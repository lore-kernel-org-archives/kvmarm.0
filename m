Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8413D9DAF;
	Thu, 12 Mar 2026 23:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359518; cv=none; b=fNk1DU3h9ZSUpFEgu4EgQaXIwht5hupHpqskzyjeN00MnCbgYHsjTqseHBsQMwpLLym2HEEo/zIhFORLD9MnNMwQftc3ZubXKXwlNZ4eUwTGAfotsRJW1gBZHISW22T+D8ZLrEnx0btLMLYVtC09QK15TzQns3CpAAwrzxxG6B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359518; c=relaxed/simple;
	bh=qD/7CdUR0FWQsy1MPlTTxVBHiQ9FN1ndBxO1HK0Fr3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfcfSCj1UhOujdFWMiz4WxlK8uTa/cFmu39kBKV16EhdrhfTyM5b6v6hufoLxaPG5Z4+ZcJ+iPNaINn8CnGan9MPaXXV60zPPyZ/mxwPrefK6/gwpfkz5XvA0aAhhK76UsZgQByZN0tfztX+MZopv0FffVratixXAm7cVDm6DQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZNspkYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZNspkYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C61CC4CEF7;
	Thu, 12 Mar 2026 23:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773359517;
	bh=qD/7CdUR0FWQsy1MPlTTxVBHiQ9FN1ndBxO1HK0Fr3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UZNspkYoKLw42etkuga7S8rATF+lLguXC6ojsSBBDb7AiOYPywY2WrZZELLNLK3cR
	 /h4I4hFjhAb/UxzqOG7/2xC7OQM6O59c3PyIEWUU2qvYpc5L8xWeTj/hiywgG9xISD
	 /nqtFoA0no+2aN12rv+vIj3SneQQ7F159NWyl1dtdj1M/FdxUwQJOFFVJp22NV2Lxd
	 r5BDMhsilc/woqZa02OEzGTEiuiGBfJFo9g1ha945FZwNKa1wWt2oTvYMefHI/kXNW
	 8bQHdHrVdmEq2VzG2XpoMX2t8pEjzpx2Pt0geuU2ygArByrT1NSBlGWLk90diJCo5M
	 mJqL7A9jzz3hw==
Date: Thu, 12 Mar 2026 16:51:53 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, rostedt@goodmis.org, arnd@arndb.de,
	linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Message-ID: <20260312235153.GA1147071@ax162>
References: <20260312182010.111013-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312182010.111013-1-vdonnefort@google.com>

Hi Vincent,

On Thu, Mar 12, 2026 at 06:20:10PM +0000, Vincent Donnefort wrote:
> Compiler and tooling-generated symbols are difficult to maintain
> across all supported architectures. Make the allowlist more robust by
> replacing the harcoded list with a mechanism that automatically detects
> these symbols.
> 
> This mechanism generates a C function designed to trigger common
> compiler-inserted symbols.

This certainly seems more robust.

> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index beb15936829d..3b427b76434a 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -136,17 +136,37 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
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
> +$(obj)/undefsyms_base.c: FORCE
> +	$(Q)echo '#include <asm/page.h>' > $@
> +	$(Q)echo '#include <asm/local.h>' >> $@
> +	$(Q)echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);' >> $@
> +	$(Q)echo 'void undefsyms_base(int n);' >> $@
> +	$(Q)echo 'void undefsyms_base(int n) {' >> $@
> +	$(Q)echo '	char buffer[256] = { 0 };' >> $@
> +	$(Q)echo '	u32 u = 0;' >> $@
> +	$(Q)echo '	memset((char * volatile)page, 8, PAGE_SIZE);' >> $@
> +	$(Q)echo '	memset((char * volatile)buffer, 8, sizeof(buffer));' >> $@
> +	$(Q)echo '	cmpxchg((u32 * volatile)&u, 0, 8);' >> $@
> +	$(Q)echo '	WARN_ON(n == 0xdeadbeef);' >> $@
> +	$(Q)echo '}' >> $@

This should use filechk, otherwise undefsyms_base.c will be regenerated
every build, resulting in undefsyms_base.o being rebuilt every time.

  $ make -skj"$(nproc)" ARCH=x86_64 mrproper allmodconfig kernel/trace/

  $ make -skj"$(nproc)" ARCH=x86_64 V=2 kernel/trace/
  ...
    CC      kernel/trace/undefsyms_base.o - due to: kernel/trace/undefsyms_base.c
    NM      kernel/trace/simple_ring_buffer.o - due to target missing

filechk_undefsyms_base = {                                              \
	echo '$(pound)include <asm/page.h>';                            \
	echo '$(pound)include <asm/local.h>';                           \
	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);';       \
	echo 'void undefsyms_base(int n);';                             \
	echo 'void undefsyms_base(int n) {';                            \
	echo '	char buffer[256] = { 0 };';                             \
	echo '	u32 u = 0;';                                            \
	echo '	memset((char * volatile)page, 8, PAGE_SIZE);';          \
	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));';   \
	echo '	cmpxchg((u32 * volatile)&u, 0, 8);';                    \
	echo '	WARN_ON(n == 0xdeadbeef);';                             \
	echo '}';                                                       \
	}

