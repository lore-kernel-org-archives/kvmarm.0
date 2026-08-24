Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4441DDF2;
	Mon, 24 Aug 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787577088; cv=none; b=ZVl80u76XQkhNsaVNJGy46pOpY+xTBcxeLz/MFVqiKNHVUCpLmmrbuE+Yo9YfThkLBI5z6xluLvUt4Ef9t5/zTrIp/uEoDFHKLkPQsMDt/apxqPLoC/wNEh54gfWLBK4ihWobWXFTRyKQgBTbu9siQ2yCB3pEOAazh7GWMXioMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787577088; c=relaxed/simple;
	bh=LcNO0u4GdRBXz1SiMceApW9NzNRbdNrIo26k+v9FBbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhuCCinYs81Can9fjadPtNaLEp7tIHOERLm9lQ3e95oH3/CVjmXBt1YAn/wZxqvDlAR4pvx1/WbbAXJ1FY2zP8w2jBhI3heINhPR4oZVEuFQc+yuh0xzMYLyGyCvv1M3IAF+79VuvikOdRYhGQWj3ZF/enP99xOjPC9mSarDuVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0VtTwaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0VtTwaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5DF1F000E9;
	Mon, 24 Aug 2026 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787577087;
	bh=n7HiGwiy8zh65H/ghfLKcvCaAQ1QBuBFk3PdyU2HykY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o0VtTwaVRqk1Dla6o9ikX8ehZRhFLRvgPMp2mxYi/khhbWyA9gGo0waep43QA/sRf
	 euxBdA7EIKPc4iin04QTtnISHevt3xYr+NItQVfXyAicmxGdHa7MyStMM8WX7QNPAS
	 u8ZzLsLL2hlIuG2ipFHPxdntXjplJwTtyyNqZ3Rp5kjDeL10kNJwHKelby5Gvo4rMB
	 tODx4lfhpK47P1fl6L3DjCidb4/BWYWFTW0pyVxgk2g7R9KyS5RfvYbilzZhtA51NO
	 yByd9QPW3bOI/wGNyi4YyUJOB1TU3HbcQckrEefKcxPlTG+RuoMRddRlnqdjEG/hhJ
	 AspuCfHlYou5Q==
Date: Mon, 24 Aug 2026 14:11:22 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: Defer the GMID_EL1 read to
 {init,update}_cpu_features()
Message-ID: <aoxC-nyNc7Z6hHrK@willie-the-truck>
References: <20260819142558.1300100-1-fuad.tabba@linux.dev>
 <86se464ixe.wl-maz@kernel.org>
 <CA+EHjTwCuSO37k3mJSJLPW4kHHN+MTWYiLRLQMzNzisMsunQ=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwCuSO37k3mJSJLPW4kHHN+MTWYiLRLQMzNzisMsunQ=A@mail.gmail.com>

On Sun, Aug 23, 2026 at 02:09:02PM +0100, Fuad Tabba wrote:
> On Sat, 22 Aug 2026 at 10:13, Marc Zyngier <maz@kernel.org> wrote:
> > On Wed, 19 Aug 2026 15:25:58 +0100,
> > Fuad Tabba <fuad.tabba@linux.dev> wrote:
> > >
> > > __cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
> > > ID_AA64PFR1_EL1, so it reads the register on MTE hardware even when the
> > > kernel has disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets
> > > HCR_EL2.TID5 in that case, which traps the read to EL2 and injects an
> > > UNDEF:
> > >
> > >   Internal error: Oops - Undefined instruction: 0000000002000000 [#1]
> > >   pc : __cpuinfo_store_cpu+0xf4/0x264
> > >   Call trace:
> > >    __cpuinfo_store_cpu+0xf4/0x264 (P)
> > >    secondary_start_kernel+0xc8/0x1d0
> > >    __secondary_switched+0xc0/0xc4
> > >   Kernel panic - not syncing: Attempted to kill the idle task!
> > >
> > > Only pKVM is affected, and only for a CPU onlined after KVM init: its
> >
> > Is that for a CPU that has gone through a an offline/online cycle?
> > Because otherwise, such a CPU wouldn't be able to boot at all (we have
> > a strong requirement that pKVM sees all CPUs at boot time).
> >
> > If that's the case, some clarification would be good. Otherwise, some
> > clarification is absolutely required! ;-)
> 
> Yes, an offline/online cycle: every CPU's first bring-up happens
> before KVM's initcall, so hotplug is the only way to reach
> cpuinfo_store_cpu() with TID5 set. I'll say so in v2, along with a
> note on the reproducer (offline then online CPU1 with arm64.nomte, on
> QEMU with MTE enabled).
> 
> As a side note, to answer a question Will asked me offlist, it's not
> an issue in any of the Android versions: Android 17 (and earlier)
> never gets the trap. The Android commit that disables MTE there does
> the HCR_ATA hunks only, and there is no handle_host_mte() either, so
> the read is untrapped.
> 
> > > PSCI CPU_ON relay sets the host HCR before the CPU enters EL1, whereas
> > > plain nVHE sets it at CPUHP_AP_KVM_ONLINE, after cpuinfo_store_cpu().
> > >
> > > Defer the read to {init,update}_cpu_features() and gate it on the
> > > sanitised ID register, as MPAM already does. system_supports_mte()
> > > cannot serve as the gate, as update_cpu_features() also runs during
> > > initial SMP bring-up, before smp_cpus_done() calls
> > > setup_system_features(). The init path gains the CONFIG_ARM64_MTE test
> > > the update path already had, leaving SYS_GMID_EL1 uninitialised when
> > > MTE is compiled out, where its only other user (lib/mte.S) is not
> > > built.
> >
> > I'm starting to wonder whether having CPUs to go through a feature
> > collection process during an offline/online cycle is a good idea. The
> > data should still be there, and is not expected to change.
> >
> > Is it just that we don't have the correct tracking information?
> 
> I think you're right. Nothing on the arm64 side tells a re-online from
> a first boot, so secondary_start_kernel() collects everything again.

I think that's deliberate, because we support the mostly theoretical
case of a different physical CPU being hotplugged in. Even though it's
a bit far-fetched for most systems, I don't think it's something we
should break unless we have a good reason to do so.

Will
