Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C226A42B31A
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950012; cv=none; b=PK2E+OnhAawHmL1gSwqD0/vOlQW7uTivjFmj6uGZEbPCU1TVVFQiPxvb9ncgYKR8OTgrDL8k0l5ydVVu9/3UHVqVuXL50jZYJXB6vpgthAIwTsjWC9tpTI7a1YGUmOib8WGrH96vgzku5ncmKH6vgFggOEWpWQPBiEbC8DcPQs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950012; c=relaxed/simple;
	bh=tYdnk5tOol8WIKi8pkZkTGVW7gBF7nYaJSJwdchDpho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=a0k5IkenSMWlpn9ZzdZt8k3sAY0E7UJeKQsbSKgeyNmTkgLCWd1QbqOAUy42OYF8VIg7+go4K76I5fiSmVEqTatmRgrREhQEXc217IIoVxDiCP87wiF4fVTVnS2N2YiXTLJh7Oj01WWcy6PpiIToizwbdK02AWqetCSIdjssVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rNZaFRIT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rNZaFRIT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAACE1576;
	Mon, 13 Jul 2026 06:39:57 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A04893F7B4;
	Mon, 13 Jul 2026 06:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783950002; bh=tYdnk5tOol8WIKi8pkZkTGVW7gBF7nYaJSJwdchDpho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNZaFRIT1qi7sKMWL/4vX26ID86qj9I5keyv2oPWOoNmc1ELLz0eGK0r8QiT99T8S
	 6orp+qFLlTvso7UdM5nzJ6DoGnttSaxp2q3q3sGuSFFhPqKNYr1WIX/4utf/5arI80
	 +muK+heFN5qvzbYZ54JJU71xYU8YPvxVKsKqiyGI=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management
Date: Mon, 13 Jul 2026 14:39:55 +0100
Message-ID: <alTqqxEZLuYN-gY6@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709104026.2612599-5-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-5-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 06:40:24PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Add HDBSS (Hardware Dirty Bit State Structure) per-vCPU buffer
> management including allocation, freeing, and loading of HDBSS
> registers during vCPU load.
> 
> This patch creates the foundational infrastructure:
> - struct vcpu_hdbss_state and enable_hdbss/hdbss_order in kvm_arch
> - kvm_dirty_bit.h header with alloc/free declarations
> - dirty_bit.c with alloc/free helpers
> - __load_hdbss() in VHE switch for register loading
> - vCPU create/destroy hooks for buffer lifecycle
> - sysreg definitions for HDBSS register manipulation
> - Makefile update for dirty_bit.o
> 
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_dirty_bit.h | 16 ++++++++
>  arch/arm64/include/asm/kvm_host.h      | 13 +++++++
>  arch/arm64/include/asm/sysreg.h        | 11 ++++++
>  arch/arm64/kvm/Makefile                |  1 +
>  arch/arm64/kvm/arm.c                   |  7 ++++
>  arch/arm64/kvm/dirty_bit.c             | 52 ++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c        | 15 ++++++++
>  arch/arm64/kvm/mmu.c                   |  1 +
>  arch/arm64/kvm/reset.c                 |  4 ++
>  9 files changed, 120 insertions(+)
>  create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
>  create mode 100644 arch/arm64/kvm/dirty_bit.c
> 
> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> new file mode 100644
> index 000000000000..84b12f0a10af
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + * Author: Leonardo Bras <leo.bras@arm.com>

You are adding the file, so the copyright note should be yours, then?

> + */
> +
> +#ifndef __ARM64_KVM_DIRTY_BIT_H__
> +#define __ARM64_KVM_DIRTY_BIT_H__
> +
> +#include <asm/kvm_pgtable.h>
> +#include <asm/sysreg.h>
> +
> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> +
> +#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5..c41ec6d9c45a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -420,6 +420,10 @@ struct kvm_arch {
>  	 */
>  	struct kvm_protected_vm pkvm;
> 
> +	/* HDBSS: per-VM dirty tracking state */
> +	bool enable_hdbss;

Is there not a way of checking hdbss without adding this new member on the 
struct? Would not checking the vcpu_hdbss_state from current vcpu should be 
enough?

> +	unsigned int hdbss_order;

Is that the order for hdbss buffer size?
Haven't finished reading the series, but would that be bad if this was also 
in the per-vcpu state struct, instead?

Also, here I suggest that we save a number, instead of the encoding for 
HDBSSBR_ELS_SZ, and convert it on hdbss setup. It could be either a 
shift, or size.

Reason being that you used this to compare with HDBSS_MAX_ORDER at some 
point, and there is no guarantee that the encoding will always be in 
crescent form.

Also, it's not clear where you set this value.
 
