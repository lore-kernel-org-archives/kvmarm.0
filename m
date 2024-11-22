Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24848176FD2
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 22:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732315083; cv=none; b=H1Od6CUqs44VcVDMSohU397E2sQE7bcLhFNk8omZ0SsgdTGzSiO+VeDtB6A3KtJywOeGA/hNH7E9oIGQYL/j3KS9RYzEEFSr/AV6n5j/HFs7K2uYN1Zq0+NYasQk0SFJsMjo5d8wpA19wyRBHdc/ygVrnJZNUC2LyLZLGcp4Nnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732315083; c=relaxed/simple;
	bh=6GLmjpPY6EOrT6vmph0MIzerN19LbhQl4PfcSl2fDic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tM7JyD3PsuInSHCwik5CoAD9X7sKGaRXI1iTshzKXTnzAejA5nK07JxP0tEmUHxBYqcj3pVMvaIBo2Hohx+qTBt5mvNzQKf+VXzBPzGxCAsYhLIbK76+k7NDs64F7O9w8g0C8KXMfXKzajf094ujQ8M90QbPZPXc+pY8ORArOJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EBwt4bFa; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBwt4bFa"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-211f1b2bf2bso14275ad.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 14:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732315081; x=1732919881; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5kr5xL10rVafwH2QwXNIB2NX51MpVtbUlFWYreKeG40=;
        b=EBwt4bFawYk5ERGShbmHKMGWGKje8tyhYD8hwy/3f3xWO514UciFtcCXfVNulOiOgl
         VWnYLrU5DmLkrGfIbz2WU91HOxZERDS5yGmNj0IbX2deQzDd4oSUeyadN4mw6eUPpzoo
         yaM9tESnOTY//+ev3BZPq8yIM08Z7J3KOq1RgNrHbkgykaA8ZwcveYz/WNprxeEqZuQz
         wpfbCMOLVneHn0dQ10DVriKRtDfJw2G+G2nuo8dKn72BLn0TcglXPmiwzXXD/g2tKo6Y
         VPCvmaHBdPp17WOhu99Vg+hHJFCy20ynnOjHi9lKVPQuUfh2b4FH/YvdG52wvWcE3hE4
         qlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732315081; x=1732919881;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kr5xL10rVafwH2QwXNIB2NX51MpVtbUlFWYreKeG40=;
        b=GLv7xFXNdG25ASwObE+mW3SRAcYh4Xui+RRSN8Ro/r3oEMro3/XhGcYZSxa48OEpkN
         8Az42yQkS3nEJT9WJwYyRBfVdOn5qp0pl6BtMxYrBj1ygHHIaTijh3n0rAxtOC0vqVdC
         hn7GUD3uQ5oL+0Rn6/bLN6udtcvDhf7il4C2wV5evZRL49kK0eYGZD4HvRRuYPHsNG7B
         +fVYPcN0X9dzfdnzkuZ/0Hbd0v1qx52gXfJ5ler8ID92pY3WumLaZOOw0YfAHY4S4tew
         lt+Y/Px5Ckiqexy3+3MRge0CY5Rb3qzLWIB9szVQTYOc/1iXO5g8i36rGE2J6e0BQg2Y
         LsXw==
X-Forwarded-Encrypted: i=1; AJvYcCVol/u+cOo3pZSz8IYwP/z3n3UTovuZm0zXqJeGhUWiU67mFbFAZmF/pXQRt4DX5oVmqjm1pDI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZV9Y6xO3gUeLO6awv4bxgyd+pEt8Ict+jsZCC/NeGYm7rfAyB
	78vjgt5wXU8vArD7dCzPp8Lc++xh0YgiMGIkyDMp5exSf6WO+tsjBVlP7leLDw==
X-Gm-Gg: ASbGnctMHSoORs244hxUojHMJdNpnyksZlPZgm2+M9LLiWqLe9Ia+SJmMnN3AbslGb8
	saY2DEvbCZDT0VuNJRFpI881RYhyeM7mMP71f5bIR58gHUVocoh1GoqqpRbNrzU9dQgW5X+XU9X
	NP+taxZv5iG/KfniEPtk0FlZbkT82CH6mPcnxPfHpxZSr8/77S9R+7B0NERy6M/7SVzP0npY1dN
	3Z94XyTiYTw3nMfYk+baUXr236nCxYNbb/KyNctq+mFW77vhFMcBjehR564SXSXgwkHNAaOqEmR
	wUn0BlMO
