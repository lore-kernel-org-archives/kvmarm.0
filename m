Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E4145A07
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 23:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721346475; cv=none; b=JwnTX44oCv89Hz3mPL3bWkTUBZRZlhqvUcrLEvl1sNwOPQ9rd/heTj7J+IbKUCnSXvSATAfg+CAj1/dtwMapooXXcuo3pwkDnmG5Clqm3HPaN1LfnXztW9Y3EXCxsbBorjyMJI0NQP078QGJaZQpOa2it2iPwaZzRxU9yOaJIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721346475; c=relaxed/simple;
	bh=47h5NGaRPMcJoe2hZvUn4CFZamjTK9bMbPmVK25pOdo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=J/wFIJh8z+FeuxBRmdbBgaHP/+dE6MyJatnDOX/VJs9HV0AXKSDzQlObSb0USItdTW9f4hgXldrkyqOX1E9aKP1SndWmujafZk1ly1plK+SNjKW2d1xU/nhd6s4V7OpTzPQew4hAMjc9H3ZHzoX2DSI/QfAoi7kTB5mWUPIT09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vMCu75iA; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vMCu75iA"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7039e4a4a03so746198a34.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 16:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721346473; x=1721951273; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9wG4uwlbaV+J8vLwBombRfMb1OG6U151ykySFE5AhqQ=;
        b=vMCu75iAV8TBmt7qLCxaIHNkXqnkwhGy/vcmyj359ONO2If/7XUzX1rT4dS1VhAdKr
         oTrbQK4+PW3ViRYGuWrz9yIWZ5gSs++GSBoTu2IWOjTekdyy1w3TSSvi2JXtaXhW6kzO
         JkeYMPqpvtuGwqCyainxitMkAGzagPAi2n1KW9K8d1+SdikKkvNUec6yj4xcK+G8ZtGZ
         khnNUneidurOvutkYGl8Umf1geHs/vBdbhCTrqomJlEMP+aCfdEgeOnov3wGG6WE8A5q
         26lq2hV697ium+pWt0N5ZxcrAmDbsjEXAGtsEmlButcBrLsCcPcsxqZmVsB8d5D2d6gr
         2hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721346473; x=1721951273;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wG4uwlbaV+J8vLwBombRfMb1OG6U151ykySFE5AhqQ=;
        b=lmiXJWJfHeHTco1aiSAAOPLyMSCat9kVhnyrn35EmJ26hen3QWA5RZC0DdWbZ4DmNK
         OyXvSmBB5FIcONfkrEd9J/byhO3HCredMTIie+TX7A6yVbyQoJXdzvTiyqzyhCva4jeF
         5jI7xIlpTKugCEYrZmPyNk95aoQ80KeDmyFGEw56Dez4kE60Pm2aRmdEbpwERgkeflLc
         cUL+x36S1qW3uNOBMlFDARDLtyVX6iXTfKDnBrV+p/UvpnuhAtJEqWidU41NY1zWxKhD
         cRVgkx1BXwdWbc2vKDp4FE8yt11rM9tyxK4fnNlTzIw9pNz063Z8MYoVlB13LfBMc9Uy
         VLnw==
X-Forwarded-Encrypted: i=1; AJvYcCV4ZUdYWma9PCjl51F+pqyzKHAJyanywwi1QnjB7w2UWQQ9a2JJad4jXG8CBVkDjDEkrx3qsF65UbaM7hWpa1rlyddVMaMm
X-Gm-Message-State: AOJu0Yzc2KJt1I660GpiLuL7pAZkX7TKsB3lKv6faZuxD7t1NgjvXPzn
	MtQ8qtTDkwYVs62bOke7ErHjc6aM9/SU7Vg9OkA1o36i8eGOh1Y1yysa40t7O60=
X-Google-Smtp-Source: AGHT+IGb5vwrvVRNc/Zru+u1tWaF5JoGONpNCNR6gfjZnBju8QrPRuYrwnUehHVlBaNSMasi1A3gpw==
X-Received: by 2002:a05:6830:700b:b0:702:1ea0:cfbb with SMTP id 46e09a7af769-708e37a48b4mr8654473a34.18.1721346472747;
        Thu, 18 Jul 2024 16:47:52 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:15c8:3512:f33c:2f80])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-79db5690a65sm142926a12.16.2024.07.18.16.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 16:47:52 -0700 (PDT)
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Andrew Morton
 <akpm@linux-foundation.org>,  Marc Zyngier <maz@kernel.org>,  Oliver Upton
 <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,  Suzuki K
 Poulose <suzuki.poulose@arm.com>,  Arnd Bergmann <arnd@arndb.de>,  Oleg
 Nesterov <oleg@redhat.com>,  Eric Biederman <ebiederm@xmission.com>,
  Shuah Khan <shuah@kernel.org>,  "Rick P. Edgecombe"
 <rick.p.edgecombe@intel.com>,  Deepak Gupta <debug@rivosinc.com>,  Ard
 Biesheuvel <ardb@kernel.org>,  Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
  Kees Cook <kees@kernel.org>,  "H.J. Lu" <hjl.tools@gmail.com>,  Paul
 Walmsley <paul.walmsley@sifive.com>,  Palmer Dabbelt <palmer@dabbelt.com>,
  Albert Ou <aou@eecs.berkeley.edu>,  Florian Weimer <fweimer@redhat.com>,
  Christian Brauner <brauner@kernel.org>,  Ross Burton
 <ross.burton@arm.com>,  linux-arm-kernel@lists.infradead.org,
  linux-doc@vger.kernel.org,  kvmarm@lists.linux.dev,
  linux-fsdevel@vger.kernel.org,  linux-arch@vger.kernel.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-riscv@lists.infradead.org
Subject: Re: [PATCH v9 38/39] kselftest/arm64: Add a GCS stress test
In-Reply-To: <875xt2xojp.fsf@linaro.org> (Thiago Jung Bauermann's message of
	"Thu, 18 Jul 2024 20:34:18 -0300")
References: <20240625-arm64-gcs-v9-0-0f634469b8f0@kernel.org>
	<20240625-arm64-gcs-v9-38-0f634469b8f0@kernel.org>
	<875xt2xojp.fsf@linaro.org>
Date: Thu, 18 Jul 2024 20:47:49 -0300
Message-ID: <871q3qxnx6.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Thiago Jung Bauermann <thiago.bauermann@linaro.org> writes:

> # # Finishing up...
> # # Thread-4030 exited with error code 255
> # not ok 1 Thread-4030
> # # Thread-4031 exited with error code 255
> # not ok 2 Thread-4031
> # # Thread-4032 exited with error code 255
> # not ok 3 Thread-4032
> # # Thread-4033 exited with error code 255
> # not ok 4 Thread-4033
> # # Thread-4034 exited with error code 255
> # not ok 5 Thread-4034
> # # Thread-4035 exited with error code 255
> # not ok 6 Thread-4035
> # # Thread-4036 exited with error code 255
> # not ok 7 Thread-4036
> # # Thread-4037 exited with error code 255
> # not ok 8 Thread-4037
> # # Thread-4038 exited with error code 255
> # not ok 9 Thread-4038
> # # Totals: pass:0 fail:9 xfail:0 xpass:0 skip:0 error:0
> ok 1 selftests: arm64: gcs-stress

Also, Shouldn't the test report "not ok" at the end considering that
there were fails?
-- 
Thiago
