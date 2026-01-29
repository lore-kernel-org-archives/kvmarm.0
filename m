Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5594F34D93C
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707788; cv=none; b=OBqE0KHpk9NEr3hdoRzQ74WCyPVo7wpc87S9yFfiAHNlTZ9M1UbaZlVriS+Xia6pe9okXpT7aTonIL/IwlDc6MKBErqF+GksmPuqSj4/eDovooGB5cOjYUZ+sDZaw3NWsxqNwCwugwVMEkO28m38UELRHSOtb502GpCQZnAazuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707788; c=relaxed/simple;
	bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EDDVQ062v2VILgQDux2vqgwkFL8lJWv5nAizMa0CqHlO/hENeVvl+eCPJLHNP34oNcoJrkfFFYooOu6l6emkbGZT+7E+ipE6xY7rJOfrSlA5InpMb26knU4oI2n1zagMaTyA40PFIOIZ35m7IHf4ZOpcFSaoFpG8V1ChFH+QNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qU0eG51L; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qU0eG51L"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4806d23e9f1so14181885e9.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 09:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769707785; x=1770312585; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
        b=qU0eG51LqPAPNg6qG8b2tK1MAeotogohoXq5fwny5Fa0Q6E0OfDfDoWoIrveu3vgCw
         p/zQMLXI/GW8UDgqv+ugZ9yjd02/olBYwwVoFb8uV3EULG0rRSMUUz6gQJ1VGWQXlPuz
         xxb2UkWrAqPIqAvpP/Wn6bBg4nNIintKHq2wYJ1dcXeYvOO/HXGZGpYNGUhrg4Acp8Zi
         CfmrUeknuiMkq172aiGeMQIU0FfifCSuYIIkZ3ArOarzZ2MSwBia54FpTgA8Q3pr5MMR
         W2/zGt5lF8obx4DYM6JvRS+m3FiGBdVEcQaROzx6sQym+jnqcDBSXfXZ8rlA8ZRJDTyy
         PAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769707785; x=1770312585;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=be866/Yp5BAQJMoBK98y8dBJLQ2gHvccZfOQ5Qw+jAY=;
        b=MuOJEMLmjjnuysxLupsNQPEy91MgaQnLp0IBIYnMopaSp0FRDOPGti0V4Cb4ROXAWq
         pOQo0sNtQWr8jjYAizFXS/gr3Cs6pUvrK16q9gPNcB1pesalV9u8DDwu83T54gAAuesE
         futwap4kbca4fSp1NwQvhGDUtolE8uKReNpeTHGgeycd4RvhzcnWE9GTZsQZorQ3n1eB
         G10XB408n+tVbupe2WDQDm5pRFTSiOS0ROuH4cdAz0/UN/BRaFoQs3kYxpARw8EsFACh
         LaKJPZZEWi5pkVX02vKFhaXRsK72dkKJ91C3x7PPkIOFwf6cd1AxeoRuviy9Hlb+YeF2
         dMdw==
X-Forwarded-Encrypted: i=1; AJvYcCVRGYbr+mulBo30L1Y1A2Fgp+G0pzkKvLaMJ+hBMrZJoyyJyVVUEpX8d8gT6Oc3Qi4Zo603fsw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzR0CAHf/sfcaoB7I7Q6IqExiSndfgvJ1B8XDfGi5JIDkpEWrzl
	UKsQnRfmc6TJM680jwIO8c4/SRULW1prFnDS5UfV7VWCvutOxNNFBlk3vcqZ/twf/WU=
X-Gm-Gg: AZuq6aKx37Y11YHQ9PG00nsfC8h2NC94Zg2h9jJmDKYh92HPJjB04X+9b7AZW48iEKD
	lQCy5wPYiKROx/dPhv3h/6MS352+LrpOLvcNG0e5WgSq927l7p0dUFJvq2TTM46st4uVnNXfRzX
	WSaU+S55DJZ/9WVHFn9lHC/EwiYWv/JHOcoJiSYUJFIkbMUtt52hKQ4fioltyJDZkd8s7u09ruw
	fGZpDAQ3mRFRaBFsxbRxg0wPGykxCj28dwV5Yno/pZC9b/+3i2/Bq+ecw/5OwtUBmgUlZz3o4Q5
	GFf1PGj1yjkGhkpY+8Obbt/OBwQiZyMPqsn8ut+eLDPsTOXSBa+9aMFhVdH9q7uKrcca0Qlyelv
	TqIazcEZgPl5aGqkjADUOnMdB4O+JCh6lUiqJenvtCPXi3mAfIa+DHGmcga0Y/GbEnAEcMdLaRs
	b8WswSfFHwdwc=
X-Received: by 2002:a05:600c:350b:b0:47a:935f:61a0 with SMTP id 5b1f17b1804b1-48069b9a017mr121874905e9.0.1769707784613;
        Thu, 29 Jan 2026 09:29:44 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482da8eba27sm66755e9.6.2026.01.29.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:29:43 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 067175F878;
	Thu, 29 Jan 2026 17:29:43 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
In-Reply-To: <76bf33a0-968d-4b99-a157-3eef076af69d@sirena.org.uk> (Mark
	Brown's message of "Thu, 29 Jan 2026 16:41:05 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
	<87343o8jay.fsf@draig.linaro.org>
	<76bf33a0-968d-4b99-a157-3eef076af69d@sirena.org.uk>
User-Agent: mu4e 1.14.0-pre1; emacs 30.1
Date: Thu, 29 Jan 2026 17:29:42 +0000
Message-ID: <87wm1072ex.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> On Thu, Jan 29, 2026 at 04:39:33PM +0000, Alex Benn=C3=A9e wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> > Currently when deciding if we need to save FFR when in streaming mode =
prior
>> > to EFI calls we check if FA64 is supported by the system. Since KVM gu=
est
>> > support will mean that FA64 might be enabled and disabled at runtime s=
witch
>> > to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
>> This is conflicting with the now merged 63de2b3859ba1 (arm64/efi: Remove
>> unneeded SVE/SME fallback preserve/store handling) so I think this patch
>> can now be dropped?
>
> Yes, this should go away in the next rebase.

Everything else applies cleanly though so thats good ;-)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