X-Google-Smtp-Source: AGHT+IH7FcOLwqCX5Pk18qMpoAhw/6OPuccEjBkX6SjRRnRTGj+6abQWL8biM94lLtA5xkrz6/Cx9w==
X-Received: by 2002:a17:902:d550:b0:20c:5cb1:de07 with SMTP id d9443c01a7336-2149e0a53c8mr239615ad.11.1732315081192;
        Fri, 22 Nov 2024 14:38:01 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcbfc0960sm1890512a12.11.2024.11.22.14.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:38:00 -0800 (PST)
Date: Fri, 22 Nov 2024 14:37:56 -0800
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
Message-ID: <20241122223756.GA2112434.vipinsh@google.com>
References: <20240821223012.3757828-1-vipinsh@google.com>
 <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
 <ZyuiH_CVQqJUoSB-@google.com>
 <20241108-eaacad12f1eef31481cf0c6c@orel>
 <ZzY2iAqNfeiiIGys@google.com>
 <20241115211523.GB599524.vipinsh@google.com>
 <Zz5-3A36cckhYu9K@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zz5-3A36cckhYu9K@google.com>

On 2024-11-20 16:29:16, Sean Christopherson wrote:
> On Fri, Nov 15, 2024, Vipin Sharma wrote:
> > On 2024-11-14 09:42:32, Sean Christopherson wrote:
> > > On Fri, Nov 08, 2024, Andrew Jones wrote:
> > > > On Wed, Nov 06, 2024 at 09:06:39AM -0800, Sean Christopherson wrote:
> > > > > On Fri, Nov 01, 2024, Vipin Sharma wrote:
> As discussed off-list, I think having one testcase per file is the way to go.
> 
>   - Very discoverable (literally files)
>   - The user (or a shell script) can use regexes, globbing, etc., to select which
>     tests to run
>   - Creating "suites" is similarly easy, e.g. by having a list of files/testscase,
>     or maybe by directory layout
> 
> Keeping track of testcases (and their content), e.g. to avoid duplicates, might
> be an issue, but I think we can mitigate that by establishing and following
> guidelines for naming, e.g. so that the name of a testcase gives the user a
> decent idea of what it does.
> 
> > > > Could also use an environment variable to specify a file which contains
> > > > a config in a test-specific format if parsing environment variables is
> > > > insufficient or awkward for configuring a test.
> > > 
> > > There's no reason to use a environment variable for this.  If we want to support
> > > "advanced" setup via a test configuration, then that can simply go in configuration
> > > file that's passed to the runner.
> > 
> > Can you guys specify What does this test configuration file/directory
> > will look like? Also, is it gonna be a one file for one test? This might
> > become ugly soon.
> 
> As above, I like the idea of one file per testcase.  I'm not anticipating thousands
> of tests.  Regardless of how we organize things, mentally keeping track of that
> many tests would be extremely difficult.  E.g. testcases would likely bitrot and/or
> we'd end up with a lot of overlap.  And if we do get anywhere near that number of
> testcases, they'll need to be organzied in some way.
> 
> One idea would be create a directory per KVM selftest, and then put testcases for
> that test in said directory.  We could even do something clever like fail the
> build if a test doesn't have a corresponding directory (and a default testcase?).
> 
> E.g. tools/testing/selftests/kvm/testcases, with sub-directories following the
> tests themsleves and separated by architecture as appropriate.
> 
> That us decent organization.  If each test has a testcase directory, it's easy to
> get a list of testcases.  At that point, the name of the testcase can be used to
> organize and describe, e.g. by tying the name to the (most interesting) parameters.

Sounds good. Extending your example for testcases given below this what
I am imagining ordering will be:

testcases/
├── aarch64
│   └── arch_timer
│       └── default
├── memslot_modification_stress_test
│   ├── 128gib.allvcpus.partitioned_memory_access
│   ├── default
│   └── x86_64
│       └── disable_slot_zap_quirk
├── riscv
│   └── arch_timer
│       └── default
├── s390x
├── steal_time
│   └── default
└── x86_64
    ├── amx_test
    │   └── default
    └── private_mem_conversions_test
        ├── 2vcpu.2memslots
        └── default

