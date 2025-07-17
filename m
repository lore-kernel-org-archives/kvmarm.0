Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780F32F8C31
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752771609; cv=none; b=g0qhkCMdaSzfDgOL0NaxpkBO5bfPTGw494Emf2FjRYuVlWmBONiHeyBJwddv3jTxVfhiEXAq0Fn83Qz9LmaEMVLlrFN0H46Ecf5g9Q+8ZTjNtLnTlK1bhfLuy40TkxMmGvTEYsXcprkjsyW4IygHCTi9BGc3H/X4/TQFmeBsnCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752771609; c=relaxed/simple;
	bh=oU8OEN8DiLQiuJ4IMSJ9Khs9v4CHN7kHLEKR+HRpsD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hv957ry5giend1GtGkllzcpTvM8jQsdm1TupN+UGw9v+9oAQ+HYtD8QPWXHwGzNuOergUv4f8Ir0Kmsyd5O0ENBUmjN2PVP6+2lmaEfO8E2Dzhfam5dXXarm8qqIBtViDi/Fc2IOyTntmOtMVAcZbAXdy/Va36qxAsPmoYZarCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmEGM+Gj; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmEGM+Gj"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso26641cf.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752771606; x=1753376406; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oU8OEN8DiLQiuJ4IMSJ9Khs9v4CHN7kHLEKR+HRpsD4=;
        b=WmEGM+Gj45Hzl345HpUEqbN9Qqr8GOX75BjdG9fTQSERzI/fBMe0QVzZdQXZ3OJdid
         H8MLvOAVQaAhm02UeEU+84fqJrQnlDVGV4owgyENDLihlZL0ERdDbkkkfd2NiT39bicp
         SYrujgGL4Oon7OSBm7HRmD3ErTfcXXCUnguL15JlQAdn9tMsh28wZN6dktxr17RlarU2
         1k0nGBZAaE/riwxqcjU7FNh7/ggyc9KtUVTKxgZG924SYQBLGZYCOqWgwoLH8gBa16EF
         HvBf7Tw+/PHlWKGE6wuyDjC0PAY7zRwfNaT1BZx3NRp9BhMh3e0Q/knPb8qqvXd4oP8U
         1pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752771606; x=1753376406;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oU8OEN8DiLQiuJ4IMSJ9Khs9v4CHN7kHLEKR+HRpsD4=;
        b=DCI6cjCbGGU2/DwcBqnEtwHKC5aXkPvbHBRU9pdkWDLwgFvYiSKls6nImk/ck51pvq
         5sMYAJ16tL2kg1mP6Tx07Oz+oYBWYkIkVVfwtUi2FMeQyvv0NA/kW/NJtp7qaO7hM99o
         CeYQ+Jfiq4vMQ7KjHA7YB6hx0gshOouNVdfb5v+MNrd3c8KU5NzdVdr5gohqXlhpbo/D
         9/I1AS50xORQ7FdaVTbYGFP4FNkRSlc5HF+ndnSB678WZ6wLqrP2yupqvmFRiA4ZmTbF
         iGDZwc8/5Vuhi8giw9nRKHvsb/37MajaOixtQIKZgg1LjtOvHdjmkOJyERzxGXayCu4v
         FPCg==
X-Forwarded-Encrypted: i=1; AJvYcCVywPbxiSza9xN45y8d+7XNpUANqGTHRH5Ucg9q6zp87SoeZfIWTjUypmaJl2i6R4+qE2K/ECo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsIYtZPVSeTIO1zUhDJ0LK+KR8soJ0Gp5miUlBKoPo2fe8Ynky
	t8cR2AsLtMekpCs2/Y9+tpEFT2slDU51kNKzL2xfyXhVc2WldLhrqANIzLCFbRCM22UhT0iS29m
	0qzYK7CKU82iuAP/kkA9QrKzfbbQuymcMubuDCeNs
X-Gm-Gg: ASbGncuPqUJDTq60dRakd/DQ+burY5oHt2LgCSxa7wsmZlF7Wlj/LY5R64sMiTD3DyO
	a1lHX7Yf6B8gN2QsEu72bwXTVOe61d/UQLik5g7bMnWZFlxTd4zXGs/Ql2KzuFNLDFsbWLuSShS
	gsk4d2ov512laauywx9vqDOKr34WWuvc94fGANsTaoIPLJKSPKrqvv1ePz91v+0u754mI5zNk+k
	FD247h+SB9KHw3kxg==
