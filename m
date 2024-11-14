Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2F18C01A
	for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731606157; cv=none; b=haTm2x5oNd7fuQsKNhhREke/eQmlmE8mW6tva3BbmH2WZB1vk2TKTCK7SZrRVFFr22s2hTXOTPpFO0eXiK/cJiDbdukrUk8JHVnhN+plowR8Ly7pkahGLAUXpHLWNCPts1eJJzT4ICVhXYhKjgx4jDjG16zTQPkb92myT2XMfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731606157; c=relaxed/simple;
	bh=5uog7s88Vdjn9LrHFqVJ7H6JRAqfaj//EHJnHT0pKe0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C1ekhy4qT6TxSb1xk1RBB2WJmOHh9CIBIgEzTPW25MmtDAd8qsexZ9aBBMop6mVbE1pqL4NAr2V0siZUt4JeKV/3qHb9HTpyHuJDuCUIcE5TLPgY6h3a8nFfIkxoMqaFtkIpdO9nLPDoS/eDHMhGIMvQ3AiTl2m4utd1I86YHDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LtSWeMt9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LtSWeMt9"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e6241c002so810852b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 09:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731606155; x=1732210955; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jxstw+HdDkmUNCxSNezg+z3DZ+qdKf7DbKMcdrw87E=;
        b=LtSWeMt9kY1vxYrMJrMBucxIvqJfGtkuOvd7DI5sF/GnWQHSt8wX45qk1VZPjZD0Ys
         NpsPVzFbFnnRhFvhJRYXmioUfvtYtdzNhU0wkMpq/787TxzDDfinzqbr3VleUEB6NScg
         P77iFngozyF+Sbp8iIH7TvQPQygV9Kxysu2W/1gR8qFuuINQbTJ3Vd9gx36bsKPNY9XX
         JAoViKSk/26rAsi7jNhymvlo6ljYoPmp950Uregf9E6p99yBS699250AiS85be5Q3Et+
         MOdy/eb5P3wDGWeS5VxuJusDtH/dIMQ1Pab5aIzG+qqhUN+UllZtnF8fORKtPUp0VFwO
         QRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731606155; x=1732210955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jxstw+HdDkmUNCxSNezg+z3DZ+qdKf7DbKMcdrw87E=;
        b=r9Dghu1ZK2pUyacokCxMuTRptksAcDKlb5oSPLJCzTbBIKdbs/pLNNxPJ78+Qk/12j
         GxlRswvsp1lgiPKTaKq8WD0Jdg9sUJV67PPrl/NkdvKdpS3qQp7iXMKXIeYRNWNfVOZa
         49hBjerqKQy33G+fzbZXIGlepSgVy5qy0lPefrAKUF1k1LBM3l2vubwkTvoIfX5/bpM0
         8P2uPPRTCoJEA4PECrpWtgLSRHYnNTNLaL9U6sGNatSAOuREmDhMxeR9Cw1bwPBmMdm2
         3bcVxMmYc8p6YKiIIprj9d9arHd3ZR082D2HuT3rXbRzC2djaDpYgNfyzqHSQY5uwx9/
         9eLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuwN9HV9NWIFef54p2npiAPrUICGodT5KUEHqMVtxg75DRDQyDN8CXkXbMqIZNQYjyGRv6M7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/sfyMcmQBCNWmV3COqfdtaGTZDuY43BCZMwLgUZuALaQanUXs
	NT0EUb8fK2Vh6Okop4J4/yffSnZccqd4r6/pn+A+H5CWtF2pQo5g+qFro/ygEUZS7x6GMRdasjU
	/nQ==
X-Google-Smtp-Source: AGHT+IE2t7/BQUDGvQdq1WU4OfDCD4pafvlstYkabCEfeZEIVCwo/4m39wonrcrGj/V1SHEHETmIrMp08OA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2167:b0:724:67d7:17b2 with SMTP id
 d2e1a72fcca58-72467d71a19mr35667b3a.0.1731606154070; Thu, 14 Nov 2024
 09:42:34 -0800 (PST)
Date: Thu, 14 Nov 2024 09:42:32 -0800
In-Reply-To: <20241108-eaacad12f1eef31481cf0c6c@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com> <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
 <ZyuiH_CVQqJUoSB-@google.com> <20241108-eaacad12f1eef31481cf0c6c@orel>
Message-ID: <ZzY2iAqNfeiiIGys@google.com>
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just default
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 08, 2024, Andrew Jones wrote:
> On Wed, Nov 06, 2024 at 09:06:39AM -0800, Sean Christopherson wrote:
> > On Fri, Nov 01, 2024, Vipin Sharma wrote:
> > > Phase 3: Provide collection of interesting configurations
> > > 
> > > Specific individual constructs can be combined in a meaningful way to
> > > provide interesting configurations to run on a platform. For example,
> > > user doesn't need to specify each individual configuration instead,
> > > some prebuilt configurations can be exposed like
> > > --stress_test_shadow_mmu, --test_basic_nested
> > 
> > IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
> > command line options.  Users shouldn't need to modify the runner just to bring
> > their own configuration.  I also think configurations should be discoverable,
> > e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
> > approach is that testing different combinations is frustratingly difficult,
> > because running a testcase with different configuration requires modifying a file
> > that is tracked by git.
> 
> We have support in KUT for environment variables (which are stored in an
> initrd). The feature hasn't been used too much, but x86 applies it to
> configuration parameters needed to execute tests from grub, arm uses it
> for an errata framework allowing tests to run on kernels which may not
> include fixes to host-crashing bugs, and riscv is using them quite a bit
> for providing test parameters and test expected results in order to allow
> SBI tests to be run on a variety of SBI implementations. The environment
> variables are provided in a text file which is not tracked by git. kvm
> selftests can obviously also use environment variables by simply sourcing
> them first in wrapper scripts for the tests.

Oh hell no! :-)

For reproducibility, transparency, determinism, environment variables are pure
evil.  I don't want to discover that I wasn't actually testing what I thought I
was testing because I forgot to set/purge an environment variable.  Ditto for
trying to reproduce a failure reported by someone.

KUT's usage to adjust to the *system* environment is somewhat understandable
But for KVM selftests, there should be absolutely zero reason to need to fall
back to environment variables.  Unlike KUT, which can run in a fairly large variety
of environments, e.g. bare metal vs. virtual, different VMMs, different firmware,
etc., KVM selftests effectively support exactly one environment.

And unlike KUT, KVM selftests are tightly coupled to the kernel.  Yes, it's very
possible to run selftests against different kernels, but I don't think we should
go out of our way to support such usage.  And if an environment needs to skip a
test, it should be super easy to do so if we decouple the test configuration
inputs from the test runner.

> > There are underlying issues with KUT that essentially necessitate that approach,
> > e.g. x86 has several testcases that fail if run without the exact right config.
> > But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
> > write robust tests.
> > 
> > E.g. instead of per-config command line options, let the user specify a file,
> > and/or a directory (using a well known filename pattern to detect configs).
> 
> Could also use an environment variable to specify a file which contains
> a config in a test-specific format if parsing environment variables is
> insufficient or awkward for configuring a test.

There's no reason to use a environment variable for this.  If we want to support
"advanced" setup via a test configuration, then that can simply go in configuration
file that's passed to the runner.
