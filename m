Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A734D4F9
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 15:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787584527; cv=none; b=e9OF2CPZkK5SgykuGKsI1EJCA0i1cdHWDZpJj6mW51PR8K6Exobt7XEm/RSUAOLX+RRCmwR4Uuy2g8p3TZU0sMsw03qqg6ajnwfvASkmCLzKdz9grxv4oK0xQu+xKb0xqdBBZjA68PVz5C3zn9xC6637wh40lQf5ef6iY/FIMro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787584527; c=relaxed/simple;
	bh=c06Gx503jxl6pcEkyyFWb7rMuvr9i6fZ7D0GH9SHlCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nawyL4jZh48vgrLZlOcifbD9RyDGwnH5e/vJvd6/7OhNShpVoxEv/0ymHPfp6Ez+1Ao8shGQTxBSzPeLWOJaIViPzFjvLLDDEcsYuHF7q2ZURlPHGs8PEUHCN/cqjgGS7860HzKLK1apO9y6mHYWZC02ftdEGZGnNc0oE0okXFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ry7Yu3ZY; arc=none smtp.client-ip=91.218.175.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ry7Yu3ZY"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=c06Gx503jxl6pcEkyyFWb7rMuvr9i6fZ7D0GH9SHlCw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787584523; v=1; x=1788189323;
 b=Ry7Yu3ZYXmvAejDifO6nVNevgszyvptiW0V9Z9BNV9Y9iCVxneQtvygxoUKz5aMw+JIbXcYf
 Osxzsh9UQFHzvfxcAjgsrjqh8n3YGsbziWnHsPCFG72RXdo0YGLAQMRQIzcw2b3bqkkeAQqAxpo
 xrYbwpWA5WISZXJV5/rISklk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f43.google.com (209.85.167.43)
	by smtp.migadu.com with ESMTPS id 1e7690fe7d7b2e14;
	Mon, 24 Aug 2026 15:15:23 +0000
X-Mizu-Trace-ID: 1e7690fe7d7b2e14
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so13030e87.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 08:15:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq9W5K0J953ZgPHsO+ZWAoA7Ogad6R0EYaIze1kQrVEVgN7JM/ohFoM9N1rdBCqIrrUKsA4pr8=@lists.linux.dev
X-Gm-Message-State: AFuF++kw4y6iKt7er4nXEN3n3axdLKfdNC0kvSUCL7EnIfHNLVZBAN2U
	6wFjYt7MrZqaNAxV8CmCZL0xfh0nLmSqDI6kHZAPJ1YcWJ5Eb2Ye24p7iKazv2gL5/Qf7eHHafH
	F1C82Nzo2SAH5G05dcUp/ey6gdFlQ1aW6E9a3MVp0
X-Received: by 2002:a05:6512:ad5:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b48c308b7fmr281232e87.5.1787584518113; Mon, 24 Aug 2026
 08:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260824071004.504894-1-fuad.tabba@linux.dev> <aoxCk5lFQv6lFwHQ@willie-the-truck>
In-Reply-To: <aoxCk5lFQv6lFwHQ@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 24 Aug 2026 16:14:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy6Xh=eNg22fBdjPzZOZitzvcDX2L5zbSUFCsX1n6XobQ@mail.gmail.com>
X-Gm-Features: AcwNN1XvpxGBrD3A5SrELJ33c_fc3D2mqO8UzqmTV8IHCn1exQF3tnUOLYiOz8g
Message-ID: <CA+EHjTy6Xh=eNg22fBdjPzZOZitzvcDX2L5zbSUFCsX1n6XobQ@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: Defer the GMID_EL1 read to {init,update}_cpu_features()
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 24 Aug 2026 at 14:09, Will Deacon <will@kernel.org> wrote:

> > +     /*
> > +      * info->reg_gmid deferred to {init,update}_cpu_features because
> > +      * reading it traps to EL2 when MTE is disabled.
> > +      */
>
> I don't think we should defer this, as I've been actively doing the
> opposite for parallel CPU onlining (where the ID registers can be read
> concurrently by incoming CPUs to amortise the cost of a trap) and also
> for the RNG traps during early boot:
>
> https://lore.kernel.org/all/annJ0oDB2HObQC5j@willie-the-truck/
>
> If you look at the diff I sent in the thread above (I didn't get a
> reply), the idea is that __read_sysreg_by_encoding() reads from the ID
> register values stashed by cpuinfo_store_cpu(). So you could use that
> to check id_aa64pfr1 before reading gmid, as it will give you the
> sanitised view.

I just did, but I don't think it'll work. The thing is,
__read_sysreg_by_encoding() gives the override-applied local value,
not the folded sys_val.

arm64.nomte is a command-line override, so that works. But
CONFIG_ARM64_MTE=n sets none. Any gate would still need an explicit
IS_ENABLED(CONFIG_ARM64_MTE).

That said, I don't have to defer it. I can keep the info->reg_gmid
read in __cpuinfo_store_cpu() and gate that read on the state that
arms the trap:

        static inline bool gmid_el1_accessible(u64 pfr1)
        {
                if (!IS_ENABLED(CONFIG_ARM64_MTE))
                        return false;
                if (system_capabilities_finalized())
                        return system_supports_mte();
                return id_aa64pfr1_mte(pfr1);
        }


TID5 is set from system_supports_mte() and only once capabilities are
finalised, so the local check is still correct before that. Gating on
system_supports_mte() keeps the different-physical-CPU case you want
to preserve working: if one re-onlines with MTE while the system view
has it folded off, the gate stays false and it won't read GMID_EL1.

If you agree, I'll respin with that.

Cheers,
/fuad





>
> The only snag is that I didn't convert all the registers over, so
> there's some work there.
>
> WDYT?
>
> Will
