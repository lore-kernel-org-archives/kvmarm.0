Return-Path: <SRS0=F0YX=TY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C23C072B5
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 19:22:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13C7B217F9
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 19:22:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13C7B217F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53FE64A496;
	Fri, 24 May 2019 15:22:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ov5a+lyKh13K; Fri, 24 May 2019 15:22:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6E94A49C;
	Fri, 24 May 2019 15:22:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6254A477
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 15:22:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1WxJhq25MnQn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 15:22:53 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5011A4A389
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 15:22:53 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id t4so2775670wrx.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 12:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Ug4Bl3el14wpTnYvRfqXJCkiW+ZQVz0A+SEzks8ca+c=;
 b=a+KESVXTZqC0nlDtZ1lynsSPNOQkSbbwsAseWhcZ9EWqga/LgKDbeoMatXkoPAhmHO
 qd4qIWdttsonVkU9qvQe/2pbV8jP0NbUev6t0oYf5kHM/SvVDTkVizzvt0BQ9CVH5RHq
 6U1anq68ycBuyuo3WOhrRi0G1o7SoFzsVdo2lMPcbdlSnayY5yNBqvvaTUKiU6pWP48E
 MycvRkj1L1DsR6HDt5rQwydPAoJeDZg3Yw9lZEBR4FDMiM1T6VD8G6ZpCxu2C8IKs0zq
 Mwvn2eG9dgMMFBPgx8kIfigaBa52KhNvsF2jm6hNOCuvecGy/P0MPYt+IYS3zqebSESM
 2a3Q==
X-Gm-Message-State: APjAAAV1MpPwMX3XGObiigb1JcrllaVEyN/Y9bSWQicO4lLwfW0ZgAgt
 bUqs1H7mCfDUHjfzczlsb3dJFw==
X-Google-Smtp-Source: APXvYqxc9I/gqPCwUGGqH4wF3p5c19c142inhBUwCyjvflRF3Erk2N54jSOBP2OotGkbtC4HE70Ugw==
X-Received: by 2002:a5d:4b81:: with SMTP id b1mr39369544wrt.217.1558725772192; 
 Fri, 24 May 2019 12:22:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
 by smtp.gmail.com with ESMTPSA id n5sm4642955wrj.27.2019.05.24.12.22.51
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Fri, 24 May 2019 12:22:51 -0700 (PDT)
Subject: Re: [PATCH 1/3] MAINTAINERS: KVM: arm/arm64: Remove myself as
 maintainer
To: Christoffer Dall <christoffer.dall@arm.com>
References: <20190524144745.227242-1-marc.zyngier@arm.com>
 <20190524144745.227242-2-marc.zyngier@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1adc9268-438e-6c24-7883-690960d1c060@redhat.com>
Date: Fri, 24 May 2019 21:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524144745.227242-2-marc.zyngier@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
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

On 24/05/19 16:47, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> I no longer have time to actively review patches and manage the tree and
> it's time to make that official.

Thanks Christopher for your work, I hope to meet you anyway at KVM Forum!

Paolo

> Huge thanks to the incredible Linux community and all the contributors
> who have put up with me over the past years.
> 
> I also take this opportunity to remove the website link to the Columbia
> web page, as that information is no longer up to date and I don't know
> who manages that anymore.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5cfbea4ce575..4ba271a8e0ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8611,14 +8611,12 @@ F:	arch/x86/include/asm/svm.h
>  F:	arch/x86/kvm/svm.c
>  
>  KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
> -M:	Christoffer Dall <christoffer.dall@arm.com>
>  M:	Marc Zyngier <marc.zyngier@arm.com>
>  R:	James Morse <james.morse@arm.com>
>  R:	Julien Thierry <julien.thierry@arm.com>
>  R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	kvmarm@lists.cs.columbia.edu
> -W:	http://systems.cs.columbia.edu/projects/kvm-arm
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
>  S:	Maintained
>  F:	arch/arm/include/uapi/asm/kvm*
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
