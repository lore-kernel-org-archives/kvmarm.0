Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472634B693
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 20:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777061746; cv=pass; b=RlDa/10zJMpGXMuYc+X3ndXGlOGXBx3M/YmViAJHQFigLqYOn1F4Cci/W16lkdjJcCZLDIQr9YqE36zn3SCCYFQJngyDmmnOd8vY0r1wNwOmMc1Jze2YwjGw7luzpPnTMrfdJG1I5f61+3MFE7aQbZ6RUlNcUU4fHB+9pFl1Y08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777061746; c=relaxed/simple;
	bh=Vbb/QbHuW7LGihD/Z5UNc4YCg0mP3LbwRcOYR2R1TWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tBl1ayBhP2M/P8UHaiaPNfuzMGOlmBXKgGLJ8A9jGeFkkDLZ+KOWMtmUJhm6FsZ2Gt/Uik9C+aO1dyuBnFJiu4cywBewNirWoEy3zcitKQSJnd7QY4WlNTjD7D1LKfRemPYxCUqv/cshdCnJFBHBGjCsGUVsHbegdq8Wx0hxFXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=T4t12gaB; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="T4t12gaB"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2adbfab4501so40939955ad.2
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 13:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777061744; cv=none;
        d=google.com; s=arc-20240605;
        b=JxzMLcS9BVacK+Qj2vZ6WyTZG4KRLpTGEyFXhESSVUG5aOUqh/qUwRRnbOnHgHxlaw
         0y2tBM9sHvexBuQh93Y4JOiPFtHXVVg/zggL/cj8RGccOPHEdbjY7toF6VK4Tmvr/Mur
         4CbEYtJOCvdBxJhwxAlJgW3rYlyQv8byMoXV00F4HwRIV+3yJQANbSRgQT4WL98PhH4Q
         4X53s9Z5Zso4VFtz8jrKaSkLPbMWz16rDFKvZnjM31G868IBcIX2CvN44KYIrL6GPmAx
         N1BC4JBnEjoS7TvELuWXEOONVhir+NMEl1WryJU3CayOCvs6ZRA82nZbuNqvi8GuC99O
         7U3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sp92EwCFMmdCctd+G8p5NZ1F+m0+I8XgaVk8fcD+2Os=;
        fh=iQu9GyP+YFwu0PIVlyRSsLG52Ol4yIbgzVnQ4JZcoos=;
        b=D+3h32yRbYs1H8YB58NngjVk0yMg4kf4pdaSiQZz73azsnHibPHgAXAqezSg+dk+m3
         VRbAnn09l2G6DkTti2pQ1NoE6K7YRSeDwlf3zZcGZtlFnS7l96opGqMPWFFARx8twjZA
         iZAJv2FOR7BihMDNl+kXXz+qca1Xc91rRdZheEQ58Op8NkckGZFVs7v343/Kgwir96VB
         pB+DO6+07z/FvkJFDRUOp8fQ9HYbteI3XIwCfG9E+52xrIzbtKTuwh+N6sJgI7V5gbox
         YLK174M9X4gkpkqkbicWQAfkiueeyS++czJA0XnIkoQmOUz0pD0q6hXEsV1jbRqiDYTw
         gmxA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777061744; x=1777666544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sp92EwCFMmdCctd+G8p5NZ1F+m0+I8XgaVk8fcD+2Os=;
        b=T4t12gaBEccul4cvsyJWyU0ZdNs2FI9HaJAOCMBIhJUWEKcSSzT+AfLBLdZFCDK/yq
         WAB9NEuD1G0zFZGvO7WEGr04QCHtBvuh7xByE74WCg3egvvd4+BAOCpsMzpQR6Rqw/mU
         5FY/jqp7I824VRoJd1QhKuu2mYZmlv/mL/Epa7yNzNrmbc4gUcOzHiuNvyjD+X5i6ChM
         lySlGU7V8f26OoNc7YaHQ0a7U0Yy/RGA0zZ9Ca2rcPUtsdAKGqUsYzimcpBLzaQFDlPE
         P914Pj1jT6eQpixUCGzLIi+3Br/3sgytijaKLFt9gdWpTjbz8OSqQaTRy+0dVT1rFNE/
         VCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777061744; x=1777666544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sp92EwCFMmdCctd+G8p5NZ1F+m0+I8XgaVk8fcD+2Os=;
        b=r/k2AiAJYoh7hyKHtTJ1HAf1qiBVvdKccMlY3iloj1VW5BpYE/hClUIBERklxm12Qy
         +Wg9oDbif+ajkn6UF+MWBjfH++uRsGqrLdi6QC+MK3p88Npg/VQPz5UuPAPfldGsx54S
         VYSPTq9vS+ZSAi7tzE4JMB4kLHAsnb2Ona6MuhSwSUiGMsZ1sYRTSDczBcq089kNb9b0
         On11J7ppWllKcsTX5DHzY10IqGJHCN8ZBCtbN57fMpOKyrLHSvisWmPf3vAFuE9iQWOB
         soToy1pHM2M8+LT2EiiFrgRZi5gg4Wp0O1uf84dEJPThc3N8bWF/e07lYo5Vgi34lm/Z
         Sh5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+cvmwmSdoZcC9jKEqcw7HhEDt6FJPd00q0M6tc7Fnz3m/sAu5FD9XK3NdFParNWntazb4QW+k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+sY6I7GTf/KuWCwEKskgRA8FCoLkMedgDuzoq0SiJozqsvXPC
	2LUbV3P91rQsZK5vjmaocqhw6LYJ8DRR5tL80YSP3m5l8A9btGyrRpn6ykW6dI4IqWjaonDAxUt
	5Yk1gfDTnE2JYXHpmIqfev3W4TMwkBcLLZ/sjUyVY
