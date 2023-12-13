Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213271844
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ox/nAT5R"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6ce7c1b07e1so5511673b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 18:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702435509; x=1703040309; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=CJ7qwCmvq20mGgi3dRymJGPN14h9pbhwL4VM2txPZCM=;
        b=Ox/nAT5RTU8A/059hdQrT7Xufblts7BBiAxuMHU2DBXuhWFSB9HiPzRXZ1xSXtGkso
         iMaAKc7Y32spkfVgzNL9/X45Y/iT67R6IpzUqWz4kOA+o0H7K1wtE+1xIB4zuXod6bPV
         3y6db1LQlMupaW7+7mDG5Y7VP9V+MK/bTU/lE0fja9ZF6W2Zwy259eYwY1bklLXfQt4C
         xXMimqTPa2kfIUpzmXC+7OSfJ7U1fX5McZBHpDOZMTH06JZxvl6jxf0rQphaZ7es+Knw
         2yn3R/dzrtIHyOm06KnIPf8IaNNgbnKRdB1cSEO0fCqQTqo1aezCBXudviNP0fA9TPxa
         F8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702435509; x=1703040309;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJ7qwCmvq20mGgi3dRymJGPN14h9pbhwL4VM2txPZCM=;
        b=IlsNyg/L3GFm/Q+yWRmV/71+i7LiindfqvGNR7vwXEhcaNCiQb3XQBtZydDMRgAo75
         IbRUS5i4zfGXw0G1me63mcD7CZ0rNhfd2z3nktzBz2rKi0D0s2OFF8dBFnCE0u51qbs7
         105gTMMboEsYZRMqQ6LnT/tIf0wofUdrpqbh+St2ctN8GCuGc8/EJxl+h92uYGRN2DMv
         LbVlBwLXR/tVkoprnVMlmESaSazHQOVULT5l6NQgmIKorvce2GlKc4cub8AzcXX4BrvJ
         YMg2KTsqaD8p4ItBtc9sxgVdgsW1ng8s5odjSUAAljR6dePxgLhX3MF+7TTYk8k9d6zI
         Ce7Q==
X-Gm-Message-State: AOJu0YxGpHl8QO57OiR/ItNEA6SILZ+qKeZbefozdbNQNwVImlIGqS/x
	4E85BUgTvfaibp4UKMJbl7VoaQ==
X-Google-Smtp-Source: AGHT+IGi//6HE3KINOZpirefGAX+e3jIHwZFWzUp/AR1xA1scaFysKSWvBw9/QjFkCNOqGCFGdEidA==
X-Received: by 2002:a05:6a00:c81:b0:6cb:a2f4:8579 with SMTP id a1-20020a056a000c8100b006cba2f48579mr8585102pfv.15.1702435509333;
        Tue, 12 Dec 2023 18:45:09 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:cddd:ffc9:f19e:a4dc])
        by smtp.gmail.com with ESMTPSA id y72-20020a62ce4b000000b006cb7bdbc3besm9528817pfg.17.2023.12.12.18.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 18:45:08 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-37-201c483bd775@kernel.org>
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
Subject: Re: [PATCH v7 37/39] kselftest/arm64: Add a GCS stress test
In-reply-to: <20231122-arm64-gcs-v7-37-201c483bd775@kernel.org>
Date: Tue, 12 Dec 2023 23:45:06 -0300
Message-ID: <87zfyex1l9.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


I'm going a bit out-of-order to report a build failure in a test:

Mark Brown <broonie@kernel.org> writes:

> +// Recurse x20 times
> +.macro recurse id

I get an assembler error here:

gcc -nostdlib gcs-stress-thread.S -o /home/thiago.bauermann/src/linux/tools/testing/selftests/arm64/gcs/gcs-stress-thread
gcs-stress-thread.S: Assembler messages:
gcs-stress-thread.S:236: Error: unexpected end of file in macro `recurse' definition
make[2]: *** [Makefile:24: /home/thiago.bauermann/src/linux/tools/testing/selftests/arm64/gcs/gcs-stress-thread] Error 1

This is with gas from Ubuntu 22.04, which ships binutils 2.38.

> +function recurse\id
> +	stp	x29, x30, [sp, #-16]!
> +	mov	x29, sp
> +
> +	cmp	x20, 0
> +	beq	1f
> +	sub	x20, x20, 1
> +	bl	recurse\id
> +
> +1:
> +	ldp	x29, x30, [sp], #16
> +
> +	// Do a syscall immediately prior to returning to try to provoke
> +	// scheduling and migration at a point where coherency issues
> +	// might trigger.
> +	mov	x8, #__NR_getpid
> +	svc	#0
> +
> +	ret
> +endfunction
> +.endmacro
> +
> +// Generate and use two copies so we're changing the GCS contents
> +recurse 1
> +recurse 2

-- 
Thiago
