output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the load balancer"
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "The Zone ID of the load balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app.arn
  description = "ARN of the Target Group to attach ECS Service to"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security Group ID of the ALB"
}

output "ecs_security_group_id" {
  value       = aws_security_group.ecs_tasks.id
  description = "Security Group ID for ECS Tasks (allows traffic from ALB)"
}