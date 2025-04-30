Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0402DC775
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 04:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745987119; cv=none; b=bCAVKt3jpgbGAWSTxCyPdiHBjrGPgzhINxU6Ll15vabyBWpYqCjatvGxtohJPDtXQCr4DNsMQLANXYKVwABnM57rH9+biJdqPBUzsBi5YIw0mKkpSYItdeMlnpfyTeRrixZTXZFrDLq6vYVJvbxXi+i2V1nSY319yIiAprMb47U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745987119; c=relaxed/simple;
	bh=YoINL3SCWfkae2dP2gypAqnB4AkqatXeI1a981LEJp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VYsZrjj64fhDpEgb7hFkrE78MTmXq81aE8DAvVaKxnhg7SdnhAZ1G37L18bYDq96OUIku6mR7811sn3kiORFpB6EdvhWiEXT/SfhJTKetZL/tZ/QxS98q2J3Z1oZ9vaLcv8jtLQFV2Y2e7kjt/YZxx23jP/rmVGWSRx+xuMuxwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfUYQVx1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfUYQVx1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745987116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/9ZIpgit3K5HEouvbiwaznyb2ZT+dyMuQHH+dHlTBs=;
	b=CfUYQVx1KIijCvk7rZK+W2hkP5qiyVY8PNy/vVVbelpBHweO83uqBHwlhsv66xXro3l11H
	i2swWuydnIi6Ri/5uLSWtOpxmcRiZOqaAJfSgPmoy0sNOVM/oPF6+4H0v0hmE0AA5BfzjS
	hU/JIC1DsMWIEGNp7bRBWELEz/b99OE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-Km1QA-mzOjGiozGpdJhd8Q-1; Wed, 30 Apr 2025 00:25:14 -0400
X-MC-Unique: Km1QA-mzOjGiozGpdJhd8Q-1
X-Mimecast-MFC-AGG-ID: Km1QA-mzOjGiozGpdJhd8Q_1745987114
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so3803300a12.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 21:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745987112; x=1746591912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/9ZIpgit3K5HEouvbiwaznyb2ZT+dyMuQHH+dHlTBs=;
        b=LBRcY1S8BDRBZOHlk/UC41rdXXd9+xGb24enm2vul9TPX7UaF1+bh338vmzE7wwSgF
         A8o/x1sGMTU+W30kJ8kuu0k6IwfSNbGuoX+82tQE/8ghUVnd2isFHZbht6YdP28tSX2D
         t1rGZ7KbCF3d1Phx2d5JJ3FDtNz5ZwpglKt+5jO8iZOXxN6tGlmA4GlgU2UMnlyMmS9B
         Cr3uQ7EqNB0asXoiqmsIIHDw2juINrI1Q+2C7xi5l+YtwS+idGRyC5QQ9/tD/ExeaN5S
         4Rs4lkD27EAG16CHUNU0JEgOKooTUVN83L2F+nC6PblaiYs1vTFQsBuQu9elyoeY1ECQ
         AphA==
X-Forwarded-Encrypted: i=1; AJvYcCUCizR1RObM/hxdqibIGFgZ80KhPCEOhzovmFH6GgzaVX7ra7IjHDzplC0OeSjhEWVlpEm+/Ns=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqIyurQ53vxN0kKtsK0thgcFobfpJJzU+aDVye145KfqmgOc4T
	ZzY1rw3ylyYHSzooTZ+VmH8Kk3gNTGtdWC+O5nKJTlTpqEgqcYePw8/uFD0vvcZqfJs6rZ9eT6+
	kS8lJoI0/6O358P48Ko2nNQABqXm4FJGYhtncRC4lKXiGZxdqtYcsSQ==
