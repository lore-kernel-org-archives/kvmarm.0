Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6ADC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 04:07:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC8CE611EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 04:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC8CE611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8684B13D;
	Fri,  5 Nov 2021 00:07:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TJyTSA95dyJL; Fri,  5 Nov 2021 00:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 108C74B0F5;
	Fri,  5 Nov 2021 00:07:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 581734B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 00:07:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y6tCtisXkhCT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 00:07:42 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 312CA4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 00:07:42 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id p17so7353713pgj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 21:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=llkuSb5L0jD6uE3X1Ynlqc/ho6/ZjfVGOP1jb8IlvtY=;
 b=CgwWzLxvp/Ys6iQTLaSFINNjrWrsZdvERBVFUf3pSsp/7dAeAcEh26sO9s5OX7LKIn
 /tvZ5i96zuyLM5qyJ5VLuq2/eadmyISfLgq4vOTCoWAgXLTMRQifAlFsL0wOys+sI84c
 F7Xi7LQvdqEk8Y4KVvMA0q1XtBCYw4kJLHh7z/Ll7t4JeGUbn9POCmevvBusXDpooJ+B
 k2wKoTf5Hcocrh8CB678iONSG3+zGZhYpXmyQlahA8bwRu96JYhMK8CdopRjBCDYUOdd
 92dr6qBNNDMj2LwqJzYGedCU6jdT87c/LF61IlnuEnPCIIHAECe13I+ozU9X4MzRwszn
 R2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=llkuSb5L0jD6uE3X1Ynlqc/ho6/ZjfVGOP1jb8IlvtY=;
 b=i+vIn9uNvo3QHlC3/WpGnnPikTmnI38DF/N2C2YJCJ08u30Y7VaDrO9OyCj28o8d31
 iQ7MUaIT8G4DjNPKavXBArWx+xslwF66tX5bGaXU/grGtqBBgNYvUJbDoNxfWcNYQxkK
 y9owghi5+q0UWTZSM+kH582AfbDmKs45a/BkOWfeb2Fy3J2mKvVbw53EBWQEK2OdJU1e
 f97i6NzmCVZKCXfy+R/Vrk1F88IKLfPJ7+pytQPLuHiffWuY/Npl987Gp4OPuo9d7Hdh
 qTqPqBoN8BR029qB6jdInuawpWf89nma8ua6vI+FpM0oyfJgQJAv35iR2yNFwbbT9Isw
 HbMA==
X-Gm-Message-State: AOAM532CKi87o3kd5HSwRZ0erb/mEQNE89HQWcZQkR1anHzGmQKk9WGR
 m3m8GzjszdY55RlqDSvCXbHRTmrqItSgtruXZb/Xtw==
X-Google-Smtp-Source: ABdhPJxVWPCzurrkxGOQvESM60+vz35M7q2DOzwppoBNuuLOlob6+tQKsQpwQXnfvWq5G62psSFMc58PWrB/iRPN4HM=
X-Received: by 2002:a65:4889:: with SMTP id n9mr1402858pgs.303.1636085261047; 
 Thu, 04 Nov 2021 21:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-19-reijiw@google.com>
 <YYQNGqpy1NiUEXYD@google.com>
In-Reply-To: <YYQNGqpy1NiUEXYD@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 4 Nov 2021 21:07:25 -0700
Message-ID: <CAAeT=FyowLxUTpLDoAxrETbOyCTCcfc1==hy-Q4F5fdswqS-yg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/28] KVM: arm64: Introduce
 KVM_CAP_ARM_ID_REG_WRITABLE capability
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

On Thu, Nov 4, 2021 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 11:25:10PM -0700, Reiji Watanabe wrote:
> > Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
> > that ID registers are writable by userspace.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 8 ++++++++
> >  arch/arm64/kvm/arm.c           | 1 +
> >  include/uapi/linux/kvm.h       | 1 +
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index a6729c8cf063..f7dfb5127310 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
> >  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
> >  the hypercalls whose corresponding bit is in the argument, and return
> >  ENOSYS for the others.
> > +
> > +8.35 KVM_CAP_ARM_ID_REG_WRITABLE
> > +--------------------------------
>
> ID registers are technically already writable, KVM just rejects any
> value other than what it derives from sanitising the host ID registers.
> I agree that the nuance being added warrants a KVM_CAP, as it informs
> userspace it can deliberately configure ID registers with a more limited
> value than what KVM returns.
>
> KVM_CAP_ARM_ID_REG_CONFIGURABLE maybe? Naming is hard :)

Thank you for the suggestion.  Yes, that sounds better.
I will change the name as you suggested.

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
