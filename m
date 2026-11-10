Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322904;
	b=kvT1PQPOwd3vTdQ8jYdDALxm4+DP2GfCk5L4x1mssTNDT4vq4+aPgmZsLWQK5PTqp8kA
	 nhAAxy4hCV6bzs3+y7ft01+JpNIYarsv5MvjhVfHDGHO4EvjQiUdZmdxEFJ1r5akHq66s
	 6iz2QKemn8MQQ3yWvzFumAbbGai+pymoiMpTXSZ2hJ7nZJ5GaRnhARl1+mXBd+xr3BQru
	 EG4DgJ9DOvm8WoGeh/KYJHZxYBFXijs+ZaXuJ9Lhgrj7PINFBW5Shu8gayX/ausy4eGu/
	 GNHKBU4rG75FYTgcj2IAuA9XJ3vQGb6w7LyrwheXSyORturmhGVKUL8S9wp7YCJ4BLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322904;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=tBOw9MmsY/45kZ1xClRUn5mk5+Ni4aNsCRB93P9Vktk=;
	b=Nybo2Z2Ea0FSgfn2N4fRX+72MxWBOVmcB5ceBXiecH+PopYlM1u27NEAfvm30NbJPNtA
	 cKg3p2eBLO0tpMKnDDJNVBdoEA+s2kbcEUO+/yGQUkEpJrouXKNtLf0rdXQpSr/nqWPLD
	 ueG9x2KxfJZSeFXFdynkTeMs8XW/I6y472T3+FhXvDqGj0lIFOt0U7yigoaVbrXp+WEuo
	 gjGt0+vHy0jx27fQVC+F9EOyD0xyCSNZ2mmxSLiCsF9BdlHXo/wu6774UZ5xXXB6qBsh8
	 si58qZP6hQMuicddqaq5RgvKVj1DWLWvy+cECPGYlBwWmVPmnMFRnrnxWjuTAqNgcNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JcR3jUr3;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DE1606A33D
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48DE1606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JcR3jUr3
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A8921477;
	Tue, 10 Nov 2026 07:01:39 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D8EF3F632;
	Tue, 10 Nov 2026 07:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794322902; bh=wc1ESF0HdLuJ1jHL7QH8MdHopqXBIAcjp27aKnu4KV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JcR3jUr3iFha9Z3O7XdWX0UfqdJ8rATKlQECKTr3T1Pm9PqyV5bs3lKo7o6ximxc2
	 6FOoSvU7tdpw1PSabW9lnO8RyC3IvHiE+e2dxVTcdlt911Fc6mlEu6NmKSZqR03kbU
	 JD5J7y/t4CVOwWn73MNNBc49r5pi/Gc/td93xaeU=
