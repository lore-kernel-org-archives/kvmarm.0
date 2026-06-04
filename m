Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCEF2D1911
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584473; cv=pass; b=mzTLQ1G1pMGD631WmKdzPoqfFbnCMCSBq2UUxSadJ6jxYYANPdOx7FlpeEv4HMCaxHEsJU8g8hyohalABRKQtE/SdeSUQn4cisH4JAorJbSIaTSGC1ikvcgPdxmY0JF3G2fCrXKO9p7A4a75EYW1VnYS3h/y29YgPTsmMfr5yhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584473; c=relaxed/simple;
	bh=cS36YC7Wu3PtL9qTsgYUx0lM3dO2E4U9fKR5NR4EZG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cv5zM9n2ej1147tPoai7ebowZ9n9xxm38QAE6urCK6nKObzDO57jvHEvt9NELpqAFWihsfkWWJTyscVoWO+WzTGgcrI+d/YDGNjOj60pCDjpieWrbScTzumTUZTjOehIVedWnv6qdnUqAC0PD2ohCe1B9pY+g5TVzt+Z2Wm2VwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgHj1c12; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgHj1c12"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec3f69d343so127049166b.0
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 07:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780584469; cv=none;
        d=google.com; s=arc-20240605;
        b=ifnQFmxb4jmqWza+BoEN5IekIeApZxLwnamFY90zwLBl3ydT7LkG1BAgwp1wQNhJAw
         JELel2T+zxUiKONSdp+cxlFXEdRRrbSRLe/czeYKntIwQKn8dPVu71UDWW9VrwP73ahn
         SDke9l2s4OEgvJa+w/BnwOsd/Ng6xaj1/QuLyKwPkJ5SmcOJdwHZxmqPV568s1Ca78Hb
         sy1/z3aKv8yKxtXohSE1SdMwkH5Ika9rhT2eZ7K4tdGHX1ET0f1w7J0Nxfo8V0sWD80T
         3ulGlgqvy9Ev8XC4ma8ZrsOuJAPxiz4RNOjnbARdpL43G4UbTpZazNpnPAj6ne30Oyl+
         oeqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QSjd1U/70yhpLCdfTmik43TR68lZDDCtC2Km+f9O/NM=;
        fh=+eq9y8RvMq9Jpf3NJI7UZ2a/PsgNeDA/ABIvIZVtxjQ=;
        b=bwe19fLFxESXmqd6U/AkEq7Pbh0K6yHjxxuwbdS7RhYhw8lnbxkS16FUt1F7/aV5My
         xVIK/QoSxBAQz1Zu1WDiCTjVCvk1u0jlQ9fvDKTb9IP+ba+XlM5+fiFLp86zw2EGMTmH
         5VBZvcBYyDm1Vo6LyilRoIvIaOrOkliG2vdOsLTjY884hzmNhZsDoXMaN4sv3Yi3nqoI
         ekxxPknv0lwd49eUeCgXwKhXGOkKXG6yZZH2tu/cTj+008dq3WFIpLDvQAnUDDMqP7Ob
         f06UME02SxkCs9dw9VQ2Jd1LpUoJWppKQx8DtnC4Wc4av/JcBNiBSoJ8QqXt0BJlZg4h
         fTMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780584469; x=1781189269; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QSjd1U/70yhpLCdfTmik43TR68lZDDCtC2Km+f9O/NM=;
        b=UgHj1c127n4YipjmGQ/C8zzuVr6BIGB7HBEUoM3AFb16Otx6DBwhaCQz/NgYsNYLGZ
         IiMCgf6eODoLPsjjkmFXIrAI4ieZsmzaJmcvkwfaENlR6TT0iR18ZbvVl1sDzV0AWCTA
         ZPEEmSobizqdzuAj7U72yD0fjkMQFqEPhz4YgZJrnGtAdRb8zWa96+o5wzjQdrkHqYJa
         bj+5sDw4Vc4jZ4Tq2vWHBHyhGQwCBpNHOqv/atPGAHiUpVh2m2tjrd+3HSr0byrr7X6v
         Xj+YZGbF9/inE0ElBJBZw74hnRfMK3vkEAmKkCuoL3BNe/c7PezUe1bx8hWZs8qgIwRo
         vykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780584469; x=1781189269;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSjd1U/70yhpLCdfTmik43TR68lZDDCtC2Km+f9O/NM=;
        b=Jbkb5echhBbVWcVDB8ZmuYZtrLnt8i8vYAwYIoFq9AwQ1KpzWLhn6cV4f8R1o4RJNv
         KyHukyf203UX25tooZuUticO8lQduvLCZvAKRwG2T0ks6psZfoxlxSlhzd7NyHj0TWNY
         nfHDBYWqpojAbrq/mwgXjtrzFLhKiqp1bSj/BaEBLBuCcK6LV8kokLyyEVRwLyeVBDQU
         lx3Ib00+7r76EGSHR1imrjs2x8cGxu22mqKVYV2NuoDl6VcQ4c2XDXJUTtPj64pAxZJv
         R1RkFd0N5zYDmkKnpUlai1kTCpX+woTduSOZs6KkpbFVI2CLW5r1Fk65iBTaw89FSAiO
         5D4g==
