Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E3030103D
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763417946; cv=none; b=oUcGMnKpLYjehctEw47EOHXjQqmoB++VXun9fVryGfRkwFqVwPtwFazuDVpgOL2lrZCZ/qObMlyWIG/x1VNc+kYjKer7pLMkMvtrUdhB7qDFQ562AEZPGOnRJS2ngTE2gl0QQ+Ro8aOX75/5DitAgVztVs9bYZDS6PP1ee16rFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763417946; c=relaxed/simple;
	bh=m+SUNOSsRGNg6e4fertlZE3XZICpzyYhXKuDwT0ifo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KD2Ib4oWEWD3QUH1WLVIX1io2OJ9gj130pAPr0OCWza4K8w0CzqwTF/blBeOhX1uy3pT/Lupyj40/BqpF6eQs+WYOrgd2w94aMI+zO06JvK/9E4Z9HSHQhh6hr+r8fOTk8/eRIX8pYbiX2/qRL8zhFRoZEr/46MCKtWvK1WQ5Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0EHtZivr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0EHtZivr"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297e66542afso159805245ad.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 14:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763417945; x=1764022745; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jketl0ykgqH6CHwpfbMW0pLhEMzOqTEcodUiqzB4Vy0=;
        b=0EHtZivr5lEkBYPxSfEoMlt8cClCaaOAPfaI/8Acq284d4AdFfIwHF8itjprPqwzmy
         L0ZzIUIz5ffR73L3aNBVb/UlcVwiPF2+DPZLTKMz7p49hAcRt6YRThpvXLwdWka+M5XF
         boDTRHta6YrX/IvC/zD/ss+zEUbJns2vV9AdH0b+woC0tblcCFbm4+Rx8YbqWqreDdPL
         k/JaMF6XoGyG05SSoxeT0to6McaIraWfye35QpHR3PqDxa3/xdGRakXMg60jUm6EwCNr
         7ju7caoo+/rS/QRPgjed7OX48KoXpdbMIbd3K71FLSHWn44QH91Mpgw5I3CbUDHSuuYg
         NW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763417945; x=1764022745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jketl0ykgqH6CHwpfbMW0pLhEMzOqTEcodUiqzB4Vy0=;
        b=GcaHg8wBv6RqVBqxmbPF8/bxV5R3J5AwP3iQRR7dJBtGmxL/5KKsXACgpd7xzTZwXP
         kzqYz+dsvLFnQqvQi801xpRMPxc27DqPfmfNbWDu8SuyCuxVi4s8dwzPj3y340EU3nKO
         iCLSwa81zOK5KzCLu2s7c1IbnBioEuHc5V1KUq/6P141zcvl2dbhrt28kG1dX/ja1/Kh
         Jvfr24mim/OIY2HNh+TaTM2ZuYXeQlEejGOn8R+h+JPqItn+cLeVlsk3MbrB1s8/qcA1
         hJdAxQvo9GEYfMUxiduv3UI5MR4epxiBOvQbpKK/gX44rc+RkzkaQmoVi+3MDeeJ7xzP
         A1mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhvH8EzkaDIMuTNYI7r2UWcBKgivuHvfVJdWmwRVKqkh98m36yg2mzhbmAwNxlTVVjHLKwpfc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4ibVmsvR10sLwcbu+OB07yFNgFyn4YJSuJUfVXx1yHO5WFAUU
	ENnXXP80zNDVi/Aq5g03/kymTmXEBdZ4Eo5mgbkuhChj11QTzy15A53lHsjU09VV79CfZtKxuVe
	AhcHIOg==
X-Google-Smtp-Source: AGHT+IHcdd0ArWlATEcfj8BU5F82GWD1Li5aCx6PmaH0PInTm//H/NUZ3GqyQdoRB02rIu9vl/OLgCgIy78=
X-Received: from plgn12.prod.google.com ([2002:a17:902:f60c:b0:297:e1db:fee5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e951:b0:298:46a9:df1f
 with SMTP id d9443c01a7336-2986a6b88fbmr168676665ad.12.1763417944666; Mon, 17
 Nov 2025 14:19:04 -0800 (PST)
Date: Mon, 17 Nov 2025 14:19:03 -0800
In-Reply-To: <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com> <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
Message-ID: <aRufV8mPlW3uKMo4@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Nov 15, 2025, Mathias Krause wrote:
> On 14.11.25 19:25, Sean Christopherson wrote:
> > On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
> >> This is v2 of [1], trying to enhance backtraces involving leaf
> >> functions.
> >>
> >> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> >> fails hard for leaf functions lacking a proper stack frame setup, making
> >> it dereference invalid pointers. ARM64 just skips frames, much like x86
> >> does.
> >>
> >> [...]
> > 
> > Applied to kvm-x86 next, thanks!
> 
> Thanks a lot, Sean!
> 
> > P.S. This also prompted me to get pretty_print_stacks.py working in my
> >      environment, so double thanks!
> 
> Haha, you're welcome! :D
> 
> > 
> > [1/4] Makefile: Provide a concept of late CFLAGS
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
> > [2/4] x86: Better backtraces for leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a

Spoke too soon :-(

The x86 change breaks the realmode test.  I didn't try hard to debug, as that
test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.

I can't for the life of me figure out how to get Makefile variables to do what I
want, so for now I'm going to drop the x86 change so as not to block the rest of
the stuff I've got applied.

I'll keep the rest applied, so just resubmit the x86 patch against kvm-x86/next.

FWIW, conceptually I think we want something like this:

diff --git a/x86/Makefile.common b/x86/Makefile.common
index be18a77a..65e41578 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -44,6 +44,7 @@ COMMON_CFLAGS += -O1
 KEEP_FRAME_POINTER := y
 
 ifneq ($(KEEP_FRAME_POINTER),)
+ifneq ($(no_profiling),y)
 # Fake profiling to force the compiler to emit a frame pointer setup also in
 # leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
 #
@@ -53,6 +54,7 @@ ifneq ($(KEEP_FRAME_POINTER),)
 # during compilation makes this do "The Right Thing."
 LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
 endif
+endif
 
 FLATLIBS = lib/libcflat.a
 
@@ -120,6 +122,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o $(SRCDIR)/$(TEST_DIR)/realmode.
        $(LD) -m elf_i386 -nostdlib -o $@ \
              -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $(filter %.o, $^)
 
+$(TEST_DIR)/realmode.o: no_profiling = y
 $(TEST_DIR)/realmode.o: bits = $(realmode_bits)
 
 $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o

> > [3/4] arm64: Better backtraces for leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/da1804215c8e
> > [4/4] arm: Fix backtraces involving leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/c885c94f523e
> > 
> > --
> > https://github.com/kvm-x86/kvm-unit-tests/tree/next
> 
