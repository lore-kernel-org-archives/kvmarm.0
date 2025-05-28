Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3F220F37
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748467352; cv=none; b=QAh28YHWYawooi46sO0zJddLTQnMbLhyS6HyVLA6rMx/sIDSMorYsSDhn0TuuA7ijueDDX/5OLqQ/zotvmKI7P85/qOCyd+xGfCUKRGUHxlr0o+BydFE4mN3EXI+v/B6w7s+nvBuQE2pmFen1ck3peDnSbFUHPwQwF14a6Z+9U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748467352; c=relaxed/simple;
	bh=qNcyy5oc4dGI+WJuUIFH9btqQ8mdDTTn5TeXPQS1fq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPgmgVAMxSIxwsOAIVQaxYoeXIy9ea2Wyojzw6jyldDbjLdmy+VdjPAsLfeb5/6ymYWniQZXHp5VIuoFi7kshz58Pf+EH+jCuhDNtWuN8iw6exk2HjfTTr8jgmgPyCFN5HqMg+JQ2ONfNG9F1MaEndGdlHllvoxPWGf8wwVZh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tu8WusHD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tu8WusHD"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311dbea6c10so276521a91.0
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748467350; x=1749072150; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BT+c6zGpxWunPJzCyibqWW9XXWypfHDjrKmTt1TSPms=;
        b=Tu8WusHD99aXyxmghkaN0cv3MlkxQn1BLDnno4dDngc4oSjBGDUmtS0tCPo8Rirsnt
         /9oZUGGqlqvajvyXm4goLSOsj5jKEAAfQNJT1y1FBGHHFU7iTVekBFgM7Qac1av7Jiis
         uyWcnqNb3JxuvaTJXwOjJPBu/Zz+azdiwImkMDrHamTan0IF5XMuRJMeXzraNTfqWBkg
         d+YTkvV3bpsI7DVD1rsjnDeZpOWE/79v2gIiFVrMt3m+rukySwcsx5ncXUOP4OBH+hI6
         wuyFulQFTObWDgxTbFDO4d99RxP7b9yoeCCxVrzCoHxgRggMOumevpq1TuEsV3+XZBKV
         NczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748467350; x=1749072150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BT+c6zGpxWunPJzCyibqWW9XXWypfHDjrKmTt1TSPms=;
        b=YG4HwVDXT6IymNlbJ96HNML0oOFV3Da7PmjVmnfBoqIfl1nY3/yHmOWAOLvPRgM9xS
         d4xqq/GcWZlHRlY+A0e8qvXFH8xDVW+jUBc6rjULnLSAuQV/Mmi/94uKUDn6pvNYcBp+
         BRz7On4IQPEoRuuNBC/WtlwB1cl+9nlv2eHjUXfTawaKBYvHAvJInwgauPOrTcwF6EW5
         +zOEbgJCchB5q451a3bCabqZhY6bv/BMMer/GTkSxButR/NNiLtCF0LbLvCjHxapLFuz
         dD1V4HVMm4fzxlAfSC4/e7bwrkPVSObBzLELtykA9hi3xM1oeTDhru6//RZDtKaP9gPG
         PTNA==
X-Forwarded-Encrypted: i=1; AJvYcCW58wD/kmnfb8gRkCEsffdmKssBsOdie2nBPb6BMREDUq2H+GaeGKkZGBq4VCgfYrcVu58vBLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoRbTPjXJSDhYaLRAxFG5JfSxEtHYsT3/xglXEhCmY4AbMiS8k
	INT2rvN3DndZwChuK4L037ThEK+7fidxuK59NDiENv61g1KsmkW46ESIrn8kBYh54nqRu5o2i3G
	+OykYGw==
X-Google-Smtp-Source: AGHT+IF+NBSwn27LCwHruaYCKMmwinUtCZExXbbsFzSAslFn8KGj0A9s44fdNVHSd+EufkBdd/ISjeqX35w=
X-Received: from pjbrr5.prod.google.com ([2002:a17:90b:2b45:b0:311:b3fb:9f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3510:b0:312:1ae9:152b
 with SMTP id 98e67ed59e1d1-3121ae9232dmr446908a91.23.1748467350549; Wed, 28
 May 2025 14:22:30 -0700 (PDT)
Date: Wed, 28 May 2025 14:22:29 -0700
In-Reply-To: <aDdwXrbAHmVqu0kA@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-6-jthoughton@google.com> <aBqj3s8THH9SFzLO@google.com>
 <aDdwXrbAHmVqu0kA@linux.dev>
Message-ID: <aDd-lbrJAX62UQLn@google.com>
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, Oliver Upton wrote:
> On Tue, May 06, 2025 at 05:05:50PM -0700, Sean Christopherson wrote:
> > > +	if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> > > +	    (change == KVM_MR_FLAGS_ONLY)) {
> > > +		if (old_flags & KVM_MEM_USERFAULT)
> > > +			kvm_mmu_recover_huge_pages(kvm, new);
> > > +		else
> > > +			kvm_arch_flush_shadow_memslot(kvm, old);
> > 
> > The call to kvm_arch_flush_shadow_memslot() should definitely go in common code.
> > The fancy recovery logic is arch specific, but blasting the memslot when userfault
> > is toggled on is not.
> 
> Not like anything in KVM is consistent but sprinkling translation
> changes / invalidations between arch and generic code feels
> error-prone.

Eh, leaving critical operations to arch code isn't exactly error free either :-)

> Especially if there isn't clear ownership of a particular flag, e.g. 0 -> 1
> transitions happen in generic code and 1 -> 0 happens in arch code.

The difference I see is that removing access to the memslot on 0=>1 is mandatory,
whereas any action on 1=>0 is not.  So IMO it's not arbitrary sprinkling of
invalidations, it's deliberately putting the common, mandatory logic in generic
code, while leaving optional performance tweaks to arch code.

> Even in the case of KVM_MEM_USERFAULT, an architecture could potentially
> preserve the stage-2 translations but reap access permissions without
> modifying page tables / TLBs.

Yes, but that wouldn't be strictly unique to KVM_MEM_USERFAULT.

E.g. for NUMA balancing faults (or rather, the PROT_NONE conversions), KVM could
handle the mmu_notifier invalidations by removing access while keeping the PTEs,
so that faulting the memory back would be a lighter weight operation.  Ditto for
reacting to other protection changes that come through mmu_notifiers.

If we want to go down that general path, my preference would be to put the control
logic in generic code, and then call dedicated arch APIs for removing protections.

> I'm happy with arch interfaces that clearly express intent (make this
> memslot inaccessible), then the architecture can make an informed
> decision about how to best achieve that. Otherwise we're always going to
> use the largest possible hammer potentially overinvalidate.

Yeah, definitely no argument there given x86's history in this area.  Though if
we want to tackle that problem straightaway, I think I'd vote to add the
aforementioned dedicated APIs for removing protections, with a generic default
implementation that simply invokes kvm_arch_flush_shadow_memslot().

