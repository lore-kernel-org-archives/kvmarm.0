Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E068D20F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682946008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gu02SxXLbO3DyWzxZ6dfB8HpA3rxPgJw7VzwMPi2098=;
	b=IWK9VuvRFXHKKd5Vk0YFga3MYcsSU6HzOnvUBu+Vm0coPUXecqPSrZp7j5e5weraQy/yPT
	G3DgXpUWVObo/sQpUDFLM7T130xqddbDJKix+BK45q8YNFw3YN35XVysK0NrqSSZ5MffKl
	D165v4Xv8Fjs1t2p9H/g0WW0ktePq44=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-6lowSnY1PCCmlNmJMBzx7w-1; Mon, 01 May 2023 09:00:06 -0400
X-MC-Unique: 6lowSnY1PCCmlNmJMBzx7w-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1a6a5debce1so1256155ad.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 06:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682946005; x=1685538005;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu02SxXLbO3DyWzxZ6dfB8HpA3rxPgJw7VzwMPi2098=;
        b=BXfpZF3+hpOt7wMdHeCQxw12ulGH9dUIIW6kyL2W/XNEnUc4kYau//ynagDlEW8ghL
         ip1Rb2APMrHUqHVK37HdPLk2EnGtaJG1G56VBwjeh6r8Y4lbcw3fZ0hWs24kFLZygu/o
         8/3rO5i0Pjz1hPQjzGpKL2HJJINuGWRrUFnE0tCk9XKie110GoSg+hHF6GZFmXYhvxKR
         oKXulFwUosAyVoQCHH579xvp8HxSxb1Vm0uIAqdMzuo6AMIccTj/8edFN9KrRVXeyqqL
         boa41AQghDmgxfDenPTC0FzpbKynjtstWGy/Pf8TS9nIwV43YmVuI2gkynAXKvGbQAST
         KYGw==
X-Gm-Message-State: AC+VfDwwzLpqC6cBJYE6ZI15aGRZsQ4Ugjk8Ir958cugC8kQ19JD7pRa
	eNS/c5mbPe29YFgMNJoJtg2C3W0P/+h+vHNAF2cCpJQxycdubcnscu07eJl5cweNbhh/W5CWnJQ
	j2E9l1y2KKEPZHZFq
X-Received: by 2002:a17:902:f68e:b0:19a:a815:2877 with SMTP id l14-20020a170902f68e00b0019aa8152877mr16926788plg.6.1682946005351;
        Mon, 01 May 2023 06:00:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4dA3jXDv+wzHabFIGunVb7DUuP05Vo5+oeKu83B3yHp0pwtTFCw8ifqJzgivrKm9EQuGOhfw==
X-Received: by 2002:a17:902:f68e:b0:19a:a815:2877 with SMTP id l14-20020a170902f68e00b0019aa8152877mr16926750plg.6.1682946004944;
        Mon, 01 May 2023 06:00:04 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6-20020a170903228600b001aad4be4503sm4122771plh.2.2023.05.01.06.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 06:00:04 -0700 (PDT)
