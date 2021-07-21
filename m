Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1896CC636CA
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 908DA6121F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 908DA6121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314304B121;
	Wed, 21 Jul 2021 08:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJfBw35gDUIJ; Wed, 21 Jul 2021 08:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D99C94B134;
	Wed, 21 Jul 2021 08:20:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C19E4A483
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 21:15:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8hfseFjDni8v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 21:15:54 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A12649F83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 21:15:54 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id i14so989906pfd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 18:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UXoV+cGKQ4myvPfURbj+4IGhllQad57NXO7QIqiHQD4=;
 b=H3ES8RUOc7jcBhXKSSld1nbtEpTXLfbidaCzKfB/7XWZnxi/oMpreSNT8W9IF2UQFL
 j53LKazE8AZ9Zwuz9I4JcCE7RID2J6gT2zRjeiHMGJSJiWsWf5QNFSWGnQJdK6/c+m6e
 281I99+7jaPLChAxNoOpxnsyI/mmQKcHRHYFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UXoV+cGKQ4myvPfURbj+4IGhllQad57NXO7QIqiHQD4=;
 b=Q6G26e+L8c2VLbA98ISBcpsJdvXnVoOdlpynqHP1ebrJRvgdMPCy2g8JJtqWyTtL+4
 XtUZfr+MBDbocJg1yiYpFeJvnLVSehtxrHwTlN6SIX5OMMJicU+Ms3fFX+OWacRyfE06
 LpZw3k5dIUi/Cbkxzdlx+7VzS1YhKMXn32ZP+S6wvVcHvKxVvvNIIF9JFbdlbTZ76KsO
 CPnA+/wteK7RZEuwyvDkrc5BiW+2QE16hQoVeZjU+a3eP1TpcnDFbZILYncbI9YDqR8S
 JAS6VBLTUpI/+5SMjPTX9g1fZQOxppvKyjy//HXBj/m9gDm/ZSYlX4SFpuXMnckLFAAF
 FKlw==
X-Gm-Message-State: AOAM530WUfUYxvUXvaSNywRWak6m46Nu0/OGHfNfQ6ZpmwuTBaQ03nqd
 VST0n6I2hGKtTzddijPFQJuwFQ==
X-Google-Smtp-Source: ABdhPJxfp5hGyASzFBCflJxvg/JXYrMBHZ4gp61qQS2+oVr0x7oYazVdBxY8Q9kTjoig37pYkCKYGg==
X-Received: by 2002:a62:19c9:0:b029:32a:129f:542d with SMTP id
 192-20020a6219c90000b029032a129f542dmr33857420pfz.8.1626830153493; 
 Tue, 20 Jul 2021 18:15:53 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:808c:1a13:1159:8184])
 by smtp.gmail.com with ESMTPSA id x18sm23934960pfh.48.2021.07.20.18.15.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 18:15:52 -0700 (PDT)
Date: Wed, 21 Jul 2021 10:15:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCHv2 4/4] arm64: add host pv-vcpu-state support
Message-ID: <YPd1Q1ppmKng67tk@google.com>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-5-senozhatsky@chromium.org>
 <874kcz33g5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <874kcz33g5.wl-maz@kernel.org>
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
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

On (21/07/12 17:24), Marc Zyngier wrote:
> >  
> >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  {
> > +	kvm_update_vcpu_preempted(vcpu, true);
> 
> This doesn't look right. With this, you are now telling the guest that
> a vcpu that is blocked on WFI is preempted. This really isn't the
> case, as it has voluntarily entered a low-power mode while waiting for
> an interrupt. Indeed, the vcpu isn't running. A physical CPU wouldn't
> be running either.

I suppose you are talking about kvm_vcpu_block(). Well, it checks
kvm_vcpu_check_block() but then it simply schedule() out the vcpu
process, which does look like "the vcpu is preempted". Once we
sched_in() that vcpu process again we mark it as non-preempted,
even though it remains in kvm wfx handler. Why isn't it right?

Another call path is iret:

<iret>
__schedule()
 context_switch()
  prepare_task_switch()
   fire_sched_in_preempt_notifiers()
    kvm_sched_out()
     kvm_arch_vcpu_put()
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
