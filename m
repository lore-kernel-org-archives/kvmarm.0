Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09929424
	for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708344164; cv=none; b=Eq5s20dyhFpSibXC7vBZvtDWyY22B1E+e8q61gX0iR6IZUhk0GjrbAFXYNXXUAgV2Mri1SNVp55SMwph30xndQ+rxzyhRA2hStqmFVQlmihfynlwR1ZQ678VEQuF4/Rh/2sAwAgcLfi69J+X+E/mHUFZ3iH6iBu9xA+BcQOkhok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708344164; c=relaxed/simple;
	bh=SJNxDovJQU4s53wEmE6hVUIUVXIND8lC8ymI4e7vDRc=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=Eb2jMD1X0u9ysy5IXsJ7VO7rn45vWcDlLEt4boLWrClBBVS8ppvPKE1rcHYXvxlQ3XyA1OjK+TLZUsiXrOYNVzSghGk0RK4i+29O8ayGTbgpsf73GPCV9eGJi5KgJRAOkGeufqEA9lZr3L/a81RV6YC4fdTJJ2NP8xZHI7M/g34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEf99pDm; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEf99pDm"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e466a679bfso268512b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 04:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708344162; x=1708948962; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXVHiQqTVvLwPVSN4wK295H+HuDvWyHMdFATUrh61Qw=;
        b=EEf99pDmZR2M03IKy2iyKyttj3/Qw0v4dXinc0z4ZITSGs6NUdPDrXRAdQKplyXjbN
         cQSy2Uu4wy8DoJet+2C071B2Ta4F9dLn1pthKaiDHQiG4Ecz8QQ+6RN2IG78fWMRwiKj
         6H/WgQM2vXUl4n6masWZT6hIsOS06Xgny4+XVFxBLrXgzgMmYOadiVsrKXryriEP0jmm
         RUCm8HT9F4BbOpNe4G9u61zdgZGUgRHLAr/DvuT7d25BrGWsR+4gjMr7I78Lly64A8wQ
         aXk0tD1uBlzikEf7SgkwpOvine+Qlxt/U9eUzye9ziB9lH6dgsvugvIkM4mfDgHlr5sl
         kmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708344162; x=1708948962;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sXVHiQqTVvLwPVSN4wK295H+HuDvWyHMdFATUrh61Qw=;
        b=TfLYNLEUVksEk8SMxDh15MCAahN0ukJ/Bis4qIG6G6Udv+I2cSn5XUb7/7E5tYNriD
         56qrlfs+8cNeckFaQGfkTGgili44mE22HrZoa88fKvRuh7p4ClC42Iy3aPiMJIpe3tpu
         YiOxYyIcR4z/YnQFgATQ9Vs92hRj8J/wQifwo2wKoGNhrsnhj19Ucugb6SZ6yYfGrtGl
         tJa6i6shVwkAl4KiD8Tz3ldDBIbIaB0vaqe+GBXZodLmk47ZScaOeXbUNsU/I+gemMsB
         THILO/3TNjY67HnHThiyQ6Ua7zEB/qNoRyeb06aY1jwJ9boXzYFAjsq6onQkWZDOCsKG
         cwTw==
X-Forwarded-Encrypted: i=1; AJvYcCXHnIMQJQqviMtnQcwZR5fTGqqxmdMHL1HhHVqBEWbfTeperneF1gPVpiUXNWoh31+90lIwZUVUR4XEZDgNFFnwJZ2HkOlj
X-Gm-Message-State: AOJu0Yxmq3q/2xTlB8vVeQwVY3MVh6FzZ178uNH21vdxLbRt8So5zXHJ
	BO/Ubi5MuWM11swKCLkcnq1cmTi1zcpZVfzAQh8H0A5Qe27c+h44
X-Google-Smtp-Source: AGHT+IGM/mBl6p+7VQ/UBUY0liSnc0g8tiRAnqqtUyMEBG/QP3L26RLnUqLU9SBZSVRFhEVzjBzHUg==
X-Received: by 2002:a05:6a20:2d13:b0:1a0:aea4:f15c with SMTP id g19-20020a056a202d1300b001a0aea4f15cmr656909pzl.4.1708344161563;
        Mon, 19 Feb 2024 04:02:41 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78551000000b006e0e66369e5sm4638738pfn.66.2024.02.19.04.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 04:02:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Feb 2024 22:02:32 +1000
Message-Id: <CZ91GLI40959.3EGSUC8X9D0WU@wheely>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v4 8/8] migration: add a migration
 selftest
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-9-npiggin@gmail.com>
 <abbcbb47-1ae7-4793-a918-dede8dcaf07f@redhat.com>
 <CZ7673PUQ853.DB10GSBEZ65Z@wheely>
 <4d73467d-2091-4342-87a1-822f4aeb8b70@redhat.com>
In-Reply-To: <4d73467d-2091-4342-87a1-822f4aeb8b70@redhat.com>

On Mon Feb 19, 2024 at 4:56 PM AEST, Thomas Huth wrote:
> On 17/02/2024 08.19, Nicholas Piggin wrote:
> > On Fri Feb 16, 2024 at 9:15 PM AEST, Thomas Huth wrote:
> >> On 09/02/2024 10.11, Nicholas Piggin wrote:
> >>> Add a selftest for migration support in  guest library and test harne=
ss
> >>> code. It performs migrations in a tight loop to irritate races and bu=
gs
> >>> in the test harness code.
> >>>
> >>> Include the test in arm, s390, powerpc.
> >>>
> >>> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
> >>> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >>> ---
> >>>    arm/Makefile.common          |  1 +
> >>>    arm/selftest-migration.c     |  1 +
> >>>    arm/unittests.cfg            |  6 ++++++
> >>
> >>    Hi Nicholas,
> >>
> >> I just gave the patches a try, but the arm test seems to fail for me: =
Only
> >> the first getchar() seems to wait for a character, all the subsequent =
ones
> >> don't wait anymore and just continue immediately ... is this working f=
or
> >> you? Or do I need another patch on top?
> >=20
> > Hey sorry missed this comment....
> >=20
> > It does seem to work for me, I've mostly tested pseries but I did test
> > others too (that's how I saw the arm getchar limit).
> >=20
> > How are you observing it not waiting for migration?
>
> According to you other mail, I think you figured it out already, but just=
=20
> for the records: You can see it when running the guest manually, e.g.=20
> something like:
>
>   qemu-system-aarch64 -nodefaults -machine virt -accel tcg -cpu cortex-a5=
7 \
>     -device virtio-serial-device -device virtconsole,chardev=3Dctd \
>     -chardev testdev,id=3Dctd -device pci-testdev -display none \
>     -serial mon:stdio -kernel arm/selftest-migration.flat -smp 1
>
> Without my "lib/arm/io: Fix calling getchar() multiple times" patch, the=
=20
> guest only waits during the first getchar(), all the others simply return=
=20
> immediately.

Yeah I got it -- I re-ran it on arm and it is obvious since you told
me it's not waiting. At the time I tested I thought it was just arm
migrating really fast :D

Thanks,
Nick