> +
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  	/* Nested virtualization info */
>  	struct dentry *debugfs_nv_dentry;
> @@ -838,6 +842,12 @@ struct vcpu_reset_state {
>  	bool		reset;
>  };
> 
> +struct vcpu_hdbss_state {
> +	phys_addr_t base_phys;   /* for memory free */
> +	u64 hdbssbr_el2;         /* load directly */
> +	u64 hdbssprod_el2;       /* save directly */
> +};
> +
>  struct vncr_tlb;
> 
>  struct kvm_vcpu_arch {
> @@ -945,6 +955,9 @@ struct kvm_vcpu_arch {
> 
>  	/* Hyp-readable copy of kvm_vcpu::pid */
>  	pid_t pid;
> +
> +	/* HDBSS registers info */
> +	struct vcpu_hdbss_state hdbss;/
>  };
> 
>  /*
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7aa08d59d494..1354a58c3316 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1039,6 +1039,17 @@
> 
>  #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>  					       GCS_CAP_VALID_TOKEN)
> +
> +/*
> + * Definitions for the HDBSS feature
> + */
> +#define HDBSS_MAX_ORDER		HDBSSBR_EL2_SZ_2MB
> +

See above comment on using the encoding instead of an actual size/shift 
number.

> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & HDBSSBR_EL2_BADDR_MASK) | \
> +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
> +
> +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
> +
>  /*
>   * Definitions for GICv5 instructions
>   */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 59612d2f277c..ec2749af64fa 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -18,6 +18,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
>  	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
>  	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
> +	 dirty_bit.o \
>  	 vgic/vgic.o vgic/vgic-init.o \
>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>  	 vgic/vgic-v3.o vgic/vgic-v4.o \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be8..bf6688245d83 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -38,6 +38,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_dirty_bit.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_nested.h>
>  #include <asm/kvm_pkvm.h>
> @@ -565,6 +566,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (err)
>  		kvm_vgic_vcpu_destroy(vcpu);
> 
> +	if (vcpu->kvm->arch.enable_hdbss) {
> +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
> +		if (err)
> +			kvm_vgic_vcpu_destroy(vcpu);
> +	}
> +
>  	return err;
>  }
> 
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> new file mode 100644
> index 000000000000..6c7a6ef66b5a
> --- /dev/null
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + * Author: Leonardo Bras <leo.bras@arm.com>
> + */
> +
> +#include <asm/kvm_dirty_bit.h>
> +#include <asm/kvm_mmu.h>
> +#include <asm/sysreg.h>
> +#include <linux/gfp.h>
> +#include <linux/kconfig.h>
> +#include <linux/mm.h>
> +
> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order)
> +{
> +	struct page *hdbss_pg = NULL;
> +
> +	if (vcpu->arch.hdbss.hdbssbr_el2 || !system_supports_hdbss())
> +		return 0;
> +
> +	if (order > HDBSS_MAX_ORDER)
> +		return -EINVAL;
> +
> +	hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, order);
> +	if (!hdbss_pg)
> +		return -ENOMEM;
> +
> +	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +		.base_phys = page_to_phys(hdbss_pg),
> +		.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), order),
> +		.hdbssprod_el2 = 0,
> +	};
> +
> +	return 0;
> +}
> +
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct page *hdbss_pg;
> +
> +	if (!vcpu->arch.hdbss.hdbssbr_el2) {
> +		return;
> +	}
> +
> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
> +	if (hdbss_pg)
> +		__free_pages(hdbss_pg,
> +		     FIELD_GET(HDBSSBR_EL2_SZ_MASK,
> +			       vcpu->arch.hdbss.hdbssbr_el2));
> +
> +	vcpu->arch.hdbss.hdbssbr_el2 = 0;
> +}
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index bbe9cebd3d9d..fe72944bfd3d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_dirty_bit.h>
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/processor.h>
> @@ -213,6 +214,19 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
>  	local_irq_restore(flags);
>  }
> 
> +static void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
> +	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
> +
> +	isb();
> +}
> +
>  void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  {
>  	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
> @@ -220,6 +234,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  	__vcpu_load_switch_sysregs(vcpu);
>  	__vcpu_load_activate_traps(vcpu);
>  	__load_stage2(vcpu->arch.hw_mmu);
> +	__load_hdbss(vcpu);
>  }
> 
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 346efed6e605..83251d95bf3f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -16,6 +16,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_dirty_bit.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_asm.h>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b963fd975aac..d8104bcbd9ff 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -27,6 +27,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_dirty_bit.h>
>  #include <asm/kvm_nested.h>
>  #include <asm/virt.h>
> 
> @@ -161,6 +162,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>  	kfree(vcpu->arch.vncr_tlb);
>  	kfree(vcpu->arch.ccsidr);
> +
> +	if (vcpu->kvm->arch.enable_hdbss)
> +		kvm_arm_vcpu_free_hdbss(vcpu);
>  }
> 
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> --
> 2.33.0
> 
