Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5878970986
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G0VVngfN"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5c239897895so166458a12.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 13:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701899046; x=1702503846; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=emWQ//128IChCAhCT/THcHGJcWxhncZjLzE78FXSX8E=;
        b=G0VVngfNGph7kzRP4HO12itz7HNZvxt3bXOv4oT6au8zhdh9jNFk3iW9vfksgRTL50
         qroMvhLZyL3lJDqmWx2l3LWGrf6wALI5jMa4bLKKcJkAdHRFCo2mE5Xl8/JQh1WOW81T
         Oobihe+7CgAYuAc0cqSg4xrEdkVM+p8umfJggf/FfvSp41UwjhyTkPiKlSYgr01Dl3Z/
         Wttf7JHZyhEFpQy9KI17ew9XrinmS4mErTbjPJ73QPUB/bdezDjKV880f3Y8dkWSMxn5
         BozUzyI0sxHCCC0M0dEFqpBcW3dJC7DoAt7aqcj61Z5GYPd1CvD1mk3/qXzKrJFOoGbo
         whsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701899046; x=1702503846;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emWQ//128IChCAhCT/THcHGJcWxhncZjLzE78FXSX8E=;
        b=o0x7nh8oGx5olRtO2CMZUF1m0nqLdLTAjG53s4NjSCQ1KtqU0H9GkAI6JtqBeEubMj
         oLlOLaIdXZP5CrDc7PZZ0hbY3ugxHG1VsCHD7UO2+vyxRGy3XAaReBPnXZVoFAHAZ651
         l/sqoc2LgMlTXstBXglcrpgqHq16Kn+AXhyj6O2YNo8MvQvU0pu7JgKnxZF0OfnIf3Uy
         tjbspR0YmCme6rlYlt//mETWNEFKjFYAv8Sj1DWIJV8s7f24mn8BQ51Varc+VUBtB7E7
         4Vw0BohvzFpO+kJl+GB5nmw43y4u3wHHF29jWSP7BVHprtoTPky8SMUyjOCTTXxbn/YH
         wFCg==
X-Gm-Message-State: AOJu0YyltIAyR4eiNMryhRfeWsJUg3p/bwY6En38P8kHGAkPnEOGSdAj
	wVSO8OzRhMJxG+CRGO94PWjENw==
X-Google-Smtp-Source: AGHT+IF/KxemxaFFxK+8duX7yz47wLjIg4ovMlgkotFmeA6CuhxmgEGVP9MOvenfubO04eLnbo0Zng==
X-Received: by 2002:a05:6a21:190:b0:187:f343:ab3d with SMTP id le16-20020a056a21019000b00187f343ab3dmr1422332pzb.55.1701899046588;
        Wed, 06 Dec 2023 13:44:06 -0800 (PST)
Received: from localhost ([2804:14d:7e22:803e:f0e2:3ff1:8acc:a2d5])
        by smtp.gmail.com with ESMTPSA id ju17-20020a170903429100b001c74df14e6fsm267818plb.284.2023.12.06.13.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 13:44:06 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-23-201c483bd775@kernel.org>
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
Subject: Re: [PATCH v7 23/39] arm64/mm: Implement map_shadow_stack()
In-reply-to: <20231122-arm64-gcs-v7-23-201c483bd775@kernel.org>
Date: Wed, 06 Dec 2023 18:44:04 -0300
Message-ID: <87a5qnhuqj.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> Since the x86 code has not yet been rebased to v6.5-rc1 this includes
> the architecture neutral parts of Rick Edgecmbe's "x86/shstk: Introduce
> map_shadow_stack syscall".

This paragraph can be dropped now.

-- 
Thiago
