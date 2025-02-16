Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E9217E019
	for <kvmarm@lists.linux.dev>; Sun, 16 Feb 2025 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739732139; cv=none; b=rJ2VnAQE+XuNjUDODjcJYuX3nzy//nmxSMc2WUUKhGlP0Zr0zTq2tEr4d4/4cwPBqEvm9z4ksSTqXaNuzd/CMJcJQn107qZs0l8uNsi6VocC8Qa63hXXswBlVCgjFmJba6RZWU1kTXhcBsqo5AiRokqnLeEoA3zJMWfScn+TkeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739732139; c=relaxed/simple;
	bh=IKpPF+jBmDIT4Sot/gf+UPfPlLbYFzYrpayV85CmsbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZNivegMV4Giw/Z/i3YoPlNNPCqSRC03J6uiWKmBFaE0f0lISjBUVpy9oxkEi7kzgzklory8yhu7UGayFAf1SoeOyRD/eOewTjQHRb0qfp53Alb/kq7dSq/DArMHNvynwlv7dVTjuWH2FNwRKyXyZslX7sjigFgfp/C0g+zcDvmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEoeH8VN; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEoeH8VN"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abb7a6ee2deso160947466b.0
        for <kvmarm@lists.linux.dev>; Sun, 16 Feb 2025 10:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739732136; x=1740336936; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hC5pjueK3njHG+/S0PsoYfxNvXRhtdE6Y8ckyHhZnt8=;
        b=DEoeH8VNxhxbDZQfqWNtK4MieRZJtXV1eNX+NzdCh0KEjwZ+xE9WzDvZfFDoOmmYkV
         NkTQVObpz7OahQ/DFgF03pl9ZyQyFSbqpgBpWEdi92XPxlqZMnzfIGnsquLmWKhR5c6f
         wkAbpR7YgL8+XqV5xGY4GBjAoc968Xtlg0rV40SnrJ60GD0P2F+RBP/CkryIeXv0iAXv
         F5KS1vs4Ud/o2fOqrW8om4UC93MbeUE4y5b2pYf+Nl/jpBXLmdVU+/vDDESlheJHXFNk
         DDsAxCmjp1xbAOA3ewbTfMmSuacTsyj/J49zyUvnycqba6xElqvTfUkm0s1flk1y5bIe
         PFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739732136; x=1740336936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hC5pjueK3njHG+/S0PsoYfxNvXRhtdE6Y8ckyHhZnt8=;
        b=fdTOZCmDaUX7IfRbb8p0E3rU6ZgFBqwDAXPUcHrE6foJ1MITYp2UXNcuQ3qxI6Xe+Z
         OvoP251hHe3jAgFpWh2IGtiYvfNoriwlUkgi/Tvdl2XbOn2iuioCBKI/TFOVhQ3I5LWs
         ZswuVllMecU8RXdMCXAOr7GtMPXyknt1Zlfpkuf6j0nPbOIKxQQK/5146Mi5IVTC27AZ
         gHW8L27Y/tfp7766nufbXJlgzGTn8lPMnlAtyjKP9GoUiVe1maFbrGqscjFmlK6PP+02
         JNqSZrVLqRaYdQahLWfmkuBd+Pgm1bxemtK+hqBWSn/YGevew/C/xn+YbndYbBJRfbxo
         4H1g==
X-Forwarded-Encrypted: i=1; AJvYcCWzAgD1YBGInEx57Ptc726YpP8yDCi2ceN7m4wX/PTYHPTt1OHvFlHCS5vwY8lYyU05hTPjYGo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnbqfXpcFqZWpKTm8hTdY6z+r4lOCXX67QaprwpMvExaKItFbB
	pHyMykkI6eeLuXHdbVRnMG26awCkOSok9udbxG6NLxQU25rg9GY0HRKrBldyYYcFcAW7ndf/D1m
	uDKpfoQxef+CZmxJNqKnkDqyleLA=
X-Gm-Gg: ASbGncsLBGilT1SD+kxaStctGxWOjwAFNfvAqnrPuBTIjkXFX8SLOX68uS8UhQUPazS
	2/UudwTHyPBbv+SA8Sdmh5jyZSlOiwbhRlEuKr8HAFxz5c3xhJDmTgVV7w45W6XpbZRUTo7Vt
X-Google-Smtp-Source: AGHT+IEMhW69OjMic/GlsnphTy5HjgljXL7lYabt3t/KZP5dlB7Z7axgQFJTFGXD1Wtre/ru3ZMNXPSCNMU+4lVJMnc=
X-Received: by 2002:a17:907:7f27:b0:ab7:d77b:43a3 with SMTP id
 a640c23a62f3a-abb70bdba40mr717236866b.32.1739732135933; Sun, 16 Feb 2025
 10:55:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250211143910.16775-1-sebott@redhat.com> <20250211143910.16775-2-sebott@redhat.com>
 <Z7BoydkyT_h0gwOV@linux.dev> <CAE2XoE_8ihJZQF856w-_F+cgJW7fLWGz7M7Ztoxzw2vE51_m1A@mail.gmail.com>
 <87v7tb17os.wl-maz@kernel.org> <CAE2XoE9=hjP+qpsy+FcYcSDectDajiXjtcMCVpacSo4cFOo=tQ@mail.gmail.com>
 <86jz9psqwd.wl-maz@kernel.org>
In-Reply-To: <86jz9psqwd.wl-maz@kernel.org>
Reply-To: luoyonggang@gmail.com
From: =?UTF-8?B?572X5YuH5YiaKFlvbmdnYW5nIEx1byk=?= <luoyonggang@gmail.com>
Date: Mon, 17 Feb 2025 02:55:23 +0800
X-Gm-Features: AWEUYZk3_EEMv5D6Rj82ShfmoPzBCN_NwGOjAGxgYCLPZKy3POf8ciw95cVy4Uc
Message-ID: <CAE2XoE8i=jPgSea5jXY0eOxas9Y_2pa7QheqS1xuw2qeTQDNyw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sebastian Ott <sebott@redhat.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
	Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:09=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 15 Feb 2025 19:04:20 +0000,
> "=E7=BD=97=E5=8B=87=E5=88=9A(Yonggang Luo)" <luoyonggang@gmail.com> wrote=
:
> >
> > According to this, the MIDR EL1 is updated properly, but the MIDR for
> > aarch32 is not updated, and I don't know how to hook the update for
> > MIDR for aarch32
>
> It is the same thing. The AArch32 view is configured the same way as
> the AArch64 view, and there is nothing to do at all (that's what
> VPIDR_EL2 is all about).
>
> With Oliver's change, I'm correctly getting a different MIDR using a
> hacked up kvmtool, see below. I suspect you're not running with the
> correct patch applied.
>
The applied patch is V2, with writing vpidr_el2 disabled, Is that the cause=
?
The branch is here
https://github.com/lygstate/linux/tree/main
I am not applying your patch

--=20
         =E6=AD=A4=E8=87=B4
=E7=A4=BC
=E7=BD=97=E5=8B=87=E5=88=9A
Yours
    sincerely,
Yonggang Luo
