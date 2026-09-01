Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1C0346A0A
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 04:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788235640; cv=none; b=b2GQ/3FIuynGHdyuvdZCmcOu69HeXkImUASqPzg3yseHwTI0l9PS5psLdGOIUbdZz1fp0z0T5mHuIbMuZyivVoS6Jidznx6LTQdJDALlrSPu0u4v1+rkNyHaQv7DsoiTEhRtOh+NjWfGRazM0UooAHN3USNHNojskhdPNT+i/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788235640; c=relaxed/simple;
	bh=O/Ubhju6/CMfMzweAqgcy04r843jfVN4o87C1rotyes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qP3q7N425fh46Y4BtuZHUJm5xJ+FVD4HhKeiFtshPTLVPVIC2owiSphm/EUBMRi0CBEjjzZKmFVMuTAY88LbvLTKhwQycplb5ML5+m8ZdzXW6onXfxCCtsvPQ1DapNybBH9QuwOKfRMbkdqLdou/N1teqbocrtf9JbAJ1ckOe54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DKfx1I0p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DKfx1I0p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788235637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hYyUlGRd8/lofFSDDasZjeN19936R0gqWjSIRl9W7sM=;
	b=DKfx1I0p1gxFzxi2Bj9aGdY5EdC3/UQ1AphTXtgy/T4e3UEcMzW61NCyNQVEhILUIMckZt
	rmaA8hCKGdBu8PHDbUSz3J8WcbZblPGLBld5/iezHW3ZSZ+CIJTTFRmsvja+i36gzAEkNf
	SMyrr3F4WGlG6UMlQk2PobiC2FrKplI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-dBZaTLKRPvenNjkcxuvEZA-1; Tue, 01 Sept 2026 00:07:16 -0400
X-MC-Unique: dBZaTLKRPvenNjkcxuvEZA-1
X-Mimecast-MFC-AGG-ID: dBZaTLKRPvenNjkcxuvEZA_1788235635
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398d292eac1so4335831a91.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 21:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788235635; x=1788840435;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hYyUlGRd8/lofFSDDasZjeN19936R0gqWjSIRl9W7sM=;
        b=Rkt7GN78nQqT+F1P1ZoNl6XFcHvAhQegbide2EjsBXBjLo86xz6S3AoUG3L7EuFMP/
         RDiEFsrzvaj2uGEUwU6fcTyMlTby3WYljaWyfPjPCkBMRE6J/MjIZnpS2BjKZkE/K1dp
         FehmxxpMmaQmTGtkgZ/x4D6dKuc2OCmhm9wiRSNEa1KGhXJ7KeaiaJBiapOzMGVbL1m6
         JqkInMaUwb+XrEW6ZIIsDcxjtfE4WHMFaTwPrBXtWpos1MLopR28yS1Evnqm64toXRnt
         I6dINyE04pecoDLN4sRz/K7S1RNXLKoJ6lomtzYMFchprlQZc3qlmSFsEUqocE4oZ5LI
         81Mg==
X-Forwarded-Encrypted: i=1; AKwUvBxxPARCidgyMDjRTQ1BRt+7Mui2pJggxllp9hOaNvUGrKEETJ+GIIgc249r0UFZTAYrfoK9+5w=@lists.linux.dev
X-Gm-Message-State: AFuF++ksARNWShWS8GpO1C8E+36QrqwdpTKKF0NrVapa6tVKNDNzP4Pm
	I5f1bnWm4knXMUkUb2a4j3nQDqsMQ3Yfd8csM1jiR8WfkXKI+Dy6eWW0x6Z2JFcDLNoZ7p8qPXz
	ElY4M9RT2drmqrCi0TpOuSQUpd8oWFfD/1oyIud3SF9TSk1i23ibE29d8kQ==
X-Gm-Gg: AYBFou01wCmqBOQ8CzVpCsibXwz198gWpLfYP1mUq/HRUFwUVJzTJEDWrDPd6ramoyy
	GCxKPbDV2x1dMsABV+wkX45A3moOfmY7dC9M/Jc9cdD9YVLraHt1d3crFVA70nrP8aMC5KZ2SmX
	H6vNI6je6TSgU4gKrzr2MdnarjJsR9i4mLAXmXYuWRM71BEn65QQGOFArw9p0ZWUdPq3r+JmJwa
	fLQ5zErE4XDWAVcVXffgLCHbdb3Cgm9yUsgJZbBGDfzYa6GTneedj7bNpvu/QhnKHZNKn6g2HHY
	9vY5OddOj9nQJcZL8+70G7KZXZaJX6JuHZYJz7kfCVGY2NKjvVh4aXKh/lxsuDPVgIsEDdvmFkI
	dgiSlbjdV2CSbWcU2G9S9keOFN1mpQBMJpU4qxHsgnQ==
