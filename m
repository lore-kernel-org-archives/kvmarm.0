Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BACC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 06:24:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD03F49F1F;
	Fri, 14 Jan 2022 01:24:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iPuGGr91TROB; Fri, 14 Jan 2022 01:24:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C51249EF6;
	Fri, 14 Jan 2022 01:24:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5557349ECA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 01:24:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id milDCG1VdPvD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jan 2022 01:24:06 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54A9749E32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 01:24:06 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id u15so12528999ple.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 22:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=efD7MXnSTwwB5xVjXzKnpMf87tT71yAx/cljfnEhNas=;
 b=VGerjJAK8GzUatgIVU0a+8oCQmLsZwZaA+xK/n8dg9nnhsCwi/cLvyukvffHwbq4lD
 KUfhzEQDfHJ3FYQFDjf3LmONir9tuCFjuR8y8YaMKZaXGG7AkFWUIkVcXQmn/4eRmCng
 jm6TqwihJHpnT5w4Rtz9yeYnmgsj/596lDOnlOI5WxnBOLAY+Dn/CUdUt//Oqn89O9xX
 5K5aNFzbE9ndV89wLtwYSCJIyuPEKzB5JZcATTObSRZ0LF2ryCXr9GwRsphLbHwK1Dz5
 mFl0gV7bAhaYxQp4RtohXeS+M/y0JGauajd/X3ewewRMHVIMEvFdPOX5lWBO5GSl2h6k
 3+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=efD7MXnSTwwB5xVjXzKnpMf87tT71yAx/cljfnEhNas=;
 b=vxKsPemsOy42zr2JrKraBqZNA3QJlaUN2x9IfWuKNMV3si+GyeKQYhNtdKW8u1wWQB
 17Rn0i+PI9QLAFZNH+p6hIyV5OopDgp8IG7/w2++ybdQY4xKUIgoq3u3sUbMGnQEEC4z
 c2APrY3tsNhC5X/sQ5pJfqvpCRaI0XQP354HU/RA0XX2wIjiUSKfDXQ2kLpgnrj+Nidc
 zbAgEuBSzJt2Gx9ZNi5L1e5mnRM9lUixwt1axJhRx+ZeJsjb1IS1a2lwhMbtf47tslHY
 C6o7NnUqmLH34f8qjz1tZn5yi72WxmMHqkZjxgQ9Z5RY9oXUZgQCLLAUEKfzOaxcsKxs
 8wWQ==
X-Gm-Message-State: AOAM531sE0KtcOAs9oh2ldGAvM1OM34C1sg4Ow20Km8hHRHh0EvE6lVC
 vMQAGTMCYKaVzDjYOqT5tv0ugfpOkXi+4rnbgnCUtaTmiIqw3A==
X-Google-Smtp-Source: ABdhPJyOGEzTN5ie9agHxl4cS61ylB6xO8eTkZnYeEg8FGn5HzoowBJbQV+Ws9vld5pFq3VE38zPZoChvTtPXqEREvE=
X-Received: by 2002:a17:90b:4a09:: with SMTP id
 kk9mr18400389pjb.230.1642141445152; 
 Thu, 13 Jan 2022 22:24:05 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-5-rananta@google.com>
 <CAAeT=FztkibSajKjnpRfObx+D1r8H1s_8-5MmqjemJTfmb2mpg@mail.gmail.com>
 <CAJHc60ywYgAPfG11Ljkj3qzLoUn9mZPKnPH0P-HYS-pfs+A__g@mail.gmail.com>
 <CAAeT=FwA9X9eXrF+Q31Wzah=UkM-B8bMJObjJ=oCV0rjLfX6=g@mail.gmail.com>
 <CAJHc60y6b-scY8zcPuLnjGtr6HzSBnmhi2mCnmkNm4nTxgMTUQ@mail.gmail.com>
In-Reply-To: <CAJHc60y6b-scY8zcPuLnjGtr6HzSBnmhi2mCnmkNm4nTxgMTUQ@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 13 Jan 2022 22:23:49 -0800
Message-ID: <CAAeT=FyER7GWZqSHyRA4-YRwef_KmGEw+tUoxBc7GXC4-6hFhw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

> > > > > +static void
> > > > > +kvm_arm_get_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 fw_reg_bmap, u64 *val)
> > > > > +{
> > > > > +       struct kvm *kvm = vcpu->kvm;
> > > > > +
> > > > > +       mutex_lock(&kvm->lock);
> > > > > +       *val = fw_reg_bmap;
> > > > > +       mutex_unlock(&kvm->lock);
> > > >

I have another comment for kvm_arm_get_fw_reg_bmap.

I just noticed that @fw_reg_bmap is a value of the bitmap register
(not a pointer).  I believe what you meant was a pointer to
hvc_desc->hvc_*_bmap.  Also, you can remove @val and return the register
value instead (change the type of the return value from void to u64).
I'm not sure if you will keep this function in the next version though.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