X-Gm-Gg: ASbGnctIqSmRg+EqWbYdS73yXQ2f7pZCBEYnYzLJ2RRwF+rsYGZBBLmvttu2Viz6hrm
	XuwM9xtwtSrS893nCysXA+tPOstRF+RqdFzxa2kMYwjkYch74/Db2I3r4jkjWQkCh2oS7fzqo9O
	9ET+KHNXuyD8RgAS/cvHZloplIrWl8aiIfDU6oeIG/P/W9Z/eEHE9CZZBUfg1WmzjVU2fmxnhSf
	tRRFjLffia+lxYRsPVpXW7pQWiDwcSr2riDyJzFxuj5PwSwpDrKsACzD2YifbM+wOdolCzNXXSH
	PZwjIKzbM8Lk
X-Received: by 2002:a17:903:1a6f:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22df3590ef6mr30861035ad.38.1745987112444;
        Tue, 29 Apr 2025 21:25:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyXj2p77AmMx3N+ITVW1jQFy+1LPquQePsvvxXex3oWiwLfzusXWyW1Gs0Qv4M8sW36jIdYA==
X-Received: by 2002:a17:903:1a6f:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22df3590ef6mr30860675ad.38.1745987112018;
        Tue, 29 Apr 2025 21:25:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c13sm112249685ad.162.2025.04.29.21.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 21:25:11 -0700 (PDT)
Message-ID: <dac9f2c6-d46e-4232-abbd-8aa097f012a5@redhat.com>
Date: Wed, 30 Apr 2025 14:25:02 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/43] arm64: RME: Define the user ABI
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xgSEqnZZNPouuu7ykPy1ujzsj_Hi_rbyAzSUEgA6NiQ_1745987114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> There is one (multiplexed) CAP which can be used to create, populate and
> then activate the realm.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add documentation of new ioctls
>   * Bump the magic numbers to avoid conflicts
> Changes since v6:
>   * Rename some of the symbols to make their usage clearer and avoid
>     repetition.
> Changes from v5:
>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>   Documentation/virt/kvm/api.rst    | 70 +++++++++++++++++++++++++++++++
>   arch/arm64/include/uapi/asm/kvm.h | 49 ++++++++++++++++++++++
>   include/uapi/linux/kvm.h          | 10 +++++
>   3 files changed, 129 insertions(+)
> 

With below comment addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1f8625b7646a..99ba6c82cf37 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3527,6 +3527,11 @@ Possible features:
>   	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
>   	        no longer be written using KVM_SET_ONE_REG.
>   
> +	- KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context) for this
> +	  VCPU. This must be specified on all VCPUs created in a Realm VM.
> +	  Depends on KVM_CAP_ARM_RME.
> +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
> +
>   4.83 KVM_ARM_PREFERRED_TARGET
>   -----------------------------
>   
> @@ -5098,6 +5103,7 @@ Recognised values for feature:
>   
>     =====      ===========================================
>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>     =====      ===========================================
>   
>   Finalizes the configuration of the specified vcpu feature.
> @@ -6452,6 +6458,30 @@ the capability to be present.
>   
>   `flags` must currently be zero.
>   
> +4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
> +------------------------------------
> +
> +:Capability: KVM_CAP_ARM_RME
> +:Architectures: arm64
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_arm_rmm_psci_complete (in)
> +:Returns: 0 if successful, < 0 on error
> +
> +::
> +
> +  struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +  };
> +
> +Where PSCI functions are handled by user space, the RMM needs to be informed of
> +the target of the operation using `target_mpidr`, along with the status
> +(`psci_status`). The RMM v1.0 specification defines two functions that require
> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
> +
> +If the kernel is handling PSCI then this is done automatically and the VMM
> +doesn't need to call this ioctl.
>   
>   .. _kvm_run:
>   
> @@ -8280,6 +8310,46 @@ aforementioned registers before the first KVM_RUN. These registers are VM
>   scoped, meaning that the same set of values are presented on all vCPUs in a
>   given VM.
>   
> +7.38 KVM_CAP_ARM_RME
> +--------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: args[0] provides an action, args[1] points to a structure in
> +	     memory for some actions.
> +:Returns: 0 on success, negative value on error
> +
> +Used to configure and set up the memory for a Realm. The available actions are:
> +
> +================================= =============================================
> + KVM_CAP_ARM_RME_CONFIG_REALM     Takes struct arm_rme_config as args[1] and
> +                                  configures realm parameters prior to it being
> +                                  created.
> +
> +                                  Options are ARM_RME_CONFIG_RPV to set the
> +                                  "Realm Personalization Value" and
> +                                  ARM_RME_CONFIG_HASH_ALGO to set the hash
> +                                  algorithm.
> +
> + KVM_CAP_ARM_RME_CREATE_REALM     Request the RMM create the realm. The realm's
> +                                  configuration parameters must be set first.
> +
> + KVM_CAP_ARM_RME_INIT_RIPAS_REALM Takes struct arm_rme_init_ripas as args[1]
> +                                  and sets the RIPAS (Realm IPA State) to
> +                                  RIPAS_RAM of a specified area of the realm's
> +                                  IPA.
> +
> + KVM_CAP_ARM_RME_POPULATE_REALM   Takes struct arm_rme_init_ripas as args[1]
> +                                  and populates a region of protected address
> +                                  space by copying the data from the shared
> +                                  alias.
> +
> + KVM_CAP_ARM_RME_ACTIVATE_REALM   Request the RMM activate the realm. No
> +                                  further changes can be made to the realm's
> +                                  configuration, and VCPUs are not permitted to
> +                                  enter the realm until it has been activated.
                                                               ^^^^^^^^^^^^^^^^^^
