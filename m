Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4884EB46
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060938; cv=none; b=TInv/DDmhUxrJ0PSwYR720X9OTpZV9O7x29U5PRnwFPNLWBICj7UAp5/dRRVU7hkWs/VbWZPkZ12/uUVvlw/WQZCyIe0Wr03+Zunw5neWQms3JWcCtLEYjSt+F59wAB5UqiGtdSLcyr8q17/n5FbyBWwt6brl8A0kvIxTwmCH2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060938; c=relaxed/simple;
	bh=73wabGAltLGPlrbwx5dEuZuw5LGsvnG/XNxCGcyGdEc=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 MIME-Version:Content-Type; b=gna6m68UAgcL4+xBrmPviIMde78BGAVijrbtj7VdwOm/w1154yjMAUEypc2sgImFSUrDwgQ3/RpTeIISEaRWVeBjkVCw1OUQZQPsAAj4VKF3ukOWzce1iWn0I40l+CWq38q0Q3Aj+NyhgsJgCsNInlYA9utX/4Z/s6i29bB7t5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wQo+ho1D; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wQo+ho1D"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6da4a923b1bso3685101b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 11:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709060937; x=1709665737; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=aDa40DJKClW8mXYqnyP7bggV377JTuxgqEkMOwvAuyk=;
        b=wQo+ho1DIaxvQQlUKOjHB0MOUnMXNWUM3gvQbvjqC45kf9C+2bZRf8lkgOK0BOpX4P
         TCA68EUnHKl8ZbNJaARVnYQHuSrFLRJ9c49iHNtS+HdpMtYwg8ZBRk7Z9S+GtzXQ9mki
         lXwWv9Uw3oFB0Dg5g9NDlCk23xBQhaIkp1Q61yiVETnaGGWkK0DC+lCLgQCrVI+jeiiI
         Su6bEEnKq/E7ZzPaacyRHmSKeEIiAzDb1MrIsmGh68elwZld4vLmw/D47ClPMUEU33H/
         SG9fnp5LBaR2faavY64RmqiBImC6/K3tMedON8BIZClbylnwp8SfUCkoWUG18ND8rKz6
         CGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060937; x=1709665737;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDa40DJKClW8mXYqnyP7bggV377JTuxgqEkMOwvAuyk=;
        b=siqPd/25YbwvxdWsRw40OVrp4a21nJRkKq3ChdMjyvc6oiTQEBX5B5y20gj5DZMvY9
         BbSw5j6Da9qIlHql5mSr2a8VK2Gig0CpAuvZgqhys5ASgfgs+Gz5ee7x8jsITs/43TXB
         R96iJOqyS0sg3ByzIjvakXG5BcybSH70wbCuukKyGtFmm6xmNFwqtRFDsjMQsCeirkah
         F7wGw+g8FtJHsCouok8z0MTzKY5dQcbIbU4292cmeOiNKX6xSOkWsb1v5CO314FuHNtc
         gebs61IYNP4vzKd8j7MW11MwAbnLnyUxwiF8F4bs0gH2yJpzAqy2TmyqUoFUca/C91G2
         hAIw==
X-Forwarded-Encrypted: i=1; AJvYcCVdRsnBcaSUOXv0XnAvELzxCyRPzTu8oBw5njDnuM3Ti/IEo0ttGoHfiebY/oUirvEL614HL6UPJpjNG3jhjVhkIFv4jU5i
X-Gm-Message-State: AOJu0Yz5oWK8edGi+e99ch+GdB8WXa5wW9oqodlIuQp8B8dKJlm1yr8W
	hcGEQh8u/ze9k3HmlL636XweUygIDkLbFMvEcw7cJkwCTY4YHbEMRLt9AcGSxOY=
X-Google-Smtp-Source: AGHT+IGtXhFFwEJ+AgMWI6EdwH6IahppDs+nYPC080WdpMAQ57X/AOuTkrytFfwmna6ljKJ3aYPMfQ==
X-Received: by 2002:a62:aa0c:0:b0:6e5:54a6:5a9c with SMTP id e12-20020a62aa0c000000b006e554a65a9cmr1287142pff.17.1709060936644;
        Tue, 27 Feb 2024 11:08:56 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:d617:f08f:e330:49c1])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm6713883pfl.98.2024.02.27.11.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 11:08:56 -0800 (PST)
References: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
 <20240203-arm64-gcs-v8-33-c9fec77673ef@kernel.org>
 <87sf1n7uea.fsf@linaro.org>
 <9b899b4e-7410-4c3b-967b-7794dac742e4@sirena.org.uk>
 <87ttlzsyro.fsf@linaro.org>
 <4adb0c7e-34a1-4c50-b011-6e31ef8813a7@sirena.org.uk>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v8 33/38] kselftest/arm64: Add a GCS test program built
 with the system libc
In-reply-to: <4adb0c7e-34a1-4c50-b011-6e31ef8813a7@sirena.org.uk>
Date: Tue, 27 Feb 2024 16:08:53 -0300
Message-ID: <87plwh912y.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> [[PGP Signed Part:Undecided]]
> On Thu, Feb 22, 2024 at 11:24:59PM -0300, Thiago Jung Bauermann wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> My rootfs is Ubuntu 22.04.3. In case it's useful, my kernel config is
>> here:
>
>> https://people.linaro.org/~thiago.bauermann/gcs/config-v6.8.0-rc2
>
> Does using defconfig make a difference for you?

No, I still get the same result with the defconfig.

-- 
Thiago
