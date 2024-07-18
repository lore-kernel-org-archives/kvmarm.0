Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6F5145FE3
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 23:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721345663; cv=none; b=l74sibV7KZ70p/xb7sJXiVG6r5oq5GTEcc2UfCUFn2uLutnBtJsFFz/a0cv2J7V7fU7Z+ZEjBwkvkMWJF6WM4VKWL5zZCT3yfEBtv0h8uxT++zdJxXPODYQxPMkKb1uN6IDTgg4Iujm5EqMefgXYP9dEn/TlyYqEIEgToxdtuyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721345663; c=relaxed/simple;
	bh=Uy508/sq/1r69twOonqkXxOzsVEWpYS/wUjciXNylJA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YK3wOOLY8yTMw94s3iHcynLB2oN3NUqFu5YppoMfrfLRrRDbMEHre1x7n7geX3EvbwLHEvjBNC7j1DCNUYeLkhIfUllljLxdI8P1K+RQ39zhr3GeL4htfw9ucyAprKsDUYTmmTfHIsvUFfHJJFdEaKdLpN4lGUy4Wjrv7pw2nLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rtG+Fk7z; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rtG+Fk7z"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-71871d5e087so1007253a12.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 16:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721345661; x=1721950461; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/qF+1IDJjtH4yt3+dIXZUb/sL6BCvMKOBa4IWo3wL00=;
        b=rtG+Fk7zJQfu+TjnC4IwK/ftBtVFGxy1yDQuhWb8Ak3e9QOJQksq4hlWxLxLO4ExYP
         NqRQeful6HGVatnKTN7b7sW2xDXWbPo6A/wmpKytxfXXkgBA6/BJlR+7U7LKnWL199jk
         086EGgBY9BUw8nnLDBAJsghB+BkGFtQOgND2iR45QiOGJi7AzQKAW2ERpj752/B9+zuQ
         UlZ2mervip+j0w8WWphHZ7wRrpn5fQLa//IplLrOQ/k3rBbSGsVEsbG0v55/D55deYao
         KRuX3ClR/MGUCfdZLTBPIqWerUgdefek9zgfF9haUvGfCWpCQdoXnrYoIlcHhaMH6GRP
         FGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721345661; x=1721950461;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/qF+1IDJjtH4yt3+dIXZUb/sL6BCvMKOBa4IWo3wL00=;
        b=FE4+irJjiMHCuMyAOJ353wN9eqSEM0c5ZJEl4jBPRQVa1HMfzkCHMavAc7sKzYk6Yn
         wD/8g5aFTwGgSZe9QC3vH5PkLD1if5iHTPr/cg/bwEsmRg7g4EfDSTT2k2TSO28tLYrR
         BoMzuz5f/We9mIHRGRBt+AtCnUeJ0qvxk9zTlJn7a6FdGRbMESwHf5ilED/3rVs3m/n+
         F4hAvbkA7f+ZB2YOSc+r+XALUOrsLnATNSxJgl+2sgYuC4ndELphzw9AB1A87SB/1GZx
         +qKcUZJuq9+8vXxYrxAD6h6X7eVBTVfnKmXUzv7sLkt0Y8Rtbf4lcwnljnYtBYkiajOw
         CoRg==
X-Forwarded-Encrypted: i=1; AJvYcCV5PYlw2yg3pUCwVhBodCkpqbItiTXHgKYewFtyrvgm8qjxIAq188uwC2BWtBQ4l3RdMp2qfOn0My6q40FXxEL83Mbznm6Z
X-Gm-Message-State: AOJu0Yxq9wqToRsVh6Q0JxOxJ1g8lpkne9uyGDNYpIpwLDFSHbBYGbpg
	heS4I4U2GPsT/tl29b+3sr57rcsNXblUoFoIeAbcHTnJzM3KM25TLviui1zja6w=
