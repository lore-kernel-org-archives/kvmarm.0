Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA68CA9EB9
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 16:51:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC76221906
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 16:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC76221906
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9224A94F;
	Wed, 23 Oct 2019 12:51:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yWMHFX3Doma4; Wed, 23 Oct 2019 12:51:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D9134A950;
	Wed, 23 Oct 2019 12:51:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2ED4A945
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 12:51:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXt0DbWnSVxG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Oct 2019 12:51:22 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A4444A8D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 12:51:22 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iNJqs-0006Um-Q5; Wed, 23 Oct 2019 18:51:14 +0200
To: Mao Wenan <maowenan@huawei.com>, <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: Select =?UTF-8?Q?SCHED=5FINFO=20before=20?=
 =?UTF-8?Q?SCHEDSTATS?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 23 Oct 2019 17:51:14 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191023032254.159510-1-maowenan@huawei.com>
References: <20191023032254.159510-1-maowenan@huawei.com>
Message-ID: <26ee413334937b9530bc8f033fe378ec@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: maowenan@huawei.com, steven.price@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2019-10-23 04:22, Mao Wenan wrote:
> If KVM=y, it will select SCHEDSTATS, below erros can
> be seen:
> kernel/sched/stats.h: In function rq_sched_info_arrive:
> kernel/sched/stats.h:12:20: error: struct sched_info
> has no member named run_delay
>    rq->rq_sched_info.run_delay += delta;
>                     ^
> kernel/sched/stats.h:13:20: error: struct sched_info
> has no member named pcount
>    rq->rq_sched_info.pcount++;
>                     ^
> kernel/sched/stats.h: In function rq_sched_info_dequeued:
> kernel/sched/stats.h:31:20: error: struct sched_info has
> no member named run_delay
>    rq->rq_sched_info.run_delay += delta;
>
> These are because CONFIG_SCHED_INFO is not set, This patch
> is to select SCHED_INFO before SCHEDSTATS.
>
> Fixes: 8564d6372a7d ("KVM: arm64: Support stolen time reporting via
> shared structure")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  arch/arm64/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index d8b88e4..3c46eac 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -39,6 +39,7 @@ config KVM
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> +	select SCHED_INFO
>  	select SCHEDSTATS
>  	---help---
>  	  Support hosting virtualized guest machines.

SCHEDSTATS is really an odd choice. Here's what I get after disabling
DEBUG_KERNEL (from defconfig):

WARNING: unmet direct dependencies detected for SCHEDSTATS
   Depends on [n]: DEBUG_KERNEL [=n] && PROC_FS [=y]
   Selected by [y]:
   - KVM [=y] && VIRTUALIZATION [=y] && OF [=y]

WARNING: unmet direct dependencies detected for SCHEDSTATS
   Depends on [n]: DEBUG_KERNEL [=n] && PROC_FS [=y]
   Selected by [y]:
   - KVM [=y] && VIRTUALIZATION [=y] && OF [=y]

WARNING: unmet direct dependencies detected for SCHEDSTATS
   Depends on [n]: DEBUG_KERNEL [=n] && PROC_FS [=y]
   Selected by [y]:
   - KVM [=y] && VIRTUALIZATION [=y] && OF [=y]

So clearly SCHEDSTATS isn't meant to be selected on its own.

We can either just select SCHED_INFO (which *nobody else does*), or go
the full x86 way which selects TASK_DELAY_ACCT (and thus depends on
NET && MULTIUSER). My gut feeling is that we shouldn't deviate too much
from x86...

Thoughts?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
