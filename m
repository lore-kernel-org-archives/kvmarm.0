Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BCC18E351
	for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 21:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705330; cv=none; b=Pes2KdFUP4vI35ifTcGbOCmZuI9oLUotbgWcDxtGj5m9Ofvlwb6LXr0VO/g2We9NFdbiJY/23kB4V28fdzCJetbQCJP3of4myZHb1GbnL6tPzkAM8mymo0KNNjQie1fjDNSqQMRi+6ZytA1CO4F60JOG84YcHwTo8wtQpyfrais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705330; c=relaxed/simple;
	bh=trwmvmbAnZgaQ6EZSEOh8Une0rIcrMhZwDzqFcj8pxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqMfDGvsNb2gcNVisYs/nqbXCunS6j7lfOiqi/LY52+VJG2DCTjypMWtd9MEULQjRk820H9dBS6K68RsUpcwc2yzgX8jHsG6yQubIVJFUYDK4ht/Wj35+XSvobGYvcVuyI7FyalTW4fAe5qCZxrEx+bZVnxeHrLULDFCSFbblc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0GfSEnz/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0GfSEnz/"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20ca03687fdso34595ad.0
        for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 13:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731705328; x=1732310128; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nM0MnCaJJLmdERpqY9PV6u9+AmwEyhjWFW3qkZDsAPA=;
        b=0GfSEnz/2BxL1Ff7Ljq2LmPkBc1BNlrsVUKMxWXJyIR/CN3gpfl9UC3wye7utSbbzy
         +mec02MwPr+sMdLBFv7o+c7IvIOH8DkMINKT4FDOsjP2cGcUGTZbDWRGflH5A3RVux/G
         lUHxSyUddgu0VwsMzV/MJBvt+fIluf3cKQSbt2y/h1M8hCX5+PdTxP8L2mV9ytGRlmgM
         qejG3jVU49hlQE3WTNYaqfucb4ZR8AjZBPtAeBnj6xT/iw44liz8bdICnAwHzb/DaJ/J
         +5/gnwbDLC/T9PmkfuusMaASLmRAxxlikDBGMW0XCVhmHxuNG1TOmwRE+pEMvt1OjFCA
         o0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731705328; x=1732310128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM0MnCaJJLmdERpqY9PV6u9+AmwEyhjWFW3qkZDsAPA=;
        b=GV+NKKz4f9XZrWLbWnkaK7QRG5LBdjAhFkGUsdJsIhoH6l3qZSB472HOcrVnA0EKHP
         O8Ysp1OJjSTSxnvILaTnbTgtPKAd1mSXh/+SOBp8np0t566EpjiQw4rwHMhCo9ZVKOWD
         BqRAnkBl43Eb0gc/kFG6u9Gng9I6PdaVTI7zbptV6IXaIPhUnzJeeHcLbQOfH4+HgFnY
         vNQDKoiLmLKU0weP+KEiibfx4wTh4kQ6yIyCsNHrtsf3Vt/w+4GTlvc3B++1mIStgJp7
         Fqc+6lqW4LT7TUUJcAYHfdGP4AlE8tX4lJOfx+kK4r8W9PVztTI87+v3JSshO2TqguL9
         +aMg==
X-Forwarded-Encrypted: i=1; AJvYcCWxe4G5S7fzvSmx27rfFeN6rXZMiQxvEzsX9cvpO5F3+XqGHHOrSWVxNZpdkK7EWKicKEjQxos=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSNoZOk+sNiGaD2VkOykJBALlCXwmsuwBa0yucwq/hwYX9G4+B
	2FprPidB4aPMIARk8wnvQfKmLw8AwNMG6MjXXl8r5kuxquXeLsT6kmXFaHzbfQ==
X-Gm-Gg: ASbGncsGFxfpdcwQRz/kgZPvZ/iGgWqmYIbh06KSWS8ZWk7uwISejL6ZV7N2p127zYR
	WdOc0e5MoHzmvjoOEaQ+cjKkvBNFGNFNAEWXyzJiYnrrjC+HB6TOqBB2EdANFclHkham5YK4c1g
	Zze2892QH/iGk9JjDiij7AY4IOkVFGtjoCb7+ufcIz6V6II7uB995ba6wWXe3g9rVhOckoncfzs
	X5DBqGjDNX0JfYiAE3jN4sqchcFOg04216iidlzgwYkUknd14hRIu6ai7RwTo9Cs96I+Kkdysx7
	jVHqqrSX
X-Google-Smtp-Source: AGHT+IG54m6rEFmImb5DSUuRdJgzvPLf5+rPUGSAVLO9hy0QHwDB3d2opaLJ5cQwhz6bZyjkGDS1Kw==
X-Received: by 2002:a17:902:f68d:b0:206:a87c:2873 with SMTP id d9443c01a7336-211ee1f5f05mr310055ad.5.1731705327532;
        Fri, 15 Nov 2024 13:15:27 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1c2deb3sm1746337a12.23.2024.11.15.13.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:15:26 -0800 (PST)
