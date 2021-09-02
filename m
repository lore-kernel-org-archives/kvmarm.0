Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835E6C432BE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:43:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02BC3610CE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 02BC3610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7070C4B120;
	Thu,  2 Sep 2021 10:43:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZsI6k5REW1Xp; Thu,  2 Sep 2021 10:43:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6474B134;
	Thu,  2 Sep 2021 10:43:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 793FA4B128
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:43:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7EOj3b3pRuF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 10:43:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9D64B120
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:43:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630593809;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fHO5Tzwhao5TiABrZCBAUisQfo436W0ONUMzhgH6h6s=;
 b=BxSroMcTIYvGGurcloBi3/Gy8HT2smMkbMhawo9LdyNrH+OoMXcEuQpqtW4f1tGLVfYN2M
 IGzkPC4KBNmxDZ/Ulk7crT/xQeXUahX87g9dJ8l60/suvU72I0JypwBc2orvQcT8AVG5LF
 kflVBJlblGu5mB3pxWipQfE74o/6GK4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-tg_deOP-OTaeHb3fIZ4BPQ-1; Thu, 02 Sep 2021 10:43:28 -0400
X-MC-Unique: tg_deOP-OTaeHb3fIZ4BPQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 m16-20020a7bca50000000b002ee5287d4bfso778723wml.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 07:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fHO5Tzwhao5TiABrZCBAUisQfo436W0ONUMzhgH6h6s=;
 b=nudIqLxeBM+yT4mO0n/iTJ1OlaXhrYs6Fj4IO4vPa31RiuBuBJucr8wVZMwCm8Us0N
 C33UGa8kR9ug9G6k+tRlrxesJ/3Mit0PGbysC2uLG0kMKKn6SfPPccEdjm8TR8xDaXAP
 yMh0bQjSM3Ha27JE7Z2q0SDjDNH3AqCBXpDCKZqFSiBkRkT+DJDaRzim5v2rKMyZUbFO
 WR3h81T+m1bmWCrT8+gp0+yExwD/mWZGo163qKvV3IemSiUxk5iW/j+8T6IE5h2p15wQ
 gItAqgTNYhG/Di9sd/15fcTpDwnWeyn0KGVcRvcWCBaIcKGVLuaWMUfsMbYkSs10YipC
 VvTw==
X-Gm-Message-State: AOAM5327moK+Ou9yVpDihSvM5VLSJ4W9+C7Nnj0IBq5DOjY2sU+YHfG6
 +JYneZUAyFd1uDepbRGJe+nycsk/j7cmy7lPe5mi4+COJR1hWloEzYacvBcsGZLo7Xw6AnYt1ON
 ouqxeBoZCEEwMe0IfMpWZAIrV
X-Received: by 2002:adf:d185:: with SMTP id v5mr4114895wrc.378.1630593807497; 
 Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAITxf/zsmp3O/FLDDlzAAMda3pWOdK4AMw/uZTLp2t5nLI+RKcceAMXP4cp6k6aVrvMWRkw==
X-Received: by 2002:adf:d185:: with SMTP id v5mr4114878wrc.378.1630593807374; 
 Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id p4sm1786988wmc.11.2021.09.02.07.43.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
Date: Thu, 2 Sep 2021 16:43:25 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable
 and enable local IRQs
Message-ID: <20210902144325.c3beg3qqnfdwj6um@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-7-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-7-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:06PM +0000, Raghavendra Rao Ananta wrote:
> Add functions local_irq_enable() and local_irq_disable() to
> enable and disable the IRQs from the guest, respectively.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