Message-ID: <b12032f1-44ef-3ca8-30d0-997fe141ac9e@redhat.com>
Date: Mon, 1 May 2023 21:00:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 27/29] arm64: Add support for efi in
 Makefile
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-28-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-28-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:04, Nikos Nikoleris wrote:
> Users can now build kvm-unit-tests as efi apps by supplying an extra
> argument when invoking configure:
> 
> $> ./configure --enable-efi
> 
> This patch is based on an earlier version by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   configure           | 17 +++++++++++++----
>   arm/Makefile.arm    |  6 ++++++
>   arm/Makefile.arm64  | 18 ++++++++++++++----
>   arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
>   4 files changed, 67 insertions(+), 19 deletions(-)
> 
> diff --git a/configure b/configure
> index c36fd290..b665f7d5 100755
> --- a/configure
> +++ b/configure
> @@ -86,7 +86,7 @@ usage() {
>   	               pl011,mmio32,ADDR
>   	                           Specify a PL011 compatible UART at address ADDR. Supported
>   	                           register stride is 32 bit only.
> -	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
> +	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
>   	    --[enable|disable]-werror
>   	                           Select whether to compile with the -Werror compiler flag
>   EOF
> @@ -208,14 +208,19 @@ else
>       fi
>   fi
>   
> -if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
> +if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
>       echo "--[enable|disable]-efi is not supported for $arch"
>       usage
>   fi
>   
>   if [ -z "$page_size" ]; then
> -    [ "$arch" = "arm64" ] && page_size="65536"
> -    [ "$arch" = "arm" ] && page_size="4096"
> +    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
> +        page_size="4096"
> +    elif [ "$arch" = "arm64" ]; then
> +        page_size="65536"
> +    elif [ "$arch" = "arm" ]; then
> +        page_size="4096"
> +    fi
>   else
>       if [ "$arch" != "arm64" ]; then
>           echo "--page-size is not supported for $arch"
> @@ -230,6 +235,10 @@ else
>           echo "arm64 doesn't support page size of $page_size"
>           usage
>       fi
> +    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> +        echo "efi must use 4K pages"
> +        exit 1
> +    fi
>   fi
>   
>   [ -z "$processor" ] && processor="$arch"
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 01fd4c7b..2ce00f52 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -7,6 +7,10 @@ bits = 32
>   ldarch = elf32-littlearm
>   machine = -marm -mfpu=vfp
>   
> +ifeq ($(CONFIG_EFI),y)
> +$(error Cannot build arm32 tests as EFI apps)
> +endif
> +
>   # stack.o relies on frame pointers.
>   KEEP_FRAME_POINTER := y
>   
> @@ -32,6 +36,8 @@ cflatobjs += lib/arm/stack.o
>   cflatobjs += lib/ldiv32.o
>   cflatobjs += lib/arm/ldivmod.o
>   
> +exe = flat
> +
>   # arm specific tests
>   tests =
>   
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6dff6cad..eada7f9a 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -31,11 +31,21 @@ endif
>   
>   OBJDIRS += lib/arm64
>   
> +ifeq ($(CONFIG_EFI),y)
> +# avoid jump tables before all relocations have been processed
> +arm/efi/reloc_aarch64.o: CFLAGS += -fno-jump-tables
> +cflatobjs += arm/efi/reloc_aarch64.o
> +
> +exe = efi
> +else
> +exe = flat
> +endif
> +
>   # arm64 specific tests
> -tests = $(TEST_DIR)/timer.flat
> -tests += $(TEST_DIR)/micro-bench.flat
> -tests += $(TEST_DIR)/cache.flat
> -tests += $(TEST_DIR)/debug.flat
> +tests = $(TEST_DIR)/timer.$(exe)
> +tests += $(TEST_DIR)/micro-bench.$(exe)
> +tests += $(TEST_DIR)/cache.$(exe)
> +tests += $(TEST_DIR)/debug.$(exe)
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>   
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 647b0fb1..a133309d 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -4,14 +4,14 @@
>   # Authors: Andrew Jones <drjones@redhat.com>
>   #
>   
> -tests-common  = $(TEST_DIR)/selftest.flat
> -tests-common += $(TEST_DIR)/spinlock-test.flat
> -tests-common += $(TEST_DIR)/pci-test.flat
> -tests-common += $(TEST_DIR)/pmu.flat
> -tests-common += $(TEST_DIR)/gic.flat
> -tests-common += $(TEST_DIR)/psci.flat
> -tests-common += $(TEST_DIR)/sieve.flat
> -tests-common += $(TEST_DIR)/pl031.flat
> +tests-common  = $(TEST_DIR)/selftest.$(exe)
> +tests-common += $(TEST_DIR)/spinlock-test.$(exe)
> +tests-common += $(TEST_DIR)/pci-test.$(exe)
> +tests-common += $(TEST_DIR)/pmu.$(exe)
> +tests-common += $(TEST_DIR)/gic.$(exe)
> +tests-common += $(TEST_DIR)/psci.$(exe)
> +tests-common += $(TEST_DIR)/sieve.$(exe)
> +tests-common += $(TEST_DIR)/pl031.$(exe)
>   
>   tests-all = $(tests-common) $(tests)
>   all: directories $(tests-all)
> @@ -54,6 +54,9 @@ cflatobjs += lib/arm/smp.o
>   cflatobjs += lib/arm/delay.o
>   cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
>   cflatobjs += lib/arm/timer.o
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs += lib/efi.o
> +endif
>   
>   OBJDIRS += lib/arm
>   
> @@ -61,6 +64,25 @@ libeabi = lib/arm/libeabi.a
>   eabiobjs = lib/arm/eabi_compat.o
>   
>   FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
> +
> +ifeq ($(CONFIG_EFI),y)
> +%.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
> +%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
> +	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
> +	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
> +		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
> +		$(EFI_LIBS)
> +	$(RM) $(@:.so=.aux.o)
> +
> +%.efi: %.so
> +	$(call arch_elf_check, $^)
> +	$(OBJCOPY) \
> +		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
> +		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> +		-j .reloc \
> +		-O binary $^ $@
> +else
>   %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
>   %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
>   	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> @@ -74,13 +96,14 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>   	$(call arch_elf_check, $^)
>   	$(OBJCOPY) -O binary $^ $@
>   	@chmod a-x $@
> +endif
>   
>   $(libeabi): $(eabiobjs)
>   	$(AR) rcs $@ $^
>   
>   arm_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
> -	      $(TEST_DIR)/.*.d lib/arm/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
> +	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
>   
>   generated-files = $(asm-offsets)
> -$(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +$(tests-all:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)

-- 
Shaoqin