Message-ID: <7c3854ab-1fad-49ec-91f6-e1e56290ce53@arm.com>
Date: Tue, 10 Nov 2026 15:01:39 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 04/23] Sync kernel UAPI headers with v7.4-rc1
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-5-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-5-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> Synchronise the headers to pull in the support for the GICv5 IRS that
> was added in v7.4-rc1. These changes do not include the GICv5 ITS
> changes which are still under review at the time of writing..
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/include/asm/kvm.h        | 16 ++++++++++++++++
>  include/linux/kvm.h            | 21 +++++++++++++++++++++
>  include/linux/virtio_console.h |  2 +-
>  include/linux/virtio_ids.h     |  1 +
>  powerpc/include/asm/kvm.h      | 18 ++++++++++++++++++
>  riscv/include/asm/kvm.h        | 17 +++++++++++++++++
>  x86/include/asm/kvm.h          |  4 ++--
>  7 files changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
> index 1c13bfa2..65ee09bd 100644
> --- a/arm64/include/asm/kvm.h
> +++ b/arm64/include/asm/kvm.h
> @@ -97,6 +97,11 @@ struct kvm_regs {
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>  #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
>  
> +/* Supported VGICv5 address types  */
> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
> +
> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
> +
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
> @@ -106,6 +111,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>  #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>  #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
> +#define KVM_ARM_VCPU_PMU_V3_STRICT	9 /* No default PMU creation */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> @@ -417,6 +423,16 @@ enum {
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>  #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
> +#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
> +#define KVM_DEV_ARM_VGIC_GRP_IST	11
> +
> +struct kvm_vgic_v5_ist {
> +	__u64	spi_ist_addr;
> +	__u64	spi_ist_size;
> +	__u64	lpi_ist_addr;
> +	__u64	lpi_ist_size;
> +};
> +
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 6c8afa20..8dff2fc1 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -996,6 +996,10 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
>  #define KVM_CAP_S390_VSIE_ESAMODE 248
> +#define KVM_CAP_S390_HPAGE_2G 249
> +#define KVM_CAP_PPC_COMPAT_CAPS 250
> +#define KVM_CAP_ARM_PMU_V3_STRICT 251
> +#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 252
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1340,6 +1344,8 @@ struct kvm_s390_keyop {
>  /* Available with KVM_CAP_COUNTER_OFFSET */
>  #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
>  #define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
> +/* Available with KVM_CAP_PPC_COMPAT_CAPS */
> +#define KVM_PPC_GET_COMPAT_CAPS	_IO(KVMIO,  0xb8)
>  
>  /* ioctl for vm fd */
>  #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
> @@ -1648,6 +1654,21 @@ struct kvm_memory_attributes {
>  	__u64 flags;
>  };
>  
> +/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 error_offset;
> +	__u64 reserved[11];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
> index 7e6ec2ff..0506539e 100644
> --- a/include/linux/virtio_console.h
> +++ b/include/linux/virtio_console.h
> @@ -44,7 +44,7 @@
>  #define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
>  
>  struct virtio_console_config {
> -	/* colums of the screens */
> +	/* columns of the screens */
>  	__virtio16 cols;
>  	/* rows of the screens */
>  	__virtio16 rows;
> diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
> index 6c12db16..f9056af0 100644
> --- a/include/linux/virtio_ids.h
> +++ b/include/linux/virtio_ids.h
> @@ -69,6 +69,7 @@
>  #define VIRTIO_ID_BT			40 /* virtio bluetooth */
>  #define VIRTIO_ID_GPIO			41 /* virtio gpio */
>  #define VIRTIO_ID_SPI			45 /* virtio spi */
> +#define VIRTIO_ID_MEDIA			48 /* virtio media */
>  
>  /*
>   * Virtio Transitional IDs
> diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
> index 077c5437..913a64b9 100644
> --- a/powerpc/include/asm/kvm.h
> +++ b/powerpc/include/asm/kvm.h
> @@ -437,6 +437,24 @@ struct kvm_ppc_cpu_char {
>  	__u64	behaviour_mask;		/* valid bits in behaviour */
>  };
>  
> +/* For KVM_PPC_GET_COMPAT_CAPS */
> +struct kvm_ppc_compat_caps {
> +	__u64	size;			/* Size of this structure */
> +	__u64	flags;			/* Reserved for future use */
> +	__u64	compat_capabilities;	/* Capabilities supported by the host */
> +};
> +#define KVM_PPC_COMPAT_CAPS_SIZE_VER0	24 /* sizeof first published struct */
> +
> +/*
> + * Capability bits for compat_capabilities field in kvm_ppc_compat_caps.
> + * These bits indicate which processor compatibility modes are supported.
> + */
> +#define KVM_PPC_COMPAT_CAP_POWER9	(1ULL << 62)
> +#define KVM_PPC_COMPAT_CAP_POWER10	(1ULL << 61)
> +#define KVM_PPC_COMPAT_CAP_POWER11	(1ULL << 60)
> +#define KVM_PPC_COMPAT_BITMASK		(KVM_PPC_COMPAT_CAP_POWER9 | \
> +					 KVM_PPC_COMPAT_CAP_POWER10 | \
> +					 KVM_PPC_COMPAT_CAP_POWER11)
>  /*
>   * Values for character and character_mask.
>   * These are identical to the values used by H_GET_CPU_CHARACTERISTICS.
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 504e7330..39b0f3f1 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -102,6 +102,11 @@ struct kvm_riscv_smstateen_csr {
>  	unsigned long sstateen0;
>  };
>  
> +/* Zicfiss CSR for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_zicfiss_csr {
> +	unsigned long ssp;
> +};
> +
>  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
>  struct kvm_riscv_timer {
>  	__u64 frequency;
> @@ -199,6 +204,12 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZCLSD,
>  	KVM_RISCV_ISA_EXT_ZILSD,
>  	KVM_RISCV_ISA_EXT_ZALASR,
> +	KVM_RISCV_ISA_EXT_ZICFILP,
> +	KVM_RISCV_ISA_EXT_ZICFISS,
> +	KVM_RISCV_ISA_EXT_ZICCLSM,
> +	KVM_RISCV_ISA_EXT_ZICCAMOA,
> +	KVM_RISCV_ISA_EXT_ZICCIF,
> +	KVM_RISCV_ISA_EXT_ZA64RS,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> @@ -240,6 +251,9 @@ struct kvm_riscv_sbi_fwft_feature {
>  struct kvm_riscv_sbi_fwft {
>  	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
>  	struct kvm_riscv_sbi_fwft_feature pointer_masking;
> +	struct kvm_riscv_sbi_fwft_feature pte_ad_hw_updating;
> +	struct kvm_riscv_sbi_fwft_feature landing_pad;
> +	struct kvm_riscv_sbi_fwft_feature shadow_stack;
>  };
>  
>  /* If you need to interpret the index values, here is the key: */
> @@ -263,12 +277,15 @@ struct kvm_riscv_sbi_fwft {
>  #define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
>  #define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
>  #define KVM_REG_RISCV_CSR_SMSTATEEN	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
> +#define KVM_REG_RISCV_CSR_ZICFISS	(0x3 << KVM_REG_RISCV_SUBTYPE_SHIFT)
>  #define KVM_REG_RISCV_CSR_REG(name)	\
>  		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
>  #define KVM_REG_RISCV_CSR_AIA_REG(name)	\
>  	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
>  #define KVM_REG_RISCV_CSR_SMSTATEEN_REG(name)  \
>  	(offsetof(struct kvm_riscv_smstateen_csr, name) / sizeof(unsigned long))
> +#define KVM_REG_RISCV_CSR_ZICFISS_REG(name)  \
> +	(offsetof(struct kvm_riscv_zicfiss_csr, name) / sizeof(unsigned long))
>  
>  /* Timer registers are mapped as type 4 */
>  #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
> diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
> index 5f2b30d0..00ce2653 100644
> --- a/x86/include/asm/kvm.h
> +++ b/x86/include/asm/kvm.h
> @@ -45,9 +45,7 @@
>  #define __KVM_HAVE_PIT
>  #define __KVM_HAVE_IOAPIC
>  #define __KVM_HAVE_IRQ_LINE
> -#define __KVM_HAVE_MSI
>  #define __KVM_HAVE_USER_NMI
> -#define __KVM_HAVE_MSIX
>  #define __KVM_HAVE_MCE
>  #define __KVM_HAVE_PIT_STATE2
>  #define __KVM_HAVE_XEN_HVM
> @@ -477,6 +475,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
>  #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
>  #define KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM (1 << 10)
> +#define KVM_X86_QUIRK_NESTED_SVM_SHARED_PAT	(1 << 11)
>  
>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> @@ -532,6 +531,7 @@ struct kvm_svm_nested_state_data {
>  
>  struct kvm_svm_nested_state_hdr {
>  	__u64 vmcb_pa;
> +	__u64 gpat;
>  };
>  
>  /* for KVM_CAP_NESTED_STATE */
> -- 2.34.1
> 

I run ./util/update_headers.sh localy and got indentical result,
so FWIW:

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>

