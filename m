Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F84158D84
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720533912; cv=none; b=WbcA+subuANV7u6fSLdancjJ2K83neZ7ix2QDr4P9jBIQRwyfS5jZP0KgX4nohb+emEQRXXv4we4HZxHaeQLShJbvqRDfuzc90uk6GgtrCyfw1hY1664/2/g6u/oqLJxdr59wLYt4KjTpF8MsVFBn2e6u6xbOjfN26nLuZ2JPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720533912; c=relaxed/simple;
	bh=V8w+WduDjYMbi0xF1AXf4foyhxK/Tys6Ftz1gy0oyc0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KEwy4Xyyl8E68Zr39xfViZeNdm12NDK7OZr0vIRf2DwJAo4Dm/Fsac3TZyVxbAxiOOThv9ZUSS9eKY8dvlKO3W4u61r2nou2mYGD23iTUMuUPB7z2tAUuuVfOyRqpTn5S/JRTcrsn9pR6O+CIMYZDYwDja6zog39wvL0+ejZ5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yYeDp+lb; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yYeDp+lb"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-595850e7e11so611001a12.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Jul 2024 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720533909; x=1721138709; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFnTUzpKhBIUCroDn1g1yjbNPSRiA5x35lp/BspUfsQ=;
        b=yYeDp+lb7qp4Q1I3WyTu3I7Z7Rn7QhqD04aB8Ahu0/pcyyGa4/SVmI84iHN5DBxiym
         X6h4xgn81H+4PbLDDm5j81fq2F/fCdHMoigOjKEC08wuMDwwt4MnHWvXn71MA+39SN1b
         UAHQ+CFr+uUYWZSoQ+eyyBAPodpN3PK+4aeOC2A+kFtOBrhZ7C+jO4Gkw363YmE6bjhI
         kwpSgEFovPl+1lOHLrPIgyiyRO9JhHtmN8nD/SJRQZQSNZRAW09OKZdzfRBM/tRFyk1/
         IsCkdmQYLPR5ZC4OP/oXzG8nVqkqhwzU/icOoSF8CJKQLCgqU3yqnF7zOCa2S9oQYU99
         KPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720533909; x=1721138709;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFnTUzpKhBIUCroDn1g1yjbNPSRiA5x35lp/BspUfsQ=;
        b=UOHTigmlwu3lKGpMZkzjRvrKLisdvJofguknRlHXGTFkOeCwBiz4C415FhgmlEZI7H
         0ust9lCx3S0nW9gQ/GZeNys0JMX04up2cGmUNuSiPfa5CVfjnBZxFoDifTBRkccJQHQW
         0FoH2SeLOOqLIXOYkEwXq6EdmOySNRniOTHnmxaJMuUZFjkE/HyN2Hl8mhVVPF56GmIg
         rCvDcIjisHKWTNRCYusWmmqTllIEHlLglsXF4zw8sXrHyGn59iN59BzVdodXpF0O14mI
         /MORr2gtqX4NCXtPBPhJAPSH7mZ/HUOZCs+ZxU15EczgjtYvWbhP5Mmk7wylWLs0jiOA
         MBCw==
X-Forwarded-Encrypted: i=1; AJvYcCV8It4lMkJn4xThWz0uobk1eWhR6HOonPn3ldKbxhKG7qpxrcX2ZNiXChrvHjOVAztN1EsVOlw+8W7l7CId4eOaSsiEIoQ5
X-Gm-Message-State: AOJu0YycQ6Y6XXrTIGYvGV48viAIMgAHWWl74lm9zKENnAm84vz0/U7S
	KKYn0zorcxKTwJ4hSF6M8Mq9TfA/IUebAA+7GL/Mx188ko4wo8qTDvd8wdIaJSc=
