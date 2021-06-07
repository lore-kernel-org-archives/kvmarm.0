Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9060C47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 17:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78C3F6105A
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 17:17:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78C3F6105A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 271B84B0B5;
	Mon,  7 Jun 2021 13:17:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GkeegYBK19cu; Mon,  7 Jun 2021 13:17:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80E274B089;
	Mon,  7 Jun 2021 13:17:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8644A173
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:07:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5JPaJob+jr9a for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 12:07:46 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E80049E5F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:07:46 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id m7so503657pfa.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 09:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4pT+fPdmYDqDMFuFLXYZiJ/4/kBu8OXPCoDOzFw+hto=;
 b=s8B6/VkuyXq4qdYRCmbgDg+SuezH6hOi58cGFA8q/J9XqHQlocG8YjLu7ejgMWS/xX
 fed8XbG0wA0QUN4lym+108KLQDsbNs4KIbRKYo6ilZOvq0o+d6UyoR//aLXn1Hu/vlAq
 yP1ZP+cxFayYOfDE9LeAJPdGGrWedrAAUYMHZSd48ZxJfOHA8eMFXyZJhu15By4aWLpE
 wE70dG4QXBHkg2XblNgK4vtxL/COW5tWSLBPuBynh4Db6gExW4b3XTknI75Gwm8TIZ5b
 4pEaSRuON5OtGFW4NYQDPLWQvFtE4A0IvVd/m1uWCVKDTMruHgrAinkwRR9JPq0A+Iss
 gf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4pT+fPdmYDqDMFuFLXYZiJ/4/kBu8OXPCoDOzFw+hto=;
 b=Q0fMHe8kiO/T6nDSFUDWipW0ZU/32NuSqEsJzPClGibe8RmP4jxe2dHR4zgKZHfnTi
 /L6K9mU8mPgetEiMXwGqwPH8yIyacXEl4FF6jDPKbbmwGv5vlvcnAxx1IQSaOWOxVGsc
 7m95dN5mLouNkMb+c7JbC20aXla/dkFi1aKDoVjwMZ+ZswkPupYPHloUZBPfeuwkY+ms
 L4hlu4XxgRIQ4bR3mT/aILTvLR5Rhf+GXbnhlKUbMVcB5PWb2adNWHqiINK35qB/2X5Q
 lyPwGe7DLBsqn3qqBEoJHsHgZc6StJINqOHlUYkz7CTJNTsr+oDesamYVwqeUUHfWkYA
 UwZQ==
X-Gm-Message-State: AOAM530oq6rCRcoPiFfKhriwzGylxXc54KBvB0KSC8zma4s10JEOurRi
 5BgrTNaJ+55zaK2qUXzcpvqXyg==
X-Google-Smtp-Source: ABdhPJwlwJ6AkmZNuLpzKISd0pSadI1yVpmHR5ZCOBmzeB1TAshfbuXw/bugo1uFnF0tkAOa9I2F0g==
X-Received: by 2002:a62:8204:0:b029:2ea:2647:bb4f with SMTP id
 w4-20020a6282040000b02902ea2647bb4fmr17635905pfd.23.1623082065121; 
 Mon, 07 Jun 2021 09:07:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id g63sm8580661pfb.55.2021.06.07.09.07.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Jun 2021 09:07:44 -0700 (PDT)
Date: Mon, 7 Jun 2021 16:07:40 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YL5ETJatW+BM9vKS@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com> <YLqzI9THXBX2dWDE@google.com>
 <6d1f569a5260612eb0704e31655d168d@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6d1f569a5260612eb0704e31655d168d@kernel.org>
X-Mailman-Approved-At: Mon, 07 Jun 2021 13:17:14 -0400
Cc: kvm@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Sun, Jun 06, 2021, Marc Zyngier wrote:
> This is becoming a bit messy. I'd rather drop the whole series from
> -next, and get something that doesn't break in the middle. Please
> resend the series tested on top of -rc4.

That'd be my preference too.  I almost asked if it could be (temporarily)
dropped, but I assumed the hashes in -next are intended to be stable.

Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
