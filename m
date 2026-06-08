Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B02DF6F6
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 13:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780924624; cv=pass; b=RRCqWEF4Nku0I5MR1MjorpPcY5jNwUQc4bO9H/rvSZl/0UCKD2g+IUeSNS7fIv/ZHJUelAFJfCCUi1zcbIgwTcnwXHdfhs2EhnmlwgqRww52CPX0a4ap22B/IaY2NoJ9SGnw4MndkUGjnKLN63L3NYVxt+foIWaxWWSPH7YCjOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780924624; c=relaxed/simple;
	bh=jpwc82heUpqMLlZQLmJN6guRG5C4um2+SNRKRsuOVas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O5qet9EPxsphT13UUl4rODnwvJL7Ub4njWXv5T3mSytAgYb+toAGYfMJSgqwM4eWo2WlW8n/tP1rXQ8FpeB9zfi1+RhvOphUc82NWDrS06G/mRafepgRrgKpxmyJwYXpXISRSKKApaf+UrgmwFUbfx2ojGHYrsOBBSCM49e2m/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RV1NFesR; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RV1NFesR"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-43d133d9a28so1560988fac.2
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 06:17:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780924621; cv=none;
        d=google.com; s=arc-20240605;
        b=lLDJr0o2dkbRIhZOv4BB0geb81R+K3TA2/anj6aXnfxEfVcOcxhjYpcCrgMFya5ZZ+
         nQ70dFT2+xQi2ShMPnRD2eTMmYhXyxjET1VNPfvVoZhFyqlLPcSYGXwBSZHQOmMclxCJ
         ZAxU1Ibf0mwg4j5Gtx5Ey9tLpLZJTUM7aSJST/v4pZb3QXAr7b0ZhvbzQzHJ1rkVfjX2
         huXwSshERSmKlSKrBbiuMgy3M5/G42pTHZ4abu3cF1VgtPNd4QpI82iO7x1LkTRC5bdr
         kZ93dT255w9KxN+I4M3syUHDo9lFGo+8yG/dij1EyLnpBHyqMIaqZ7Zvr3OpvWSLl3Kz
         DWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AfDmQD3XkqnhyOK6L1IuRTH5e227SPMKiBMcBej6ec8=;
        fh=5bqSHc//dKcxsdaSG21SJ0HLJRS4atoQaQX+Gx3/2ZY=;
        b=dccuCrm3UtFIShAv0GwfGfLacPDlmRFs1PNK4RPKqYUQiWC+BsgOeDFdXgY2/XglTJ
         FindbErLF+1A0Byf7SbKbajS3EIsJSlk4pkEB5WwukGW/CdohbkQ80Bc5Ro53NkEYH+b
         VtJvZYpsNtD5g4fm3FHfheLPrQTxqAcxs6eBJ5btxNYtUq4JpzpVKddh26axBzmPzkWM
         fFyfcDC4R3EYXXZjZMMSJinppGEW0NEbGlcyfH0xhAUE9nN1tEPi6+I83budOXTdEbHn
         ETLL5iSx4dRVRwSIcTQHsZyjljVh95kqcX7e8xwzYNjiyqAz9wTIdk/V0Q7X2R3k8iYP
         PvmQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1780924621; x=1781529421; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfDmQD3XkqnhyOK6L1IuRTH5e227SPMKiBMcBej6ec8=;
        b=RV1NFesR/dg9WRSHTV5OKMgy5a8h1ylZ5/ZZv/Vpp04ucFZY5hoIvOoRIvjwp3wtMm
         8pabswnLZOiL82Tl2pep+JwvotI8ffuVccMl1jVkjl882RJl+Kop4i9+UJ5OH7QnjupW
         /ubAt7VjDFC6YYVTCd0mqlWDTgKCDHE9aIvGjhFhwL+wMlNfPv+Oz1rXG/R84V/mKhwp
         /gAiahcBC8zlvZ9Jgo5/H8juW/HmnecfrSRNJ47JXQl4ifwecrKOz7/63cpGz+IJf3/x
         0YkSxONkL/8qQ6inPRAX8ppqRmKRx0F3S6muokca/LFb66Gwtlti+xGWlDvRBHqSUJuv
         +wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780924621; x=1781529421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AfDmQD3XkqnhyOK6L1IuRTH5e227SPMKiBMcBej6ec8=;
        b=fWwAFerE57n44miWOb5QMiUULgOUn0+bHTwRZYzdS7JEp/ijfvUf/wHAzAMKT+pL3b
         yzdIcbYTreR8YxM2ifW/bXQDv35pdHXApL4DNgozvngCMDA/ZxyEJo1JYqyB8UKkUMR6
         zeeLCiLTrQMSJ+t7gk9Riw2mwiTb6jDh5qoSFaMW+RhsGHWldBlvQc+L3/YGwuptlHAd
         fP+XyK5+mNDdCH1YcGUa2ImlSEECrlB0yK8OPKy3Z5vf6AgZsVFYpKIE0WYaO4hFgbqH
         Kiw5ZiXqz4ISW1ZDbXY/46XX80avHZKH97WD5UzgPNemc10hmLYmFA8UUmB9LRRnITmp
         TRNA==
