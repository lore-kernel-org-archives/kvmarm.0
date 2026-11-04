Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816919;
	b=3zGhJujK8dN5do1bQ3cmDea48NNp42BiGH4A68VMs/562uUdXi7ED2s5wkNMN4v0Xaz1
	 v1raU5fchl89Dg9dqYj2VyTf0kqoFN2RKuvdqQKxNiUAFIBincp4wHUgacJ4uAH9lb1ml
	 0NM5xzb/56SShjrDZWCCHM4+BIgf60j0zeufKsLI6mkdqz3kS1FBNCLEWEpedGqjyZhnY
	 ay2c0q6xwHbxBL9Lix0E+1u9zb8OplS2vSgu30TueKy6/x3wFpyE2k7U0vlOcg3CbUDPS
	 Vh2/AAxA9hjfSJzS4jTOfZfF2BpPPSNvUuHbaht10io3K8+yBJLhnpncoNJmFVG7WDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816919;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=tXTH1bVChQt8wV44REyFEQA4MegRvaL/1pieI+Gg7FY=;
	b=RIEWgO9W1xGj2L9+5s5+wnJLWAkWccLjm0wAbo10RcdKcLbPVx+OCbwLDPULpvDXKdnC
	 QTFQt5/n9Tp2XNzeposy21AJ3tI34loJl9lTHAX+1rJ9oYXEt7nSTl9kUzua5jRmW+HPp
	 d0bB63H+xwBo3kchlcR6VWu24GrJ1sLR5B/u3TFs2ImRkxt1VRF/1QpEHb0E9awHljpWY
	 CyJLIDJhiNgJP3Kvgeuup+ZGv8MjYpO7/2XA5RI9/aLmcXpX2Ag2RKFu+cIIQbaxBwLI0
	 O2zrJxZUaS5nYVsWYHELiX6GmHaY8ubQU0Alf+TLVztu439BiGK4wS25WBIpcCLeX0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="rSFvh/8S";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDAA606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 18:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBDAA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rSFvh/8S
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEE601BB2;
	Wed,  4 Nov 2026 10:28:33 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 349973F632;
	Wed,  4 Nov 2026 10:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793816916; bh=XAmxe6ymW7j94Goqd+Z8z0Uu6UV8KLiV1tg4kl0rNQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSFvh/8SDgUFnexl1Vf+hIzVyIbp5ZSvh7xlnhzChYXsyY1vnZjYBy53cpc9C0Jxe
	 xLcEjXEkUkf9ZtmExsIko5kYY4oRNM6/X5hT4s6z+YPTjJY3ner/MHxJfGiIv2SCI8
	 r6nwW4sZbu2kghBnuzpHUN+StXJtZAOv1vuwSQHc=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Wed,  4 Nov 2026 18:28:32 +0000
Message-ID: <aut5UKnP5BREpTNU@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <aut5F2V0glbJv6ys@LeoBrasDK>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org> <autJUntFMhCoqZeH@LeoBrasDK> <autp0cVkXwvSXPGC@kernel.org> <autrOLZWT-s4Ailc@LeoBrasDK> <autzno1eEpw4X-0I@kernel.org> <aut5F2V0glbJv6ys@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 06:27:35PM +0000, Leonardo Bras wrote:
> On Wed, Nov 04, 2026 at 10:04:14AM -0800, Oliver Upton wrote:
> > On Wed, Nov 04, 2026 at 05:28:24PM +0000, Leonardo Bras wrote:
> > > > The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
> > > > permission model. So we have no way to construct a translation in the
> > > > stage-2 that satisfies our requirements.
> > > 
> > > Since other vcpus will have VTCR_EL2.HD=0, couldn't we enable it just for 
> > > the sake of processing this CMO?
> > > 
> > > I guess it would need to either decode the instruction or single-step this 
> > > vcpu just to make sure it does not write to the same page we just did mark 
> > > WC.
> > > 
> > > > 
> > > > The other way to do this would likely involve halting all vCPUs in the
> > > > VM and attempting to single-step which has a near 100% chance of blowing
> > > > up in our face.
> > > 
> > > Sorry, why all vCPUs?
> > > 
> > > I know for all vCPUs it would be terrible for performance, what else 
> > > do you mean by "blowing up in our face"? 
> > 
> > In order to make this work, you need to guarantee that there's no
> > concurrent updates to either the instruction itself of the stage-1
> > translation.
> 
> Oh, wait. We have to be worried about an instruciton changing while the 
> vcpu is running on them? wow
> (What would happen if the instruction changed while we were running?)
> 
> Well, stage1 changing could be prevented by some existing lock, but maybe 
> that's weird to access from kvm code.
> 
> > 
> > The operations would be, approximately:
> > 
> >  - Take a stage-2 permission fault on the cache maintenance instruction.
> >    Walk the guest's stage-2 and find a translation in writable-clean
> >    state.
> > 
> >  - Pause the VM, re-enter the guest and single-step the instruction. If
> >    we take the debug exception then the guest must've changed the
> >    instruction. Go back to base state.
> 
> Pausing the VM would be required so other vcpu treads do not access the 
> page we are trying to run CMO on, right? 
> 
> > 
> >  - If we take another stage-2 permission fault for a cache maintenance
> >    instruction, temporarily promote the translation to RW in the shadow
> >    stage-2 and re-enter with single-step enabled.
> > 
> >  - Take the debug exception, invalidate the shadow stage-2 translation,
> >    disarm single-step, restart the VM.
> > 
> > The transient RW mappings seems ripe for pretty nasty bugs.
> 
> Ah, right, other running vcpus could write to it while it's RW if we don't 
> pause the whole VM. Yeah, makes sense to me now, would be horrible.
> 
> 
> Thanks for helping me understand!
> Leo

Ah, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
