Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CEE1C69E
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 08:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708935014; cv=none; b=UyuGU08Ei34FFYHC0OFxuMjR5cs2FaqkekXLSkhlq3Tq5ovFiwxnsG984oAK7i2gqgarr7d1kgSsTsUKDMntp3PYlXIrOl+LV9qgftf/kNAzv4+IeTebM9uqu22eEcB1jzVPpjg5IuOBTX4f6HLXCeWuNWUbK0ll83Yl3xs98hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708935014; c=relaxed/simple;
	bh=0rEJgdXMQFNKOG9TkEY6a7r5OzMiNPZsokrEY69bxso=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=EuVG+SyMdVxjf8jde2yzAQ0GzGJVTOS2WALb3DUfex9ZfcaCmGxzfg0jlRTdLpfbM12eWldrDyCujLyjq2Gq4BLGz1JRhGfKnajdW6ylDS+LAN8fuP7l2jN4b8UWltLWjVwzfgxFMDLWmNIAstSIJkbPLaZJnM2FoenSxUh9QyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+m8er1l; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+m8er1l"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dc139ed11fso17063595ad.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 00:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708935012; x=1709539812; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40CoeWlqXJhcfzeZ8GLVER1J3s3pk7Hsd4Z6LBpACw4=;
        b=S+m8er1ldRmiicKuVvLQNaG4xJ2aIkFkwcxtSfg0O5FKT2pKzbAT1pYRYE3xUbx711
         DmaYM9iYE25Qy4Exq9JVt8sUmmmezBgcEfFs0dleci9ZdFZ5QKzYTe4npDkTNepvkK4X
         ZBlIc1sGZta9+B6ADagh23y2QJCw5kZ2B6OdMBUfQnNKU35+BJV8MnhgtgwZfDvuoIeL
         88haotWL7KlMR0WHzgTL8bccLXWQ9mZUoNvsww5kYGmc+CQ58oM7d+Z02CoY7XAGjcQh
         PTur5BhBUn/5Pijh771P3uxuL1GVoyRWjnx4hbe9lKb1IDv4CQIghTFV8uYua9t7YMNy
         urlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708935012; x=1709539812;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=40CoeWlqXJhcfzeZ8GLVER1J3s3pk7Hsd4Z6LBpACw4=;
        b=X5EzK0N6UV0bzfIRQ8bKgUuaWbcHnbhkXWIcEu66cmvQfHn7JaW58Cotrmw/HgJ9oT
         gjGtY/Mwc52t95tvSTb1711JoIXf0aShr3TWUVKNeAoF5gdSaVCjwlmHfpORvFOnKrm6
         S5lb7CHcZXf/IVxFaXM4CjNWu5pbXTMxvofLnlggwfK+L3TGi/2nGidXlnZZecpoEfLs
         PGrYmMlpWPqBHUeREHUM3udCKy4+Qbqqsf2dkH9nXL2bSp3IgIovPte5nbwFYWBiU3O0
         BzWv6KS6nSP6KbkXLzvEQx4iG9bxz0DaVpt4pGqHzJHd9T6PtWB+hZlmIL7a3TSutSDW
         wXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvLcb4/X9S69OkUV3Y5zr7dSAjCXQ/zLAvPhzRJ+LRER307NBj7iE8DvieDVfOgD3Ajeqks9zaIu9bTTmeo9uoAxEZkd1c
X-Gm-Message-State: AOJu0YxBf0YS7ah1PIpt74PjAN9VvGjq6DZq3GR20uH8438MP5azA0b2
	E8OQGYvhzws3FOz8cwcr1qCounQW268qGDNwYmtG5orNtVOPFmm2
X-Google-Smtp-Source: AGHT+IGjewnhiknpGMm5HU4N8i6SJvrGSCvXNkP65jhcUFNHjZ9u6URsa8lY6wCVKeLBowpA/NdmVA==
X-Received: by 2002:a17:902:e5c7:b0:1db:fc18:2da5 with SMTP id u7-20020a170902e5c700b001dbfc182da5mr8456349plf.30.1708935012131;
        Mon, 26 Feb 2024 00:10:12 -0800 (PST)
Received: from localhost ([1.146.74.212])
        by smtp.gmail.com with ESMTPSA id mm12-20020a1709030a0c00b001d8d1a2e5fesm3348276plb.196.2024.02.26.00.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 00:10:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Feb 2024 18:10:02 +1000
Message-Id: <CZEUWE22JA80.3S73L9F5A04RK@wheely>
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
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240221032757.454524-1-npiggin@gmail.com>
 <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>
In-Reply-To: <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>

On Fri Feb 23, 2024 at 5:06 PM AEST, Thomas Huth wrote:
> On 21/02/2024 04.27, Nicholas Piggin wrote:
> > Now that strange arm64 hang is found to be QEMU bug, I'll repost.
> > Since arm64 requires Thomas's uart patch and it is worse affected
> > by the QEMU bug, I will just not build it on arm. The QEMU bug
> > still affects powerpc (and presumably s390x) but it's not causing
> > so much trouble for this test case.
> >=20
> > I have another test case that can hit it reliably and doesn't
> > cause crashes but that takes some harness and common lib work so
> > I'll send that another time.
> >=20
> > Since v4:
> > - Don't build selftest-migration on arm.
> > - Reduce selftest-migration iterations from 100 to 30 to make the
> >    test run faster (it's ~0.5s per migration).
>
> Thanks, I think the series is ready to go now ... we just have to wait fo=
r=20
> your QEMU TCG migration fix to get merged first. Or should we maybe mark =
the=20
> selftest-migration with "accel =3D kvm" for now and remove that line late=
r=20
> once QEMU has been fixed?

Could we merge it? I'm juggling a bunch of different things and prone to
lose track of something :\ I'll need to drum up a bit of interest to
review the QEMU fixes from those who know the code too, so that may take
some time.

I left it out of arm unittests.cfg entirely, and s390 and powerpc seems
to work by luck enough to be useful for gitlab CI so I don't think there
is a chnage needed really unless you're paranoid.

I do have a later patch that adds a memory tester that does trigger it
right away on powerpc. I'll send that out after this series is merged...
but we do still have the issue that the gitlab CI image has the old QEMU
don't we? Until we update distro.

Thanks,
Nick