X-Received: by 2002:a17:90b:1a85:b0:398:9be8:ea68 with SMTP id 98e67ed59e1d1-39907e96b11mr7101596a91.21.1788235634849;
        Mon, 31 Aug 2026 21:07:14 -0700 (PDT)
X-Received: by 2002:a17:90b:1a85:b0:398:9be8:ea68 with SMTP id 98e67ed59e1d1-39907e96b11mr7101454a91.21.1788235634155;
        Mon, 31 Aug 2026 21:07:14 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d2e465sm50184750c88.4.2026.08.31.21.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 21:07:13 -0700 (PDT)
Message-ID: <c9608c82-d4ff-4c0f-8f7b-1793ed205566@redhat.com>
Date: Tue, 1 Sep 2026 14:07:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/45] KVM: arm64: CCA: Add basic infrastructure for
 creating a realm
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-15-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260803134403.80630-15-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ORL-RAyPk6fpcgZyNzBI76YfSFNVFM9NySopOTuAEjo_1788235635
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 8/3/26 11:43 PM, Steven Price wrote:
> Introduce the skeleton functions for creating and destroying a realm.
> The IPA size requested is checked against what the RMM supports.
> 
> The actual work of constructing the realm will be added in future
> patches.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v15:
>   * Remove realm->params and only temporarily allocate the page when the
>     realm is being created.

[...]

