Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DC01E521F
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752227133; cv=none; b=nIlOy8ScIctXHegyDQqEhaX7TcW2Dypk72IqB36mEdnTKLmL2Wrxv8ajKGW+xOoIu3EgkCNvdp8dDHOR/k/LvfKOdfFzfY3iwOZ0/V3yji8BUw9JUuAkbj3Xr61DtvzHzNo8sl6SYp6hI+GxT9M9IqG1f9ZQLhpKK4I1XhKs6+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752227133; c=relaxed/simple;
	bh=G9mm78zXYI6piKO+tCuvJ8phdn2YIo88+qdAXqWDekI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UYhNL6V7WgBmkJVfl+0jifwxbaI0/SXltT4bbgXv47dU1q1+H6DuDpaBs72LZykN0BJgs3ckRAjrnsWyUHDDAvUcxmono5Mt83mYkh5EMy174C8NJeilkNE926XW0aHW1RIhpXiv54cvPBCzqGDlGp6Gy9FfL2vAiVAYRRoOLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dL7qkSDv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dL7qkSDv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752227126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QSYtK8W1hoFX+G4/TI9sDJE2SYg5NnfEH2SkGUJResc=;
	b=dL7qkSDvE1E6mN0F8zNRJ4/JjdzNqDzZcaDqbefyGcci8DStLLf6rVqceG6r9aC7uMbZS0
	pPEP5SxHNU+LPthjJAzAF3NW2XlOOxeVLA8pw3c82FIy3k2CpPnv+MROGvrN3dbQR9y5ot
	Gq6P5GgHaOdXIa0pr7W+Jl70lwNGeOA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-dBI_nSacNrivDLNcndqcXg-1; Fri, 11 Jul 2025 05:45:25 -0400
X-MC-Unique: dBI_nSacNrivDLNcndqcXg-1
X-Mimecast-MFC-AGG-ID: dBI_nSacNrivDLNcndqcXg_1752227119
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4532514dee8so15140335e9.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 02:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752227119; x=1752831919;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QSYtK8W1hoFX+G4/TI9sDJE2SYg5NnfEH2SkGUJResc=;
        b=ByIVivxFkknOKqAka85ckDFSwF98mX/LUNOx5vz6M0t8PivYLPTGB0U07OJwl0H/yC
         BUXJOnMYWlk0g3INAW/bXZk8emf47uLlKapv7II8aCaa+3B72yU8c1SciKaRNyvSWT9s
         mT93sMoz4vKTRoqDmnrDXfr0iAZ0hrKavJSOFc9HDaM4Hhrrig2rp73/n+Zh9rsu0wzd
         jbslkd9MF/EwSZOOqbegDOtgdPwdpx8LZrj2Olfzw5CSWDtxUzqadiNC6E4y478S29iZ
         vs46JpRSZiB0FmpIDBKs1E5VMmbPAm+Zf6i/YzSHPTjlQOToLjN6w72kn+l4WGt8mfPj
         99zA==
X-Forwarded-Encrypted: i=1; AJvYcCX6esn/db1VBbgpJDTFjiDlS9go0z5zoUj+XVu3oLJj4LcRKt7KznIXJOTBCFjOdimd1ui/mGQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9ku9kfKS9eiCmqOt6KIg6RJN/FdAOxS1lfjYIBO+40HKZdMST
	+tON+62x0agxkFqGa4jYdYN5mb+oR+SRoijpyRzQvu/lFYgYo3UwqSJWDpv4cVYJI8zVENajm8j
	oVEoCPtO2uz5jf69pPp1ML1HC7iUBDsRu7pI+iKcrFiQ+Q1SIe/vw0I+hjA==
X-Gm-Gg: ASbGnctHuMKoTrjfQKAKYACyOB8M77tljzV7JeRr5EmCeacs96nVwHJifYWg3oPvE8N
	rox2slLU9tj4M61plCVjimjYTAGYrIb1iG2S/akTbHHCPPsu/H1XSTwRsy986qxdSlfzmR0HrT9
	zCBxuNIYategdji31HP2tTlrI9iSAYnO9pAI+bmg3/FoKRX0lzd1a6L0xUvJd50zg9A1S7CamN9
	ztvukXpY2wPRrt/2LynJ1eRhiugrRX1LFLhU17ncaVWYDrSqIcr1TsXvi4KvnLajJYQ4RH29Jg1
	Eeo9tvStsNJMWW6QYaoU5ojl9Z4MKxCiajko1PPcSXJRWZgsvAz1qcWtgJaZlXsYtJ6BMRSWKj0
	BEanPaNl3Sa/E9sRIVoP44/ggcR+kIH8wvu9RZ69QPWiZyi8q1dZ0VXYES7Dgmj9wQ/E=
