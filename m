Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD335A3B7
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773324477; cv=none; b=QoY5BYY5JpZOZwmbQi91WY8FXxESkhmgXoM/ZWKllLKiKlXCLcm+MBP6gLFojoGb42CGw11f0EogAsJe0g/bgZC2eQplleuni5d+Rm40h7G22ublyFgaTmcsXb8N+ewZIIfBMZUi2hJTNTf8FZjaTg1Y2n2+BVDsL5By5O+PaGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773324477; c=relaxed/simple;
	bh=je2Su01mUc5JDXpVVT4CNHVYbw70OhSPnxJmGcuocjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECtN0reMFk0Jwsiw8LIDlUvWUkqBnm7ZAAgxqfnCdpI6BFbkcFCGZzE7AjXTgphjGgA0pTSZXWrv/Sx9gGgVRrHZr+TkEbr9jQ+mStUi/TwTHMrDWAo9TBaPKeXgrQaxAznHteXRzqbJ7JkpzTX4pqLQOYzhXTNydJ/o5Zf1x1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J0jzJepa; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J0jzJepa"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439b8a3f2bcso867661f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 07:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773324471; x=1773929271; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=viC1gPLlOGctSWu83HWjGEsXF70NJAe1D+sqpq58byY=;
        b=J0jzJepat0esCiXI5E6BRliTPG+fJogxVyL/LAwVmp7cUq65oRs8IRcfL1LnQqgHQw
         ZWE8G/hLTnWBAUND29lbcbE7JusUdhswmi/fErXgRFvDkkTgfimxpJxABBHKq7eDZd0e
         XO+cfkX5DLzBn9BLePLiu9N5L6e+pWqOIEwQrsFqsc8xDIOXcP4wu8gvegH5D5oLmQG9
         qjoxPYx9+P5Apb2F7T8QEMZNMXK2rF1Do2MUPUJSJS5Bt4p8QbmsYg/rr+gRN8ACOcJW
         eL7469AwFYnOqIHVYOyJbIGT4tlUKjNrPIj4WjhhdFI9VVDOeRJ/BDW9q//oxIiJDC/k
         f2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773324471; x=1773929271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viC1gPLlOGctSWu83HWjGEsXF70NJAe1D+sqpq58byY=;
        b=Qz7mA4NlTKw3L1ypAVu3BYhX/BKJdxY4W50ZemITyhKU7Vc+SWv6q4CK0e9SbbvLQq
         9hvZTiXokJKddnrO1K41MktSh2R/N4AjfEu/yBlW9UsYZ6Q430JWD9Na14n5i8JjjS44
         bU8TZgvJs3b69i3nK8AATerTz3lx6ara0NhfV471YN6ROVDJVeM405zJMRNkbQWxkDt/
         JhCrbB0UIOB9FYtAAr6eF80b7rjpN1hmmq7KLiPDZMoy0VjNNKi2pi2NWh2vJhw92J2F
         1JGqK+B94awWUAidcTn3LUVpFNoWBMm1bCNBWE0TCGWOsZUV47HxvlpINw4BE/nwiLYu
         TwiA==
X-Forwarded-Encrypted: i=1; AJvYcCXoqzxwfJDKvSC1FBeQASIjB1rT03eEZVFEkUfsAeMJYV+vOK25dipeDxcVjA5Jn6R1FarjaKA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGfkpzDCk6kAc0/VrhvyvJCF/u+W2jJOow2WjdPmwCXLuUomY7
	jEDdMa1CuGUXFM/OO+dboF9mmQXpclX9tGLVFj9PFSJ40FEaWArgu0YEukKVAAypZw==
X-Gm-Gg: ATEYQzxM5p1E1pNLmjJXfxcNrXPxmeXecYCe5zGGG/VDv6qbuUz2V462UpgPrEdGJCl
	e/wqGKnjqrWL4+22Dzyhnm5JOKs9mRyZ2gQ9HSDE+lbg5OacPajFx/2XAyrhvZ94xB+52OPhwYY
	8TB7b7pDZ/6cFexwGMfPVbSO6qFexD2zK0uQlsRl3gLxjGLXkb7FAb05q9ipOjd0d/hYuuiNyxS
	oYBL0Z/atSQ1Cmz9YDP7TP+cQ1136nNcSGgpAVfajVyrHpMVFt0JFdyFiUN3FpK/w4Ybbv2fLR+
	WTiz39ngo+C5c7rYbZzzYNkW30CN8sgnh2N43WCV2iri9p8wOaNVUaehuvidR+8LXEnrKrcaZFy
	Ujr0OsMPleBEfnCWHNRRHlhZUf+9uwVWYzZxjT6QRj8S3bMIdEkIjpeeR/zijH3BEC6i318e7Me
	k6ExetGSvnBFgUnTWak9nFXoe1ykmgvTXywuVssK84jMI+zOzHNpLM2zO9I/fPbn7IbQiu+SEoc
	+hpJA==
