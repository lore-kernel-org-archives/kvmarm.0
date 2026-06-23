Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7913D3D6CD6
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227059; cv=none; b=RPDEX8ABFliPFTR3//sI0d/akJan9ZMNaY+biS2opf+JhX8WMHAcHUY56s86oUpxjMu2HBRpT6va0RUwte65pfnlFxi5RZAnGrM3LlCA4um+/Flw3Nkx28uQGERGs8HUMCG+gGgXsc0YFyTzqr5YSOxSd5ysy4x9Ww4yQMZIDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227059; c=relaxed/simple;
	bh=xn+1qusiaej+g+1BhTrpeBRbpOlc9scvk1tLtcxW+ps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mmZLwYKfP4N/bIX+A/q8uMS9R7VHLRyn1ZbGYYsJf1upmRrixFnwwse55/CtgziebuX1EIAwrxpo5pBNs1ClcQ/oNiSxVYv2ySAyG9FNE02bq62soRjIHrHCiLbnBitPWioVVzPcR/Jxg255JEruyJdFrwACRm5fdbaD9SLZIbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VUAmhy1t; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VUAmhy1t"
X-Forwarded-Encrypted: i=1; AFNElJ8dpJT32ipZAMAgRlsQIFafrbA3pFoyWbIb6UIHG7G5CTrbaf1xcgyRODnYUCHzETCyA7jdxTo=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782227053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bLiOvdfBu1LQGrT07aeKL9SEbEIREO7O5xToFkLfyUE=;
	b=VUAmhy1tJ5Sg0W1i/+ktUzM1Vg5brtCCnu5kq87k209Ri2bKFklJHC6vZvJI65EYlHTOaU
	8InKpymcR61Y+601rjnLTQKVBvVpzR6rDIALYMxjOaYfojmLNK8E7/FUczSj4WJJ2VML6d
	A3w9X5dUVLnOsopaxeKepyl6zKpWvds=
X-Gm-Message-State: AOJu0YyrDdeybTQ+eL5x99ACt/n5qSrqMobN4hsWcjo33fRlKtQLXFB9
	DjaH/+/8KfMPN3iKzyTSsNMtiN84DeAi5VFS9cmYRkfzFpRB8Vob5JBKO2ZriL6NfcYB02/9DjM
	uNMkX3S9h/BfMMrIHqj1EyjDIWAgXftV7nvFPOEOw
X-Received: by 2002:ac8:5c8f:0:b0:516:4f62:85e6 with SMTP id
 d75a77b69052e-51a53db1948mr9720661cf.17.1782227047172; Tue, 23 Jun 2026
 08:04:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621213155.6019-1-include@grrlz.net> <178222278590.523236.18181071715501850418.b4-ty@kernel.org>
 <CE64C9AC-32D5-495E-B713-552921468FB9@grrlz.net>
In-Reply-To: <CE64C9AC-32D5-495E-B713-552921468FB9@grrlz.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 23 Jun 2026 16:03:30 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz+oNerTD3Ygj3EzOA4zm4BKfQYM45ydwVO=2amErkBAQ@mail.gmail.com>
X-Gm-Features: AVVi8CdKu39AfvQ4xyTggnIFcw_6d9wFkc4c5a-xa35cOd03y-_YXnLsNNh7uWk
Message-ID: <CA+EHjTz+oNerTD3Ygj3EzOA4zm4BKfQYM45ydwVO=2amErkBAQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
To: Bradley Morgan <include@grrlz.net>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jun 2026 at 16:01, Bradley Morgan <include@grrlz.net> wrote:
>
> On June 23, 2026 2:53:11 PM GMT+01:00, Marc Zyngier <maz@kernel.org> wrote:
> >On Sun, 21 Jun 2026 21:31:55 +0000, Bradley Morgan wrote:
> >> Protected guest faults charge long term pins to the VM's mm. Teardown
> >> can run later from file release, where current->mm may be unrelated.
> >>
> >> Drop the charge from kvm->mm instead.
> >>
> >>
> >
> >Applied to fixes, thanks!
> >
> >[1/1] KVM: arm64: account pKVM reclaim against the VM mm
> >      commit: d098bb75d14fde2f12155f1a95ec0168160867ce
> >
> >Cheers,
> >
> >       M.
> >
>
>
> Hey, which tree did you apply it to?

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=fixes

/fuad

>
>
> Thanks!
