Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A69EECAAA2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 00:53:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B28244E390;
	Thu, 25 Aug 2022 20:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3tIeGvrkdNNX; Thu, 25 Aug 2022 20:53:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7004E373;
	Thu, 25 Aug 2022 20:53:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4AD4E373
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:53:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8u5CKjTOtVpc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 20:53:35 -0400 (EDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com
 [209.85.217.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62FF14E372
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:53:35 -0400 (EDT)
Received: by mail-vs1-f48.google.com with SMTP id m66so269158vsm.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 17:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=Fhu/EVEBLSu/3KSf5ItZEuzOt/5JilGlFLRwNgSUIxY=;
 b=c76630Lu8LzWdOPChT9C2E5frjk/NZyKMsyV5oYEe6DyQfF0dLBayYZoxmxhWX1o/p
 1JobhHmvWBCPWxC1xdMXfHW3l3dS8eqQeRoNr+n8Hr6Gg9sTDBETjySGa0m5aE5knoTv
 Y2wvV12VngbxEHC4JDXqrs0TRMwckEFpuj9MtioXPWtgxLE/X7NAkI/uqLnr9jfAR9yS
 BS5ipIkcCMf0N4QjPabJMlDvRSxkzdbU0YpEO3LKWB02KaBpvKKkousZ4XvQFDWegoGE
 KVe4Sb01aZTpJoO+Iy8m5/xBroaJFZkbBQQfWizG+tZ76SaPkoxBmtCSJlaZrX1ury9t
 Zlag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=Fhu/EVEBLSu/3KSf5ItZEuzOt/5JilGlFLRwNgSUIxY=;
 b=mX3rLPknbLeFVHksZ5TMqroku7hmhL7JYWhsuSxeC8MtZY8zSEROR8qyuO0NaXmnb/
 q9RYGecMa+Bqqn3tC3k5Nt4V7noaCNzm8y0SIooDB7t3XnzRVbyOMRBcJfVag1ksRJlO
 D/4fce1dVeSgl7OmbAy0vBQd45O4ovaKmTsNc3MebkL3MAFuuyxuFhz6cIBTeTUr1zxp
 2CcrZ/91YAH52S9/A9MkhG/vtv4ESYazD4brX0XjkKHO/paBORSI12ngDrFNgh3kkWBe
 eyCf7uPQarNfwSAZvhJjb4qfboR68vElAnM91zINvXRl2Tr1uuxIv5BylDCfcPu1q0Tg
 n08w==
X-Gm-Message-State: ACgBeo3Ks+qeBqayE3c58RHUqPInkb87lqBSvcUar7MSxjE0ovub9iUY
 a+WdOMxKKzpyCTS7DSC1JMZ7dRs1f29iOq8WEfRI8w==
X-Google-Smtp-Source: AA6agR5dA3FEzav0fnfqK8HpXi7Nmc3Rw5gadbvBD/pSPCDDrQA3YlufC6mUMuZkEvdFfwE59ZqW1e/QZg0k48DNEFU=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr2426094vso.51.1661475214815; Thu, 25
 Aug 2022 17:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-4-reijiw@google.com>
 <Ywepg6c4FT7DvJ83@google.com>
In-Reply-To: <Ywepg6c4FT7DvJ83@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 17:53:19 -0700
Message-ID: <CAAeT=Fw_c52n8aAUHQLDmhL8sB3iZPwS59ji4wxBKFeLSRwtaw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

On Thu, Aug 25, 2022 at 9:55 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> > Remove the hard-coded {break,watch}point #0 from the guest_code()
> > in debug-exceptions to allow {break,watch}point number to be
> > specified.  Subsequent patches will add test cases for non-zero
> > {break,watch}points.
>
> Also worth mentioning that you're opportunistically zeroing the debug
> registers as their values are UNKNOWN out of reset.

Yes, I will add that description in v2.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
