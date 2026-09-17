Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B953B2472AA
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652475; cv=none; b=ZK0SN2cRbeEHiBiAxOjDSyDvBsuz66lfwAkQLbIrG1AbmHmoFEG+9wPMg0N/+8ZC1vs6eXfkhgzJ18aQZxHkVTySeubylaW0/eXLgKkpcEVlMukncrbfYH/8UsidOT7aH579oDOXKERPorlrvvF3hSFcU46oonujonUb6jjtv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652475; c=relaxed/simple;
	bh=pMaltV42Ut7J+2cvhhHM52+pUEN9+wxX7ldHO0AuSsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=qLbvCHS9USu5djkWCjsyg88WMrR72f0LtSObDXHHzChO3EAuQ9DlKUT5G5yseQ9tCFNOrJIv49KoTiiAHrDhCUCRi8Zvo2rfEfdGFawGSSJFC0mbSn+k9eFOG0mQdjJzTw2pSCxaMAyD9rHPGcjxzrfwucilCEo40W2kgOio8wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JQutnQTN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JQutnQTN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB488143D;
	Thu, 17 Sep 2026 06:40:58 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 809E43F7B4;
	Thu, 17 Sep 2026 06:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789652462; bh=pMaltV42Ut7J+2cvhhHM52+pUEN9+wxX7ldHO0AuSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQutnQTN7eXMuu0BG6pjPJy+Tfv4OvbHBuIZXxBwmmeWMJytzGn8ZgZi/2hIuXmIn
	 TKz9i7bbdeJ76jeIPLHxWz7SMpsmQjhu3IdJoCq1qIiDrdpQu3GlwcRYPtH6loIzjD
	 eXmAPJmOUph9hUvPFVrCcY6DUEelDIckOkMyahNQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Thu, 17 Sep 2026 14:40:42 +0100
Message-ID: <aqvt2gnlBZeNsaf4@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqsl1_IqnV2r8kUL@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org> <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 16, 2026 at 04:27:19PM -0700, Oliver Upton wrote:
> On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
> > On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> > > Hi,
> > > 
> > > On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > > > When dirty-logging is disabled, even non-write faults make a page dirty,
> > > > which avoids a second fault when the page is actually written to.
> > > > 
> > > > On dirty-logging enable, this approach causes all (writable) pages on the
> > > > memslot to be marked clean, even if they were not written to, which can
> > > > take a lot of time, while holding the MMU lock, doing atomic writes to
> > > > PTEs.
> > > 
> > > Do you have any performance numbers for this? Enabling HAFDBS seems a
> > > bit involved to avoid some stores on the first pass.
> > 
> > Not yet, but if the idea does not look too crazy I can find hardware and 
> > collect some data :)
> 
> TBH this looks like a micro-optimization so I'm not expecting the
> performance gains to justify the behavior change.
> 

Okay then, I will get a machine to figure the performance gains :)

> > > > 						      has_vhe() &&
> > > 
> > > I don't see a reason why this needs to be constrained to VHE-only.
> > > 
> > 
> > Humm, in nVHE would not the host kernel run in EL1?
> > I thought that this being a feature that depends on EL2 registers host 
> > would need to be in EL2 to make use of it.
> > 
> > That being said, I understand very little of how this works, so I 
> > constrained to VHE only at the start.
> > 
> > Would this work in nVHE?
> 
> We already pass a stage-2 MMU configuration to EL2 from EL1 in nVHE and
> hVHE. How is this any different?
> 

Ah, so we can just ask the hypervisor in EL2 to enable that behavior in 
those cpus? I have dig deeper in code to get a better understanding on how 
that would work.

Would that make sense in pKVM as well?

> I'm not opposed to making features VHE-only, but there needs to be some
> amount of reasoning to justify it.

Likewise, I am not opposed to make it work outside VHE as well, I just 
don't understand enough of nVHE/hVHE/pKVM yet, so I thought starting with 
VHE would be simpler.

