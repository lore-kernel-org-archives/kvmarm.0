Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72D53D38F
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 02:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708395482; cv=none; b=ncERhpbCNESivxCj95U4BBNmUZdICjxvBVUWjCb1M9x3yCBx8so6HR1HO0hl8j16J9UmqVOuGu6+Fm0N+YQuvLGUNsXyiC67KWnchOZ6wjZdbhEv8WGwM55TswqMoPL9hOE7zqDCT+epIIlUP8z5Hq5YuJuKypSiAZsXjRyIdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708395482; c=relaxed/simple;
	bh=kywl0E7Ccn+F6uJKh4GjD6fADlYLci1v7yF8jV6BqRU=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZgZahe/NDBudP8adaa0vCO6dJfYMHpaoXpU7X220rcSkh+ois4Dg5le8J7lOpfaOccVS0RUJ/GgbbSElXCK8iA7/QisyDixLLucOOSG5ypG2qqS2J3XEKdGL4PY0e3KKG4nNd0viquQRo99wXCap+mFn2jizcSI+jtFLxkvhbw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HOvIv2zv; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HOvIv2zv"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3c13410a319so3310895b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 18:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708395480; x=1709000280; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=hyy8ZTU+BTw5Zgz2454qzBwNJQ5zOkaDYTH0aZ4A4fg=;
        b=HOvIv2zvSLVLs+Iiplanbg8MR6rjslkzkgXqvbMNcwFZHlbSygErLQWpqieuPWF0vV
         5ujH43TO941dYh9olNRivjBA8banoGG5O/Z8z9aiHBEYnW2xL94QkmfUi7PPswXSR4M4
         88WgWeyIz9JokOyTeS05C0WgoO669dVUCdkOrG8DS1ISsj7uqd8Yb9KXJmuHWAn19Dw8
         eLsFSw7AQ3cNptBoBfk3gkKSB0Hw0tPv4fNNVuexQzPzWzH9E1T1blk3BK9m6ewd4DFm
         ITG6s0J0pK57mDL8JdVtf2/c2e9qwPF84R2nWOY84t9LSeVXF+UBzedQXsLU7GAO6ft8
         ceyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708395480; x=1709000280;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyy8ZTU+BTw5Zgz2454qzBwNJQ5zOkaDYTH0aZ4A4fg=;
        b=hh+gvueTlp8vWKfFlzduL3R47wN+d2kgeZvo1P2SBM6US3wp/bcrbkqrXkrYtX3KQ0
         46q6Fe6TGQWWnNCpQg3nqrGwTLNs3VwkQFORc22hoFt04hIBv54RinrlZ2nqBAqwjeUu
         vK5RP338MT7+Kf9q3ePWnilSlLrKWefeTrUMcS+lMuS7sY5AvTu75bP24f5IhJDZbBRv
         IKJ+IH3epXs9/HeEVqZ9RZRCGhZFfC/51e152YA2IoZNMf+zuZa/CVcvTVX4hAGP/f1h
         Y4aLbGZ+VnCVV2kA71j4A3GMVpIXHFVj5Gy+MAN3PKB/8hBNgzb9LXDuN5BI2g35J8ar
         vwRg==
X-Forwarded-Encrypted: i=1; AJvYcCWaG1mA4Mi+658DYXsGzsmbNHsJ+NeqYzJ6c1nzeeLiAkPhVFZB1o53dN/U/2j9AtKtqmE9oZ4F2qX5P9u80ycl2RJfRLTy
X-Gm-Message-State: AOJu0Yw+LrzMoHxkWp+AzI4nr5wEhX05UZGwhadpo38CAfFRckyT+DWZ
	vuxNyyCd6xbeQpNoKAIetfHjzeLJEBQnP8cNYkQDWyDYe7zRfTLqH1B9yt+hW14=
X-Google-Smtp-Source: AGHT+IG+AWqQMKARywU7epk4MPVFD1c38rPYRk/u1nDYjlo0ottYYY2CyLviBufhz/tQt6Ao3jO2qw==
X-Received: by 2002:a05:6808:2b06:b0:3c0:4455:a2fa with SMTP id fe6-20020a0568082b0600b003c04455a2famr15407500oib.18.1708395479877;
        Mon, 19 Feb 2024 18:17:59 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a328:9cae:8aed:4821])
        by smtp.gmail.com with ESMTPSA id jw26-20020a056a00929a00b006e45e51ba11sm3274807pfb.145.2024.02.19.18.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 18:17:59 -0800 (PST)
References: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
 <20240203-arm64-gcs-v8-35-c9fec77673ef@kernel.org>
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
Subject: Re: [PATCH v8 35/38] selftests/arm64: Add GCS signal tests
In-reply-to: <20240203-arm64-gcs-v8-35-c9fec77673ef@kernel.org>
Date: Mon, 19 Feb 2024 23:17:57 -0300
Message-ID: <87o7cb7uay.fsf@linaro.org>
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
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/arm64/signal/.gitignore    |  1 +
>  .../selftests/arm64/signal/test_signals_utils.h    | 10 +++
>  .../arm64/signal/testcases/gcs_exception_fault.c   | 62 +++++++++++++++
>  .../selftests/arm64/signal/testcases/gcs_frame.c   | 88 ++++++++++++++++++++++
>  .../arm64/signal/testcases/gcs_write_fault.c       | 67 ++++++++++++++++
>  5 files changed, 228 insertions(+)

Just FYI, in v7 I reported that gcs_write_fault was failing for me.
Now all tests in this patch are passing.

-- 
Thiago
