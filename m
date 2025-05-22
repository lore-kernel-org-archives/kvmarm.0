Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4910417A2F3
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747934448; cv=none; b=AreDKDJJqbv0y/XX40w7R1XK02GCEu4/HszTRf+j9Yf7hN0dr1LNiAOc38ekv6Rt0Q5BIT6RsMNOI/sBzBtdaPXLJxjrzbUBWK7yEiocrJ9CZx3VbyykXw1ti7w2qELHQBu4M598nC2JFsAaFhzrPAm47vAe0M/FcO/FVm2UxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747934448; c=relaxed/simple;
	bh=f0XMvMxyxmQO+2lM8j8iwFTLKsVl26kGRvuGKeTW2FI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gyHmQX0vd0PIGZgmFP39WP/rP9xk9LaF6ieCw8TDDZ6yb21osWHHURjkmjbyXoOLOJ3p9Vs8Axd5+eJL1rxRpPvDJCRboz24hibjljLIuNSm9avBk7o4xikaILaVpKeDi/h3i9cX/j1TQyT/UEQltPIYd7LBJ18Yi4cFqCSeTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dImguw1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dImguw1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC39C4CEF1
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747934447;
	bh=f0XMvMxyxmQO+2lM8j8iwFTLKsVl26kGRvuGKeTW2FI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dImguw1T60mad+h3HSsvAIAGBZoPyTPvysg0PLKfbw7ZusucDBwWkXb/t8dv8WMOU
	 ZZ6aAsxZ3NJaHzMeK/jILjLP3f8g/G5mfEWuPVyaHDO7YU2O0/3emWRgm3pOcU/MoM
	 JmlGrDbi1bgSs7VKOTVEUhua/5BFdd5TCnrm1JsexjraKyYjwoxxR/waR0FmqALK7U
	 xbqfkbyRGTquiPEsVtBNQYh/T7x6txLXkXBg1QEvdEh+0GNyr9mlk8LW4muXOp/J3t
	 wYvzYg2cpvpsRfSGiwFDKDnCHx7VRengnDHNYN1c1iRuk7Zj09NcuXByPiXItZX38l
	 KVc5EXz0yFjaw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad51ef2424bso1326223066b.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 10:20:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUaCYPnRTAdQSMD3pv72Izx5Fvu4MEbUGcp1rKPLJU1bccvTk/xhWKCf+7RAXTQtJMVyaSwWs4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl8g8+eDigW7arI66j4qsmdVjZLyy3MuvLGFCJQWfhrUi1l3cN
	Bg+5l8fOCPpaVCAZaEOdSOhphOlvmIp5+Ie+rvmhRGRNk4qzY8PNB8N2NHx1P5oBWkuasA1PHSO
	jDoUL9Pi6Ool8wt/+o0ZdW8kJtzhLYQ==
X-Google-Smtp-Source: AGHT+IGAYYG+vIgGuI/ayC2uGqWgyniPCcMHhUSyeQcygsPjUjSYmhf9rYJn77siFd52fYZ5ibkezDZJq/F4ygapM/I=
X-Received: by 2002:a17:907:3f08:b0:ad5:6939:8333 with SMTP id
 a640c23a62f3a-ad569398704mr1462923066b.37.1747934446333; Thu, 22 May 2025
 10:20:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org> <aC9NhvYzajduVm7y@e133380.arm.com>
In-Reply-To: <aC9NhvYzajduVm7y@e133380.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 22 May 2025 12:20:35 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKWY7rRGTbHXTmm4RC9F8fqrs133=75XFkVdm91bLHfaw@mail.gmail.com>
X-Gm-Features: AX0GCFvVXljRLS6CQowdkTNTXjrD3dK31miPdgViETu3tYaW68KPRqx4Jf1fUa0
Message-ID: <CAL_JsqKWY7rRGTbHXTmm4RC9F8fqrs133=75XFkVdm91bLHfaw@mail.gmail.com>
Subject: Re: [PATCH v22 2/5] arm64: el2_setup.h: Make __init_el2_fgt labels
 consistent, again
To: Dave Martin <Dave.Martin@arm.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 11:15=E2=80=AFAM Dave Martin <Dave.Martin@arm.com> =
wrote:
>
> On Tue, May 20, 2025 at 05:27:37PM -0500, Rob Herring (Arm) wrote:
> > From: Anshuman Khandual <anshuman.khandual@arm.com>
> >
> > Commit 5b39db6037e7 ("arm64: el2_setup.h: Rename some labels to be more
> > diff-friendly") reworked the labels in __init_el2_fgt to say what's
> > skipped rather than what the target location is. The exception was
> > "set_fgt_" which is where registers are written. In reviewing the BRBE
> > additions, Will suggested "set_debug_fgt_" where HDFGxTR_EL2 are
> > written. Doing that would partially revert commit 5b39db6037e7 undoing
> > the goal of minimizing additions here, but it would follow the
> > convention for labels where registers are written.
> >
> > So let's do both. Branches that skip something go to a "skip" label and
> > places that set registers have a "set" label. This results in some
> > double labels, but it makes things entirely consistent.
> >
> > While we're here, the SME skip label was incorrectly named, so fix it.
> >
> > Reported-by: Will Deacon <will@kernel.org>
> > Cc: Dave Martin <Dave.Martin@arm.com>
> > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > ---
> > This one can be applied even if the rest of the series is not.
> >
> > v22:
> >  - New patch
> > ---
> >  arch/arm64/include/asm/el2_setup.h | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/as=
m/el2_setup.h
> > index ebceaae3c749..30f57b0334a3 100644
> > --- a/arch/arm64/include/asm/el2_setup.h
> > +++ b/arch/arm64/include/asm/el2_setup.h
> > @@ -204,19 +204,21 @@
> >       orr     x0, x0, #(1 << 62)
> >
> >  .Lskip_spe_fgt_\@:
> > +
> > +.Lset_debug_fgt_\@:
>
> Dangling label?  There doesn't seem to be any branch to it in this
> series, unless I've missed something.

I tried to explain that in the commit message. To have both what you
wanted and what Will suggested, you end up with 2 labels in between
the last skip and setting registers.

Rob
