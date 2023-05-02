Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51CB33E8
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 18:51:46 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b9a8075bd7cso7385990276.1
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 11:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683053506; x=1685645506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkbn6HF/azjC3hqgYfJo0k/s9Wz6c8/SBfQlRZ/p7n8=;
        b=R7lwly+9ExnHydnRSuaxye6/E5YwQWRRtLjklyRzqQQuFgpVQzhFSuLko4XkeXNT1c
         MDftcjk6ACDpCc5tI0lsIlNza4AlQF89uyA7OGH/a+8uDGg/OQgj5EY0tmDaAEqURUtp
         GkeCh9tfaNYn9v3wvOpnYOVQwTznB4iWNgYeJW0PZ5kLvmtl/07Blf8fwBHrnaRLG71B
         Gyf/4DUYFh5JNUEXFMOPwi6mtItCsxeNjma8ehwsUjeHCtXmk50SBY1tDs30WWyAKq0f
         WbFaxkAui+aG7DgCEiIG4z+AZVFqsbK7zTtRIlZ2l/t/dsx2aykAd4ZVJiu+XuIXIS5b
         GRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683053506; x=1685645506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkbn6HF/azjC3hqgYfJo0k/s9Wz6c8/SBfQlRZ/p7n8=;
        b=Z5g5m/oqVfQhBlnmHgLL0MLBcMSwYHntpocPVP5G057w4TCpZxfLdQ6cwfLbHbwoBq
         LWxtcD62Agk756p3+3bm69JBsdFFhaKd1Rmky1Fd1apNGunXTJAJKeziS3qhdCsCLUlB
         GjZ6AolhoccHG8UTAjWm6QuMyjo7zy+Ayn8VjYIMouatG7Bj4RCzDF2ceQ9qBM8k2Eoj
         2kBpguE5I4C36J3QtmOqeTUgQn/2pP2x03YvbzC/oqm/nDqHUl91GL7afveHR0MycvRZ
         L2zV6op5X684GH7McPw5I0pPm22X4t2OdlW3HGuO1f53MuM7LbDGFc1oq0wsJr9MpCiT
         odxw==
X-Gm-Message-State: AC+VfDzMB8crpLum0sB5VDldX7K+8LWQAWCU1FOZ29Ogxz02Z5v48/6N
	Pl0pWNOtmmiqoG74PtyugJfiHZehyRU=
X-Google-Smtp-Source: ACHHUZ5LlbcSh/2UOPKizan0t+OqQOybGVQmWjGZNcHYVZjRkM3ADux9Em34nt3QwYn1EAo7oP2OsoCcDns=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e796:0:b0:b99:4473:ed93 with SMTP id
 e144-20020a25e796000000b00b994473ed93mr7121031ybh.4.1683053505921; Tue, 02
 May 2023 11:51:45 -0700 (PDT)
Date: Tue, 2 May 2023 11:51:44 -0700
In-Reply-To: <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
Message-ID: <ZFFbwOXZ5uI/gdaf@google.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, May 02, 2023, Anish Moorthy wrote:
> During some testing yesterday I realized that this patch actually
> breaks the self test, causing an error which the later self test
> changes cover up.
> 
> Running "./demand_paging_test -b 512M -u MINOR -s shmem -v 1" from
> kvm/next (b3c98052d469) with just this patch applies gives the
> following output
> 
> > # ./demand_paging_test -b 512M -u MINOR -s shmem -v 1
> > Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> > guest physical test memory: [0x7fcdfffe000, 0x7fcffffe000)
> > Finished creating vCPUs and starting uffd threads
> > Started all vCPUs
> > ==== Test Assertion Failure ====
> >  demand_paging_test.c:50: false
> >  pid=13293 tid=13297 errno=4 - Interrupted system call
> >  // Some stack trace stuff
> >  Invalid guest sync status: exit_reason=UNKNOWN, ucall=0
> 
> The problem is the get_ucall() part of the following block in the self
> test's vcpu_worker()
> 
> > ret = _vcpu_run(vcpu);
> > TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> > if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
> >    TEST_ASSERT(false,
> >                               "Invalid guest sync status: exit_reason=%s\n",
> >                               exit_reason_str(run->exit_reason));
> > }
> 
> I took a look and, while get_ucall() does depend on the value of
> exit_reason, the error's root cause isn't clear to me yet.

Stating what you likely already know... On x86, the UCALL is performed via port
I/O, and so the selftests framework zeros out the ucall struct if the userspace
exit reason isn't KVM_EXIT_IO.

> Moving the "exit_reason = kvm_exit_unknown" line to later in the
> function, right above the vcpu_run() call "fixes" the problem. I've
> done that for now and will bisect later to investigate: if anyone
> has any clues please let me know.

Clobbering vcpu->run->exit_reason before this code block is a bug:

	if (unlikely(vcpu->arch.complete_userspace_io)) {
		int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
		vcpu->arch.complete_userspace_io = NULL;
		r = cui(vcpu);
		if (r <= 0)
			goto out;
	} else {
		WARN_ON_ONCE(vcpu->arch.pio.count);
		WARN_ON_ONCE(vcpu->mmio_needed);
	}

	if (kvm_run->immediate_exit) {
		r = -EINTR;
		goto out;
	}

For userspace I/O and MMIO, KVM requires userspace to "complete" the instruction
that triggered the exit to userspace, e.g. write memory/registers and skip the
instruction as needed.  The immediate_exit flag is set by userspace when userspace
wants to retain control and is doing KVM_RUN purely to placate KVM.  In selftests,
this is done by vcpu_run_complete_io().

The one part I'm a bit surprised by is that this caused ucall problems.  The ucall
framework invokes vcpu_run_complete_io() _after_ it grabs the information. 

	addr = ucall_arch_get_ucall(vcpu);
	if (addr) {
		TEST_ASSERT(addr != (void *)GUEST_UCALL_FAILED,
			    "Guest failed to allocate ucall struct");

		memcpy(uc, addr, sizeof(*uc));
		vcpu_run_complete_io(vcpu);
	} else {
		memset(uc, 0, sizeof(*uc));
	}

Making multiple calls to get_ucall() after a single guest ucall would explain
everything as only the first get_ucall() would succeed, but AFAICT the test doesn't
invoke get_ucall() multiple times.

Aha!  Found it.  _vcpu_run() invokes assert_on_unhandled_exception(), which does

	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED) {
		uint64_t vector = uc.args[0];

		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
			  vector);
	}

and thus triggers vcpu_run_complete_io() before demand_paging_test's vcpu_worker()
gets control and does _its_ get_ucall().
