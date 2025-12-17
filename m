Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D036C0CA
	for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978797; cv=none; b=jSGgdWbP+23erHjG0LFwY7pNE/s5SPJvNhC+GIsVAEwrL4mDsb0B6k/xpK1PE3YQcMO6Dnbxl5RYV/n0kVfVRCjQ2babrr+AEplDku/cRW5o8IRAQebAQvsx0VSMierHAh61ywW7uPQoYyQWEx21N8CMBvIR7N5ZEsgdWBbV4Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978797; c=relaxed/simple;
	bh=Y8HwpCJLp5JuXwZzLKV+3HBK3WSOBZDnT2hxF952di4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRQM/AMkQLkR3Z+GF8GnrHFKOFHIQe92ZWnsKRbCM0EEWDZi1s6zKa84C67cV4OlQ8FVAxT6+3i9O9GRqlVvfYxBzYIUV4kWw1y57IBmvyGg9Dkqch8uQrjjt3ac1KWc25RgXeRLNTFCUjf8r+VAc2NTuTOnQtGlORvIts4U6C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lL7HmRyW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lL7HmRyW"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c902f6845so4343052a91.2
        for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 05:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765978794; x=1766583594; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6pIj46nVvtUq+4eec5aThnrTEmEGNk5gVfAEDmgIrpg=;
        b=lL7HmRyWAjijoUQn1j9fTKPPzMCbsaREP3VnbdELn2MgnOc933qH3MF4WFA1qJ95RC
         jvfL6ZgmGN0gkZ4lUU2viarwE6+9IXdfHeDk83eObnwhb6J+lCfZkJLLvwWYOKnIMxos
         eYU4rhHU+2p4F2euPGDbUyEZwfrqgJJKvONSWOh/irDo+vCXwMeNx4IxZDCcnZjXijWR
         b049+V9H1r195xwwmkFuTjEbbYzQWjKTarnrGYdrGsk5tobC2SFX84gJljtApyrwUpgE
         HrJBD7nAKNx7izKyol95nbuaqg4pgr1npCtMqUF79xGPe7MKvbRc5ywx42zFTQ7c6lws
         qTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765978794; x=1766583594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6pIj46nVvtUq+4eec5aThnrTEmEGNk5gVfAEDmgIrpg=;
        b=WfsD9LSn9wSscmK7W9DIKcxEK4+gA6p1cAkPxUBc1TJrewD2OznYl8S9Dl9W/afvYI
         pj2n10tp97wbb51NZv93CeEK9JOOqPLx/efZYim/owNh7cizw2Phzm0Kjtn71yLnKYbk
         BrTXc8sFufTnO80V+mPyXpoJHI6hZ/X9NHWdpukxvgKL1Vd0bD3BkIckOF3vBvmCuCpz
         noxZcBR7iixpRb7qokQ5Sh6T8vO4m+peSl7+EGI00/cpH/6BegFfbAWRtafbiSPoovfy
         kVZ3/Hmx+IxPH+akAZZU0R4kPQs51UhepRu5IdP4t+Bijk7so/CWywq6WnGm/sDPBvyU
         56lA==
X-Forwarded-Encrypted: i=1; AJvYcCW0lq3IbVVMTs1Pyoz5Z25DEDKSFMAyBUuxtH1Kl3ni+QwJv4c/3AWKCfcas0EWIQlJkg7dKZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPu90zXiYfqkAY6Vf260kLFiJow9baFbTL8g9jK7OHF7vSX0Yr
	pMnAMFOKaJby7VJuVzSNBOakdTbbHgNuY16/1cmRALgzcY8kAq2UNPXh
X-Gm-Gg: AY/fxX4j5Az5nuTdVBpoxK3fdTmSHukZXiIatcQLOc35R+7JhfZ1VCbvDZTlXmcAj52
	1WVXTYueKz63dxgE19BA2+eEfjtri94cdRaXmO0dcJDzgRAkvW+N3NOqxU2NS5BEvCtW1sduw2w
	vZVpWD4nMD8fEa4ZjM+PfhPB9IutjBq3QKoLu2psQUuwNUSnTXVdxW1OhywB42aFRk+yDnSQWy0
	Mf1cjB13ExSSe8GzKmCHdkn06EWcY6e1WvbAbmSAnyDx76yT7Tb9/VUuot2or5pz0+DxkeVD59n
	wNvCYrMGCzly8Y3aneSFaKJMbSYEhx9m5JUVpveZaOdwVP/Itc+VfcwteMZvxPre2wbq4wg7eH/
	pT83t1OGL1+Of7OFyVN2Scv935SlRRaIkxc0+nJrdmRMseLeKvthVaaXYgZDCxxjf1RqeJeEQ12
	s3G1A6SEASolTb5+VGseKeRwDQutM/duZID62oYspSyWZDT6iSFluwvMgL3Iy0Cj1l1oVVycEjJ
	gyQGQwrM6nr6ueentWhKdsAFUA=