X-Google-Smtp-Source: AGHT+IHeNpR/+BN6xdHvYv3j4QgYq0wNKWKEZESgam6TiVIr9nAQ68C9bCDfOK9/avU/Gq6vxcviQoc9FPaew2iDRIg=
X-Received: by 2002:a05:622a:8d04:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4abb1327719mr384211cf.8.1752771605706; Thu, 17 Jul 2025
 10:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com> <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
 <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com> <diqztt3ag3su.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqztt3ag3su.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Jul 2025 17:59:29 +0100
X-Gm-Features: Ac12FXw4Rvcuc6rmyInnEzxFUojvTpTYKEnaNr9lZYk_ew7ONziPwEn2F1tG90w
Message-ID: <CA+EHjTxh2nsmiSjx=nkNof5uwjtCJBt+YACBrECwEjHM5d-vBA@mail.gmail.com>
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 17 Jul 2025 at 17:50, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>
> > On 7/17/2025 8:12 AM, Ackerley Tng wrote:
> >> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >>
> >>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>>> Introduce a new boolean member, supports_gmem, to kvm->arch.
> >>>>
> >>>> Previously, the has_private_mem boolean within kvm->arch was implicitly
> >>>> used to indicate whether guest_memfd was supported for a KVM instance.
> >>>> However, with the broader support for guest_memfd, it's not exclusively
> >>>> for private or confidential memory. Therefore, it's necessary to
> >>>> distinguish between a VM's general guest_memfd capabilities and its
> >>>> support for private memory.
> >>>>
> >>>> This new supports_gmem member will now explicitly indicate guest_memfd
> >>>> support for a given VM, allowing has_private_mem to represent only
> >>>> support for private memory.
> >>>>
> >>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
> >>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >>>> Co-developed-by: David Hildenbrand <david@redhat.com>
> >>>> Signed-off-by: David Hildenbrand <david@redhat.com>
> >>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>
> >>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >>>
> >>> Btw, it seems that supports_gmem can be enabled for all the types of VM?
> >>>
> >>
> >> For now, not really, because supports_gmem allows mmap support, and mmap
> >> support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
> >> mean that shared faults also get faulted from guest_memfd.
> >
> > No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is
> > independent to whether gmem is supported.
> >
> >> A TDX VM that wants to use guest_memfd for private memory and some other
> >> backing memory for shared memory (let's call this use case "legacy CoCo
> >> VMs") will not work if supports_gmem is just enabled for all types of
> >> VMs, because then shared faults will also go to kvm_gmem_get_pfn().
> >
> > This is not what this patch does. Please go back read this patch.
> >
> > This patch sets kvm->arch.supports_gmem to true for
> > KVM_X86_SNP_VM/tdx/KVM_X86_SW_PROTECTED_VM.
> >
> > Further in patch 14, it sets kvm->arch.supports_gmem for KVM_X86_DEFAULT_VM.
> >
> > After this series, supports_gmem remains false only for KVM_X86_SEV_VM
> > and KVM_X86_SEV_ES_VM. And I don't see why cannot enable supports_gmem
> > for them.
> >
>
> My bad, my explanation was actually for
> kvm_arch_supports_gmem_mmap(). Could the confusion on this thread be
> showing that the .supports_gmem is actually kind of confusing?
>
> If there's nothing dynamic about .supports_gmem, what have we remove the
> .supports_gmem field and have kvm_arch_supports_gmem_mmap() decide based
> on VM type?

I do think that, in the same manner has_private_vm is a field, this
should also be a field, and for the same reasons. It would confuse
things (in x86) having one be dynamic.

As David said, let's not nitpick this :)

Cheers,
/fuad

> >> This will be cleaned up when guest_memfd supports conversion
> >> (guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.
> >>
> >> With guest_memfd stage-2 there will also be a
> >> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
> >> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
> >> CoCo VMs, shared faults will go to the other non-guest_memfd memory
> >> source that is configured in userspace_addr as before.
> >>
> >> With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
> >> faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
> >> allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
> >> wishing to use guest_memfd as the only source of memory for the guest
> >> should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
> >> creating the guest_memfd.
> >>
> >>> Even without mmap support, allow all the types of VM to create
> >>> guest_memfd seems not something wrong. It's just that the guest_memfd
> >>> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >> p
