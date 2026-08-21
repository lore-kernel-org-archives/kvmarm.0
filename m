Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5688039890A
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787302566; cv=none; b=g/Vk8iRGARdM6LU3d4/aX+RgMDoLUy69ZX/AbLtPtwgvFFLNQorWUaqbufKJi2PHp9m3RCfEPe4PGyiZblYy2FwaFyC2TdTeHEwZp411eG7X/Yc9oPNaG4NTP1Pz5MMqIZA0+TvzQSq/ygrfh7DK8MZRIojdlkevfoaeW/B5Sn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787302566; c=relaxed/simple;
	bh=8111Qd+mRYZcNLNqgu3KSlEknrL1BX/iBccbqkA4J+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MWTPcqKoKAzamb5Tl+KmxjJETmzpXXryvpgAFXPEYGapJ2dMeStwP7SB4LeZNm/dcHffH7jIHSKk4YPIEaaDKWCPK6duKIEfM2IgKsg75M1Xmg1+jXeX+oX8yv8ZpWGq0DgkjKA9J3dfY39pkIAIPWPPPajGh2p9Zig2tApTcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PSOEo6WA; arc=none smtp.client-ip=95.215.58.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PSOEo6WA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8111Qd+mRYZcNLNqgu3KSlEknrL1BX/iBccbqkA4J+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787302562; v=1; x=1787907362;
 b=PSOEo6WAd+Do0J59glLh6O8TArIZlyBROQew/8yJR/fQ3CZyxnf2gPPYIeDxrvuUZ4lzZfF1
 JlHKTYQ8Lvmc9a0Npon+kcT7wYlctSaI68icy0mZCIIHUtEycgsUfUVAK3cIOfvOaYFlviyCcy5
 3+LgZgVhhR9VtLpyK7XbRLdw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f51.google.com (209.85.167.51)
	by smtp.migadu.com with ESMTPS id 67ec3190e052428d;
	Fri, 21 Aug 2026 08:56:01 +0000
X-Mizu-Trace-ID: 67ec3190e052428d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so4357e87.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 01:55:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqBIMCijIpTQbxA7zyw+HT34CRvg/n5Iy9wlFEjBUxhGsa3Fj4NdMFAp00YL10KUXXFuiw8Wek=@lists.linux.dev
X-Gm-Message-State: AFuF++mV91lfN6ANOQ+I3LnrgJ27M7BWz8P0g4tTsEeRtZGBs/WAvrCM
	YZEa+l78vjELvax6DZjsKkC2swkGA/4HnKXuifp+oq3JX6uhe39hbdRjRiZOyNtI212FXzBdFHe
	2e9Za+oDIbrcCVOU79SxQzVEHCoYvR/DkpTzBfmKY
X-Received: by 2002:a05:6512:2508:b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b484aa7312mr125597e87.3.1787302556573; Fri, 21 Aug 2026
 01:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260821064445.615838-1-fuad.tabba@linux.dev> <20260821064445.615838-2-fuad.tabba@linux.dev>
 <20260821065743.3563C1F000E9@smtp.kernel.org> <CA+EHjTy6Qb8dv_apBg4RVU+V-LsP1Z+BkDYfRKLX0f6PnbKpeg@mail.gmail.com>
 <861pbr6emw.wl-maz@kernel.org>
In-Reply-To: <861pbr6emw.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 21 Aug 2026 09:55:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw+DGr5ZNMwqdSWEejDz-i48uh9uAjNghrYCXPRQBF3WA@mail.gmail.com>
X-Gm-Features: AcwNN1X3BW8PtRz67w1ebl42ONYlm7lvJCB4ekAzg0lCm2zJbuW6phvOHdrqeos
Message-ID: <CA+EHjTw+DGr5ZNMwqdSWEejDz-i48uh9uAjNghrYCXPRQBF3WA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when
 GITS_BASER changes
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Aug 2026 at 09:50, Marc Zyngier <maz@kernel.org> wrote:
...
> > Yes, and it violates the spec: with GITS_CTLR.Enabled == 0 writes to
> > GITS_TRANSLATER are ignored, so nothing should be injected.
> >
> > It was reported in June [1] and is being worked on.
>
> Is it? I'm worried this has stalled. I'll have a look...

I actually noticed it the other day and way planning on picking it up
later, since it has stalled, as you said. Trying to keep the fixes by
theme...

/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