> 
> > > > +		!kvm_vcpu_has_nv(kvm) && cpus_have_final_cap(ARM64_HW_DBM);
> > > 
> > > Same thing goes for nested... KVM can make use of HAFDBS in the
> > > canonical stage-2 MMU (or even a shadow stage-2) independent of the
> > > guest hypervisor.
> > > 
> > 
> > Humm, I remember reaching the conclusion that it could not be used if the 
> > guest supported NV. Let's say:
> > 
> > L0 - Host	- Has HAFDBS enabled
> > L1 - Hypervisor - Has HAFDBS disabled
> > L2 - Guest	-
> > 
> > Let's say guest writes to a page, and the shadow S2 has DBM=1, so it's 
> > marked as WD by HAFDBS. Since no fault was taken, how would the L1 be able 
> > to update it's S2 pagetables to mark the page dirty?
> > 
> > (We would have to transverse the Shadow S2 Pagetable updating the original 
> > S2 pagetable)

(*)

> > 
> > I was wondering, thought, that we could emulate it in the last level 
> > hypervisor, if it's guest does not support nested guests. That would mean 
> > we can have the last-1 level hypervisor to update the S2 pagetable on the 
> > last level hypervisor without it having to fault. Ex:
> > 
> > L0 Host - HAFDBS disabled
> > [...]
> > Ln-1 Hypervisor - HAFDBS disabled
> > Ln   Hypervisor - HAFDBS enabled
> > Ln+1 Guest - No E2H feature
> > 
> > When the guest writes to a page, the host should receive a fault, that IIUC 
> > have to propagate down up to Ln Hyp. If Ln Hyp has HAFDBS, we could skip 
> > injecting a fault in Ln Hyp, as  Ln-1 Hyp could emulate HAFDBS and write 
> > the dirty bit to S2 pagetagle of Ln+1 guest, that resides in Ln memory.
> > 
> > Not sure if the troulbe would be worth, though.
> > Does it make sense?
> 
> I'm not following your reasoning here.

Oh, sorry, that got confusing up there. Everything above (*) was my 
perception of why would not that work. Lines below (*) are a new idea on 
how we could use it in the last level hypervisor.

> Treat the shadow stage-2 MMU as a
> TLB; that TLB is filled with a writable translation when S2AP[1]=1 in the
> L1 translation.

L1 considering that L1 is the last level hypervisor, right? So the example 
above the (*). 

If so, yeah it makes sense. Shadow S2 acs as a TLB so we don't have to 
walk all intermediate pagetables to figure out the translation every time 
we need to access it and the entry is not in the HW TLB.

Thanks for sharing this... thinking about the shadow S2 just became easier 
:)

> 
> The dirty state of the pseudo-TLB is completely internal. You could then
> layer HAFDBS for the L1 translation on top of this (which we don't
> support) by potentially relaxing the descriptor _before_ evaluating the
> resulting permissions. You'd then take write permission faults to set
> S2AP[1] in the L1 translation.
> 

Would relaxing here mean mark the shadow S2 PTE as RO?
I think you got what I meant on the idea below (*), but exemplified with 
the example above (*).

What I meant in the idea below the (*) is that the level (n-1) hypervisor 
could just flip the dirty-bit for it's level n guest (which is the last 
level  hypervisor), emulating a hardware that supports HAFDBS. That would 
avoid injecting the fault in the level n guest and just flip the bit 
directly from level (n-1) viewpoint. For that, only the Ln hypervisor 
should have HAFDBS enabled. (this idea does not depend on the 
underlying hardware actually supporting HAFDBS).

Does it make sense, then?

> > > The name would suggest this thing takes a vcpu pointer...
> > > 
> > 
> > Ah, that name was based on
> > #define kvm_vcpu_has_feature(k, f)  __vcpu_has_feature(&(k)->arch, #(f))
> > 
> > That takes a kvm struct to check the kvm_arch one, instead of looking into 
> > the vcpu. I did it like this because there were some scenarios it was not 
> > quite straightforward to get the vcpu to use vcpu_has_nv(), which takes a 
> > vcpu.
> 
> This thing probably should've been "kvm_has_vcpu_feature()" or similar to
> massage the expected typing.

Humm, makes sense.
Would you like me to change the new one to kvm_has_nv() in the next 
version?

Thanks!
Leo
