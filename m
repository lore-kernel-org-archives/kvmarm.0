Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5073A1DE4F1
	for <kvmarm@lists.linux.dev>; Wed,  1 Oct 2025 17:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759339953; cv=none; b=EF+2ZEzg0PNBmSMobb9XGnkHG/dU7EEZjxk4i9jizqwu4iKMbl/CaFFH1Lmj+/+tQNAqJkO8MrP6b8a07ZSMWiI23pGn4ZTy9r3DB2xBMRaJxNpNoWX5lSCMlmguIY8cdBUC5+V9KjUrg9CnSrLZ8ZubAV6Vef6v8U0B98euV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759339953; c=relaxed/simple;
	bh=rHk1d9c2nYAN1GlB0Qqqi7n0BwmF7bTieJ3BBoipGQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msthW0JHhiAKNvwyFzMCueOiWUs4nNbwfi3PfRL2lDTV4mQH+C9uy/N0f/ILVYYdW/dK6ywjzXAARmYqSYspAgIfn5E9ILoT+Avzz/crjnHMEfGUjakqKDxnQwYOXSFKgCiHIjXlnZzYQ6eE2iebHXyzLdY4uw/lTJnKgM6v5BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KkI98xNJ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KkI98xNJ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27eeafd4882so15555ad.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Oct 2025 10:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759339951; x=1759944751; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o/YWYDtjG6ffJt7pjNnPORxoGZIxj6mJz/9fII2K1Ck=;
        b=KkI98xNJcp/8L/rqUaDCSS/3RZ8PL1nKF4a2RW0AZ9aLU78SgDU2jDd51nMHHtS7Jq
         LqwxJQ4GujLzwJZ+x277GNtyvr95sPMuiqVGHvcDqpwMM4JGJjHpWCoxYOj8BQUvLIH6
         TaIwi6RqRk2BY6uJr+qouzQe3ug/9mFntT5UlCzC7ruvF74zK6p1VkUI1KndAC6WEQmk
         px+N0DeUsZioOGBm2TUdCzBaZaLv76WIxspDjfouWP99dm0Aqa0V0VFxFqFOIOSESmMr
         ObLqd0nkGhADHhkafafEJj5N91nWl4Lilqk6vxAAAEHo4NT9qFcCRJmtR0EZtFpJ0Ilm
         rUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759339951; x=1759944751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/YWYDtjG6ffJt7pjNnPORxoGZIxj6mJz/9fII2K1Ck=;
        b=aSUxolFJAV3TXFDrg9PiZFPX+Dc14O6lJO4XaH17gykKt641RLYxDLmoaVb5zXaRkH
         VKPy4ifD9zinew3ig8QmPGXOhGfRbcJkyyFcmSXckDgZKHSxyM4SRaM01ccWp1Afb/el
         xe5IL3quAy5/nnkfeLXhIzlKJ65V9RJPA+N/l+GPTz+5uYOD8mO4j636Eut9KwQggjeP
         ZHbJmN40FjqZpuGCcNNuHZYJKZTB+JJuAuJCdynsoEGTm5yC+0QC9M5wbRs5IBgD+7r+
         TU5hvMBKEWIz3yVF7RkoC/G9cSXWt6TwccekMNqw+bxKoOESsArLmL5+4R8bI5FU5qRF
         tJQA==
X-Forwarded-Encrypted: i=1; AJvYcCXto7tWJaOG7LpQZ40uvLn2hR5b6HKplaf0v181t2wI6Fksw33d4brTb52Y0+Hs8IOmI3HSTjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwkDVdjJ4X8ILRFuWdujlP95tEq8on4mmnwTesV6o2V0qzH2y0a
	wAb8CmLZ8vgjyr+0h2mssireMxL/VsDvnky/DeLvbifjoVhqU2iVJs0ppG8dBJ8FGw==
X-Gm-Gg: ASbGncv39Txp1/MljXAc0G2yI45d54A6G/i5D2khab6ZlP7ApH9crNItuiWcNWfnSRs
	6TQE++B8VxUqhLQWarj8jFNJFduBLqEtpAhSc23h6wRwQnxZ8rbO0cNQUt4/8GntPZWGekqEusR
	XRWnej8nXz4EWiizDUKlMxaXV4te3FyzqUqLODW/vAlfE0nBqlonqLTXjp8/lopkpcxIF0l+LJd
	nTtp5VdpiMl5BBauANHV/OLYL2ugBA3KHkWfep/Rvqx8D5oJJIEwLb9kKGatnmLzdaX4tWYlWzs
	hQR0e0AZ4sbGrTZzKNKjYDro2fiKsJ6P9k7jN9Gm5aUjrYG+HlI1xgWm+ADmroB1OEQxQ9TyHdK
	P4J3KvS8/JrIJDpY+MtRikP0sj/ZlnLMV5mp5xF7+gro4LOdV1zKeNLqHUEqiAX3JLf1hbO/NVc
	n14UjhjHCbFBnEV6MSyg==
