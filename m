Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6DC7F9
	for <kvmarm@lists.linux.dev>; Sat, 24 Jun 2023 10:31:40 +0000 (UTC)
Date: Sat, 24 Jun 2023 12:31:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687602698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3n67zTOSkCuSmBIFx/64QtEed8ed1O/yKXJNvvKKX4=;
	b=bLvnzqWF6movDJFvurcUa+NXtzFw3w4by83NzUnJW7yzl/vUXwvzyOSx+Aj4B2xIrU5aTf
	FyeaMCle9mg2IzYPVwcatsNg8wKVdqpDqXiP08eFGmC7sKl8tY/5Yhvtaz5ZGZyjx/L/t7
	q06no4SRykMkDoWy1TnruXGNByBzTXg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a
 separate file
Message-ID: <20230624-774d9b995f86fca17f3d3d89@orel>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-2-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617014930.2070-2-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 17, 2023 at 01:49:25AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Debugging tests that run on EFI is hard because the debug information is
> not included in the EFI file. Dump it into a separeate .debug file to
> allow the use of gdb or pretty_print_stacks script.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arm/Makefile.common | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index d60cf8c..f904702 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -69,7 +69,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>  ifeq ($(CONFIG_EFI),y)
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
>  %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
> -	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +	$(CC) $(CFLAGS) -c -g -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
>  		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
>  	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
>  		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
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
> -- 
> 2.34.1
>

We also need a change to arm_clean to clean these new files up. Or, since
we probably want them for x86 as well and we already have other efi
cleanup to do, then maybe we should have a common efi_clean in the top-
level Makefile which x86's and arm's clean use to clean up all efi related
files.

Thanks,
drew
