Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794852055;
	b=5GqJEAkiWked1J0mxpsI5xDk6IzQv+Sk8AxN7SkYSRd0nv5IH6+rtCwb5tzVScSosczD
	 +xmondjzMcpAOH+SDJ5CVOsZkgzr/mndtvOFB11Hk9J0L/80Xe5LMY1yXVbJOYf9AdPM2
	 djCSmsDhyrJA9nVBNYw38EJtMidqnMO4DQkPefxIjHZXd66aOHU3Zh6ZZwz/HUyh/LNSy
	 gMDzBcf/VNC46K34mjAI5XctosHuLLVXVV4cQeOBk6iE8gNH7ngE9fxKz2WTCrRzMDY1W
	 6TvE872nu82Htm5sCP+VvzP57Leg/SP9KHH//wkWLftaFgFMSQVRUwYM3wiymy/vFzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852055;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=D/XBLOi0WjEnBxk1dG/LNzqKf7nMH35SVhi22WC5wxI=;
	b=yN7vjnyyUnwN+cKO9IHdN/tXG0SwFOmjPweWZIjGfK8N5sfUpRAyxJiuo2PR3JH1u4lb
	 CRmwQD7bDPglF1nMtEAyRDktuLIBBUjAEjFddlX7m5Mf2hggSfmfDEkzNjM84HdUec3xS
	 XK96tb/rrjmoTLr65L8GuwRKnuaB3AR/0ihn8kSDd60MUP18wN/chb3zf5vnnrdNkWfhc
	 rMbtEBy3J21HqES+jYZgeSJNvVmDOUaATQ8kH7cJx0CLLyhsGsyYYbAWLOuiTFtR/7v2p
	 BEz7sKBIm24OLtUp6cNQo+v7jvGFK3rzbSBIDszkcmVU5B/kcl0iKYe4+6ssSt+FePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BjE33oFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA601606A880;
	Mon, 16 Nov 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BjE33oFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF31F000C9;
	Mon, 16 Nov 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794852055;
	bh=D/XBLOi0WjEnBxk1dG/LNzqKf7nMH35SVhi22WC5wxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BjE33oFMXa4AhDYze0syrDZC6bL5KpQ9tBbRd6fTchO0dU9u1tiqfQDom2owirBZ8
	 sL7dtbAr1WBy5/ihvcYE2iOZccGSKT9NpgN2AH8Pl18JebYWsx7QMxMdvPb8E/xrdK
	 OZT0dbOMekLl95lZiuKd+aUybKVeTNxvM+5ZoxjHrJ6UVetL0SYJETzRwLMij4vlqO
	 3X98MRk/M9aWGH2yC8geBWYvyC21jzZhD3OjctccJvlZe2nEhqmIvzQkjGT00uFhiR
	 1jU0omwb8l85KhpFaT43Du8By1VwRfHDCoDIgVHJqoIS6Rd2WxhOVB7Jf4sLf+ZzxA
	 sHzMNiDdtBlwA==
Date: Mon, 16 Nov 2026 18:00:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 02/28] arm64/sysreg: Define MDCR_EL2.E2PB values
Message-ID: <avtEyQjo7o7Chzw_@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-3-alexandru.elisei@arm.com>
 <atDUMAe0QGP_4swk@gremlin>
 <avSiiFvN13FqNCDm@raptor>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avSiiFvN13FqNCDm@raptor>

On Wed, Nov 11, 2026 at 05:14:48PM +0000, Alexandru Elisei wrote:
> Hi Lorenzo,
>
> On Thu, Oct 15, 2026 at 02:52:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 03, 2026 at 05:05:57PM +0100, Alexandru Elisei wrote:
> > > KVM will make use of the different values for MDCR_EL2.E2PB, document them.
> >
> > As with 1/28, using [0] to check the definition of the register.
> >
> > >
> > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Looks correct, a couple small nits below, with those addressed:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  arch/arm64/tools/sysreg | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> > > index a11a968eb707..4485736a4f49 100644
> > > --- a/arch/arm64/tools/sysreg
> > > +++ b/arch/arm64/tools/sysreg
> > > @@ -4045,7 +4045,12 @@ Field	17	HPMD
> > >  Res0	16
> > >  Field	15	EnSPM
> > >  Field	14	TPMS
> > > -Field	13:12	E2PB
> > > +UnsignedEnum	13:12 E2PB
> >
> > MEGA NIT: Shouldn't there be a tab rather than a space after '13:12'? :)
>
> Fixed.
>
> >
> > > +	0b00	EL2
> >
> > So broadly - this means EL2 owns the profiling buffer right?
>
> Yes.
>
> >
> > This seems to align with the document (which is very verbose, obviously :):
> >
> > "If EL2 is implemented and enabled in the Profiling Buffer owning Security
> > state, then the Profiling Buffer owning Exception level is EL2. Otherwise,
> > the Profiling Buffer owning Exception level is EL1 and, Profiling is
> > prohibited at EL2."
> >
> > "If EL2 is implemented and enabled in the current Security state, then
> > accesses to Profiling Buffer System registers at EL1 are trapped to EL2,
> > unless the access generates a higher priority exception."
> >
> > > +	0b01	RESERVED
> >
> > NIT: Hmm, it seems to be the convention to just omit entries that are
> > missing from the definition in the docs? So is this needed?
>
> Removed.
>
> >
> > I see a couple named ones, e.g. in CTR_EL0.L1Ip:
> >
> > 	# This was named as VPIPT in the ARM but now documented as reserved
> > 	0b00	RESERVED_VPIPT
> > 	# This is named as AIVIVT in the ARM but documented as reserved
> > 	0b01	RESERVED_AIVIVT
> >
> > Which have comments explaining why, i.e. they were defined before but are
> > now reserved.
> >
> > > +	0b10	EL1_TRAP
> >
> > Again my understanding - EL1 owns the profiling buffer, but EL1 sysreg
> > accesses trap to EL2?
>
> Yes.
>
> >
> > Seems to align with docs:
> >
> > "Profiling Buffer owning Exception level is EL1. Profiling is prohibited at
> > EL2."
> >
> > "If EL2 is implemented and enabled in the current Security state, then
> > accesses to Profiling Buffer System registers at EL1 are trapped to EL2,
> > unless the access generates a higher priority exception."
> >
> > > +	0b11	EL1
> >
> > And finally - EL1, traps to EL1 too right?
>
> Profiling buffer owning exception level is EL1, accesses to the profiling buffer
> registers made at EL1 are not trapped.
>
> For the exact trapping priority and possible trap configurations, you can have a
> look at the pseudocode for accessing one of the profiling buffer system
> registers (PMBSR_EL1, PMPTR_EL1 or PMBLIMITR_EL1).
>
> >
> > Again seems to align with docs:
> >
> > "Profiling Buffer owning Exception level is EL1. Profiling is prohibited at
> > EL2."
> >
> > "Accesses to Profiling Buffer System registers at EL1 are not trapped by
> > this mechanism."
> >
> > > +EndEnum
> > >  Field	11	TDRA
> > >  Field	10	TDOSA
> > >  Field	9	TDA
> > > --
> > > 2.43.0
> > >
> > >
> >
> > All LGTM!
>
> Thanks,
> Alex
>
> >
> > --
> > Cheers, Lorenzo
> >
> > [0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-?lang=en

Thanks for all above :)

--
Cheers, Lorenzo
