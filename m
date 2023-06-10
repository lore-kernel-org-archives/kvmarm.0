Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E4E1114
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 01:14:08 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-52c30fa5271so873437a12.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 18:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686359648; x=1688951648;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1B2w267TBCpz92wei44eed0BDmkFzEc8WfjYSUeJWY=;
        b=Uy6aU5sEf3jT7I+LecbM12yEPgp9cC/kXC5awo6u9TOLDl6tvOsptrPc0+ee4ewkea
         mYOIWxMMGHUIzZm40dMF0PB3T3pPvEqNPMSsXJ8baitNi1KJNTF9ImTz6UuMJr+Kasy7
         Y0pAC2cVj6SPR3OW4Ns5bET2OoevWtIrK9VItlYnF/MHkVuh7wo3nL79R+KAxOIKmIOx
         RWiyWPyPeUXKntfQHtx9XwnKV3PoI3zqFtJtPpRaMQjj6tre1hkCh6ecLY8rUU/hMJle
         +GGgU2GtQ5IBIWVWHbkuUP9DAbm135F0Ihx73UuYYLq2lKuUamG++YM6szss3pqF+MoK
         qqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686359648; x=1688951648;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1B2w267TBCpz92wei44eed0BDmkFzEc8WfjYSUeJWY=;
        b=Uqbz26pQC9fR6xWLhuBj2SduVVoqkppADMjkNv8CMmbKNiVVpNPix1ojc7GNW6hOme
         M7MT4TBylyKPPAS/n50vo73a9zG3zm78rzNXIHPG1L/KD37jVIvZxlZquYo99QOHX5Ut
         acSEbYKR/RIJqMaxMwk1+c4hNptoUtsYRlscW/y7qR0ZscITNlcxqTRksgP/I7lwnPH0
         i5OHUVAFB6geFdTDlolz4vSiOTY3FS8jHV00kUm8TjHsutqA3yj3rcGWQexvIqN4/0bv
         DwIUQCo52/Af4yHfDn/oZ+zSjnL9GvoVZgLbZ5o1FgOcCSFpnTq9xri3rcl1ptebhPCA
         PfBA==
X-Gm-Message-State: AC+VfDxdz27Twwm5zyhFhNVGf+pYTFrAt9tJX3PNtA5zRjVOjKe20bTK
	dKDcSPtN9iYvR92do60kiJI=
X-Google-Smtp-Source: ACHHUZ5ylaBpGa/gkxG6a2Q+jnkyf/UAtXUzQ1Iqg6nCj/4XJxcvrmsRO64xD8cLcMxDt7xlLAundg==
X-Received: by 2002:a17:903:492:b0:1b0:4727:69d4 with SMTP id jj18-20020a170903049200b001b0472769d4mr381833plb.54.1686359647368;
        Fri, 09 Jun 2023 18:14:07 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001a4fecf79e4sm3842314plh.49.2023.06.09.18.14.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 18:14:06 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230609-a490dc451a2b45a60dbe9e13@orel>
Date: Fri, 9 Jun 2023 18:13:55 -0700
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A6D2DF32-8129-4955-943B-C9FBBA767196@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
 <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
 <20230609-2ef801d526b6f0256720cf24@orel>
 <32f41722-2941-55b5-d11b-200e43319c8e@arm.com>
 <20230609-a490dc451a2b45a60dbe9e13@orel>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 9, 2023, at 7:31 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
> On Fri, Jun 09, 2023 at 03:06:36PM +0100, Nikos Nikoleris wrote:
>> On 09/06/2023 08:21, Andrew Jones wrote:
>>> On Thu, Jun 08, 2023 at 10:24:11AM -0700, Nadav Amit wrote:
>>>>=20
>>>>=20
>>>>> On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>=20
>>>>>=20
>>>>> On May 30, 2023, at 9:09 AM, Nikos Nikoleris =
<nikos.nikoleris@arm.com> wrote:
>>>>>=20
>>>>>>=20
>>>>>> +static void uart0_init_acpi(void)
>>>>>> +{
>>>>>> + struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
>>>>>> +
>>>>>> + assert_msg(spcr, "Unable to find ACPI SPCR");
>>>>>> + uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
>>>>>> +}
>>>>>=20
>>>>> Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
>>>>> address and bit_width as bit-width?
>>>>>=20
>>>>> I would appreciate it, since it would help my setup.
>>>>>=20
>>>>=20
>>>> Ugh - typo, 8 as bit-width for the fallback (ioremap with these =
parameters to
>>>> make my request clear).
>>>>=20
>>>=20
>>> That sounds reasonable to me. Nikos, can you send a fixup! patch? =
I'll
>>> squash it in.
>>>=20
>>=20
>> I am not against this idea, but it's not something that we do when we =
setup
>> the uart through FDT. Should ACPI behave differently? Is this really =
a
>> fixup? Either ACPI will setup things differently or we'll change the =
FDT and
>> ACPI path.
>=20
> Yeah, you're right. It's not really a fixup and I forgot that we abort
> when the DT doesn't have a uart node too. Let's leave this as is for =
now.
> We can do a follow patch which adds a config that says "use the early
> uart and don't bother looking for another" which we'd apply to both =
ACPI
> and DT.

Ok. I=E2=80=99ll add some option later to force it, perhaps if =
UART_EARLY_BASE is
different than the default.

