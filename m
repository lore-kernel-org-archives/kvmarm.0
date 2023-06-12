Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1A1DDF8
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 15:59:53 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b3c5389fa2so8814005ad.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 08:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686585593; x=1689177593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2me08iLiC6XwS+//ZtbN/tFK1hxSnmX2rBu9RUTLZE=;
        b=ON8sblzASTTO0L9SA0XYkgsRvCVpPWhzw8Gja+FZ6x0irF8PZd7T0aU6CGVbcLmwlt
         V8dMrM628wSMidxsj44ukrjjU4WPaukz7/1o2SO48sBnn6XItthszJoRRhNaqxU6H3zW
         PiWYz6zj79vi5TQBmkh5a5F4QqZn0b76GGaGReqpz+z7ktAOzuwxh20nhwFns8qeX/zF
         jRkXDr/J6yXFlAbzy+xHCnW6faWfbAXZv5ukw8EgXwzItGHdFirgnPfEHWAabxpimzTU
         ozp4pql64fSnrrpADeSulBGV87tC059S9JSNUwWD+Gt20AE7dajBi9JRgA+41CnDPEMj
         TzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686585593; x=1689177593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2me08iLiC6XwS+//ZtbN/tFK1hxSnmX2rBu9RUTLZE=;
        b=XFN/qnQe0F6Bb9rqZlERVhiPPvtizrOFUXb12WkDU9OwFrStu89buuJRF7nVYVf9xs
         +vxxHpLFK5KX4L6HJgOTbaMwOcyOX83X0wuEbcMoO8csl4uGUDURA9fjQdsP0kCupVoQ
         dzmasFeg1lHGur4T48nwPrhPzpZn21GnvFCULt8GfPkTTaNSGhew8eteWgGvrHg8pCrb
         0cKpbriUt/yD6S/C/DdUcmEMNIx6tn/99Fja8JWwib4KmTS0XVNjm9zJflf4/86iBIVi
         kW62QXNrhHV9Y//eWB667fmghJI140GZ2vGASXSpAwaWrnpV3/1Mv9LZcpz6TxirdWav
         NrsQ==
X-Gm-Message-State: AC+VfDz53BQK80jhmO5LDZaoCOOpogiHM8lJ5Qs5t9n4ZJ/oFZ7tfRoW
	kqz+JMJXsZau4WRmRS+l1Yw=
X-Google-Smtp-Source: ACHHUZ7EmtqzUQhh3Au1lL6u6ocYtXsqDFbxhA3BNW6Ps/j+IX4e9u4O7P6Md0Yk4jzLzYx7mJubEA==
X-Received: by 2002:a17:903:2301:b0:1b0:36ad:fe13 with SMTP id d1-20020a170903230100b001b036adfe13mr7998999plh.16.1686585592597;
        Mon, 12 Jun 2023 08:59:52 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001b045c9ababsm8422380plx.264.2023.06.12.08.59.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:59:52 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
Date: Mon, 12 Jun 2023 08:59:40 -0700
Cc: Andrew Jones <andrew.jones@linux.dev>,
 kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 12, 2023, at 2:52 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> On 12/06/2023 08:52, Andrew Jones wrote:
>> On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
>>>=20
>>>> On May 30, 2023, at 9:08 AM, Nikos Nikoleris =
<nikos.nikoleris@arm.com> wrote:
>>>>=20
>>>> Hello,
>>>>=20
>>>> This series adds initial support for building arm64 tests as EFI
>>>> apps and running them under QEMU. Much like x86_64, we import =
external
>>>> dependencies from gnu-efi and adapt them to work with types and =
other
>>>> assumptions from kvm-unit-tests. In addition, this series adds =
support
>>>> for enumerating parts of the system using ACPI.
>>>=20
>>> Just an issue I encountered, which I am not sure is arm64 specific:
>>>=20
>>> All the printf=E2=80=99s in efi_main() are before =
current_thread_info() is
>>> initialized (or even memset=E2=80=99d to zero, as done in =
setup_efi).
>>>=20
>>> But printf() calls puts() which checks if mmu_enabled(). And
>>> mmu_enabled() uses is_user() and current_thread_info()->cpu, both
>>> of which read uninitialized data from current_thread_info().
>>>=20
>>> IOW: Any printf in efi_main() can cause a crash.
>>>=20
>> Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi =
and
>> put a zero_range call, similar to the one in arm/cstart64.S which =
zero's
>> the thread-info area, in arm/efi/crt0-efi-aarch64.S?
>=20
> While I haven't run into any problems with this in this series, I had =
in a previous version and back then the solution was this patch:
>=20
> 993c37be - arm/arm64: Zero BSS and stack at startup
>=20
> So I agree we should drop the memset and call some macro like =
zero_range in arm/efi/crt0-efi-aarch64.S.
>=20
> Let me know if you want me to send a patch for this.

Thanks. I am still struggling to run the tests on my environment. Why =
the
heck frame-pointers are disabled on arm64? Perhaps I=E2=80=99ll send my =
patch to
enable them (and add one on exception handling).

Anyhow, I was wondering, since it was not clearly mentioned in the
cover-letter: which tests were run on what environment? Did they all =
pass
or are there still some open issues?

[ I ask for my enabling efforts. Not blaming or anything. ]

Thanks again for the hard work, Nikos (and Andrew).

