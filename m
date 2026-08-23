Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB983D1AB5
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787490588; cv=none; b=Z8Y1AJfLZXT4WN5oKRsFq+/wmAkhLj9kJKID/DedTBdsJUdc0ajHJqXq4GT6WDcQ9WG1dL8otlLcC/eXR545/xvRoqyuxUIDQJsw5RnLnKxI9p6P8x09p6bJhgb7TDIoCIb6ectYvzm6tZxUDsQVy//DESprml9rRsxQgsHjp2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787490588; c=relaxed/simple;
	bh=+5k1rXmTX/it9boYs3lIDPyaHBv4G9129/fVZ2lADWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PJRGn4Z0colQ/spIsviLactGfiFEtB4IwvEAzObJlg3NRn0UjYrQVJxc6FdrBsr79CcM+eP2xL1wf3o5fVzfeMeXnLGFwj3wDPA1BeaJNQ0K095Vi03kmTdqFEZMeW3xEQFD2juPnkLhvwcIv6hUCLrShxefRcimwrinPC0SHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HP7iy8wk; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HP7iy8wk"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+5k1rXmTX/it9boYs3lIDPyaHBv4G9129/fVZ2lADWQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787490583; v=1; x=1788095383;
 b=HP7iy8wkYruvox1Q1XkjaZh06SZIuJ9J4kFAkJd1WQuoSTROk9ASvJzdGOpM4P43GwW2S1ZF
 bq1vMBxkefzmf3xbefBzneNP2Owb+l5hwAKpSUG0PHbOliU/rj7TqZfAQsxxW7mM4UOzLJAulzl
 ngTSSnWD0HIwTsS7m08vl3x8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f47.google.com (209.85.167.47)
	by smtp.migadu.com with ESMTPS id d2a439ac7d2d51e0;
	Sun, 23 Aug 2026 13:09:43 +0000
X-Mizu-Trace-ID: d2a439ac7d2d51e0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso6703e87.0
        for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 06:09:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoKH7rqQRv62+ztIKDG4q4A6dChQ/BpWW6I3Buh9cWiyO+4/mHABcQ4M9sEis0OKssnehRsm+c=@lists.linux.dev
X-Gm-Message-State: AFuF++nSIpZrVC5RZqlIBauqYO6FeJGcHetos4tW3GPHgFFPDBVxuxwX
	v0sbaNlJXwN9kCRSfV9u7b73ncIbLZNAYmiWKDFx4aNjB+8b4Dwc330zXco0CmUoB2czBpBD5uz
	pGHSMhbmiVJJaoWMDLwD5JkI0eW3nP5BIPD69GXR0
X-Received: by 2002:a05:6512:110a:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b48c2f3ce4mr101634e87.1.1787490578785; Sun, 23 Aug 2026
 06:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260819142558.1300100-1-fuad.tabba@linux.dev> <86se464ixe.wl-maz@kernel.org>
In-Reply-To: <86se464ixe.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 23 Aug 2026 14:09:02 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwCuSO37k3mJSJLPW4kHHN+MTWYiLRLQMzNzisMsunQ=A@mail.gmail.com>
X-Gm-Features: AcwNN1VTPhsoVRXIEYl1K8kNwsfcX0dYbmxiyufgRZKr-RVlTK7GPAHaV8SAaFM
Message-ID: <CA+EHjTwCuSO37k3mJSJLPW4kHHN+MTWYiLRLQMzNzisMsunQ=A@mail.gmail.com>
Subject: Re: [PATCH] arm64: Defer the GMID_EL1 read to {init,update}_cpu_features()
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Oliver Upton <oupton@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 22 Aug 2026 at 10:13, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 19 Aug 2026 15:25:58 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > __cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
> > ID_AA64PFR1_EL1, so it reads the register on MTE hardware even when the
> > kernel has disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets
> > HCR_EL2.TID5 in that case, which traps the read to EL2 and injects an
> > UNDEF:
> >
> >   Internal error: Oops - Undefined instruction: 0000000002000000 [#1]
> >   pc : __cpuinfo_store_cpu+0xf4/0x264
> >   Call trace:
> >    __cpuinfo_store_cpu+0xf4/0x264 (P)
> >    secondary_start_kernel+0xc8/0x1d0
> >    __secondary_switched+0xc0/0xc4
> >   Kernel panic - not syncing: Attempted to kill the idle task!
> >
> > Only pKVM is affected, and only for a CPU onlined after KVM init: its
>
> Is that for a CPU that has gone through a an offline/online cycle?
> Because otherwise, such a CPU wouldn't be able to boot at all (we have
> a strong requirement that pKVM sees all CPUs at boot time).
>
> If that's the case, some clarification would be good. Otherwise, some
> clarification is absolutely required! ;-)

Yes, an offline/online cycle: every CPU's first bring-up happens
before KVM's initcall, so hotplug is the only way to reach
cpuinfo_store_cpu() with TID5 set. I'll say so in v2, along with a
note on the reproducer (offline then online CPU1 with arm64.nomte, on
QEMU with MTE enabled).

As a side note, to answer a question Will asked me offlist, it's not
an issue in any of the Android versions: Android 17 (and earlier)
never gets the trap. The Android commit that disables MTE there does
the HCR_ATA hunks only, and there is no handle_host_mte() either, so
the read is untrapped.

> > PSCI CPU_ON relay sets the host HCR before the CPU enters EL1, whereas
> > plain nVHE sets it at CPUHP_AP_KVM_ONLINE, after cpuinfo_store_cpu().
> >
> > Defer the read to {init,update}_cpu_features() and gate it on the
> > sanitised ID register, as MPAM already does. system_supports_mte()
> > cannot serve as the gate, as update_cpu_features() also runs during
> > initial SMP bring-up, before smp_cpus_done() calls
> > setup_system_features(). The init path gains the CONFIG_ARM64_MTE test
> > the update path already had, leaving SYS_GMID_EL1 uninitialised when
> > MTE is compiled out, where its only other user (lib/mte.S) is not
> > built.
>
> I'm starting to wonder whether having CPUs to go through a feature
> collection process during an offline/online cycle is a good idea. The
> data should still be there, and is not expected to change.
>
> Is it just that we don't have the correct tracking information?

I think you're right. Nothing on the arm64 side tells a re-online from
a first boot, so secondary_start_kernel() collects everything again.
The tracking is there I think: notify_cpu_starting() sets
cpus_booted_once_mask, and it runs right after cpuinfo_store_cpu(), so
the mask is usable at that point. Gating cpuinfo_store_cpu() on it
would skip the collection and the cross-check against the boot CPU on
a re-online, and leave the verification in
check_local_cpu_capabilities() as is.

That changes what hotplug does on every arm64 system, so I'll send
this other patch after the merge window, and keep the current one as
the narrow fix for stable (the trap is in 7.0 onwards). Does that
work?

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
