Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FAF172BA9
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 23:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900179; cv=none; b=QIuFUvnHPuSicAHlt8usXJN5ErrwdvfabG+2v07LPOoLyrWj525bot53+H6pR9972OChDQG87pURsspnSlPMheUcpUuGdb6CvT1ELp6VkoSKBRgAOkVII8eZZqCVSadjQqSkLeNPm6rCu2klnU1UK+1hnhGuFtQ3wR99zvc/L7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900179; c=relaxed/simple;
	bh=lnV0jTwl7I7N5aiPuuu9PVE+w5Wngmq6yvhGhBmjrvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ReWZT2SEttUIG70LweuS+Gz0B7RjsGkNnxCAGxYYMM7TV0U6KMWgylg5f7D1UvlhPPj6wuyM6eLaAgM9DOD93LnqaXuHZByaAIduBlCiI0BYIOQoxAwug3rLIn11MMx5+03uPKHPp5MLZ4W2Mckv+8DjmnWNMKDlQGFAMJwfKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4EdCbKLK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4EdCbKLK"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ad78c1a019so229278a12.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 16:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900176; x=1723504976; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZqhT0BfYtdHqe5JEJY1dxcglZN0X6+UEhtDWxpbx9R0=;
        b=4EdCbKLK5DpxYdxOAcf04YnU5LBMhSJqxGgNJpEY9G+RLAlBXxFOb2hWkhTWbYLUHN
         1NrxhA4jJ6UVlrAUiUI972+XwY/P7amMpXlSUprVfzJOzYwtQJrvFGYT1F8y2abQeuQR
         aSWQe3XsOSl/tRw37VOfNYvkga0NXwbkE8cTQAAajVvDIBaCdh2uf9rSLbyZUQn2W/Ct
         NxlxCfRWC84L6FEpb1aI1c0/JMu7M+pPWGO81IBp6GVcv0gRrOHR18kqNWuo/LJgFR+e
         WyYscB0ZQ7uFTH8K9Ip/HfnPvu/huYSX7CBS7hnYKvrWx1MITwaiz9d6Bvn9Gxit3Snk
         tdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900176; x=1723504976;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZqhT0BfYtdHqe5JEJY1dxcglZN0X6+UEhtDWxpbx9R0=;
        b=XNuscAFe0m0cCE83OelBQcrb2eVs/GH+YcQ/3fKbt94U7Ds3g9a6BkIgr5jPdfxqab
         cOaiP+yKQfQzLQVda8vDW+ms75TtFHsKleCXL1kcL9tdAQAi69il/vfgAJ6KDTEUF73c
         gZIKqo7ksQmcXqfHJAZoIu3dbpGjEEq8q9Xu2QhZnS6aoJKuUGyu1WXwTWdRfs/tGqzv
         qPVhoRiNq4ahLncWEztAxgJ3YK1ZBT/qd8qnGOd6loPCEyePygIeVwSvpEoROtFQQI/m
         8zRD6FYh5t6tEVxzSZz7iz1exS+te6DMc+NHZOs+VJ05acc4hzEE9G3+iLSJz88gmlAz
         zEVg==
X-Forwarded-Encrypted: i=1; AJvYcCXwZmY3WOw3iBLIQos0KR80S+bneSjBn8AhJu3ctPUTrUVDVYdZG40Qa58L7JXyGSc/RjQyQ2TVNfM9IrtB2SPmPERwt3l7
X-Gm-Message-State: AOJu0YzjBlGNI9r50eEfPVxWPD37lwyhUHleUiI/PRv6khoUQBV74Not
	bYrjA0RiTI4RSzFK1i0bGW/dUqoNv9ZzsD9CLk2z7UyWPEBOvhC1Qs4N61LDFvMq5BqoUehp09z
	aQQ==
X-Google-Smtp-Source: AGHT+IFnC2s9xgJUYrQamoHpNNjMdfjnR6jKC7U3Po3pJ/hHYZ7yn8m2xqR/ZVZ53CGLeUu13/uKbBw5g2Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dacd:b0:1fb:325d:2b62 with SMTP id
 d9443c01a7336-1ff57464ba5mr9382545ad.10.1722900176428; Mon, 05 Aug 2024
 16:22:56 -0700 (PDT)
Date: Mon, 5 Aug 2024 16:22:54 -0700
In-Reply-To: <345d89c1-4f31-6b49-2cd4-a0696210fa7c@loongson.cn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-65-seanjc@google.com>
 <a039b758-d4e3-3798-806f-25bceb2f33a5@loongson.cn> <Zq00OYowF5kc9QFE@google.com>
 <345d89c1-4f31-6b49-2cd4-a0696210fa7c@loongson.cn>
Message-ID: <ZrFezgVbCI3DRQH3@google.com>
Subject: Re: [PATCH v12 64/84] KVM: LoongArch: Mark "struct page" pfns dirty
 only in "slow" page fault path
