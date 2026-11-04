Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817168;
	b=Sbxk0CQvd3rnA8z6Cbj5CoOzAarSVhhDkd/DMCgbwSflRYLvkfs1g0YGhRnkwiyoFKsO
	 ixDqMpK31gpD3oaDpH3yPC9+vzultypH80TS/Mfq+rFlGrcRToSsSTeZKVEoBvfGL11MQ
	 iiMGESdxl6S5H2bJ5N9xB1bGH1QSRqdFlAy1Z3HCcb0VTe3MNsrlPMXYlQNJ8WVPPLLbq
	 CmuYzfSPqjBPN63DdrTdy81gXlen/g46s9TB6oxVt4o9IrHlygUEOu8bXyn4i/Lkx8K19
	 AibkZKEx6oHHlcNctx0ezQchtW2cYnfAwaG4Rip17Fx6FYcfGB32Bs5OC5KYgM89xuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817168;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=7pBRtkafzErXry2a4M3ZOFuqMll2Iapj6nbguhU7Ss4=;
	b=ftj7NTZ2xKJmQ8UQKl3MgfcRkQ+DuX7xy/9XKUpztEdVTHJCkaql41CvMl2MlU7WyT2P
	 RKJHS34EPBGppwRJx+ePzWGdk3belymQER1xVHgPKUcPGmCKsZXV5b3ifDjVim4sJgW0G
	 nyiFqwkcL8l+3EXuXbYFm/my77RaGz7E/5WtmhumXeJ+hEwKQT48XxrMMD/oMr6r+hCpd
	 zUneWwk0EGIrNuJXkNZ6PMR4R8/MMCagPX0UdSjal2Hg6YoAM/f9zStaSsoueyvJN3cXt
	 eTwvxjMWwuj+Zx1rT+jcwftt8AMwmldUe66Rxq5NZMOHM0x7J8Pb4XfFHst4+r8N+eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y43Do6f9;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A064606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 18:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A064606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y43Do6f9
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 409461BB0;
	Wed,  4 Nov 2026 10:32:44 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC4023F632;
	Wed,  4 Nov 2026 10:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793817167; bh=7di+1trkvwAVQJRdOwTmOwiFwFpSdsSHG14QqEB+m3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y43Do6f9p/SoPNsKqtGj9a1kQodPRx7pA8k2wQ6paa9lc5HcntjBztICGsrAonx2S
	 GIKGMUg7nQKaG0fvF9X1LWYRoTR2kDFjmLZlzeDj8OjZ9y5YL5r12WSgwhT0iRxpyh
	 3peglGk2v7bT8Ue1CBIzHu5nNmF5xfDd1DeYO2u8=
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
Date: Wed,  4 Nov 2026 18:32:43 +0000
Message-ID: <aut6S_jvr_ZLbDoi@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <aut5UKnP5BREpTNU@LeoBrasDK>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org> <autJUntFMhCoqZeH@LeoBrasDK> <autp0cVkXwvSXPGC@kernel.org> <autrOLZWT-s4Ailc@LeoBrasDK> <autzno1eEpw4X-0I@kernel.org> <aut5F2V0glbJv6ys@LeoBrasDK> <aut5UKnP5BREpTNU@LeoBrasDK>
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

On Wed, Nov 04, 2026 at 06:28:32PM +0000, Leonardo Bras wrote:
> On Wed, Nov 04, 2026 at 06:27:35PM +0000, Leonardo Bras wrote:
> > On Wed, Nov 04, 2026 at 10:04:14AM -0800, Oliver Upton wrote:
> > > On Wed, Nov 04, 2026 at 05:28:24PM +0000, Leonardo Bras wrote:
> > > > > The writable-clean state is nonexistent when VTCR_EL2.HD=0 in the direct
> > > > > permission model. So we have no way to construct a translation in the
> > > > > stage-2 that satisfies our requirements.
> > > > 
> > > > Since other vcpus will have VTCR_EL2.HD=0, couldn't we enable it just for 
> > > > the sake of processing this CMO?
> > > > 
> > > > I guess it would need to either decode the instruction or single-step this 
> > > > vcpu just to make sure it does not write to the same page we just did mark 
> > > > WC.
> > > > 
> > > > > 
> > > > > The other way to do this would likely involve halting all vCPUs in the
> > > > > VM and attempting to single-step which has a near 100% chance of blowing
> > > > > up in our face.
> > > > 
> > > > Sorry, why all vCPUs?
> > > > 
> > > > I know for all vCPUs it would be terrible for performance, what else 
> > > > do you mean by "blowing up in our face"? 
> > > 
> > > In order to make this work, you need to guarantee that there's no
> > > concurrent updates to either the instruction itself of the stage-1
> > > translation.
> > 
> > Oh, wait. We have to be worried about an instruciton changing while the 
> > vcpu is running on them? wow
> > (What would happen if the instruction changed while we were running?)
> > 
> > Well, stage1 changing could be prevented by some existing lock, but maybe 
> > that's weird to access from kvm code.
> > 
> > > 
> > > The operations would be, approximately:
> > > 
> > >  - Take a stage-2 permission fault on the cache maintenance instruction.
> > >    Walk the guest's stage-2 and find a translation in writable-clean
> > >    state.
> > > 
> > >  - Pause the VM, re-enter the guest and single-step the instruction. If
> > >    we take the debug exception then the guest must've changed the
> > >    instruction. Go back to base state.
> > 
> > Pausing the VM would be required so other vcpu treads do not access the 
> > page we are trying to run CMO on, right? 
> > 
> > > 
> > >  - If we take another stage-2 permission fault for a cache maintenance
> > >    instruction, temporarily promote the translation to RW in the shadow
> > >    stage-2 and re-enter with single-step enabled.

But what if instead of RW we made it WC, and enabled Hardware HAFDBS just 
in this cpu?

Other CPUs with HAFDBS=off would fault on write, and we could block them 
there. 

(We would have to serialize those accesses, though, as multiple vcpus could 
use the same strategy at the same time)

Thanks!
Leo
