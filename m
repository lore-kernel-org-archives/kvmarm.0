Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28A4C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 14:42:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BA5B4B125;
	Tue, 17 May 2022 10:42:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9C0TXd19NvDe; Tue, 17 May 2022 10:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81CC74B2CC;
	Tue, 17 May 2022 10:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3A64B19D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 10:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOAdBsFdbkCc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 May 2022 10:42:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A16449F38
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 10:42:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1652798533;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hTjqsV1Fp+r+noPld4SG87IVv2bHAbFunBtzqB6+vis=;
 b=bZKBvBEodeHSdUe1ffOfv8NWU61sFikV2g/7xDPD/Ov+P8Ho1ajm81nNPeRuSNQEI8NGYc
 tP9pE66EVHdjHEs/EWyW9qhODNjLK7hvTQUM+2dpgfE7p1gnuMuZxDjvR7EzsLfyb3ovqO
 WsAUZ4uJ11hWIKjwnh6+HRzJuFENF/g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-5HEgFhYOOCGcLQB0s2fFhw-1; Tue, 17 May 2022 10:42:12 -0400
X-MC-Unique: 5HEgFhYOOCGcLQB0s2fFhw-1
Received: by mail-ed1-f69.google.com with SMTP id
 g10-20020a056402180a00b0042ab515d6c5so3692887edy.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 07:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hTjqsV1Fp+r+noPld4SG87IVv2bHAbFunBtzqB6+vis=;
 b=MNt7zxaUMATCpF9ZpzS02JIDK186zS3zkrjWrCc+a+OOQQZ8/4azpIN9nzQ7HMs00i
 UwvAfzx20WhdV1P2ccGBsfR0jfsD1F7tNmgX5FZ2+dmPTRDuAhI2B7bkfHDH+lVQgbkZ
 eRw8s704ZZV/xNnDksfRsCC464vhz3sfRfnzZNVWsX9OiPH7cnUnhMJyH4DQxm/ISl46
 lJbWzt0IFTnmv234UlD78b7eHtAMlmGZiTaRl49mpAjuAnPAZIZqUnZNkX346XMaWEdM
 ewQstc3CcjsF58izzcYY517JKFSU8CET7pmXQQkPVa+hjWM36teBSU6ZPWR/Ilz7X6oE
 OuNw==
X-Gm-Message-State: AOAM5336lAUSfnPbrlEkQf6ZgPK6jrIgPEaRapsHWspeq1Ecw/eyYmzW
 5w1j/TlJdm0IrBYXQQSXsugqLexzGT3NyCCwA/NH3nEvTp9LP9MOPCWSmH9w5ru5sdUaIi+H78X
 isDpINi84asIvEikgL8KCq+pK
X-Received: by 2002:a05:6402:238f:b0:42a:98d8:ae1b with SMTP id
 j15-20020a056402238f00b0042a98d8ae1bmr17423856eda.168.1652798530587; 
 Tue, 17 May 2022 07:42:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye0bbFmMONyTqmP3It4fL7QuUCBzVF03Vy8Tp5rLhkr7l+Xsej5oxl8SSRjnzPPSKeMkbGMg==
X-Received: by 2002:a05:6402:238f:b0:42a:98d8:ae1b with SMTP id
 j15-20020a056402238f00b0042a98d8ae1bmr17423824eda.168.1652798530348; 
 Tue, 17 May 2022 07:42:10 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
 by smtp.gmail.com with ESMTPSA id
 e9-20020a056402104900b0042ac0e79bb6sm1853112edu.45.2022.05.17.07.42.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 May 2022 07:42:09 -0700 (PDT)
Date: Tue, 17 May 2022 16:42:07 +0200
From: Andrew Jones <drjones@redhat.com>
To: Bill Wendling <morbo@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Check for dynamic relocs with
 readelf
Message-ID: <20220517144207.662hyp276g3syzf2@gator>
References: <20220504230446.2253109-1-morbo@google.com>
MIME-Version: 1.0
In-Reply-To: <20220504230446.2253109-1-morbo@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Zixuan Wang <zixuanwang@google.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, May 04, 2022 at 04:04:46PM -0700, Bill Wendling wrote:
> Clang's version of objdump doesn't recognize "setftest.elf" as a dynamic
> object and produces an error stating such.
> 
> 	$ llvm-objdump -R ./arm/selftest.elf
> 	arm/selftest.elf:	file format elf64-littleaarch64
> 	llvm-objdump: error: './arm/selftest.elf': not a dynamic object
> 
> This causes the ARM64 "arch_elf_check" check to fail. Using "readelf
> -rW" is a better option way to get the same information and produces the
> same information in both binutils and LLVM.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  arm/Makefile.arm64 | 6 +++---
>  configure          | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)

Merged to https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git master

Thanks,
drew



> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6feac76f895f..42e18e771b3b 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -14,9 +14,9 @@ mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
>  CFLAGS += $(mno_outline_atomics)
>  
>  define arch_elf_check =
> -	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> -		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
> -	$(if $(shell $(OBJDUMP) -R $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
> +	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
> +		$(error $(shell $(READELF) -rW $(1) 2>&1)))
> +	$(if $(shell $(READELF) -rW $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
>  		$(error $(1) has unsupported reloc types))
>  endef
>  
> diff --git a/configure b/configure
> index 86c3095a245a..23085da7dcc5 100755
> --- a/configure
> +++ b/configure
> @@ -12,6 +12,7 @@ cflags=
>  ld=ld
>  objcopy=objcopy
>  objdump=objdump
> +readelf=readelf
>  ar=ar
>  addr2line=addr2line
>  arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> @@ -372,6 +373,7 @@ CFLAGS=$cflags
>  LD=$cross_prefix$ld
>  OBJCOPY=$cross_prefix$objcopy
>  OBJDUMP=$cross_prefix$objdump
> +READELF=$cross_prefix$readelf
>  AR=$cross_prefix$ar
>  ADDR2LINE=$cross_prefix$addr2line
>  TEST_DIR=$testdir
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
