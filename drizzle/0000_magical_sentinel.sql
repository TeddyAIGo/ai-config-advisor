CREATE TABLE `assessment_answers` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text NOT NULL,
	`question` text NOT NULL,
	`answer` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_answers_question` ON `assessment_answers` (`assessment_id`,`question`);--> statement-breakpoint
CREATE TABLE `assessments` (
	`id` text PRIMARY KEY NOT NULL,
	`owner_hash` text NOT NULL,
	`user_id` text,
	`email` text,
	`name` text,
	`country_code` text,
	`country_name` text,
	`status` text NOT NULL,
	`classification` text,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_assessments_user` ON `assessments` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_assessments_status` ON `assessments` (`status`);--> statement-breakpoint
CREATE TABLE `email_events` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text,
	`recipient` text NOT NULL,
	`kind` text NOT NULL,
	`subject` text NOT NULL,
	`html` text NOT NULL,
	`status` text NOT NULL,
	`provider_id` text,
	`created_at` text NOT NULL,
	`sent_at` text,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_email_assessment` ON `email_events` (`assessment_id`);--> statement-breakpoint
CREATE TABLE `funnel_events` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text,
	`event` text NOT NULL,
	`detail` text,
	`created_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_funnel_assessment` ON `funnel_events` (`assessment_id`);--> statement-breakpoint
CREATE INDEX `idx_funnel_event` ON `funnel_events` (`event`);--> statement-breakpoint
CREATE TABLE `rate_limits` (
	`key` text PRIMARY KEY NOT NULL,
	`count` integer NOT NULL,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `product_recommendations` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text NOT NULL,
	`product_id` text NOT NULL,
	`reason` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_product_match` ON `product_recommendations` (`assessment_id`,`product_id`);--> statement-breakpoint
CREATE TABLE `products` (
	`product_id` text PRIMARY KEY NOT NULL,
	`brand` text NOT NULL,
	`product_name` text NOT NULL,
	`category` text NOT NULL,
	`capacity` integer NOT NULL,
	`interface` text NOT NULL,
	`specifications` text NOT NULL,
	`compatibility` text NOT NULL,
	`country` text NOT NULL,
	`price` integer NOT NULL,
	`currency` text NOT NULL,
	`inventory_status` text NOT NULL,
	`purchase_url` text NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_products_country` ON `products` (`country`);--> statement-breakpoint
CREATE TABLE `recommendations` (
	`assessment_id` text PRIMARY KEY NOT NULL,
	`baseline` text NOT NULL,
	`draft` text NOT NULL,
	`approved` text,
	`revision` integer DEFAULT 1 NOT NULL,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `admin_reviews` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text NOT NULL,
	`admin` text NOT NULL,
	`action` text NOT NULL,
	`notes` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_reviews_assessment` ON `admin_reviews` (`assessment_id`);--> statement-breakpoint
CREATE TABLE `recommendation_revisions` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text NOT NULL,
	`content` text NOT NULL,
	`author` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_revisions_assessment` ON `recommendation_revisions` (`assessment_id`);--> statement-breakpoint
CREATE TABLE `sessions` (
	`token_hash` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`expires_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`email` text NOT NULL,
	`name` text NOT NULL,
	`country_code` text NOT NULL,
	`country_name` text NOT NULL,
	`role` text DEFAULT 'user' NOT NULL,
	`created_at` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);--> statement-breakpoint
CREATE TABLE `email_verification` (
	`id` text PRIMARY KEY NOT NULL,
	`assessment_id` text,
	`email` text NOT NULL,
	`code_hash` text NOT NULL,
	`attempts` integer DEFAULT 0 NOT NULL,
	`expires_at` integer NOT NULL,
	`consumed_at` text,
	`created_at` text NOT NULL,
	FOREIGN KEY (`assessment_id`) REFERENCES `assessments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_verification_email` ON `email_verification` (`email`);