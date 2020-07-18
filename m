Return-Path: <SRS0=+9g1=A5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED98C433E2
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jul 2020 13:49:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDBCF2073A
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jul 2020 13:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDBCF2073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 299BF4B15D;
	Sat, 18 Jul 2020 09:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SYyjWoVIoeAF; Sat, 18 Jul 2020 09:49:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8F24B141;
	Sat, 18 Jul 2020 09:49:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4C14B141
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jul 2020 09:49:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CHShZ7zAS91x for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Jul 2020 09:49:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC514B113
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jul 2020 09:49:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4952B12FC;
 Sat, 18 Jul 2020 06:49:34 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC3B93F718;
 Sat, 18 Jul 2020 06:49:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics
 for GCC >= 10
To: Andrew Jones <drjones@redhat.com>
References: <20200717164727.75580-1-alexandru.elisei@arm.com>
 <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <202d475d-95df-2350-a8e9-9264144993ac@arm.com>
Date: Sat, 18 Jul 2020 14:50:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On 7/18/20 10:11 AM, Andrew Jones wrote:
> On Fri, Jul 17, 2020 at 05:47:27PM +0100, Alexandru Elisei wrote:
>> GCC 10.1.0 introduced the -m{,no-}outline-atomics flags which, according to
>> man 1 gcc:
>>
>> "Enable or disable calls to out-of-line helpers to implement atomic
>> operations.  These helpers will, at runtime, determine if the LSE
>> instructions from ARMv8.1-A can be used; if not, they will use the
>> load/store-exclusive instructions that are present in the base ARMv8.0 ISA.
>> [..] This option is on by default."
>>
>> Unfortunately the option causes the following error at compile time:
>>
>> aarch64-linux-gnu-ld -nostdlib -pie -n -o arm/spinlock-test.elf -T /path/to/kvm-unit-tests/arm/flat.lds \
>> 	arm/spinlock-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a lib/arm/libeabi.a arm/spinlock-test.aux.o
>> aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
>> lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'
>>
>> This is happening because we are linking against our own libcflat which
>> doesn't implement the function __getauxval().
>>
>> Disable the use of the out-of-line functions by compiling with
>> -mno-outline-atomics if we detect a GCC version greater than 10.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>
>> Tested with gcc versions 10.1.0 and 5.4.0 (cross-compilation), 9.3.0
>> (native).
>>
>> I've been able to suss out the reason for the build failure from this
>> rejected gcc patch [1].
>>
>> [1] https://patches.openembedded.org/patch/172460/
>>
>>  arm/Makefile.arm64 | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index dfd0c56fe8fb..3223cb966789 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -9,6 +9,12 @@ ldarch = elf64-littleaarch64
>>  arch_LDFLAGS = -pie -n
>>  CFLAGS += -mstrict-align
>>  
>> +# The -mno-outline-atomics flag is only valid for GCC versions 10 and greater.
>> +GCC_MAJOR_VERSION=$(shell $(CC) -dumpversion 2> /dev/null | cut -f1 -d.)
>> +ifeq ($(shell expr "$(GCC_MAJOR_VERSION)" ">=" "10"), 1)
>> +CFLAGS += -mno-outline-atomics
>> +endif
> How about this patch instead?
>
> diff --git a/Makefile b/Makefile
> index 3ff2f91600f6..0e21a49096ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,6 +17,11 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>  
>  .PHONY: arch_clean clean distclean cscope
>  
> +# cc-option
> +# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> +cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> +
>  #make sure env CFLAGS variable is not used
>  CFLAGS =
>  
> @@ -43,12 +48,6 @@ OBJDIRS += $(LIBFDT_objdir)
>  #include architecture specific make rules
>  include $(SRCDIR)/$(TEST_DIR)/Makefile
>  
> -# cc-option
> -# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> -
> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> -              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> -
>  COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
>  COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
>  COMMON_CFLAGS += -Wignored-qualifiers -Werror
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index dfd0c56fe8fb..dbc7524d3070 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -9,6 +9,9 @@ ldarch = elf64-littleaarch64
>  arch_LDFLAGS = -pie -n
>  CFLAGS += -mstrict-align
>  
> +mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
> +CFLAGS += $(mno_outline_atomics)
> +
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
>  		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
>
>
> Thanks,
> drew

Looks much better than my version. Do you want me to spin a v2 or do you want to
send it as a separate patch? If that's the case, I tested the same way I did my
patch (gcc 10.1.0 and 5.4.0 for cross-compiling, 9.3.0 native):

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
