Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24BD134B4
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 12:55:08 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-65242634690so4147195b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686660908; x=1689252908;
        h=to:references:message-id:cc:date:in-reply-to:from:subject
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N9+J5pkzNukUkC+uqb2tz8DIK3px0ww4xZnjqp8unR0=;
        b=bKuxr4gjk2PMj61xfuW+ebHXU8+iCXVxu3jnqjg+5fgtRsnA2us+DfnrHaM2rka0Fj
         AqpYG7fycKc80sFo4JRtHu+kRafFlBnTmFHR0R96zVr9wnQUKyFpMk2lFvmD7/36FJH6
         CPMryp9EuBngD8qVgoxwVMLCmtRas9uT7yV+LfGliL0JZeFSHJumKgbWgqbcd26aGmVE
         YVRyvV6u9K1uA6DXLLJsZ9FO9siuFNSXpRj9vJxOIqGZVD0+A+RllTpNrQjJaK38c7LA
         soMcmByTGygWFzo+1JVOZSH7WR4m/7mXhmIix1SR8OFrEgeB7t+l/8aKXsw1lm1HfoCB
         Lnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686660908; x=1689252908;
        h=to:references:message-id:cc:date:in-reply-to:from:subject
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9+J5pkzNukUkC+uqb2tz8DIK3px0ww4xZnjqp8unR0=;
        b=BC01SxfwiKpApryR65mn7uJ3nMTFwLS6U4MnTyQMbThqI95PcyDEap32IrRowMhqDK
         INg60ymB3D8zx02rKrBFlwrO8UPLI9EHKO5JSiut8tiTrn7DG/MrE1PuXZZ4FhQgwmLT
         lv1obW9wQ39X13mOxZWx2LwRhrrNcdYqtg/+GvGzpN7CoZVsLYIPHLcKQgwTJxIRVbl9
         FWnqYmYQ/r0MpGnr6e3Ik/qqhR3GLdoDAsrJCbIbjTOkLey1rDEM0wfeYJQrEiiPiyFl
         g52lbbr/UM2rhMAtob1KilzcpVRmAC9UMuWUUQZ0mJRRGyWV74eEgyrlXMS3LCgcmN2M
         7hUQ==
X-Gm-Message-State: AC+VfDxAdsiLpr1bUmjkYSpGpIlnsWLLxkJRnXfHc1JUo4Z/ignQ4UNy
	gKrIbkBtR1hY8025ZiNug/0g9b0VGU8=
X-Google-Smtp-Source: ACHHUZ7MfQ83oeDmCKmmF5IR2/dUBT3Uiq0Q33EsEyZFdNt5EmdBPOC7p+P3Sv0wyKFxK0zN35mfmA==
X-Received: by 2002:a05:6a20:3d17:b0:10c:41a6:ac1f with SMTP id y23-20020a056a203d1700b0010c41a6ac1fmr13360873pzi.16.1686660907717;
        Tue, 13 Jun 2023 05:55:07 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902d68300b001b243a5a5e1sm3553874ply.298.2023.06.13.05.55.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jun 2023 05:55:07 -0700 (PDT)
Content-Type: multipart/signed;
	boundary="Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3";
	protocol="application/pgp-signature";
	micalg=pgp-sha256
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230613-6b1cb3080babea45f2542c49@orel>
Date: Tue, 13 Jun 2023 05:54:53 -0700
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Message-Id: <D24DE2A5-2655-41C8-8320-69E1AD67823D@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
 <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
 <de16e445-b119-d908-a4dc-c0d7cf942413@arm.com>
 <20230613-6b1cb3080babea45f2542c49@orel>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)


--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jun 13, 2023, at 4:21 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
> On Mon, Jun 12, 2023 at 10:53:56PM +0100, Nikos Nikoleris wrote:
>> On 12/06/2023 16:59, Nadav Amit wrote:>
>>> Thanks. I am still struggling to run the tests on my environment. =
Why the
>>> heck frame-pointers are disabled on arm64? Perhaps I=E2=80=99ll send =
my patch to
>>> enable them (and add one on exception handling).
>>>=20
>>=20
>> I am afraid I don't know why it's omitted. It seems that x86 and arm =
keep
>> it:
>=20
> The support was first added to x86 and then I ported it to arm and =
gave
> porting it to arm64 a small effort too, but it didn't work off the =
bat.
> I wrote it down on my TODO, but it eventually fell off the bottom=E2=80=A6=


Thanks. Don=E2=80=99t worry. I=E2=80=99ll send my implementation.



--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmSIZx0ACgkQHaAqSaba
D1pJTA//eDphpaaagDgAqhCvKZmAzI6/Jg7kihKfKAiRy/p29ZfD1r4hHcE/X4XC
qWvyvFVc3qkKUhUayGW7w3+XsJibZ7mbUzoWZFIu1IL+C5SpLJOvbaVObu05j3pV
aZicJ1JLXoo2HM6mMvz4Y5hYRlHnyQes2qvOmqtQ8Z2vI2NWS0PJI9tsQW7R08pQ
mgeyjjnOudh0MjMGIB+FlmFRnfM4wRaxAT/3WibqR36u7Lupaz8OHa81t0JjPNku
+GxztEiMkJZDNB5O6H/QXfnOn2GiFwIVxpXKnP0lM+IowLKDDCxijcodVkdsm6ON
Gvye3w8r2A2aSGb83XWZqy09FlWlMq0asUKLIIhk0pyUEvxeOnQpPnKyCqFT2jVY
gNzeKi3ZfpxeKkWwYLqZworaGuBbkt4iKPWm8KVBZo0kQzefIU534a9GfZUzyHvk
IKLWpzip7/rsXBWXOXcivcenizEYCuNJlc25DKtzOPbFvU3gJF6dafq7LcZb9yRq
biQwQrXtCnFZNlSs0Uzb7BQM6hNJyDeJ8KwjCs8rnBXf7Al+zGGT5V/8CyR1Kvbw
prfjIRvEd85aJOrqQYWmcX1WbfU8rTze+jImsDYN74U/Wix42j4jiFZCp8/uxKQx
omMbG4ddTbY+gsL150AWfKQKAVCDO2T3ZwjdMbH4CjOXmUP/Jfg=
=L0j+
-----END PGP SIGNATURE-----

--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3--
