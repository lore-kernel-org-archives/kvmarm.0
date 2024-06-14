Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29579CC
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718325829; cv=none; b=rPwUVKSJzQZZlaxPYpCicIRvBcxqP71y2Xp68hcXr6x8bZzHB4A9sJKlgDFDJyttC+bfd6fmTKsYIzqULQljNNBgC0OzacmrVFyxBoG3UjlNchSUJSNh/5SQBoJGcXJp3mzAmgXzY9wmx4FqHqrgXSFA+4Fs8quvnHrkYZn/u0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718325829; c=relaxed/simple;
	bh=YeGjlmbTI36irvbQqfOfz9A45ri6Xl8G0t1fxDrHCI0=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Ytgfl4hs1b/F184X4wSdQ9On14/heAHPLu06YiFdRCdE0n8vEQBOmXaAi+A4vJni8MU93eLsM5PZPh8BBmaYFPbTfacKadYzvWfTaqU/4cVvM5kn0SDklDgY+fAmhGsm2nK+INHzmw6cIZEFNRVlEKFCvUr1OyUgznw0aQ7eWNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsrt7zIS; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsrt7zIS"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d24c3f4b86so471095b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 17:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718325827; x=1718930627; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eWVs6LwRBJG+U3k9Ejxz2oBmjdXJxvB7EaltXDx1Yc=;
        b=fsrt7zISsSZIrUUd7H79h8B+6mXKn+L4cFNe37GC25dZww8za+dCnGXLwUDm4RiouU
         WXxgMgl7B5yoke/gPxA/BBp6Fo2R6cBWK0odNNWioedMzsuIlLGWU/l6KPHribl8/vMt
         mYLscw7CkQZMCIbrx6se7bgbslDmUg3iOVJLzbo6aT76RDulKtatdYtTpjhMwMhxj8T0
         gTPJUPFs1MQfkURqTmQxQX3HPSnI/8FF8tE+Z4BNBwpzQY7bMaAOhqZu8vuIYCQE1X1f
         MRQyDJb/UoiuIx4tP0QH/uj7Ulcj4q4NOw7rs008qugTlbndCYDMC294uteNEhcta6by
         lS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718325827; x=1718930627;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/eWVs6LwRBJG+U3k9Ejxz2oBmjdXJxvB7EaltXDx1Yc=;
        b=JrzMJXm7AkCtDGjeSg5D8WRmWOgt9S/DNMb/cvb/BNVVEDaMb1tiowMvSH/IdFpbWa
         GAjzBLmN9QHCXKTz+CS4dB1uS+39y1jsJFd1rFTNHcXcRXipwwVl/tQgLtG8L3YlbuRw
         ++nLELOu1q/KghFn+tOf2Xb/S+VlNGwI4K/PZFYGRS7wJcqOkGXHNxSUVpOrMvLXsBgp
         pGlTVvrbMW4Zz5eGRXoDiLVnzDn3lyZR4ckEF5zHZuwirILX3XeegzqSgbs9WRIliQxY
         J6Sji4iHQsaNwxLRtZz89lBTq06eOMPP/pIp8NtuYnXR+0iVGjRJvTdT318E8SzfzJ1I
         gQIg==
X-Forwarded-Encrypted: i=1; AJvYcCVVSf2eadjhMQFQ6DUVJBiuIJqrQlBTfIU8OcaJK1b7o7QmkeHAFHc2Ocbp50f0COezeErUWBIJt0281bFxvdx40SLpYv0O
X-Gm-Message-State: AOJu0Yz9DTvC2JxxStM4OOtRSZ/tC1FUSfXCAtz8e+H3Lhf7X/M7m31E
	7vuNFPYOUMqrjBEv1qFvk2QynRjXMcfz0cPzvZWKsQykzSVm0iMa
X-Google-Smtp-Source: AGHT+IG/WsixQvvfFJeL2cK/SvFU0QWQIcY3fHQHS0r/xzXjpdjaDngQ5f4l/dQsk2QM6rvOkN+UjQ==
X-Received: by 2002:a05:6808:1992:b0:3d2:24d3:80f3 with SMTP id 5614622812f47-3d24e9dc797mr1382862b6e.43.1718325826876;
        Thu, 13 Jun 2024 17:43:46 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc922643sm1950344b3a.31.2024.06.13.17.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 17:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 10:43:39 +1000
Message-Id: <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
X-Mailer: aerc 0.17.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
In-Reply-To: <20240612082847.GG19790@gate.crashing.org>

On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> > in dependency chains that cause them to be made as intermediate files,
> > which get removed when make finishes. This results in unnecessary
> > partial rebuilds. If make is run again, this time the .aux.o targets
> > are not intermediate, possibly due to being made via different
> > dependencies.
> >=20
> > Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> > the rebuild problem.
> >=20
> > s390x does not have the problem because .SECONDARY prevents dependancie=
s
> > from being built as intermediate. However the same change is made for
> > s390x, for consistency.
>
> This is exactly what .SECONDARY is for, as its documentation says,
> even.  Wouldn't it be better to just add a .SECONDARY to the other
> targets as well?

Yeah we were debating that and agreed .PRECIOUS may not be the
cleanest fix but since we already use that it's okay for a
minimal fix.

Thanks,
Nick
