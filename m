Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225F38F656;
	Wed, 11 Mar 2026 22:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773267503; cv=none; b=WlZ7YScgKGl4ErutLt49psV+o1KhO+6ZKbR3/mIC5gH0UX572P1U4Ta2w0zlaj5tRGKfkTI7EAArzVvL+sk97YUc33QNHMoIJIO/hgSHfTBk5BEL8ol4g0qb2qp/Y6OctH//i0etOH0m2e6dyRpNnM2xpf4CtsgmsF8jPWfYsFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773267503; c=relaxed/simple;
	bh=UkcWuDDKFCtOzPMcaQPRi4iOunlDeFvQXT87qyfDCmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUNPSnhOObjdoNf//tdmnYLXO8O/ik05STcVVtgL8omu7A7OfcM45NTJIilyebHnziCsBcyp93bITg9iQi2yc5ZGIGLxuIRfqsFIQmvJQKBFd7/r8hYwUrnqzVS/fAGyCX/PEm5CY8lOgp8izucTqAP+vITNO12WQe3CrRVgaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9J3sgLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9J3sgLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89708C4CEF7;
	Wed, 11 Mar 2026 22:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773267502;
	bh=UkcWuDDKFCtOzPMcaQPRi4iOunlDeFvQXT87qyfDCmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9J3sgLA9S//wXI5sCKh7YLMqn41GDJmYfc598b7ndkFh8SDdWL+zRt5FfHTApL1t
	 eFw4mxiTQ52uHOiZnwnfhQkLZZ69FGf+Omdav3EFSFZvGLzDVaBr6C3Rjwngxabxwz
	 d+0JasLxpFrmuqlAqg/17icDaUayGe59gigm4h+zHWLCUCAAoz9z33wVCRN3oC28+B
	 I4sw7mxR8qx/+1CrghYdwu7qyQ4Nhd5ot4eqj1gDAOhg3ejLRDXDKaDXhl85fG3i4o
	 mrUjtO5XPJyLmYaTqf1esEqls3WQjEw/BgecuDmQ9+r0WBP4atyMefSKeR4bZ5orPU
	 G2ybt0con6eMw==
Date: Wed, 11 Mar 2026 15:18:16 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
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
Message-ID: <20260311221816.GA316631@ax162>
References: <20260309162516.2623589-1-vdonnefort@google.com>
 <20260309162516.2623589-19-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309162516.2623589-19-vdonnefort@google.com>

Hi Vincent,

On Mon, Mar 09, 2026 at 04:25:04PM +0000, Vincent Donnefort wrote:
> The simple_ring_buffer implementation must remain simple enough to be
> used by the pKVM hypervisor. Prevent the object build if unresolved
> symbols are found.
> 
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index d106beca8d7f..3182e1bc1cf7 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -132,4 +132,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
>  obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
>  obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  
> +#
> +# simple_ring_buffer is used by the pKVM hypervisor which does not have access
> +# to all kernel symbols. Fail the build if forbidden symbols are found.
> +#
> +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> +UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> +
> +quiet_cmd_check_undefined = NM      $<
> +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"

This check triggers when building allmodconfig targeting arm, arm64,
powerpc, and x86_64 (at least, I did not test more at the moment) with
clang. If this is a hard failure, this really needs to print something
out to the developer/user to help them debug off the bat, versus having
to manually dig the $(NM) command out from the .cmd file or V=1. I came
up with

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 3182e1bc1cf7..c725b06876bc 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -141,7 +141,13 @@ UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sani
 UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
 
 quiet_cmd_check_undefined = NM      $<
-      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+      cmd_check_undefined = \
+          undefsyms=$$($(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST) || true); \
+          if [ -n "$$undefsyms" ]; then \
+              echo "Unexpected symbols in $<:" >&2; \
+              echo "$$undefsyms" >&2; \
+              false; \
+          fi
 
 $(obj)/%.o.checked: $(obj)/%.o FORCE
 	$(call if_changed,check_undefined)
--

which prints

  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
                   U llvm_gcda_emit_arcs
                   U llvm_gcda_emit_function
                   U llvm_gcda_end_file
                   U llvm_gcda_start_file
                   U llvm_gcda_summary_info
                   U llvm_gcov_init

for arm64, which makes sense since these are LLVM specific GCOV symbols,
so they should probably get the same treatment as the other ones:

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c725b06876bc..d464e3aa5bdd 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -136,8 +136,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 # simple_ring_buffer is used by the pKVM hypervisor which does not have access
 # to all kernel symbols. Fail the build if forbidden symbols are found.
 #
-UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
-UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
+UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
 UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
 
 quiet_cmd_check_undefined = NM      $<
--

For x86_64, I see

  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
                   U __clear_pages_unrolled
                   U __memmove
                   U copy_page

which comes from the use of KCFI_ADDRESSABLE(), since allmodconfig has
CONFIG_CFI=y.

For powerpc (with both clang and GCC), I see

  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
                   U .TOC.

For arm (with both clang and GCC), I see

  Unexpected symbols in kernel/trace/simple_ring_buffer.o:
           U __stack_chk_guard
           U warn_slowpath_fmt

Presumably adding all of those should be fine as well?

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d464e3aa5bdd..4f120cb8c79c 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -137,7 +137,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 # to all kernel symbols. Fail the build if forbidden symbols are found.
 #
 UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov llvm_gcda llvm_gcov
-UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST += __aeabi_unwind __stack_chk_fail __stack_chk_guard stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST += \.TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
 UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
 
 quiet_cmd_check_undefined = NM      $<
--

I don't mind sending a series for these, I just wanted to make sure I
was reasoning about everything correctly.

Cheers,
Nathan
