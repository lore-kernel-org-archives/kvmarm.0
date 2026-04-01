Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B07F47A0BC
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775063380; cv=none; b=KJpTkmvRzQpWSkm0N9ptCyb0TuCmTb7XLKyzt3zQS9bVbdoZeI2SMFn6kdCvxqkThQ4bkswdis06v5XqR9NwVG/dztwiQYthLp2EBHo0hB9DnYSTp/guc2jHzB2jNgfX0N2kOCcE9YtTiLtMJ226jJ4CCo8T1524rMCpK5TiUMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775063380; c=relaxed/simple;
	bh=vz3fsrkwyh2DquzkFwvcrwde1yO/DbLGn4XjzLbGysU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fddvubP3N1LEPsHBdDwU43vtMFsEkDqcXo5AXNCf3erWg4+BYVVS5cTCN5+UhUdhOVmLNJlDb1I7LWYt4IGJj7jrI40xRgnZY1u88xWarQLl//rQm8E1Q6ye3nV+6SPSUbKNk2SaQx0TX8QebslgMKAqbNYm3JSE92Vn+nCXV1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jcImUHuj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jcImUHuj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E7362E99;
	Wed,  1 Apr 2026 10:09:32 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7992C3F641;
	Wed,  1 Apr 2026 10:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775063377; bh=vz3fsrkwyh2DquzkFwvcrwde1yO/DbLGn4XjzLbGysU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jcImUHujDcSUwk1p2Zaj1jON0llNZ0+Bu1JJeMQ8Qdf+wtdm9VIIbIJc2RaDnwco1
	 oA5TJFWGpsmoIdROpGftSnHk9RSClEw1Gqrc0dr5kJEGIeDpmXZeY+2q228aKVg00z
	 TycqRdqvtcukRw8VnkihHzSXLnkwHhlfihQnFq/E=
Date: Wed, 1 Apr 2026 18:09:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Message-ID: <ac1RTexR1zbRBLXA@arm.com>
References: <20260401170017.369529-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401170017.369529-1-maz@kernel.org>

On Wed, Apr 01, 2026 at 06:00:17PM +0100, Marc Zyngier wrote:
> As we are missing ID_AA64PFR2_EL1.GCIE from the kernel feature set,
> userspace cannot write ID_AA64PFR2_EL1 with GCIE set, even if we are
> on a GICv5 host.
> 
> Add the required field description.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
