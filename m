Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A1C4C85
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749749667; cv=none; b=uVK/E2HOQ21qNsgXuYQALaaFzQGi+wfkqQexp4mUE+8dwptmFpEzbnli3stt3to1GOJC0FTnKKgpyxtejZbxdTBIAd3X7vwl2vu/GRNsRo659ayKsW7mE2AED9WRxdpFMCB5Z/H8fr93o4HNl9tYNi0b+EWV8DFQRAIGMLLos6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749749667; c=relaxed/simple;
	bh=tUQaclW9DMkN0TzMOFrjK9idmQHqc6kQxHKKF2mXtBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npuXNz5FDGD0pNZ0sqtWAmPjD9h8vNRtlmgcFaOQBaBHkcV2AwZ4YviyyIlEZT9VpukKaHbWETI+92mxNOKIxfb4lHqi6cyqdzfGJnoDHxYnlR5Ey+3vGcpykC6jVtXRc9j9Kl8dIz0i07xK/UZjXHofyY2BQKihCsdoEd72JGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lIiLwntu; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lIiLwntu"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e7311e66a8eso1197278276.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 10:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749749663; x=1750354463; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrafqKRYjLIYlVlnQCbScViLttcaCCEtpwvofjO7Z3g=;
        b=lIiLwntudcFVhpz4ryyfm9wPIkAcRXxJ2mWOYLoCDA8/GqSvTvw8SIgABk/VbpOBBt
         fNOPKAXrZeElI7pJFslLs+NGs5lQKQVNVv26doZFq1WqL4tj3wXjOZj3VMSfTvNck3Il
         /V0Ad8z6me9tV2/TeNx9+SM/HX01PTsO8egfu8Up31JCjzsHN0XyYF5VkG0CHJ0F8roe
         DbbWhnRDPcj9y81b4Rf3ERqZ2x9o6FfviRVAHEGdKs/vGjagT2yra1s5Gdo9WX1ZQ56s
         7+34huZBm7sB54jBFXIC0ZSaALrBiHSsS4xF6QhxFWESXXhMgfrubpKJh9UkzTd7w0sf
         hypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749749663; x=1750354463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrafqKRYjLIYlVlnQCbScViLttcaCCEtpwvofjO7Z3g=;
        b=D67BL+1Xa8nzCfc9b4lV5lyBN49Z5a4HdGSdA9NO58nJWAaKfI9CZMwECpb195bOdU
         PSLSBQa5KqddPgViHdGxfBeDoXngDfFufjr7MAoMXPjaP4aJoARpElUHNorpZR5BO7i4
         XKqPitf9Pk8ujjmXIai4xEB/20GyU2VRvX/ZVbU1EEOKVvISI4t/s3yfjV3Gl26vQQda
         nKzfqOmdKo7kpYOfCOMhf0qRIBVarOVAy76QIM3Y3ODUbtpTgug1ycVzovbqK+qqg1MF
         emRVP5jfkYakZOIsKi1SRkx00wIA6vwtpZswt9xMceSQAwdbPRWWerTr7T2mWQxY5rhM
         rAkg==
X-Forwarded-Encrypted: i=1; AJvYcCUaWz5hY/W2gIF2pHtWbLKDYKcvjktzUJ1exvpFiu0chUbwgRp4kGcD4TWYhecMwrQG9pparhA=@lists.linux.dev
X-Gm-Message-State: AOJu0YypqgnKwQlma7Hdx5BMQwmt/9aS+e5IQ/ORr1btO3WVViAC0xbs
	ncjccpnBuaTdY5L4UWSr7lrut/sOIB4fFi7qmgwPGSd2WNaWT4TWm9zp9mq2JHUFXqfuOXVK3sM
	vZYtIG5FSR+XR51Z+zPmm4gac/YYZvVfYPL75AFMu
X-Gm-Gg: ASbGnctGwwGmF//gteCwGomd5FW4/2IeaEawYs7yUrqhIbQwPv7+OQt3Srhjcf7Juvj
	TXhcnz+oc7R3nZ1jg/DJ53imjZjDHLZfTnBEv29XsILxxuKgCrRrHzNTtQYwMEMeJIl8G5WLrxF
	rj+21M9S4o5wk1RNFB3Bs3/S5ZJnOme5ZLSsbiUy6tZj3Z+CCrLa5L0RwPrMTH/LAiyWoU56hFT
	g==