X-Google-Smtp-Source: AGHT+IG3LzjynQX7X4H7S9Io3Ynamjd2a9PPbU+36SGNDnZcAgiWppcnGVLBSdjNiAVnsvjUFOBbeQ==
X-Received: by 2002:a17:90b:2ccf:b0:340:cb18:922 with SMTP id 98e67ed59e1d1-34abd71f7e6mr16889624a91.14.1765978794294;
        Wed, 17 Dec 2025 05:39:54 -0800 (PST)
Received: from [172.27.236.53] (ec2-13-250-3-147.ap-southeast-1.compute.amazonaws.com. [13.250.3.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c25b7d59dsm18602604a12.6.2025.12.17.05.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 05:39:53 -0800 (PST)
Message-ID: <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
Date: Wed, 17 Dec 2025 21:39:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Tian Zheng <zhengtian10@huawei.com>, maz@kernel.org,
 oliver.upton@linux.dev, catalin.marinas@arm.com, corbet@lwn.net,
 pbonzini@redhat.com, will@kernel.org
Cc: linux-kernel@vger.kernel.org, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, yezhenyu2@huawei.com, xiexiangyou@huawei.com,
 zhengchuan@huawei.com, linuxarm@huawei.com, joey.gouly@arm.com,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 suzuki.poulose@arm.com
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-5-zhengtian10@huawei.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20251121092342.3393318-5-zhengtian10@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/2025 5:23 PM, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Implement the HDBSS enable/disable functionality using the
> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.
> 
> Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
> at the start of live migration, configuring the buffer size.
> The feature is disabled by invoking the ioctl again with size
> set to 0 once migration completes.
> 
> Add support for updating the dirty bitmap based on the HDBSS
> buffer. Similar to the x86 PML implementation, KVM flushes the
> buffer on all VM-Exits, so running vCPUs only need to be kicked
> to force a VM-Exit.
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  10 +++
>   arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
>   arch/arm64/kvm/arm.c              | 107 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
>   arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
>   arch/arm64/kvm/mmu.c              |  10 +++
>   arch/arm64/kvm/reset.c            |   3 +
>   include/linux/kvm_host.h          |   1 +
>   8 files changed, 194 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d962932f0e5f..408e4c2b3d1a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
>   u32 __attribute_const__ kvm_target_cpu(void);
>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> 
>   struct kvm_hyp_memcache {
>   	phys_addr_t head;
> @@ -793,6 +794,12 @@ struct vcpu_reset_state {
>   	bool		reset;
>   };
> 
> +struct vcpu_hdbss_state {
> +	phys_addr_t base_phys;
> +	u32 size;
> +	u32 next_index;
> +};
> +
>   struct vncr_tlb;
> 
>   struct kvm_vcpu_arch {
> @@ -897,6 +904,9 @@ struct kvm_vcpu_arch {
> 
>   	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>   	struct vncr_tlb	*vncr_tlb;
> +
> +	/* HDBSS registers info */
> +	struct vcpu_hdbss_state hdbss;
>   };
> 
>   /*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e4069f2ce642..6ace1080aed5 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -331,6 +331,23 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
>   	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>   }
> 
> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 br_el2, prod_el2;
> +
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +	prod_el2 = vcpu->arch.hdbss.next_index;
> +
> +	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
> +	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
> +
> +	isb();
> +}
> +
>   static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>   {
>   	return container_of(mmu->arch, struct kvm, arch);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 870953b4a8a7..64f65e3c2a89 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>   }
> 
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct page *hdbss_pg = NULL;
> +
> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
> +	if (hdbss_pg)
> +		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
> +
> +	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +		.base_phys = 0,
> +		.size = 0,
> +		.next_index = 0,
> +	};
> +}
> +
> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
> +				    struct kvm_enable_cap *cap)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +	struct page *hdbss_pg = NULL;
> +	int size = cap->args[0];
> +	int ret = 0;
> +
> +	if (!system_supports_hdbss()) {
> +		kvm_err("This system does not support HDBSS!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (size < 0 || size > HDBSS_MAX_SIZE) {
> +		kvm_err("Invalid HDBSS buffer size: %d!\n", size);
> +		return -EINVAL;
> +	}
> +

I think you should check if it's already enabled here. What if user space calls 
this twice?

> +	/* Enable the HDBSS feature if size > 0, otherwise disable it. */
> +	if (size) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
> +			if (!hdbss_pg) {
> +				kvm_err("Alloc HDBSS buffer failed!\n");
> +				ret = -ENOMEM;
> +				goto error_alloc;
> +			}
> +
> +			vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +				.base_phys = page_to_phys(hdbss_pg),
> +				.size = size,
> +				.next_index = 0,
> +			};
> +		}
> +
> +		kvm->enable_hdbss = true;
> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;

VTCR_EL2_HA is also a necessity for VTCR_EL2_HDBSS to take effect.

> +
> +		/*
> +		 * We should kick vcpus out of guest mode here to load new
> +		 * vtcr value to vtcr_el2 register when re-enter guest mode.
> +		 */
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			kvm_vcpu_kick(vcpu);
> +	} else if (kvm->enable_hdbss) {
> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			/* Kick vcpus to flush hdbss buffer. */
> +			kvm_vcpu_kick(vcpu);
> +
> +			kvm_arm_vcpu_free_hdbss(vcpu);
> +		}
> +
> +		kvm->enable_hdbss = false;
> +	}
> +
> +	return ret;
> +
> +error_alloc:
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu->arch.hdbss.base_phys && !vcpu->arch.hdbss.size)
> +			continue;
> +
> +		kvm_arm_vcpu_free_hdbss(vcpu);
> +	}
> +
> +	return ret;
> +}
> +
>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			    struct kvm_enable_cap *cap)
>   {
> @@ -132,6 +218,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		mutex_lock(&kvm->lock);
> +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -420,6 +511,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   			r = kvm_supports_cacheable_pfnmap();
>   		break;
> 
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		r = system_supports_hdbss();
> +		break;
>   	default:
>   		r = 0;
>   	}
> @@ -1837,7 +1931,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 
>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   {
> +	/*
> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> +	 * before reporting dirty_bitmap to userspace.  KVM flushes the buffers
> +	 * on all VM-Exits, thus we only need to kick running vCPUs to force a
> +	 * VM-Exit.
> +	 */
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> 
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_kick(vcpu);
>   }
> 
>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cc7d5d1709cb..9ba0ea6305ef 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -412,6 +412,49 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>   	return arm_exit_handlers[esr_ec];
>   }
> 
> +static void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 br_el2;
> +
> +	if (!kvm->enable_hdbss)
> +		return;
> +
> +	dsb(sy);
> +	isb();
> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +
> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> +	if (curr_idx == 0 || br_el2 == 0)
> +		return;
> +
> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> +	if (!hdbss_buf) {
> +		kvm_err("Enter flush hdbss buffer with buffer == NULL!");
> +		return;
> +	}
> +
> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> +	for (idx = 0; idx < curr_idx; idx++) {
> +		u64 gpa;
> +
> +		gpa = hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &= HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> +	}
> +
> +	/* reset HDBSS index */
> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.next_index = 0;
> +	isb();
> +}
> +
>   /*
>    * We may be single-stepping an emulated instruction. If the emulation
>    * has been completed in the kernel, we can return to userspace with a
> @@ -447,6 +490,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>   {
>   	struct kvm_run *run = vcpu->run;
> 
> +	kvm_flush_hdbss_buffer(vcpu);
> +
>   	if (ARM_SERROR_PENDING(exception_index)) {
>   		/*
>   		 * The SError is handled by handle_exit_early(). If the guest
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9984c492305a..3787c9c5810d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -220,6 +220,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>   	__vcpu_load_switch_sysregs(vcpu);
>   	__vcpu_load_activate_traps(vcpu);
>   	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
> +	__load_hdbss(vcpu);
>   }
> 
>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7cc964af8d30..91a2f9dbb406 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1843,6 +1843,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (writable)
>   		prot |= KVM_PGTABLE_PROT_W;
> 
> +	if (writable && kvm->enable_hdbss && logging_active)
> +		prot |= KVM_PGTABLE_PROT_DBM;
> +
>   	if (exec_fault)
>   		prot |= KVM_PGTABLE_PROT_X;
> 
> @@ -1950,6 +1953,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> 
>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> 
> +	/*
> +	 * HDBSS buffer already flushed when enter handle_trap_exceptions().
> +	 * Nothing to do here.
> +	 */
> +	if (ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
> +		return 1;
> +
>   	if (esr_fsc_is_translation_fault(esr)) {
>   		/* Beyond sanitised PARange (which is the IPA limit) */
>   		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..65e8f890f863 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>   	kfree(vcpu->arch.vncr_tlb);
>   	kfree(vcpu->arch.ccsidr);
> +
> +	if (vcpu->arch.hdbss.base_phys || vcpu->arch.hdbss.size)
> +		kvm_arm_vcpu_free_hdbss(vcpu);
>   }
> 
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5bd76cf394fa..aa8138604b1e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -876,6 +876,7 @@ struct kvm {
>   	struct xarray mem_attr_array;
>   #endif
>   	char stats_id[KVM_STATS_NAME_SIZE];
> +	bool enable_hdbss;
>   };
> 
>   #define kvm_err(fmt, ...) \
> --
> 2.33.0
> 
> 

