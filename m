Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65891840
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 06:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692168861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgxVBCPXJnsNLI+46xSarM00ICOkVY08GNNNdoBDjSY=;
	b=EU7OUBkFv/mdgYOzep8HRi9BXNUVVwcqiwe8MdSIualAjZXNq9Y8xiF8SNzMAGRY6NtPVe
	PwV+fulbF94hAHYXwSBx1QuGzReunuE+b+nrNs0jVGehvCHh+NNYOsxa0+L4y9+HPEyyvM
	m2vCCankaejbi9Ogd9GGeaLV7Oa2Lyc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-mnr8J3f0NluoG2uuf38fDg-1; Wed, 16 Aug 2023 02:54:20 -0400
X-MC-Unique: mnr8J3f0NluoG2uuf38fDg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-26b5bd44ae5so680059a91.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 23:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692168859; x=1692773659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgxVBCPXJnsNLI+46xSarM00ICOkVY08GNNNdoBDjSY=;
        b=Vn/svesQbMZ4HPKJIAk1oP77TDIGpUAippFyHH5XGVmt2LHFcoGxfIz5R1nlPj2vrp
         Mezo81VONCwHA/UA7L/gPBvk/eSNPc5hDz+N+u2EbBF0TFaN2e8KFqI95Nshw3xo4JxO
         n07Nvx7l2xWJff77mJOxhd7d9dVFAh9Foc5IDjd4GxboGDu/M+pDr9ZgbPCn8+CBm1mZ
         Ew4yZJJQUA06FL3gmpMDEV3aD9K+LUyfx2cADuEZgUmQ6DW1pKTl1IrEj4kIhLDT/pCV
         CPWpV+SF7dWQU6pouwJF7uIQKZ16ewjXsMboYrv0A4nbOYuuJur8MhZTEPRVivOukiDl
         3vIg==
X-Gm-Message-State: AOJu0YwOsgF+pLTmX8RQYP+22Y6pG6cgBdQHftJL/1RHpV67rCqcAVn/
	w/z0voUt/SaSoY2xQ06LmP1Ph90ZihuXBi6SmUob6/fpOdHo5xvKzuJ9vUdszOg4Y5IsNV7sKJP
	2UH06YEuPFq8FT5zv
X-Received: by 2002:a17:90a:3ee5:b0:26b:27f6:90cc with SMTP id k92-20020a17090a3ee500b0026b27f690ccmr770928pjc.2.1692168859071;
        Tue, 15 Aug 2023 23:54:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd1P04owTF2cdwpf0pccpR9NLO2ED6eD6S+SvhMYjVhqIN6dPlHq32ucBOvg9alBVH6mrqyw==
X-Received: by 2002:a17:90a:3ee5:b0:26b:27f6:90cc with SMTP id k92-20020a17090a3ee500b0026b27f690ccmr770914pjc.2.1692168858740;
        Tue, 15 Aug 2023 23:54:18 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gk18-20020a17090b119200b00263ba6a248bsm12594305pjb.1.2023.08.15.23.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 23:54:18 -0700 (PDT)
Message-ID: <eaa2519e-15b3-2fd4-199e-8e3368df7e0d@redhat.com>
Date: Wed, 16 Aug 2023 14:54:13 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 10/11] KVM: arm64: selftests: Import automatic system
 register definition generation from kernel
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-11-jingzhangos@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230807162210.2528230-11-jingzhangos@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jing,

On 8/8/23 00:22, Jing Zhang wrote:
> Import automatic system register definition generation from kernel and
> update system register usage accordingly.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c692cc86e7da..a8cf0cb04db7 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -200,14 +200,15 @@ ifeq ($(ARCH),x86_64)
>   LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
>   else
>   LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> +ARCH_GENERATED_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include/generated
>   endif
>   CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> -	-Wno-gnu-variable-sized-type-not-at-end -MD\
> +	-Wno-gnu-variable-sized-type-not-at-end -MD \
>   	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>   	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>   	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>   	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> -	$(KHDR_INCLUDES)
> +	-I$(ARCH_GENERATED_INCLUDE) $(KHDR_INCLUDES)
>   ifeq ($(ARCH),s390)
>   	CFLAGS += -march=z10
>   endif
> @@ -255,8 +256,16 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>   $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>   	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
>   
> +ifeq ($(ARCH),arm64)
> +GEN_SYSREGS := $(ARCH_GENERATED_INCLUDE)/asm/sysreg-defs.h
> +ARCH_TOOLS := $(top_srcdir)/tools/arch/$(ARCH)/tools/
> +
> +$(GEN_SYSREGS): $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg
> +	mkdir -p $(dir $@); awk -f $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg > $@
> +endif
> +
>   x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> -$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> +$(TEST_GEN_PROGS): $(LIBKVM_OBJS) $(GEN_SYSREGS)

I don't this this really works. Since the $(GEN_SYSREG) is the 
prerequisites of $(TEST_GEN_PROGS). Only when $(TEST_GEN_PROGS) being 
compiled, the $(GEN_SYSREG) can be generated.

But the fact is, the $(TEST_GEN_PROGS) is relies on $(TEST_GEN_OBJ), 
which means $(TEST_GEN_OBJ) will be compiled before $(TEST_GEN_PROGS), 
but $(TEST_GEN_OBJ) depends on $(GEN_SYSREG) again, at the time, the 
$(GEN_SYSREG) hasn't been generated, so it will has error:

No such file or directory.

#include "asm/sysreg-defs.h"

I think the correct way to generate $(GEN_SYSREGS) is add a prerequisite 
for $(TEST_GEN_OBJ), like:

$(TEST_GEN_OBJ): $(GEN_SYSREGS)

Thanks,
Shaoqin

>   $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
>   
>   cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
-- 
Shaoqin

