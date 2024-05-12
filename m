Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3086B28E17
	for <kvmarm@lists.linux.dev>; Sun, 12 May 2024 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715528850; cv=none; b=B4/aPnFT2a+SemKHEt9uH30FWkfav3DMwQ9VkLNZ5x6R7cUqGqtTG4Qy9rZEGJEeWhUjNz2P1FyKn62zk50YKWx+nic4Ud4OKPw+KBL0O3Q2I1BRo64eCTma28msJbtHP8iSrsgTxp6KDATb/4Ln28VTidMOmTs1naxKHti8L94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715528850; c=relaxed/simple;
	bh=1Bj38UuMJi0RjVuLbbbblgBhH3BcEMkeipr+0q2iGg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwTVQMB2KVDZpuf6uviyTDNXEXVQutYyXxSpc44V+sif8y3E6yAYC6o1kxDiQJeNc0qdcyFZIu/zMZvD6WDCTWfl7wOMubDlYdHp0aP8B/kiOmHr/jpxbs6v4bVv5RnPm5fqZsti/20PtlLBm7qOBfVMaAUVcezXnaEgfvuz3Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVNUIkjX; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVNUIkjX"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-47eff9b3c23so1028231137.0
        for <kvmarm@lists.linux.dev>; Sun, 12 May 2024 08:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715528848; x=1716133648; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Bj38UuMJi0RjVuLbbbblgBhH3BcEMkeipr+0q2iGg4=;
        b=EVNUIkjXkEpoe+8ERoYzI/gTKGMKcsD7r2FvsZ2WMGUWcwU0X1A8Iy58dikIseQMcK
         c9AA4GflzLO4olxka8C7hEG7bjFvVKHDKUNk7DIEsrvT1Z91JAbCow89IXfnEFuETBIm
         kBnjJkjMOThsXLSEGwXTwd5lhDeIc+wSfx9GK9CJjI7NEJjS3Wu5BwEAkRPHkijNmkZx
         bJe8VPvM9KTkgnu4uuVzJ6sqjfMBFJUYofwBw2uzz/UKbdmqbe2vlkF2OYgge5WcnQY9
         ByV/oURaeIcwhg9B6UZRukSpXTqTJ2njvQb3EGEAdgqnk7RucfDGaN8ui8PlIRfe4CJP
         78CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715528848; x=1716133648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Bj38UuMJi0RjVuLbbbblgBhH3BcEMkeipr+0q2iGg4=;
        b=spSdOUTz1SLCFG9lNu2U+FgOfQ7BBp2plebHnGp5iaJHvrs4nYechK156A0z6dNz9f
         ybLPzC7Wx0bvBdA0q+aR8pidWlKcRnln5lAo7s7WLq68uFyUxfPl8ilsuz58jvSMcym9
         f/4bcLPz1twY8t0tsw/2OyutOJzczhtzEmH9jPTqa0CdZ0JvpiNnEXNpxVnI3BD6VkpA
         kAcozuYcieCr5GiFYW/d6Rz09uW/cWvWz1ccLHyOj/8TE02wTUUQLh7nbW2s/CJztyPS
         oyNh0jlbqKQI4PcowDs3KFky8AXERGMnuiDB/hsoDdMa86Mn95/+ymXbeWTWlbI0tVnD
         +ubw==
X-Forwarded-Encrypted: i=1; AJvYcCWAbbWGVHKb0W28M8VsRpzLYBB/j7B8Gb4WQ+Riy5Penw0L8d/njRAES2agu9iPOYSuaVS3AVjVuNDwbVVdzpO3OJe1Fi9w
X-Gm-Message-State: AOJu0YwVKDsq4Oo7crfIcSv6PSgGuA+Mb3Ak071wKaGYHwJYoxfywol1
	7tiDvWnjQaVtIv9wl+jv561Owt+1dkLSpBzF+bDFOleO84/o9Bbg94hkJHZwnEv02r50tmJjfjK
	IydWV+/CCnp4iDy3Vr6am3Rq7F1rusHsH+wW3
X-Google-Smtp-Source: AGHT+IF5YVQ8bTbMFv2SsIuJDpWG69UyzHxh2J1FtFO/Oa0nCEIkVGVyhlnW21OLh0OeUYr7rPbvAgWjSyHKVPZv0E8=
X-Received: by 2002:a05:6102:cd3:b0:47e:edef:b986 with SMTP id
 ada2fe7eead31-48077eaf260mr7392009137.33.1715528848056; Sun, 12 May 2024
 08:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com> <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
 <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com> <CA+EHjTzoD4wXhiG-uQ2xzrZkw5fLqjdOsiE87EdY5Z1qfvF7_g@mail.gmail.com>
 <86ttj6p062.wl-maz@kernel.org> <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
 <Zj-10O_rbwnNadpZ@linux.dev>
In-Reply-To: <Zj-10O_rbwnNadpZ@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 12 May 2024 16:46:51 +0100
Message-ID: <CA+EHjTw9sBodDrVyJk7SmJLO29N_oYK611=uOHRO7Z9+0bVOEA@mail.gmail.com>
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, 
	broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, 
	smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver

On Sat, May 11, 2024 at 7:15=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, May 10, 2024 at 09:00:54AM +0100, Fuad Tabba wrote:
>
> [...]
>
> > > > For protected VMs, we don't want to lazily save/restore the host's
> > > > fpsimd state, because that could leak information to the host that =
the
> > > > protected guest is using fpsimd. Therefore, for protected VMs, the
> > > > host fpsimd state is maintained (saved/restored) in hyp (at EL2),
> > > > without the host needing to know or do anything about it.
>
> I'm a bit confused by this statement. Isn't pKVM downstream lazily
> managing fpsimd state on behalf of the host for protected guests? IOW,
> don't we return to the host with traps enabled at EL2 and load state
> after the trap?

Sorry, I got my wires crossed between fpsimd and sve. It's the sve
state that is restored eagerly, rather than rely on the
TIF_FOREIGN_FPSTATE as in other KVM modes.

> > > But I think that's a regression from the current status. It looks lik=
e
> > > now that the state is really private to EL2, nothing will restore the
> > > FP context on exit, while this was the case before we reworked this.
> > >
> > > It'd be good to plug this in 6.10, as this is a regression.
> >
> > You're right. I'll send a patch to fix this.
>
> I'd be fine with a hack that *eagerly* saves/restores the fpsimd state
> on every exit in protected mode for the time being. Not great, but
> obviously correct and its not like protected mode is very useful
> upstream to begin with.

I think I have a solution that would maintain the existing behavior
for non-protected VMs in protected mode, i.e., lazy handling. I just
want to tidy up the code a bit more, run it through a few more fpsimd
and sve stress tests, and send the patches.

Thanks,
/fuad

> --
> Thanks,
> Oliver
