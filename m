Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92528CF43
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751296994; cv=none; b=AKNYr+L433xA+O2gGJt6LGiaCGQXKtDQxeCILLK3IkkUEkYJXsKV9Cf+QoDdx7AxOVXt9wZ+2ZMt3Xzb4WEWblR5u6WHady+SfMRlhPAEX1+W3Ftc4VhG98LSkL7AzrXX/cIA98A3u5UeiTZIYWGeR562tzR0w6EHVO5dJuQ3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751296994; c=relaxed/simple;
	bh=m40CaCvXv6dQ/Kik62QOQVVIz2NlJXmaGa9e5MrI4kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0ouUGVdYM9jOQYqpwN8mUXJClw+gmEr0mNejmA+IijOPmXgz7ftUWnKzcR0CGcC7EfE4pelRq7FkkgSuEepE4YeWNql8iM5fFds/yHoKlCeSarLEkdRCa2DKeJsXF+XzqexTuBnf/3i1o0CEAotS9R02pwB2jrs4wqFDm0j3GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gVsupbnr; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gVsupbnr"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e85e06a7f63so1700617276.1
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751296992; x=1751901792; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m40CaCvXv6dQ/Kik62QOQVVIz2NlJXmaGa9e5MrI4kA=;
        b=gVsupbnrkJU6eQ2oMkmLMG8dV5XpR/+2psLgjZc72DQdN18F60Xx6MwuYwyq7hv8Qn
         vcLo5RKaFWvDZuiZPQ0k9sju3v7ku7oES/stCa7KiJxtij8bCKONsbhQJSkS4VIKenXH
         p6qUUPvkeYCs2Uez1FzesQhYoa9/Jl3UYhV+rAEfNV+2b7Dc90OBMxUAcLRG2G3MdsjO
         IE9XXE1ehK3G7ioqDYhPqQmoGVKTCg5STy4ljR4/cI1SMWL3GAYA/UKbv4pC7G3g9YAn
         q2cwwi/b2e+yoipMwNE0qH8uxAyWKVZR148NtmriCFOoxO3A7oJrIMBn6d0x/wz1ny2k
         NOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751296992; x=1751901792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m40CaCvXv6dQ/Kik62QOQVVIz2NlJXmaGa9e5MrI4kA=;
        b=CVNEtS/2B14hjEl8wKOliPY0rkEIvqklyqULfqmQolsOTqLjaI5++lp5v9Fc0287oa
         AVCQFxEQdRqlK0LmDzCEWmAy5nA+D8JyFsDEikApLTDHI8tkjAAgA8lYfXLjV1slaDaJ
         mFUIMmuER8ZYugoqbdxtNwiH1SzAnwGNx50/ftNeOJANC2X1GronU5i4/I9sg8tzSL92
         rjHEUcKPFkmuV4Z6i223h0aJHzK4RNrcTbctN0aAsERaA2O3rWY4DW6mDulCHtgLWha1
         i3sy40WVx6XZWehTcLgAJLWmy6uRRWXUEqefxKaH7djgTGG8ge6OOnHsceBOuZgR1B04
         cz+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6ZvPHo3OJI6QrnS/LcQWQL3p6zrfhSOUuVqWBxnSR67uxCgcH0p5pFTlz4po49KgtGg7e9tg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxY7XhPgeQwcoS4HA9X1SwaqWabppAb9utWE1czrqk5flxU4bDW
	Mlz2EiCmuH2idp2K0pOFw3PHJMLd4j6EzROP4bOhevccSb7R4OAKXIEYMlDb/hdTj49IgaLa0Qq
	ij3I0MCXOotmzdNNs7389UyDyR6iMW2qDX56sfqZyWg==
X-Gm-Gg: ASbGncvDgYwgAF9YRAgEVYOFISgVbvS7sHBPdV1lc3fKMPkfKOME1P29jg/wqmZTq6s
	0FC2EKR001Y0wA1SrZb8XtpzxyIosU+H6zBRqiZUS3cl1r5GUHFWe6FwDustQAGjX63mVxbzLHg
	nrBq80e9qUogrIR3+JgGSLEFfr6UzzTQvz5QS9ecqwUOOc
X-Google-Smtp-Source: AGHT+IFLey3gbDO7x3IaACwxZKzj8qTloEuvMAvkPa8CTVEMIeapmV9N19RDAtE8dOmUNYaIULXNoTjX4myy8R9g/Lc=
X-Received: by 2002:a05:690c:d85:b0:702:52af:7168 with SMTP id
 00721157ae682-7151713694bmr204905857b3.2.1751296991584; Mon, 30 Jun 2025
 08:23:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617153931.1330449-1-cohuck@redhat.com> <20250617153931.1330449-14-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-14-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 30 Jun 2025 16:23:00 +0100
X-Gm-Features: Ac12FXx_QA1CfRyIPMvH1-pew-Ema3cEXUdffZUdmGWz7Wrn2y7JuUohVq0azp4
Message-ID: <CAFEAcA9OXi4v+hdBMamQv85HYp2EqxOA5=nfsdZ5E3nf8RP_pw@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 16:41, Cornelia Huck <cohuck@redhat.com> wrote:
>
> Generated against Linux 6.15.
>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

Stripping out all the lines that just moved around,
here are the additions:

> +DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)

This is ARMCPU::id_afr0. If we want to store this in
the idregs[] array that's fine but we ought to move it.

> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)

> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)

> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)

These are all ID registers we don't implement yet
because we don't implement any features that are
described in them (i.e. our implementation is RAZ/WI).
I guess it's OK to list them here, though we won't
do anything with the array entry.

> +DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)

ARMCPU::id_aa64afr0

> +DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)

ARMCPU::id_aa64afr1

> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)

> +DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)

More ID regs for features we don't implement yet.

> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)

CCSIDR_EL1 isn't a single ID register, it's an array
of them (indexed by CCSELR_EL1). We keep them in
ARMCPU::ccsidr[]. I don't think it makes sense to
have an entry in isar.idregs[] for this.

> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)

ARMCPU::clidr

> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)

This is an array too.

> +DEF(GMID_EL1, 3, 1, 0, 0, 4)

Another ID register for a feature we don't yet implement
(and a slightly oddball one in that it should UNDEF
until we do implement FEAT_MTE2).

> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)

We implement this as a fixed zero in helper.c.

> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)

We construct the value of this one in aa64_dczid_read()
based on ARMCPU::dcz_blocksize plus some runtime info.

-- PMM
