Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B592B1487CC
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723070198; cv=none; b=oKcZRtP5tGXC8sk8RCn1R8ByfLwVZCZumvPmR3PSCz5HzLPSdG8cTa/4OjOX5c7wz/DttWMasjwa2nRXtIvKPRoxZpgKyuou/kMqJvUjuomScJY9KlyI+g8bvr2WFEHfS7KYnw2Or3XNkYlaUZ7quloKdIaRycoUsZrjLKZJDpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723070198; c=relaxed/simple;
	bh=a82BazRTsLV8O545SUtLHexI80RAcukz/terjjLKadM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=quABa19DZnKExu250W/B6jN8KIv2gOYCK7EoGp7+mx+BiLCx8sfh70eCIBgzEhbvx4RUvIG2tfdB7iVgLhCR1VVbVCPfMB30zZ6MZEn1MdKj6nFEqtApjUFvj4JZPlYCgl4pEtvlCHcwRrutQOa/i4+klGWsaAVX8O9n0rYI78s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VyRwF3kv; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VyRwF3kv"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7093705c708so347276a34.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723070195; x=1723674995; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5xqVBE75uTakMohQNNM+Ob3mwTWILCE117tt64StnA=;
        b=VyRwF3kvfhml4WGI6XZGqOoG2oTP1XF4Bvl6sR4scl4sxAd8CigdegRsMnlwooIId5
         vRkvlUXPk6TLAA5Q6KxmnzPH6G4XnK4kfNRxr/2Sh5jwGDZsH5a9yKvacyZ2Cu7vxp5q
         FD3o8JIJHuqFVK3qjFQiQSFa+W+nxVc7YoprkNf5PPG6tpCPCMdXg/07AOR+YxB3i7Sk
         5r/k1XelMXU7RBB1yq3sPLhMd4hgPZfi9hwBFhhVfGSTeNNTg6kiQyIW0yTit7yQK1/9
         APxs0Jg27eUv0hcJnVQzaZE6twwxKxPsPJFbmxmjMpFe/7o2l6UqbtOdcKqxsABUbOKD
         wQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723070195; x=1723674995;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5xqVBE75uTakMohQNNM+Ob3mwTWILCE117tt64StnA=;
        b=CejGg6IwWpktNqgmS+K3AiYziLjW84z/haU3kdErd3MHFyYTq7gyvFAGrObuIEq8sK
         XUlbkX/4GBvGg8w4AT4Oj4Qew54b0fdj/ohwXPIeq24ma18RUhsr0ahu88owxD4Y6GUl
         bO5PIWfdD2tiqZQWmRZ9Gwaiueoss9slFms2H9qGMo+VC7feMITzZL2KBrImPvwdkqAY
         98QdEzZ/TI8Y0mBA6cKpqRIEwiOi6ZiwxukoOskvQKamQV+j+kieYicP1ffaEuNJSxLb
         JI06XlVoMWPXHHRB9UCLLR8ujShNelg1X5vfjjKen3QfT2Ff+BrPC5jd5gzbhI6lgovW
         WzuA==
X-Forwarded-Encrypted: i=1; AJvYcCXDjNVZmzUtzIXbwMj3SnVqIQlhJGW5U1jZikH9JzSN4L3kkpa1aB39hL3pylOYZo3LiWFwU9AqAwd0Wsl8gB7Abn3qiGgk
X-Gm-Message-State: AOJu0YwupTzHnfZetVsWsFfJb/bTgJbUvTeAJ9BFuGNyPXnG43elJJHR
	mJa4aQ5foB9Qw46RUzVTAjXh0COYe7Zf5dw1k93EBZjnXRscaI/UyI2ox5A2HsQ=
X-Google-Smtp-Source: AGHT+IGTBDVQAm3GArH3otwegCgx4BHN1ZL2N8yxYA8F/kedHOZ4Afd+CPHaShh6RvNkbAtiESu5bQ==
X-Received: by 2002:a05:6358:70c1:b0:1aa:b860:f10e with SMTP id e5c5f4694b2df-1b15cf91432mr25702255d.15.1723070194758;
        Wed, 07 Aug 2024 15:36:34 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7b7654be293sm7403332a12.91.2024.08.07.15.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:36:34 -0700 (PDT)
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
Subject: Re: [PATCH v10 37/40] kselftest/arm64: Add GCS signal tests
In-Reply-To: <20240801-arm64-gcs-v10-37-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:07:04 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-37-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:36:31 -0300
Message-ID: <87bk24dkpc.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> Do some testing of the signal handling for GCS, checking that a GCS
> frame has the expected information in it and that the expected signals
> are delivered with invalid operations.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/signal/.gitignore    |  1 +
>  .../selftests/arm64/signal/test_signals_utils.h    | 10 +++
>  .../arm64/signal/testcases/gcs_exception_fault.c   | 62 +++++++++++++++
>  .../selftests/arm64/signal/testcases/gcs_frame.c   | 88 ++++++++++++++++++++++
>  .../arm64/signal/testcases/gcs_write_fault.c       | 67 ++++++++++++++++
>  5 files changed, 228 insertions(+)

The gcs_exception_fault, gcs_frame and gcs_write_fault tests pass on my
FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