X-Google-Smtp-Source: AGHT+IHx7ebKepLK2+ba7wopXv1hEpDMMQTNfdMH8JIKjgqqvoILE8tuG/fflLyAGOySPePvLbMnkQ==
X-Received: by 2002:a17:903:22c2:b0:26d:a02f:b046 with SMTP id d9443c01a7336-28e8dd04808mr80535ad.11.1759339950898;
        Wed, 01 Oct 2025 10:32:30 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6ff0dddsm2827615a91.18.2025.10.01.10.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 10:32:30 -0700 (PDT)
Date: Wed, 1 Oct 2025 10:32:25 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, seanjc@google.com,
	pbonzini@redhat.com, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org,
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn,
	chenhuacai@kernel.org, oliver.upton@linux.dev,
	ajones@ventanamicro.com
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
Message-ID: <20251001173225.GA420255.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-10-vipinsh@google.com>
 <86qzvnypsp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86qzvnypsp.wl-maz@kernel.org>

On 2025-10-01 09:44:22, Marc Zyngier wrote:
> On Tue, 30 Sep 2025 17:36:35 +0100,
> Vipin Sharma <vipinsh@google.com> wrote:
> > 
> > +KVM selftest runner is highly configurable test executor that allows to run
> > +tests with different configurations (not just the default), parallely, save
> 
> s/parallely/in parallel/
> 

Thanks, I will fix it.

> > +output to disk hierarchically, control what gets printed on console, provide
> > +execution status.
> > +
> > +To generate default tests use::
> > +
> > +  # make tests_install
> > +
> > +This will create ``testcases_default_gen`` directory which will have testcases
> 
> I don't think using the future tense is correct here. I'd rather see
> something written in the present tense, possibly imperative. For
> example:
> 
> "Create 'blah' directory containing 'foo' files, one per test-case.
> 

Thanks, I will fix it.

> > +in `default.test` files. Each KVM selftest will have a directory in  which
> > +`default.test` file will be created with executable path relative to KVM
> > +selftest root directory i.e. `/tools/testing/selftests/kvm`.
> 
> Shouldn't this honor the existing build output directives? If it
> actually does, then you want to call this out.
> 

To generate default test files in a specific directory one can use
"OUTPUT" in the make command

  make OUTPUT="~/test/directory/path" tests_install

This allows to generate testcases_default_gen in the given output
directory. default.test files will still have test binary path relative
kvm selftest root directory. 

$OUTPUT
└── testcases_default_gen
    ├── access_tracking_perf_test
    │   └── default.test
    ├── arch_timer
    │   └── default.test
    ├── arm64
    │   ├── aarch32_id_regs
    │   │   └── default.test
    │   ├── arch_timer_edge_cases
    │   │   └── default.test
    │   ├── debug-exceptions
    │   │   └── default.test
    │   ├── external_aborts
    │   │   └── default.test
    │   │   └── default.test
    │   └── ...
    ├── coalesced_io_test
    │   └── default.test
    ├── demand_paging_test
    │   └── default.test
    ├── ...

So, arm64/aarch32_id_regs/default.test will have 'arm64/aarch32_id_regs'

User can then supply -p/--path with the path of build output directory
to runner. 

  python3 runner -p ~/path/to/selftest/binaries -d $OUTPUT/testcases_default_gen

If -p not given then current directory is considered for test
executables.

> > For example, the
> > +`dirty_log_perf_test` will have::
> > +
> > +  # cat testcase_default_gen/dirty_log_perf_test/default.test
> > +  dirty_log_perf_test
> > +
> > +Runner will execute `dirty_log_perf_test`. Testcases files can also provide
> > +extra arguments to the test::
> > +
> > +  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
> > +  dirty_log_perf_test -x 2 -v 5 -i 10
> > +
> > +In this case runner will execute the `dirty_log_perf_test` with the options.
> > +
> 
> The beginning of the text talks about "non-default' configurations,
> but you only seem to talk about the default stuff. How does one deals
> with a non-default config?
> 

In the patch 1, I created two sample tests files,
2slot_5vcpu_10iter.test and no_dirty_log_protect.test, in the directory
tools/testing/selftests/kvm/tests/dirty_log_perf_test.

Contents of those files provide non-default arguments to test, for example,
2slot_5vcpu10iter.test has the command:

  dirty_log_perf_test -x 2 -v 5  -i 10

One can run these non-default tests as (assuming current directory is
kvm selftests):

  python3 runner -d ./tests

Over the time we will add more of these non-default interesting
testcases. One can then run:

  python3 runner -d ./tests ./testcases_default_gen


