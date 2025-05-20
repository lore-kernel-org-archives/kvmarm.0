Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAAE25A65C
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747779739; cv=none; b=qdpMKEz4UDCoi6k8l61iaAY4uw34Whb/0/oJaG4rXK/ytDOYkGhe3nV9i5p0VPvi5CmUJkW1NH3J7WOsn8U8LltemsjVlDBTb+fNF1i3y8i37k44U36cn6JfWULh1gv0iGp/4VXSI8KM6IgETVrMulcGGqzRsk8BYt1dsbrXWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747779739; c=relaxed/simple;
	bh=PSFnRhdA6dv0Ibd3iDpTetyUbHtuWoDiaLttMv9a8UA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MuTFjfVZddhlyoAzjKw9Bvh/QC7Gaf7QUxb4Gth5n1IAmr1dsOnQcXnTlX1OHqV7qOKw2lWVirBVuBwmODfJUoQKkiE8e5MgE1Hm079cunXgE+Ex1h7CnfNOZ+y+COpIoLYRhQqUXQmz1INcQqxKRFYgSYKcdtc9CkevNajqKK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqEQU7Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqEQU7Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEE3C4CEF5
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747779739;
	bh=PSFnRhdA6dv0Ibd3iDpTetyUbHtuWoDiaLttMv9a8UA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uqEQU7Qx052CYgFoK14TYHm07pqL9HttCt0RkS5DIje8K9StJYmkNw9g+u8tq/2wr
	 5RGm2y07KmQKKlHfkI1YJiunsSMpznKqf/w90actLrdnMjGb1VjKjpKSU4aDlVbR16
	 XrvTMp7yjpCiU37oOD8ximJLfxaqKVdiRePRN/Yq6OIODft51LuYb3uRnt5BWxjJ24
	 RfLjGHALLZyGQyg5sDTBh8GEDc+MD3xMZibDeL98zsHY2qUrhRHqmtJ0RkN9/ZC1N9
	 34lihYFSdcOg5sPQX+YgaFbGCT5bMgac90T6OXSipHOkysUbowsKJq6bQYrbJr8RFD
	 7SGYVaSrjqcjA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acacb8743a7so1021453866b.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 15:22:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrVUpZOPEqIMXlTgxnbE0lxcbKFxV0cgRel3XN4THfSQPSpx/ElOYop+ysBcXL38Jppeb5xEc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt21ao1/BkICDdsHX4yw+yXcifg6kcOf84nMgv6RoAyzE6mK0R
	LWqSeh4jwIUZrbdxsa0gf9CMhRMwSZlZYgRQxMY0UdGeSEOV1QyNGo6KRgXQ6b/gkH8Nzf7mmj+
	Zg+Ied4NoUunXPkb1tNmY2jb8O44bBw==
X-Google-Smtp-Source: AGHT+IGov0hihbX3nMjv/1exgX1GdOXfquBDi24JqrrM+xtngJD67Rk/E6K9Ejlx6ygNLKgOhEILcowTjixD7Xd6Yss=
X-Received: by 2002:a17:907:3f08:b0:ad5:67f3:73ea with SMTP id
 a640c23a62f3a-ad567f37579mr886028566b.21.1747779737495; Tue, 20 May 2025
 15:22:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-4-ff187ff6c928@kernel.org> <20250519150621.GA17177@willie-the-truck>
 <20250519215651.GB2650608-robh@kernel.org>
In-Reply-To: <20250519215651.GB2650608-robh@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 20 May 2025 17:22:06 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL2KgLQGXRLZJ3txuvytqbRRkdK1nM=5_URO2gH_nZMWw@mail.gmail.com>
X-Gm-Features: AX0GCFtFzlmCBASIuU0YBO76uu_wIfpgFX6QwQXx6mNBYPf-UQnVG91SPo_aQCM
Message-ID: <CAL_JsqL2KgLQGXRLZJ3txuvytqbRRkdK1nM=5_URO2gH_nZMWw@mail.gmail.com>
Subject: Re: [PATCH v21 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 4:59=E2=80=AFPM Rob Herring <robh@kernel.org> wrote=
:
>
> On Mon, May 19, 2025 at 04:06:22PM +0100, Will Deacon wrote:
> > Hey Rob,
> >
> > On Mon, Apr 07, 2025 at 12:41:33PM -0500, Rob Herring (Arm) wrote:
> > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > >
> > > The ARMv9.2 architecture introduces the optional Branch Record Buffer
> > > Extension (BRBE), which records information about branches as they ar=
e
> > > executed into set of branch record registers. BRBE is similar to x86'=
s
> > > Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> > > (BHRB).
> >
> > Since you picked this up from v19, the driver has changed considerably
> > and I presume you will be continuing to extend it in future as the
> > architecture progresses. Perhaps having you listed as Author (and
> > crucially, in git blame :p) with Anshuman as a Co-developed-by: would b=
e
> > more appropriate?
>
> Shrug.

I did a comparison to v18 arm_brbe.c. It was 1134 lines. I (and Mark)
have removed 332 lines and changed 369 lines. So a little more than
half remains, but the unchanged parts are a lot of 1 line helper
functions, brackets and whitespace. So given the more complex parts
have changed, I will change the authorship.

Rob
