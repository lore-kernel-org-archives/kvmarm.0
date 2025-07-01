Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E951C1F0E4B
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751351939; cv=none; b=CNRbpB1/UgfJncUzZKe7zh5CXcj+hXwJ8D7wc0CRfMkT8A4XYAH/PNy72gLzRtl8LkMBFybPTpS73/ET4RWDTk96lb2oETd9b6Jw8TxE831qXWxNqIG4yPyiZhDxMZV2Po0zKq6StOd95HsYCpPttlwk7r+Ski4i8SZ6kLToKAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751351939; c=relaxed/simple;
	bh=vdn58W0P4SV8Ws3EOrRhV/EDGwj8q19SsrDH5hQ3C3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDkFoa3O7kwsWZ3H6LBYZ5ZMGOVrTEXjdq2wadqxBlGJ3Eddo1YWW067ldZYwN9Jj9x2VqeH4NQ/763z+snZVjRSVBg7W7mA1E5BaZaxEivFEZY0sPSYmyPUXFwQSarSCAB3J0EGdZV/o6dqpDKl+fnfRDqhxVovB9ng1/01Ng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3fM6c9p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3fM6c9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751351936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N2L3Cw1UrT66uEmHGGmoTWSgiUKsnwQtuwgvg8Krxk=;
	b=J3fM6c9pIGIO/62xO58L/gejBho5qFBGgoNMPUhhpa+dS4z2i7OgEZLtVBTNKJ7qUA269m
	AX5JF5GYgHaxVnxV6X6zvNwK/Af1wJHY29Ddh9r2uJQwneEpj7gtLS9bdgkHsggg+3/+jh
	zQmIN1ZR+nizzmW1DQ5Siny5RQiYgPk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-9zo3CPXUPOSf-27EJCC3yg-1; Tue, 01 Jul 2025 02:38:56 -0400
X-MC-Unique: 9zo3CPXUPOSf-27EJCC3yg-1
X-Mimecast-MFC-AGG-ID: 9zo3CPXUPOSf-27EJCC3yg_1751351935
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3121cffd7e8so2232277a91.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 23:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751351935; x=1751956735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/N2L3Cw1UrT66uEmHGGmoTWSgiUKsnwQtuwgvg8Krxk=;
        b=aNLKuRRTgdTn6FIjPifYLWSR7YvM4aC9ryUHUpsmL4z9am3LAztS2rOo2/q8pcrx7g
         TJrnC65sJWvn3YDf/AmaEbplfSn75iNSlhFOL/weVo/MRoJ8uMPzb/BYo/kgRBiDZIG+
         HsYNFJZ/eIMQgv2PuQ22CSkgvXgJPSWt5gYHn3JcY9HXVkN7G5e+ozK7INr+Q5kMj7AE
         j6rING+SJwHS+1mx1nCXa9Cjv3Q18eLMUlMumYOUTzIgCehAfL7AD4/lQA0h/222XPlq
         9C0QxU0EN4OFxVZjDX7mtmkB1Ey15YUGPYYOr3I3UfyBrCUKEMmZfD45GflML/V2cjzN
         X9TA==
X-Forwarded-Encrypted: i=1; AJvYcCWQdGCSxLQ5ttFIxW5+miBoX/DtdOSbabXxaGEUX3bY7iqLeBWJNePX0NLrYqBKVl5/s2PJuLM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW3ued2cZVcX+vUtF/zWjyAfIjqTFmYZ0wyhEwUdQM7xDzRksz
	e6J93Lca1+qOmL+i0wN61X48/qMydByottn3nr4RARqDIW5i5PT1em1eXyy6lU66VjuiKrdqmkO
	w7rpyfUdnHUydfattcmwRBK1qICfNfK0q4W9Td8k1WuH4OWDQ3q+VQ7Ihzw==
