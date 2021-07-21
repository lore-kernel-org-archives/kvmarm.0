Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7596AC636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:06:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF90D61249
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF90D61249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71DA04B0DB;
	Wed, 21 Jul 2021 12:06:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c3qSwFnQWuay; Wed, 21 Jul 2021 12:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70DEA4B0E4;
	Wed, 21 Jul 2021 12:06:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2E94B0D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:06:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4+WC27n9PB6S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:06:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C92DF4A522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:06:20 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12C061009;
 Wed, 21 Jul 2021 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626883579;
 bh=jFGg/EUoFFDeElbsqd3XeBtL8WBcmWuSIesI5JRpX/I=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AqJbLMlGvsJ7Pp4AP0n4iw/SiwiUoudllglRPtqA2qlSRRRu3pZrA6TqryBk+5CvN
 F6Mm6/jZ48eixJcgXX8iNqAQzJbjKKzXLMmKD2oF071IircKwGO0vyhdCH5xdZttLd
 fWDEraMW4tECn6BBRIbe4TBbJlRPlMb53bKkR7WNcT3UISf5yRpRjLMnoKC+j2l8jo
 +WkDnDr1VwnV/ifU9b5qSpBrdoj3AxXyKtn+TavPCMzc/tFujnInDoTkD4BT/DO8+x
 uKEAhZWQMHUj46xs1+++igYBrQiRt+POXC5lRcIRIWrm4HRQ05dxd1KT6PF+Fa2CnZ
 XY+TYOxzDDQsw==
Date: Wed, 21 Jul 2021 17:06:14 +0100
From: Will Deacon <will@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 2/3] kvm/arm: Introduce a new vmid allocator for KVM
Message-ID: <20210721160614.GC11003@willie-the-truck>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-3-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210616155606.2806-3-shameerali.kolothum.thodi@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: jean-philippe@linaro.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jun 16, 2021 at 04:56:05PM +0100, Shameer Kolothum wrote:
> A new VMID allocator for arm64 KVM use. This is based on
> arm64 asid allocator algorithm.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |   4 +
>  arch/arm64/kvm/vmid.c             | 206 ++++++++++++++++++++++++++++++
>  2 files changed, 210 insertions(+)
>  create mode 100644 arch/arm64/kvm/vmid.c

Generally, I prefer this to the alternative of creating a library. However,
I'd probably remove all the duplicated comments in favour of a reference
to the ASID allocator. That way, we can just comment any VMID-specific
behaviour in here.

Some comments below...

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..75a7e8071012 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -680,6 +680,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
>  int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
>  			    struct kvm_device_attr *attr);
>  
> +int kvm_arm_vmid_alloc_init(void);
> +void kvm_arm_vmid_alloc_free(void);
> +void kvm_arm_update_vmid(atomic64_t *id);
> +
>  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
>  {
>  	vcpu_arch->steal.base = GPA_INVALID;
> diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> new file mode 100644
> index 000000000000..687e18d33130
> --- /dev/null
> +++ b/arch/arm64/kvm/vmid.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * VMID allocator.
> + *
> + * Based on arch/arm64/mm/context.c
> + *
> + * Copyright (C) 2002-2003 Deep Blue Solutions Ltd, all rights reserved.
> + * Copyright (C) 2012 ARM Ltd.
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/bitops.h>
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_mmu.h>
> +
> +static u32 vmid_bits;
> +static DEFINE_RAW_SPINLOCK(cpu_vmid_lock);
> +
> +static atomic64_t vmid_generation;
> +static unsigned long *vmid_map;
> +
> +static DEFINE_PER_CPU(atomic64_t, active_vmids);
> +static DEFINE_PER_CPU(u64, reserved_vmids);
> +static cpumask_t tlb_flush_pending;
> +
> +#define VMID_MASK		(~GENMASK(vmid_bits - 1, 0))
> +#define VMID_FIRST_VERSION	(1UL << vmid_bits)
> +
> +#define NUM_USER_VMIDS		VMID_FIRST_VERSION
> +#define vmid2idx(vmid)		((vmid) & ~VMID_MASK)
> +#define idx2vmid(idx)		vmid2idx(idx)
> +
> +#define vmid_gen_match(vmid) \
> +	(!(((vmid) ^ atomic64_read(&vmid_generation)) >> vmid_bits))
> +
> +static void flush_context(void)
> +{
> +	int cpu;
> +	u64 vmid;
> +
> +	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
> +
> +	for_each_possible_cpu(cpu) {
> +		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
> +		/*
> +		 * If this CPU has already been through a
> +		 * rollover, but hasn't run another task in
> +		 * the meantime, we must preserve its reserved
> +		 * VMID, as this is the only trace we have of
> +		 * the process it is still running.
> +		 */
> +		if (vmid == 0)
> +			vmid = per_cpu(reserved_vmids, cpu);
> +		__set_bit(vmid2idx(vmid), vmid_map);
> +		per_cpu(reserved_vmids, cpu) = vmid;
> +	}

Hmm, so here we're copying the active_vmids into the reserved_vmids on a
rollover, but I wonder if that's overly pessismistic? For the ASID
allocator, every CPU tends to have a current task so it makes sense, but
I'm not sure it's necessarily the case that every CPU tends to have a
vCPU as the current task. For example, imagine you have a nasty 128-CPU
system with 8-bit VMIDs and each CPU has at some point run a vCPU. Then,
on rollover, we'll immediately reserve half of the VMID space, even if
those vCPUs don't even exist any more.

Not sure if it's worth worrying about, but I wanted to mention it.

> +void kvm_arm_update_vmid(atomic64_t *id)
> +{

Take the kvm_vmid here? That would make:

> +	/* Check that our VMID belongs to the current generation. */
> +	vmid = atomic64_read(id);
> +	if (!vmid_gen_match(vmid)) {
> +		vmid = new_vmid(id);
> +		atomic64_set(id, vmid);
> +	}

A bit more readable, as you could pass the pointer directly to new_vmid
for initialisation.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
