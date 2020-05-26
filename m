Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BB9C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 10:52:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0895120776
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 10:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0895120776
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACEB4B2B4;
	Tue, 26 May 2020 06:52:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pdGEiboK7Jjv; Tue, 26 May 2020 06:52:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F48F4B211;
	Tue, 26 May 2020 06:52:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E25A4B209
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 06:52:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gKNQHIcgsQrd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 06:52:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EF874B1C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 06:52:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B3FC31B;
 Tue, 26 May 2020 03:52:00 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 047543F6C4;
 Tue, 26 May 2020 03:51:56 -0700 (PDT)
Date: Tue, 26 May 2020 11:51:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFCv2 4/9] kvm/arm64: Detach ESR operator from vCPU struct
Message-ID: <20200526105154.GD1363@C02TD0UTHF1T.local>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-5-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200508032919.52147-5-gshan@redhat.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, May 08, 2020 at 01:29:14PM +1000, Gavin Shan wrote:
> There are a set of inline functions defined in kvm_emulate.h. Those
> functions reads ESR from vCPU fault information struct and then operate
> on it. So it's tied with vCPU fault information and vCPU struct. It
> limits their usage scope.
> 
> This detaches these functions from the vCPU struct. With this, the
> caller has flexibility on where the ESR is read. It shouldn't cause
> any functional changes.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h     | 83 +++++++++++-------------
>  arch/arm64/kvm/handle_exit.c             | 20 ++++--
>  arch/arm64/kvm/hyp/switch.c              | 24 ++++---
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  7 +-
>  arch/arm64/kvm/inject_fault.c            |  4 +-
>  arch/arm64/kvm/sys_regs.c                | 12 ++--
>  virt/kvm/arm/arm.c                       |  4 +-
>  virt/kvm/arm/hyp/aarch32.c               |  2 +-
>  virt/kvm/arm/hyp/vgic-v3-sr.c            |  5 +-
>  virt/kvm/arm/mmio.c                      | 27 ++++----
>  virt/kvm/arm/mmu.c                       | 22 ++++---
>  11 files changed, 112 insertions(+), 98 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index bd1a69e7c104..2873bf6dc85e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -270,10 +270,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>  	return vcpu->arch.fault.esr_el2;
>  }
>  
> -static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> +static __always_inline int kvm_vcpu_get_condition(u32 esr)

Given the `vcpu` argument has been removed, it's odd to keep `vcpu` in the
name, rather than `esr`.

e.g. this would make more sense as something like esr_get_condition().

... and if we did something like that, we could move most of the
extraction functions into <asm/esr.h>, and share them with non-KVM code.

Otherwise, do you need to extract all of these for your use-case, or do
you only need a few of the helpers? If you only need a few, it might be
better to only factor those out for now, and keep the existing API in
place with wrappers, e.g. have:

| esr_get_condition(u32 esr) {
| 	... 
| }
| 
| kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
| {
| 	return esr_get_condition(kvm_vcpu_get_esr(vcpu));
| }

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