X-Gm-Gg: ASbGncv+wb/a3zL22vxoOlCpsHCV95t1GvbmdIPNNUG12msaDsLvA4YMhoslxB1IDuB
	08lbRG3RlXU/byWYGBKzfzPmxeCwd0V11JbQvI7mY6Uy+RMUav7n3MJEIhkn3ZnbqZy78ByMzJq
	j8XXtuhHbK8i/AMFx/VJ2O1tN1+qiYegZoy3ek3OeNFGGTJWmUDw47FGRx+TYnaEMHoksRmrUm5
	s1RI9tE07vKduhdus3W+xzNoBYTQ/4djjUVijbUk3gK1gdORTOWsngUSHnuUy4iW4x/TJlo+BG7
	lq6YP69Nw5B7OyMJpVU0TJ0UcQX6UAdCjByO/aH92T3SrlyXqzwdj3XFyprfZg==
X-Received: by 2002:a17:90b:3c50:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-318c8ec5177mr22460865a91.5.1751351934651;
        Mon, 30 Jun 2025 23:38:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXGVdcl+epWZi9VPn55ApO38WReIopBQVp1X+PhM6QPcmIdOqHMzKdtlUHTKMJd/V5XIritA==
X-Received: by 2002:a17:90b:3c50:b0:312:f0d0:bc4 with SMTP id 98e67ed59e1d1-318c8ec5177mr22460805a91.5.1751351934113;
        Mon, 30 Jun 2025 23:38:54 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c1523351sm10913306a91.48.2025.06.30.23.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:38:53 -0700 (PDT)
Message-ID: <e33e6268-a6a5-421d-97c1-b26044e3cfa5@redhat.com>
Date: Tue, 1 Jul 2025 16:38:44 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/43] KVM: arm64: Allow passing machine type in KVM
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-10-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-10-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SgsKJklGhmSL4xPJ4vH32HpjKwcoOdi8LtettQSjzlE_1751351935
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add some documentation explaining the new machine type.
> Changes since v6:
>   * Make the check for kvm_rme_is_available more visible and report an
>     error code of -EPERM (instead of -EINVAL) to make it explicit that
>     the kernel supports RME, but the platform doesn't.
> ---
>   Documentation/virt/kvm/api.rst | 16 ++++++++++++++--
>   arch/arm64/kvm/arm.c           | 15 +++++++++++++++
>   arch/arm64/kvm/mmu.c           |  3 ---
>   include/uapi/linux/kvm.h       | 19 +++++++++++++++----
>   4 files changed, 44 insertions(+), 9 deletions(-)
> 

One nitpick below.

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 65543289f75c..0049d67fe38f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -181,8 +181,20 @@ flag KVM_VM_MIPS_VZ.
>   ARM64:
>   ^^^^^^
>   
> -On arm64, the physical address size for a VM (IPA Size limit) is limited
> -to 40bits by default. The limit can be configured if the host supports the
> +On arm64, the machine type identifier is used to encode a type and the
> +physical address size for the VM. The lower byte (bits[7-0]) encode the
> +address size and the upper bits[11-8] encode a machine type. The machine
> +types that might be available are:
> +
> + ======================   ============================================
> + KVM_VM_TYPE_ARM_NORMAL   A standard VM
> + KVM_VM_TYPE_ARM_REALM    A "Realm" VM using the Arm Confidential
> +                          Compute extensions, the VM's memory is
> +                          protected from the host.
> + ======================   ============================================
> +
> +The physical address size for a VM (IPA Size limit) is limited to 40bits
> +by default. The limit can be configured if the host supports the
>   extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>   KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>   identifier, where IPA_Bits is the maximum width of any physical
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8080443d24af..b3e3323573c6 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -172,6 +172,21 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

Here we need to explicitly set the realm's state to REALM_STATE_NONE even though
it's equal to zero, and the struct vm should have been cleared on allocation.

		WRITE_ONCE(kvm->arch.realm.state, REALM_STATE_NONE);
		kvm->arch.is_realm = true;
		break;

> +	default:
> +		return -EINVAL;
> +	}
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);

[...]

Thanks,
Gavin

