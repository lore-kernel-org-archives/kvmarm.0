Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EA91487CC
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723069962; cv=none; b=Lyn6VI64TE6RimpyvS+ydMCBFgUfIv2GxnkOHkF88bMXZt3I1u02CCOX7UGhYz02DTYvN5H2nZxvF4NuVZyizYVjJxePXScbEXtcxUNXzvtOcdYdApkbG/QiO/doYMybyu+UU69iSxV57iS+XWDTzC0RQkrhyM1NkB/Zl8HDLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723069962; c=relaxed/simple;
	bh=IDNMT6o5KfwYfTY17255Evt0lbZnm4CnEGRfht11BXg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y3CiiLDj9P+H4dt5lzF9b4n+wqiruKbQyemDT2vX52ndDk0EFJgr+2Hzy9ycDh25PyeIauVcr5CPGRwFuNq1M2lAkdPfzZ64iIHuVw0EMNDRRi7HZtd6+QrjpjoISoAPIThbeRiGNhUUigoENXGRotu/B85s7vuC6ybQu7Lpru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hIbpf1i5; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hIbpf1i5"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cf93dc11c6so324265a91.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723069960; x=1723674760; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=d/17UOMKe5oLrCx17iNXp2TK19+E7NavssE5gQNb1UE=;
        b=hIbpf1i5ASNWOz5T8DgYLCRkX0Css8hAfZKSw0uikoa+8pF14lNfo4j4G1yh7RaCV/
         9BlD/h9R6tT1qNtgSyE5y0w9DTCDh9GHyR48OcdcMg3TQ/49S/N66LlIaZ1Xe4JjhDkA
         cqaOkGctMV5KFJq3uj0pNPFXc8DSjg7IdffInIkorXyqeMufmv9YjitCYsPqGmUxQYvu
         Ejnc0JjzsBTlf7fTEAejkDmyELb840Fa4Cgf97gLsrKWcnM7r43phraFf27FT4XkprkX
         5AKrJV4eeXMNETwnCXhBe1XPtZFit7i3Ldok/Oc22hUTsyk4PkzM4F5EoTexW+a+xKF4
         Sslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723069960; x=1723674760;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/17UOMKe5oLrCx17iNXp2TK19+E7NavssE5gQNb1UE=;
        b=nPa58b7KCGe2WKqg5xheW1uRtI7doT1ZaGZU+X95UpYPTPdYXfY0BKhDuPDJQs0yFB
         JJjsdqFoSR1SdrgqryK5SRnFRDd7t+/5MueNMb0Xi0Rs82iM89Gs5xM9BNx8F4XJ7Y7u
         SlIQlVLXw0c0oDu+dt6kwTHz2QqIpqPUVeDoOCnZLiKNW0y5SGNIPzxG5/s/iHLS0QPF
         6drqK5cHjISFkspwLaUJmWMfexh5OaEzOfMI60xsxamq2E7+3iPscu/LqIvFvItXj6DL
         NuMrV/8erJNEk+Qqsfannm7ebAidbwXEmQlT2r0Uo7WmbxOoMTA8cBltD48wyHwfMicK
         fHkg==
X-Forwarded-Encrypted: i=1; AJvYcCV0T0U4JFD4/kBfEcsF6uX72i3fY/uuF8YQA949/9uDJLOOxLEKlcdcgR9I5GGEtclM0ClwoQNt0im2KV+V1l7MiHKNI/yA
X-Gm-Message-State: AOJu0YyE5kacm4pwg1hQnUvRYVRKo6HZmmrYEiEnUz6O7ajAr+otjoz5
	O2jinSaq18YJxiOgGA+9AIy07/qPx7Qi2KrgHtK79H28SKD24x/YgDmVHnSH9gk=
X-Google-Smtp-Source: AGHT+IF6ltj6rd3uaMmAKqZ9lRxXF6GH8BM7xXm35nsHglv5MkLIzgBV5TQkDCcootMgdowWsa/ZAw==
X-Received: by 2002:a17:90b:1254:b0:2c9:96fc:ac52 with SMTP id 98e67ed59e1d1-2d1c347b2b5mr29119a91.26.1723069960420;
        Wed, 07 Aug 2024 15:32:40 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b3b5a39bsm2102276a91.50.2024.08.07.15.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:32:39 -0700 (PDT)
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
Subject: Re: [PATCH v10 35/40] kselftest/arm64: Add a GCS test program built
 with the system libc
In-Reply-To: <20240801-arm64-gcs-v10-35-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:07:02 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-35-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:32:38 -0300
Message-ID: <87jzgsdkvt.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> There are things like threads which nolibc struggles with which we want
> to add coverage for, and the ABI allows us to test most of these even if
> libc itself does not understand GCS so add a test application built
> using the system libc.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/gcs/.gitignore |   1 +
>  tools/testing/selftests/arm64/gcs/Makefile   |   4 +-
>  tools/testing/selftests/arm64/gcs/gcs-util.h |  10 +
>  tools/testing/selftests/arm64/gcs/libc-gcs.c | 736 +++++++++++++++++++++++++++
>  4 files changed, 750 insertions(+), 1 deletion(-)

The libc-gcs test passes on my FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
