Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7D5371D04
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782927200; cv=none; b=C8KJTHK6zA+BOqgbJTNWsxIF94TEMG1Ne9bXOOt+ZDukCbuIoxGenJMTIrn0w7THGGsj/9MII5lCtRldHtJvT2ZVMp/T5q+gUvoA794HT4ApjSfBzzPciRVvbxyR34Nr4I/tVbCU3368tklzsGlcbp/ARvlYrMIvTDfvZyXTjUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782927200; c=relaxed/simple;
	bh=UwqYnvXTRJArH5PhuwcDicJPfOibNsw2Bb8PS13kd3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PivZdzak4I/Y5EZBJg3/ZIkIxbVVjozCNMcAhROv5306r05GBJyVpe4+9q6Xz4WMHPvKJ8/Nf8ghp5U8tOtDxRaROz2959QwEBj7LSzmkbKfL5pX67uDwWH7jBldr+2SkVZst6FftaLef6B2ZZJhoz+CxuEYv9dcHuYXY0V3W58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCXIW8ab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCXIW8ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E2B1F00A3A;
	Wed,  1 Jul 2026 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782927199;
	bh=+z0fbjW9ssNRmSPO2H+7NJGzbAm8sR1IL0A1mKQNDl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RCXIW8abYqClUoCdniO4snhdwe78MvK47WiMjOcQb3ZOCemdXID/tl3zNcgbwGFu2
	 a8ok1k3NDhJbRe46MIcX61KgPJ23nyTUUrG2TU406wtYG8FT+OhUkCCUBQExYqTTtI
	 NCqK5GLTX+74dbOgrdOayUgrpXLBLGDiwsGY3vMIQObXLiKTjvDHuHXzuT6HfsKWH2
	 ERrnqhTyzaq84q8J8AGplyLQ6wgQCjAfLFpGK1YIdWnIElut+wRgR8ppByS7is/I3z
	 XBnaO9lc2WrG8bVA8DNY/tCiNVaj8Xisp3SIONQtHcedjdcLvJZHIq2DAPAzVeqWN1
	 TY/zwHDlNPvcQ==
Date: Wed, 1 Jul 2026 10:33:18 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 22/22] HACK: KVM: arm64: nv: Set the dirty state for CMOs
 that fetch for write
Message-ID: <akVPXoMOdw0UaEaH@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-23-oupton@kernel.org>
 <wt53tup6v5hngzostsualmxnbyhmtjcg6yvyhbqpzellt3x73q@ncz6oc4oxar5>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wt53tup6v5hngzostsualmxnbyhmtjcg6yvyhbqpzellt3x73q@ncz6oc4oxar5>

On Wed, Jul 01, 2026 at 11:16:20AM +0100, Wei-Lin Chang wrote:
> Hi Oliver,
> 
> On Tue, Jun 23, 2026 at 11:42:01AM -0700, Oliver Upton wrote:
> > From: Oliver Upton <oliver.upton@linux.dev>
> > 
> > Cache maintenance instructions that fetch for write do not set the dirty
> > state on descriptors, effectively passing the permission check and
> > leaving the descriptor in a writable-clean state. While this may make
> > some sense as the literal write has already occurred, there is no way to
> > correctly represent a "writable, but only for CMOs" permission in the
> > shadow stage-2 in such a way that the next genuine write generates a
> > permission fault.
> > 
> > A possible alternative would be to treat CMOs using writable-clean
> > translations as NOPs, relying on FWB to force everything coherent on the
> > CPU. This mostly works but will lead to breakage for VMs that have
> > assigned devices performing non-coherent DMA.
> > 
> > Another option would be to set HCR_EL2.TPCP and do full trap+emulate of
> > CMOs. And yes, dear reader, that would suck.
> > 
> > Just do the obvious thing instead and mark the descriptor as dirty for
> > CMOs. Maybe we can get an architectural relaxation if we're lucky...
> 
> This is interesting... So the problem is that when a CMO that require
> write permission is run by a nested guest, and the guest stage-2 is
> still in the writable-clean state (which means the shadow mapping must
> not have W) the instruction gets trapped and KVM gets in an awkard
> position.
> 
> If we keep the guest s2 writable-clean and shadow mapping RO -> guest
> can't make progress unless we emulate the instruction, but if we make
> the guest s2 writable-dirty and shadow mapping RW -> not architectural
> as of now. Treating it as a NOP also comes with problems as you said.
> 
> Am I understanding this correctly?

Yep, it's exactly as you've put it. We need both FWB and fully coherent
DMA to safely treat the CMO as a NOP and full CMO emulation is the line in
the sand for me :)

KVM could potentially detect the presence of noncoherent DMA (see x86's
kvm_arch_[un]register_dma()), but devices can be assigned long after
we've computed the vCPU feature set so no chance of limiting FEAT_HAFDBS
to situations where the stars align.

Thanks,
Oliver
