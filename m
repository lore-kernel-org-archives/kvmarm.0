Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E90738CFFF;
	Fri, 13 Mar 2026 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773419849; cv=none; b=R1Pk1S0yk0/BxIWGY3S9g5mn8mOomHLwqbP+1DxFcmkwS6L3G7kA3Q/bL3y9Xw32L/W3vTGn/vOb/65P4LUn1s8pg0XJhWXAVhQJOw46pGFZfg3jE1hfWPB3q8D2ZWUDhD3MiPDXMdkOuBplUo8CDhf7xdcu0Lwb+veSe8xcINI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773419849; c=relaxed/simple;
	bh=+p7K7t+lqKRI/HEx+sFaMdgIdBTU2hDoEqIoEciXQqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5wgHop5guyT4lmzvFKkn2eYsmBfPkX009kPyDx0vbyIHxJySTrmvHP2+N49B6sHfzny1aSRymx+npOhFUuIf0Wbwyaajlae5Z30Tu8AV+encmZESoIK44tNikgHb7HSra8ZB1vwZXnzYZvuLKDSjGozuxccfZknDEIlACLGbw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9t7jYSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9t7jYSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5375C19421;
	Fri, 13 Mar 2026 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773419849;
	bh=+p7K7t+lqKRI/HEx+sFaMdgIdBTU2hDoEqIoEciXQqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y9t7jYSXb3E2gURWOtsG8nDT4lxlXyOjNSD1SWiKmKUE8R+65TgwKKdSRTak/gNVB
	 Eccrvvbc3joPxt9wA+0/V6OcyATwvkjQzX3jCJNct+8PmFHyxnJOmpZHfW4uu5WqNw
	 koqnkajz1sXX3qtkOPzbQI4n3MYq2h/rap2rTAUT2ymqZU858vLwfpK9JfvIgMY+XQ
	 VMbDp14B1HQIWwQi8Q+r2+t8HMjvuZEpzaT7IG4STs7S/2rgnYNTPlTGmeRm/Tigz0
	 6z7v8PkdG9tdVjyGg5qzuWjz/pu9+qFsBSOpLHaNr5v2/udpq6EpTwgCArM2daTowT
	 IRqQOLhAwO29Q==
Date: Fri, 13 Mar 2026 09:37:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, rostedt@goodmis.org, arnd@arndb.de,
	linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v2] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Message-ID: <20260313163724.GA2573924@ax162>
References: <20260313105829.1214123-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313105829.1214123-1-vdonnefort@google.com>

On Fri, Mar 13, 2026 at 10:58:29AM +0000, Vincent Donnefort wrote:
> Compiler and tooling-generated symbols are difficult to maintain
> across all supported architectures. Make the allowlist more robust by
> replacing the harcoded list with a mechanism that automatically detects
> these symbols.
> 
> This mechanism generates a C function designed to trigger common
> compiler-inserted symbols.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> ---
> 
> Changes in v2:
> 
>   - Use filechk (Nathan)
>   - Removed deprecated extra-y (Nathan)
>   - Added simple_ring_buffer in allowlist (Nathan)
>   - Added memcpy() to generate more symbols (Nathan)
>   - Added __sancov 
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index beb15936829d..96627a909ecc 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -136,17 +136,42 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  # simple_ring_buffer is used by the pKVM hypervisor which does not have access
>  # to all kernel symbols. Fail the build if forbidden symbols are found.
>  #
> -UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> -UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer llvm_gcda llvm_gcov
> -UNDEFINED_ALLOWLIST += .TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
> -UNDEFINED_ALLOWLIST += ftrace_likely_update __hwasan_load __hwasan_store __hwasan_tag_memory
> -UNDEFINED_ALLOWLIST += warn_bogus_irq_restore __stack_chk_guard
> -UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> +# undefsyms_base generates a set of compiler and tooling-generated symbols that can
> +# safely be ignored for simple_ring_buffer.
> +#
> +filechk_undefsyms_base = \
> +	echo '$(pound)include <linux/atomic.h>'; \
> +	echo '$(pound)include <linux/string.h>'; \
> +	echo '$(pound)include <asm/page.h>'; \
> +	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);'; \
> +	echo 'void undefsyms_base(void *p, int n);'; \
> +	echo 'void undefsyms_base(void *p, int n) {'; \
> +	echo '	char buffer[256] = { 0 };'; \
> +	echo '	u32 u = 0;'; \
> +	echo '	memset((char * volatile)page, 8, PAGE_SIZE);'; \
> +	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));'; \
> +	echo '	memcpy((void * volatile)p, buffer, sizeof(buffer));'; \
> +	echo '	cmpxchg((u32 * volatile)&u, 0, 8);'; \
> +	echo '	WARN_ON(n == 0xdeadbeef);'; \
> +	echo '}'
> +
> +$(obj)/undefsyms_base.c: FORCE
> +	$(call filechk,undefsyms_base)
> +
> +clean-files += undefsyms_base.c
> +
> +$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
> +
> +targets += undefsyms_base.o
> +
> +UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitizer __tsan __ubsan __x86_indirect_thunk \
> +		      simple_ring_buffer \
> +		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
>  
>  quiet_cmd_check_undefined = NM      $<
> -      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST))`"
>  
> -$(obj)/%.o.checked: $(obj)/%.o FORCE
> +$(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
>  	$(call if_changed,check_undefined)
>  
>  always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked
> 
> base-commit: 33f2e266515717c4b2df585dadefa0525557726c
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

Thanks! This is almost perfect for my tests, one final thing that I
noticed as a result of my full overnight builds. For ARCH=riscv (and
some other architectures from a quick grep), there is some logic in
their include/asm/string.h files to avoid FORTIFY_SOURCE when KASAN is
enabled for the entire build but not enabled for the particular file. As
undefsyms_base.o is not linked into vmlinux or modules, it does not
automatically have KASAN enabled.

  $ cat allmod.config
  CONFIG_GCOV_KERNEL=n
  CONFIG_LTO_CLANG_THIN=y
  CONFIG_WERROR=n

  $ make -skj"$(nproc)" ARCH=riscv KCONFIG_ALLCONFIG=1 LLVM=1 mrproper allmodconfig kernel/trace/
  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
                   U __fortify_panic
                   U __write_overflow_field
  ...

This cures that for me.

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 260382f62dbf..55af887a90e2 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -164,6 +164,11 @@ $(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
 
 targets += undefsyms_base.o
 
+# ensure KASAN is enabled to avoid logic that may disable FORTIFY_SOURCE when
+# KASAN is not enabled. undefsyms_base.o does not automatically get KASAN flags
+# because it is not linked into vmlinux.
+KASAN_SANITIZE_undefsyms_base.o := y
+
 UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitizer __tsan __ubsan __x86_indirect_thunk \
 		      simple_ring_buffer \
 		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
--

With that addressed:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

Cheers,
Nathan
