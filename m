Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BECD330666
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729013; cv=none; b=NooEn6cmAwrsFgGywfPA9BtrlN4C9mWDOVQunMspRjIIiLaMoQOhuGa1E8Bb9zepJDWR8gC3Aht5pwJhOPAmww9WI6T2nXOrqLIjNz6xSska/F0Hb9pOcQcpSQf9t3+Ty7DEdRqDxE7EZ49MCq2yqvNnsl4h3rlqdDu0hp2dZKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729013; c=relaxed/simple;
	bh=Ds6nJwSE6DlTJOVLmnCEfT6iaTAaF5KKMPl6oD7/81I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=QFbapDmCAZz9na333ugUQRqXJ6sPFrn1qrMRErey+h0E0jLSsVh+FXZHAvnYc7TvHH+4O+qR1HDhFGMCs0khZKBdiEQzh/87+gahP/EfkP4P0QP9cOiyyp854TKMC/vW4FFmDxTtZSwL1PGvHTEZAtLzeuvG+GDqTBBJHfvHzOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vB6G5fRK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vB6G5fRK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8CAC176C;
	Mon, 29 Jun 2026 03:30:06 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 418263F836;
	Mon, 29 Jun 2026 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782729011; bh=Ds6nJwSE6DlTJOVLmnCEfT6iaTAaF5KKMPl6oD7/81I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vB6G5fRKn9k3DSsZ9kNIFzcAuSNXA10J9wQsTq/LFe/mWIQ48TDRIOCzdG4V9/9el
	 co63LfgLjYKeghuLBK4QyEv1HbEj8vlc0zfU61Ues9mvX2vGoshJAJ1s56gZpv/UF4
	 /AxNl+k/45UD7xM2g5uXRP3JCy4xJWRXVYTZh1wg=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 00/22] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Date: Mon, 29 Jun 2026 11:29:50 +0100
Message-ID: <akJJHlqXPvWoWTT_@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <8633y9ql8q.wl-maz@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <aj6bZZLSk24Ze6_S@LeoBrasDK> <8633y9ql8q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 26, 2026 at 06:12:21PM +0100, Marc Zyngier wrote:
> On Fri, 26 Jun 2026 16:31:50 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > On Tue, Jun 23, 2026 at 11:41:39AM -0700, Oliver Upton wrote:
> > > KVM's support for hardware descriptor updates has been lacking, owing in
> > > large part to the fact that the most widely available NV2 hardware
> > > actually lacks HAFDBS :)
> > > 
> > > This series brings support for hardware dirty state and table Access
> > > flags to the nested MMU. While KVM uses neither of these features, the
> > > kernel definitely does in the stage-1 page tables. Since there is only
> > > one hypervisor to rule them all, implementing this stuff at stage-2 is
> > > mostly motivated by the desire to enable guest stage-1 :)
> > > 
> > > Implementing dirty state at stage-2 is a bit more challenging than
> > > anticipated, I'm in the middle of seeking a relaxation from Arm that
> > > would make this all architectural. See the last patch for the details.
> > 
> > Hi Oliver,
> > 
> > Haven't read your patchset yet, but in regards to stage-2 dirty-state
> > tracking, there have already been some efforts in the area, also
> > implementing HDBSS and HACDBS in a way of improving performance / reducing 
> > impact of live migration on a system.
> 
> I'm worried you are reading this series the wrong way. This is mostly
> orthogonal to the whole HDBSS/HACDBS/SLAUA (Super Long And
> Unpronounceable Acronym). Oh wait, you haven't read it yet. Great :-(.

Sorry, I have very little understanding of nested, and I wrongly thought 
this patchset would be in some way also involve hw-accelerated dirty-bit 
usage.


> 
> This series is about *implementing* HAFDBS and HAFT in NV. We can't
> rely on the HW setting the AF and DB in the guest's own S2 PTs,
> because these page tables are never live. So we have to do it
> ourselves.

Got it!

> 
> So this has nothing to do with S2 dirty tracking for the purpose of
> migration. The guest could implement its own migration based on that,
> but that has nothing to do with what this series is doing.
> 


Makes sense.

Thanks for clarifying this, and for your patience.
Leo
