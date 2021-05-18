Return-Path: <SRS0=6U3X=KN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BCDC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 11:49:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3540D61007
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 11:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3540D61007
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC534B436;
	Tue, 18 May 2021 07:49:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FAQtnMfQSkWB; Tue, 18 May 2021 07:48:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFC24B465;
	Tue, 18 May 2021 07:48:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B34D4B436
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 07:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lle9gfXGf-eF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 May 2021 07:48:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B19F4B463
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 07:48:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1621338535;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mlQ7G6nQMS0+u70jyAdMN6frxJBI8Gxh0QekrRUBeO0=;
 b=EWO4v2L3pFYXuXh2xWuR5fF4QJg6wbdKJ4jLVEsGwIoSgOVO2G0P1P062Cic7GCX8HWrkK
 n++mVJF7yG1oUgoZrcoUJN73Ij71mwaL1rVBUabNhuDOtjYa1rq+IUqu4mGAgm9/Vvvebe
 T9RVYMUmWQCvpYRLPeFCdh0JYbqmzdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-h6kIOpP2MM6TE80SuJXNVA-1; Tue, 18 May 2021 07:48:53 -0400
X-MC-Unique: h6kIOpP2MM6TE80SuJXNVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A794C107ACE3;
 Tue, 18 May 2021 11:48:50 +0000 (UTC)
Received: from [10.36.114.156] (ovpn-114-156.ams2.redhat.com [10.36.114.156])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 457A860855;
 Tue, 18 May 2021 11:48:43 +0000 (UTC)
Subject: Re: [PATCH 15/56] KVM: arm64: Add build rules for separate VHE/nVHE
 object files
From: Auger Eric <eric.auger@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-16-maz@kernel.org>
 <2ff3a1cb-a310-7963-4171-bd1e7d08e39b@redhat.com>
Message-ID: <5d1853ed-3474-edbc-545a-1f88f2a4e5ca@redhat.com>
Date: Tue, 18 May 2021 13:48:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2ff3a1cb-a310-7963-4171-bd1e7d08e39b@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi David, Marc,

