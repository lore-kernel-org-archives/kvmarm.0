Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D68488
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E76jPTTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697622738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTy9u72AvKpymhTEXgz7cOJwTX00iefFLAvlM+p6PJw=;
	b=E76jPTTz1M4xscg2bEGlWZcC2ChGB4nHYMKU21qQf3DNZwEFMduN2SbTYoFX6nP01IGqY6
	bi25HyqaDMJivFHgqnrn/P7Y76MgXhzDY/SLLI641K2SaxSONBZNgQ085zAiOlxQrCEuwr
	emBehEnOgeBvB0YibkuiG2obJnF5ie8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-TTRBYrg5M9OirthexLkyng-1; Wed, 18 Oct 2023 05:52:17 -0400
X-MC-Unique: TTRBYrg5M9OirthexLkyng-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-41cb5ff64b0so12594971cf.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 02:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697622736; x=1698227536;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTy9u72AvKpymhTEXgz7cOJwTX00iefFLAvlM+p6PJw=;
        b=eSLGujnavg52EyJQCVYgUEITGqr/tqSi+nDg9fkpgolXVxxoTLQlLDDrPDjgd2U/eH
         GGPjtQw46zrPVVgDUT4EgPJbeDVEKVN1z7f57lbKMTraZL97CMsI7rIkTCkd50ZhaaSg
         coJUzeHjePZnXMlVQGIbLcQ/zE2Z7zwhZDeq6+XPn6cN34/LCkvVjdv+CMj33VdZYcEr
         LS+p6AAbUKqDtKq/GWISDcDBmTwXUYg0CCe8wvXmomCNkubPYAJt8WtcALOeGDSSxBkA
         JHEycOwiMT8+2xonq8rbsapaLNqBiwEDcIsk9lUrfz2qyXP2yMZbng9AksIOoIficcOV
         IDHg==
X-Gm-Message-State: AOJu0YyexLdzECWBclMXSckP/f9wI5htQEbFHl0NYqFnIjHPRFaWeEk7
	I2iBorWUNw2ifqGuPVw9B7NMjM3rfOVEFqlVZ8/apIKHwrXN1aralOx/Ab7vhM/VgdqjWedNF50
	5ekPL+M9m1YiGqDbm
X-Received: by 2002:a05:6214:c2c:b0:66d:32ad:77ba with SMTP id a12-20020a0562140c2c00b0066d32ad77bamr4707748qvd.1.1697622736530;
        Wed, 18 Oct 2023 02:52:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVIoia+AvL7oQ7X+AY+YoEIrdAelNbHiwY+7nsEk5kM6AwK4l8oKJhaiX3l5rnuZ9MhTTUxQ==
X-Received: by 2002:a05:6214:c2c:b0:66d:32ad:77ba with SMTP id a12-20020a0562140c2c00b0066d32ad77bamr4707727qvd.1.1697622736269;
        Wed, 18 Oct 2023 02:52:16 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.189.211])
        by smtp.gmail.com with ESMTPSA id ea11-20020ad458ab000000b0065b09512e14sm1217347qvb.21.2023.10.18.02.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 02:52:15 -0700 (PDT)
Message-ID: <1c99fb73-3420-e12d-9828-5e501edef8b2@redhat.com>
Date: Wed, 18 Oct 2023 11:52:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
To: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Jing Zhang <jingzhangos@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231011195740.3349631-4-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 10/11/23 21:57, Oliver Upton wrote:
> Start generating sysreg-defs.h for arm64 builds in anticipation of
> updating sysreg.h to a version that depends on it.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a3bb36fb3cfc..07b3f4dc1a77 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -17,6 +17,17 @@ else
>  	ARCH_DIR := $(ARCH)
>  endif
>  
> +ifeq ($(ARCH),arm64)
> +arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
> +GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
> +CFLAGS += -I$(GEN_HDRS)
> +
> +prepare:
> +	$(MAKE) -C $(arm64_tools_dir)
> +else
> +prepare:
> +endif
> +
>  LIBKVM += lib/assert.c
>  LIBKVM += lib/elf.c
>  LIBKVM += lib/guest_modes.c
> @@ -256,13 +267,18 @@ $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
>  $(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
>  
> -EXTRA_CLEAN += $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SPLIT_TESTS_OBJS) cscope.*
> +EXTRA_CLEAN += $(GEN_HDRS) \
> +	       $(LIBKVM_OBJS) \
> +	       $(SPLIT_TESTS_OBJS) \
> +	       $(TEST_DEP_FILES) \
> +	       $(TEST_GEN_OBJ) \
> +	       cscope.*
>  
>  x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> -$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> +$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c prepare
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> -$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> +$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S prepare
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
>  # Compile the string overrides as freestanding to prevent the compiler from
> @@ -274,6 +290,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> +$(TEST_GEN_OBJ): prepare
>  
>  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
>  cscope:

