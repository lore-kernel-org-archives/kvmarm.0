Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0A9C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:45:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB9C161241
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:45:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB9C161241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3C84B104;
	Thu, 23 Sep 2021 07:45:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6r5Rol7k3EKc; Thu, 23 Sep 2021 07:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E694B10A;
	Thu, 23 Sep 2021 07:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0464B101
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uuDEDRmuOznZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 07:45:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3044406E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:45:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B973106F;
 Thu, 23 Sep 2021 04:45:11 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.17.13])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E915E3F59C;
 Thu, 23 Sep 2021 04:45:09 -0700 (PDT)
Date: Thu, 23 Sep 2021 12:45:06 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/5] arm64: Prevent kexec and hibernation if
 is_protected_kvm_enabled()
Message-ID: <20210923114506.GB14893@C02TD0UTHF1T.local>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-2-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210923112256.15767-2-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Sep 23, 2021 at 12:22:52PM +0100, Will Deacon wrote:
> When pKVM is enabled, the hypervisor code at EL2 and its data structures
> are inaccessible to the host kernel and cannot be torn down or replaced
> as this would defeat the integrity properies which pKVM aims to provide.
> Furthermore, the ABI between the host and EL2 is flexible and private to
> whatever the current implementation of KVM requires and so booting a new
> kernel with an old EL2 component is very likely to end in disaster.
> 
> In preparation for uninstalling the hyp stub calls which are relied upon
> to reset EL2, disable kexec and hibernation in the host when protected
> KVM is enabled.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kernel/smp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 6f6ff072acbd..44369b99a57e 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -1128,5 +1128,6 @@ bool cpus_are_stuck_in_kernel(void)
>  {
>  	bool smp_spin_tables = (num_possible_cpus() > 1 && !have_cpu_die());
>  
> -	return !!cpus_stuck_in_kernel || smp_spin_tables;
> +	return !!cpus_stuck_in_kernel || smp_spin_tables ||
> +		is_protected_kvm_enabled();
>  }

IIUC you'll also need to do something to prevent kdump, since even with
CPUs stuck in the kernel that will try to do a kexec on the crashed CPU
and __cpu_soft_restart() won't be able to return to EL2.

You could fiddle with the BUG_ON() in machine_kexec() to die in this
case too.

Thanks,
Mark.

> -- 
> 2.33.0.464.g1972c5931b-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
