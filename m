Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C437059E
	for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756234693; cv=none; b=UEC2vv2A3ZVheEAiajEqOOuWGzb6GGuKMf05lX9eszdvnvQ1jIVW6FCCbiVacFSv9gieUTC8vOznkpVN6rcMeHnqsTKuBhMKH7i/eCjLAlkC2le2DajVo5bYcebBDrksMfupflO+T1AvRmaNOdxEo7/GhGCvN7iKHIbsiVMTIAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756234693; c=relaxed/simple;
	bh=kDpcIIxD2JVz4pEHGDWpKjEw9aLoXw9c1amAhm9tDMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tr607J5Kz2Royhq1oziYo9k9cqzdR2vCLU10jd+MIMNPgQn+myDtuHw2C1GCJWjI0hlknwfRvwZ7bJbYZojs9zYjkLPe0r36SV6fi2pNGoXOMoig080Vys0GwvPd0ciPBt0JBR2PgJoadtEPvphqeN1msdi2mMOHe2/uGboWQeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3vNhh8zY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3vNhh8zY"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3275636daa1so655606a91.0
        for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 11:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756234692; x=1756839492; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HsY3QiK0IbnEstf82hU96UYsRAXIuVACCLqPo2mVzDA=;
        b=3vNhh8zY7OlnJO93LABPkRu1QT90gVDLxkYnAz668VrDLjqDnMgd+dvB4uaAoT1OFy
         Fplt3r3Oe3Y3NBmVYVXnM7Jk2kg/TDnu6R/hV0Cn8mXneTfxHp7kndePlD6DLRDnNwEv
         VvATKbwqMgv8KAVCSGUejT/5wqE8kDLta65hl1ocpfogZ+a8SDBfLiDju0UfP0HC0FZk
         YWP6uS4PFoXZk/16ITpqDt/MIKQT3Pf6en3TdxDHqGmkRu+IhWeVl6TBmsh55TENQ4xV
         ERi1tBqoc/poJu87cwXWcPRbf5V2wQ+Tdj34/4c9OxKX/10ko0vC4CvwlmR7C4Fk2H6H
         2d5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756234692; x=1756839492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HsY3QiK0IbnEstf82hU96UYsRAXIuVACCLqPo2mVzDA=;
        b=bOjSPk2iG+gQN/N8Tp0B6MYFN/j9Ga51NqKpJVrug9y3eUHNEyNHLwGDkqPZSdsy0X
         qQL3hugw1TghD+WXY+F9rAnSizz6XRHQMjHGYl0sXkYprBEfAXHYI20KA5mkl3Lh5TIT
         sViZ82kkxxc4YwRw1zQq97QNAKLZqV1dzo8T1dFVzUQTrx1hUmzCO+hf86mVUtuERAt7
         rB5LkXNBuX6PpjHYAUvh7HalbAUU9+YqQ/jH8hLJH2U57Fq+1xFwzq159rF8gQ48jeT5
         rCey7DC8/Cm3FJZAEXCXTgdJisRrlZfstJYYnGU4MRIAN27sWw5SN5RKfACgliK06d9K
         /3LA==
X-Forwarded-Encrypted: i=1; AJvYcCX5YeVYxT8diO53NRwaAudjOjOpozltRJTrwUYOm93O7pYvbHncfWg5Y+uqhwIv5tkafDR1UP4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi8vuKlbFDroUAJPu0vBGVY/s9t9VSqRlpv9QSD0TkFzuapG06
	5U8+DmrH09PGDiXtDqtpRp5G6et192tPxQXWBHpxAT0elJs8wzqo8U4xlP8KowH/zw50svWQYqE
	aL+1GtQ==
X-Google-Smtp-Source: AGHT+IEbYMyz1OK/7DxpodLpUWaOFW3JDTS/P5ttB89uVykFsbXSvA935+WSo4TPCjtqlt5OUT9tb2npKgM=
X-Received: from pjbst5.prod.google.com ([2002:a17:90b:1fc5:b0:325:b894:3c5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d06:b0:321:87fa:e1f1
 with SMTP id 98e67ed59e1d1-32515ea158cmr20429199a91.22.1756234691802; Tue, 26
 Aug 2025 11:58:11 -0700 (PDT)
Date: Tue, 26 Aug 2025 11:58:10 -0700
In-Reply-To: <aKeeRynpwFTSONfm@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com> <20250821210042.3451147-6-seanjc@google.com>
 <aKeeRynpwFTSONfm@linux.dev>
Message-ID: <aK4DwtuQtzYvRei-@google.com>
Subject: Re: [RFC PATCH 05/16] KVM: arm64: Introduce "struct kvm_page_fault"
 for tracking abort state
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 21, 2025, Oliver Upton wrote:
> Hey Sean,
> 
> On Thu, Aug 21, 2025 at 02:00:31PM -0700, Sean Christopherson wrote:
> > Add and use a kvm_page_fault structure to track state when handling a
> > guest abort.  Collecting everything in a single structure will enable a
> > variety of cleanups (reduce the number of params passed to helpers), and
> > will pave the way toward using "struct kvm_page_fault" in arch-neutral KVM
> > code, e.g. to consolidate logic for KVM_EXIT_MEMORY_FAULT.
> > 
> > No functional change intended.
> > 
> > Cc: James Houghton <jthoughton@google.com>
> > Link: https://lore.kernel.org/all/20250618042424.330664-1-jthoughton@google.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  18 ++++
> >  arch/arm64/kvm/mmu.c              | 143 ++++++++++++++----------------
> >  2 files changed, 87 insertions(+), 74 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2f2394cce24e..4623cbc1edf4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -413,6 +413,24 @@ struct kvm_vcpu_fault_info {
> >  	u64 disr_el1;		/* Deferred [SError] Status Register */
> >  };
> >  
> > +struct kvm_page_fault {
> > +	const u64 esr;
> > +	const bool exec;
> > +	const bool write;
> > +	const bool is_perm;
> 
> Hmm... these might be better represented as predicates that take a
> pointer to this struct and we just compute it based on ESR. That'd have
> the benefit in the arch-neutral code where 'struct kvm_page_fault' is an
> opaque type and we don't need to align field names/types.

We'd need to align function names/types though, so to some extent it's six of one,
half dozen of the other.  My slight preference would be to require kvm_page_fault
to have certain fields, but I'm ok with making kvm_page_fault opaque to generic
code and instead adding arch APIs.  Having a handful of wrappers in x86 isn't the
end of the world, and it would be more familiar for pretty much everyone.

> > +	phys_addr_t fault_ipa; /* The address we faulted on */
> > +	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
> 
> NYC, but this also seems like a good opportunity to rename + retype
> these guys. Specifically:
> 
> 	fault_ipa => ipa
> 	ipa => canonical_ipa
> 
> would clarify these and align with the verbiage we currently use to talk
> about nested.

Heh, I'm so screwed.  x86's use of "canonical" is wildly different.  I can add
a patch to do those renames (I think doing an "opportunistic" rename would be a
bit much).
