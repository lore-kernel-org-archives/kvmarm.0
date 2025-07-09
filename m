Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13944A92E
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097149; cv=none; b=VySQShF6sMdne7ls6xUiZPTHVA0qHK9Tvd/o43U4NHz2DKeNFue4pYGuIRKejW/LtgNrAlqOJnTatUvrM+v4OQBqRamWvILuqoVxiIfpcU6jWZzBPKvtwMUBiff1Zw/4G+JLANcUpQe0sFdjQ8ci1TD15TdR3PjhFXm+osozJxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097149; c=relaxed/simple;
	bh=GODhRmDiVJiCnZUnkaX8NW89MJRIIVn4pvNiMuRjOq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPyVVKhATW19+NCUIjL/izKROXGbQRwWRZHDCosJr0Iz7wfO6jyShjXjBSsXEn7rZgpDBTDAqGIZ75xF30WXitvcaQhfwHpHJM/zNNCniJp/WcxankE7jQSqO/qzKxBc17Z4gbylss+fkk/AiNBJxFWrAz0nEXzc5tN+a/303lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q5KUPtoY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q5KUPtoY"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31215090074so602415a91.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097147; x=1752701947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRjFnmCzYN+qn8kF+o9IzfpkXQ4+JquW4HupC73fftA=;
        b=Q5KUPtoYXUP1TF4DmhpdlqvzyxV043jVb0Tzlkyt+xWGjcfr6Xti9RtvdFklAgfrOj
         MlKJqp7B/SwsfIQcZQP3xXRF9Y7EOZ730WsaOd2xYAX0uIuoHbptU4KyR4wHbzgGVyOS
         xe7E/tidQFPE1NgkkuE3VMUDXNmcXhp0Bd8dR/jbqLsBM6rXsHe6Rx8JpBpg9KBoSdtB
         q8X65l4VYqk8syJxJ2+EyA3B95nnjZCRIHxCA5EY8vk2XSMEKaYRdAZs6DWQxZwa4og/
         gtCASJRrrEnecHZW326YXqVpVXWAmSlp+tnNKrwZe6I9V/w6aRcZqGC1pHEYdxZdGm8I
         mSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097147; x=1752701947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRjFnmCzYN+qn8kF+o9IzfpkXQ4+JquW4HupC73fftA=;
        b=SlfZlzL5rniU+zVNYrXhwdTO93g651ZFrbg4zenMCrRhNIDVya15ohmXTRZpB1ezCi
         Svqoufq65RkUJiBrAKMAbULpxN3ken1DrG2cZNownkbRqPvJy/mKnYQkA8THz6/q3v4f
         t2mdSkJURUvkRthnCPDXUZouDNptSU1B33GiCOG5+eETu24mtkW+t2P6NGMQBb/BCHA7
         I/L+ZksB2H4+3FpToDc0FhA75eeq1m4gUJUJuFIUbihPekRtnmYZSXh/rxjgm1RHC7Dr
         RkcjEvExelK+bXkJQPHvtj8j255V3n0OdSg38XSyifJweXIDWEL77o58xs23qvgm+MDR
         gtnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGbf5/crsAfHuin7jfA+Rg1QIRS78jGYRLsG6pRJc4YXFWz+Gkfo6ZJ9q4FvaYwkkKyOfNev4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWqvWEVDov0Nlgih4sVFGc36fyBtF2uqeCxzTTzmm7w8OhQEnS
	JgY6GJ4iwCwFujdv9gswDaraEVcoFQGbIY0lZNeoHQVf7pnuHomhfupfFkieyjFfw8gQuvqOFYE
	eUTlskA==
X-Google-Smtp-Source: AGHT+IGqLtd25jQcDPlbBnyHm57aZXVZqGANjf8aQ+PHIDAz5DerrzktIfl+GNc39oHL/0frC4tukw2+CLQ=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:312:2b3:7143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5344:b0:313:62ee:45a
 with SMTP id 98e67ed59e1d1-31c3ef2308emr245837a91.13.1752097147476; Wed, 09
 Jul 2025 14:39:07 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:39:05 -0700
In-Reply-To: <20250606235619.1841595-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-3-vipinsh@google.com>
Message-ID: <aG7heUe_zBf83tlJ@google.com>
Subject: Re: [PATCH v2 02/15] KVM: selftests: Enable selftests runner to find
 executables in different path
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add command line option, --executable/-e, to specify a directory where
> test binaries are present. If this option is not provided then default
> to the current directory.
> 
> Example:
>   python3 runner --test-dirs test -e ~/build/selftests
> 
> This option enables executing tests from out-of-tree builds.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/runner/__main__.py    | 8 +++++++-
>  tools/testing/selftests/kvm/runner/selftest.py    | 4 ++--
>  tools/testing/selftests/kvm/runner/test_runner.py | 4 ++--
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index b2c85606c516..599300831504 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -29,6 +29,12 @@ def cli():
>                          default=[],
>                          help="Run tests in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
>  
> +    parser.add_argument("-e",
> +                        "--executable",

"executable" is kinda odd to me, as that suggests a single, specific executable.
-p/--path seems more aligned with how this concept is typically described in Linux.