Date: Fri, 15 Nov 2024 13:15:23 -0800
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just
 default
Message-ID: <20241115211523.GB599524.vipinsh@google.com>
References: <20240821223012.3757828-1-vipinsh@google.com>
 <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
 <ZyuiH_CVQqJUoSB-@google.com>
 <20241108-eaacad12f1eef31481cf0c6c@orel>
 <ZzY2iAqNfeiiIGys@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzY2iAqNfeiiIGys@google.com>

On 2024-11-14 09:42:32, Sean Christopherson wrote:
> On Fri, Nov 08, 2024, Andrew Jones wrote:
> > On Wed, Nov 06, 2024 at 09:06:39AM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2024, Vipin Sharma wrote:
> > > > Phase 3: Provide collection of interesting configurations
> > > > 
> > > > Specific individual constructs can be combined in a meaningful way to
> > > > provide interesting configurations to run on a platform. For example,
> > > > user doesn't need to specify each individual configuration instead,
> > > > some prebuilt configurations can be exposed like
> > > > --stress_test_shadow_mmu, --test_basic_nested
> > > 
> > > IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
> > > command line options.  Users shouldn't need to modify the runner just to bring
> > > their own configuration.  I also think configurations should be discoverable,
> > > e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
> > > approach is that testing different combinations is frustratingly difficult,
> > > because running a testcase with different configuration requires modifying a file
> > > that is tracked by git.

I was thinking of folks who send upstream patches, they might not have
interesting configurations to run to test. If we don't provide an option
then they might not be able to test different scenarios.

I do agree command line option might not be a great choice here, we
should keep them granular.

What if there is a shell script which has some runner commands with
different combinations? There should be a default configuration provided
to ease testing of patches for folks who might not be aware of the
configurations which maintainers generally use.

End goal is to provide good confidence to the patch submitter that they have
done good testing.

> > 
> > We have support in KUT for environment variables (which are stored in an
> > initrd). The feature hasn't been used too much, but x86 applies it to
> > configuration parameters needed to execute tests from grub, arm uses it
> > for an errata framework allowing tests to run on kernels which may not
> > include fixes to host-crashing bugs, and riscv is using them quite a bit
> > for providing test parameters and test expected results in order to allow
> > SBI tests to be run on a variety of SBI implementations. The environment
> > variables are provided in a text file which is not tracked by git. kvm
> > selftests can obviously also use environment variables by simply sourcing
> > them first in wrapper scripts for the tests.
> 
> Oh hell no! :-)
> 
> For reproducibility, transparency, determinism, environment variables are pure
> evil.  I don't want to discover that I wasn't actually testing what I thought I
> was testing because I forgot to set/purge an environment variable.  Ditto for
> trying to reproduce a failure reported by someone.
> 
> KUT's usage to adjust to the *system* environment is somewhat understandable
> But for KVM selftests, there should be absolutely zero reason to need to fall
> back to environment variables.  Unlike KUT, which can run in a fairly large variety
> of environments, e.g. bare metal vs. virtual, different VMMs, different firmware,
> etc., KVM selftests effectively support exactly one environment.
> 
> And unlike KUT, KVM selftests are tightly coupled to the kernel.  Yes, it's very
> possible to run selftests against different kernels, but I don't think we should
> go out of our way to support such usage.  And if an environment needs to skip a
> test, it should be super easy to do so if we decouple the test configuration
> inputs from the test runner.

Also, keeping things out of tree won't help other developers much. I want
majority of that configurations which maintainers/regular contributors
maintain locally to be upstreamed and consolidated.

> 
> > > There are underlying issues with KUT that essentially necessitate that approach,
> > > e.g. x86 has several testcases that fail if run without the exact right config.
> > > But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
> > > write robust tests.
> > > 
> > > E.g. instead of per-config command line options, let the user specify a file,
> > > and/or a directory (using a well known filename pattern to detect configs).
> > 
> > Could also use an environment variable to specify a file which contains
> > a config in a test-specific format if parsing environment variables is
> > insufficient or awkward for configuring a test.
> 
> There's no reason to use a environment variable for this.  If we want to support
> "advanced" setup via a test configuration, then that can simply go in configuration
> file that's passed to the runner.

Can you guys specify What does this test configuration file/directory
will look like? Also, is it gonna be a one file for one test? This might
become ugly soon.

This brings the question on how to handle the test execution when we are using
different command line parameters for individual tests which need some
specific environmnet?

Some parameters will need a very specific module or sysfs setting which
might conflict with other tests. This is why I had "test_suite" in my
json, which can provide some module, sysfs, or other host settings. But
this also added cost of duplicating tests for each/few suites.

I guess the shell script I talked about few paragraphs above, can have
some specific runner invocations which will set specific requirements of
the test and execute that specific test (RFC runner has the capabilty to execute
specific test).

Open to suggestions on a better approach.

