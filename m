Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEB4C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 06:48:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B11846112D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 06:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B11846112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AABC4B19D;
	Tue, 14 Sep 2021 02:48:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id chiE8VHwdkdC; Tue, 14 Sep 2021 02:48:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C3334B13B;
	Tue, 14 Sep 2021 02:48:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74434B13B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 02:48:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JhWVrQgR1B0h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 02:48:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C97434B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 02:48:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631602132;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UZ7o8ZJ24gb5TbRY3xTVpN4Kfg4Yx3sUWIRCXgdvIDA=;
 b=blIo+7S/7TmKEgmcznzDtNWsC74UPmXMqcczwiW6dTx1Oe0rR0znjYMZGOZXoG5iSAxzS4
 zNi/0jeqKHL85hKvX3BxRukdnxjtZaZd9RaH/LCNG2XSWEkhvMVa4RxZ4+NNT/Zr8P6LUK
 rTGBLCbX4z/IWhvcTVI2tqapKbaAAPE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-NXFvkq3JPuqYWGF7LnssNQ-1; Tue, 14 Sep 2021 02:48:49 -0400
X-MC-Unique: NXFvkq3JPuqYWGF7LnssNQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 w24-20020a056402071800b003cfc05329f8so6249279edx.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 23:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UZ7o8ZJ24gb5TbRY3xTVpN4Kfg4Yx3sUWIRCXgdvIDA=;
 b=wpeX8m5UZhEsQ2d7cAcsqgBFbUSjYovkIA6tq3V6eWiVZiNT6TQa2dvuAmg7IJ0/Bs
 vRs2UUJL1J80jjgfngkidKU86AZLVa3eQxhpJcfyZvqzy0/xVymEpLwHoCdv9fqbUkLq
 dSrZQwDJAZBMQePFG6Y+Yo0CwP8o0RaYXpBUmL1SAly46XOyKMDukAArIJ6BydRBDsNJ
 berequjw4x1JlIurrC3A4mq4uml6YQzU6hCvWW9JvzE+rxKpZmtBHShRG/EwzV8y4egi
 lXcPhcc9r2OoclBwjSEZyrGe30hWNSrVhiINrTnY0Ob+X0U8QpLtY9IIjZwCA6WyeeBM
 P4lQ==
X-Gm-Message-State: AOAM531GJGPvO9NUKOaSrhCTMPXCsp+83em2ipDI1cy6L5YLQj+m8SdF
 3XnpVF9T+geu/vPgcqF2InctJr0ZhaMHP9cXqmJm/Ll7bYwGxWcMIrn3B+2r0k11HoaxDv7ITKS
 X58OulA7BdUViV1j/ggz/fdGr
X-Received: by 2002:a17:906:8481:: with SMTP id
 m1mr17698374ejx.459.1631602128197; 
 Mon, 13 Sep 2021 23:48:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw/4k09BImJGGLEkWCmc0EMaDoeTSkvL0ybA8OStqRMYzS/MmU4Z+f7vH4tYT3VtEQ0mZWKQ==
X-Received: by 2002:a17:906:8481:: with SMTP id
 m1mr17698349ejx.459.1631602128062; 
 Mon, 13 Sep 2021 23:48:48 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id m10sm4338731ejx.76.2021.09.13.23.48.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 23:48:47 -0700 (PDT)
Date: Tue, 14 Sep 2021 08:48:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 02/14] tools: arm64: Import sysreg.h
Message-ID: <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-3-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210913230955.156323-3-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Sep 13, 2021 at 11:09:43PM +0000, Raghavendra Rao Ananta wrote:
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into tools/ for arm64 to make use of all the standard
> register definitions in consistence with the kernel.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/arch/arm64/include/asm/sysreg.h | 1296 +++++++++++++++++++++++++
>  1 file changed, 1296 insertions(+)
>  create mode 100644 tools/arch/arm64/include/asm/sysreg.h

Looks like an older version than what is available now (v5.15-rc1?)
was used, but it's expected that these tools copies go out of date
quickly and it doesn't matter.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
