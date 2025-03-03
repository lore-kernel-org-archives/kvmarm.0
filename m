Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DBB1E1C09
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 04:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740977653; cv=none; b=jB+T6fXJIHAFa4lOONOH7Nj4xbQt/BUpV0F5AZCrK21gAFmeJwn+rLtLxQVn5TLxIVCvReQZxYQhbehx9r2Ax5is/RphaGMllcGRQs2L1yDZaLCrELv4NMDhaJfghl87WPjTIyMuPwZurmtkKnazsy5llER2HM2Ay9sDkMfTcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740977653; c=relaxed/simple;
	bh=/Q3d4gUCjX1Ns3emiF4KTsF0mBF/50bMqjvHn7VKOsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3pjGuqAw+ScaeQXeSwGjPPkuB3Kbz3j55T8JG6/TXVzsnmsL7ULhjaxy/xz2RHLOvNpFkILJClU138lj+AuI4tJ1SiSYBfp9G7pfxLpJFuKAQyYKBcJtmuuFeGhE/hzJpy3qpM/P6OFhSTdaoXtZJjW9QhjEDLjYPukf8x8Dbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TQ3x+FEE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQ3x+FEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740977650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOpndmvGS2CTNAq9sooQow9PnGsS4iRFoQMUou58z7M=;
	b=TQ3x+FEE0Ph1KUPgq7BDnS0uzEz3Qg7rS6NbWZWGLV+q9oqIttN7RJEJoThYGAK80dHnuf
	h4qw/t1hQrSXNSn8DU7Qzk7ltDWsfqlHRgaolUYqjic3p8PdOtViEuZ9gD5vTK09unNnDI
	arP00JOfUjnEyZa9zWb5be/swPApbF4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-2MODTDirP5644FavmExhAg-1; Sun, 02 Mar 2025 23:53:49 -0500
X-MC-Unique: 2MODTDirP5644FavmExhAg-1
X-Mimecast-MFC-AGG-ID: 2MODTDirP5644FavmExhAg_1740977628
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-223a2770b75so17215935ad.1
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 20:53:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740977628; x=1741582428;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOpndmvGS2CTNAq9sooQow9PnGsS4iRFoQMUou58z7M=;
        b=elO60R8pM7up0QmnDKBjnvduCGSfROBEL9jGSHZtooR7PxxsrNB/wmsHqhWqFIaaUO
         gDksx9h0R6P/C7wvmzJX5OfSnH42Z/yP1NFJ0j+5QQtHltaeOJkNGkXyuKtxuVD5wDWR
         gnf1QNyQceOkCsPZ1NDvxhE7kyOx/XxtywJl0rcuxUQtOd8RO8vwSo0RP3Fur7ONroGU
         X5fbnpmhWKdpz4TEQlcOMH/TnWqA00I/WEMcP7w6NYrFcLV/tujCK+9ZE/kKVNHj5Nh2
         GPQZDva/NknZkizA3g/t1NKcq2KDI9JfvNEuSzrAApnvzXHJUn0nu82T65slR0OculS+
         Ql+w==
X-Forwarded-Encrypted: i=1; AJvYcCVUtwQqEDxjMIOOpsL2u5IKMJK2fiHGXp64y7GGP9okpcJNiv78m6ZKe/3yFOQvhcHgerYDQGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyftXPY+XEoLjT6FI8mlSnikUP+46artk3omqqpK7avP8crLQpj
	WTOkm2r+Y1XkFYecBNuRrXexVJZ7jV7QeYGEiogM1iyil0RemAss6aKn+raGmXqQoDF9XFONroe
	OjVTr3XjDb675TA/QG5iqAhqm8FlY5WnQb9Q012DeqvFDyBBmeneAdA==