X-Google-Smtp-Source: AGHT+IEKbX/FsbhFnIw71MBLVcrzrP5T77uZDA6cQicktN0+nhvg+Wct/m4wkCJiaiaT9dRkb2DrPg==
X-Received: by 2002:a05:6a20:918c:b0:1c3:a411:dc45 with SMTP id adf61e73a8af0-1c3fdd6b4e7mr7804327637.39.1721345661197;
        Thu, 18 Jul 2024 16:34:21 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:15c8:3512:f33c:2f80])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf7c72075sm199845a91.28.2024.07.18.16.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 16:34:20 -0700 (PDT)
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
In-Reply-To: <20240625-arm64-gcs-v9-38-0f634469b8f0@kernel.org> (Mark Brown's
	message of "Tue, 25 Jun 2024 15:58:06 +0100")
References: <20240625-arm64-gcs-v9-0-0f634469b8f0@kernel.org>
	<20240625-arm64-gcs-v9-38-0f634469b8f0@kernel.org>
Date: Thu, 18 Jul 2024 20:34:18 -0300
Message-ID: <875xt2xojp.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> Add a stress test which runs one more process than we have CPUs spinning
> through a very recursive function with frequent syscalls immediately prior
> to return and signals being injected every 100ms. The goal is to flag up
> any scheduling related issues, for example failure to ensure that barriers
> are inserted when moving a GCS using task to another CPU. The test runs f=
or
> a configurable amount of time, defaulting to 10 seconds.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/gcs/.gitignore       |   2 +
>  tools/testing/selftests/arm64/gcs/Makefile         |   6 +-
>  tools/testing/selftests/arm64/gcs/asm-offsets.h    |   0
>  .../selftests/arm64/gcs/gcs-stress-thread.S        | 311 ++++++++++++
>  tools/testing/selftests/arm64/gcs/gcs-stress.c     | 532 +++++++++++++++=
++++++
>  5 files changed, 850 insertions(+), 1 deletion(-)

This test fails for me, even without THP:

$ sudo ./run_kselftest.sh -t arm64:gcs-stress
TAP version 13
1..1
# timeout set to 45
# selftests: arm64: gcs-stress
# TAP version 13
# 1..9
# # 8 CPUs, 9 GCS threads
# # Will run for 10s
# # Started Thread-4030
# # Started Thread-4031
# # Started Thread-4032
# # Started Thread-4033
# # Started Thread-4034
# # Started Thread-4035
# # Started Thread-4036
# # Started Thread-4037
# # Started Thread-4038
# # Waiting for 9 children
# # Waiting for 9 children
# # Thread-4030: Failed to enable GCS
# # Thread-4031: Failed to enable GCS
# # Thread-4032: Failed to enable GCS
# # Thread-4033: Failed to enable GCS
# # Thread-4034: Failed to enable GCS
# # Thread-4035: Failed to enable GCS
# # Thread-4036: Failed to enable GCS
# # Thread-4038: Failed to enable GCS
# # Thread-4037: Failed to enable GCS
# # Sending signals, timeout remaining: 10000ms
# # Sending signals, timeout remaining: 9900ms
    =E2=8B=AE
# # Sending signals, timeout remaining: 200ms
# # Sending signals, timeout remaining: 100ms
# # Finishing up...
# # Thread-4030 exited with error code 255
# not ok 1 Thread-4030
# # Thread-4031 exited with error code 255
# not ok 2 Thread-4031
# # Thread-4032 exited with error code 255
# not ok 3 Thread-4032
# # Thread-4033 exited with error code 255
# not ok 4 Thread-4033
# # Thread-4034 exited with error code 255
# not ok 5 Thread-4034
# # Thread-4035 exited with error code 255
# not ok 6 Thread-4035
# # Thread-4036 exited with error code 255
# not ok 7 Thread-4036
# # Thread-4037 exited with error code 255
# not ok 8 Thread-4037
# # Thread-4038 exited with error code 255
# not ok 9 Thread-4038
# # Totals: pass:0 fail:9 xfail:0 xpass:0 skip:0 error:0
ok 1 selftests: arm64: gcs-stress

--=20
Thiago
