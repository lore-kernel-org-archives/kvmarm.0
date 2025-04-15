Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA7E20AF62
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744732504; cv=none; b=JTuP4JEnIp9+6m1q6Aljjj+SlEwAuHunRL+ClIWoQbcaQOJJzxofgg+Khq73YssKH5qlVoRX6z8bx68MZN6FVL3uyIe7dFBH3aRA1vNDeBO6ZKjvGY8xcujF3mL+pUw2OuUqWzTuagktBzntFu/D55/d5XWauISDdCrE1AoiH7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744732504; c=relaxed/simple;
	bh=nQOyz0LdTaX4VVRdt3j4Nh4bjWfbz57R986Vkga7Ab8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tG+J/eA9K491vo6oNGC7iPDFS1VvDhfMSCf0//7g+nOjqrqyclOoVl6syzXhIabVRvcdHCiuFOdzNuYwbGJXu3Tyf7zZL28mIdXMCRDFaZaAzt6fO/aXFD6uOTSX7LI5vOYzMUD8umWM7irlDflVmw01PY7bn2/EjGvDpkAcd4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297E6C4CEEB;
	Tue, 15 Apr 2025 15:55:00 +0000 (UTC)
Date: Tue, 15 Apr 2025 16:54:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev, will@kernel.org,
	mark.rutland@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
	sebott@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
	anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com
Subject: Re: [BUG][PATCH v8 4/6] arm64: Make _midr_in_range_list() an
 exported function
Message-ID: <Z_6BUgekb7YXOExu@arm.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>
 <3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com>
 <865xj5la2q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xj5la2q.wl-maz@kernel.org>

On Tue, Apr 15, 2025 at 04:26:53PM +0100, Marc Zyngier wrote:
> On Tue, 15 Apr 2025 11:57:50 +0100,
> Ada Couprie Diaz <ada.coupriediaz@arm.com> wrote:
> > I discovered that this patch breaks boot for some CPUs when building
> > the default defconfig plus KASAN. This is still the case in v6.15-rc1
> > and rc2.
> > 
> > This patch marks `is_midr_in_range_list` as position independent but
> > it isn't, breaking early boot when instrumented with KASAN and
> > `CONFIG_RANDOMIZE_BASE` enabled.
> > 
> > The breaking usage seems to be in `kaslr_requires_kpti()` called in
> > `early_map_kernel()`.
> > My testing on an AMD Seattle board does crash, but newer machines
> > implementing E0PD do not crash as they do not need to check MIDRs in
> > `kaslr_requires_kpti()`.
> > `is_mdr_in_range_list` did work in PI code previously because it was
> > `inline`, which this patch changes.
> 
> OK, this is much more of a pain than I thought.
> 
> I tried bringing the various helpers into the PI section, but it ended
> up being extremely ugly.
> 
> More importantly, this is something that is pretty much at odds with
> the whole idea of the MIDR override -- it happens way earlier than we
> can populate the table.
> 
> The thing is, the only reason we need to do this is that we need to
> support the Cavium SEFAC (Sorry Excuse For A Computer) that cannot run
> with KPTI.
> 
> I can restore harmony with the following hack. But maybe we should
> just prune TX from the kernel and be done with this contraption.

That works for me. Well, we can still keep it around but panic on boot
if kpti is enabled on this platform. Just don't bother checking it via
early_map_kernel() from the PI code.

-- 
Catalin
