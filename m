Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBAEEC5
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 06:15:35 +0000 (UTC)
Date: Mon, 26 Jun 2023 08:15:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687760133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fNF07VoGo26+xilKqlR9Lg2Z/PCRyjJsqNC3ggaqlDE=;
	b=B0LqQENq/ffVQH4/QI+7xzw0SQlH/bxiYYusDkLFDS9Zt7F1rkLB4oCsA/IM/uA0YizPdt
	wHJM6UUUXttNsIp5lPgYhFIirWyKorxMgbVjmDldrNXghZ8eaHN7ojeHt3+nauASYxVajw
	6fnb8E3UbW8sGTj1A2LrNgqUvSnBefQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in
 a separate file
Message-ID: <20230626-9f6f98244a9ea949a48db91d@orel>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-2-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625230716.2922-2-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 25, 2023 at 11:07:11PM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Debugging tests that run on EFI is hard because the debug information is
> not included in the EFI file. Dump it into a separeate .debug file to
> allow the use of gdb or pretty_print_stacks script.

We're still missing the run_tests.sh change needed for
pretty_print_stacks, but I can post that myself.

Thanks,
drew

> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> 
> ---
> 
> v1->v2:
> * Making clean should remove .debug [Andrew]
> * x86 EFI support [Andrew]
> ---
>  arm/Makefile.common | 5 ++++-
>  x86/Makefile.common | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index d60cf8c..9b45a8f 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
>  
>  %.efi: %.so
>  	$(call arch_elf_check, $^)
> +	$(OBJCOPY) --only-keep-debug $^ $@.debug
> +	$(OBJCOPY) --strip-debug $^
> +	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>  	$(OBJCOPY) \
>  		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>  		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> @@ -103,7 +106,7 @@ $(libeabi): $(eabiobjs)
>  	$(AR) rcs $@ $^
>  
>  arm_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
> +	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} $(libeabi) $(eabiobjs) \
>  	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
>  
>  generated-files = $(asm-offsets)
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 9f2bc93..c42c3e4 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -54,6 +54,9 @@ ifeq ($(CONFIG_EFI),y)
>  	@chmod a-x $@
>  
>  %.efi: %.so
> +	$(OBJCOPY) --only-keep-debug $^ $@.debug
> +	$(OBJCOPY) --strip-debug $^
> +	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>  	$(OBJCOPY) \
>  		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
>  		-j .rela -j .reloc -S --target=$(FORMAT) $< $@
> @@ -124,4 +127,4 @@ arch_clean:
>  	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
>  	$(TEST_DIR)/.*.d lib/x86/.*.d \
>  	$(TEST_DIR)/efi/*.o $(TEST_DIR)/efi/.*.d \
> -	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi
> +	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi $(TEST_DIR)/*.debug
> -- 
> 2.34.1
> 