s/has been activated/is deactivated

I don't see where the guard is applied to prevent vCPU is added after realm
has been activated. I may missed that. Otherwise, it's something to be improved
n the subsequent patch where a vCPU is created and added to the realm.


> +================================= =============================================
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index af9d9acaf997..b57712880605 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_regs {
>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>   #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>   #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
> +#define KVM_ARM_VCPU_REC		9 /* VCPU REC state as part of Realm */
>   
>   struct kvm_vcpu_init {
>   	__u32 target;
> @@ -429,6 +430,54 @@ enum {
>   #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>   #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>   
> +/* KVM_CAP_ARM_RME on VM fd */
> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
> +#define KVM_CAP_ARM_RME_CREATE_REALM		1
> +#define KVM_CAP_ARM_RME_INIT_RIPAS_REALM	2
> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
> +
> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
> +#define ARM_RME_CONFIG_RPV			0
> +#define ARM_RME_CONFIG_HASH_ALGO		1
> +
> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA256		0
> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA512		1
> +
> +#define ARM_RME_CONFIG_RPV_SIZE 64
> +
> +struct arm_rme_config {
> +	__u32 cfg;
> +	union {
> +		/* cfg == ARM_RME_CONFIG_RPV */
> +		struct {
> +			__u8	rpv[ARM_RME_CONFIG_RPV_SIZE];
> +		};
> +
> +		/* cfg == ARM_RME_CONFIG_HASH_ALGO */
> +		struct {
> +			__u32	hash_algo;
> +		};
> +
> +		/* Fix the size of the union */
> +		__u8	reserved[256];
> +	};
> +};
> +
> +#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE	(1 << 0)
> +struct arm_rme_populate_realm {
> +	__u64 base;
> +	__u64 size;
> +	__u32 flags;
> +	__u32 reserved[3];
> +};
> +
> +struct arm_rme_init_ripas {
> +	__u64 base;
> +	__u64 size;
> +	__u64 reserved[2];
> +};
> +
>   /* Device Control API on vcpu fd */
>   #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>   #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..0b8479985581 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> +#define KVM_CAP_ARM_RME 240
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
> @@ -1582,4 +1583,13 @@ struct kvm_pre_fault_memory {
>   	__u64 padding[5];
>   };
>   
> +/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
> +struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +};
> +
> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd6, struct kvm_arm_rmm_psci_complete)
> +
>   #endif /* __LINUX_KVM_H */

Thanks,
Gavin

