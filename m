Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752328C0C
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 09:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0GAnyp/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697622637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NLpCBnDLvfXNYYi67xC1Ssv/noZY9gzp0KbFkKx9aOs=;
	b=A0GAnyp/UUjRpeMHeGjsAC5ZDjD+b5XSA9HTvinG3i7f56TvBQdWZeXY6HlSv9EetmZTit
	+YozkcrLUygbGfyvoaSGSXtH6SNR3QgqeqF7aj4j5wevXPrQWh/agouNJB/Z8JLWA9QGZd
	AgMETQxHQqfqvtIdIPIY1LdD0E4GEaU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-p8Z9PcuwPWeiTePLyzILLA-1; Wed, 18 Oct 2023 05:50:35 -0400
X-MC-Unique: p8Z9PcuwPWeiTePLyzILLA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-77405179afdso734993785a.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 02:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697622635; x=1698227435;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NLpCBnDLvfXNYYi67xC1Ssv/noZY9gzp0KbFkKx9aOs=;
        b=hW9Et4fVU+l92kGIIlVuMPw4LAj/jURJDg9HYcP8sdnzld/MIzt0HoEDycIz0ooipO
         1BMuTCcDfff+k4DS1C1uxZDzPTZ98SWptbprYf3pvdglAaUexPex5ZTsLM1pMY/Akz+r
         /MMu445w7YON/dyTiMtTbq9UQ4+VO7dazVt+9L/sNdQsMbYV8hYN/S3u4kjW+KM8gw2i
         guJsk38xh4hALiK6pIg9O/V4ef4XpMncLoZPrdu8MsqvmledSIRcY7HkTv350GsCMCQb
         H/TTjSzIhRmwPCPaCnPSHED853czXo+NfGujYIcZR7aQmzdL7k17sxKZK0HWcqhqOyRZ
         QStw==
X-Gm-Message-State: AOJu0YzSZw4jNnZo8/rEWgWP23BjGJhZbNHgBDaXCpdbxgUN8X6IVwGX
	RaWbOgehRgVeUQy0KFGNDpNyeTnluhUKPU74REb94fysOUkkPfUP3yX8SLMSDQmp9Q9YTkMNi6u
	0sRov6X27O+NAkqzx
X-Received: by 2002:a05:620a:25d3:b0:774:1d2c:c412 with SMTP id y19-20020a05620a25d300b007741d2cc412mr4926123qko.44.1697622635303;
        Wed, 18 Oct 2023 02:50:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJzybtWarVKQQszbGViLQUiJB1FoBZ7kxdl8szeiXBGLOy9SIafzQrmXJGJp4Ev7uirtyyTw==
X-Received: by 2002:a05:620a:25d3:b0:774:1d2c:c412 with SMTP id y19-20020a05620a25d300b007741d2cc412mr4926097qko.44.1697622634967;
        Wed, 18 Oct 2023 02:50:34 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.189.211])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b007743446efd1sm1342740qkb.35.2023.10.18.02.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 02:50:34 -0700 (PDT)
Message-ID: <4aa5d142-462f-24d9-8f13-ead19c15ae99@redhat.com>
Date: Wed, 18 Oct 2023 11:50:28 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 1/5] tools: arm64: Add a Makefile for generating
 sysreg-defs.h
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
 <20231011195740.3349631-2-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231011195740.3349631-2-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 10/11/23 21:57, Oliver Upton wrote:
> Use a common Makefile for generating sysreg-defs.h, which will soon be
> needed by perf and KVM selftests. The naming scheme of the generated
> macros is not expected to change, so just refer to the canonical
> script/data in the kernel source rather than copying to tools.
> 
> Co-developed-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  tools/arch/arm64/include/.gitignore |  1 +
>  tools/arch/arm64/tools/Makefile     | 38 +++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 tools/arch/arm64/include/.gitignore
>  create mode 100644 tools/arch/arm64/tools/Makefile
> 
> diff --git a/tools/arch/arm64/include/.gitignore b/tools/arch/arm64/include/.gitignore
> new file mode 100644
> index 000000000000..9ab870da897d
> --- /dev/null
> +++ b/tools/arch/arm64/include/.gitignore
> @@ -0,0 +1 @@
> +generated/
> diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
> new file mode 100644
> index 000000000000..f867e6036c62
> --- /dev/null
> +++ b/tools/arch/arm64/tools/Makefile
> @@ -0,0 +1,38 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ifeq ($(srctree),)
> +srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +endif
> +
> +include $(srctree)/tools/scripts/Makefile.include
> +
> +AWK	?= awk
> +MKDIR	?= mkdir
> +RM	?= rm
> +
> +ifeq ($(V),1)
> +Q =
> +else
> +Q = @
> +endif
> +
> +arm64_tools_dir = $(srctree)/arch/arm64/tools
> +arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
> +arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
> +arm64_generated_dir = $(srctree)/tools/arch/arm64/include/generated
> +arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
> +
> +all: $(arm64_sysreg_defs)
> +	@:
> +
> +$(arm64_sysreg_defs): $(arm64_gen_sysreg) $(arm64_sysreg_tbl)
> +	$(Q)$(MKDIR) -p $(dir $@)
> +	$(QUIET_GEN)$(AWK) -f $^ > $@
> +
> +clean:
> +	$(Q)$(RM) -rf $(arm64_generated_dir)
> +
> +.PHONY: all clean

