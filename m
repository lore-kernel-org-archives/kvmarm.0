Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E11FBE9A
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878602; cv=none; b=DZBlm8Lt7u0vianUpEGC4XD77Ak+b45gEVWFj6Ccir6k9fkfLgx4iJPPwNgpEHQS+2LyXcGc/xq8JQHOFiZbRHCFykkCefKeSPBu00IWwqbNVpp2l0xtJtV7ityCMlNBrjG+5BmIAs2v9/3SOj46Mzgkwl7VPWaV6O+YrB1AEN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878602; c=relaxed/simple;
	bh=RKYfSmZK+kMBn4RgSfJDwulSLPDgEUTwy7dfVhaPYOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/Drm2oIfPHSX6+IjoEMlNJ4ABgUDhsVt9Ir+iEKjKMjbQXs6MijQxs2hsRFg9LOhtx0jzDgzL9eU+6UMPwbtkbreG5IOWKTIjjyMHNvkYkpIFzlYSpJrauxYuCkxmpqe1TY9v//cv6GmQ92Cf/XeC+A4VkW0Rrcnps9OWTlmTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/C5wTpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/C5wTpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCD0C4CEE3
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 18:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736878602;
	bh=RKYfSmZK+kMBn4RgSfJDwulSLPDgEUTwy7dfVhaPYOA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K/C5wTpfG4Rd2MWgb8z1Md/0zBuecYRLF4yjUTwNCzsEUwnYC9rfJP5HGvNKsdsQ7
	 DksaQp9opt+0DIrVX09XT+s8ubO47xlLZkLCkD/KuRE+zwQnWyGxyb+7hg50jCeVYQ
	 MeSGnhYI0UnCUJw3KsIejluh0FFTjHs2DLCw6O4dPSu5vm4Ebd5McmVPyh2Xcig58w
	 n+bUhXyND9d+xVWCKR+XpsqzHZhACxtKlTPou0UrFRcmGzPnV5pJPfotHIhxGHRKKD
	 WB1renVdw0E49qNEfSEP38+zjP0HUA1wF6xvenn95g9onngZ6NV/220m44HqWiGr3O
	 AeQ3N6RZWxzNA==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53e399e3310so6022469e87.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 10:16:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWFgPgCKnv/qf3UgXcaM0ngzg4hcZjBvpIyMApATXs6efn0xRN2xJOR8N0rE+tR/E3urkDuHxM=@lists.linux.dev
X-Gm-Message-State: AOJu0YztQX2hetXyA9lT9sXx7/twm75xJAwIlvoTzyF8lUqBmQRw9Ovp
	LJtnWO8m+BRq9vNtL5qgMcmxnZxZn+aSFj/OFwP+W6lyL22424atk0KgqOoABdk6wmwWKxeHGXj
	pk3uAhKfeuvvhPJOi8J13+JOg5w==
X-Google-Smtp-Source: AGHT+IGGOq29Ly0ZiReSsSG4zDCnevGMV01cjuVIyjShG009A/m7+eOZbOSwPYztyfDKw2UikdO/TdT9vSPsjA2CrSc=
X-Received: by 2002:a05:6512:ba5:b0:542:a73d:a39c with SMTP id
 2adb3069b0e04-542a73da516mr1491477e87.49.1736878600307; Tue, 14 Jan 2025
 10:16:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org> <87frloqjso.wl-maz@kernel.org>
 <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org> <86jzaywtea.wl-maz@kernel.org>
In-Reply-To: <86jzaywtea.wl-maz@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 14 Jan 2025 12:16:27 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
X-Gm-Features: AbW1kvYckisY3EJJj3cTSTGDYaoMGnLnDfmXedaqQOVtLizCHFObKT-9BYcwz9s
Message-ID: <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
To: Marc Zyngier <maz@kernel.org>
Cc: James Clark <james.clark@linaro.org>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, coresight@lists.linaro.org, 
	James Clark <james.clark@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Shiqi Liu <shiqiliu@hust.edu.cn>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 10:49=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 13 Jan 2025 15:43:39 +0000,
> James Clark <james.clark@linaro.org> wrote:
> >
> >
> >
> > On 12/01/2025 12:49 pm, Marc Zyngier wrote:
> > > On Tue, 07 Jan 2025 11:32:41 +0000,
> > > James Clark <james.clark@linaro.org> wrote:
> > >>
> > >> From: James Clark <james.clark@arm.com>
> > >>
> > >> There are a few entries particularly at the end of the file that are=
n't
> > >> in order. To avoid confusion, add a comment that might help new entr=
ies
> > >> to be added in the right place.
> > >>
> > >> Reviewed-by: Mark Brown <broonie@kernel.org>
> > >> Signed-off-by: James Clark <james.clark@arm.com>
> > >> Signed-off-by: James Clark <james.clark@linaro.org>
> > >> ---
> > >>   arch/arm64/tools/sysreg | 2 ++
> > >>   1 file changed, 2 insertions(+)
> > >>
> > >> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> > >> index b081b54d6d22..4ba167089e2a 100644
> > >> --- a/arch/arm64/tools/sysreg
> > >> +++ b/arch/arm64/tools/sysreg
> > >> @@ -48,6 +48,8 @@
> > >>   # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces e=
numeration
> > >>   # item ACCDATA) though it may be more taseful to do something else=
.
> > >>   +# Please try to keep entries in this file sorted by sysreg
> > >> encoding.
> > >> +
> > >>   Sysreg   OSDTRRX_EL1     2       0       0       0       2
> > >>   Res0     63:32
> > >>   Field    31:0    DTRRX
> > >
> > > "Do as I say, don't do as I do".
> > >
> > > I don't think this makes any sense if we don't actually sort the file
> > > the first place.
> > >
> > >     M.
> > >
> >
> > I think it's ok if it avoids review comments that new entries should
> > be sorted. Or maybe we do the opposite and the comment should say this
> > file is allowed to be unsorted...
>
> The better option would be to add the comment *and* sort the file.
> Leading by example has some value, it seems.

IME, it's better if documentation just states what the tools enforce.

Can't we add something like this to the header generation:

$ grep '^Sysreg\s' arch/arm64/tools/sysreg | sort -n -k3 -k4 -k5 -k6 -k7 -c
sort: -:22: disorder: Sysreg ID_MMFR4_EL1       3       0       0
 2       6

Rob
