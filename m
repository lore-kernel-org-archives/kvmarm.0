Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5591145346
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 22:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721341717; cv=none; b=u4IY8WjnQdZKi7jb3jfwqKjOZHklHkmWgRSmurnbbenYr3/Z9Wtuc0Nl+UXRb4JrFMFStydYnKWn5IqUepUfUJkDP7VrOnZFJ9S1Bvrh5B9sTPGnzNXF73wP74G+RfielRtn6qvjqOL1Xj1G8rY/KPKvnh3s6wYd6Z2RvlL4W90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721341717; c=relaxed/simple;
	bh=/dgDQ63gkEhY3dFzZwulJGUglg5Uq6j9k84TZuMsK6g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bw52PZxiiZreyGAlv80DUK6XxTQcgDLj3Qd+9wRe8uGjlbVIND23LD9I4r5sUDxHfl1KaPHnnkXm6i/u3wSN3nY+HnHnhEaLmfAzWYtezJuI57G1qPcTb7dxTuCWIsUcYRsV1wxvhhgNO+9vBtfM+zaA17Dk8E+3YIivEznSukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MfTv70lY; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MfTv70lY"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fc424901dbso13093635ad.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 15:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721341715; x=1721946515; darn=lists.linux.dev;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mAFp8cCYrsuMTkT1FWDyABYg4XKo158nqIj+Kj0+oyk=;
        b=MfTv70lYhDb+AroRM3FQYFHM+KofD07Vty9Q/qTKS8UbBGSp/jyOueB6D52KZkotOT
         /60/rjR0DxhON5T/DLoYcQKhAwXH9qxNtnrJpaGWDreIqoLPCD4B+VeeAQ+nKDayecnN
         r2KfT1Vvm4Qw6YBXh8FpbezvGdTyR9dSESbW0VZaD9fUzJ2JXOxLrPPQMp4pXsOwU2+w
         k0s3nt+rF41ZanGbI6fLHhKnjG+Trab9h77ye85bTXmRQvZCdIW0nio12Tg0TlPRoe90
         48jnDZ4unsPP17zakYpg22BPJLoZujnATbVlK7/aJWjQFkKbzU06Rrjd4+n5H+GGzNB8
         K9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721341715; x=1721946515;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAFp8cCYrsuMTkT1FWDyABYg4XKo158nqIj+Kj0+oyk=;
        b=AmOw5x/vtPYD6o1hsh2MSNI0oOcg25DguFVya5xafJxJaqCozp824eVUi9VxkfK4hX
         nd4JrcS7VK737bOn5Ki6Djbrjb8T9KB4A/H/OFMm/X2fENZO0LW3sTRcdacK6BVDCLXc
         5MEbjrrbI0RSlwp9W9iQOr6/u+1dOagskNp+EDnwSEKhBOStZXQJLnugcaeJJ+w2JNwg
         0CtCR8fgHfLm+XlcJG16amcTB4/+Lt1/HWtMrRbgeeI7EnbA1+HNOqQy+InBg+VRoIfz
         SCkW2aGZ1hJii2CI1Xu4mp75NaedVt9mmoQYJdo+7zMzjrVp114VkBHUH9PKEgcrz8wv
         o7MQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfyQR5ORP7ait8C35f1MDXCrcooQgnIwlOCtSR27o5BDn4h2tjASCqtKXH79aEOnhk2yjKTlNi7jSqJnRQCnrkoqgv2qvC
X-Gm-Message-State: AOJu0YzkBfjdJcb5HH3CiOu30kuDj7YOpe+bmLME3czm3pMi2PirSX3s
	R/MfZKIStG/hD0kHe84VGtQKdtJVKSJm6do6DEMXJO+DI5znv2tYwEGACctYAhM=
X-Google-Smtp-Source: AGHT+IF+55vW6JaqSjwGQi3R1yuf8ZxKtUymaiTTvyr4EyfBefOjisnvw3P8CACe6QPfDEnW0zUgIw==
X-Received: by 2002:a17:902:f707:b0:1fb:37fa:fedb with SMTP id d9443c01a7336-1fc4e154856mr54520445ad.10.1721341714980;
        Thu, 18 Jul 2024 15:28:34 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:15c8:3512:f33c:2f80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd64b51aebsm849435ad.27.2024.07.18.15.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 15:28:34 -0700 (PDT)
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
Subject: Re: [PATCH v9 35/39] kselftest/arm64: Add a GCS test program built
 with the system libc
In-Reply-To: <a1ee93ab-2168-4228-a4e8-eab02c046bd3@sirena.org.uk> (Mark
	Brown's message of "Thu, 18 Jul 2024 17:16:39 +0100")
References: <20240625-arm64-gcs-v9-0-0f634469b8f0@kernel.org>
	<20240625-arm64-gcs-v9-35-0f634469b8f0@kernel.org>
	<87plray8we.fsf@linaro.org>
	<a1ee93ab-2168-4228-a4e8-eab02c046bd3@sirena.org.uk>
Date: Thu, 18 Jul 2024 19:28:32 -0300
Message-ID: <87ed7qxrlb.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mark Brown <broonie@kernel.org> writes:

> On Thu, Jul 18, 2024 at 01:14:41PM -0300, Thiago Jung Bauermann wrote:
>
>> In my FVP VM, this test gets a GCS SIGSEGV before running the first test:
>
> Do you have THP enabled?  That still doesn't work (I'm expecting it to
> be fixed with -rc1).

I did have it enabled. After turning it off in the kernel config, the
test does pass. But I see 30 lines of "INVALID GCS" in dmesg while
running it. Is it expected?

-- 
Thiago
