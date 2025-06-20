Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47454226865
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750452409; cv=none; b=Dc1HU4gV6BKNc8iT+d0AxluYS9Z5UMFFCNhescyZrfx3Xj8PNSn8mqXAOFrkx3uHBmwnMDTJaslQ8RABoVOvFjAgkhYVgVlTRKl0j0z91B6xCHeuDGsIIoSZBBi+4Ucwrp5SwaWrd4k7FS7DFfsykFbD9JUHQtwJSAjWq8L31dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750452409; c=relaxed/simple;
	bh=PeikzViu08NQWTbsah1WIOxZg1rvu0au6ayjQVoeClo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePS5xKnVCMG7Gz+HdFHV6SGzjjJ0UKps5Aw1j+R8KxApky9TsVGRVcps46gQhIljRzPLDYZdG4em5hna80Z65BkFWQU87iicgqWnTNtkFqlerHUrG/DmWFYUP+Io8AXAtBDofukFCiZlUIYxZFdc5uYEWp+7YPfK9nm1K9TSOq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wB2JMktH; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wB2JMktH"
Date: Fri, 20 Jun 2025 13:45:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750452395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ByAPDQByeMdLRhDMIGN/IiSb/H4BbcIKGrfBibrThdw=;
	b=wB2JMktH26IhXs7XGQI53IupRTDVbGuWl0qkGpR4EDdkm6Y0SKYhHCVQ3hJR8Rqu2hK1LA
	N1NJF2AJ9y/cp/vQqHMdmu8F0Mj3Qd4i049KApbe8HC1z3bEABA5689uiXgYJFwU2g76pp
	zOPEZ4caj/QyY29FLXxszr21nzjdq9A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
Message-ID: <aFXIgrmU8uSA6YHS@linux.dev>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org>
 <aErlezuoFJ8u0ue-@google.com>
 <aEyOcJJsys9mm_Xs@linux.dev>
 <aFWY2LTVIxz5rfhh@google.com>
 <aFWtB6Vmn9MnfkEi@linux.dev>
 <aFWws7h3L-iN52sF@google.com>
 <aFW2NISX0q11sop1@linux.dev>
 <aFXFO6_lVV5PpGW-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFXFO6_lVV5PpGW-@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 01:31:55PM -0700, Sean Christopherson wrote:
> On Fri, Jun 20, 2025, Oliver Upton wrote:
> > On Fri, Jun 20, 2025 at 12:04:19PM -0700, Sean Christopherson wrote:
> > > If I post it as a standalone patch, could you/Marc put it into a stable topic
> > > branch based on kvm/master? (kvm/master now has patch 1, yay!)  Then I can create
> > > a topic branch for this mountain of stuff based on the arm64 topic branch.
> > 
> > Ok, how about making the arm64 piece patch 1 in your series and you take
> > the whole pile. If we need it, I'll bug you for a ref that only has the
> > first change.
> 
> Any preference as to whether I formally post the last version, or if I apply it
> directly from this thread?

Since I have this email on my phone I'm always in favor of not getting
spammed :) This thread has all the discourse too, so likely a better
artifact.

> > That ok?
> 
> Ya, works for me.  What's the going bribe rate for an ack these days?  :-D

Usually about the cost of a pint ;-) For the arm64 bits:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
