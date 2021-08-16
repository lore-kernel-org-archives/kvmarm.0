Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C3AC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 12:16:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 019D061C13
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 12:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 019D061C13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6569F4B08E;
	Mon, 16 Aug 2021 08:15:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e6ax7ysLyb4j; Mon, 16 Aug 2021 08:15:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF604B0B3;
	Mon, 16 Aug 2021 08:15:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DDA4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 08:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IMXQbXdhgu3B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Aug 2021 08:15:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E9E4B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 08:15:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629116153;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TtYSIBToB+BmD+CawxpOkHBAy0xx9e6INa/j+nR9EVA=;
 b=bwBIshdD+NLhzrNXvsUiXXTaEsegYTgLoxrpK6+Df3GgJnAV9dgNJFvfBjfEtHqml80FGy
 /ViVowtfvhcUiFDTOzMpoV/VJ5A6xl/zJkvWYUcvXyO+XvZK2o3VSGG3LI0YVCLUAk/XL8
 y1C6jtsFu1Kr/70sCQ9Wh7MGrzUApqs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-n8Z6LsGuP2OW-qBQyhjbTA-1; Mon, 16 Aug 2021 08:15:52 -0400
X-MC-Unique: n8Z6LsGuP2OW-qBQyhjbTA-1
Received: by mail-ed1-f69.google.com with SMTP id
 e3-20020a50ec830000b02903be5be2fc73so8689662edr.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 05:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TtYSIBToB+BmD+CawxpOkHBAy0xx9e6INa/j+nR9EVA=;
 b=BJNDtI6VTZULMe93VuntTVjuv30DK9pIgkM874V/eGVW9wsZrZLDPVwLKwBcyNCFr/
 QBDqz7T8IUvI2Y9I1sl57CqT37TblzMlIaiTV8SL4sf9Be8K0Non6hPWGaguNKe5nXzP
 +rZ+2O4vN6NWl5oTjZetjKHpu3smEH1reXyqIJdJR6tO9MI7EfrnZskpgc+yu3xZ04IJ
 ib+AvFRoUfNd6DdEnRNphRBqxU1uvz0PY8Rb+Mf4E7u8VUiKjQ7OfVkFzUIciL6wNJD2
 Zfso5U1zS3e1ra/uCzI0If1vuhHAnOpxAHelxUha97DV/BlX8JU0S86/hUoMQh7jvePl
 5g5w==
X-Gm-Message-State: AOAM533aKOuRCmkobnlgepcrG/K4WOyJmWuIXYOorY6N4xmrN7J4m5Dp
 EahscPD7aE1UespIXb7yCLMUZp4kH99ECEFlkNqwLINQ34b7+cfRlWLUnlWBJeHJeAp6mD0l48R
 cvgzMbvkOxbx1RxlwzxJOcKIt
X-Received: by 2002:aa7:d4d3:: with SMTP id t19mr19498083edr.131.1629116150791; 
 Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfEaBs2MuLXmF0DrS7/u9PwEaM1QS6mBptDHXsF4n5KvyWlM5xu2nsqC6r+jAqSDuEOjSG1Q==
X-Received: by 2002:aa7:d4d3:: with SMTP id t19mr19498046edr.131.1629116150580; 
 Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id ck17sm4786345edb.88.2021.08.16.05.15.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
Date: Mon, 16 Aug 2021 14:15:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
Message-ID: <20210816121548.y5w624yhrql2trzt@gator.home>
References: <20210813211211.2983293-1-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Aug 13, 2021 at 09:12:01PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-10). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Since the test heavily depends on interrupts, the patch series also
> adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
> to the KVM's aarch64 selftest framework (patch-9).
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, spinlock support,
> and so on, are also introduced that the test/GICv3 takes advantage of.
> These are presented in patches 1 through 8.
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 

Hi Raghavendra,

I appreciate the new support being added to aarch64 kselftests in order to
support new tests. I'm curious as to why the kvm-unit-tests timer test
wasn't extended instead, though. Also, I'm curious if you've seen any
room for improvements to the kvm-unit-tests code and, if so, if you plan
to submit patches for those improvements.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
