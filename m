Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C7C1494A9
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734454989; cv=none; b=aqYMh1qFps2s9tSPqEB8h5/17DVB32XaQew/gfgyPECgSTIaEal8cvs8AUw0f/iiXmtRIjVAHVLxoY58HzWoeeUteR3cRUnXt+zUNJb766xRoRHFIR5awKUY6H7lzBgXS6IJJclmvKMTZlzRnQ2LdE0UrglVLozZMAHkB9wqFho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734454989; c=relaxed/simple;
	bh=y4rvd2i45ul2OIU5/nJesQGlmoS4ZWQ/I/mmlz+Q+ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWE5qqRqyyvGNZi/AEXBtHiE9g6CmNL6RfvpmMQuvO+r5YewWrNo5mlJ/WfG7zj4NyXEA6j7Zj+kxUVAhL41j/e6VBeMOPZMlviBQ60hFEZMJs9tVlLXFt7RLysKcd0Nq+Qrg+MyFXp/+GB6fePaLI5gIvb5e9ZMcAx536CuPFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3A/LYSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3A/LYSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30787C4CEE0
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734454989;
	bh=y4rvd2i45ul2OIU5/nJesQGlmoS4ZWQ/I/mmlz+Q+ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i3A/LYSqFumD5PYmmp1gUpj+0qB+2xkRxXi2l7E/ripxz9fZlHVcmj9lsU0HxzRn+
	 QIMV4RbqDd6Tu3z16J+OVDrfXm3Uxmh17biZLf/xWBqmE6dMMTgkuO8uIY14maKNEh
	 SezSLO9l7KNVKfJZ+bxBU+u34gVl1pwJb0vdDevX/hCV4MzgzXRLYIzT7a9LERiyvo
	 YBImUV+TW740F6GnGi1LQQqLkDEGSN2BdjOR89EhfsxhX/aOlCpYjmsFN54iRL52Rp
	 RwuVUqtXEhMrph6yYSdO7cUrB3H1BNp9VcVu9068jW3oEMa5F2eBR0DLQQtuzZPeG9
	 FWAiFeBIcdnZg==
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e3983426f80so3590708276.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:03:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUNTEBKl9lXkM0LVCK9AMsI1brL9Q5WcnQcm1X/CRtXInEzb09ryROt6+ip6RvBNHLzcixbHEo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc5aIq/UMd0QlKUb2ciS95YMWqenHjxHvCP1pajf5btIUarlGL
	5gojJlv4eSYyUvP3WislWdvKeRASgadxv8MMczFmtoRl8KlnUFKAKmTQY1Xqfai9Bfq20ukMxjZ
	BruOeuV1Nen3zQq3eQOW3epbs6w==
X-Google-Smtp-Source: AGHT+IGKvG8I/im/k/IPybn045bPPxXVEzIGxeaZoFQYWf7CnT275gjzpCkuXW1FxOqOUlHA0uA3p6+cPeXvMyJJp6Q=
X-Received: by 2002:a05:6902:2681:b0:e4b:b2bd:5fa0 with SMTP id
 3f1490d57ef6-e53606627d2mr320097276.20.1734454988345; Tue, 17 Dec 2024
 09:03:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-19-anshuman.khandual@arm.com> <20241216231505.GA601635-robh@kernel.org>
 <a442bca4-d1c0-4f3e-ae13-4836caec2da9@sirena.org.uk>
In-Reply-To: <a442bca4-d1c0-4f3e-ae13-4836caec2da9@sirena.org.uk>
From: Rob Herring <robh@kernel.org>
Date: Tue, 17 Dec 2024 11:02:57 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+45YNGNEcDVFvKH3Tiwtz0HF9_O4tPfQH0dbXra2bcRQ@mail.gmail.com>
Message-ID: <CAL_Jsq+45YNGNEcDVFvKH3Tiwtz0HF9_O4tPfQH0dbXra2bcRQ@mail.gmail.com>
Subject: Re: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
To: Mark Brown <broonie@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 9:30=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Mon, Dec 16, 2024 at 05:15:05PM -0600, Rob Herring wrote:
> > On Tue, Dec 10, 2024 at 11:22:43AM +0530, Anshuman Khandual wrote:
>
> > > +Sysreg     PMUACR_EL1      3       0       9       14      4
>
> > I already added this and various other PMUv3.9 registers you've added
> > here in v6.12 and v6.13. So are you on an old base or the tool allows
> > multiple definitions? If the latter, that should be fixed.
>
> The tool is written in awk and hence *really* dumb so it's not going to
> notice this, and so long as the resulting definitions are identical the
> compiler won't either.  It would indeed be nice if the tooling were able
> to detect this.

Something like this should work:

git grep -h '^Sysreg\s' arch/arm64/tools/sysreg | tr -s ' \t' ' ' |
sort | uniq -c | sort -n | grep -E '^\s+([2-9]|1[0-9])'

No duplicates currently.

Rob
