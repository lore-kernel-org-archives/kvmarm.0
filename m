Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7D3FFABB
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 18:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773341004; cv=none; b=YzVrLzAZog11owamoaG7aky6/cOUL3xVgKdkYnmRuPd+gf6/ngtXn7BLNnIMQbrJqhM/e71rkhTN6yOiNc//IBED+UbSFHaIdeppAPPFeJ5WHzuUvZN7vZ13kp5DSCj4fT6d0uKTbUh6W+IJru1ZeeH+Q0K9M5PwVSyfftFql+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773341004; c=relaxed/simple;
	bh=wNjGkrCgltAtFOqjZc9rAdqyLnP1NHaLJ+DkaO7WvkE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzCxkcTuYZBBh1PT/JICMkdN1NKfFap6WFxq38GNGguul1Y2NLcn7uTtT6sfGMOGcbOWMB58aIOT8xAGbXTqU7Bvvxam/nB/mKZsyvIIL6JsFhXkuH3CB3QgO7V1/pLZjNhMCvMT5kBEVyR8b7S4xIwbC07YxmIUfcnYAXcvbKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2A091A0319;
	Thu, 12 Mar 2026 18:43:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id B7E0C20026;
	Thu, 12 Mar 2026 18:43:19 +0000 (UTC)
Date: Thu, 12 Mar 2026 14:43:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, arnd@arndb.de, nathan@kernel.org,
 linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com
Subject: Re: [PATCH] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Message-ID: <20260312144334.7548a7b8@gandalf.local.home>
In-Reply-To: <20260312182010.111013-1-vdonnefort@google.com>
References: <20260312182010.111013-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: B7E0C20026
X-Stat-Signature: 1qtyh9rbmfjkhn4wtr68fatc181p7cqi
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19aB8bpxPW73ovhyaKYt4xyG81OXKADkdI=
X-HE-Tag: 1773340999-317614
X-HE-Meta: U2FsdGVkX18X7n9dHN8IsqMTT7bI1AT77T3HJN2H4G5TvKG4QgaFH+tgFCT/a/AHHvu9x1wCwF5KpfV1mFr7SJ5CShcMajjldvhIgMOYEZF8mdHgOc2fhNFl1udMR+O1urySRbU03ju0kQpu0nCNMnNFJ96qoQaCp+9vxKueNY/S7vt/Mn5VYanv656H8Z03OSRukNkeWBkNEerEgahiWUqe6HZdyr1TURhAnRqG9kQulgrNkUb9sqXR9hYvHOxUAF9j4X4n+D0oIcA8640IFxFFaRe5GXJtI/BYLmC8woJ903aqsfCaB+tI5paU7EEzsm42GnFqSoC6QIG+HNInYWPZFVxnZhpSSTehADoyzIp5AL6A5znITthQ6ULL2d+V

On Thu, 12 Mar 2026 18:20:10 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

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

Looking at the scripts/Makefile.* files, it looks like the proper way to do
C files is to make it a single command:

Perhaps something like:

$(obj)/undefsyms_base.c: FORCE
	$(Q)(								\
	echo '#include <asm/page.h>';					\
	echo '#include <asm/local.h>';					\
	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);';	\
	echo 'void undefsyms_base(int n);';				\
	echo 'void undefsyms_base(int n) {';				\
	echo '	char buffer[256] = { 0 };';				\
	echo '	u32 u = 0;';						\
	echo '	memset((char * volatile)page, 8, PAGE_SIZE);';		\
	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));';	\
	echo '	cmpxchg((u32 * volatile)&u, 0, 8);';			\
	echo '	WARN_ON(n == 0xdeadbeef);';				\
	echo '}' ) > $@

-- Steve


> +
> +clean-files += undefsyms_base.c
> +targets += undefsyms_base.c
> +
> +$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
> +
> +extra-y += undefsyms_base.o
> +
> +UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
> +		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
>  
>  quiet_cmd_check_undefined = NM      $<
> -      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e ,$(UNDEFINED_ALLOWLIST))`"
>  
> -$(obj)/%.o.checked: $(obj)/%.o FORCE
> +$(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
>  	$(call if_changed,check_undefined)
>  
>  always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked
> 
> base-commit: 33f2e266515717c4b2df585dadefa0525557726c

