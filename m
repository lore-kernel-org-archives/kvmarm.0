Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36165C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 12:38:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A01F261168
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 12:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A01F261168
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177554B0DD;
	Wed,  8 Sep 2021 08:38:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AyiCcCMb2Fey; Wed,  8 Sep 2021 08:38:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D984B0E7;
	Wed,  8 Sep 2021 08:38:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C17AE4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 08:38:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJEDWqRqKlSc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 08:38:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6D1407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 08:38:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631104721;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HLILDPxKgTqKXnfuzAZAfkzzX4dTKMN4K2TKBTinPy8=;
 b=D0tydaL518ZpQkubxTFAgD+b0Pnd1oAEt1bBldPyybGkfCVEqC/ruqvuTcyxPkXlTjaxTY
 +a2mC7u1pYjuLNHSJDo9/50QYEofNW8OEHa4S7DALEUaLVJBlHlYd+6uVH8yKQyCHgf76i
 OZjECARgTwfOE+VSOvpEZ7vgfktmLPM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-zjsg3ip6OyC2qq78-Reu1A-1; Wed, 08 Sep 2021 08:38:40 -0400
X-MC-Unique: zjsg3ip6OyC2qq78-Reu1A-1
Received: by mail-ej1-f70.google.com with SMTP id
 dt18-20020a170907729200b005c701c9b87cso931081ejc.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 05:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HLILDPxKgTqKXnfuzAZAfkzzX4dTKMN4K2TKBTinPy8=;
 b=IDMiVbgCqg7mHM4BGl/odtVyHVr0YCZigmwI56yEEZTuHsHrf/M0pMe49Q3XXhUuFb
 l91uh1uSjJT0J8RQcw9X573N8UzYhhCgiep+H8PDdFgGiBBraG3OzOUwt5jC2Hgb4W3y
 7LTbqK6R2AycSt7PKX1fAN97soINZMyACFiYrOexiqvbO+vYBsD+f89ONh4qWf8GTaUy
 l9q7ySRmJvphdjqvfEXQEP/MjqqSJnHKOv9/tt12ojk1HogpjZQfObO+nwDFI10s0hRa
 xv4/baITgoj/nwPd9VJoVV0kymNVyG71MWI97mF+0nl9+UoKUuxk6UcnenDya+B/vZVz
 oFiQ==
X-Gm-Message-State: AOAM530Mapq/8+PoxSWoYz6xe0T0JkzljUvQtTegQTd4ipL0OeLb7gAb
 3IAQlHrBDISvPBRwxM/xoCPlgawBsKQ3pvznpTZSqAehuC4VTXDMqBL00AOLGo3HSb/MGawpdU+
 8aajUko+3/Hm3QDSkcKx7c/H0
X-Received: by 2002:a50:998f:: with SMTP id m15mr3606144edb.193.1631104719304; 
 Wed, 08 Sep 2021 05:38:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycLx7AoNuPav5pLLv7LxfvSTvHfNhFqLrFBMo/KI4x2WofYcProh3FH9UDqZ+zN64+XUkKlQ==
X-Received: by 2002:a50:998f:: with SMTP id m15mr3606130edb.193.1631104719187; 
 Wed, 08 Sep 2021 05:38:39 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id w3sm1072659edc.42.2021.09.08.05.38.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 05:38:38 -0700 (PDT)
Date: Wed, 8 Sep 2021 14:38:37 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Add missing field descriptor for
 MDCR_EL2
Message-ID: <20210908123837.exyhsn6t2c7nmbox@gator>
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-3-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210827101609.2808181-3-tabba@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Aug 27, 2021 at 11:16:03AM +0100, Fuad Tabba wrote:
> It's not currently used. Added for completeness.
> 
> No functional change intended.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 327120c0089f..a39fcf318c77 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -295,6 +295,7 @@
>  #define MDCR_EL2_HPMFZO		(UL(1) << 29)
>  #define MDCR_EL2_MTPME		(UL(1) << 28)
>  #define MDCR_EL2_TDCC		(UL(1) << 27)
> +#define MDCR_EL2_HLP		(UL(1) << 26)
>  #define MDCR_EL2_HCCD		(UL(1) << 23)
>  #define MDCR_EL2_TTRF		(UL(1) << 19)
>  #define MDCR_EL2_HPMD		(UL(1) << 17)
> -- 
> 2.33.0.259.gc128427fd7-goog
>

If we're proactively adding bits per the most recent spec, then I guess we
could also add HPMFZS (bit 36). Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
