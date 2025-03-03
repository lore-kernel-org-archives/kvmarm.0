Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E376D13C8E8
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 04:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740975039; cv=none; b=MQfPxGR8uZcnXU6URzrPM9YNMB+hTlZ6PiRnNtUO+FCu+Bys7Su3kSZvBvo0GjFOHirzGoFI1EqwYZXrT2wVH2AXLSA8fsQtJ6rkpuW2c7uQEspi1MNbGTllie+MnU/Bm58IS4X9E8qX9BGSJVgodHjE05Z0YPdp0f0DLkEPmsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740975039; c=relaxed/simple;
	bh=Y7HjfUwf/Jdo7JmIWpCYe9yTIbXiqAYv6OQCDypKD3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pjb43/qC1g4KXN3i1pM908NPYbRNRoFp86VHE83rwWcoHNJcOY2Q8IPCLXAbm9uCyEcc2imOpdkbMLjxGWj3u5HhXnFEioCZCGPzN99a8lLwb7W7Pyiggjju3yxQGbIPmIeGhinIFbGYrnS7jkCPnB2EY5sas5hJTQ32e5wFkzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+dbNOR7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+dbNOR7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740975036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8Jpi5dvbsyJ9QNrNx2h/R0ed7l3DEYZ+0/PjrpQmlY=;
	b=S+dbNOR7xDtgHZ4YcqQKUd7Yx0CBnHhRoBACUWfTqA2TG2oOlSuCQvDIR6wX/bqToBtF2I
	sZic4X/1dWjneD4pA2NeOnzkkyRLRQAwmIyqdflQP80GHjysZB5YIYGDoD9mORyJm/Js3S
	9uNLXfzXHv0Wt/aNuzkRjXZxbpWEkgI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-egKYVgHtOju0DPG37zd7zA-1; Sun, 02 Mar 2025 23:10:35 -0500
X-MC-Unique: egKYVgHtOju0DPG37zd7zA-1
X-Mimecast-MFC-AGG-ID: egKYVgHtOju0DPG37zd7zA_1740975034
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2234bf13b47so75488445ad.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 20:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740975034; x=1741579834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8Jpi5dvbsyJ9QNrNx2h/R0ed7l3DEYZ+0/PjrpQmlY=;
        b=TD8s1E61vmH2G1loDGJvJisy2j1ArWeEkOni0Z/MFwqvNT/Pl9P5YPy+9iEQg1bTMo
         8KXEW4pSoZNycN7PUHUOawao/RkTLaroTeIJODkq4fv+U3tSWR+siWlw9s4pxf/wVKv7
         l2WzHfR11ETev6e309uw/Uj4h15K+EEag7U2Ljd1NEPy0cpDgi3O2Ojl1YBeiUQ7ud7K
         DJ/DoqfHNSWnwNRWl/RnALB2p3Ymx0AvTZ7LWki5EIbM5NFJH0zEz2JFrQ96ctEOFVh3
         xCDblEuHFkLlUwBW9jYfvXhLakbWMxk/QRnP79+R/cmX2wbxUBvyRhKIfoqYF3QC0myL
         bIxg==
X-Forwarded-Encrypted: i=1; AJvYcCU2LtmiZQDcQFdK7DOuwQAHhcTnV6xJ4ODWteNOVqJyrmRzRA7bVOdQYvWUN9izQTAnBr9+UzA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2xfoObkVBFVwjh59liGtniPUPN8He9MMwY0yWm4DDI7qtGxye
	wdR0mMvvUyV3HdUjERI2EjHWyPf/T22lz81vEWcqRfet4DqY2ygeWFj6uDxUxubh4FJAgINH9eV
	0Thkc7eXrQsLmMvE86yQ4Dal1BfgxihXb1gFr0O9kRUEGxCH8q0tlUw==
X-Gm-Gg: ASbGnctCOqmW2ParP35/Uf8hotnjBcVV8R5hzEYQXplLOJ8C6uJ8TZaEBijpwoF9p0T
	jk0UdU9kZpjC5icC8zBDf6GqCAh1cOEillfmbbUA55M9tF0TOIT65PF9XG0GQQPLLBEkeF/gmAJ
	RAd2ciTyJ+tqCT8WuuYg6SGeJvTMA1mpnk4hYI0083yfyyNvtN2YDEvCz/TOqgQ218SQqc0tkis
	MwebQ/uYvIvkmuXCa2irCOxCdxQkOjgoGNU4V++SAKamGghEpRcm4lOF4s4WPdiihGfESZnbLcg
	G1vjrBn8QZaSUNXW5Q==
X-Received: by 2002:a17:902:fc4f:b0:220:f509:686a with SMTP id d9443c01a7336-22368fbeaffmr188469615ad.29.1740975034356;
        Sun, 02 Mar 2025 20:10:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEw8k64wqsi9xaJMniYJ96OZyxXCWbCHDZik8qo7jA9iBAMykPZRI5AC4LCj7ThWiPsfJiuoQ==
X-Received: by 2002:a17:902:fc4f:b0:220:f509:686a with SMTP id d9443c01a7336-22368fbeaffmr188469335ad.29.1740975034020;
        Sun, 02 Mar 2025 20:10:34 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d26acsm68417915ad.9.2025.03.02.20.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 20:10:33 -0800 (PST)
Message-ID: <e130dd51-330e-43ef-b86f-41fd96cc9ec3@redhat.com>
Date: Mon, 3 Mar 2025 14:10:24 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/45] arm64: RME: Define the user ABI
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-8-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-8-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ejZ0uGSu692rRrMSRoz9HlaSdgC2OsXl8TqRZwJnTto_1740975034
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> There is one (multiplexed) CAP which can be used to create, populate and
> then activate the realm.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Rename some of the symbols to make their usage clearer and avoid
>     repetition.
> Changes from v5:
>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>   Documentation/virt/kvm/api.rst    |  1 +
>   arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h          | 12 ++++++++
>   3 files changed, 62 insertions(+)
> 

The newly added ioctl commands need to be documented in Documentation/virt/kvm/api.rst.
Section 4 would be the right place for it. Other than that, it looks good to me except
the ioctl commands need to be fixed as suggested by Aneesh.

Thanks,
Gavin

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0d1c3a820ce6..06763d89c0d7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5094,6 +5094,7 @@ Recognised values for feature:
>   
>     =====      ===========================================
>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>     =====      ===========================================
>   
>   Finalizes the configuration of the specified vcpu feature.
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 568bf858f319..7eae0b1a482e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -105,6 +105,7 @@ struct kvm_regs {
>   #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>   #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
> +#define KVM_ARM_VCPU_REC		8 /* VCPU REC state as part of Realm */
>   
>   struct kvm_vcpu_init {
>   	__u32 target;
> @@ -415,6 +416,54 @@ enum {
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
> index 45e6d8fca9b9..fa8f45029dff 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,8 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   
> +#define KVM_CAP_ARM_RME 300 /* FIXME: Large number to prevent conflicts */
> +
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
>   	__u32 pin;
> @@ -1581,4 +1583,14 @@ struct kvm_pre_fault_memory {
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
> +/* FIXME: Update nr (0xd2) when merging */
> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd2, struct kvm_arm_rmm_psci_complete)
> +
>   #endif /* __LINUX_KVM_H */

