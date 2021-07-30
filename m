Return-Path: <SRS0=pkzt=MX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1EEC4338F
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 750C661040
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 750C661040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E393F4A19F;
	Sat, 31 Jul 2021 05:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWUnIDyeV-zQ; Sat, 31 Jul 2021 05:33:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C2C4AED4;
	Sat, 31 Jul 2021 05:33:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9554B08C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:24:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o5FCcfSIQXUi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 12:24:06 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E4FD4A19E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:24:06 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id i10so11694084pla.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 09:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9Dt7BPkqKJMerMDAUFj+9/P/yGyah1WPEScK3C0WzA4=;
 b=dB/7UCE7sp7q+bEm8dm5tdQNQGCMHmj7u+PrWEFahjhHDjJaNkqQkVeqD0H+Ls4llN
 C5sWP5NLwCkAZuvoYJCHubExu9LiCnALoCfusst8K06XqgFScxO7tlHOeFx+K1qS2MTw
 LMMfvx36FQU7t0ov0W6nl2B5AXFx3BcPlVItSW5YC4cWzaa/gl0XttSRyqP2oRaqjCAi
 zf8nLFILyqe51JcEL8GR42b/BAGQYqld4sO66AS6HhwyVENHdL8XW/C/H/xzlhMQcED5
 I43rIH/KK3LNK+yLFyD/40DB2bdvHosUf0Kwky1pBu3Chq+GSZxvyR9JeklPGv5evsDs
 eB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9Dt7BPkqKJMerMDAUFj+9/P/yGyah1WPEScK3C0WzA4=;
 b=Wtp6BJVXmeW8l6V5CkBTxpIaxI380vfzWxnL/jacXqqN+s2jNvFTsw8U2z4jy9exyT
 l6vYRGyqv1BFNpw/EO/6JKDe1NslbesxpwNQCQtvQpUxfeRkT4F6kfVX1un3JPOZfStl
 RosB0QJfOwyQxgODQs33i4c5n1ZCbJSRGWEvYG364pbHbd5NQZK2JbYPYNhKGihNWvQQ
 rpzs7LyxU30N8WNFLl9PUktBouGyRBhVJARRa2S+HJfteIFevjPxQzlgMrrzyk7T59WX
 ahFwhNaJp8oIkfwtW8vY2CxTycFaZe0mMFqXGAEkl1cq4OPThP/Iy9PIG/qD6T/N5HIo
 KYLg==
X-Gm-Message-State: AOAM530LOyo1O4Q3JdyQ1g6Yfpcnqfiox78NCEq61wbKOcBvF8ddHBAd
 3mqTMq4zmXKXCv/G40CstvRqug==
X-Google-Smtp-Source: ABdhPJxTmfhIfPyjKz/UdLpI661R9AEt1hom4/brpTzb/gdG6WfcxlblSRvTcb3ctkd6UWtkgCV2vg==
X-Received: by 2002:a05:6a00:1508:b029:332:3aab:d842 with SMTP id
 q8-20020a056a001508b02903323aabd842mr3547511pfu.59.1627662245035; 
 Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id i8sm3063415pfk.18.2021.07.30.09.24.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Jul 2021 09:24:04 -0700 (PDT)
Date: Fri, 30 Jul 2021 16:24:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQQnoDq7d4KU4bAV@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
 <YQLwP9T4hevAqa7w@google.com> <YQNRnbuucxcYJT2F@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YQNRnbuucxcYJT2F@google.com>
X-Mailman-Approved-At: Sat, 31 Jul 2021 05:33:51 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Jul 29, 2021, Ricardo Koller wrote:
> On Thu, Jul 29, 2021 at 06:15:27PM +0000, Sean Christopherson wrote:
> > On Thu, Jun 10, 2021, Ricardo Koller wrote:
> > > +	struct ucall uc;
> > > +
> > > +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> > 
> > UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
> > have no idea that it's referring to an unhandled event, e.g. my gut reaction would
> > be that it means the ucall itself was unhandled. Maybe UCALL_UNHANDLED_EVENT?
> 
> I see. I can send a new patch (this was commited as 75275d7fbe) with a
> new name.

Eh, no need to post another patch.  If it can be fixed up in tree, great, if not,
no big deal.

> The only name I can think of that's more descriptive would be
> UCALL_UNHANDLED_EXCEPTION, but that's even longer.

Unfortunately, EXCEPTION is incorrect as x86 will route unexpected IRQs through
this as well.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