X-Gm-Gg: ASbGncuKoiB1wa05Ra2/ja9ekMvbAdrGSVuj16D/WZ39hfCwJW8D2BOFH4zZzcvvL9k
	9r4cfz8hKCX9S/cgKKiGazfyxsIA23wUvMlt8yOHqrJFYEoLoa0oBkqQSp+FfU02cbmMHGBTfHO
	XXP5RhkIKcoExCrofkwJacm4KuXVP0kKqeZBEzzwjMAOEIjcnAjGODeuV7MYtU9vcZTqgPixkO2
	itvVSXESF7eNXE3iavoKWPD1VQh49ih5RFPt3R4R7qqcvqN4EMuNFgdmk445aqH4cHCzWUxSHSe
	upiWfxRDLl5DJrh6LQ==
X-Received: by 2002:a17:903:41cb:b0:223:3781:b600 with SMTP id d9443c01a7336-2236920acb2mr202357135ad.45.1740977628213;
        Sun, 02 Mar 2025 20:53:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLRAVnzN70JdT8ECZbLP+/KQdRigH/UQkGxmw0H8i5HF/nVSSmnBIohZTsVrXlcl3ik9AvfQ==
X-Received: by 2002:a17:903:41cb:b0:223:3781:b600 with SMTP id d9443c01a7336-2236920acb2mr202356895ad.45.1740977627908;
        Sun, 02 Mar 2025 20:53:47 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350513dd4sm68505855ad.224.2025.03.02.20.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 20:53:47 -0800 (PST)
Message-ID: <48b68e9c-e550-4fa9-b479-7b2aad4fd538@redhat.com>
Date: Mon, 3 Mar 2025 14:53:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/45] arm64: kvm: Allow passing machine type in KVM
 creation
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
 <20250213161426.102987-11-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-11-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hqEk-q7EGcIqmE5hOFsWKJ7ghXQ79LUYbn-hZVE1PZQ_1740977628
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Make the check for kvm_rme_is_available more visible and report an
>     error code of -EPERM (instead of -EINVAL) to make it explicit that
>     the kernel supports RME, but the platform doesn't.
> ---
>   arch/arm64/kvm/arm.c     | 15 +++++++++++++++
>   arch/arm64/kvm/mmu.c     |  3 ---
>   include/uapi/linux/kvm.h | 19 +++++++++++++++----
>   3 files changed, 30 insertions(+), 7 deletions(-)
> 

Section 4.2 of Documentation/virt/kvm/api.rst needs to be updated. Other
than that, it looks good to me:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index df6eb5e9ca96..917ee7c674f5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -180,6 +180,21 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		if (!static_branch_unlikely(&kvm_rme_is_available))
> +			return -EPERM;
> +		kvm->arch.is_realm = true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8cda128aafef..f8ad8f88bbb8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -886,9 +886,6 @@ static int kvm_init_ipa_range(struct kvm *kvm,
>   	if (kvm_is_realm(kvm))
>   		kvm_ipa_limit = kvm_realm_ipa_limit();
>   
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>   	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>   	if (is_protected_kvm_enabled()) {
>   		phys_shift = kvm_ipa_limit;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index fa8f45029dff..9cabf9b6a9b4 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -644,14 +644,25 @@ struct kvm_enable_cap {
>   #define KVM_S390_SIE_PAGE_OFFSET 1
>   
>   /*
> - * On arm64, machine type can be used to request the physical
> - * address size for the VM. Bits[7-0] are reserved for the guest
> - * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
> - * value 0 implies the default IPA size, 40bits.
> + * On arm64, machine type can be used to request both the machine type and
> + * the physical address size for the VM.
> + *
> + * Bits[11-8] are reserved for the ARM specific machine type.
> + *
> + * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
> + * For backward compatibility, value 0 implies the default IPA size, 40bits.
>    */
> +#define KVM_VM_TYPE_ARM_SHIFT		8
> +#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
> +#define KVM_VM_TYPE_ARM(_type)		\
> +	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
> +#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
> +#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
> +
>   #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>   #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>   	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
>   /*
>    * ioctls for /dev/kvm fds:
>    */

Thanks,
Gavin

