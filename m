Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1121F12F4
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752232175; cv=none; b=EXC6f5EhPbio1PGAir8ZcpnKMDCu+76E057AmM0pjPCkYSclaH78zeGngDjZ5NlnYzkvgwD5dRBaOkfWovoCBueHuQPWQ/pJtA76uy2kw+S9el9N4IF1xZJ8KxyOY5j961xvopjj02HQVZFqUq58WYRHR/Dbj/TMI9WUfIgHAn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752232175; c=relaxed/simple;
	bh=pEbsbZRW72uqAMiY+GWSPB3tnRE4dYbX0ZSg/zik3CM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GbX61n8GWBx6/7Y4/QPPPP2waiNobztV5lOFQgRHnVbslWEaVXR65lwyJqWCzx9JtR8m13BbLABXKlj+Zzu2SOzqAuWyio98aOK3lltgB1ABbIwUifnCAwUNqT8IHfqiaubkSr4SWH2lErf3LhcfMHZ2N9MX48Mr6bNhVD+PSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SsPGcWR8; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SsPGcWR8"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso98631cf.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 04:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752232173; x=1752836973; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YtL2RY30FqQCse8pZRhypsMK1Ug1daCGyP2jBjuiKck=;
        b=SsPGcWR8ArSftSbK2aEJz8VYQj0oP6y0cIfjdrEIOgc+Lg+3ZjNk2iDrhgAxyp5Wr6
         dz1r2TQSw3dee0GvRLWy19jPn05ZwgBYDkEfdcTVQinQ4QvilwtABLo2qvFjT3w3W7X6
         nNXvTqmW9/olrpch8Et5JcP/7XFlx9D70aQeJB2SPBq7T4eGd7OIPUmRXOtxqvyxunrb
         DoKo1mE59dX2zgf8Xg1GX4qRqpcGNPanklGRblL6iUMdtQG67T4++tC7lMbBtl3adaSg
         1/ubQbEiFo0wInNIbRnumENoXmmDkK+EotAFrgFXE9KV/J+zAkv8D4mESN52qW6hwire
         JQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752232173; x=1752836973;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtL2RY30FqQCse8pZRhypsMK1Ug1daCGyP2jBjuiKck=;
        b=KofNVXZleJT2L622GzLzQPVCwGuld9KsStOqF3mnGgxeER/pJcSBmgP7z9LkL8HRvK
         12DtdOcAYrAzA73ID5uhcESKmmhTr9FQNjAe99PJ9oiiTrbODJu2+yycPs8cLEbk0dH+
         1huvL3uxIX78U0rpS2NpdhcEz0UST1N80A48AsHkQRkqO+XsnSpt+bbkiGpc3vW/SJ2l
         3YlxGHPz18Zm+ecITbWNPVhxh8rX5QjSAMk2FrDsOc80qnUSSE3BqRGVMp0X+ISbG1t7
         txpoexloE4UWfHqhU27Afj2jqV7szdf+g3gJZ3ItJkFZ3o2i7wIyCPO1GJPVad3+F/cF
         npPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOAGgH5FVxJmlRBUQdMo+z0map8K7jjK08f4d5pqI20JTtKh5KNb3gAv7AZZr16fxfHg+15u0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYt963WsYIRIWp1lRW9+LcWWHIzrE+1+G8ulz7FXDom5WA5aFe
	yEmrqG/2DjGszE9Bab6SL5Pf1XPD0U9QaXDDxLRmcpzz7trUN3Rk10U9iTBR8erGvi8Q+fMIjX1
	FMXwRZeQp5dPQTWPp4mp9Kph0pIvdE1ZzgV4xx5lF
X-Gm-Gg: ASbGncsyIJwA7uETgrDHSAUYXuN/M/mMscnKlwDM7LYDDIp3gAEURxK3BdpH69F2ncn
	ujZFUFYCntieW6PnToj07OwBrGrMJhN6xFpV8fFA76GKw+nFN74gA/eYCS+AwdVhtgAuJxYg883
	5hFdR9JpockBkClTTqqKid0FE5WX9Scvp6nW7InE+Kw0Ky8zxA5bCCI7T6UeTB4+lrt1lgMwA8f
	jIdvRxG89SWYjjlsA==
X-Google-Smtp-Source: AGHT+IERmXIWH70IswPePcnTHu8w/geAIcWqwjz0lTJocB7rOcnLO6OtVHZyap867obl3kpAHCdb6bS3TpHBmI7izYE=
X-Received: by 2002:ac8:7d4e:0:b0:4a5:9af6:8f84 with SMTP id
 d75a77b69052e-4a9fbe8344fmr3522001cf.14.1752232172426; Fri, 11 Jul 2025
 04:09:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250709105946.4009897-17-tabba@google.com> <20250711095937.22365-1-roypat@amazon.co.uk>
In-Reply-To: <20250711095937.22365-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 12:08:55 +0100
X-Gm-Features: Ac12FXy7m-zlvbmjUHarQqtRk7cRzn7RmdIcZj367UfAD88hqnMBvOGnU1eJgFc
Message-ID: <CA+EHjTz8nC-_904=N==B=SJ0sb8AV047LbnA8x6gqZr3cRONPQ@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com" <fvdl@google.com>, 
	"hch@infradead.org" <hch@infradead.org>, "hughd@google.com" <hughd@google.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "maz@kernel.org" <maz@kernel.org>, 
	"mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com" <wei.w.wang@intel.com>, 
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com" <yilun.xu@intel.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,


On Fri, 11 Jul 2025 at 10:59, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
>
> Hi Fuad,
>
> On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                     struct kvm_s2_trans *nested,
> > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +       bool write_fault, exec_fault, writable;
> > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +       struct page *page;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       void *memcache;
> > +       kvm_pfn_t pfn;
> > +       gfn_t gfn;
> > +       int ret;
> > +
> > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (nested)
> > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +       else
> > +               gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +       write_fault = kvm_is_write_fault(vcpu);
> > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +       if (write_fault && exec_fault) {
> > +               kvm_err("Simultaneous write and execution fault\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       if (is_perm && !write_fault && !exec_fault) {
> > +               kvm_err("Unexpected L2 read permission error\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +       if (ret) {
> > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                             write_fault, exec_fault, false);
> > +               return ret;
> > +       }
> > +
> > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > +
> > +       if (nested)
> > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +       if (writable)
> > +               prot |= KVM_PGTABLE_PROT_W;
> > +
> > +       if (exec_fault ||
> > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +            (!nested || kvm_s2_trans_executable(nested))))
> > +               prot |= KVM_PGTABLE_PROT_X;
> > +
> > +       kvm_fault_lock(kvm);
>
> Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> gmem invalidation occurs, don't we end up with stage-2 page tables
> refering to a stale host page? In user_mem_abort() there's the "grab
> mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> after grabbing mmu_lock" which prevents this, but I don't really see an
> equivalent here.

You're right. I'll add a check for this.

Thanks for pointing this out,
/fuad

> > +       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> > +                                                __pfn_to_phys(pfn), prot,
> > +                                                memcache, flags);
> > +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +       kvm_fault_unlock(kvm);
> > +
> > +       if (writable && !ret)
> > +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +       return ret != -EAGAIN ? ret : 0;
> > +}
> > +
> > -snip-
>
> Best,
> Patrick
>
>