X-Google-Smtp-Source: AGHT+IE+Zmggc07hsVlPoxEDJ5GRtNGB1wyrmyRK/TXjRJdHi8hOElRGk0h0SF/eAxRWxky1RxL6mQ==
X-Received: by 2002:aa7:c45a:0:b0:58b:12bd:69c8 with SMTP id 4fb4d7f45d1cf-594bbe2ba49mr1526124a12.36.1720533908642;
        Tue, 09 Jul 2024 07:05:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bda308d7sm1088890a12.91.2024.07.09.07.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 07:05:08 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4247C5F8D7;
	Tue,  9 Jul 2024 15:05:07 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,  pbonzini@redhat.com,
  drjones@redhat.com,  thuth@redhat.com,  kvm@vger.kernel.org,
  qemu-arm@nongnu.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.cs.columbia.edu,  christoffer.dall@arm.com,  maz@kernel.org,
  Anders Roxell <anders.roxell@linaro.org>,  Andrew Jones
 <andrew.jones@linux.dev>,  Eric Auger <eric.auger@redhat.com>,  "open
 list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU
 introspection test if missing
In-Reply-To: <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
	(Peter Maydell's message of "Tue, 9 Jul 2024 10:33:28 +0100")
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
	<20240702163515.1964784-2-alex.bennee@linaro.org>
	<Zoz7sQNoC9ePXH7w@arm.com>
	<CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
Date: Tue, 09 Jul 2024 15:05:07 +0100
Message-ID: <87ed82slt8.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Peter Maydell <peter.maydell@linaro.org> writes:

> On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> =
wrote:
>>
>> Hi,
>>
>> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Benn=C3=A9e wrote:
>> > The test for number of events is not a substitute for properly
>> > checking the feature register. Fix the define and skip if PMUv3 is not
>> > available on the system. This includes emulator such as QEMU which
>> > don't implement PMU counters as a matter of policy.
>> >
>> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> > Cc: Anders Roxell <anders.roxell@linaro.org>
>> > ---
>> >  arm/pmu.c | 7 ++++++-
>> >  1 file changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arm/pmu.c b/arm/pmu.c
>> > index 9ff7a301..66163a40 100644
>> > --- a/arm/pmu.c
>> > +++ b/arm/pmu.c
>> > @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_=
at_64bits) {}
>> >  #define ID_AA64DFR0_PERFMON_MASK  0xf
>> >
>> >  #define ID_DFR0_PMU_NOTIMPL  0b0000
>> > -#define ID_DFR0_PMU_V3               0b0001
>> > +#define ID_DFR0_PMU_V3               0b0011
>> >  #define ID_DFR0_PMU_V3_8_1   0b0100
>> >  #define ID_DFR0_PMU_V3_8_4   0b0101
>> >  #define ID_DFR0_PMU_V3_8_5   0b0110
>> > @@ -286,6 +286,11 @@ static void test_event_introspection(void)
>> >               return;
>> >       }
>> >
>> > +     if (pmu.version < ID_DFR0_PMU_V3) {
>> > +             report_skip("PMUv3 extensions not supported, skip ...");
>> > +             return;
>> > +     }
>> > +
>>
>> I don't get this patch - test_event_introspection() is only run on 64bit=
. On
>> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
>> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fai=
ls if
>> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result=
, if
>> test_event_introspection() is executed, then a PMUv3 is present.
>>
>> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than =
the cycle
>> counter)?

The other option I have is this:

--8<---------------cut here---------------start------------->8---
arm/pmu: event-introspection needs icount for TCG

The TCG accelerator will report a PMU (unless explicitly disabled with
-cpu foo,pmu=3Doff) however not all events are available unless you run
under icount. Fix this by splitting the test into a kvm and tcg
version.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

1 file changed, 8 insertions(+)
arm/unittests.cfg | 8 ++++++++

modified   arm/unittests.cfg
@@ -52,8 +52,16 @@ extra_params =3D -append 'cycle-counter 0'
 file =3D pmu.flat
 groups =3D pmu
 arch =3D arm64
+accel =3D kvm
 extra_params =3D -append 'pmu-event-introspection'
=20
+[pmu-event-introspection-icount]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+accel =3D tcg
+extra_params =3D -icount shift=3D1 -append 'pmu-event-introspection'
+
 [pmu-event-counter-config]
 file =3D pmu.flat
 groups =3D pmu
--8<---------------cut here---------------end--------------->8---

which just punts icount on TCG to its own test (note there are commented
out versions further down the unitests.cfg file)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
