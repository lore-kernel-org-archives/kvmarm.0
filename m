Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB853750B3
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 10:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773397423; cv=none; b=lb+2163sgv5Fk661wM8n2H3uzE4C1NTJf+Rtwc/IBS2681+YVJWLyid5oSHquY+xjQvGIUqkNKrk6fcEC3P/Xq+fHGXb415422hvltQZIvoV4MELXDMUS9UwvPPWLQtl2WNiTu/L4cLE2PjvFC4/PwwLTtN6wPLJhcp04Ogykkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773397423; c=relaxed/simple;
	bh=fd2r+mdrfBvcRUhOpn16S4IY/cr9EgphYBGD5ZNHn1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npffM2rm7vED4gAyylHYUxo7mnLnzjiNquSwrKmgGWm1y/afYfTchVx1MYQDsbDI71o8wf+lz73LUZ3fR+s7Hjqy5wCNDiJO4GuQ0rZlmIK1iCwyenmlsPsXSsOy8hQOoephZNypRSBqCpIUP1tTORHAg8vEyfRkwVIjyllZyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XBWJ0W27; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XBWJ0W27"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4853fd7b59aso12576155e9.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 03:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773397418; x=1774002218; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfOFaaHh+7PGnBGlLxa6wky8f/wOxRXhX/B9IK4WGUU=;
        b=XBWJ0W27RkKzGzNVogA4HsF0SQJRrVgb5vS3ZLhbd5uvIChJa+GfTbZoOofDE/MElg
         /WCWS3qTJyonbu0JzYMwvrLuNYRGKpcD/QuQW/ZaBbW4FgAmQKbs9qfkH36AiKKCJpcc
         +Ij3q/8HxE/Vh0/jcQGgnBAdirJDLHvk2a1u59Qz70VEzcQ0VWn5wKkxYszTykfkEPqM
         LuJzxIp6Frc2eVixZ/wudrTRbgHx458h+IP4W+kaPQIyLPMR02Ft4h/ODEjRGmPOE6Vo
         u9Z3rsvAddOB3frxhyKnRQIwdkJCuuYGmbOxWe+TdPjj6TkDXTd/MB5St3t2Ts8/Wuep
         TlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773397418; x=1774002218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfOFaaHh+7PGnBGlLxa6wky8f/wOxRXhX/B9IK4WGUU=;
        b=m8rmT1Y99hbzC5qS3dcwbjEuqEor6mKTI/pT1KY8+UJhDNy/weiwAV0IYpvLwl4Dz/
         GJbhXPuDTXRkukdzRn5BjaMFoAeXHc0YPIJJQ9zmFumpC7WWtuAOY1vaf9phe6IXH7E+
         tqIvGU6i1fcK3LkyBTAaL3eVy8+6I7J/4/I0Y77UsRGJ9Lj+ERqoRCV1lhAvZqDzG2cp
         0LLeYcKcqM66aKfQUKytfd9w1X3Hrx4a9JgBHmWOGVB9WmgPaINWkbHFUSfvcRv+raFZ
         ZoZJi2RZOw7lDolhr9G7knFRuT4oOCWw87DtEuGblAXnvPKcNPF7c/wgCHcpXpcEXYew
         eZKA==
X-Forwarded-Encrypted: i=1; AJvYcCUVClNN9rOSIchlZwodhoPSputoJ/8hLvGRg8n6lbbq+qtMWfy86Vuqe4/2KLLftGD0KFW3beQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YymDtfni/zhuQZgC+TnRiBIRSS0oqJK0IYhxbOVL0xDQ1Rx3gzo
	55MYmG3vGII2wawjyy2Ofqcn/sXGGFCqZkKantpzD9z+fnWwjvsDH60GaRkYetmpHQ==
X-Gm-Gg: ATEYQzzKsNQ5XTtOhDtlBi6X4yAZKSue93i21Tb5kstTHpmSBLFgTLPdG7jDPiU2JQ5
	v4iULIthCGaviEO0FH36fzkGne2uluvKF3pRL/ukkk40hBewqS8FKJ2BIvl7CSAcP3dsPKrYKrO
	Iz7IXd5w+7JmAD0VCJl7cV0hIKwp3cMmhf40kkBWmNXihUTVMqZ6vVbcQ9EIqSDUuazRJLaDE2n
	RB6POnYAB2QbIntx1qJRakWSlBcaUo2jUqD0rss/h4ZmKhIJSvhO+5vZwcdDSmTl/oOF1BrW5iw
	KvoUuBjtI8VnGxqMpAQFppFNinhGi/RRDH5YUfkIn/ofCCcltkyVEH8ZEENlpkNfbYSnJ6v0iYp
	4deJOnd67x53mCHQSeMggTpCUNb0xKdRo5m4S79/r3eynsGrtOttIaYezUsNFwWkUCLZ9VYYVmf
	h89BnWLRXpQSq47OuNwZZpQFshtvpAOdWh7ZPKOrXKmAjFnEEByGfBY4UAmwNKLG9wO9s=
