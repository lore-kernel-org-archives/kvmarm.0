Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C94FC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 12:21:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B293C60FC0
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 12:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B293C60FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FC44B1D5;
	Mon, 13 Sep 2021 08:21:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id REHsygBMVJ4o; Mon, 13 Sep 2021 08:21:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0178A4B173;
	Mon, 13 Sep 2021 08:21:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7800B4B108
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 08:21:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBtfBN7OXaD4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 08:21:26 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29E004B0ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 08:21:26 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id i28so16930090ljm.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 05:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mkr8GOjoBt/sh+RCX4NVAn9v5w6wwN8N4sC5/LVecLA=;
 b=kR/uxi3CryVYq6q7Z20ITMsyt2ZmDDhJy7TgEY1iE0l+AtHmw88xgWRoWRsPPUv4Rw
 PnKdZmU6XqepvjmrbZfm2nGuJOyttz9JmGPLsg3ugLO+SddJndUxq8zUWLdrn3Dnmwg5
 dzu0/nmeGhi0RlG/Ri1O2Ibls+3dgHDmuUE5DtTN9TeT10viZ50AnSbztISK7U2CWBXN
 gUA4Pwx56w9AXs2w8rM3lXBOxqIXlc5BBIF9mrLYJozSuDWaeVB9PT4DU0VsXHd0k1/7
 IKqhOTVdqJpl97QlZwEuTNFJk7OGl0qM8l0T10lOeNY+wleTCZeJMy/OWIFiEol7uRHZ
 2BmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mkr8GOjoBt/sh+RCX4NVAn9v5w6wwN8N4sC5/LVecLA=;
 b=SFHe1jWn1inSdbs6+gjBqKc7VhtuajDJZGAelxCP15xUdNiUnMos6IQjzvkDpb6RaD
 6AzfcQo2rtssDla9aGi5SgcUfIeU7wWZeyEf1fKnAcmA8AB44+S0oR3h2RuXMoQFim+4
 PkSM3yCOUOzTDSc8DHFjXRayQmXLAojb5qVuCcuKByFPCKDwRy+2nF2zyCkVq8Aj0yKf
 r6WMe+6NSWJLWgxTHdCYSH+dkwon2VD4GjbrKtKtvaXb4q/ADd3h0/nGuqJo0ShVA49/
 zdwcHbq3G9c34WIgNYhMuWhVksKb+ayqAgQbdUGLSuTF0Ddf3PgnN8B6zKTJTWlgzggk
 7nHQ==
X-Gm-Message-State: AOAM533/lNthUrroL/Pa62Km4VShuM1kHXSEZ7No9RMAGci1JMTWT4U6
 zAx6KMgAqvIE9wjLc7+Hr8KKoWXG75vUNa0yu9QtAQ==
X-Google-Smtp-Source: ABdhPJxpRNZpvn+RgdwcF7pGsUajFGcjpWr1uruf5bZ9zplVRACTkUcrAX5PCEYsDxpjuH5xU3b2oY0Kk/miHbjUmz0=
X-Received: by 2002:a2e:154e:: with SMTP id 14mr10342555ljv.374.1631535684043; 
 Mon, 13 Sep 2021 05:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210907123112.10232-1-justin.he@arm.com>
 <20210907123112.10232-3-justin.he@arm.com>
 <CAOQ_QsjOmHw+545J0T9i-nWV2bVGGEwHq5SPVvBOM-SHMXpP5g@mail.gmail.com>
 <AM6PR08MB4376DB4B908AC37DF24290CFF7D59@AM6PR08MB4376.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB4376DB4B908AC37DF24290CFF7D59@AM6PR08MB4376.eurprd08.prod.outlook.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 13 Sep 2021 08:21:12 -0400
Message-ID: <CAOQ_QshF+N7Q=-cXAoMSW4Gcy7mr_oFVpye7fEBqPeR8+3mK0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM allocations
To: Justin He <justin.he@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Xiaoming Ni <nixiaoming@huawei.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Justin,

On Thu, Sep 9, 2021 at 8:57 AM Justin He <Justin.He@arm.com> wrote:
>
> Hi Oliver, thanks for the review, please my comments below:
>
> > -----Original Message-----
> > From: Oliver Upton <oupton@google.com>
> > Sent: Wednesday, September 8, 2021 6:29 AM
> > To: Justin He <Justin.He@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>; James Morse <James.Morse@arm.com>;
> > Alexandru Elisei <Alexandru.Elisei@arm.com>; Suzuki Poulose
> > <Suzuki.Poulose@arm.com>; Xiaoming Ni <nixiaoming@huawei.com>; Lorenzo
> > Pieralisi <Lorenzo.Pieralisi@arm.com>; Kees Cook <keescook@chromium.org>;
> > Catalin Marinas <Catalin.Marinas@arm.com>; Nick Desaulniers
> > <ndesaulniers@google.com>; linux-kernel@vger.kernel.org; Liu Shixin
> > <liushixin2@huawei.com>; Sami Tolvanen <samitolvanen@google.com>; Will
> > Deacon <will@kernel.org>; kvmarm@lists.cs.columbia.edu; linux-arm-
> > kernel@lists.infradead.org
> > Subject: Re: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM
> > allocations
> >
> > Hi Jia,
> >
> > On Tue, Sep 7, 2021 at 7:33 AM Jia He <justin.he@arm.com> wrote:
> > >
> > > Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
> > > allocations"), it would be better to make arm64 KVM consistent with
> > > common kvm codes.
> > >
> > > The memory allocations of VM scope should be charged into VM process
> > > cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.
> > >
> > > There remain a few cases since these allocations are global, not in VM
> > > scope.
> >
> > I believe there are more memory allocations that could be switched to
> > GFP_KERNEL_ACCOUNT. For non-pKVM kernels, we probably should charge
> > all stage-2 paging structure allocations to the VM process. Your patch
> > appears to only change the allocation of the kvm_pgtable structure,
> > but not descendent paging structures.
> >
> Do you mean kvm_hyp_zalloc_page() here?
> Seems kvm_hyp_zalloc_page() is in both global and VM scopes.

Doh! kvm_hyp_zalloc_page() is only for the hyp's page tables, hence I
believe your patch is correct as it stands. As such:

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