From: Sean Christopherson <seanjc@google.com>
To: maobibo <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 03, 2024, maobibo wrote:
> On 2024/8/3 =E4=B8=8A=E5=8D=883:32, Sean Christopherson wrote:
> > On Fri, Aug 02, 2024, maobibo wrote:
> > > On 2024/7/27 =E4=B8=8A=E5=8D=887:52, Sean Christopherson wrote:
> > > > Mark pages/folios dirty only the slow page fault path, i.e. only wh=
en
> > > > mmu_lock is held and the operation is mmu_notifier-protected, as ma=
rking a
> > > > page/folio dirty after it has been written back can make some files=
ystems
> > > > unhappy (backing KVM guests will such filesystem files is uncommon,=
 and
> > > > the race is minuscule, hence the lack of complaints).
> > > >=20
> > > > See the link below for details.
> > > >=20
> > > > Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gma=
il.com
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >    arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
> > > >    1 file changed, 10 insertions(+), 8 deletions(-)
> > > >=20
> > > > diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > > > index 2634a9e8d82c..364dd35e0557 100644
> > > > --- a/arch/loongarch/kvm/mmu.c
> > > > +++ b/arch/loongarch/kvm/mmu.c
> > > > @@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu =
*vcpu, unsigned long gpa, bool writ
> > > >    		if (kvm_pte_young(changed))
> > > >    			kvm_set_pfn_accessed(pfn);
> > > > -		if (kvm_pte_dirty(changed)) {
> > > > -			mark_page_dirty(kvm, gfn);
> > > > -			kvm_set_pfn_dirty(pfn);
> > > > -		}
> > > >    		if (page)
> > > >    			put_page(page);
> > > >    	}
> > > > +
> > > > +	if (kvm_pte_dirty(changed))
> > > > +		mark_page_dirty(kvm, gfn);
> > > > +
> > > >    	return ret;
> > > >    out:
> > > >    	spin_unlock(&kvm->mmu_lock);
> > > > @@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu=
, unsigned long gpa, bool write)
> > > >    	else
> > > >    		++kvm->stat.pages;
> > > >    	kvm_set_pte(ptep, new_pte);
> > > > -	spin_unlock(&kvm->mmu_lock);
> > > > -	if (prot_bits & _PAGE_DIRTY) {
> > > > -		mark_page_dirty_in_slot(kvm, memslot, gfn);
> > > > +	if (writeable)
> > > Is it better to use write or (prot_bits & _PAGE_DIRTY) here?  writabl=
e is
> > > pte permission from function hva_to_pfn_slow(), write is fault action=
.
> >=20
> > Marking folios dirty in the slow/full path basically necessitates marki=
ng the
> > folio dirty if KVM creates a writable SPTE, as KVM won't mark the folio=
 dirty
> > if/when _PAGE_DIRTY is set.
> >=20
> > Practically speaking, I'm 99.9% certain it doesn't matter.  The folio i=
s marked
> > dirty by core MM when the folio is made writable, and cleaning the foli=
o triggers
> > an mmu_notifier invalidation.  I.e. if the page is mapped writable in K=
VM's
> yes, it is. Thanks for the explanation. kvm_set_pfn_dirty() can be put on=
ly
> in slow page fault path. I only concern with fault type, read fault type =
can
> set pte entry writable however not _PAGE_DIRTY at stage-2 mmu table.
>=20
> > stage-2 PTEs, then its folio has already been marked dirty.
> Considering one condition although I do not know whether it exists actual=
ly.
> user mode VMM writes the folio with hva address firstly, then VCPU thread
> *reads* the folio. With primary mmu table, pte entry is writable and
> _PAGE_DIRTY is set, with secondary mmu table(state-2 PTE table), it is
> pte_none since the filio is accessed at first time, so there will be slow
> page fault path for stage-2 mmu page table filling.
>=20
> Since it is read fault, stage-2 PTE will be created with _PAGE_WRITE(comi=
ng
> from function hva_to_pfn_slow()), however _PAGE_DIRTY is not set. Do we n=
eed
> call kvm_set_pfn_dirty() at this situation?

If KVM doesn't mark the folio dirty when the stage-2 _PAGE_DIRTY flag is se=
t,
i.e. as proposed in this series, then yes, KVM needs to call kvm_set_pfn_di=
rty()
even though the VM hasn't (yet) written to the memory.  In practice, KVM ca=
lling
kvm_set_pfn_dirty() is redundant the majority of the time, as the stage-1 P=
TE
will have _PAGE_DIRTY set, and that will get propagated to the folio when t=
he
primary MMU does anything relevant with the PTE.  And for file systems that=
 care
about writeback, odds are very good that the folio was marked dirty even ea=
rlier,
when MM invoked vm_operations_struct.page_mkwrite().

The reason I am pushing to have all architectures mark pages/folios dirty i=
n the
slow page fault path is that a false positive (marking a folio dirty withou=
t the
folio ever being written in _any_ context since the last pte_mkclean()) is =
rare,
and at worst results an unnecessary writeback.  On the other hand, marking =
folios
dirty in fast page fault handlers (or anywhere else that isn't protected by
mmu_notifiers) is technically unsafe.

In other words, the intent is to sacrifice accuracy to improve stability/ro=
bustness,
because the vast majority of time the loss in accuracy has no effect, and t=
he worst
case scenario is that the kernel does I/O that wasn't necessary.