X-Gm-Gg: AeBDieuTPUhgFpQ5L45RLLDbj7P4ilswpXPpm7/WOZcZRvyt655BM9pgvImyKMDrmRR
	tnb33CV7Way9ji1EV5Nv1afmBUvcrLSIP0UGZTR+M/Wd7HTUnUoYM5jb91GyUaI3snf+TvtbRGC
	UvX9v7kYBnxUbV0dmLZ9vtT1Uy8J71PKbnjgVic3ZPkWxKjhlYZCm9uehkWZlOdPgN4NHlbVp3I
	WAFaupgMT+pKhhypbKNXtT5kfpKxFHvY67RbCO/EZCXEJofdxBOiPuP3Tu5Z191bsZD03lNebM5
	49g1P7YuvwUAM/m6nQ==
X-Received: by 2002:a17:903:883:b0:2b2:9f45:2266 with SMTP id
 d9443c01a7336-2b5f9f8302dmr254143155ad.21.1777061741644; Fri, 24 Apr 2026
 13:15:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aeoAlVEwzRUPrlVe@e129823.arm.com> <aeoRxWPyOHGJd+Jh@e129823.arm.com>
 <aeoWO2Cwo04YYu2l@earth.li> <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com>
In-Reply-To: <aesGU8a3mbVzvteH@e129823.arm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 24 Apr 2026 16:15:29 -0400
X-Gm-Features: AQROBzD85SjPMTZ-_HyOS5lMf1XvZbjXC0wu_RfpvlwIboP78qicPJqw2hn2ACs
Message-ID: <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Yeoreum Yun <yeoreum.yun@arm.com>, Mimi Zohar <zohar@linux.ibm.com>, roberto.sassu@huawei.com
Cc: Jonathan McDowell <noodles@earth.li>, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 1:57=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
> > On Thu, Apr 23, 2026 at 2:13=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.co=
m> wrote:
> > >
> > > Sounds good. Once the patch is posted, I=E2=80=99ll review it as well=
.
> > > Sorry again for the noise, and thanks for your patience ;)
> >
> > My apologies for not getting a chance to look at this patchset sooner.
> >
> > This seems like an obvious, perhaps even stupid, question, but I have
> > to ask: if IMA can be properly initialized via late_initcall_sync(),
> > why not simply do the initialization in late_initcall_sync() and drop
> > the late_initcall() initialization?
> >
> > Does any IMA functionality suffer if initialization waits until
> > late_initcall_sync()?  If so, it seems non-critical if waiting until
> > _sync() is acceptable, as it appears in these patches/comments.
>
> This is the way first patch did, and here is some discussion for this
> (Might you have seen, but in case of you missed):
>   - https://lore.kernel.org/all/a6a0e15286c983d720de227c6827adbe976c5b9b.=
camel@linux.ibm.com/

Thanks for the pointer.

Unfortunately, my concern remains the same: it's either "safe" to
initialize IMA at late_initcall_sync() or it isn't.  Attempting to
initialize IMA twice seems both odd and wrong.

I understand the need to ensure that the TPM is available, but if it
isn't safe to wait to initialize IMA at late_initcall_sync() then it
would seem like this is a bad option and we need another mechanism to
synchronize IMA with TPM devices.  If it is safe to initalize IMA in
late_initcall_sync(), just do that and be done with it.

I'm also guessing a two stage init process, e.g. some in
late_initcall() and some in late_initcall_sync(), doesn't make much
sense here, but that could be one other thing to consider if some IMA
tasks must be done in late_initcall().

--=20
paul-moore.com