> ---
>   arch/arm64/include/asm/kvm_emulate.h | 24 +++++++++++
>   arch/arm64/include/asm/kvm_rmi.h     | 63 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/arm.c                 | 12 ++++++
>   arch/arm64/kvm/mmu.c                 | 18 +++++++-
>   arch/arm64/kvm/rmi.c                 | 56 +++++++++++++++++++++++++
>   5 files changed, 171 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..e26d6755279f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -688,4 +688,28 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>   			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>   	}
>   }
> +
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rmi_is_available))
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline void kvm_set_realm_state(struct kvm *kvm,
> +				       enum realm_state new_state)
> +{
> +	WRITE_ONCE(kvm->arch.realm.state, new_state);
> +}
> +
> +static inline bool kvm_realm_is_created(struct kvm *kvm)
> +{
> +	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 57d24b244c95..cefd00b76806 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -6,12 +6,75 @@
>   #ifndef __ASM_KVM_RMI_H
>   #define __ASM_KVM_RMI_H
>   
> +#include <linux/arm-smccc-rmi.h>
> +
> +/**
> + * enum realm_state - State of a Realm
> + *
> + * Mirrors the RMM's Realm lifecycle states where they are meaningful to KVM,
> + * with REALM_STATE_DYING being a KVM-internal state used to prevent further
> + * requests while teardown is in progress. KVM does not track REALM_SYSTEM_OFF
> + * or REALM_ZOMBIE separately as they naturally lead to teardown.
> + */
> +enum realm_state {
> +	/**
> +	 * @REALM_STATE_NONE:
> +	 *      Realm has not yet been created. rmi_realm_create() has not
> +	 *      yet been called.
> +	 */
> +	REALM_STATE_NONE,
> +	/**
> +	 * @REALM_STATE_NEW:
> +	 *      Realm is under construction, rmi_realm_create() has been
> +	 *      called, but it is not yet activated. Pages may be populated.
> +	 */
> +	REALM_STATE_NEW,
> +	/**
> +	 * @REALM_STATE_ACTIVE:
> +	 *      Realm has been created and is eligible for execution with
> +	 *      rmi_rec_enter(). Pages may no longer be populated with
> +	 *      rmi_data_create().
> +	 */
> +	REALM_STATE_ACTIVE,
> +	/**
> +	 * @REALM_STATE_DYING:
> +	 *      Realm is in the process of being destroyed or has already been
> +	 *      destroyed.
> +	 */
> +	REALM_STATE_DYING,
> +	/**
> +	 * @REALM_STATE_DEAD:
> +	 *      Realm has been destroyed.
> +	 */
> +	REALM_STATE_DEAD
> +};
> +
>   /**
>    * struct realm - Additional per VM data for a Realm
> + *
> + * @rd: Kernel mapping of the RMM-managed Realm Descriptor (RD) granule
> + * @sro: Preallocated SRO state context for Realm MMU operations
> + * @state: The lifetime state machine for the realm
> + * @ia_bits: Number of valid Input Address bits in the IPA
>    */
>   struct realm {
> +	void *rd;
> +	/*
> +	 * Reused by RTT map/unmap SRO commands. Those commands are only
> +	 * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
> +	 * held for write, including Realm fault handling where
> +	 * kvm_fault_lock() takes the write side, so concurrent use is
> +	 * serialized.
> +	 */
> +	struct rmi_sro_state *sro;
> +	enum realm_state state;
> +	unsigned int ia_bits;
>   };
>   
>   void kvm_init_rmi(void);
> +u32 kvm_rmm_ipa_limit(void);
> +
> +int kvm_init_realm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);
>   
>   #endif /* __ASM_KVM_RMI_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b961c22fce3d..c4d906861736 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -266,6 +266,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>   
> +	/* Initialise the realm bits after the generic bits are enabled */
> +	if (kvm_is_realm(kvm)) {
> +		ret = kvm_init_realm(kvm);
> +		if (ret)
> +			goto err_uninit_mmu;
> +	}
> +
>   	return 0;
>   
>   err_uninit_mmu:
> @@ -328,6 +335,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_unshare_hyp(kvm, kvm + 1);
>   
>   	kvm_arm_teardown_hypercalls(kvm);
> +	if (kvm_is_realm(kvm))
> +		kvm_destroy_realm(kvm);
>   }
>   
>   static bool kvm_has_full_ptr_auth(void)
> @@ -488,6 +497,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		else
>   			r = kvm_supports_cacheable_pfnmap();
>   		break;
> +	case KVM_CAP_ARM_RMI:
> +		r = static_key_enabled(&kvm_rmi_is_available);
> +		break;
>   
>   	default:
>   		r = 0;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c6..8b9efa8a3539 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -904,10 +904,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   
>   static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>   {
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	u32 kvm_ipa_limit = get_kvm_ipa_limit();
>   	u64 mmfr0, mmfr1;
>   	u32 phys_shift;
>   
> +	if (kvm_is_realm(kvm))
> +		kvm_ipa_limit = kvm_rmm_ipa_limit();
> +
>   	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>   	if (is_protected_kvm_enabled()) {
>   		phys_shift = kvm_ipa_limit;

get_kvm_ipa_limit() and variable 'kvm_ipa_limit' have been exposed through
KVM_CAP_ARM_VM_IPA_SIZE for both normal and realm VMs in this series. However,
the IPA limit determined by the feature-register-0 in TF-RMM, which is returned
by kvm_rmm_ipa_limit(), can be different from 'kvm_ipa_limit'.

This brings confusion to VMM like qemu, where the request to create a realm VM is
rejected if the requested IPA size exceeds the limit, exposed by the host through
KVM_CAP_ARM_VM_IPA_SIZE. So the host needs to return correct IPA limit through
KVM_CAP_ARM_VM_IPA_SIZE for realm VM somewhere in this series?

Thanks,
Gavin

> @@ -957,9 +961,18 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
>   
>   static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>   {
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>   	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
>   
> -	stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +	/*
> +	 * Realm RTTs are inaccessible to the host and may contain stale data
> +	 * after the RMM has released them. The non-root RTTs are explicitly
> +	 * destroyed through RMI before the RD is destroyed; only the root PGD
> +	 * pages remain to be freed here.
> +	 */
> +	if (!kvm_is_realm(kvm))
> +		stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +
>   	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>   }
>   
> @@ -1001,6 +1014,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   		return -EINVAL;
>   	}
>   
> +	mmu->arch = &kvm->arch;
> +
>   	err = kvm_init_ipa_range(mmu, type);
>   	if (err)
>   		return err;
> @@ -1009,7 +1024,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	if (!pgt)
>   		return -ENOMEM;
>   
> -	mmu->arch = &kvm->arch;
>   	err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu, &kvm_s2_mm_ops);
>   	if (err)
>   		goto out_free_pgtable;
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 247c4f033945..528b01d5d71d 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -5,6 +5,8 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_pgtable.h>
>   #include <asm/rmi_cmds.h>
>   #include <asm/virt.h>
> @@ -14,6 +16,60 @@ static bool rmi_has_feature(int reg, unsigned long feature)
>   	return !!u64_get_bits(rmi_feat_reg(reg), feature);
>   }
>   
> +u32 kvm_rmm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +
> +	if (!kvm_realm_is_created(kvm)) {
> +		kfree(realm->sro);
> +		realm->sro = NULL;
> +		return;
> +	}
> +
> +	kvm_set_realm_state(kvm, REALM_STATE_DYING);
> +
> +	if (realm->rd) {
> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +
> +		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
> +			return;
> +
> +		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
> +			return;
> +		free_delegated_page(rd_phys);
> +		realm->rd = NULL;
> +	}
> +
> +	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
> +					 pgd_size)))
> +		return;
> +
> +	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
> +
> +	/* Now that the realm is destroyed, free the entry-level RTTs. */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +
> +	kfree(realm->sro);
> +	realm->sro = NULL;
> +}
> +
> +int kvm_init_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	realm->sro = kmalloc_obj(*realm->sro);
> +	if (!realm->sro)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>   static int rmm_check_features(void)
>   {
>   	if (kvm_lpa2_is_enabled() &&

