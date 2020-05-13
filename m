Return-Path: <SRS0=/ewP=63=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D6CCA90AF
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 10:30:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0437E206CC
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 10:30:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="feaPsl6P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0437E206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5444B259;
	Wed, 13 May 2020 06:30:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dccb2N0JdeS4; Wed, 13 May 2020 06:30:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 234AC4B243;
	Wed, 13 May 2020 06:30:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC284B241
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 06:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jnl3yuCi+wXp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2020 06:30:48 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06B664B240
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 06:30:48 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id k12so25934668wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 03:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:date:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Bag3tcwUumhERwus8sd0P+tasr8YFyR1BtawoF6Jv0M=;
 b=feaPsl6PXU124jWtX3dAxdhE+71zs/uCFoegBNTyi5X4xrHvVm195995//fXp+PqCv
 bZjFrRwdqqAltQjGj+LEGmdB2M4LFIzNJiyL03Jlt8sIMAUlpNoCrt89NruDMkFjSfZD
 L2ZrhZ5A025g+OZzAClsEJCSgan0edGqEFBtkyb5dwVCwVXw2xbFrsUHhmbT3Cysxmlo
 j9qXbYdZyW+nxcOP0b8yHQl+bSw65rKtZUp8Rv7Zt5qxoYqpnKDfAmAfHTIe7SyQGKmy
 gySn77IU+kPf54X9nFVVLRVpCZrGXIN73Igvj0l6ULfFpCSQUhqDQE9EbgBMF5FyLbdS
 VE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Bag3tcwUumhERwus8sd0P+tasr8YFyR1BtawoF6Jv0M=;
 b=aAbr/jNItmEHKohBnI20Zq1RGu1wthGl8qxE08QDj814nojL1y/1l7q/bb0jWs2HGx
 mlNxn7MKial5cu1MqEtRo6iyd3mguYUyxw5RR/9EMc5mAfx1vcXVgRmf+68EoSBCfG4q
 Ld/1j4orvJC+9I69Ntzs4w1xdtBxoPrQ7jTDOv/5vqSV15yBke5LPx/qghUDYiJ71HTm
 V+lU97zVpHZITi2sAtm7/YjF3tDt42MO1WxdrqSS87d08ZXO7bKw4Q/p4uzVp1C8N3GQ
 nSr3+9d8rwBxSHYZ93Ae8aBtURV1cgmCeODjd9veXYKMQmQYnPYORCsygZx2/PnJPNyb
 g6gA==
X-Gm-Message-State: AOAM533C6NehemkctNgoKfjKmlqNT5TF7eSg8hXHU9R17w0RkZQD9ixL
 D9LhwQpaJmyNAFowLCOAY3EBgw==
X-Google-Smtp-Source: ABdhPJwieEag500N253ZjLYIuWDnNCr/RP0yjgHBqAOAFRcDDDnTfLgV5ev2GxXV9li2Vw8U//ZBMQ==
X-Received: by 2002:a1c:7407:: with SMTP id p7mr5473936wmc.114.1589365846539; 
 Wed, 13 May 2020 03:30:46 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com
 ([2a01:4b00:8523:2d03:e021:170a:2079:28ea])
 by smtp.gmail.com with ESMTPSA id 60sm3774269wrp.92.2020.05.13.03.30.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 May 2020 03:30:43 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil
 <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date: Wed, 13 May 2020 11:30:41 +0100
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 01/15] arm64: kvm: Unify users of HVC instruction
Message-ID: <20200513103041.ktaov2jws72itmag@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-2-dbrazdil@google.com>
 <878si3j13w.wl-maz@kernel.org> <20200507143633.GA169263@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200507143633.GA169263@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Thu, May 07, 2020 at 03:36:33PM +0100, Quentin Perret wrote:
> On Thursday 07 May 2020 at 15:01:07 (+0100), Marc Zyngier wrote:
> > >  /*
> > > - * u64 __kvm_call_hyp(void *hypfn, ...);
> > > + * u64 __kvm_call_hyp(unsigned long arg, ...);
> > >   *
> > >   * This is not really a variadic function in the classic C-way and care must
> > >   * be taken when calling this to ensure parameters are passed in registers
> > >   * only, since the stack will change between the caller and the callee.
> > > - *
> > > - * Call the function with the first argument containing a pointer to the
> > > - * function you wish to call in Hyp mode, and subsequent arguments will be
> > > - * passed as x0, x1, and x2 (a maximum of 3 arguments in addition to the
> > > - * function pointer can be passed).  The function being called must be mapped
> > > - * in Hyp mode (see init_hyp_mode in arch/arm/kvm/arm.c).  Return values are
> > > - * passed in x0.
> > > - *
> > > - * A function pointer with a value less than 0xfff has a special meaning,
> > > - * and is used to implement hyp stubs in the same way as in
> > > - * arch/arm64/kernel/hyp_stub.S.
> > 
> > I don't think any of this becomes obsolete with this patch (apart from
> > the reference to 32bit), and only changes with patch #2. Or am I
> > misunderstanding something?
> 
> Nope, I think you're right. To be fair, this patch has changed quite
> a bit since the first version (which did change that comment a little
> later IIRC), but David has done all the hard work on top so I'll let
> him answer that one.
They have a different meaning in the three different contexts:
	1) hyp-stub HVC: hcall ID + 3 args
	2) hyp-init HVC: 4 args (no hcall ID)
	3) host HVC: function  pointer + 3 args
The patch was meant to have all three use the same HVC routine, eventually
converging on host HVCs also using 'hcall ID + 3 args' in patch 02, but it is
a bit forced at this point. I can drop this patch from the series and we can
clean this up later if it still makes sense.

> 
> And David, feel free to take the authorship for this patch -- I barely
> recognize it (for the better), so it's more than fair if you get the
> credit :)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
