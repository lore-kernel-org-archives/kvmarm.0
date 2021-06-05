Return-Path: <SRS0=TgZW=K7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E15C47082
	for <kvmarm@archiver.kernel.org>; Sat,  5 Jun 2021 08:46:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CE1E61057
	for <kvmarm@archiver.kernel.org>; Sat,  5 Jun 2021 08:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CE1E61057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47ED449F5F;
	Sat,  5 Jun 2021 04:46:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QVg4LJMnARKk; Sat,  5 Jun 2021 04:46:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70B984A1B0;
	Sat,  5 Jun 2021 04:46:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4951A40D0A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 20:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vYEOJIZ9xW+n for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 20:58:18 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A0C749E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 20:58:18 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id i5so9212191pgm.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 17:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=osHu87SZoZXOMS0NS84nF9iOOHnrmeoNqfJAhUD9Nl8=;
 b=Pa2JkyxLSE1rRGXabDLfYGJX/e+p4npDVCtYeuxRukmJiFGdGIs7Vo8XKOzfnQzs/h
 pbb10ZmPwg85W0Dj/cd2W3ynNa33DRRMiaarmlMcQH7ryJSk8MkcmDQypI8DrMcWoYol
 7goaClgk0qO6BplZ0Ao8y/pEzN0c96DZijxn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=osHu87SZoZXOMS0NS84nF9iOOHnrmeoNqfJAhUD9Nl8=;
 b=gixMJoj/t2lIoGlsUmgzFQv/uyGo/MCqpH0U+kHX+hahQ+wL1B+5nwYJCoE9q5UXeY
 jNh8asmJb+/CcjBOYPK+jrQDsJf8XvdNtw8tRb/sGXz1zwJjvCY4hj9F0VNWtJtF4vss
 x9PoaQ+qQs8tcBSkhaIPQk9EIWLal18BKYyEYXTw0xOrLU2fEqvbOmBiXHayR7BOVNM4
 nuumKy353BeQbRQzPKtx36NCz4MKz/W0jEsyhNZhc5OltyANbfR2PMgV4v7yQwrZ1Svt
 Ni+QUV9x5qevWjAh+BxKO9/3hNZE4Q9imxkuU76hHf1G1YVUSbpVkFRFJeQSZF9Roflf
 Hjig==
X-Gm-Message-State: AOAM530GWJoqYcRiHfE6uVW7d8sUtDKeawemKm7lCxkSY+kME6+Z65qr
 g9qjQAHrUXI2V75JM2XsDrbZeg==
X-Google-Smtp-Source: ABdhPJy+XB9KHA35L5KIcgyH8Y+GaTXYvt2kl0/zackCdS6suLdzG8cg7LKDJkfhiNoNuu0cLhDNPw==
X-Received: by 2002:a63:4145:: with SMTP id o66mr7648691pga.4.1622854697107;
 Fri, 04 Jun 2021 17:58:17 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:5981:261e:350c:bb45])
 by smtp.gmail.com with ESMTPSA id v11sm2662358pfm.143.2021.06.04.17.58.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Jun 2021 17:58:16 -0700 (PDT)
Date: Sat, 5 Jun 2021 09:58:10 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLrMIugtkxePl/UZ@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87v96uyq2v.wl-maz@kernel.org> <YLnwXD5pPplTrmoZ@google.com>
 <87tumeymih.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87tumeymih.wl-maz@kernel.org>
X-Mailman-Approved-At: Sat, 05 Jun 2021 04:46:23 -0400
Cc: linux-s390@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On (21/06/04 11:03), Marc Zyngier wrote:
[..]
> > Well on the other hand PM-callbacks are harmless on those archs, they
> > won't overload the __weak function.
> 
> I don't care much for the callbacks. But struct kvm is bloated enough,
> and I'd be happy not to have this structure embedded in it if I can
> avoid it.

Got it.

> > > How about passing the state to the notifier callback? I'd expect it to
> > > be useful to do something on resume too.
> > 
> > For different states we can have different kvm_arch functions instead.
> > kvm_arch_pm_notifier() can be renamed to kvm_arch_suspend_notifier(),
> > so that we don't need to have `switch (state)` in every arch-code. Then
> > for resume/post resume states we can have kvm_arch_resume_notifier()
> > arch functions.
> 
> I'd rather we keep an arch API that is similar to the one the rest of
> the kernel has, instead of a flurry of small helpers that need to grow
> each time someone adds a new PM state. A switch() in the arch-specific
> implementation is absolutely fine.

OK.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
