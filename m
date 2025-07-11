Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EC32E0939
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243507; cv=none; b=GE8sQ+9fbeyqvHYNREph+VwyB6lPAqlIAQZHe8Jd/LZeSLUMPoIpVghDYhe8eKdRfvPKG5/MqNVrnNhK+bsXoXJs1A9oBVKGFWN7zv9LNYdPDeTGIJQEY9cRPQfhueb/FzLyAyQZYvnj6w38q9lKOvL3pTwwlBsVdqvFYWIRxXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243507; c=relaxed/simple;
	bh=EeHQX3xHa/SasShpS2hysO5j+FP/KZl3ZrefBTI2Wdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fa+fig8PwWGQf5oHe8TDEY5Zc1O1cc8AsX5lDAaunsxzAqFQCJgROU+apInNowX3CMPquIncLsFrCLqGC/mwL67DVXZ6LNv46kjF700A3iEgjyLLmHzEgGOuGKvL/Kds+B2iCSgqs9CssXNNTpBPX7F09k3SdvVEw1OeiylFv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foVDRHSK; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foVDRHSK"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso138201cf.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 07:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752243504; x=1752848304; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SPqXh8MG6l1A7ppi1PWLeVr8JkzkP6r8TXr4WFndhco=;
        b=foVDRHSKDHGWmNDF/8bOHJj+Klha4Eg4REv+SWCJKpdTTiZtf6fvXPbu+1wNUAWmZ9
         6VYJEWQqdGKRvehHmIi5qT8kX7Vbbzr69ty8NcmUubltRY7BvNDqK+5gvLyDr3E2J++r
         W1cAgtBdgXPsuyJe0vyPO9sROAxSlIkxZlwWV/mcGJa6vnD00hx839iV8VrF86smPF4n
         3cY3DqzhOCoeRMGgteCyi7furnddqdThodsyhQOEg1oNPE2+sAm4eQwCIhPdZSVADlec
         BO6dzImCjBXKfcBr/kbQK6pAbM0eBZ2OtAkZOZTqBb/cxloExAbdSoYB/VXP0r3w4AL1
         XEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752243504; x=1752848304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SPqXh8MG6l1A7ppi1PWLeVr8JkzkP6r8TXr4WFndhco=;
        b=CayWwkrlgxgXe0DR+xqSCML/H8yxoeVbNQZfeO7N2J9FFUSt+HB+/PkccJ7laoWRZr
         5d6N+psT/HFQIKgM01kC7kjxX1gSOl2vuA6bMoCN7U4uNVUU9SujwAoqvWpLaPxSaZkO
         N7ZRVJq5axNgapKLqx4I6O2s4FdN5OWcROVjMmTRxZ9qXqYKd8TyAPJ9OslJ1S2wtUPL
         LetdvZrs9FmkLCR6ryiDfw/6rgxwju+C4qdqCgWXNvtRuXfzCR97Jvz5lRFF2SYjVBId
         ezq0cHssEHaoE2RCxL5ip3gjIdNVPRxfxSu4GWllSS/Axd2rVCdROXtYLfs8fkMYAEOi
         Hlyw==
X-Forwarded-Encrypted: i=1; AJvYcCWhW6N83EYJozt0JdZI/oUOxaZRwYII4XqspSmSAfk7hryRsLFeD3RrTdgZOv66pKluzxBK67s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE6JlyG96DHwj4xZDnVWlLaXAkhDwIqr/nlEcehNfEdPL/Yt0L
	PF8AuIBKXp2sumzNojZ9SyVztbJyjARrzz8s7/J1alKVwU5+uubXv9i9Z1+4XSCJ1wQOWoSzOcO
	5sLcpQD4YQuLDmFntvLkT35DcforRv3ZJKx9ObMhE
X-Gm-Gg: ASbGncumpttij8KJExsJ5mtqbyD2Cxq15e8HyZUlSB6jsATBreiG0XgZj3eZh9cBGdK
	gWSRL9r5Eakfa/D/XOFb8kQ4+0okH62rVT5vowQ1AS8vIYeaGC3gw2FV4WDHbMexh08bPMYa1tJ
	NrPfZan1KKXucUkSqM3ysXlNV4dsXS/YOjCdb8hPbpXhBPt7wtnh8jMZknlWiLiL1S3NKpEd0U+
	0Bn+PQ=
