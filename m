Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E219738C40E
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975029; cv=none; b=pZM2/heiigzYr2NicoahGikCl4s1ZANu1Ej9FMqmuPMMl4Gq53F+NdkwoodEXtiv8f9dKcG3L4Akte4zNuUQlvPq7q4tX6x6nU9wrVGEyauDgloFwILJy1DM9fkmXBAUFgKXEnE9WOfov73QNJGdPRGOqgeIx6IFKeq25BH/PC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975029; c=relaxed/simple;
	bh=uMxa0LUMTrmXf/VvtfhTUvj5CgJXaMoxvOVfT9iI41Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQ65kutkmes8rTFqvMrAL+2HPR9NGWGJXWi39yAmeJ0p5+KRr6PQpvumQbuwiJi+iU2uuTwtXDacp163mLNvcuyUi683lkVjvuZwd2SbgfGs/g06xqPr1EP5rdeh6SbIryGcZ6Y3MExQ9NLqv+nPdz2d/sW5KiiA2PW/Cc6NK3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ddV0TDZd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ddV0TDZd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADA4F3571;
	Wed,  1 Jul 2026 23:50:21 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 593B93F905;
	Wed,  1 Jul 2026 23:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782975026; bh=uMxa0LUMTrmXf/VvtfhTUvj5CgJXaMoxvOVfT9iI41Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ddV0TDZddEa3J114tCfL9vGDB/bc2SGQJ/KaccU2ahQQyuw5ZPGtpxn+s3H6Rnkr+
	 tDArNeYhTWDWquK93EYpT6UpNVVgJq663Q8Iu44j+qhzov8X1N7DlyLuZ6QZ9TMvtl
	 NeM6jhNUn2r9uv7L+dHW1e05GPN7m9J5lbiU2650=
Date: Thu, 2 Jul 2026 07:50:10 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 22/22] HACK: KVM: arm64: nv: Set the dirty state for CMOs
 that fetch for write
Message-ID: <v5zo6ub26nafnxwrscdbcqwhbfd4kxiltv43icfp4y25cev2gf@kb3nfrxtdmmy>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-23-oupton@kernel.org>
 <wt53tup6v5hngzostsualmxnbyhmtjcg6yvyhbqpzellt3x73q@ncz6oc4oxar5>
 <akVPXoMOdw0UaEaH@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akVPXoMOdw0UaEaH@kernel.org>

On Wed, Jul 01, 2026 at 10:33:18AM -0700, Oliver Upton wrote:
> On Wed, Jul 01, 2026 at 11:16:20AM +0100, Wei-Lin Chang wrote:
> > Hi Oliver,
> > 
> > On Tue, Jun 23, 2026 at 11:42:01AM -0700, Oliver Upton wrote:
> > > From: Oliver Upton <oliver.upton@linux.dev>
> > > 
> > > Cache maintenance instructions that fetch for write do not set the dirty
> > > state on descriptors, effectively passing the permission check and
> > > leaving the descriptor in a writable-clean state. While this may make
> > > some sense as the literal write has already occurred, there is no way to
> > > correctly represent a "writable, but only for CMOs" permission in the
> > > shadow stage-2 in such a way that the next genuine write generates a
> > > permission fault.
> > > 
> > > A possible alternative would be to treat CMOs using writable-clean
> > > translations as NOPs, relying on FWB to force everything coherent on the
> > > CPU. This mostly works but will lead to breakage for VMs that have
> > > assigned devices performing non-coherent DMA.
> > > 
> > > Another option would be to set HCR_EL2.TPCP and do full trap+emulate of
> > > CMOs. And yes, dear reader, that would suck.
> > > 
> > > Just do the obvious thing instead and mark the descriptor as dirty for
> > > CMOs. Maybe we can get an architectural relaxation if we're lucky...
> > 
> > This is interesting... So the problem is that when a CMO that require
> > write permission is run by a nested guest, and the guest stage-2 is
> > still in the writable-clean state (which means the shadow mapping must
> > not have W) the instruction gets trapped and KVM gets in an awkard
> > position.
> > 
> > If we keep the guest s2 writable-clean and shadow mapping RO -> guest
> > can't make progress unless we emulate the instruction, but if we make
> > the guest s2 writable-dirty and shadow mapping RW -> not architectural
> > as of now. Treating it as a NOP also comes with problems as you said.
> > 
> > Am I understanding this correctly?
> 
> Yep, it's exactly as you've put it. We need both FWB and fully coherent
> DMA to safely treat the CMO as a NOP and full CMO emulation is the line in
> the sand for me :)
> 
> KVM could potentially detect the presence of noncoherent DMA (see x86's
> kvm_arch_[un]register_dma()), but devices can be assigned long after
> we've computed the vCPU feature set so no chance of limiting FEAT_HAFDBS
> to situations where the stars align.

Cool, I see. Thanks for the extra info! Always learning a lot from
these.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Oliver
