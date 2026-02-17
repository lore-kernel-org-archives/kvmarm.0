Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B496C3382EE
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771330410; cv=none; b=Q2jSFXIYCruouo2ERZBmo/luoGfKERvAHp/06diPg3ZqstKMB5+88Q5mhxZQF47I+sSpbg+x54K2UJrfHyz+V+nwFWjsAPcoiOY5I4KSCLPiS2nGrfNX3Fu2UyKtU5W5i74DojvujHDiS72YaCzNTSbyc7/XLwwnHnZ2edw/Quc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771330410; c=relaxed/simple;
	bh=ZcmdwvD+Ytf9TvbpZjsGSZ51nONOOm22E5FYt3DLyfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlYpDzaG8S33ZJMv1Bt5ANGZs9yRKRsvwJJfvcuKbcKqQF5SJVPiaSApn3Ik8xvNy/sp9yC6JiVtWfiyA9K5VViakwdZEHkTviQKEbDhqPgcvbeeTGrcpds4lcPSC7xbiavY90iMAPM2V1GdjwCs2XRODXUeDK3HdFNjywd/avI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJn+hUpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJn+hUpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B2C4CEF7;
	Tue, 17 Feb 2026 12:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771330410;
	bh=ZcmdwvD+Ytf9TvbpZjsGSZ51nONOOm22E5FYt3DLyfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YJn+hUpU+jV0R3ilaDWttYT5aln5YTQ728AwNAt0nBQXNGeqHu0HGZIxD9Ql1Uh1m
	 57Iy/4YX4aBf5BKFF6ozfVJpX4YL9oq5wkqz6a3OCNPbVd6jk8vr96xaiyQOlTHVC7
	 m7EhutR+0ZqicUYngky1aAJqdMwNxLI0fB0tvIKrmnUPGe/gqHg6FujRkU5gW2MgZC
	 qYeK/68xhadA65dgJljteU6Ahy4J+y3lBdKrcjMAujU1uUc1SJigu6IBBTh/l3Zbpj
	 Z2ziZF/vbFopalBFwLPH20eMR+mZc0tmUTf8IRS3CjY5Lr61QZERmMGg1ssRSqh9JH
	 M7nyzzcnb80dg==
Date: Tue, 17 Feb 2026 12:13:24 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZRbZOT13aT60Z70@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <aZM9kv9X5KjeM94j@raptor>
 <aZNPdDAHiLpTvGnS@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZNPdDAHiLpTvGnS@willie-the-truck>

On Mon, Feb 16, 2026 at 05:10:17PM +0000, Will Deacon wrote:
> On Mon, Feb 16, 2026 at 03:53:54PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
> > > On Mon, 16 Feb 2026 13:09:59 +0000,
> > > Will Deacon <will@kernel.org> wrote:
> > > > 
> > > > The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> > > > generation in guest context when self-hosted TRBE is in use by the host.
> > > > 
> > > > Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> > > > TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> > > > per R_YCHKJ the Trace Buffer Unit will still be enabled if
> > > > TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> > > > Trace Buffer Unit can perform address translation for the "owning
> > > > exception level" even when it is out of context.
> > > 
> > > Great. So TRBE violates all the principles that we hold true in the
> > > architecture. Does SPE suffer from the same level of brokenness?
> > 
> > I think not currently - I_JZRDG from DDI0487M.a.a says that after a PSB + DSB
> > 'no new memory accesses using the lower Exception level translation table
> > entries occur'.
> > 
> > But looks like the behaviour will be changed so that it will be similar to TRBE,
> > according to the Arm known issues document [1], added in D23136:
> > 
> > 'When the Proﬁling Buﬀer is enabled, proﬁling is not stopped, and Discard mode
> > is not enabled, the Statistical Proﬁling Unit might cause speculative
> > translations for the owning translation regime, including when the owning
> > translation regime is out-of-context'.
> 
> I think SPE is ok, as __debug_save_spe() clears PMSCR_EL1 and (unlike
> TRBE) PMSCR_EL1.ExSPE _are_ factored into whether or not profiling is
> "enabled".
> 
> So there's a funny asymmetry between SPE and TRBE, which I assume is due
> to the coresight much associated with the latter.

Urgh...

Alex and I spoke a bit about this on irc and we think SPE might suffer
from the same problem after all. It just uses different terminology, so
it's not as obvious to shake out from the TRBE example.

With TRBE the problem is that we have:

  * TRFCR_EL1 controls whether or not trace generation is "prohibited"

  * TRBLIMITR controls whether or not the trace buffer unit is "enabled"

With SPE we have:

  * PMSCR_EL1 controls whether or not *profiling* is "enabled"

  * PMBLIMITR controls whether or not the *profiling buffer* is "enabled"

Unlike TRBE, the SPE spec doesn't talk concretely about address
translation but I think it's safest to assume that the profiling buffer
being enabled means that it can translate out of context, similarly to
TRBE.

So we'll need to zap PMBLIMITR as well. I'll cook something for v2 but,
as before, I'm going to struggle to test this (I think SPE got whacked
at EL3 for a bunch of errata on the devices I have).

Will
