Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F45A146A72
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723070056; cv=none; b=WGtZNCKtzSwV9EHw+/vhc7iEl7a/JkzimmCyCdsRa94QfQwYQyem76WF7UnV1bQog6cCQbFxW0yraaA/OJC7apn4cBrpqps8ioWGtBxYe1V7IgGUKPJh0BzLeBOtWHWetNgu/8fat/ptk408HKYc1/UheG9mVKwkSVDWhbgxOzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723070056; c=relaxed/simple;
	bh=Hnvwb4GsJ5xhBtc2iD024XC8qkygckvf+U3nq/Qf0EA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pQIIKHtwVRUIyhgJzJFFD9jE0/7T+/VnCPNa3NWY614sygQ/q8F5hk71Y1rYia8O93uCtGPXBGvn1bi6dKTlQpGHFzLAD1J8cSKT1lUkIJGbjjwEKJqd4RkYddU3cFJVahLmT8pGcEgqGrNXfUAZ657oJ3NakPwutQFSTlODYrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iipYWHqx; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iipYWHqx"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-75a6c290528so257055a12.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723070054; x=1723674854; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lfrHG1WH6erSaIaipwT8ciCPWYlneUqYmls1urpaYsI=;
        b=iipYWHqx3v/Vf2uFolEjJ/w/ozSV3TyEc+xORseZ5OrkCaMxHCRyseOEgf06kVvZnT
         DW3YkE+G+GzNZ5jMgv+UQhmyrvpm51bP/PZJtKSjzoUKbTw4DmYz18PFqbKR4DgqIAx6
         BGp2t6PE+N1HvVKvc6b+dQCuAcxxmHUWDebvUzpZD7KdtOClH5qb6E3O69hKlO4trj9P
         wMxOjqvJ+mdFxXQFBkWxJGz/VCbIUIa/7qDkkvUQ5HruNNB+iZb7PBfl7AF0hRUeD3pg
         O9nEmBNn5RfNdWclz9kM8iAW15R6em/Nu3kaMI60M62BV6ftwQt6IjjVqOzUB3bogrGk
         M9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723070054; x=1723674854;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfrHG1WH6erSaIaipwT8ciCPWYlneUqYmls1urpaYsI=;
        b=Rac3b7MX1gaykBLxAXch1c4LXQKRRr3WjiYeZ6JLh79BWuBt04kqYmmIorTeONlD3B
         ZQjJQyqycg1w4EmmC7ICdrEG9dL12fZ2IcE68+0r/v4xqULZha/DczIXLA80uF3Rcfnl
         NTZY+x+2mext7g9pqN/WCLuQj7iKDnd+qrJV/DxzxIqQEI82YiHWQntjorwtiplqW7Rr
         P1+8T6K0k+7k3yf0B0/8fxuRPn3PrMsZ2LYPbfEQN6IpVbGYL86LCyrBIsmA4L88LzDa
         4LdSv6Z7fME/TejL7s7q0mAC/AsEIB9R4NLxCe66QpIGrzOfcU2aMSlsjfDoSDmXcp6h
         Hpiw==
X-Forwarded-Encrypted: i=1; AJvYcCWIuRdiCkB9WuVYu96Zc4Fo5GAOtWLLN5diq24dVddbDQ7P7ULufHe/elGmviNuZg+hXTnzTVdOzs+/yuMXQnzgPLXSBEAa
X-Gm-Message-State: AOJu0YwiNOZKm5QCCskUde2DrHc3isAQDhTaN9LRBdvfABJ4LopWb4U3
	ngV/AqRVzS6U8VjOQyowG+8VDWqB+67pyGHaQx91R0wj5aMVrUXI2HFBrWt79LY=
X-Google-Smtp-Source: AGHT+IG39+No54Rw/miCMksXv5QcGuWzil+DCVtmW0Rz/pFwmk6IgrNbAr9fPsdspRzM1slcOMQVlg==
X-Received: by 2002:a05:6a20:c21:b0:1c2:912f:ca70 with SMTP id adf61e73a8af0-1c69966e0b6mr16020999637.42.1723070053844;
        Wed, 07 Aug 2024 15:34:13 -0700 (PDT)
Received: from localhost ([2804:14c:87d5:5261:6c30:472f:18a6:cae1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59176eb6sm111615725ad.196.2024.08.07.15.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 15:34:13 -0700 (PDT)
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
Subject: Re: [PATCH v10 36/40] kselftest/arm64: Add test coverage for GCS
 mode locking
In-Reply-To: <20240801-arm64-gcs-v10-36-699e2bd2190b@kernel.org> (Mark Brown's
	message of "Thu, 01 Aug 2024 13:07:03 +0100")
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
	<20240801-arm64-gcs-v10-36-699e2bd2190b@kernel.org>
Date: Wed, 07 Aug 2024 19:34:11 -0300
Message-ID: <87frrgdkt8.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> Verify that we can lock individual GCS mode bits, that other modes
> aren't affected and as a side effect also that every combination of
> modes can be enabled.
>
> Normally the inability to reenable GCS after disabling it would be an
> issue with testing but fortunately the kselftest_harness runs each test
> within a fork()ed child.  This can be inconvenient for some kinds of
> testing but here it means that each test is in a separate thread and
> therefore won't be affected by other tests in the suite.
>
> Once we get toolchains with support for enabling GCS by default we will
> need to take care to not do that in the build system but there are no
> such toolchains yet so it is not yet an issue.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/gcs/.gitignore    |   1 +
>  tools/testing/selftests/arm64/gcs/Makefile      |   2 +-
>  tools/testing/selftests/arm64/gcs/gcs-locking.c | 200 ++++++++++++++++++++++++
>  3 files changed, 202 insertions(+), 1 deletion(-)

The gcs-locking test passes on my FVP setup:

Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>

-- 
Thiago
