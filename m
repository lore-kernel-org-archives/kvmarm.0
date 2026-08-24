Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD6381EA7
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787596645; cv=none; b=QOP24tFYYAkeQdBYSCS1W6SzLeVZTPTb3qyfAYvDFZsG3fEEtjcLrPrHaIHsljv6BbFCj9nVrEs2OPNU7LrjgysPekOL2zP40Dk+QefPb7+HFl9sSRxS7hH8ePTZ/+5JXECS8KelI4aduGzQZVsRDuN8IzotamRJdhSZx9PtXCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787596645; c=relaxed/simple;
	bh=z1eMC5A17e3WPWEyqxdEPWPA4oSgaXmtkR6wiU7W6FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U1opiZDNsfiiOwBiXczh+Clvryl81BkkuWaPx6RoMR6zaLQDO/AkhAigio3YQGfM71QRRVOWLOrbpPAH3bBScWEDanqv0mDfkZBjorUN3Dvbx1t1lH9mnQKAkaYmQHVAEzUk87g36fcJhv6mUgw7XLw2lltFCQHbOyvzvjfbQn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xTXyesBf; arc=none smtp.client-ip=91.218.175.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xTXyesBf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=z1eMC5A17e3WPWEyqxdEPWPA4oSgaXmtkR6wiU7W6FA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787596640; v=1; x=1788201440;
 b=xTXyesBfm2fMB1ZFYd4YmPNMIv7uwV2ER1cWjre5n5sfrzmWbAMazq2LwjWUkiVIp8L1g3AG
 o1z3My5wvTpR53oNmd8oROXb0n39qaE/HUcjtkFgSBmkQiPKgW/0IwE9Hszs+fqQSg7pOIiykGA
 sA/AOhWiag8/HXLO9LQ8dzzM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f46.google.com (209.85.167.46)
	by smtp.migadu.com with ESMTPS id a3b66447e3b2a528;
	Mon, 24 Aug 2026 18:37:10 +0000
X-Mizu-Trace-ID: a3b66447e3b2a528
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so1401e87.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 11:37:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqhAv/8vIeAqTWYB4eNhBJwVMcAOKcSi1gcA5Vk18mPeZQH6GOUFT/XiJ8+3PWFGfa+5Xg9qRw=@lists.linux.dev
X-Gm-Message-State: AFuF++mFCmawiKUwwmPz0vSfLDV7htA/LWzmlpyNuo1+PgG1qilZS8Y2
	s2QLSzRSBvjPYq9EBM9hSnD4uBsf9CvJALVbSGdmNk/6u8YZs/KP6KQlmMuNGm/8ApfdFpIWB/Z
	dwDRuoeNXMVe6s6pIeiKV/ccQvBZ++rIF/cI+h1c9
X-Received: by 2002:a05:6512:68c:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b49cf97240mr7768e87.6.1787596625703; Mon, 24 Aug 2026 11:37:05
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260824071004.504894-1-fuad.tabba@linux.dev> <aoxCk5lFQv6lFwHQ@willie-the-truck>
 <CA+EHjTy6Xh=eNg22fBdjPzZOZitzvcDX2L5zbSUFCsX1n6XobQ@mail.gmail.com> <aoxpG13UZfKJ2Rfu@willie-the-truck>
In-Reply-To: <aoxpG13UZfKJ2Rfu@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 24 Aug 2026 19:36:29 +0100
X-Gmail-Original-Message-ID: <CA+EHjTynGY1DFY=SP27MF=ioCQA4jnwnpJWCj1DLRqsqEyEUgA@mail.gmail.com>
X-Gm-Features: AcwNN1V9W7VHXq___zx5wU5QYK_PcNw-jBsBbWE1dTJRfIwYwTjUmk-5HFvXctg
Message-ID: <CA+EHjTynGY1DFY=SP27MF=ioCQA4jnwnpJWCj1DLRqsqEyEUgA@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: Defer the GMID_EL1 read to {init,update}_cpu_features()
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 16:54, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Aug 24, 2026 at 04:14:41PM +0100, Fuad Tabba wrote:
> > On Mon, 24 Aug 2026 at 14:09, Will Deacon <will@kernel.org> wrote:
> >
> > > > +     /*
> > > > +      * info->reg_gmid deferred to {init,update}_cpu_features because
> > > > +      * reading it traps to EL2 when MTE is disabled.
> > > > +      */
> > >
> > > I don't think we should defer this, as I've been actively doing the
> > > opposite for parallel CPU onlining (where the ID registers can be read
> > > concurrently by incoming CPUs to amortise the cost of a trap) and also
> > > for the RNG traps during early boot:
> > >
> > > https://lore.kernel.org/all/annJ0oDB2HObQC5j@willie-the-truck/
> > >
> > > If you look at the diff I sent in the thread above (I didn't get a
> > > reply), the idea is that __read_sysreg_by_encoding() reads from the ID
> > > register values stashed by cpuinfo_store_cpu(). So you could use that
> > > to check id_aa64pfr1 before reading gmid, as it will give you the
> > > sanitised view.
> >
> > I just did, but I don't think it'll work. The thing is,
> > __read_sysreg_by_encoding() gives the override-applied local value,
> > not the folded sys_val.
> >
> > arm64.nomte is a command-line override, so that works. But
> > CONFIG_ARM64_MTE=n sets none. Any gate would still need an explicit
> > IS_ENABLED(CONFIG_ARM64_MTE).
> >
> > That said, I don't have to defer it. I can keep the info->reg_gmid
> > read in __cpuinfo_store_cpu() and gate that read on the state that
> > arms the trap:
> >
> >         static inline bool gmid_el1_accessible(u64 pfr1)
> >         {
> >                 if (!IS_ENABLED(CONFIG_ARM64_MTE))
> >                         return false;
> >                 if (system_capabilities_finalized())
> >                         return system_supports_mte();
> >                 return id_aa64pfr1_mte(pfr1);
> >         }
> >
> >
> > TID5 is set from system_supports_mte() and only once capabilities are
> > finalised, so the local check is still correct before that. Gating on
> > system_supports_mte() keeps the different-physical-CPU case you want
> > to preserve working: if one re-onlines with MTE while the system view
> > has it folded off, the gate stays false and it won't read GMID_EL1.
>
> I still don't understand why you have system_supports_mte() here. If
> the CPU has MTE, the CONFIG option is enabled and the cmdline override
> isn't set, we can read GMID just fine on this CPU, regardless of the
> system capabilities.

I could gate on the local value with the override applied instead.

> > If you agree, I'll respin with that.
>
> I can't tell who's calling gmid_el1_accessible() so it's hard to tell
> whether I agree or not. May as well send a v3 though, so we can see what
> you have in mind!

Sending it now. Probably shorter than just describing it.

Cheers,
/fuad

> Will
