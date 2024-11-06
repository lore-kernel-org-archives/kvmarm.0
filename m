Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C23E206509
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912804; cv=none; b=mFo0vZ93PiZQW1zFs6zS2EZuJioI/Bgqr8bMbPYvBNxKcSq35ugjefWRlSovk4K/68SsO9frwgE0am2ja1a76QIFjA9HmE8tzFslTadxFAE3CTOEjd6oWnNVvQNGPInUJcj4hKKcRAAHeYtyAXXye6wDGTJKzCXwRYlbqscI8/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912804; c=relaxed/simple;
	bh=6Rf5zqPa5m3hV7JKPsCSyDllRSudKN5CTQ483bKOox4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o3SXQl4e0lkZ8N+MDvBEFHWQEp1AjraLfdvAh36PuZB0/NLQYctbcUmOPrCAfnjyTebDZqJsP+55cmjFjBVQo/SADKaSst51m4nymkG14Ve9fYsGCPbb55qeB//lPG9ZPzFZIWQuNwTlYbE+MMiu/z4G67NqcvLzvoHsu2ys3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bXXISnRw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bXXISnRw"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fea2adb6so9687029276.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 09:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730912801; x=1731517601; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5t+pTmBPHbo0E/uwfzEy52VjrmqfqWmgZSSzb34Bz4w=;
        b=bXXISnRwx5sd5H1qnnobT0evM4bogYPZ/y0dZVk1B2QXDpVVcJChqZR3MmjmMqlYHF
         0DmMaqn6PJTu/jlUFCf+B9OyAiTUDfJr0/sqqVB+ftvBe9Qht+CTmLYGYN10xzYHCe/d
         nWa9ikHudsdpFcpXmFEm37Bv7nA9/htE2tJR6+fovzSmSkVtK8ZCmu5NWvt1P1CLHLZs
         qwTWZFNUkjepHtPuNOzYYYTB9cfczenNEk9tActxS+zj/SlKkzBq5Dj2vwRGQ4Td7Cxk
         upZHyYMQsjw5TkR/LPkHkdmuv/D56ZJB1zuoqJNWlrAtSSuClsAs9ESU3fo7QqRs4gkJ
         hUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730912801; x=1731517601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t+pTmBPHbo0E/uwfzEy52VjrmqfqWmgZSSzb34Bz4w=;
        b=mM2cOCrZsjgl5G2gX34PvT9s02CmypmjR1iSsaBk6+v1dsi89fjU24Qg1hoTCgnKrS
         YyS6ILaOY6vgtT2A2MdXSA+q8Z+Mc5bdSwDLp0ZvSAIbjkwegxTlVhj+aw1FfFSAk54/
         rl4Mhg7m3NUFMdHkquD3bAePS486i0mJw3jjHtSdpRtN4gmjBiadDUKeBqnO5xV67ENk
         m3PXDc+XnOZSWGaoDT4zPnKo7RGHvdrwdl+v8aO0fLCcRprL0MwRKczQqCF9wgDS1McN
         pxwqx9oVYb0OACELwkIy3d4/hWJt9wUeKq/Soqw2ezuboBxZaNFk3z0N33wgWLiJOwIL
         3yJg==
X-Forwarded-Encrypted: i=1; AJvYcCUTlmY+R9hh1BWwD6SjVOS6cK7IBGtzbiWmoazFJcSKXmIku9NkifqmCehto84KZsv0YZh1y0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhybzisLsjA98EF3WmBtocd8d4mhGo0b/UI2FLT+qoXFUJYkyz
	fq1sOhRUjm08aZPwzN737jiBbW04aCwUs2Btt+0SgHibfTwI0FweNM/jkEI+iIf3F5jSAqxwNm+
	hLA==
X-Google-Smtp-Source: AGHT+IGtFenR1QTBctdMYFKBTYZG/ZO0INYKhWuvVmpVVCJ3u0Ldd1ciEKyXxUgTterH6MxTNnFNUgE23Nc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:abe9:0:b0:e30:b98d:a33d with SMTP id
 3f1490d57ef6-e30b98da4f0mr50282276.5.1730912800993; Wed, 06 Nov 2024 09:06:40
 -0800 (PST)
Date: Wed, 6 Nov 2024 09:06:39 -0800
In-Reply-To: <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com> <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
Message-ID: <ZyuiH_CVQqJUoSB-@google.com>
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just default
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Vipin Sharma wrote:
> Had an offline discussion with Sean, providing a summary on what we
> discussed (Sean, correct me if something is not aligned from our
> discussion):
> 
> We need to have a roadmap for the runner in terms of features we support.
> 
> Phase 1: Having a basic selftest runner is useful which can:
> 
> - Run tests parallely

Maybe with a (very conversative) per test timeout?  Selftests generally don't have
the same problems as KVM-Unit-Tests (KUT), as selftests are a little better at
guarding against waiting indefinitely, i.e. I don't think we need a configurable
timeout.  But a 120 second timeout or so would be helpful.

E.g. I recently was testing a patch (of mine) that had a "minor" bug where it
caused KVM to do a remote TLB flush on *every* SPTE update in the shadow MMU,
which manifested as hilariously long runtimes for max_guest_memory_test.  I was
_this_ close to not catching the bug (which would have been quite embarrasing),
because my hack-a-scripts don't use timeouts (I only noticed because a completely
unrelated bug was causing failures).

