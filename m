Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5443A18641
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032493; cv=none; b=QK2F8bP4nue1Go0KYKFxf2giKf+SuiC84x3Gv7FLNn+lv01dGYWTv/BdkHB2UCeBfgf5X1tNUTqb5/euzyxwJ3BvEjr7i8b9j7FLKIyWENwTKUZQAQtjIWBIRyRjfXXPMbSoN3c++vjmcD8r9+1hHECtgnnoZjZexsdssgL4GvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032493; c=relaxed/simple;
	bh=Jw16o+DWWMk5L5htTB+2+9MEZXqx6dLp72BB7nLRi4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ekR0+dbiPGeD0SG+Z4iMHTA3g5iP+XBsaW6SjEB7f4vCvcYI7rtZa1XdJxpYdOx2SPl6lC2/4PrptneHapWZwV1Fu5mCKwqCpMjLvJ59cqDLqEYTpDzfO4hdlgEGEmblWgg9eaC87d9rSIasHMIaC/A3hJEcKFB1423tmQLmNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fMuYNG3o; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fMuYNG3o"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso123757a91.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032491; x=1746637291; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=URk21pnT/XOSFzAg25G44Je9n7xhg0j0WDExK+T2XSo=;
        b=fMuYNG3o+n1vLb76HZUmsEuFM6DgAN68kPlF4NL/o/Z9eMKOD4JwYPRTFAbXfh3NHq
         K7gnx6F02lcoxom+YMSwfYXgOmuObMekvK+uxQE+gbprxwFGuiLKe1IEz3TqzjQEJTS5
         WMz/uDfz9juOS2YOC1Av+IDeH3puHT9WTw0iVoOxeZRXeTFvcAUnUmyxNE1sPqEzF+io
         PYdaj4smKc3dPGLemb96tj6SqGinyLStZm2vH3edUojNGxbGtKwdx5v6gI7XKnRJuWro
         uGmpbY/2xw+8MHNeWa9QETHI3DJAv+fwxm7SQduwPOlS/t6gj6hmQDkTuJZDH33an9xy
         vlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032491; x=1746637291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URk21pnT/XOSFzAg25G44Je9n7xhg0j0WDExK+T2XSo=;
        b=NC0P1xG1+ShxnD29K7CbCjvQ3yr2wNnKBETTEBrAobnybsEljQjgWTci6bCyKDSrVt
         e1nU0uvNJkuK5GOAI4uu5fEESzAVQXTHGJ6HAU/USk1lOsKb8RPHc8FoKGm9LkvwhzmI
         V921CXVU/sVIZ1N8liZlEP8Gw1CW3W0b7vDteAkuq7j1pRjtfM89bt+Mfju1CpikQPhN
         iCPOwFKgrtNavnTE/0S1r/dLnJx0xbm+wAt6qSjm1JGtHA1bmCzHTQGePl2oUWVmImLp
         pW2ogN4Ps/4MCFS8JzGF+N+VVvGlu31ubAIod47BnU//rkGciZQg6suEPzJ6zqOyLTVA
         rEVw==
X-Forwarded-Encrypted: i=1; AJvYcCXXUu3AsclWhgmLtOIKOKDN/xL6AlPYm0XhxpeZyWHNHzX0dW8aHcRGrz4XSGcuZVSUBq53k2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzHA3SteUPwkWxnlKFd6m1zC6xF5mK5hIQj7C5IN92ecpLrkb/
	3N9jqDOJYTilmJmzsFP5FG3bxgXm5/+44cVhrOIaJUaSLRQ5LgdQqke6uDHX3LeCspJINpoTQ/5
	wwA==
