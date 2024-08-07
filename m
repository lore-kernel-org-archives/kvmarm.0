Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9DE15099D
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723069362; cv=none; b=NQYao9EcueGe7We+Hk2MkFIugPxOC0Q9hl2OsD9bvsKkqn3pdNb7FXDhIwOaVGECyngBqGBBD9U7E30rLIYH2o4QCI7zjbHZjbh/brD8sHm3CURPqZbb+dsn52Mbwx4RbCQ4qT1ag+HThJOYtCX/ryKRqjQYcSCZINbwtle3ZNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723069362; c=relaxed/simple;
	bh=3btizCSSAKzA1J+IVvS5w27hk1nP/wRY5h7VZDI2y8c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ABfa6z+oPVc/bw6a1BFGx3VTfLAXvIFWp5/OMrGRrGLI5zpV7PgQjSJXiTOy8VDrx5mP7pzH3+nIaPsSG2rcpQ1Pe3s1ZGIGuiMnATsstjlQWn7UPY3NboAH4jUciMAkMR95JtuKeaDJawRL+YgPezNnqe/lS0icup9aq37O5lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d00WP9wD; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d00WP9wD"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70d2b921cdfso359400b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723069360; x=1723674160; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZVO8jPYcIWWyL3ex1mes3d5ZlFCIJ9T4CxX0DBumqo=;
        b=d00WP9wDhL+Mc5+AECLAaIHfwnwwQij15gYnZ7XIYhVSelaTH8OUICZEI+J6sklAxx
         NrcBeNUGTJTlkKRgBj0mtkENYgfdGxAY5PBu98r2+Vu7KTKd0K8eImQOEBRWy8oehBnT
         7h1azu9S9nW01y0UKkok6SfZJ/Bulyzf4ybBlYoosMloCb+cf2DHHde3X9YdulSYYofy
         trzbOtBTKBtY0e8ijlfzlwTO4YtGWxSDPELeuqtesWUT1O/8EUaT2J9zlWtfRe/A4O+P
         YteaqpCHQEVLOfkKX+EoMhVOxxgT2z4hCRS5h6xWkfyShNrwuQdODJViX14E04u4LA7v
         QHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723069360; x=1723674160;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZVO8jPYcIWWyL3ex1mes3d5ZlFCIJ9T4CxX0DBumqo=;
        b=pMpbN3AT3tQWd3QF3pVqXpNdb1WesgK4WoWE859lP2Jr7dIX6kfXkSGjkmrjnWcw4+
         hHS4dJugV1t1Sj22USu/hewBXdIrnRla/a9hQlv7dcN12dMJUaaXLmkXa6w8xoOxMEK1
         wE1BTT+o2sqT6N6N5n5wQwMmqlKaGq8WdUoubEC8m3xNj1g+4SXo9sbDDaOAhj3wyX3c
         RvrLwBvgONg3WdCEcR6SGYDlSyK6krK5uqA7o9fVqhI8Z4Pd/fmA/u1DL8ZXbxhrZiKV
         7jdvVRaX4RgCpKNn8JhswMr6uaCGTIBqAHvw2t+/6NBHckziDPTzgoRDjQS8seEBrIF+
         2nlg==
X-Forwarded-Encrypted: i=1; AJvYcCVeyj3jclU8ThZQ+MaludUi3LvAIveABYLN5//2mK7/0OoorOKMYELpNNk4rJnmGC9SjBF7NmY1DiiyJsq9L4ZTNL+aCyIL
X-Gm-Message-State: AOJu0YxVuO/Lk+9JzhAOHzQfMUuovIcMxgUM3JNNn4M0of64yzMkVVd2
	iMixpraSMR0LBzl0P5GbHsPUlgOkVkTIN1VI2WU96hGMGbTNLSBR5vHrUUQga/o=
X-Google-Smtp-Source: AGHT+IH2Cc0g0B6ra70L5cg48YZJx7srHh+PqfLxpX9PDwnG8XSpUfpqxIf7dyUyWUuyhSQCs84ohw==
X-Received: by 2002:a05:6a00:1302:b0:6f8:e1c0:472f with SMTP id d2e1a72fcca58-710cad5a30emr137306b3a.8.1723069360049;
        Wed, 07 Aug 2024 15:22:40 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb228d37sm5911b3a.46.2024.08.07.15.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:22:39 -0700 (PDT)
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
Subject: Re: [PATCH v10 27/40] kselftest/arm64: Verify the GCS hwcap
In-Reply-To: <20240801-arm64-gcs-v10-27-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:06:54 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-27-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:22:37 -0300
Message-ID: <87zfpodlci.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hello,

Mark Brown <broonie@kernel.org> writes:

> Add coverage of the GCS hwcap to the hwcap selftest, using a read of
> GCSPR_EL0 to generate SIGILL without having to worry about enabling GCS.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/abi/hwcap.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

The hwcap test passes on my FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