> - Provide a summary of what passed and failed, or only in case of failure.

I think a summary is always warranted.  And for failures, it would be helpful to
spit out _what_ test failed, versus the annoying KUT runner's behavior of stating
only the number of passes/failures, which forces the user to go spelunking just
to find out what (sub)test failed.

I also think the runner should have a "heartbeat" mechanism, i.e. something that
communicates to the user that forward progress is being made.  And IMO, that
mechanism should also spit out skips and failures (this could be optional though).
One of the flaws with the KUT runner is that it's either super noisy and super
quiet.

E.g. my mess of bash outputs this when running selftests in parallel (trimmed for
brevity):

        Running selftests with npt_disabled
        Waiting for 'access_tracking_perf_test', PID '92317'
        Waiting for 'amx_test', PID '92318'
        SKIPPED amx_test
        Waiting for 'apic_bus_clock_test', PID '92319'
        Waiting for 'coalesced_io_test', PID '92321'
        Waiting for 'cpuid_test', PID '92324'
        
        ...
        
        Waiting for 'hyperv_svm_test', PID '92552'
        SKIPPED hyperv_svm_test
        Waiting for 'hyperv_tlb_flush', PID '92563'
        FAILED hyperv_tlb_flush : ret ='254'
        Random seed: 0x6b8b4567
        ==== Test Assertion Failure ====
          x86_64/hyperv_tlb_flush.c:117: val == expected
          pid=92731 tid=93548 errno=4 - Interrupted system call
             1	0x0000000000411566: assert_on_unhandled_exception at processor.c:627
             2	0x000000000040889a: _vcpu_run at kvm_util.c:1649
             3	 (inlined by) vcpu_run at kvm_util.c:1660
             4	0x00000000004041a1: vcpu_thread at hyperv_tlb_flush.c:548
             5	0x000000000043a305: start_thread at pthread_create.o:?
             6	0x000000000045f857: __clone3 at ??:?
          val == expected
        Waiting for 'kvm_binary_stats_test', PID '92579'
        
        ...
        
        SKIPPED vmx_preemption_timer_test
        Waiting for 'vmx_set_nested_state_test', PID '93316'
        SKIPPED vmx_set_nested_state_test
        Waiting for 'vmx_tsc_adjust_test', PID '93329'
        SKIPPED vmx_tsc_adjust_test
        Waiting for 'xapic_ipi_test', PID '93350'
        Waiting for 'xapic_state_test', PID '93360'
        Waiting for 'xcr0_cpuid_test', PID '93374'
        Waiting for 'xen_shinfo_test', PID '93391'
        Waiting for 'xen_vmcall_test', PID '93405'
        Waiting for 'xss_msr_test', PID '93420'

It's far from perfect, e.g. just waits in alphabetical order, but it gives me
easy to read feedback, and signal that tests are indeed running and completing.
        
> - Dump output which can be easily accessed and parsed.

And persist the output/logs somewhere, e.g. so that the user can triage failures
after the fact.

> - Allow to run with different command line parameters.

Command line parameters for tests?  If so, I would put this in phase 3.  I.e. make
the goal of Phase 1 purely about running tests in parallel.

> Current patch does more than this and can be simplified.
> 
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

One of my complaints with our internal infrastructure is that the testcases
themselves can dictate environment settings.  There are certainly benefits to
that approach, but it really only makes sense at scale where there are many
machines available, i.e. where the runner can achieve parallelism by running
tests on multiple machines, and where the complexity of managing the environment
on a per-test basis is worth the payout.

For the upstream runner, I want to cater to developers, i.e. to people that are
running tests on one or two machines.  And I want the runner to rip through tests
as fast as possible, i.e. I don't want tests to get serialized because each one
insists on being a special snowflake and doesn't play nice with other children.
Organizations that the have a fleet of systems can pony up the resources to develop
their own support (on top?).

Selftests can and do check for module params, and should and do use TEST_REQUIRE()
to skip when a module param isn't set as needed.  Extending that to arbitrary
sysfs knobs should be trivial.  I.e. if we get _failures_ because of an incompatible
environment, then it's a test bug.

> Phase 3: Provide collection of interesting configurations
> 
> Specific individual constructs can be combined in a meaningful way to
> provide interesting configurations to run on a platform. For example,
> user doesn't need to specify each individual configuration instead,
> some prebuilt configurations can be exposed like
> --stress_test_shadow_mmu, --test_basic_nested

IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
command line options.  Users shouldn't need to modify the runner just to bring
their own configuration.  I also think configurations should be discoverable,
e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
approach is that testing different combinations is frustratingly difficult,
because running a testcase with different configuration requires modifying a file
that is tracked by git.

There are underlying issues with KUT that essentially necessitate that approach,
e.g. x86 has several testcases that fail if run without the exact right config.
But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
write robust tests.

E.g. instead of per-config command line options, let the user specify a file,
and/or a directory (using a well known filename pattern to detect configs).

> Tests need to handle the environment in which they are running
> gracefully, which many tests already do but not exhaustively. If some
> setting is not provided or set up properly for their execution then
> they should fail/skip accordingly.

This belongs in phase 2.

> Runner will not be responsible to precheck things on tests behalf.
> 
> 
> Next steps:
> 1. Consensus on above phases and features.
> 2. Start development.
> 
> Thanks,
> Vipin
