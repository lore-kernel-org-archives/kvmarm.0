Return-Path: <SRS0=lrOB=GC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAADC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 11:03:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 028BE20789
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 11:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 028BE20789
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5AB4B185;
	Wed, 30 Dec 2020 06:03:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2a5ivqSTDAr4; Wed, 30 Dec 2020 06:03:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2609F4B15B;
	Wed, 30 Dec 2020 06:03:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A977E4B163
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Dec 2020 06:03:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hvzBiFG6sTF6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Dec 2020 06:03:03 -0500 (EST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B96094B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Dec 2020 06:03:03 -0500 (EST)
Received: by mail-wm1-f51.google.com with SMTP id q75so4454478wme.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Dec 2020 03:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=WS30afWY3GKACZJXCkkdeuRXpGLieFQFBc+EFWHXZ8I=;
 b=mcpxu45JEAPmoccMikSFXPzTHkYmNC9Cr2PxZF40ApQKLEt8ZByo+t4Jg+RtvlgioZ
 KPFZPvQog2EMXmEuRxbQyh1m8Tgk0umqTlpZKvxJUo2DJucEj9nfKymKPAPUqWFAD9cO
 VYzGwqDMiJn+rq4wPNXnI3mmw0MGIG408+6RDbnHSbM81z7fptRzXUanxDddqvV6JwKw
 4P6vsMKVg5ADZEBJVnbIoINXwH3okfS0SYIXIG1pW9wX36MQ5b/4XwpAYWA6Mc6UXq5Z
 SGY8fG+SjE0UUOIQdOSxaWjRr8S/Xouoc3xoINaMgpjvsBwb3pXklmthHBqXNoVcw2gD
 O+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WS30afWY3GKACZJXCkkdeuRXpGLieFQFBc+EFWHXZ8I=;
 b=CBl5liwWVZXDvJmTq0u1NIXf/8uh4P3xE7ccfBfgZojUU1wF09+ixT7DYBEqBP/Lk7
 JsarhS+ujnC+Bassu12ggYuzvjt9Eh37O8u/zmp0yd4hZPqsxKb9nJrUXFG6IG5Qifhg
 fPC4OTG2POEtDlHMAMzXykwdvUjAgvrXrzNmQcq455cGYqEGQgePD33h8XGEYRgb1pA5
 +4njfHvse88Hi/36v62S1bfnrdlAHls9TmkEh2F/KcQ8Ti+Y5VNmjX4USjh/RVqx32A4
 dyh16D84johIZJd/+nlOrzw1gHrZbKp/dMdgQU+OYftchyvc4x71TVKKEwv5+9bV//H8
 n5Wg==
X-Gm-Message-State: AOAM530BgJcoZoRLVb6BRF1qzBc2we2riiASmCe1MMAoem1wMYssOT2m
 /tDShdZOUzgl2ovRSypRYjl5Ew==
X-Google-Smtp-Source: ABdhPJzRBv6eAt8+sGkPthVC4MF6WX/caLmzGEjiLKFuGvqf5bNuQxrUjMah5pk6tT2ykIwAJbZmTw==
X-Received: by 2002:a1c:4156:: with SMTP id o83mr7146093wma.178.1609326182577; 
 Wed, 30 Dec 2020 03:03:02 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:b0e4:997:fb3:e517])
 by smtp.gmail.com with ESMTPSA id y130sm7256253wmc.22.2020.12.30.03.03.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Dec 2020 03:03:01 -0800 (PST)
Date: Wed, 30 Dec 2020 11:03:00 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
Message-ID: <20201230110300.a2wei7ojhjkqfkgk@google.com>
References: <20201229160059.64135-1-dbrazdil@google.com>
 <229d84b8d7818a170adf489535ea2d43@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <229d84b8d7818a170adf489535ea2d43@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

On Tue, Dec 29, 2020 at 05:16:41PM +0000, Marc Zyngier wrote:
> Hi David,
> 
> On 2020-12-29 16:00, David Brazdil wrote:
> > The KVM/arm64 PSCI relay assumes that SYSTEM_OFF and SYSTEM_RESET should
> > not return, as dictated by the PSCI spec. However, there is firmware out
> > there which breaks this assumption, leading to a hyp panic. Make KVM
> > more robust to broken firmware by allowing these to return.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > index e3947846ffcb..8e7128cb7667 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > @@ -77,12 +77,6 @@ static unsigned long psci_forward(struct
> > kvm_cpu_context *host_ctxt)
> >  			 cpu_reg(host_ctxt, 2), cpu_reg(host_ctxt, 3));
> >  }
> > 
> > -static __noreturn unsigned long psci_forward_noreturn(struct
> > kvm_cpu_context *host_ctxt)
> > -{
> > -	psci_forward(host_ctxt);
> > -	hyp_panic(); /* unreachable */
> > -}
> > -
> >  static unsigned int find_cpu_id(u64 mpidr)
> >  {
> >  	unsigned int i;
> > @@ -251,10 +245,13 @@ static unsigned long psci_0_2_handler(u64
> > func_id, struct kvm_cpu_context *host_
> >  	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
> >  	case PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
> >  		return psci_forward(host_ctxt);
> > +	/*
> > +	 * SYSTEM_OFF/RESET should not return according to the spec.
> > +	 * Allow it so as to stay robust to broken firmware.
> > +	 */
> >  	case PSCI_0_2_FN_SYSTEM_OFF:
> >  	case PSCI_0_2_FN_SYSTEM_RESET:
> > -		psci_forward_noreturn(host_ctxt);
> > -		unreachable();
> > +		return psci_forward(host_ctxt);
> >  	case PSCI_0_2_FN64_CPU_SUSPEND:
> >  		return psci_cpu_suspend(func_id, host_ctxt);
> >  	case PSCI_0_2_FN64_CPU_ON:
> 
> Thanks for having tracked this.
> 
> I wonder whether we should also taint the kernel in this case,
> because this is completely unexpected, and a major spec violation.
> 
> Ideally, we'd be able to detect this case and prevent pKVM from
> getting initialised at all, but I guess there is no way to detect
> the sucker without ... calling SYSTEM_RESET?

Yeah, there are no bits to check, unfortunately. :(

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