$(obj)/undefsyms_base.c: FORCE
	$(call filechk,undefsyms_base)

  $ make -skj"$(nproc)" ARCH=x86_64 mrproper allmodconfig kernel/trace/

  $ make -skj"$(nproc)" ARCH=x86_64 V=2 kernel/trace/
    GEN     Makefile - due to target is PHONY
    DESCEND objtool
    CALL    scripts/checksyscalls.sh - due to target is PHONY
    INSTALL libsubcmd_headers
    NM      kernel/trace/simple_ring_buffer.o - due to target missing

> +clean-files += undefsyms_base.c
> +targets += undefsyms_base.c

I don't think this targets addition is necessary.

> +$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
> +
> +extra-y += undefsyms_base.o

I think this should be

  targets += undefsyms_base.o

as extra-y is deprecated per Documentation/kbuild/makefiles.rst.

> +UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
> +		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')

With an allmodconfig + ThinLTO build, I still see:

  $ cat allmod.config
  CONFIG_GCOV_KERNEL=n
  CONFIG_KASAN=n
  CONFIG_LTO_CLANG_THIN=y

  $ make -skj"$(nproc)" ARCH=x86_64 KCONFIG_ALLCONFIG=1 LLVM=1 mrproper allmodconfig kernel/trace/
  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
                   U __fortify_panic
                   U __write_overflow_field
                   U simple_ring_buffer_commit
                   U simple_ring_buffer_enable_tracing
                   U simple_ring_buffer_init
                   U simple_ring_buffer_reserve
                   U simple_ring_buffer_reset
                   U simple_ring_buffer_swap_reader_page
                   U simple_ring_buffer_unload

Something like:

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 48c415a0c7e4..0f9a6ce9abd9 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -142,13 +142,15 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 filechk_undefsyms_base = {                                              \
 	echo '$(pound)include <asm/page.h>';                            \
 	echo '$(pound)include <asm/local.h>';                           \
+	echo '$(pound)include <linux/string.h>';                        \
 	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);';       \
-	echo 'void undefsyms_base(int n);';                             \
-	echo 'void undefsyms_base(int n) {';                            \
+	echo 'void undefsyms_base(int n, void *ptr);';                  \
+	echo 'void undefsyms_base(int n, void *ptr) {';                 \
 	echo '	char buffer[256] = { 0 };';                             \
 	echo '	u32 u = 0;';                                            \
 	echo '	memset((char * volatile)page, 8, PAGE_SIZE);';          \
 	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));';   \
+	echo '	memcpy((void* volatile)ptr, buffer, sizeof(buffer));';  \
 	echo '	cmpxchg((u32 * volatile)&u, 0, 8);';                    \
 	echo '	WARN_ON(n == 0xdeadbeef);';                             \
 	echo '}';                                                       \
--

cures the first two. The simple_ring_buffer symbols are very odd...

  $ llvm-nm kernel/trace/simple_ring_buffer.o | grep simple_ring_buffer
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_commit_845
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_enable_tracing_849
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_init_847
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_reserve_841
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_reset_846
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_swap_reader_page_837
  ---------------- d __UNIQUE_ID_addressable_simple_ring_buffer_unload_848
  ---------------- t __export_symbol_simple_ring_buffer_commit
  ---------------- t __export_symbol_simple_ring_buffer_enable_tracing
  ---------------- t __export_symbol_simple_ring_buffer_init
  ---------------- t __export_symbol_simple_ring_buffer_reserve
  ---------------- t __export_symbol_simple_ring_buffer_reset
  ---------------- t __export_symbol_simple_ring_buffer_swap_reader_page
  ---------------- t __export_symbol_simple_ring_buffer_unload
  ---------------- T simple_ring_buffer_commit
                   U simple_ring_buffer_commit
  ---------------- T simple_ring_buffer_enable_tracing
                   U simple_ring_buffer_enable_tracing
                   U simple_ring_buffer_init
  ---------------- T simple_ring_buffer_init
  ---------------- T simple_ring_buffer_init_mm
  ---------------- T simple_ring_buffer_reserve
                   U simple_ring_buffer_reserve
  ---------------- T simple_ring_buffer_reset
                   U simple_ring_buffer_reset
                   U simple_ring_buffer_swap_reader_page
  ---------------- T simple_ring_buffer_swap_reader_page
                   U simple_ring_buffer_unload
  ---------------- T simple_ring_buffer_unload
  ---------------- T simple_ring_buffer_unload_mm

This is LLVM IR bitcode at this stage, which could be messing things up.

  $ file kernel/trace/simple_ring_buffer.o
  kernel/trace/simple_ring_buffer.o: LLVM IR bitcode

Maybe not worth thinking about too much and just adding it to the
allowlist manually?

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 0f9a6ce9abd9..cb1ec50a8386 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -166,6 +166,7 @@ $(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
 targets += undefsyms_base.o
 
 UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
+		       simple_ring_buffer \
 		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
--

Cheers,
Nathan
