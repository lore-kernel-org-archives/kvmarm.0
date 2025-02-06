Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689751F4162
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857047; cv=none; b=k2uZBWW0aQSdu1hW+aiR0/npmZj70VyMv+vV8pjV+CGoHOtAYwPa7NU1wKHUVNHwPgXMnor3lJeAhpMOQLDgV/Cel9aA2XT/rfZwmuqdCFrjqrfz56BvBWHACdKsTt3FHOwQkbGFuKuR93QptqxAFw3uuFZszwsmFOpbK7hMdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857047; c=relaxed/simple;
	bh=zVYEH9u7BZqBR99JO0eGFShudYpqrhSzoFDK0x9XVJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ghhmu8KabyFLjDXonyPKGbtwqrQHRwNCGZUryIYgqqvOJ7ZxHP3tlpi9HZe95mjUJvltkTx/nm1+pOQb6O0Oc5fohQpc6onjW2+bbVbrQTSwdz06gv1wOXHxQdzG+LUDZfoaRtHdZhBIgNAvpVliPgywoeBvcFXkj5fSwWflOoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWsIVXMs; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWsIVXMs"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-46b1d40abbdso9078811cf.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738857045; x=1739461845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVYEH9u7BZqBR99JO0eGFShudYpqrhSzoFDK0x9XVJU=;
        b=PWsIVXMsqxR3dtwIZ+2QlF82ZLSW3v+zAz2wmN6LAoiAuNkKW4A46vBAr/2sPAkCRE
         duuJTfkNBt7y99TgL6/p0YxwHxiZmqGfl+D2tI1G6kdcuKsdp+eX08MCvAy12g8yjpPD
         +Gk+f3dBV+RMZZs/wipYt2nM+WpibIFACuQ82DqSLXgpu2H/LHJ8r4ZvPPQgSw2k67c9
         8voKmvGkLmUk8WLgRURDa1s1XPQrI6HM1zZwwlqBHJPopqq74cfwhnG1RkJQhM9UjM5k
         n9Qxu3ZeBeZO2TBO3NrM/1HAvBaCOrzDgsInM84X5PKUWrdf0tHqy944/ZK6jlZlz1oM
         7HJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738857045; x=1739461845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVYEH9u7BZqBR99JO0eGFShudYpqrhSzoFDK0x9XVJU=;
        b=hn6mSF5qhoppzFyij3yy1d4RMNVuZZLFLRZ39xm7HlPmcX1iPZ6qXxSLcihg/ajxLF
         geXBoIWVKiGIYHlO0TX6Dd3LBccQm09yLGi4+6e6POSI3Eg5DJ+uk6tbDyxYNvZhwtlh
         lN9Mj5NAisArT7ujJruKjYTiwx4krapLKmR63LrGQgxNFuQaFkb53OQ6uF8pdDT4/ypq
         dU6atOcowhZQa+mM5CPprZHxhagQpYY0ds61jEV48qJgXmBxXoqUjQ5sR269pSFlNaEV
         SDYSrlztBoPujDEPES0rQTdlUQ85WahRU0cFiVAi9lELh8tLk4PwdMZCwv7if6torCjb
         Kh3Q==
X-Gm-Message-State: AOJu0YwNA7BLG3u1Ht90eyLV1o5j9miHrGyYAVpHEARD8Aa2RO3yJAI7
	2joe8mYtdhF2z6lRuNIfWRxR612XqYZGxKjffjw+v2gPOgwdiMDo4/Y2xp15wOBmVYyorb7+elx
	RyH6iA4aZXCDfX4WV4VxT2kPFzInwZ3CqRacI
X-Gm-Gg: ASbGnctfz7Tc675ft3XPb3x8Xg8XFHMGqkiMeAfSKmVVgHxauGbxNiowUfjtUZLeDU6
	KXOXYXUVkLkWe8DAEGmEWOaGr+f3MSKNO6KvSAEb/vR1eaxCtxSj5r2Ctn93zFzOYWzU7YNTDks
	fPSYpApJWSBA77i0/NsW4mcKCmpsY=
X-Google-Smtp-Source: AGHT+IE+rncFtbwAhZ1eoJytYc7UY8vVDkzQB+FICzCa3dFx23X6hvyuFMYoDKTdtpAQ+BR2Few3Qk+b0NFFyA1UmdE=
X-Received: by 2002:ad4:5f45:0:b0:6d8:8fdd:9797 with SMTP id
 6a1803df08f44-6e42fc59b24mr129162316d6.36.1738857044694; Thu, 06 Feb 2025
 07:50:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206152100.1107909-1-maz@kernel.org> <20250206152100.1107909-2-maz@kernel.org>
In-Reply-To: <20250206152100.1107909-2-maz@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 6 Feb 2025 16:50:08 +0100
X-Gm-Features: AWEUYZl1exSceb3O3opzpDJtoQyjd-knXe-SoSYCxd4Vf1FfK1UFVnubiYOcITk
Message-ID: <CAG_fn=VMo=S_QBoSQ0oL-p1ajxU-=tX+EPqZ41POSSFMS08szg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: timer: Drop warning on failed interrupt signalling
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 4:21=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> We currently spit out a warning if making a timer interrupt pending
> fails. But not only this is loud and easy to trigger from userspace,
> we also fail to do anything useful with that information.
>
> Dropping the warning is the easiest thing to do for now. We can
> always add error reporting if we really want in the future.
>
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>

Thanks!
