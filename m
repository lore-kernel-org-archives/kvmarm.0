Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51038B154
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773305721; cv=none; b=JvEeMwOeQwwZoInjlLS18jbC8CSQR4LwpPADTEYHOgFkexdtOenisg/1NS5he3A8Mec511KIcVLmVAHl3FLu27Vljj/QTMO8cfZx0vDacVwskmiaRnDQsY7pgaJvmDGE27hX9I+kf9Zgp8VmKs4lXdlsWVNEIVPFihMrXpGUkl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773305721; c=relaxed/simple;
	bh=/3vdoFQ6xBKuMKdZ3izMz8e4s2bhLnzcXpE/ttaYt/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1Z50xcT+RsCsaEKDaQqdXMxjcTtuKBaA85WtYaZX/L+Rtzwotvu1DpU5+FCoZD/Fo8mUj95P8Y9MnnvXX0j4v9Y1jiGUgtadJF5BlPK5kk0VYB8Q/XwhtZ+gX9rVwlwJxZQwKUqxEsMVkFZ6SXwbqZuNHds3RJtKXGDO4W+VbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tIPorZlQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tIPorZlQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-483487335c2so5727155e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 01:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773305719; x=1773910519; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6m3iVjAJ3GnbX16/A8yr0Uv8IZ6KsZjKuUcZqEbIVJA=;
        b=tIPorZlQFMHG1+uHPdWzBG8ePLpjFzjWpuB00fTK5exzGHwH+roqW8y6j2v1Z8FWvO
         uikhSB0Qv/SAu9FU+dz2HcnKuOBFOe0OkRpjmgXnHdwzs43lfFj2MP+kXs5Tejrcl0p8
         zfj255fhWkplbQj0T+lArJtfeyFvgCbcjVrs5iDVWlhwlydX0zEwIg99f+zE54wtyUoo
         BCvr9TneCYY+ieY2q4TnsscbHKpgILWvohcXBUduZPFc6QRGHyXtWtuHNVAWls5eBrwN
         iwER/u1ohXNiJ/0dEIDIpNr8QegfK/UPI2JvsX7K7iEEU/zD3tavBGJ8L4nFdKhVkzGk
         kWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773305719; x=1773910519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6m3iVjAJ3GnbX16/A8yr0Uv8IZ6KsZjKuUcZqEbIVJA=;
        b=ITCLvXQquz99m+Jg1QbyN1SWc8jfaEA46QH2vezv+nlHK2I1Qws+Jk2sVgKrZXJgHD
         EJ9LSXvXrNLfSEcc6ZBJjp6V1KiyhEf4Wy9DsGxwfRaqqpfIZ1V/rZUw6GCTqcHQFHWl
         4PwuTdvcm/bM3ODjha0NtMXOaQtmOKzEk+Dl6U8c/OSvGUG+mznxvnZkuI9V0XYFTpKo
         KVBZ3x1wHEvZLqpughMRGlTzv1+ssbR4iKN8RWcEadvQ4uNVnAIbdyXmeL30944mD/5l
         ZNp1J4ZstjNHt9Yagcby0wVGVzaaUS4EOraZ8ltsuc3aS6tCUy/IOVM4FqYuue2jqsWI
         UMDw==
X-Forwarded-Encrypted: i=1; AJvYcCVrSkejKeaAugyk3aBKP/HGvoImCbcqbUxfQRr3jYJtEMipC1oQYA+vTAPPNw4D9eTwiEsbalY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEXtKwNE49RebSiSRBrDMscNfjvLB8HehKDzAsoJMXbAJr/IRx
	4jq8FekFB/JNYbawoyIoclsiZNIDn5gS5PRgpUkw+FpGInWPHowSOS3QiO9z2uHP1g==
X-Gm-Gg: ATEYQzyiJzipE8j4aRC/buV5eJUqy121//A2geST9uaGwo+tBqWn9wcTNbYIlAOARcN
	CF1WWMpx6vR+6sHFKV9MQLRG39DfKiRc/EEqc7M4fV0r7WBNIYOXUH0Lvy6Dg5kytLeQYExGzHF
	bkZiruQSQ0T8QdK6bYkm9F+g78LbkiTanGV5kgOrgutLuxrmGl1AYEV/3ouIW+FufebSjcI92Sg
	NpjsuT/zJESztRLwI7pO7Nr8oTxEORZxKNQmPCUUacc72StsCUbo68/5UFjA19r7lGQpc4h4ZKT
	TqlMK6ELUMx6Bzp401dfZGLiRWOHdP4g1odMCTfeDlnGeor3F4OLQ3Hw8x9xxNjN3QARJBaV8L6
	XEoB8AQoHRBDEkFvKmdWY4qPgFoOcWnlKYS5Aw7XGdb8fxh0M5HzgNR0vpBrw9AiKNrcEF1fRh7
	SuA9VEOo5wpIi8B5fsCSMiKpQZPNlEiZvrtkFSVYzyGjucia4JcXbzkrv2xqlJ1lO7wPk=
