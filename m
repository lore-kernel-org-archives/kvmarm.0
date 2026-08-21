Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D26413794;
	Fri, 21 Aug 2026 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305618; cv=none; b=D9ApZCUwoKYEghWgGEguD2zhFDyNnreXpiwez7j8CC9JmSdx1ELn/0HoZaoj0MVR8pSrJ7og+otEbcNDXM3cHYusM+aLoi5Y6ziB/W5BC98KW7jNf5d6U1UTQ3gsps9LhySbWtb2aUFwd/yJQzIh0H/eR6dB6cgr4dGB7V3Qmbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305618; c=relaxed/simple;
	bh=uB/dlZY40W+Kcz0LcL3EI6Wv8eBjf0NsJYX+e5zVle4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=eO5fNq8IKAWf/tUKIzqNITmtRrOtHtcB6oj4gQB4c3GovM/iLywv950ElvY0TfZ/CLlviFsioKPumbIeqX1ZS+annfuV8dPxFPIQvwqnWV0dG9+HqeYHHZ+VZOChKyy9Zc+QYv7fuavDsuOx6+L6wi+iHXqjUcFYLXxb3aaM8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=OuxAA2af; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="OuxAA2af"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1787305613; x=1818841613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cpMN9LdSXO0V7L4lCx7s6CMX5aKayudaKA1UYaSAlDY=;
  b=OuxAA2afIIv1Dw88TYoq/4pQ8756RCFyO0cGLNAr9Dx0fy2VRv4r62dP
   rUQSfi6/3GiIqqPgKtlRJGd17JHsVsUfMnwslH6xaTExiQLlUEsubtSgT
   fv4VS0v2vom+GpXGZ3URyPG9rrBllsTDSf+Tw8Cb6NWPXF3VSXJLPXARd
   tOKoSgPdhSyydRwKlU4pKvSXJJDDkQ7QmvtKnOjLa1avg6AOCbouvbdMu
   UyUcFU033BnhzKZTMj1kXoaRrYGAtt09VPspKgX0E9T8ZxexG9uzjorLz
   iHR4yqxrrgTEpfqA/iQFNsZU56F04jIWW1qdOBMzBXZHkp5OvECNkQ1Zn
   w==;
X-CSE-ConnectionGUID: f/Ss0aV/SZy1f0jD1bfVkQ==
X-CSE-MsgGUID: Tv40/G/KSKGHvIEr11HPpA==
X-IronPort-AV: E=Sophos;i="6.25,234,1779148800"; 
   d="scan'208";a="26571611"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:46:50 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:14597]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.135:2525] with esmtp (Farcaster)
 id bd50b97a-fdb2-4cf0-af1e-51fb7efa5dd8; Fri, 21 Aug 2026 09:46:49 +0000 (UTC)
X-Farcaster-Flow-ID: bd50b97a-fdb2-4cf0-af1e-51fb7efa5dd8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 21 Aug 2026 09:46:49 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 21 Aug 2026 09:46:48 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <sashiko-reviews@lists.linux.dev>
CC: Bjoern Doebel <doebel@amazon.de>, Oliver Upton <oupton@kernel.org>,
	<kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5.10.y] KVM: arm64: Retry fault if vma_lookup() results become invalid
Date: Fri, 21 Aug 2026 09:46:29 +0000
Message-ID: <aogeHAy/VCZuTX4i@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260821091439.8A6FC1F000E9@smtp.kernel.org>
References: <20260821090538.3493280-1-doebel@amazon.de> <20260821091439.8A6FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Aug 21, 2026 at 09:14:39AM +0000, sashiko-bot@kernel.org wrote:
> > -	}
> > -
> >  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
> > -	/*
> > -	 * Ensure the read of mmu_notifier_seq happens before we call
> > -	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
> > -	 * the page we just got a reference to gets unmapped before we have a
> > -	 * chance to grab the mmu_lock, which ensure that if the page gets
> > -	 * unmapped afterwards, the call to kvm_unmap_hva will take it away
> > -	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
> > -	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
> > -	 */
> > -	smp_rmb();
> > +	/*
> > +	 * Read mmu_notifier_seq so that KVM can detect if the results of
> > +	 * find_vma_intersection() or gfn_to_pfn_prot() become stale prior to
> > +	 * acquiring kvm->mmu_lock.
> > +	 *
> > +	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> > +	 * with the smp_wmb() in kvm_mmu_notifier_invalidate_range_end().
> > +	 */
> > +	mmap_read_unlock(current->mm);
> >  
> >  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
> 
> [Severity: Critical]
> Does removing the explicit smp_rmb() here in user_mem_abort() break the MMU
> notifier retry protocol?
> 
> The comment states that we can rely on mmap_read_unlock() for an implicit
> smp_rmb(). However, mmap_read_unlock() via up_read() typically provides only
> RELEASE semantics.

Note that this removal of smp_rmb() is not new in this backport but
verbatim taken from the mainline patch. It is also contained in all
previous backports of the patch.

I'm not an expert on the memory semantics here and open to suggestions.
But _if_ we consider this a problem, we would have to go back and review
mainline and the other backports as well.

Bjoern