On 5/4/21 4:47 PM, Auger Eric wrote:
> Hi David, Marc,
> 
> On 8/5/20 7:56 PM, Marc Zyngier wrote:
>> From: David Brazdil <dbrazdil@google.com>
>>
>> Add new folders arch/arm64/kvm/hyp/{vhe,nvhe} and Makefiles for building code
>> that runs in EL2 under VHE/nVHE KVM, repsectivelly. Add an include folder for
>> hyp-specific header files which will include code common to VHE/nVHE.
>>
>> Build nVHE code with -D__KVM_NVHE_HYPERVISOR__, VHE code with
>> -D__KVM_VHE_HYPERVISOR__.
>>
>> Under nVHE compile each source file into a `.hyp.tmp.o` object first, then
>> prefix all its symbols with "__kvm_nvhe_" using `objcopy` and produce
>> a `.hyp.o`. Suffixes were chosen so that it would be possible for VHE and nVHE
>> to share some source files, but compiled with different CFLAGS.
>>
>> The nVHE ELF symbol prefix is added to kallsyms.c as ignored. EL2-only symbols
>> will never appear in EL1 stack traces.
>>
>> Due to symbol prefixing, add a section in image-vars.h for aliases of symbols
>> that are defined in nVHE EL2 and accessed by kernel in EL1 or vice versa.
>>
>> Signed-off-by: David Brazdil <dbrazdil@google.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20200625131420.71444-4-dbrazdil@google.com
>> ---
>>  arch/arm64/kernel/image-vars.h   | 14 +++++++++++++
>>  arch/arm64/kvm/hyp/Makefile      | 10 +++++++---
>>  arch/arm64/kvm/hyp/nvhe/Makefile | 34 ++++++++++++++++++++++++++++++++
>>  arch/arm64/kvm/hyp/vhe/Makefile  | 17 ++++++++++++++++
>>  scripts/kallsyms.c               |  1 +
>>  5 files changed, 73 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
>>  create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile
>>
>> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
>> index be0a63ffed23..3dc27da47712 100644
>> --- a/arch/arm64/kernel/image-vars.h
>> +++ b/arch/arm64/kernel/image-vars.h
>> @@ -51,4 +51,18 @@ __efistub__ctype		= _ctype;
>>  
>>  #endif
>>  
>> +#ifdef CONFIG_KVM
>> +
>> +/*
>> + * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_, to
>> + * separate it from the kernel proper. The following symbols are legally
>> + * accessed by it, therefore provide aliases to make them linkable.
>> + * Do not include symbols which may not be safely accessed under hypervisor
>> + * memory mappings.
>> + */
>> +
>> +#define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
>> +
>> +#endif /* CONFIG_KVM */
>> +
>>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index 5d8357ddc234..9c5dfe6ff80b 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -3,10 +3,14 @@
>>  # Makefile for Kernel-based Virtual Machine module, HYP part
>>  #
>>  
>> -ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
>> -		$(DISABLE_STACKLEAK_PLUGIN)
>> +incdir := $(srctree)/$(src)/include
>> +subdir-asflags-y := -I$(incdir)
>> +subdir-ccflags-y := -I$(incdir)				\
>> +		    -fno-stack-protector		\
>> +		    -DDISABLE_BRANCH_PROFILING		\
>> +		    $(DISABLE_STACKLEAK_PLUGIN)
>>  
>> -obj-$(CONFIG_KVM) += hyp.o
>> +obj-$(CONFIG_KVM) += hyp.o nvhe/
>>  obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
>>  
>>  hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
>> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
>> new file mode 100644
>> index 000000000000..955f4188e00f
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
>> @@ -0,0 +1,34 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
>> +#
>> +
>> +asflags-y := -D__KVM_NVHE_HYPERVISOR__
>> +ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>> +
>> +obj-y :=
>> +
>> +obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
>> +extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
>> +
>> +$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
>> +	$(call if_changed_rule,cc_o_c)
>> +$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
>> +	$(call if_changed_rule,as_o_S)
>> +$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
>> +	$(call if_changed,hypcopy)
>> +
>> +quiet_cmd_hypcopy = HYPCOPY $@
>> +      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
>> +
>> +# KVM nVHE code is run at a different exception code with a different map, so
>> +# compiler instrumentation that inserts callbacks or checks into the code may
>> +# cause crashes. Just disable it.
>> +GCOV_PROFILE	:= n
>> +KASAN_SANITIZE	:= n
>> +UBSAN_SANITIZE	:= n
>> +KCOV_INSTRUMENT	:= n
>> +
>> +# Skip objtool checking for this directory because nVHE code is compiled with
>> +# non-standard build rules.
>> +OBJECT_FILES_NON_STANDARD := y
>> diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
>> new file mode 100644
>> index 000000000000..e04375546081
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/vhe/Makefile
>> @@ -0,0 +1,17 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
>> +#
>> +
>> +asflags-y := -D__KVM_VHE_HYPERVISOR__
>> +ccflags-y := -D__KVM_VHE_HYPERVISOR__
>> +
>> +obj-y :=
>> +
>> +# KVM code is run at a different exception code with a different map, so
>> +# compiler instrumentation that inserts callbacks or checks into the code may
>> +# cause crashes. Just disable it.
>> +GCOV_PROFILE	:= n
>> +KASAN_SANITIZE	:= n
>> +UBSAN_SANITIZE	:= n
>> +KCOV_INSTRUMENT	:= n
>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>> index 6dc3078649fa..0096cd965332 100644
>> --- a/scripts/kallsyms.c
>> +++ b/scripts/kallsyms.c
>> @@ -109,6 +109,7 @@ static bool is_ignored_symbol(const char *name, char type)
>>  		".LASANPC",		/* s390 kasan local symbols */
>>  		"__crc_",		/* modversions */
>>  		"__efistub_",		/* arm64 EFI stub namespace */
>> +		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
> The addition of this line seems to have introduced errors on the
> 'vmlinux symtab matches kallsyms' perf test (perf test -v 1) which fails
> on aarch64 for all __kvm_nvhe_ prefixed symbols, like
> 
> ERR : <addr> : __kvm_nvhe___invalid not on kallsyms
> ERR : <addr> : __kvm_nvhe___do_hyp_init not on kallsyms
> ERR : <addr> : __kvm_nvhe___kvm_handle_stub_hvc not on kallsyms
> ERR : <addr> : __kvm_nvhe_reset not on kallsyms
> ../..
> 
> I understand we willingly hided those symbols from /proc/kallsyms. Do
> you confirm the right fix is to upgrade the perf test suite accordingly?

Were you eventually able to reproduce?

Thanks

Eric
> 
> Thanks
> 
> Eric
> 
> 
>>  		NULL
>>  	};
>>  
>>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
