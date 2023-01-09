Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A38C09
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 20:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1004C433F2
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673295533;
	bh=fKmzDa8xWu0AAMUhY9kDg0odlBMun7WpnzbGtGHCOBE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oDX2C9i+FDRvpquD0Tm76+Ztd1AH/yS/g3Qg7WHgxgYL29Ye/phnNYpv6xEpWwKQd
	 JFkLncU8U/jqrN9TiunGb0Sx7rtJBsQjfJUv6/3OJh1oOagbURdbzilqMRkXx05cGT
	 24r5PMAvpKBzBIKcNP6ycQLhO+AC7wPoOldLkZH/s2TmcZuCUy+nl6bew7FhvtUsP7
	 wMo43JkxcraKxsM/4ISzDPaCz++NYL2cfLYyD2xiLF8bmRIjpXGDfMcvlSDIrCmHAp
	 vIGicqV03wqm+0XB+dtNuM4qoJ+/jdj78Mp4Zn8Cn7qKSmPtFVNk0TptynUg3Awio7
	 /ZLLBqlUUNrHg==
Received: by mail-ua1-f52.google.com with SMTP id z3so2309034uao.9
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 12:18:53 -0800 (PST)
X-Gm-Message-State: AFqh2kpUMOC4+msOx09O+cRu0VJI+T/K+4iIszGRL2K0LA9YJ7RKAO92
	DtgP4mjBJg01mCHexcH6EriOAJ/cZaeSOkZsHw==
X-Google-Smtp-Source: AMrXdXs6BTZ+8D74o0hJQvodxrknKckEnyT3FIAUEDSl4Nm2U6u2mch8LVVAz/MbaiofQWil2sRw59UL0KIBA4Gu1cs=
X-Received: by 2002:a05:6130:2ac:b0:573:d2a:e6cf with SMTP id
 q44-20020a05613002ac00b005730d2ae6cfmr3918699uac.36.1673295532626; Mon, 09
 Jan 2023 12:18:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
 <20220825-arm-spe-v8-7-v4-3-327f860daf28@kernel.org> <Y7xsDXFlNjiQ1AIe@sirena.org.uk>
In-Reply-To: <Y7xsDXFlNjiQ1AIe@sirena.org.uk>
From: Rob Herring <robh@kernel.org>
Date: Mon, 9 Jan 2023 14:18:41 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLFSMzmTSAjtWWotzFy=JLr+rjim4F_X5thWK9ji6z22g@mail.gmail.com>
Message-ID: <CAL_JsqLFSMzmTSAjtWWotzFy=JLr+rjim4F_X5thWK9ji6z22g@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] arm64/sysreg: Convert SPE registers to automatic generation
To: Mark Brown <broonie@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	James Clark <james.clark@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 1:33 PM Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Jan 09, 2023 at 01:26:19PM -0600, Rob Herring wrote:
> > Convert all the SPE register defines to automatic generation. No
> > functional changes.
> >
> > New registers and fields for SPEv1.2 are added with the conversion.
> >
> > Some of the PMBSR MSS field defines are kept as the automatic generation
> > has no way to create multiple names for the same register bits. The
> > meaning of the MSS field depends on other bits.
> >
> > Tested-by: James Clark <james.clark@arm.com>
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> > v4:
> >  - Rebase on v6.2-rc1
> > v3:
> >  - Make some fields enums and add some missing fields
>
> What changed to invalidate my Reviewed-by?
>
>    https://lore.kernel.org/all/Y2kgC9QlBwvXTLe6@sirena.org.uk/

Ugg, sorry. Nothing changed, I just forgot to add it.

Rob
