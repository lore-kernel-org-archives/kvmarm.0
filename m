Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7D639891D;
	Tue,  2 Jun 2026 05:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379665; cv=none; b=hCZIoAWN0b1rtKqrFX6rhzAIBtIrQaHDEvgXF9ouae6akbUQhYJldzElrd5WNsnWRiSIqVg7EsmGUMB/1Vouz7L89PgNXIMwUtzkAMWxuX2p8JxcWE/H80mkOm92xJ0lJ9hY0cJbzi7ZxAYpoa3MAFBKzvgzFYnIsMHqOGAOMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379665; c=relaxed/simple;
	bh=LQ4Af+mOrsaBz7Jt8y0T4s8dTZqOQdDOR+09c2n+9tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/OBLjqbhla6iBNc1Or4cF7iilxm76p5w8Xxh5fgcwpfE4ffhlvO/Anl8/xAVxvVLTFHy5dghnp9gqEsI9ySQ62J4++u8Bu8HayoaBotr0tnFBv+0xRnvaS2TgtpodfkibJ8Gyx5oB4BpwAUWHOLD8bjiIKhruvwqt0T78bDQbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyUYuEaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyUYuEaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2961F00898;
	Tue,  2 Jun 2026 05:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780379663;
	bh=Dxgi0jgxHF8ZOJD3E0wYhy+yjP1j3xhNtbRyo2XZKFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hyUYuEaZIBffvstbIQtU4xBRLFyatjz177ACyR/00AmIyTLww57nMlfTZqm7JvaFc
	 WptNFndbT9ABnMbAA8D1h45MzsemcWKb76lgHevcDTzBsUFitxJNyEp39LoXP/gCL6
	 DPBXPT0TFN4yCb9C2tZwUyap62F8y6VZvvo+oha/p/83XthtXihrPxwLwbYdanYQgN
	 bbjhcCk8CvPOkbSvtzbHwjiHxdGntgTOpa6qzWlxgRle3YvCRE8iPhDOFmq45IhCtt
	 FkGRZ2jkUZ9ouerlUZR7MLBV5sjRJXbRATfWCC9XYbwZy8fuyrdnOVNEW6hh3PkK/I
	 j4pgkeRqfLdHQ==
Date: Mon, 1 Jun 2026 22:54:22 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Drop the translation cache
 reference only for the erased entry
Message-ID: <ah5wDnNJ7AKGLDxh@kernel.org>
References: <ah2c5lu4JbUg7dj-@v4bel>
 <ah3Yx0fjguUdCk_G@kernel.org>
 <ah4yiavdXTB10P0d@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah4yiavdXTB10P0d@v4bel>

On Tue, Jun 02, 2026 at 10:31:53AM +0900, Hyunwoo Kim wrote:
> On Mon, Jun 01, 2026 at 12:08:55PM -0700, Oliver Upton wrote:
> > Hi Hyunwoo,
> > 
> > Nice find.
> > 
> > On Mon, Jun 01, 2026 at 11:53:26PM +0900, Hyunwoo Kim wrote:
> > > vgic_its_invalidate_cache() walks the per-ITS translation cache with
> > > xa_for_each() and drops the cache's reference on each entry with
> > > vgic_put_irq(). It puts the iterated pointer, though, rather than the
> > > value returned by xa_erase().
> > > 
> > > The function is called from contexts that do not exclude one another: the
> > > ITS command handlers hold its_lock, the GITS_CTLR write path holds
> > > cmd_lock, and the path that clears EnableLPIs in a redistributor's
> > > GICR_CTLR holds neither. Two or more of them can drain the same cache
> > > concurrently, and if each one observes the same entry, erases it and then
> > > puts it, the single reference the cache holds on that entry is dropped
> > > more than once. The entry can then be freed while an ITE still maps it.
> > > 
> > > xa_erase() is atomic and returns the previous entry, so put only the entry
> > > that this context actually removed. The cache reference is then dropped
> > > exactly once per entry even when the invalidations run concurrently, and
> > > the behavior is unchanged when only one context runs.
> > 
> > Next time:
> > 
> > Cc: stable@vger.kernel.org
> > 
> > > Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
> > > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > > index 1d7e5d560af4..1e3706ac3b8e 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > > @@ -597,8 +597,10 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
> > >  	unsigned long idx;
> > >  
> > >  	xa_for_each(&its->translation_cache, idx, irq) {
> > > -		xa_erase(&its->translation_cache, idx);
> > > -		vgic_put_irq(kvm, irq);
> > > +		/* Only the context that erases the entry drops its cache ref. */
> > > +		irq = xa_erase(&its->translation_cache, idx);
> > > +		if (irq)
> > > +			vgic_put_irq(kvm, irq);
> > >  	}
> > >  }
> > 
> > This definitely works but TBH I'd rather just plug the subtle race and
> > do invalidations behind the its_lock since it already nests with the
> > cmd_lock.
> 
> Thank you for the review.
> 
> > 
> > Could you give this a spin?
> 
> After testing, I've confirmed that this patch approach works well too.
> 
> Shall I submit v2 based on this fix?

Yes, please do.

Thanks,
Oliver
