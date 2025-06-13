Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEF125BEF0
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846937; cv=none; b=DSC8H4i7QSejBU/ioLGnOSy5GRG9ZCxcwi371RzGwGyVOc0w5PiWJCUxV78eYv0/zOGFHAgoM0SHInVAyzB6+iCd0Z8QCuI4KNoJWYnmo1IlRx/nuHOcUkbgGSmRMm6E9Ii36QRLBpf8G9xEUkmA8uK43MGi7HwCLITmpzPEhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846937; c=relaxed/simple;
	bh=TCA/bkZV1eOXGd9TQy3i5G9neadJfD5XdVh30uDYjMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kdFFXS33azCOtM0KEF+GCPvV3RvDLmO9lgIpUfHHRGDtPh3g218w51+ODOP9sgBTbfsRyybj+IKxxyqCFfSmMgJS2NrODegwUm9PNiu7sE5vdefbjZLYSDbA62Zj2sfldUNkFeRxKD5YS5wOBTgtqBEmEFhijdEgqDIrNsWb6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0t3Gg4/7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0t3Gg4/7"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73bfc657aefso1876069b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 13:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846935; x=1750451735; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD6EYmSk/zIl2SjxJRx3+64lAlSQfo57iDrafX9vuYg=;
        b=0t3Gg4/7xe5FKJHvjrycNMD05B8gM6seIq8MceVeYi0FhyNLwn8rXLAzm5sdXjvBlN
         M4TgrI6TI6Zos2+uYGlRVfm9F2/Dccdx7sqex5s61p2XRZ00S1BosbU/hHNYNtvytm0V
         uCPrXBipD85dPVzWqi/3hiUxJecc3Juj4MmxA4/WZ4YXtAJBMvN05VNmKLkQxSpYa2zl
         QV1vQQNeOENmEoaGfb1INv4Vdkt3ZJqylRYdlWwJXU9PZlN7DgABfrdrA7x6hP+NQsM7
         CKH6VGUsoWjZEGDj6u0HU55Z1RheBNRCcAaz8koduyiiZCc3+3u47F6n8QBy1gZswsb8
         sSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846935; x=1750451735;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aD6EYmSk/zIl2SjxJRx3+64lAlSQfo57iDrafX9vuYg=;
        b=Kha/3eXfFOZS4sHNDX12MCwBhJpYENVhZUSI3Bfw7vdC7iLJOZVfQ7vQw2cjPo5AgJ
         hJZMvrhNtjV1h5IvzptWOCL5zqn7lJqymclU/aEgLif+mLvj+nXzQ/7pNQgiaHUJwaM3
         2fO62/lwdUtRsgOgxKL8KIChNjldAfJiNAJ+kqIRtcHGJ+gwOjrf9tnIarCODpmFZYxk
         /VmCEn+ysHZf/4+Ov1WQQw9ga1wVzXqMwaFVgHiZBZc9TclNld8M26GMdlAsFY8QKXnI
         ys3iF2BXQleEzmQ1csYfkbcFcruPlmWDITwfIN0mJjlYU/hantcfhxU9MMz78yISCpi0
         rPYA==
X-Forwarded-Encrypted: i=1; AJvYcCUU6V1oEukVmG1tzZhFV8hPgYPYyUPkUh2zi7dXXh1ORRRUoQcd/+8Tq2OV6lWLeMPlLnisyVY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuX7uRonwxAIanyKVjYcbHRi0b6zBrV+1tnp8PhrLCzVeyr5zD
	Q3PRnPq0xHqDKuH0FbaocXGiqvSMSvn1KAxvYrTBZHDkZTiWMJiOsvqYy33A6EN9oXy3GoIjmyU
	XR3wDlg==
X-Google-Smtp-Source: AGHT+IFQyKC+fuYoxxZ60HlL1zbUz9ZwG4ryuK7MxSum1tmaUoFCTmYa27wuTrzB35IdSIo2hT+LP8d31ms=
X-Received: from pfmm18.prod.google.com ([2002:a05:6a00:2492:b0:748:4f7c:c605])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2ea6:b0:747:ee09:1fdf
 with SMTP id d2e1a72fcca58-7489cf6aaf9mr933541b3a.4.1749846934794; Fri, 13
 Jun 2025 13:35:34 -0700 (PDT)
Date: Fri, 13 Jun 2025 13:35:33 -0700
In-Reply-To: <20250611133330.1514028-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-5-tabba@google.com>
Message-ID: <aEyLlbyMmNEBCAVj@google.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Fuad Tabba wrote:
> The bool has_private_mem is used to indicate whether guest_memfd is
> supported.

No?  This is at best weird, and at worst flat out wrong:

	if (kvm->arch.supports_gmem &&
	    fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))
		return false;

ditto for this code:

	if (kvm_arch_supports_gmem(vcpu->kvm) &&
	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))i
		error_code |=3D PFERR_PRIVATE_ACCESS;

and for the memory_attributes code.  E.g. IIRC, with guest_memfd() mmap sup=
port,
private vs. shared will become a property of the guest_memfd inode, i.e. th=
is will
become wrong:

static u64 kvm_supported_mem_attributes(struct kvm *kvm)
{
	if (!kvm || kvm_arch_supports_gmem(kvm))
		return KVM_MEMORY_ATTRIBUTE_PRIVATE;

	return 0;
}

Instead of renaming kvm_arch_has_private_mem() =3D> kvm_arch_supports_gmem(=
), *add*
kvm_arch_supports_gmem() and then kill off kvm_arch_has_private_mem() once =
non-x86
usage is gone (i.e. query kvm->arch.has_private_mem directly).

And then rather than rename has_private_mem, either add supports_gmem or do=
 what
you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the VM=
 type.

> Rename it to supports_gmem to make its meaning clearer and to decouple me=
mory
> being private from guest_memfd.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)

This missed the usage in TDX (it's not a staleness problem, because this se=
ries
was based on 6.16-rc1, which has the relevant code).

arch/x86/kvm/vmx/tdx.c: In function =E2=80=98tdx_vm_init=E2=80=99:
arch/x86/kvm/vmx/tdx.c:627:18: error: =E2=80=98struct kvm_arch=E2=80=99 has=
 no member named =E2=80=98has_private_mem=E2=80=99
  627 |         kvm->arch.has_private_mem =3D true;
      |                  ^
make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1
