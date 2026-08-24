Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50F8357D03
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787610637; cv=none; b=N6KMZN/OBOwC7TaAfAQuRnabt5V3iIS/ufJqcEKDTOB1TuQHc+sKLCEKyONoJcAM4LX1lW626LoI3xEYTDE4fXfS5JhCxJ0b9XU3KY4rSJRa/3a92g5Y56DzYYp7LA5lnoEHLceKd7uKKmqA1t8p407JJgWIRruiv+HPAOR6KQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787610637; c=relaxed/simple;
	bh=C+tpSL7TVsBh+8q3t9TH1pAT+xgr21uNVTJjRSpvMQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XLtxWG4jpsNjMZ14+mqueOZnW2D0FiCRRVARmPU5N3e0cNvJ/RTsPhdZdy4bLulhAIM/l9gSEe8PqLb25hN/tnF7phFTBVfEbN4Srm5Mo7MMBF4XnJXxP5Ohm/RRxbzTnaoRmLLrUGLhGYufQ8YhIdjJpI6XCKUcZosDamn7DIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RbK/5+Jf; arc=none smtp.client-ip=95.215.58.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RbK/5+Jf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=C+tpSL7TVsBh+8q3t9TH1pAT+xgr21uNVTJjRSpvMQQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787610632; v=1; x=1788215432;
 b=RbK/5+JfwpMTr8GCLMfzqzTty3Uy6BkJ1vQGm10GTAEFDhpiuIBAmsrgIORkJcjqUhMw0x7Y
 NzTy6GgXgOWvveFr0K//X+zlmZ+kvsFrqoQcpwKqwAWlkhy6jTRotKhgUrVsr6NESZ7QhqtJ5r8
 oeyaiJTY72P6WGu4KMwQcX/I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f46.google.com (209.85.167.46)
	by smtp.migadu.com with ESMTPS id 7fe8f398f14dceed;
	Mon, 24 Aug 2026 22:30:32 +0000
X-Mizu-Trace-ID: 7fe8f398f14dceed
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a8173142so1311e87.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 15:30:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqFCturMTGXXUggrttsCoxEtGi4bICQ9YPE0EeRpHjhTQ0xBft7Hny0z6CU/iVOWDchWPA4rEY=@lists.linux.dev
X-Gm-Message-State: AFuF++n9bs+Snolqi8FSPvKBUXslOvGVO1UPaVlnOUr5GsB0ThVC9n95
	Oku2dqAzp7QjRx39cDwwOA9WwIuW9lj3LlHuipb2AQOluy/6rXTnFNp9mFzjgmTKmzF++an5VzJ
	L5TztIONlt/toYB1bvh/KeF2lbS/z37IIpmq1JrVM
X-Received: by 2002:a05:6512:68c:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b49cf97240mr50807e87.6.1787610631348; Mon, 24 Aug 2026
 15:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260824184155.2644646-1-fuad.tabba@linux.dev> <aoypji6EJ8zToWvh@arm.com>
In-Reply-To: <aoypji6EJ8zToWvh@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 24 Aug 2026 23:29:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
X-Gm-Features: AcwNN1V5iZSXwG_fjN9lRaKeKRg6baF9PCHCMd29lA92d-wgYEEVof0B_z2gkoM
Message-ID: <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 21:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Mon, Aug 24, 2026 at 07:41:55PM +0100, Fuad Tabba wrote:
> > +/*
> > + * Reading GMID_EL1 when the kernel has disabled MTE traps to EL2, and the raw
> > + * ID_AA64PFR1_EL1 reflects neither CONFIG_ARM64_MTE nor the cmdline override.
> > + */
> > +static inline bool gmid_el1_accessible(u64 pfr1)
> > +{
> > +     if (!IS_ENABLED(CONFIG_ARM64_MTE))
> > +             return false;
> > +
> > +     pfr1 &= ~id_aa64pfr1_override.mask;
> > +     pfr1 |= id_aa64pfr1_override.val;
> > +
> > +     return id_aa64pfr1_mte(pfr1);
> > +}
>
> Can this function not use __read_sysreg_by_encoding() directly and not
> get an argument at all? We'd get the override from that function rather
> than open-coding it here.

Like this?

      static inline bool gmid_el1_accessible(void)
      {
              if (!IS_ENABLED(CONFIG_ARM64_MTE))
                      return false;

              return
id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));
      }

> Eventually, once we get Suzuki's clamping fix,
> it also ensures we won't be able to bump the MTE version to unsafe
> values (but that's a different fix from this one).

Agreed it's separate, but v3 applies the override without checking
that the CPU has MTE2, so id_aa64pfr1.mte=2 on a CPU without it reads
a GMID_EL1 that isn't there. On the boot CPU that's before the
override is sanitised. Should I check the raw register before applying
the override, until the clamp lands?

>
> If you are worried about additional trapping of the MRS, we should go
> for Will's improvement to always read the cached values in
> __read_sysreg_by_encoding().

Not worried :) __cpuinfo_store_cpu() has already read ID_AA64PFR1_EL1
a few lines up.

Cheers,
/fuad


>
> --
> Catalin
