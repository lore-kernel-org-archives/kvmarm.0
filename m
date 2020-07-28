Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB0CC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 21:25:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B8062065C
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 21:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Irjiwd+D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B8062065C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D5824BD63;
	Tue, 28 Jul 2020 17:25:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x5l69ubPd-tn; Tue, 28 Jul 2020 17:25:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C224BCED;
	Tue, 28 Jul 2020 17:25:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D31BF4BD6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 17:25:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c+fzSHlitZWZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 17:25:25 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA6C4BD6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 17:25:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595971525;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UjpEBnWwNeMyM4AXLo8va3vZKuvKlfpizEQ8IIwLYbM=;
 b=Irjiwd+D3L8qGNLVCfLoYJr16k59oS42j3JyHos8A54++DHRpnxYBYEAxZgdVwc8yISWVL
 dYzw7vprwVlKZLItP/TnVulLIZed2FWQMF25uYSB5wBL8yABE6WklJlOj2K3XLwXDn6qZs
 MZitKdRZdYdYWLMceFkKQ5Zy8JWcpJc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-D7eq-H62P0qvYcM-eAJ4gA-1; Tue, 28 Jul 2020 17:25:23 -0400
X-MC-Unique: D7eq-H62P0qvYcM-eAJ4gA-1
Received: by mail-wr1-f69.google.com with SMTP id r29so1413819wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 14:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=UjpEBnWwNeMyM4AXLo8va3vZKuvKlfpizEQ8IIwLYbM=;
 b=KLt9QHPAZbf7TAcQXQSouQnhnBuoo2w8eNcFMgL2zOb+poLST1HKNEcf5s2GDwzNVZ
 pePRxnpec0yCXo6OK12aBgsUaWJxznC1VZTZLx/RpFv9s/i7WPUa7lpeHPL3AeUGhavy
 Wlyxo4H3GZ+UUUuHfI3PaUJf3Cq/ABAbNOCezaDk/hCXDXSpzObEParTGYMb6jxtRK9M
 esIumKSv0RB88ki3FIWJhOz9Vc0JsdGsQUYzWjuLGkR7ACx5uR/PMeuWHXqI+m090SIS
 SNNFd5woAOtLx3hfG48f++pdarF7NhCXkqGBjx+7IPWdYnGqVEwn26py2gFl4aedcBaI
 KGqw==
X-Gm-Message-State: AOAM532Bv3xeR0yy7LOp8LhZg5aL3t2GB3Nq16sX2o6Vto6lOMJanwKR
 tHvUNupGUJ8wiYsa6Om7+UdYCYCdlsF/vdx7BaqwOytQ1fib7e07y8sbIne5f55MBTzURX27tqk
 fFLfoGPq1M6papl4j5wOkb4Jp
X-Received: by 2002:a1c:2109:: with SMTP id h9mr5541033wmh.174.1595971522628; 
 Tue, 28 Jul 2020 14:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvS4Yoat8bT0HyeCP4HpI77T+segRt+fHEYM4hC3RLBuQTzQc+DrZBzPSyirYQqHWAZtm+xg==
X-Received: by 2002:a1c:2109:: with SMTP id h9mr5541021wmh.174.1595971522363; 
 Tue, 28 Jul 2020 14:25:22 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
 by smtp.gmail.com with ESMTPSA id f15sm155948wmj.39.2020.07.28.14.25.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Jul 2020 14:25:21 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm64: Compile with -mno-outline-atomics
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200728121751.15083-1-drjones@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07b701a3-927c-abd1-2177-e18eade53224@redhat.com>
Date: Tue, 28 Jul 2020 23:25:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200728121751.15083-1-drjones@redhat.com>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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

On 28/07/20 14:17, Andrew Jones wrote:
> GCC 10.1.0 introduced the -moutline-atomics option which, when
> enabled, use LSE instructions when the processor provides them.
> The option is enabled by default and unfortunately causes the
> following error at compile time:
> 
>  aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
>  lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'
> 
> This is happening because we are linking against our own libcflat which
> doesn't implement the function __getauxval().
> 
> Disable the use of the out-of-line functions by compiling with
> -mno-outline-atomics.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Makefile           | 11 +++++------
>  arm/Makefile.arm64 |  3 +++
>  2 files changed, 8 insertions(+), 6 deletions(-)
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

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