X-Received: by 2002:a05:600c:a08c:b0:485:42ba:fc8 with SMTP id 5b1f17b1804b1-485566cdb46mr38569995e9.4.1773397417987;
        Fri, 13 Mar 2026 03:23:37 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f708sm433813545e9.11.2026.03.13.03.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 03:23:37 -0700 (PDT)
Date: Fri, 13 Mar 2026 10:23:34 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: maz@kernel.org, rostedt@goodmis.org, arnd@arndb.de,
	linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Message-ID: <abPlpjwY_fT81B-E@google.com>
References: <20260312182010.111013-1-vdonnefort@google.com>
 <20260312235153.GA1147071@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312235153.GA1147071@ax162>

On Thu, Mar 12, 2026 at 04:51:53PM -0700, Nathan Chancellor wrote:
> Hi Vincent,
> 
> On Thu, Mar 12, 2026 at 06:20:10PM +0000, Vincent Donnefort wrote:
> > Compiler and tooling-generated symbols are difficult to maintain
> > across all supported architectures. Make the allowlist more robust by
> > replacing the harcoded list with a mechanism that automatically detects
> > these symbols.
> > 
> > This mechanism generates a C function designed to trigger common
> > compiler-inserted symbols.
> 
> This certainly seems more robust.
> 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index beb15936829d..3b427b76434a 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -136,17 +136,37 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
> >  # simple_ring_buffer is used by the pKVM hypervisor which does not have access
> >  # to all kernel symbols. Fail the build if forbidden symbols are found.
> >  #
> > -UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> > -UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer llvm_gcda llvm_gcov
> > -UNDEFINED_ALLOWLIST += .TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
> > -UNDEFINED_ALLOWLIST += ftrace_likely_update __hwasan_load __hwasan_store __hwasan_tag_memory
> > -UNDEFINED_ALLOWLIST += warn_bogus_irq_restore __stack_chk_guard
> > -UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> > +# undefsyms_base generates a set of compiler and tooling-generated symbols that can
> > +# safely be ignored for simple_ring_buffer.
> > +#
> > +$(obj)/undefsyms_base.c: FORCE
> > +	$(Q)echo '#include <asm/page.h>' > $@
> > +	$(Q)echo '#include <asm/local.h>' >> $@
> > +	$(Q)echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);' >> $@
> > +	$(Q)echo 'void undefsyms_base(int n);' >> $@
> > +	$(Q)echo 'void undefsyms_base(int n) {' >> $@
> > +	$(Q)echo '	char buffer[256] = { 0 };' >> $@
> > +	$(Q)echo '	u32 u = 0;' >> $@
> > +	$(Q)echo '	memset((char * volatile)page, 8, PAGE_SIZE);' >> $@
> > +	$(Q)echo '	memset((char * volatile)buffer, 8, sizeof(buffer));' >> $@
> > +	$(Q)echo '	cmpxchg((u32 * volatile)&u, 0, 8);' >> $@
> > +	$(Q)echo '	WARN_ON(n == 0xdeadbeef);' >> $@
> > +	$(Q)echo '}' >> $@
> 
> This should use filechk, otherwise undefsyms_base.c will be regenerated
> every build, resulting in undefsyms_base.o being rebuilt every time.
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 mrproper allmodconfig kernel/trace/
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 V=2 kernel/trace/
>   ...
>     CC      kernel/trace/undefsyms_base.o - due to: kernel/trace/undefsyms_base.c
>     NM      kernel/trace/simple_ring_buffer.o - due to target missing
> 
> filechk_undefsyms_base = {                                              \
> 	echo '$(pound)include <asm/page.h>';                            \
> 	echo '$(pound)include <asm/local.h>';                           \
> 	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);';       \
> 	echo 'void undefsyms_base(int n);';                             \
> 	echo 'void undefsyms_base(int n) {';                            \
> 	echo '	char buffer[256] = { 0 };';                             \
> 	echo '	u32 u = 0;';                                            \
> 	echo '	memset((char * volatile)page, 8, PAGE_SIZE);';          \
> 	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));';   \
> 	echo '	cmpxchg((u32 * volatile)&u, 0, 8);';                    \
> 	echo '	WARN_ON(n == 0xdeadbeef);';                             \
> 	echo '}';                                                       \
> 	}
> 
> $(obj)/undefsyms_base.c: FORCE
> 	$(call filechk,undefsyms_base)
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 mrproper allmodconfig kernel/trace/
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 V=2 kernel/trace/
>     GEN     Makefile - due to target is PHONY
>     DESCEND objtool
>     CALL    scripts/checksyscalls.sh - due to target is PHONY
>     INSTALL libsubcmd_headers
>     NM      kernel/trace/simple_ring_buffer.o - due to target missing
> 
> > +clean-files += undefsyms_base.c
> > +targets += undefsyms_base.c
> 
> I don't think this targets addition is necessary.
> 
> > +$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
> > +
> > +extra-y += undefsyms_base.o
> 
> I think this should be
> 
>   targets += undefsyms_base.o
> 
> as extra-y is deprecated per Documentation/kbuild/makefiles.rst.
> 
> > +UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
> > +		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
> 
> With an allmodconfig + ThinLTO build, I still see:
> 
>   $ cat allmod.config
>   CONFIG_GCOV_KERNEL=n
>   CONFIG_KASAN=n
>   CONFIG_LTO_CLANG_THIN=y
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 KCONFIG_ALLCONFIG=1 LLVM=1 mrproper allmodconfig kernel/trace/
>   Unexpected symbols in kernel/trace/simple_ring_buffer.o:
>                    U __fortify_panic
>                    U __write_overflow_field
>                    U simple_ring_buffer_commit
>                    U simple_ring_buffer_enable_tracing
>                    U simple_ring_buffer_init
>                    U simple_ring_buffer_reserve
>                    U simple_ring_buffer_reset
>                    U simple_ring_buffer_swap_reader_page
>                    U simple_ring_buffer_unload
> 
> Something like:
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 48c415a0c7e4..0f9a6ce9abd9 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -142,13 +142,15 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  filechk_undefsyms_base = {                                              \
>  	echo '$(pound)include <asm/page.h>';                            \
>  	echo '$(pound)include <asm/local.h>';                           \
> +	echo '$(pound)include <linux/string.h>';                        \
>  	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);';       \
> -	echo 'void undefsyms_base(int n);';                             \
> -	echo 'void undefsyms_base(int n) {';                            \
> +	echo 'void undefsyms_base(int n, void *ptr);';                  \
> +	echo 'void undefsyms_base(int n, void *ptr) {';                 \
>  	echo '	char buffer[256] = { 0 };';                             \
>  	echo '	u32 u = 0;';                                            \
>  	echo '	memset((char * volatile)page, 8, PAGE_SIZE);';          \
>  	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));';   \
> +	echo '	memcpy((void* volatile)ptr, buffer, sizeof(buffer));';  \
>  	echo '	cmpxchg((u32 * volatile)&u, 0, 8);';                    \
>  	echo '	WARN_ON(n == 0xdeadbeef);';                             \
>  	echo '}';                                                       \
> --
> 
> cures the first two. The simple_ring_buffer symbols are very odd...
> 
>   $ llvm-nm kernel/trace/simple_ring_buffer.o | grep simple_ring_buffer
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_commit_845
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_enable_tracing_849
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_init_847
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_reserve_841
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_reset_846
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_swap_reader_page_837
>   ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_unload_848
>   ---------------- t __export_symbol_simple_ring_buffer_commit
>   ---------------- t __export_symbol_simple_ring_buffer_enable_tracing
>   ---------------- t __export_symbol_simple_ring_buffer_init
>   ---------------- t __export_symbol_simple_ring_buffer_reserve
>   ---------------- t __export_symbol_simple_ring_buffer_reset
>   ---------------- t __export_symbol_simple_ring_buffer_swap_reader_page
>   ---------------- t __export_symbol_simple_ring_buffer_unload
>   ---------------- T simple_ring_buffer_commit
>                    U simple_ring_buffer_commit
>   ---------------- T simple_ring_buffer_enable_tracing
>                    U simple_ring_buffer_enable_tracing
>                    U simple_ring_buffer_init
>   ---------------- T simple_ring_buffer_init
>   ---------------- T simple_ring_buffer_init_mm
>   ---------------- T simple_ring_buffer_reserve
>                    U simple_ring_buffer_reserve
>   ---------------- T simple_ring_buffer_reset
>                    U simple_ring_buffer_reset
>                    U simple_ring_buffer_swap_reader_page
>   ---------------- T simple_ring_buffer_swap_reader_page
>                    U simple_ring_buffer_unload
>   ---------------- T simple_ring_buffer_unload
>   ---------------- T simple_ring_buffer_unload_mm
> 
> This is LLVM IR bitcode at this stage, which could be messing things up.
> 
>   $ file kernel/trace/simple_ring_buffer.o
>   kernel/trace/simple_ring_buffer.o: LLVM IR bitcode
> 
> Maybe not worth thinking about too much and just adding it to the
> allowlist manually?

That looks good, thanks for having a look. I'll spin a v2 with your comments.

> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 0f9a6ce9abd9..cb1ec50a8386 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -166,6 +166,7 @@ $(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
>  targets += undefsyms_base.o
>  
>  UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
> +		       simple_ring_buffer \
>  		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
>  
>  quiet_cmd_check_undefined = NM      $<
> --
> 
> Cheers,
> Nathan