X-Forwarded-Encrypted: i=1; AFNElJ8BB6ArOEVnU0wqw7pu/wEddtowiAbKNtQirXXzRQlV6BtW4cDyQorlAXbnWjSwEdiYIUscVWA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7Tn03mowNVBtYl1lrLdqpXs1hoMBhW25+E3/tYYEMBAH6Y2iS
	L9V7G7MMvuOjrFK9pQZGrr3G3APEfj/r5sz6TrenZBRRc0Cp8rZtyZ7kxfzLKHM7u6GPZUGaBfx
	OI6vL4wY8FweA2OnbFEG1l8FqFuQgIOWHi2zPdagg
X-Gm-Gg: Acq92OGkqZ31QqRLLaukhoJeuBQWM5OFY3wgrmPJLLkTEmctNjsmI01TgNsiz/3Lrbv
	RY1YzjeC9W2C9WeZAywCsLvXZ0grKvv3NPnAKlgxYp+5jAKwtkWcu/QJwbaEzq/4nA/FagmhQd7
	X8wiIcDeEnPPsQx7lWnuWwJb7N7IDz4A7KBbjIlyxqRiVQOAZ+BLA8lIjLkJjVoyUl7MNoWnQxe
	BSc4or5c37fkhsipR6EAhIHIYkXYuEbPA7G36wR6Iw3Zh00RoEMFZIKaJ2DPg60+H/lRaj9FiR8
	w8lVyGikSZWu6ajNs+H8pMNR/N9SneyCLZ+m4BgA0ExpRE8oRlj9uZzHWFhqdAtSU1O1eg2v4WR
	haLxVxhg=
X-Received: by 2002:a17:907:6d26:b0:bb7:eb68:514e with SMTP id
 a640c23a62f3a-bf0aed0cafemr433224366b.36.1780584468249; Thu, 04 Jun 2026
 07:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a2d58c.050a0220.3a55be.003b.GAE@google.com> <874in0ex49.wl-maz@kernel.org>
 <CACT4Y+bbQ3qfoy0kuXgTk5H2k=Wrg2t0Ghhc6U6fT-28ter7iA@mail.gmail.com> <86wlzu8ird.wl-maz@kernel.org>
In-Reply-To: <86wlzu8ird.wl-maz@kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 4 Jun 2026 16:47:36 +0200
X-Gm-Features: AVHnY4ICfNLxavuIrQN2iJIGM7Z0iBfnUYdb7BfndwNYy6T9AkyY1h7EA6y1Ohw
Message-ID: <CACT4Y+ZKV6Lq0uBv7ob1cKnVcD7XUvV2srUMDR5R9gxAE_Yxww@mail.gmail.com>
Subject: Re: [syzbot] [kvmarm?] [kvm?] BUG: unable to handle kernel paging
 request in kvm_vgic_destroy
To: Marc Zyngier <maz@kernel.org>
Cc: syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com>, 
	syzkaller@googlegroups.com, catalin.marinas@arm.com, joey.gouly@arm.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	oupton@kernel.org, suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Mar 2026 at 14:26, 'Marc Zyngier' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> Hi Dmitry,
>
> On Mon, 02 Mar 2026 12:59:41 +0000,
> Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > Hi Marc,
> >
> > The reproducer should print at the start specifically to address this concern:
> >
> > the reproducer may not work as expected: fault injection setup failed:
> > failed to write fault injection file
> >
> > Isn't it enough?
>
> Ah, I totally missed that, because things scroll really
> quickly... Apologies.
>
> I think it'd be a bit better to just stop the test if the
> preconditions are not met, as nothing useful will happen.

FTR filed https://github.com/google/syzkaller/issues/7450 for this.

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller/86wlzu8ird.wl-maz%40kernel.org.