X-Google-Smtp-Source: AGHT+IESEXuF+9+pwH1wKZ+9NbO7EwNOG2NYsEaw3R2SqqKDBeSnQYLSAYuo2qganDUT53HrDY6m/tsSN3o=
X-Received: from pjbsk13.prod.google.com ([2002:a17:90b:2dcd:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c02:b0:2ff:4e90:3c55
 with SMTP id 98e67ed59e1d1-30a3335eeb7mr5473897a91.27.1746032491582; Wed, 30
 Apr 2025 10:01:31 -0700 (PDT)
Date: Wed, 30 Apr 2025 10:01:29 -0700
In-Reply-To: <20250222005943.3348627-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com> <20250222005943.3348627-2-vipinsh@google.com>
Message-ID: <aBJXabTuiJyRZb-O@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Add default testfiles for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 21, 2025, Vipin Sharma wrote:
> Create a root "testcases" folder in KVM selftests directory. Add test
> files for all of the KVM selftests across all of the supported
> platforms.  Write only default test execution command in the test files.
> Commands written in the test files will be ran by KVM selftest runner.
> 
> Test files are organized based following rules:
> 1. All test files resides in "testcases" directory.
> 2. Test files should have .test extension. This is needed so that
>    git doesn't ignore the test file changes.
> 3. Each KVM selftest resides in a folder in "testcases" directory.
>    It follows the path of KVM selftests directory. For example,
>    kvm/x86_64/vmx_msrs_test.c will be in
>    kvm/testcases/x86_64/vmx_msrs_tests directory.
> 4. default.test name is reserved for the default command to execute the
>    test.
> 5. Different configuration of the tests should reside in their own test
>    files under the same test directory. For example dirty_log_perf_test
>    can have:
>    - testcases/dirty_log_perf_test/default.test
>    - testcases/dirty_log_perf_test/hugetlb1g.test
>    - testcases/dirty_log_perf_test/disable_dirty_log_manual.test
> 6. If there is an arch specific option of a common test then it should
>    be specified under an arch name directory in the test directory. This
>    will avoid test runner to execute the common test or its option on
>    unsupported machine. For example:
>    testcases/memslot_modification_stress_test/x86_64/disable_slot_zap_quirk.test
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore                         | 3 ++-

After spending a comical amount of time fiddling with the default testcases, I
think I have a final opinion.

We definitely auto-generate the default testcases.  Relying on the user to remember
to add a testcase, and on the maintainer to remember to check for that, isn't a
winning strategy.

But, I do think we should commit the default.test files to the repository.  If
they're ephemeral, then several problems arise:

 1. For out-of-tree builds, the default.test files should arguably be placed in
    the OUTPUT directory.  But if/when we add curated testcases/, then we'll either
    end up with multiple testcases/ directories (source and output), or we'll have
    to copy testcases/ from the source to the output on a normal build, which is
    rather gross.  Or we'd need e.g. "make testcases", which is also gross, e.g.
    I don't want to have to run yet more commands just to execute tests.

 2. Generating default.test could overwrite a user-defined file.  That's firmly
    a user error, but at least if they default.test files are commited, the user
    will get a hint or three that they're doing things wrong.

 3. If the files aren't committed, then they probably should removed on "clean",
    which isn't the end of the world since they're trivially easy to generate,
    but it's kinda funky. 

So, what if we add this to auto-generate the files?  It's obviously wasteful since
the files will exist 99.9999999% of the time, but the overhead is completely
negligible.  The only concern I have is if this will do the wrong thing for some
build environments, i.e. shove the files in the wrong location.

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35..d94bb8330ad1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -198,6 +198,13 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
 LIBKVM += $(LIBKVM_$(ARCH))
 
+$(foreach tc, $(TEST_PROGS), $(shell mkdir -p testcases/$(patsubst %.sh,%,$(tc))))
+$(foreach tc, $(TEST_GEN_PROGS), $(shell mkdir -p testcases/$(tc)))
+$(foreach tc, $(TEST_PROGS), \
+  $(shell echo $(tc) > $(patsubst %.sh,testcases/%/default.test,$(tc))))
+$(foreach tc, $(TEST_GEN_PROGS), \
+  $(shell echo $(tc) > $(patsubst %,testcases/%/default.test,$(tc))))
+
 OVERRIDE_TARGETS = 1
 
 # lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most

> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 1d41a046a7bf..550b7c2b4a0c 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -9,4 +9,5 @@
>  !config
>  !settings
>  !Makefile
> -!Makefile.kvm
> \ No newline at end of file
> +!Makefile.kvm
> +!*.test

Let's keep the extension wildcards sorted alphabetically, i.e.:

# SPDX-License-Identifier: GPL-2.0-only
*
!/**/
!*.c
!*.h
!*.py
!*.S
!*.sh
!*.test
!.gitignore
!config
!settings
!Makefile
!Makefile.kvm

> diff --git a/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
> new file mode 100644
> index 000000000000..5db8723f554f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
> @@ -0,0 +1 @@
> +./aarch64/aarch32_id_regs

I don't see any reason to make the paths directly consumable with a leading "./".
Spoiler alert from the next patch: the location of the test executables needs to
explicitly resolved by the test runner.
