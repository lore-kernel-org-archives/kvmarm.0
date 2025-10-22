Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD80934DB7D
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761160129; cv=none; b=BJ9M0litIPDyM5IoHw2ugWenHalUx35syyIKPv/165F3OJ7XFcxJpxkD+bDHxX8kpXcjM6xXkI+1Pq5oAAO3j9V6ORk5ZtSI7wlYw+wWlX6AyzxLMb3f8VL8cSb3LoXBJ5/QtN9jl0/bCvO2yVrFJBbwNCn0NNhZGjI4FdhlOL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761160129; c=relaxed/simple;
	bh=k7EXMNgqSkOA+7R9iYr3lcFkZvZ8bFqZ1wal4qwtUZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GKOdEjr9TEHSYWaDKqkygtOfVayHOkv2+kLeeFrgOtgK1KcB/7iEx0tcefMaVwndKWRPJICXnVBgdFOBnMXx0D7ahhpxdUbXiLrEAE0CxyWlWSf8J3W/KLm9u0D/Vqch7ogsHvCe5Jc4f2mv/1PtpsLgkPTZPDyMs0mNyxR5AV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X1H8d0mJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X1H8d0mJ"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a2743995b2so102462b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 12:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761160127; x=1761764927; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wREzy7rE27X1qKmfXOWprRl7YFBX8aFkFx3LWlFCsNc=;
        b=X1H8d0mJmJfbSsjk5p3z8XhkTtL2Poca2dm1CBT0pYw8t2armrATNxLByJR0bgCGFY
         nGxchRiM9CfRdL2Be3x4pyHzrfbEYOxi5RoJyUBomRChqFnWq1OfC6BVqeDc/K8VSJ7n
         lUcgVkKJDWFxfH6Jf1eI2FWe/TM0OqbfgPlboI2zA4pJAn34vlemD1Z2CG/fKog3HC+I
         D7oV4moul6zHOGGOAHEr7WmBXPUL7/z3JOP+COPuJb5hjOPSQNBu+HFqr947T1Vv/hJU
         cr5e9YEI7SALW9pseuTF9tL09B9kR2KoCDtAoO1bx1+t2hN3hFyAL1RQej3YUNSEhj41
         80Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761160127; x=1761764927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wREzy7rE27X1qKmfXOWprRl7YFBX8aFkFx3LWlFCsNc=;
        b=Ep8/2h2ZOgj+pAVpGNtnYg4NxdpxWQ1r8cE5V+CUUFzGNjMUWNtJUrgfzoATsiYTic
         /CJH7bNKY/AHb1L45hoEQavCeahul+VmWgDEsnjNnPrIZ+Gzfjoou15p3UwoAKKom+Ap
         FENqppCnwBMaXEbWdPCJNdriq0L9zrNC11YZ2HekaKGFv9dOlPAU/MCOt0g4F8wST9wy
         Cau03iXJTHDY6FzdzDS6tmuTvv7tSs4wNXk3/0KUCbH98I2NzaUBlvTk/Dkr01avo6xg
         BZEXSyJchSsuZ+dFZtZoXO5H0FzNSywEXh7doXTmIBZK4evjFY7jYDOZl+sBJ0Ss5KKx
         aCag==
X-Forwarded-Encrypted: i=1; AJvYcCV8sJJGKiLkskH7sbnwE3tOlSR4T5JAl5ZafbFr1K3b43iz5nAJRDRLEAYW+9AP9HX3yTCJpgo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeV1jn/UlXyFsM6PZetO7KJ2HyJQur5Id8QgNcxZxwOrpA7kJ/
	LJI1R+VwuY9K3Ot00VgoRV1bFF9lgU/4wrIUlZQhvRt8LJhYyK9ZwlxllG+Be7uVwwVgcODRY2m
	FGnlW9g==
X-Google-Smtp-Source: AGHT+IG7bMbvOV7PjecaO9CgeAeXZcwC+wb3hcO8vOg4iH6Jor9tS/5vQmEcVRzTkSnVuCY2g2HzBv4NWV8=
X-Received: from pjbpc16.prod.google.com ([2002:a17:90b:3b90:b0:330:9870:9f18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:218a:b0:2e5:c9ee:96fa
 with SMTP id adf61e73a8af0-334a861743bmr28027967637.34.1761160127099; Wed, 22
 Oct 2025 12:08:47 -0700 (PDT)
Date: Wed, 22 Oct 2025 12:08:45 -0700
In-Reply-To: <aPiZ2DEQ6qW5r5rY@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-11-seanjc@google.com>
 <aPiZ2DEQ6qW5r5rY@yzhao56-desk.sh.intel.com>
Message-ID: <aPkrvWcm3JF9WlVd@google.com>
Subject: Re: [PATCH v3 10/25] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Yan Zhao wrote:
> On Thu, Oct 16, 2025 at 05:32:28PM -0700, Sean Christopherson wrote:
> > Opportunistically pass the spte instead of the pfn, as the API is clearly
> > about removing an spte.
> >From my perspective, "remove_external_spte" means removing an external SPTE (not
> a mirror SPTE). So passing in pfn_for_gfn seems reasonable as well.
> 
> Additionally, passing in the pfn eliminates potential concerns about incorrect
> spte content.

No, it just makes bugs harder to debug.  E.g. it doesn't magically guarantee the
@pfn matches the pfn that was mapped into the S-EPT.

> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 48598d017d6f..7e92aebd07e8 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1855,8 +1855,8 @@ struct kvm_x86_ops {
> >  				 void *external_spt);
> >  
> >  	/* Update external page table from spte getting removed, and flush TLB. */
> > -	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > -				    kvm_pfn_t pfn_for_gfn);
> > +	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				     u64 spte);

Thinking more about what "spte" actually tracks, I think I'll rename it to
"mirror_spte".

> Also update set_external_spte?

Ooh, yeah, good call.  And we can use the mirror_spte information to assert that
KVM expects full RWX permissions, e.g. that we aren't creation a security hole by
letting the guest write memory that KVM thinks is read-only (extreme paranoia,
more for documentation purposes).
