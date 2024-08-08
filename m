Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440EC186E43
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 06:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098328; cv=none; b=tcDJhBNqKb29StODytlmdIX00iidvBHpAlH4yNYgjcx4+CedrjH/qaVCzKbyzZpOFsStFZll7++taqkHxYD8ttcnBD3zQTPlLWQHu3W66UC/dPBhrFqtvQVyXdLOMc/Ze57Uuk99U2WqAS5sKMvR4j7KnHdPVAwp3lRYePUZgLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098328; c=relaxed/simple;
	bh=vLLuKNqR9XU5O+YIcehGr09FLrfxLy2W9TjakvRNxc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f5FY8zA7X5TjyyaNkaWcqIiSuZefGHxgV3IlApMgGpiw6XLjsgecT8eGlBg3NwwE3W+hMcY2lKxI4N4tSfMmLoYYCAR4W/7my2oD7Q7tKqnQ49nFPFoUjY5RsPT0wEvLN99xsRnm1Ic46ECl63Gvq18fWp/wH0ILAJRKtN0Nmvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NoivvhDV; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NoivvhDV"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d1bb65e906so496867a91.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 23:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723098326; x=1723703126; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=sJzbBpFNwwY6e+GIMU5iIyI4LLoSSqWXmhkhActO1pM=;
        b=NoivvhDVFfFL99PoFbTL0GThrxJdrbN0h1pWx3R3LsRmlnKoX3ebsGEAR6P1hrw2Iz
         VvZaCoTffE90hz8iD2/WaFCw6hZbwOtgZ9yYJEhh9/kigLSMhal/XkC9n8kW2kqNOcid
         AopTncGMsQCMlhJMu5W1F/JCzwlZ1sgit9Evkvn07WWFauQp/lqoNXqW4+gVQqs686hj
         t0YnnPjl0L5mlMGJuTNENUcr0rfWcZ0fNKymz76nyfcuX2BsmKmkLfGbH8smd49sJxkh
         6NScpfyUoDoBHaI7p3upWaa8ABBLggS3a8bifYMa8qx++zHLwv9d0uAm7oPQNJMCtznT
         GeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723098326; x=1723703126;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sJzbBpFNwwY6e+GIMU5iIyI4LLoSSqWXmhkhActO1pM=;
        b=TG70g1QlK0NYxy/luWQeCE/uW+VvdLZ/9pu1LHquio2R9u/R8eYV3x0VuKbwjzIPq9
         swCRFGZ1R0RI4f0D86dIH8sny+ilR46Q9HvspUgldBuYP3XFgE86XeMqsTUrplk+AqfY
         Q7zedDSp3oN3rPqkXe44LDU5mDc0Co2b723vyKDd/sIORhDtEIE56VzojMvObxYa8iXi
         bNCdKo7FD5udQwkBTd319e9JGBF4eJfdyqK+QUOq9EbF4k7+i1dF7xnQue8fzsTnRWng
         QbPZtSODh6HxJCKkrzZWdk71LPvEccCJ2iK9/5IRYX6i4wW6d9ZoCqzpTt2lIPJoEts+
         gtog==
X-Forwarded-Encrypted: i=1; AJvYcCUCAaQ71qtYwbUeSOUBxrdG2YCEI7Iw/59XKjOtL/QdccizR7sWRDhS7HExyA1sQuEJwb4kCiL11ctk1+AGfam1QSqzKUWf
X-Gm-Message-State: AOJu0YygM0fcQhA3zBDzYB6MFaCdicms5ylr3P/aa9EcbhpFnC0wW4Jf
	ykXZWVKWsSxQjs701djdGZdvE4rdjYPrbLN8KkVYon3W6A1HwFFTHak+vYFQJRY=
X-Google-Smtp-Source: AGHT+IG5Sh4RPZDFGIdFKwM0iRTPb/2nHrMhAgBHSqeUq3wn62Dbr5Jen5m7Eo7OeNMhWJA7SfHwfg==
X-Received: by 2002:a17:90b:4ac9:b0:2c4:dc63:96d7 with SMTP id 98e67ed59e1d1-2d1c349446emr921727a91.41.1723098326578;
        Wed, 07 Aug 2024 23:25:26 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:ed46:7c69:6cee:3c20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9db74a0sm328001a91.47.2024.08.07.23.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 23:25:26 -0700 (PDT)
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
Subject: Re: [PATCH v10 39/40] kselftest/arm64: Enable GCS for the FP stress
 tests
In-Reply-To: <20240801-arm64-gcs-v10-39-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:07:06 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-39-699e2bd2190b@kernel.org>
Date: Thu, 08 Aug 2024 03:25:23 -0300
Message-ID: <87v80bcyzw.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> While it's a bit off topic for them the floating point stress tests do give
> us some coverage of context thrashing cases, and also of active signal
> delivery separate to the relatively complicated framework in the actual
> signals tests. Have the tests enable GCS on startup, ignoring failures so
> they continue to work as before on systems without GCS.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/fp/assembler.h   | 15 +++++++++++++++
>  tools/testing/selftests/arm64/fp/fpsimd-test.S |  2 ++
>  tools/testing/selftests/arm64/fp/sve-test.S    |  2 ++
>  tools/testing/selftests/arm64/fp/za-test.S     |  2 ++
>  tools/testing/selftests/arm64/fp/zt-test.S     |  2 ++
>  5 files changed, 23 insertions(+)

The fpsimd, sve, za and zt tests don't find any errors on my FVP setup
when left running for a while:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
