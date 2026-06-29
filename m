Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D35E3B774D
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729596; cv=none; b=p9L4TbzRYT1y3hs0LQ3o+ZV6xvPPRkNVCLAS4obsQ9wfpoR6U7HUfCleVxVjdMluGUdcgU9Xb+mnwM+u4G0aLrAsSMuIlvhfXRm6fj12nSQR/Q5Gzbce9ncDx/0aDnWaMUwfzUuE0uLF6jiVh3jv3eXWQUdmBYiOBM21YSZSyJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729596; c=relaxed/simple;
	bh=qAlWegfzdbB6rsXbsKuXlCVwMcM4Wnl+oUGmrzusfHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=NH3sxmRPdCx8dugPBTwNhcM42w3ZjL2UWpbi9xYHalenDrMTH2mRVUjaVMZAvqMUexjcCBbiDvolzbxDCGKiiKS4Dti0Sz4SDhyDchzf6OzhhL7ek3+xI1o59CT4W36jRnSJPhSr5Ii3GOOCJiOussGMHsUBNYYYENvgJU0WpAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XTB2/2ne; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XTB2/2ne"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EFB0176C;
	Mon, 29 Jun 2026 03:39:50 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A91443F836;
	Mon, 29 Jun 2026 03:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782729594; bh=qAlWegfzdbB6rsXbsKuXlCVwMcM4Wnl+oUGmrzusfHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTB2/2nehzG8gaxWT4RvIVFjjNlkOwaFRl9Jo70H5ZC6d98zr7a56rNFCbnuL7Hyd
	 uw5hCapWw8P3H7CcKjCimZ/uLznzzX55D89HADQ2Iu7eagv4sP5Qs3HTw/+pZ2K/0Q
	 Cmuyu+EZ3xpTGKQ5qDDSTilpYiCMzrvZh4aqf0EA=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Date: Mon, 29 Jun 2026 11:39:51 +0100
Message-ID: <akJLd5tqDhWi1ntA@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <aj64bOopE9WJoWBX@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-14-oupton@kernel.org> <aj6fj8fEonBQphZM@LeoBrasDK> <aj64bOopE9WJoWBX@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 26, 2026 at 10:35:40AM -0700, Oliver Upton wrote:
> On Fri, Jun 26, 2026 at 04:49:36PM +0100, Leonardo Bras wrote:
> > On Tue, Jun 23, 2026 at 11:41:52AM -0700, Oliver Upton wrote:
> > > Mark the descriptor as dirty if the permissions are sufficient to grant
> > > write access. Note that compute_s1_direct_permissions() already
> > > considers the DBM bit as writable.
> > 
> > IIUC the idea here is to avoid having a write fault when we first write to 
> > that page. Is that correct?
> > 
> > When we have HAFDBS the fault does not happen, and it gets marked from 
> > writeable-clean -> writeable-dirty by HAFDBS mechanism, which is cheap as 
> > it happens to be a write to the pgtable when memory is first written to.
> > 
> > On the other hand, when we clean the dirty-bits for the first time, we 
> > have to issue a write for every page that have been dirtied, in sequence.
> > 
> > An alternative would be not marking every page as dirty at first, in 
> > exchange of possibly having a faster first clean pass.
> > What do you think about it?
> 
> As Marc mentioned on the cover letter, this is unrelated to host dirty
> tracking. I'm implementing HAFDBS as part of our pseudo-TLB refill for
> nested. We need to mark translations as dirty in the nested S2 before
> filling the shadow S2 with something that allows writes.
> 

I see. Makes sense to me now.

Thanks for your patience!
Leo