X-Received: by 2002:a05:6000:2012:b0:439:cb20:f30c with SMTP id ffacd0b85a97d-439f81c77c9mr13119179f8f.23.1773324470601;
        Thu, 12 Mar 2026 07:07:50 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a76e5sm8108613f8f.12.2026.03.12.07.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:07:50 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:07:46 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	jstultz@google.com, qperret@google.com, will@kernel.org,
	aneesh.kumar@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 18/30] tracing: Check for undefined symbols in
 simple_ring_buffer
Message-ID: <abLIslqIcVscZRFg@google.com>
References: <20260309162516.2623589-1-vdonnefort@google.com>
 <20260309162516.2623589-19-vdonnefort@google.com>
 <20260311221816.GA316631@ax162>
 <abJ_cm_yM3Q-99GL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abJ_cm_yM3Q-99GL@google.com>

On Thu, Mar 12, 2026 at 08:55:14AM +0000, Vincent Donnefort wrote:
> On Wed, Mar 11, 2026 at 03:18:16PM -0700, Nathan Chancellor wrote:
> > Hi Vincent,
> > 
> > On Mon, Mar 09, 2026 at 04:25:04PM +0000, Vincent Donnefort wrote:
> > > The simple_ring_buffer implementation must remain simple enough to be
> > > used by the pKVM hypervisor. Prevent the object build if unresolved
> > > symbols are found.
> > > 
> > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > > 
> > > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > > index d106beca8d7f..3182e1bc1cf7 100644
> > > --- a/kernel/trace/Makefile
> > > +++ b/kernel/trace/Makefile
> > > @@ -132,4 +132,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
> > >  obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
> > >  obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
> > >  
> > > +#
> > > +# simple_ring_buffer is used by the pKVM hypervisor which does not have access
> > > +# to all kernel symbols. Fail the build if forbidden symbols are found.
> > > +#
> > > +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> > > +UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> > > +UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> > > +
> > > +quiet_cmd_check_undefined = NM      $<
> > > +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> > 
> > This check triggers when building allmodconfig targeting arm, arm64,
> > powerpc, and x86_64 (at least, I did not test more at the moment) with
> > clang. If this is a hard failure, this really needs to print something
> > out to the developer/user to help them debug off the bat, versus having
> > to manually dig the $(NM) command out from the .cmd file or V=1. I came
> > up with
> > 
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index 3182e1bc1cf7..c725b06876bc 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -141,7 +141,13 @@ UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sani
> >  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> >  
> >  quiet_cmd_check_undefined = NM      $<
> > -      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> > +      cmd_check_undefined = \
> > +          undefsyms=$$($(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST) || true); \
> > +          if [ -n "$$undefsyms" ]; then \
> > +              echo "Unexpected symbols in $<:" >&2; \
> > +              echo "$$undefsyms" >&2; \
> > +              false; \
> > +          fi
> >  
> >  $(obj)/%.o.checked: $(obj)/%.o FORCE
> >  	$(call if_changed,check_undefined)
> > --
> > 
> > which prints
> > 
> >   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
> >                    U llvm_gcda_emit_arcs
> >                    U llvm_gcda_emit_function
> >                    U llvm_gcda_end_file
> >                    U llvm_gcda_start_file
> >                    U llvm_gcda_summary_info
> >                    U llvm_gcov_init
> > 
> > for arm64, which makes sense since these are LLVM specific GCOV symbols,
> > so they should probably get the same treatment as the other ones:
> > 
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index c725b06876bc..d464e3aa5bdd 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -136,8 +136,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
> >  # simple_ring_buffer is used by the pKVM hypervisor which does not have access
> >  # to all kernel symbols. Fail the build if forbidden symbols are found.
> >  #
> > -UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> > -UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> > +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
> > +UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> >  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> >  
> >  quiet_cmd_check_undefined = NM      $<
> > --
> > 
> > For x86_64, I see
> > 
> >   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
> >                    U __clear_pages_unrolled
> >                    U __memmove
> >                    U copy_page
> > 
> > which comes from the use of KCFI_ADDRESSABLE(), since allmodconfig has
> > CONFIG_CFI=y.
> > 
> > For powerpc (with both clang and GCC), I see
> > 
> >   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
> >                    U .TOC.
> > 
> > For arm (with both clang and GCC), I see
> > 
> >   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
> >            U __stack_chk_guard
> >            U warn_slowpath_fmt
> > 
> > Presumably adding all of those should be fine as well?
> > 
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index d464e3aa5bdd..4f120cb8c79c 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -137,7 +137,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
> >  # to all kernel symbols. Fail the build if forbidden symbols are found.
> >  #
> >  UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
> > -UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> > +UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail __stack_chk_guard stackleak_track_stack __ref_stack __sanitizer
> > +UNDEFINED_ALLOWLIST += \.TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
> >  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> >  
> >  quiet_cmd_check_undefined = NM      $<
> > --
> > 
> > I don't mind sending a series for these, I just wanted to make sure I
> > was reasoning about everything correctly.
> 
> Yes this is all fine. If you have something already, please send it. Meanwhile, I'll try
> something a bit more durable. 
> 
> Thanks,
> Vincent

In the end to unblock linux-next I have already sent an updated list of symbols.
However feel free to send the logging bit, that is surely useful.

> 
> > 
> > Cheers,
> > Nathan
