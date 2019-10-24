Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A37C47E49
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 13:19:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E57112084C
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 13:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E57112084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5913F4A659;
	Thu, 24 Oct 2019 09:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pb8xfh2P4cjl; Thu, 24 Oct 2019 09:19:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4964E4A65E;
	Thu, 24 Oct 2019 09:19:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D574A659
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 09:19:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sI6qWoM3HClF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 09:19:17 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68E124A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 09:19:17 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iNd1A-0000Sw-Ge; Thu, 24 Oct 2019 15:19:08 +0200
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: Select =?UTF-8?Q?SCHED=5FINFO=20before=20?=
 =?UTF-8?Q?SCHEDSTATS?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Thu, 24 Oct 2019 14:19:08 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <6d037fa1-5e8b-38cd-e947-7547c1e8dd15@arm.com>
References: <20191023032254.159510-1-maowenan@huawei.com>
 <26ee413334937b9530bc8f033fe378ec@www.loen.fr>
 <6d037fa1-5e8b-38cd-e947-7547c1e8dd15@arm.com>
Message-ID: <3abfc893613caf529b0f6a933e74068d@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, maowenan@huawei.com,
 catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 Mao Wenan <maowenan@huawei.com>, linux-kernel@vger.kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-10-24 12:22, Steven Price wrote:

[...]

> From 915893f5c57241cc29d90769b3f720a6135277d7 Mon Sep 17 00:00:00 
> 2001
> From: Steven Price <steven.price@arm.com>
> Date: Thu, 24 Oct 2019 12:14:36 +0100
> Subject: [PATCH] KVM: arm64: Select TASK_DELAY_ACCT rather than 
> SCHEDSTATS
>
> SCHEDSTATS requires DEBUG_KERNEL (and PROC_FS) and therefore isn't a
> good choice for enabling the scheduling statistics required for 
> stolen
> time.
>
> Instead match the x86 configuration and select TASK_DELAY_ACCT. This
> adds the dependencies of NET && MULTIUSER for arm64 KVM.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Fixes: 8564d6372a7d ("KVM: arm64: Support stolen time reporting via
> shared structure")
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index d8b88e40d223..1ffb300e2d92 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -21,6 +21,8 @@ if VIRTUALIZATION
>  config KVM
>  	bool "Kernel-based Virtual Machine (KVM) support"
>  	depends on OF
> +	# for TASKSTATS/TASK_DELAY_ACCT:
> +	depends on NET && MULTIUSER
>  	select MMU_NOTIFIER
>  	select PREEMPT_NOTIFIERS
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
> @@ -39,7 +41,7 @@ config KVM
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> -	select SCHEDSTATS
> +	select TASK_DELAY_ACCT
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the 
> multiple

Same issue as before: you have an implicit config symbol selection.
TASK_DELAY_ACCT depends on TASKSTATS (which is why you have this NET &&
MULTIUSER constraint).

You need to select both TASK_DELAY_ACCT and TASKSTATS, as the comment 
you
add suggests.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
