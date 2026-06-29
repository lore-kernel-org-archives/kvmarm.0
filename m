Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8EC3B774D
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729531; cv=none; b=vD1HHEIfX1HH2myIgr4pw4reD89WVnH6CSm7eULTkFhPSsHK7d3fZma9wvCB/iBZBgUgHO5FbUGKu0igPdL64GHMuQ/i4K6cxXAl/D7x1fd2okrmm2WoO0/V6Z1hUbjjx2c9Y5Jn2ebVLAqkLONXTWZU4FL6oljT8RAHaxeLZyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729531; c=relaxed/simple;
	bh=icpNmy8QZD6VmNg0HDjmMCOruXJxpYpnI3FhPsZav5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=bgZHirSl15FndnPK5PaoVSjBAQhi3lhe7tkgxsFgTYZeJIaaNYJHcquvCg7kDDHfkGnK7rq7Fl7oUZtW0ch8RqLQEpRPrkgA8KUkGCa6je02e6k0UvEYs+Vau/AS2cz354Fii/ESE//HhAt1+BgroQHoVMVGVMe0rjwShntpg1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vFBOn6M5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vFBOn6M5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C7EA176C;
	Mon, 29 Jun 2026 03:38:45 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96CD83F836;
	Mon, 29 Jun 2026 03:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782729529; bh=icpNmy8QZD6VmNg0HDjmMCOruXJxpYpnI3FhPsZav5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFBOn6M5e+zHSXBhMn+RASmljj65DoBTF5dGq5dIEzVBizghiak52BOOlrFZqCb7u
	 JV9wqUEi4zL6PwgpBlL/+mkMqGVBTbKQ/ty5/ZigYxtKiMisv5XyPGlIX2Yz0UaQMQ
	 unW1daYKzYFHh2HFFUE4Q5uRnBzFV7nlOZZms0l8=
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
Subject: Re: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Date: Mon, 29 Jun 2026 11:38:46 +0100
Message-ID: <akJLNsk-Rsnbr_JL@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <864iipqofw.wl-maz@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-14-oupton@kernel.org> <aj6fj8fEonBQphZM@LeoBrasDK> <864iipqofw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 26, 2026 at 05:03:15PM +0100, Marc Zyngier wrote:
> On Fri, 26 Jun 2026 16:49:36 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > On Tue, Jun 23, 2026 at 11:41:52AM -0700, Oliver Upton wrote:
> > > Mark the descriptor as dirty if the permissions are sufficient to grant
> > > write access. Note that compute_s1_direct_permissions() already
> > > considers the DBM bit as writable.
> > 
> > IIUC the idea here is to avoid having a write fault when we first write to 
> > that page. Is that correct?
> 
> No. This is about *stage-1*, as indicated in $SUBJECT, and updating
> stage-1 when we take a fault that would indeed require a S1 update to
> be visible to the guest. A VNCR_EL2 fault, for example.
> 

Got it

Thanks!
Leo
