Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5661ABEAF
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722627133; cv=none; b=TbQmEJNOchSx+ui/cF44vMQPvWe6ZSTNixgj8FzNin5iszIA9D4qLCrdBDiCvhiBxIV/KwIf4c/LC1IjE0WmCgaCS8htCOLIRUDLEf9g5s8FdXtS6A5ra+3A0lIl9Hh/StXJQ19KPLHT5ZFSxn8pJ/4HLld8Hi05hOsEzAv65vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722627133; c=relaxed/simple;
	bh=csd0MkbfiRZ32mkpXZ9twM9kRQL1vy8OM+kdMsU6aRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=crJAAE4gOgeMtKEnD5PNvyI+hxx4KBvcGuifyT+88g8GjBDIKP4iaQsRUFqKXp9f6x8oODuBMQECw9pWMs858rV+cYGGd4rXLomW2IGBHdX6yZSM0Wr0Te9lwp/flPG1Vd22fmnr7hIoGGVDERIK9ghFO+hGHuDJ3cChpUrROH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iNmJ+tal; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNmJ+tal"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cfe9270d82so2854032a91.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 12:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722627130; x=1723231930; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTqa7oavJrWkxSTFWtVmMnGsBDrmN4Dgl5PSeoZtRS0=;
        b=iNmJ+talcLKvuEHChjLnAk72W65Z9sdjrj8B3sFMPPDTx6js2H94XAp9aFOpyxNOJx
         pe8HbMqzjT1wfVn6uOkA8gfQ1pFFM+U4Seg9LsTgI9vW+hlzBj4gNOvNa0ktNXxy57XI
         kOuyOI7mhUFZIbdPbcKhXFXnu2yC1c9yMHZsS15MlnCrDiPEwYFD7eEUA+51nlBwgE6r
         DA9ET2i7HN3WQwrOdKzPtvL20dx5sORUmp3bvQp0VN4P5s9ZjfYphKE45csPdiW9CMgL
         ojl1fs0hDJX5fjr/qP6f4E9Typ8+U8gYCLrWtaEhGECr8SPoTx8WbBDAqmpSLVQGRA1x
         LwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722627130; x=1723231930;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TTqa7oavJrWkxSTFWtVmMnGsBDrmN4Dgl5PSeoZtRS0=;
        b=dndWPpSus2wf3bFFlJ69GnHiNdK0Ppljdlig7+JM5X1aLv3Ai+ULS/cgzD1Q7Br32p
         8eLifXqjtHmW4ZnicQOKKgSLIB+zraQjpnATXSPO87eVs27/CrDTxvH/jTFbC7ujQXC5
         10Lu7G2yB+LCo98F1msJTVj6yqN+kATaFyV3dsn3DdLSoP7daX/jT1ENNdAhEcY7GHSh
         fEDIkherzEH/8s8GonoRpwRcczwfh5i7da0epUQ/6iSbtWeV9tPSTUFsQcd339KgF8k8
         veAPfQZz+aQ05BAysjrMC4iCOiA2KoA8vimDBcE5DjqHANousOPAYY2LjvtZeK9Jatsk
         3jzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhxQKWLG9ucAB1bPNTXySOQPlOOgkD2yXemlWhvQLLUdrEdVdJRFNmZwoJpDLlZVSshQJLUSfd3ssEhqkjuRGd+oGHGhhI
X-Gm-Message-State: AOJu0Yz7QHykZFksnNGe6Ib3Yk0hTOJKF0loNhdkqsrrd6CCxvbqEaCz
	BI1KSs/Y+qutL9k5V2zL/8tFgKK04TYmyks4QDB8V2JzawCdUFVzII4RM17PMxWjdgg9gotpKqT
	bew==
X-Google-Smtp-Source: AGHT+IHxpD4UvI3cH5YcMAfSn5X/q5FbzhvcZwiTnoiXfWEKupcq/mKgFqqrl+E4nqq+ftOi/sOAAYuzYXs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:50cf:b0:2c9:61f9:9b27 with SMTP id
 98e67ed59e1d1-2cff9526286mr68117a91.5.1722627130434; Fri, 02 Aug 2024
 12:32:10 -0700 (PDT)
Date: Fri, 2 Aug 2024 12:32:09 -0700
In-Reply-To: <a039b758-d4e3-3798-806f-25bceb2f33a5@loongson.cn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-65-seanjc@google.com>
 <a039b758-d4e3-3798-806f-25bceb2f33a5@loongson.cn>
Message-ID: <Zq00OYowF5kc9QFE@google.com>
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

On Fri, Aug 02, 2024, maobibo wrote:
> On 2024/7/27 =E4=B8=8A=E5=8D=887:52, Sean Christopherson wrote:
> > Mark pages/folios dirty only the slow page fault path, i.e. only when
> > mmu_lock is held and the operation is mmu_notifier-protected, as markin=
g a
> > page/folio dirty after it has been written back can make some filesyste=
ms
> > unhappy (backing KVM guests will such filesystem files is uncommon, and
> > the race is minuscule, hence the lack of complaints).
> >=20
> > See the link below for details.
> >=20
> > Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.c=
om
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
> >   1 file changed, 10 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > index 2634a9e8d82c..364dd35e0557 100644
> > --- a/arch/loongarch/kvm/mmu.c
> > +++ b/arch/loongarch/kvm/mmu.c
> > @@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcp=
u, unsigned long gpa, bool writ
> >   		if (kvm_pte_young(changed))
> >   			kvm_set_pfn_accessed(pfn);
> > -		if (kvm_pte_dirty(changed)) {
> > -			mark_page_dirty(kvm, gfn);
> > -			kvm_set_pfn_dirty(pfn);
> > -		}
> >   		if (page)
> >   			put_page(page);
> >   	}
> > +
> > +	if (kvm_pte_dirty(changed))
> > +		mark_page_dirty(kvm, gfn);
> > +
> >   	return ret;
> >   out:
> >   	spin_unlock(&kvm->mmu_lock);
> > @@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, un=
signed long gpa, bool write)
> >   	else
> >   		++kvm->stat.pages;
> >   	kvm_set_pte(ptep, new_pte);
> > -	spin_unlock(&kvm->mmu_lock);
> > -	if (prot_bits & _PAGE_DIRTY) {
> > -		mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +	if (writeable)
> Is it better to use write or (prot_bits & _PAGE_DIRTY) here?  writable is
> pte permission from function hva_to_pfn_slow(), write is fault action.

Marking folios dirty in the slow/full path basically necessitates marking t=
he
folio dirty if KVM creates a writable SPTE, as KVM won't mark the folio dir=
ty
if/when _PAGE_DIRTY is set.

Practically speaking, I'm 99.9% certain it doesn't matter.  The folio is ma=
rked
dirty by core MM when the folio is made writable, and cleaning the folio tr=
iggers
an mmu_notifier invalidation.  I.e. if the page is mapped writable in KVM's
stage-2 PTEs, then its folio has already been marked dirty.
