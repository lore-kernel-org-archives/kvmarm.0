Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BF3C636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 17:47:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE92F6128E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 17:47:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE92F6128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 291F44B117;
	Wed, 21 Jul 2021 13:47:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iu8o4s7zEGqH; Wed, 21 Jul 2021 13:46:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDF74B10D;
	Wed, 21 Jul 2021 13:46:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6014B109
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 13:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPR63Lq2wTOi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 13:46:56 -0400 (EDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EB2E4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 13:46:56 -0400 (EDT)
Received: by mail-ej1-f42.google.com with SMTP id hc15so4489633ejc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AxTvururg15eAgQqT/Vw3IaCmq/AtpICOLNE7tzoQWM=;
 b=s0WASEAsAruBpiL/ESXJp2VeA5h+VTH0uEnk+LjAD3MHgy72GUAmI0zBPcvrD8s0SA
 BWd9ei0B8Hv1rK7VYNbIu6CBlaBhnbfO64qTWXLIdQniLZyup1q2j9Bl5Ub6BeGijcX8
 o2GowuJAhyePRBqL1PylmSGGCsNgtoGiloJFlPnxkrNT2U81r5Mxayn2fG2GDKvW/6Wr
 JHGyMNfwDGxoCXuUwC54Cph9OIE9di/Zn5VNuNjuxY1xSE8IY6oZOFZOwV1+s5UgN5EL
 WdegzQ2TXCJbEAUWTyI+Nys4iqZoAnBRb0CZnuj1SZTVekfvqquMS7B2ygo0sDqp4kYi
 SlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AxTvururg15eAgQqT/Vw3IaCmq/AtpICOLNE7tzoQWM=;
 b=gUM47mSvqYBRcyIYbWVAMfZWMCyoo9Uzoy9+hW1RBp8k+vlpcsvbtpQqNMPFMnwlCW
 aYV6zx5teJ4WkcvCbfd9wa40zOhk7eJC5D1ZyAkC8JC1LEOzhFYB2ax6nBvBkYZ8spe3
 QwxmAslld3Cw9aNeMW2zPPRaeWtIviyfsBRKHxwfdXppepJX8Af3tno04dXUWT9saeGf
 U5+KQ5t+gw3OgdulSagElDbJbeYjelNmDhUjdHwfL35RigZrcpmP6Yn8YUAD4GMpN/AZ
 WlU5YWqC2ZKnx3OZ+cZoDG8C/cbLHzTM5/f4X6Y0j2MzdaHuzn93t48Uw+fl9eiygBEn
 ibMw==
X-Gm-Message-State: AOAM533PW8H0z+lb4xpZQ5ylBqVRKYhXVoNq7mMjcUroBecJ21yBm55L
 bBDJlVcpEly/FNEBTkYEnP9Z/g==
X-Google-Smtp-Source: ABdhPJy4TQnKuFecqxFoIlEfztLPuXcjzFwaiFkqmvuxoQO+VS6qVLl59Uri6H53MV/Z29iViIl6mw==
X-Received: by 2002:a17:907:170c:: with SMTP id
 le12mr41029420ejc.288.1626889615495; 
 Wed, 21 Jul 2021 10:46:55 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id qo6sm8570087ejb.122.2021.07.21.10.46.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 10:46:55 -0700 (PDT)
Date: Wed, 21 Jul 2021 19:46:34 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Message-ID: <YPhdehJ2m/EEGkdT@myrica>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
 <YPW+Hv3r586zKxpY@myrica>
 <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
Cc: salil.mehta@huawei.com, lorenzo.pieralisi@arm.com, catalin.marinas@arm.com,
 kvm@vger.kernel.org, corbet@lwn.net, maz@kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, jonathan.cameron@huawei.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 19, 2021 at 12:37:52PM -0700, Oliver Upton wrote:
> On Mon, Jul 19, 2021 at 11:02 AM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> > We forward the whole PSCI function range, so it's either KVM or userspace.
> > If KVM manages PSCI and the guest calls an unimplemented function, that
> > returns directly to the guest without going to userspace.
> >
> > The concern is valid for any other range, though. If userspace enables the
> > HVC cap it receives function calls that at some point KVM might need to
> > handle itself. So we need some negotiation between user and KVM about the
> > specific HVC ranges that userspace can and will handle.
> 
> Are we going to use KVM_CAPs for every interesting HVC range that
> userspace may want to trap? I wonder if a more generic interface for
> hypercall filtering would have merit to handle the aforementioned
> cases, and whatever else a VMM will want to intercept down the line.
> 
> For example, x86 has the concept of 'MSR filtering', wherein userspace
> can specify a set of registers that it wants to intercept. Doing
> something similar for HVCs would avoid the need for a kernel change
> each time a VMM wishes to intercept a new hypercall.

Yes we could introduce a VM device group for this:
* User reads attribute KVM_ARM_VM_HVC_NR_SLOTS, which defines the number
  of available HVC ranges.
* User writes attribute KVM_ARM_VM_HVC_SET_RANGE with one range
  struct kvm_arm_hvc_range {
          __u32 slot;
  #define KVM_ARM_HVC_USER (1 << 0) /* Enable range. 0 disables it */
          __u16 flags;
	  __u16 imm;
          __u32 fn_start;
          __u32 fn_end;
  };
* KVM forwards any HVC within this range to userspace.
* If one of the ranges is PSCI functions, disable KVM PSCI.

Since it's more work for KVM to keep track of ranges, I didn't include it
in the RFC, and I'm going to leave it to the next person dealing with this
stuff :)

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
