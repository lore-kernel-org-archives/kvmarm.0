Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0E211A
	for <kvmarm@lists.linux.dev>; Sat, 24 Jun 2023 10:12:12 +0000 (UTC)
Date: Sat, 24 Jun 2023 12:12:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687601530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eienGPJg8BhDq3nNta1lhkxktgiiv9z3+Cr1zvyVC6c=;
	b=nt8ztZneRTFCWpAj9o5WIcnYMw6nA2jRXuu5FeK2NqZSaYR6CRjGHi6tXLUHA9P+XlBgE6
	HCLy4mNldLtn3NAGayhIXyiZOIc7n3QKMY4QxXxwThJxMXRhXptuZL3CayWxDZojCIJMhq
	ChKe/EFDnnugmicD4FfK429XZRKUQQc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a
 separate file
Message-ID: <20230624-7f0459e3472cf78947b5464f@orel>
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

Any reason to not also do this for x86?

One reason I ask, is that in order for pretty_print_stacks.py to make
use of this from run_tests.sh we need a patch like

diff --git a/run_tests.sh b/run_tests.sh
index f61e0057b537..67b239f1adc7 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -125,8 +125,14 @@ fi
 RUNTIME_log_stderr () { process_test_output "$1"; }
 RUNTIME_log_stdout () {
     local testname="$1"
+    local kernel
+
     if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
-        local kernel="$2"
+        if [ "$CONFIG_EFI" = "y" ]; then
+            kernel="${TEST_DIR}/${2}.efi.debug"
+        else
+            kernel="$2"
+        fi
         ./scripts/pretty_print_stacks.py "$kernel" | process_test_output "$testname"
     else
         process_test_output "$testname"


We'd have to special-case that CONFIG_EFI condition for arm64 if we don't
also create .efi.debug files for x86.

Thanks,
drew