X-Google-Smtp-Source: AGHT+IHNPVWH/wdAnpO1y45I/cUg3DbI1iBJvNgZPDWKkOk4cJBH+ECPTzUrI9HlwvktnMn+hMUL/g6xVT13xGjgqFM=
X-Received: by 2002:a05:6902:844:b0:e81:20c5:cd04 with SMTP id
 3f1490d57ef6-e821aa1bd6cmr629551276.46.1749749663065; Thu, 12 Jun 2025
 10:34:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-15-tabba@google.com>
In-Reply-To: <20250611133330.1514028-15-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 12 Jun 2025 10:33:46 -0700
X-Gm-Features: AX0GCFuVfQClbw8rWB8Zsoe-K68LX2FzWt7lzfa3ax3n8aK0kznpkuCU2qIdi7Q
Message-ID: <CADrL8HXGzxVsBZC0GX044skYXR8thZpDQNcOMZ_+Azp=w-hOoA@mail.gmail.com>
Subject: Re: [PATCH v12 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
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
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 6:34=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Add arm64 support for handling guest page faults on guest_memfd backed
> memslots. Until guest_memfd supports huge pages, the fault granule is
> restricted to PAGE_SIZE.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Thanks Fuad! Hopefully Oliver and/or Marc can take a look at these Arm
patches soon. :)

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 58662e0ef13e..71f8b53683e7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s=
2_trans *nested,
>         *prot |=3D kvm_encode_nested_level(nested);
>  }
>
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT |=
 KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +                     struct kvm_s2_trans *nested,
> +                     struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +       bool write_fault, exec_fault, writable;
> +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT_F=
LAGS;
> +       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> +       struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> +       struct page *page;
> +       struct kvm *kvm =3D vcpu->kvm;
> +       void *memcache;
> +       kvm_pfn_t pfn;
> +       gfn_t gfn;
> +       int ret;
> +
> +       ret =3D prepare_mmu_memcache(vcpu, true, &memcache);
> +       if (ret)
> +               return ret;
> +
> +       if (nested)
> +               gfn =3D kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +       else
> +               gfn =3D fault_ipa >> PAGE_SHIFT;
> +
> +       write_fault =3D kvm_is_write_fault(vcpu);
> +       exec_fault =3D kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +       if (write_fault && exec_fault) {
> +               kvm_err("Simultaneous write and execution fault\n");
> +               return -EFAULT;
> +       }
> +
> +       if (is_perm && !write_fault && !exec_fault) {
> +               kvm_err("Unexpected L2 read permission error\n");
> +               return -EFAULT;
> +       }
> +
> +       ret =3D kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +       if (ret) {
> +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +                                             write_fault, exec_fault, fa=
lse);
> +               return ret;
> +       }
> +
> +       writable =3D !(memslot->flags & KVM_MEM_READONLY);
> +
> +       if (nested)
> +               adjust_nested_fault_perms(nested, &prot, &writable);
> +
> +       if (writable)
> +               prot |=3D KVM_PGTABLE_PROT_W;
> +
> +       if (exec_fault ||
> +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> +            (!nested || kvm_s2_trans_executable(nested))))
> +               prot |=3D KVM_PGTABLE_PROT_X;
> +
> +       kvm_fault_lock(kvm);
> +       ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_S=
IZE,
> +                                                __pfn_to_phys(pfn), prot=
,
> +                                                memcache, flags);
> +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> +       kvm_fault_unlock(kvm);
> +
> +       if (writable && !ret)
> +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> +
> +       return ret !=3D -EAGAIN ? ret : 0;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long =
hva,
> @@ -1536,7 +1608,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
>         struct page *page;
> -       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_HANDLE_FAU=
LT | KVM_PGTABLE_WALK_SHARED;
> +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT_F=
LAGS;
>
>         if (fault_is_perm)
>                 fault_granule =3D kvm_vcpu_trap_get_perm_fault_granule(vc=
pu);
> @@ -1963,8 +2035,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 goto out_unlock;
>         }
>
> -       ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -                            esr_fsc_is_permission_fault(esr));
> +       if (kvm_slot_has_gmem(memslot))
> +               ret =3D gmem_abort(vcpu, fault_ipa, nested, memslot,
> +                                esr_fsc_is_permission_fault(esr));
> +       else
> +               ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, =
hva,
> +                                    esr_fsc_is_permission_fault(esr));
>         if (ret =3D=3D 0)
>                 ret =3D 1;
>  out:
> --
> 2.50.0.rc0.642.g800a2b2222-goog
>
