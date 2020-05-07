Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD78C38A24
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:36:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7591208D6
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="va8IcNz8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7591208D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FAB54B375;
	Thu,  7 May 2020 10:36:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6XVJb9eUZYOv; Thu,  7 May 2020 10:36:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C73B4B316;
	Thu,  7 May 2020 10:36:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 376F34B316
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ebmodWM+icm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 10:36:39 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DEE34B2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:36:39 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id x17so6682592wrt.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2020 07:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2cUePzGWzDDGYMdSJecoGhzZI0bICDSzA7fgbQwoVdI=;
 b=va8IcNz8I2zqjE9CHsCzAnM6YWsHCkT+6BNuJ8fRsAg/QlH3lUCW+YkNknR8VqSvOG
 E/IC3lRkd0ZwHQalan9TG1D4/w2fUTyiZGxS/Q17YpXKcCbyWWsxSxx0xFlWxdzfx+ut
 ysYussSGR3GqsKtZzvNvKz5uEtHfKa8FYgUcDiMWE1hpFlB7r3M6eaEtZRKXOjsn7QfN
 oORfrpfCEN3NfkyQRARTPBZf4GQ7PEgSTsKIsFDcD3penmf6YN2IBJ8mFLFunzaBnjmu
 tuILSOMKhNChWN19gJNhOvmcEv+JElMcVgODP4coW1YiN9SIPkaGu9JYdaOSup2+p4YN
 6M5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2cUePzGWzDDGYMdSJecoGhzZI0bICDSzA7fgbQwoVdI=;
 b=ncLXSKRW8YxO6HP+fEmJ0sPIpRShY1MMV2KKVnJ0CMyj2lEM8mNiIVAygbob4KmEP+
 EeofNHYbPyX//LVQ1POcy1+/gIKrkPTjNwQAz64Fs7fjO+ihDid3nHBGoya4tGS+gpBg
 jKx2ajl8876rzbx2z87nkXVcr0nWFmAJq8kuQAte+UPUlWSKq3eRRTv/flkPZcOw35DN
 4TdJKDArstUnudFv48rUy7zSq4aOsfXidgD+OvfzUIf4joBj9wCpoY1jDI2IV4OVXUDZ
 wYNu00ylNsirplvKlZ9wNfKrBfLD8IjZUkYXpQfBcsv+H0J6fZMJWvaXM7i//jUUDVVp
 0kQw==
X-Gm-Message-State: AGi0PubOx/v/tg+YMoQ9VoOOfmp/S0nk19gboZCYMvDmzLEaRw5/dyrF
 QkTRrPPkXa66fm8HZkUerHhWvQ==
X-Google-Smtp-Source: APiQypIg/E6o9sgqmhLM4Cgv9qszquDB3MDl0xGyH0m0ulxsGd7+lcGC7cQvQySga4gTWRe+HpOBog==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr15498170wrq.171.1588862197885; 
 Thu, 07 May 2020 07:36:37 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
 by smtp.gmail.com with ESMTPSA id h17sm8450409wmm.6.2020.05.07.07.36.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 May 2020 07:36:37 -0700 (PDT)
Date: Thu, 7 May 2020 15:36:33 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/15] arm64: kvm: Unify users of HVC instruction
Message-ID: <20200507143633.GA169263@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-2-dbrazdil@google.com>
 <878si3j13w.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878si3j13w.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

On Thursday 07 May 2020 at 15:01:07 (+0100), Marc Zyngier wrote:
> >  /*
> > - * u64 __kvm_call_hyp(void *hypfn, ...);
> > + * u64 __kvm_call_hyp(unsigned long arg, ...);
> >   *
> >   * This is not really a variadic function in the classic C-way and care must
> >   * be taken when calling this to ensure parameters are passed in registers
> >   * only, since the stack will change between the caller and the callee.
> > - *
> > - * Call the function with the first argument containing a pointer to the
> > - * function you wish to call in Hyp mode, and subsequent arguments will be
> > - * passed as x0, x1, and x2 (a maximum of 3 arguments in addition to the
> > - * function pointer can be passed).  The function being called must be mapped
> > - * in Hyp mode (see init_hyp_mode in arch/arm/kvm/arm.c).  Return values are
> > - * passed in x0.
> > - *
> > - * A function pointer with a value less than 0xfff has a special meaning,
> > - * and is used to implement hyp stubs in the same way as in
> > - * arch/arm64/kernel/hyp_stub.S.
> 
> I don't think any of this becomes obsolete with this patch (apart from
> the reference to 32bit), and only changes with patch #2. Or am I
> misunderstanding something?

Nope, I think you're right. To be fair, this patch has changed quite
a bit since the first version (which did change that comment a little
later IIRC), but David has done all the hard work on top so I'll let
him answer that one.

And David, feel free to take the authorship for this patch -- I barely
recognize it (for the better), so it's more than fair if you get the
credit :)

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
