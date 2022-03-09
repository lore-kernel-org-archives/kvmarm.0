Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746D3C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 17:01:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2AA40C67;
	Wed,  9 Mar 2022 12:01:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FQfsf8yM609z; Wed,  9 Mar 2022 12:01:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A49C41019;
	Wed,  9 Mar 2022 12:01:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C38040C67
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 12:01:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q7hPR3RPDM6p for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 12:01:22 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB7340C23
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 12:01:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1646845282;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PmPxCROnkmuVdU5NYrU4XL6BIT6O1oBuXgVRzY2Lfe8=;
 b=UZpoyp0e+IfVAnUO4iFB0K3vcta2IWN6ho0nmnlxW2d4JRR5FznA+61352Wmmz8syuicdu
 FGG5Qq0aelTJf0DeFahqX34BsF+o4JYgjlTu9npZKnSkumD8n9ieaYcCcWRFu5WRlCGAD7
 +lfATO+BIHbYvChMXFWYVwk3p7IP4Ls=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-n0BDJJUnOMClnUfi1AqQgA-1; Wed, 09 Mar 2022 12:01:19 -0500
X-MC-Unique: n0BDJJUnOMClnUfi1AqQgA-1
Received: by mail-ej1-f69.google.com with SMTP id
 x2-20020a1709065ac200b006d9b316257fso1627735ejs.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 09:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PmPxCROnkmuVdU5NYrU4XL6BIT6O1oBuXgVRzY2Lfe8=;
 b=tAzIC8eMF/XrhSAnWm0bwofYvYt+Hac3kBYhAv/PXjFyb9Dskb+o9uldyCDFb2AcLI
 sTtDPs+saNCo0yZ26f1KFmi9XhZHYHxWLHtryKn5p/958tC5U9xvb1XNQR+3KDR+nqQX
 ijiDLXonF6ZSVchZYJbwqXw8OTmqlICFbTuXVwQmFISTcbzzaGpng1V+LuCs3I2dLTcR
 cujLrpcw2gtlaiawFMj8pLxAglscWmrQD0ULO8h/vh1F3r54ohqCHGYnmSGUM0S83lEa
 NlP35Fo45HUAWG5KMDK5sv3E9MO0dkHU8ErQidqCl4Ms32HgRqkY9tUN4NHkrCMKep1c
 g3Kg==
X-Gm-Message-State: AOAM5303dfzS6OEZVQ0+beCznxd065H7kjFzJwTUl1tnrjGzs5ae9ax2
 xxHYuJTT8gf4AkVQ2LiowDv6EvktAqlWP6/LGdry92B4iK2Huizv6ePe2L9AYqnP7Q5BXDQyySg
 ck2yRMvEvWTdUK1wy+jLIKD+L
X-Received: by 2002:a50:e1ca:0:b0:413:b403:f8e6 with SMTP id
 m10-20020a50e1ca000000b00413b403f8e6mr409211edl.204.1646845278466; 
 Wed, 09 Mar 2022 09:01:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFQSO8dCiRl5i0qGqRd2XRMqjhdfaUGLmyzRWN2NSXaTriK9rlPzsdU/DvsRag1Pi36ygPNA==
X-Received: by 2002:a50:e1ca:0:b0:413:b403:f8e6 with SMTP id
 m10-20020a50e1ca000000b00413b403f8e6mr409182edl.204.1646845278203; 
 Wed, 09 Mar 2022 09:01:18 -0800 (PST)
Received: from gator (cst-prg-78-140.cust.vodafone.cz. [46.135.78.140])
 by smtp.gmail.com with ESMTPSA id
 g13-20020a50bf4d000000b00410d407da2esm1079848edk.13.2022.03.09.09.01.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Mar 2022 09:01:17 -0800 (PST)
Date: Wed, 9 Mar 2022 18:01:15 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Change text base address for 32
 bit tests when running under kvmtool
Message-ID: <20220309170115.pthw4vnxuwqpjrfw@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220309162117.56681-2-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Wed, Mar 09, 2022 at 04:21:16PM +0000, Alexandru Elisei wrote:
> The 32 bit tests do not have relocation support and rely on the build
> system to set the text base address to 0x4001_0000, which is the memory
> location where the test is placed by qemu. However, kvmtool loads a payload
> at a different address, 0x8000_8000, when loading a test with --kernel.
> When using --firmware, the default is 0x8000_0000, but that can be changed
> with the --firmware-address comand line option.
> 
> When 32 bit tests are configured to run under kvmtool, set the text base
> address to 0x8000_8000.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/Makefile.arm | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 3a4cc6b26234..01fd4c7bb6e2 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -14,7 +14,13 @@ CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
>  
> +ifeq ($(TARGET),qemu)
>  arch_LDFLAGS = -Ttext=40010000
> +else ifeq ($(TARGET),kvmtool)
> +arch_LDFLAGS = -Ttext=80008000
> +else
> +$(error Unknown target $(TARGET))
> +endif
>  
>  define arch_elf_check =
>  endef
> -- 
> 2.35.1
>

Applied to arm/queue,
https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
