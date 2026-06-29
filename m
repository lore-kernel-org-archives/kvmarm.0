Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91149382F31
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729469; cv=none; b=M4bt0f7en/MX5xvHTqXfOW54tDkvJwdBvzuE6EoR+cCAKEHOT1ko/hIW9+qwQdN/inIGCOTjQCyzLZ6BCrwWCv5uoPVKRnDipUsmVCg8sqdK88ifzn/jURO/K6sEei16V1aDCdXOioUijW5fVaGNbT/1D4MqQX8tchx86UPWY98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729469; c=relaxed/simple;
	bh=Xf5WO6o/76Djsu8oMMNg+xMPIwpymVbL39JZFgCk//g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=eHW6yFhdx1BFTB1C7S6Bc8WAlwDa7q2TQdhaa8MYRhdUrtntN53mQMHuYoV9tnevdYMNS7BQJxrnupv1klrhxmg7GTwgCLwy3PUHHg7ykeEbESSQ35T31lMVaq2XHeRbYCghxKdK2fgU9mymAyi8b4Go3DtH7mU1GVJ6ip33540=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Sd+Nowrg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Sd+Nowrg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 781F7176C;
	Mon, 29 Jun 2026 03:37:42 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C7793F836;
	Mon, 29 Jun 2026 03:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782729466; bh=Xf5WO6o/76Djsu8oMMNg+xMPIwpymVbL39JZFgCk//g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sd+Nowrg8brjy/JPCPDSKXm/XP5k4iQkRMk16vfWKEHzyc1/GLnj6PP4tR4tgqit/
	 MmMdf7fAv6PCEeB5N5LTxXJjksVD3+3oV2PvIejs0o/q0EW/WnMA3byH4272aW1EQ4
	 dkjlMnmOeXExz/whPZ6a4MtZIHE2w0QDDoii4ljA=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 00/22] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Date: Mon, 29 Jun 2026 11:37:43 +0100
Message-ID: <akJK972qkCqZF-O0@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <aj66nzo3gTHYInp8@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <aj6bZZLSk24Ze6_S@LeoBrasDK> <8633y9ql8q.wl-maz@kernel.org> <aj66nzo3gTHYInp8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 26, 2026 at 10:45:03AM -0700, Oliver Upton wrote:
> On Fri, Jun 26, 2026 at 06:12:21PM +0100, Marc Zyngier wrote:
> > On Fri, 26 Jun 2026 16:31:50 +0100,
> > Leonardo Bras <leo.bras@arm.com> wrote:
> > > 
> > > On Tue, Jun 23, 2026 at 11:41:39AM -0700, Oliver Upton wrote:
> > > > KVM's support for hardware descriptor updates has been lacking, owing in
> > > > large part to the fact that the most widely available NV2 hardware
> > > > actually lacks HAFDBS :)
> > > > 
> > > > This series brings support for hardware dirty state and table Access
> > > > flags to the nested MMU. While KVM uses neither of these features, the
> > > > kernel definitely does in the stage-1 page tables. Since there is only
> > > > one hypervisor to rule them all, implementing this stuff at stage-2 is
> > > > mostly motivated by the desire to enable guest stage-1 :)
> > > > 
> > > > Implementing dirty state at stage-2 is a bit more challenging than
> > > > anticipated, I'm in the middle of seeking a relaxation from Arm that
> > > > would make this all architectural. See the last patch for the details.
> > > 
> > > Hi Oliver,
> > > 
> > > Haven't read your patchset yet, but in regards to stage-2 dirty-state
> > > tracking, there have already been some efforts in the area, also
> > > implementing HDBSS and HACDBS in a way of improving performance / reducing 
> > > impact of live migration on a system.
> > 
> > I'm worried you are reading this series the wrong way. This is mostly
> > orthogonal to the whole HDBSS/HACDBS/SLAUA (Super Long And
> > Unpronounceable Acronym). Oh wait, you haven't read it yet. Great :-(.
> > 
> > This series is about *implementing* HAFDBS and HAFT in NV. We can't
> > rely on the HW setting the AF and DB in the guest's own S2 PTs,
> > because these page tables are never live. So we have to do it
> > ourselves.
> > 
> > So this has nothing to do with S2 dirty tracking for the purpose of
> > migration. The guest could implement its own migration based on that,
> > but that has nothing to do with what this series is doing.
> 
> Sorry, I haven't looked at the HDBSS/HACDBS stuff yet. Just want to be
> clear, neither of these features make sense for the host to use in the
> context of NV.

Sorry, it was my mistake. I don't understand enough of NV and mixed up 
what was being proposed.

> 
> KVM's dirty tracking is done on the L1 IPA space, however nested MMUs
> translate the L2 IPA space. The descriptors emitted by HDBSS would be of
> the L2 IPA space and would require reverse-translation for each entry...

Got it, thanks for clarifying it :)

> 
> Software dirty tracking is the way to go for nested MMUs. Maybe in the
> distant future we can emulate HDBSS/HACDBS for the L1 hypervisor. Maybe.
> 

I agree. It will depend on how much performance improvement we get once we 
have real hardware to test.

Thanks!
Leo 