X-Received: by 2002:a05:600c:4455:b0:485:3e6c:aa84 with SMTP id 5b1f17b1804b1-4854b13b3cbmr83483945e9.33.1773305718060;
        Thu, 12 Mar 2026 01:55:18 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b47145dsm110869815e9.0.2026.03.12.01.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 01:55:17 -0700 (PDT)
Date: Thu, 12 Mar 2026 08:55:14 +0000
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
Message-ID: <abJ_cm_yM3Q-99GL@google.com>
References: <20260309162516.2623589-1-vdonnefort@google.com>
 <20260309162516.2623589-19-vdonnefort@google.com>
 <20260311221816.GA316631@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311221816.GA316631@ax162>

On Wed, Mar 11, 2026 at 03:18:16PM -0700, Nathan Chancellor wrote:
> Hi Vincent,
> 
> On Mon, Mar 09, 2026 at 04:25:04PM +0000, Vincent Donnefort wrote:
> > The simple_ring_buffer implementation must remain simple enough to be
> > used by the pKVM hypervisor. Prevent the object build if unresolved
> > symbols are found.
> > 
> > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index d106beca8d7f..3182e1bc1cf7 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -132,4 +132,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
> >  obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
> >  obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
> >  
> > +#
> > +# simple_ring_buffer is used by the pKVM hypervisor which does not have access
> > +# to all kernel symbols. Fail the build if forbidden symbols are found.
> > +#
> > +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> > +UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> > +UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> > +
> > +quiet_cmd_check_undefined = NM      $<
> > +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> 
> This check triggers when building allmodconfig targeting arm, arm64,
> powerpc, and x86_64 (at least, I did not test more at the moment) with
> clang. If this is a hard failure, this really needs to print something
> out to the developer/user to help them debug off the bat, versus having
> to manually dig the $(NM) command out from the .cmd file or V=1. I came
> up with
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 3182e1bc1cf7..c725b06876bc 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -141,7 +141,13 @@ UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sani
>  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
>  
>  quiet_cmd_check_undefined = NM      $<
> -      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> +      cmd_check_undefined = \
> +          undefsyms=$$($(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST) || true); \
> +          if [ -n "$$undefsyms" ]; then \
> +              echo "Unexpected symbols in $<:" >&2; \
> +              echo "$$undefsyms" >&2; \
> +              false; \
> +          fi
>  
>  $(obj)/%.o.checked: $(obj)/%.o FORCE
>  	$(call if_changed,check_undefined)
> --
> 
> which prints
> 
>   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
>                    U llvm_gcda_emit_arcs
>                    U llvm_gcda_emit_function
>                    U llvm_gcda_end_file
>                    U llvm_gcda_start_file
>                    U llvm_gcda_summary_info
>                    U llvm_gcov_init
> 
> for arm64, which makes sense since these are LLVM specific GCOV symbols,
> so they should probably get the same treatment as the other ones:
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index c725b06876bc..d464e3aa5bdd 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -136,8 +136,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  # simple_ring_buffer is used by the pKVM hypervisor which does not have access
>  # to all kernel symbols. Fail the build if forbidden symbols are found.
>  #
> -UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> -UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
> +UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
>  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
>  
>  quiet_cmd_check_undefined = NM      $<
> --
> 
> For x86_64, I see
> 
>   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
>                    U __clear_pages_unrolled
>                    U __memmove
>                    U copy_page
> 
> which comes from the use of KCFI_ADDRESSABLE(), since allmodconfig has
> CONFIG_CFI=y.
> 
> For powerpc (with both clang and GCC), I see
> 
>   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
>                    U .TOC.
> 
> For arm (with both clang and GCC), I see
> 
>   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
>            U __stack_chk_guard
>            U warn_slowpath_fmt
> 
> Presumably adding all of those should be fine as well?
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index d464e3aa5bdd..4f120cb8c79c 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -137,7 +137,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  # to all kernel symbols. Fail the build if forbidden symbols are found.
>  #
>  UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
> -UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail __stack_chk_guard stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST += \.TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
>  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
>  
>  quiet_cmd_check_undefined = NM      $<
> --
> 
> I don't mind sending a series for these, I just wanted to make sure I
> was reasoning about everything correctly.

Yes this is all fine. If you have something already, please send it. Meanwhile, I'll try
something a bit more durable. 

Thanks,
Vincent

> 
> Cheers,
> Nathan
