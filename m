Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0199D274FCB
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 21:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750281467; cv=none; b=tQBPe/MyQ7/E9GosGUh9p3Tm6B5JPyyjnCgkrVDp7OhwOr51FRiVYeaE2GdKzvNkJtCzqp0b9dOnR5bNBrydAIv7m08T01vhmJFaHcirqdySrS9I94bHdEOy4IVSVOcJw/aNAOrcYjhtaR+3q8ip7eecSVqrmc9AjZnzN0KEu9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750281467; c=relaxed/simple;
	bh=CMs2h4kbVtiV15SKFeOJCR6/uSQFgcHkomdTrmd6ICM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XwAqXg15oM19wtsT3Y180OKpF4EoZb6yuc3e9qJLnl2k2CD+TVCK2t6jk9uGTT8FZmO9g9gwa5cGaX337og9x6zrjGG/05As8b4Fskf7IDm0nCjX3QZPshZ4QuMNADobiVwx9J3Et/r6yplKMWJj8b+lFpwoyYLqcIZBV/1welM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icnXsPmd; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icnXsPmd"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394772635dso66650b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 14:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750281465; x=1750886265; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDeX7q/l2+xg1imuGAxKGeggwWOnK+wgg5Zm+bSeJk0=;
        b=icnXsPmddWNqJx8OQvrgqLhYxE3St5osvs5VHGNq29FqknFoiQj2zBYKlPz586vPt5
         rm3gHfylpLoc+5QYYBdBTGk4ffEFPMgNJY09LLeb/9wY9PE/vX8ZjKCHzy0/MVfLhMff
         An22NZVRPdoQOHhcVJzaZCsxs/rI5ZoN13ZVgPAB3P9DqzB/Gltd0rqZhFoYukNdrk85
         GfwopAfuUKKUkTD7s3rkfh3EZFHc05GgzwkM28PpH0BhS8GX7rmwSUofTgR/F096aDyk
         Q/bFgty9/v8aSoN0zH39DrHz6xz+mkebINicLo9fZxz1nRN5ylT7SU4lSWa4bZu428kE
         orZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750281465; x=1750886265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDeX7q/l2+xg1imuGAxKGeggwWOnK+wgg5Zm+bSeJk0=;
        b=g+kcCWzydcGO+5RBMNHZtgxgiz6gP4Rz59/QpDbBGZGFgWhgsFZOvyke3UQ9rWcUQd
         fgpZbES1IhrOF3t5G1GAXhGBIcHvHh2FANrFO5CDO3x8Rr4A4U9IBgYL2ZpNndl/1Vrd
         +yJdi8AfDLfaW3l9L9drP/XrPity03tsrBGw5uuQfpwHwe4Bl+aJ/zZh+Q8GgGMYby+h
         zN5fwBtTbBixKA5zU+qvu1QNz497/ZnDWLrTmzRcpyg7Z4aTMcMcTal0SCfL2gElOF/l
         tWeuDnYjOKuDu8QfsQx6bPJj9bhjTGfro/pfCbUOmdgN9Sqp1Ek73USzZ88PGbooOzJV
         obZg==
X-Forwarded-Encrypted: i=1; AJvYcCVSPCJ1iSKDeMRyrVGyKUv/nAKfuogzNRFr4un4wC2AdaTa5L514HEjVCqAXKO+iGAwlsO52OM=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt1M86oix/RwdSHTyOfb53L5m2UYyt3nPPo8XPKs5aqxF8oNox
	1j8Ra1k4X+J7fYQ/Ec0flke4DjCVnQnup5x4vM/7CL913M/5c9AYxOhObWSqaLlVYpuRzKaMfTX
	wEwRmiw==
X-Google-Smtp-Source: AGHT+IFrMBaSJPDppRsJZ5jvlklOZU4VQzs3tJ3F6qMENhjmoLLRaWLyHwVi7GAyrqStyqYxXS8ZDE6slDQ=
X-Received: from pfbef26.prod.google.com ([2002:a05:6a00:2c9a:b0:747:aac7:7c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3399:b0:21a:e091:ac25
 with SMTP id adf61e73a8af0-21fbd505f24mr32186546637.6.1750281465010; Wed, 18
 Jun 2025 14:17:45 -0700 (PDT)
Date: Wed, 18 Jun 2025 14:17:43 -0700
In-Reply-To: <aFMS4O2TkWN8nexY@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-3-jthoughton@google.com> <aFMS4O2TkWN8nexY@linux.dev>
Message-ID: <aFMs9_GBVsiRmgz7@google.com>
Subject: Re: [PATCH v3 02/15] KVM: arm64: Add "struct kvm_page_fault" to
 gather common fault variables
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

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 04:24:11AM +0000, James Houghton wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Introduce "struct kvm_page_fault" and use it in user_mem_abort() in lieu
> > of a collection of local variables.  Providing "struct kvm_page_fault"
> > will allow common KVM to provide APIs to take in said structure, e.g. when
> > preparing memory fault exits.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  9 +++++++++
> >  arch/arm64/kvm/mmu.c              | 32 +++++++++++++++++--------------
> >  2 files changed, 27 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 6ce2c51734820..ae83d95d11b74 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -413,6 +413,15 @@ struct kvm_vcpu_fault_info {
> >  	u64 disr_el1;		/* Deferred [SError] Status Register */
> >  };
> >  
> > +struct kvm_page_fault {
> > +	const bool exec;
> > +	const bool write;
> > +	const bool is_private;
> > +
> > +	gfn_t gfn;
> > +	struct kvm_memory_slot *slot;
> > +};
> > +
> 
> So this seems to cherry-pick "interesting" values into the structure but

s/interesting/necessary.  I literally grabbed only the fields that were needed
to handle the userfault :-)

> leaves the rest of the abort context scattered about in locals. If we're
> going to do something like this I'd rather have a wholesale refactoring
> than just the bits to intersect with x86 (more on that later...)

Definitely no objection from me.  How about I send a standalone patch so that we
can iterate on just that without James having to respin the entire series (for
changes that have no meaningful impact)?  I'm anticipating we'll need a few rounds
to strike the right balance between what was done here and "throw everything into
kvm_page_fault".  E.g. we probably don't want "vma" in kvm_page_fault.

Hmm, yeah, and I suspect/hope that moving more things into kvm_page_fault will
allow for encapsulating the mmap_read_lock() section in a helper without having
a bajillion boolean flags being passed around.  That would obviate the need to
nullify vma, because it would simply go out of scope.
