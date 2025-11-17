Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F9019CD0A
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 12:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763384083; cv=none; b=cZTqCC/Q+ys2PDdLOB3/zNJWs9WBoyynPzi1YIvFWaiy71WFiTZmr0NlCLGmX/j+xNWsgHyvSepSSz/OvbG0Nlc4tzY0jrmeA7NP8y9TQa9SI1TslFyWJvvXJYAt4aos6D2n4/ZqgIgDLi5JmCRAHwXlSpJEZfc+wlLKkF4A2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763384083; c=relaxed/simple;
	bh=nl0HsCOCplgzTdFedqXiVjLN/5t+82gffsxQe1egsWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/WjvLX7gl6VBwBrGCgO6WbvqFD8eavT6UhtuQKmftUcBNiqYf6+v2pMApjmjSt9nTFE4vD99NA6VH1/cr9CxJ8I1MXqbYpg65rMRdb/NArVSF3yid+wRH8D6rkdrPSmX5pZHNFfLyHnnr5Fa5490ZyEJBBzeVi4dsBFAjUETCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzL+vXYT; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzL+vXYT"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb8d6e98aso694521cf.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 04:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763384081; x=1763988881; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j0PeYkxx4r+5jJsF9hbC2hTxYP/y6FVcRV15IQ6oSzc=;
        b=xzL+vXYTrpbK+DTW0+t/Km6sfRKC0hQnW/6eCX1IMbyfUZL7vmwBAcX8VYqG5I4Jd8
         hs/jdx+/438xn8c95qZFPZVhky++BHAcCh6ODeP6zUsg+1jioMkfxfH8Fk+kO69HX9p4
         7kj6W29mGUqksPxfhlsHtgHfVjnyNmKyV1s+6nTr8s7vyosq7vmC8OVVRCs+xWw/oX5C
         IIjNDuHU3+ZLkGTV9wA38zKuIB1LLp6JHBmLebBy5VlGSkBk3yuhbf0RLYzNUCN4Irk2
         P+lDzMzRjtRLFu4lXcOGcv6QZZpGg4qNTlFalymjm33uGEh1HM5dNZZhckxBMcK7CG92
         0nWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763384081; x=1763988881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0PeYkxx4r+5jJsF9hbC2hTxYP/y6FVcRV15IQ6oSzc=;
        b=NSKAVwqzHt25knu1MBWPdwYW48YvU/de30bLmiwB3jaOU2usRgM8gnUman7rQcDOpy
         coTE5r1Emhi8q/3sUuOARt66F2TkS5KosEMYOTm/rfyJebhSGz34S8Bv6zYA8CUkKuMz
         fA59qxC3OmTMPx7yDh8fVAFq6fV8fhE5zK86YCdiWHiCT4wHC70BmH9dLLJtFfo929rG
         WXgQJkjd2AyXm0XdrbsL+yQT58SycTMXa0RH5fovMvYqh2PuEE62+iVuLYcr88jORSs0
         CKliyFjWcN91VGF2rIGJf+02eb3pubth5qACS6acUlFIOURJCICZMmCw/KLN4pEJC8sl
         0J/A==
X-Gm-Message-State: AOJu0YxOg//utkH+ZLR7MLRXYMZ6NdAdcDARsuMbngRPMLVXltBu++X0
	p+/bjpwe/EclAyjg0S3z3tG0SCC2i5Wef/f+Z0RRod8Anvp6ZJCa19cHikB/AyAgP9oegKyXrHX
	hVLAL3SWOIveAxg1cOVSGsdqk3Ga+gdFEsg8o9v1IDq60DwQ/O6ASbznCYUs=
X-Gm-Gg: ASbGnctvP/3e7as4vOrzlqd59RncaM1iMDUFzAh2w0Vd+O2xVsJU0rVBHf+Ffst4PI0
	7yYr58ovJEVzjyw4rM0Q3nZVJAkIjOya56hRg3enUbIQGOJksysXCjsiq5eV4L2/IMBb2ROx42I
	UT4vvhUCXsOXpZXEog5ysehfY8DPKRBQbddP488Og2XV+K+TzFpGILaJ1baOsRv5zvbkjmqPGsT
	wBeMmiqABUtaKV6HPvcDntaeoOWSyFVS5pqlme89rYsuxh17DGNEZO9FTbwipC2Rsx5h7mRrwby
	vllOBA==
X-Google-Smtp-Source: AGHT+IGyUPT3wn6gNyvpaQ2io1rn1H6hCVd0hgtsdhKIadTArqZSFCNMUbFtSog8erGv//K0RpdAaxu0Wib8dQEX/+I=
X-Received: by 2002:a05:622a:1a23:b0:4e6:eaea:af3f with SMTP id
 d75a77b69052e-4ee029e00ddmr10626351cf.3.1763384080849; Mon, 17 Nov 2025
 04:54:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <CA+EHjTzudrep2hEno4RPwh8H88txiVYFoU7AyJYVWG9SFSk87Q@mail.gmail.com>
 <867bvpt25u.wl-maz@kernel.org> <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
In-Reply-To: <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 12:54:04 +0000
X-Gm-Features: AWmQ_bmjMm1Pn-peAzaMdg9UHlblAmHGoqWm7U5eN4zTrXFoNWlFVMWvJb4f2Ww
Message-ID: <CA+EHjTx=sqkOfvoXO-gtAP9oZ+HJnfqFWzeughu+sTv9uJx7zw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 10:18, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Marc,
>
> On Mon, 17 Nov 2025 at 09:54, Marc Zyngier <maz@kernel.org> wrote:
> >
> > Hi Fuad,
> >
> > On Mon, 17 Nov 2025 09:40:47 +0000,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Hi Marc,
> > >
> > > On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > > with a bunch of bug-fixes and improvements. At least one patch has
> > > > already been posted, but I thought I might repost it as part of a
> > > > series, since I accumulated more stuff:
> > >
> > > I'd like to test this series as well. Do you have it applied in one of
> > > your branches at
> > > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> > > , or which commit is it based on?
> >
> > I just pushed a new branch
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes
> >
> > that is based on -rc5, kvmarm/next, kvmarm-fixes-6.18-rc3 plus these
> > patches. Let me know how this fares for you.
>
> Great! I've applied the pKVM patches on top of it. So far so good.
> I'll test this series more thoroughly and review it as well. Stay tuned...

For this series, and the series that it sits on top of (i.e.,
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes):

Tested-by: Fuad Tabba <tabba@google.com>

On QEMU, nVHE, hVHE protected mode, and protected VMs (with the latest
Android pKVM patches applied on top).

Thanks,
/fuad

> Cheers,
> /fuad
>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