X-Google-Smtp-Source: AGHT+IFB29LZRp6S9EJ4JwmCmEMzaf7JXF7ZrEyQ3VcuzP+ZF9XJDCj3TztBCcGyfvrNcJcm+eOBHyX3XQUVn4sD0j4=
X-Received: by 2002:a05:622a:49:b0:4a9:d263:d983 with SMTP id
 d75a77b69052e-4a9fbf49438mr3728031cf.22.1752243503244; Fri, 11 Jul 2025
 07:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250709105946.4009897-17-tabba@google.com> <20250711095937.22365-1-roypat@amazon.co.uk>
 <86a55aalbv.wl-maz@kernel.org>
In-Reply-To: <86a55aalbv.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 15:17:46 +0100
X-Gm-Features: Ac12FXwgQHu30_kYr5OEcOlHvsbWxMi7kgse2dUFQjfHWptAQiWGsqT7tOy6s0Q
Message-ID: <CA+EHjTz-MWYUKA6dbcZGvt=rRXnorrpJHbNLq-Kng5q7yaLERA@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Marc Zyngier <maz@kernel.org>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
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
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "mic@digikod.net" <mic@digikod.net>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
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

Hi Marc,

On Fri, 11 Jul 2025 at 14:50, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 11 Jul 2025 10:59:39 +0100,
> "Roy, Patrick" <roypat@amazon.co.uk> wrote:
> >
> >
> > Hi Fuad,
> >
> > On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > > +
> > > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > +                     struct kvm_s2_trans *nested,
> > > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > > +{
> > > +       bool write_fault, exec_fault, writable;
> > > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > +       struct page *page;
> > > +       struct kvm *kvm = vcpu->kvm;
> > > +       void *memcache;
> > > +       kvm_pfn_t pfn;
> > > +       gfn_t gfn;
> > > +       int ret;
> > > +
> > > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (nested)
> > > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > > +       else
> > > +               gfn = fault_ipa >> PAGE_SHIFT;
> > > +
> > > +       write_fault = kvm_is_write_fault(vcpu);
> > > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > +
> > > +       if (write_fault && exec_fault) {
> > > +               kvm_err("Simultaneous write and execution fault\n");
> > > +               return -EFAULT;
> > > +       }
> > > +
> > > +       if (is_perm && !write_fault && !exec_fault) {
> > > +               kvm_err("Unexpected L2 read permission error\n");
> > > +               return -EFAULT;
> > > +       }
> > > +
> > > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > > +       if (ret) {
> > > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > > +                                             write_fault, exec_fault, false);
> > > +               return ret;
> > > +       }
> > > +
> > > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > > +
> > > +       if (nested)
> > > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > > +
> > > +       if (writable)
> > > +               prot |= KVM_PGTABLE_PROT_W;
> > > +
> > > +       if (exec_fault ||
> > > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > > +            (!nested || kvm_s2_trans_executable(nested))))
> > > +               prot |= KVM_PGTABLE_PROT_X;
> > > +
> > > +       kvm_fault_lock(kvm);
> >
> > Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> > E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> > gmem invalidation occurs, don't we end up with stage-2 page tables
> > refering to a stale host page? In user_mem_abort() there's the "grab
> > mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> > after grabbing mmu_lock" which prevents this, but I don't really see an
> > equivalent here.
>
> Indeed. We have a similar construct in kvm_translate_vncr() as well,
> and I'd definitely expect something of the sort 'round here. If for
> some reason this is not needed, then a comment explaining why would be
> welcome.
>
> But this brings me to another interesting bit: kvm_translate_vncr() is
> another path that deals with a guest translation fault (despite being
> caught as an EL2 S1 fault), and calls kvm_faultin_pfn(). What happens
> when the backing store is gmem? Probably nothin

I'll add guest_memfd handling logic to kvm_translate_vncr().

> I don't immediately see why NV and gmem should be incompatible, so
> something must be done on that front too (including the return to
> userspace if the page is gone).

Should it return to userspace or go back to the guest?
user_mem_abort() returns to the guest if the page disappears (I don't
quite understand the rationale behind that, but it was a deliberate
change [1]): on mmu_invalidate_retry() it sets ret to -EAGAIN [2],
which gets flipped to 0 on returning from user_mem_abort() [3].

[1] https://lore.kernel.org/all/20210114121350.123684-4-wangyanan55@huawei.com/
[2] https://elixir.bootlin.com/linux/v6.16-rc5/source/arch/arm64/kvm/mmu.c#L1690
[3] https://elixir.bootlin.com/linux/v6.16-rc5/source/arch/arm64/kvm/mmu.c#L1764

Cheers,
/fuad


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