X-Forwarded-Encrypted: i=1; AFNElJ+YL+v7aO/TzCTWouvrkjw89r3vni1cnmAClZ7f44WT3CyMzBYMcNQBHpg8blR2dAT8l6UItSw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEjd5mLQZZ39dcmSu6r0Sc4Kfpo1/VazeO8hr3zq/FVKsU3YHC
	HBbyppIfNVqEBilT2m5W8NEyNSDtXhUBxb/elC7e5NYeoyWl1oE8/lPS0N0bVYt4y6ZFYSPU0vr
	P9J4HsbtNi5pi6ytDxXuSefAiuS67f4IkKAYuONeEpg==
X-Gm-Gg: Acq92OG7ilkwUmDWL0dGD4EGIWapclo80ZrCyA8TtJJkZ9BsmiO6n/RINjyuGvuqoRQ
	Wt2CRNBDIQVfYEo97GssPcg/dcmASNFl8cjwjHP8oz2ARu+RWTl5PQ0UHRPPTJ/XJ71+XxGIw7v
	/lDRY++GAkOsvxAd1tCmRwjFcC0jNvvcH1ORU7EGA2svFoETyRQf6UlRjLM4edNFjBva5pZCCD+
	XdDpPQ9uj8F7k4BOTMwI+R6cOfhUoZc3mp9+TL5+26FG4sHtDpmw9I8CD+DGNQ1HJXTaPw9Iwhp
	8DwaijhXcwwRA1+EPLYZnM3BFbxYuOyDxU9bstXhQGI8Heey
X-Received: by 2002:a05:687c:2346:20b0:441:b0ff:132a with SMTP id
 586e51a60fabf-441b0ff148fmr1273772fac.18.1780924620975; Mon, 08 Jun 2026
 06:17:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com> <20260526151934.3783707-2-smostafa@google.com>
 <aiK6lgW5YFWSMTxf@google.com>
In-Reply-To: <aiK6lgW5YFWSMTxf@google.com>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 8 Jun 2026 15:16:49 +0200
X-Gm-Features: AVVi8CfBberieRGRzkn_uKkTDDGnJq3OimnjM0eDLOzbP178qkP9W2-4m7NvonA
Message-ID: <CAHUa44FO02DKqqNeFuRfx8bQjwcNRfPMF2=8MdjMUFp6vYUpNw@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] optee: ffa: Add NULL check in optee_ffa_lend_protmem
To: Sebastian Ene <sebastianene@google.com>
Cc: Mostafa Saleh <smostafa@google.com>, op-tee@lists.trustedfirmware.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, 
	sumit.garg@kernel.org, vdonnefort@google.com, sudeep.holla@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 2:01=E2=80=AFPM Sebastian Ene <sebastianene@google.c=
om> wrote:
>
> On Tue, May 26, 2026 at 03:19:29PM +0000, Mostafa Saleh wrote:
> > Sashiko (locally) reports a possible null dereference under memory
> > pressure due to the lack of validation of the allocated pointer.
> >
> > Fix that by adding the missing check.
> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/tee/optee/ffa_abi.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> > index b4372fa268d0..633715b98625 100644
> > --- a/drivers/tee/optee/ffa_abi.c
> > +++ b/drivers/tee/optee/ffa_abi.c
> > @@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *opt=
ee, struct tee_shm *protmem,
> >       int rc;
> >
> >       mem_attr =3D kzalloc_objs(*mem_attr, ma_count);
> > +     if (!mem_attr)
> > +             return -ENOMEM;
> > +
> >       for (n =3D 0; n < ma_count; n++) {
> >               mem_attr[n].receiver =3D mem_attrs[n] & U16_MAX;
> >               mem_attr[n].attrs =3D mem_attrs[n] >> 16;
> > --
> > 2.54.0.746.g67dd491aae-goog
> >
>
> Thanks for fixing this and for including my other patches in the series
> Reviewed-by: Sebastian Ene <sebastianene@google.com>

Please add a Fixes: tag. This patch is independent of the others in
the patch set, so if you send it alone with the Fixes: tag I'll pick
it up.

Cheers,
Jens