1. Testcases will follow directory structure of the test source files.
2. "default" will have just path of the test relative to
   tools/testing/selftests/kvm directory and no arguments provided in it.
3. Extra tests can be provided as separate files with meaningful names.
4. Some tests (memslot_modification_stress_test) have arch specific
   options. Those testcases will be under arch specific directory of
   that specific testcase directory.
5. Runner will be provided with a directory path and it will run all
   files in that and their subdirectories recursively.
6. Runner will also filter out testcases based on filepath. For example
   if running on ARM platform it will ignore all filepaths which have
   x86_64, s390, and riscv in their path anywhere.
7. If user wants to save output of runner, then output dump will follow
   the same directory structure.

> 
> Hmm, and for collections of multiple testscases, what if we added a separate
> "testsuites" directory, with different syntax?  E.g. one file per testuite, which
> is basically a list of testcases.  Maybe with some magic to allow testsuites to
> "include" arch specific info?
> 
> E.g. something like this
> 
> $ tree test*
> testcases
> └── max_guest_memory_test
>     └── 128gib.allvcpus.test
> testsuites
> └── mmu.suite
> 
> 3 directories, 2 files
> $ cat testsuites/mmu.suite 
> $ARCH/mmu.suite
> max_guest_memory_test/128gib.allvcpus.test

This can be one option. For now lets table testsuites discussion. We will
revisit if after Phase1 is completed.

> 
> > This brings the question on how to handle the test execution when we are using
> > different command line parameters for individual tests which need some
> > specific environmnet?
> > 
> > Some parameters will need a very specific module or sysfs setting which
> > might conflict with other tests. This is why I had "test_suite" in my
> > json, which can provide some module, sysfs, or other host settings. But
> > this also added cost of duplicating tests for each/few suites.
> 
> IMO, this should be handled by user, or their CI environment, not by the upstream
> runner.  Reconfiguring module params or sysfs knobs is inherently environment
> specific.  E.g. not all KVM module params are writable post-load, and so changing
> a param might require stopping all VMs on the system, or even a full kernel reboot
> if KVM is built-in.  There may also be knobs that require root access, that are
> dependent on hardware and/or kernel config, etc.
> 
> I really don't want to build all that into the upstream test runner, certainly not
> in the first few phases.  I 100% think the runner should be constructed in such a
> way that people/organizations/CI pipeines can build infrastructure on top, I just
> don't think it's a big need or a good fit for upstream.

For phase 2 discussion, you responded:
	> Phase 2: Environment setup via runner
	>
	> Current patch, allows to write "setup" commands at test suite and test
	> level in the json config file to setup the environment needed by a
	> test to run. This might not be ideal as some settings are exposed
	> differently on different platforms.
	>
	> For example,
	> To enable TDP:
	> - Intel needs npt=Y
	> - AMD needs ept=Y
	> - ARM always on.
	>
	> To enable APIC virtualization
	> - Intel needs enable_apicv=Y
	> - AMD needs avic=Y
	>
	> To enable/disable nested, they both have the same file name "nested"
	> in their module params directory which should be changed.
	>
	> These kinds of settings become more verbose and unnecessary on other
	> platforms. Instead, runners should have some programming constructs
	> (API, command line options, default) to enable these options in a
	> generic way. For example, enable/disable nested can be exposed as a
	> command line --enable_nested, then based on the platform, runner can
	> update corresponding module param or ignore.
	>
	> This will easily extend to providing sane configuration on the
	> corresponding platforms without lots of hardcoding in JSON. These
	> individual constructs will provide a generic view/option to run a KVM
	> feature, and under the hood will do things differently based on the
	> platform it is running on like arm, x86-intel, x86-amd, s390, etc.

	My main input on this front is that the runner needs to configure module params
	(and other environment settings) _on behalf of the user_, i.e. in response to a
	command line option (to the runner), not in response to per-test configurations.

Should we still write code in runner for setting parameters which are
writable/modifiable or just leave it? Our current plan is to provide
some command line options to set those things but it is true that we
might not be able to set everything via runner.