X-Received: by 2002:a05:600c:46c3:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-454ec281d0amr20339325e9.25.1752227118950;
        Fri, 11 Jul 2025 02:45:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFnas8XgQ3IWLS2hIV11hHrPJlB9u2ohUWXcGE0uQdIEF9JiXqxZYBzaTwnR729ZNAjccDGg==
X-Received: by 2002:a05:600c:46c3:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-454ec281d0amr20338625e9.25.1752227118391;
        Fri, 11 Jul 2025 02:45:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3c:3a00:5662:26b3:3e5d:438e? (p200300d82f3c3a00566226b33e5d438e.dip0.t-ipconnect.de. [2003:d8:2f3c:3a00:5662:26b3:3e5d:438e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d50df0cdsm84339815e9.25.2025.07.11.02.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 02:45:17 -0700 (PDT)
Message-ID: <6fc1edd4-8a3c-4cba-8779-461a16b5126e@redhat.com>
Date: Fri, 11 Jul 2025 11:45:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250709105946.4009897-1-tabba@google.com>
 <20250709105946.4009897-15-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250709105946.4009897-15-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XaNLO0s8uRT750Py_F-zQFrcXAhgT_0ZECjSl0nM3kc_1752227119
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.07.25 12:59, Fuad Tabba wrote:
> Enable host userspace mmap support for guest_memfd-backed memory when
> running KVM with the KVM_X86_DEFAULT_VM type:
> 
> * Define kvm_arch_supports_gmem_mmap() for KVM_X86_DEFAULT_VM: Introduce
>    the architecture-specific kvm_arch_supports_gmem_mmap() macro,
>    specifically enabling mmap support for KVM_X86_DEFAULT_VM instances.
>    This macro, gated by CONFIG_KVM_GMEM_SUPPORTS_MMAP, ensures that only
>    the default VM type can leverage guest_memfd mmap functionality on
>    x86. This explicit enablement prevents CoCo VMs, which use guest_memfd
>    primarily for private memory and rely on hardware-enforced privacy,
>    from accidentally exposing guest memory via host userspace mappings.
> 
> * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in KVM_X86: Enable the
>    CONFIG_KVM_GMEM_SUPPORTS_MMAP Kconfig option when KVM_X86 is selected.
>    This ensures that the necessary code for guest_memfd mmap support
>    (introduced earlier) is compiled into the kernel for x86. This Kconfig
>    option acts as a system-wide gate for the guest_memfd mmap capability.
>    It implicitly enables CONFIG_KVM_GMEM, making guest_memfd available,
>    and then layers the mmap capability on top specifically for the
>    default VM.
> 
> These changes make guest_memfd a more versatile memory backing for
> standard KVM guests, allowing VMMs to use a unified guest_memfd model
> for both private (CoCo) and non-private (default) VMs. This is a
> prerequisite for use cases such as running Firecracker guests entirely
> backed by guest_memfd and implementing direct map removal for non-CoCo
> VMs.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 9 +++++++++
>   arch/x86/kvm/Kconfig            | 1 +
>   arch/x86/kvm/x86.c              | 3 ++-
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4c764faa12f3..4c89feaa1910 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2273,9 +2273,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   #ifdef CONFIG_KVM_GMEM
>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>   #define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_supports_gmem_mmap(kvm)		\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&	\
> +	 (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>   #else
>   #define kvm_arch_has_private_mem(kvm) false
>   #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_supports_gmem_mmap(kvm) false
>   #endif
>   
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index df1fdbb4024b..239637b663dc 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -47,6 +47,7 @@ config KVM_X86
>   	select KVM_GENERIC_HARDWARE_ENABLING
>   	select KVM_GENERIC_PRE_FAULT_MEMORY
>   	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> +	select KVM_GMEM_SUPPORTS_MMAP
>   	select KVM_WERROR if WERROR

Given the error, likely we want to limit to 64BIT.

select KVM_GMEM_SUPPORTS_MMAP if X86_64

-- 
Cheers,

David / dhildenb

