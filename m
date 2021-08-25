Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF3FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:02:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E78E561184
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E78E561184
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB344B1CC;
	Wed, 25 Aug 2021 06:02:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T-awLJP1NRAY; Wed, 25 Aug 2021 06:02:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AD44B1DA;
	Wed, 25 Aug 2021 06:02:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 016594B1D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 06:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id stOOuDn3-ES6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 06:02:42 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C45324B1CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 06:02:41 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id i28so42609685ljm.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 03:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=k3coRg+J3p197hAlCFr3Vj1C8Vm9KFllOcMKF9YzS/k=;
 b=cUCTblyL7c27KuwJuwJwQBvBF+zGyPs1LoT5cyb1NhbCWvEsgHwTS6wl/PEiO303Cw
 gJJRULtOxqWElvOp/NXfn3kI0QPgq+csxIwej+GRq71MCI3wyIBEn/NSVB5tGFwkPTnf
 EneqBzFzs7qVMGE6nDOBtyHlV05OrOVkJrrFQRsTt6bN+W3F4qdDcU3CECaFf7f361Bf
 1n3XgDV0zWubWVCGgT9pAkYKSmZbCqQ4no8593xoWzxgPxA10aBBCLfWQHVouS8qAIi3
 Bn4IfggRl6ekReQHAd5BL0gQO2jxUhFREzZdRfO+rqE3AYViw3ewVvcz8UcBzrbHNc58
 Kz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=k3coRg+J3p197hAlCFr3Vj1C8Vm9KFllOcMKF9YzS/k=;
 b=Ih25aW08k6DkLjl1s8rEIeq9qzMurdCDafqlVJ5pQYhk9pXOBlcP7QANfGrjFoV6f5
 PY9/kr0F2V7RqmK9Lj4V+NZrqS9rsU746im7w5Ts6gK1kEnkRx5UgX2Nul3GZSo3bcqL
 fj+mP5y8xYikI/E7tZqUxNpxSy/q2Cl4wKHjLzk7n/ToguSacZcZ7HSU3ljBTn+oA3+u
 6kHpelGMY6xfOjKe0zkNle6VAHqo0VrrlNW+g7FN+qg72EYwYq9XjLdCyaR29sgquNHe
 cg+uSVyucCKahui4s1JiorBpo+evJ2+SGL4Luur8cyyC6VYjfraNlKWg8Qj0lD3r3cbs
 157w==
X-Gm-Message-State: AOAM530DrC7pnvwPdPHXtnuxRiBjb8H0tLc964M0CGAO7EAVy3hGSGNA
 l/j6WUVOcLauZ0kX1CLOYZzrpe0yq8g0hcvC7ABftw==
X-Google-Smtp-Source: ABdhPJwvsAjsRykTCreTtC16fO1xL5nuWVpWNxzP6GpLgqqYLx9mvjmH2w0HkFOJ93i9pThzDyeIsCSDi55qWS19CpY=
X-Received: by 2002:a05:651c:33b:: with SMTP id
 b27mr36824255ljp.314.1629885759909; 
 Wed, 25 Aug 2021 03:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
In-Reply-To: <87mtp5q3gx.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Wed, 25 Aug 2021 03:02:28 -0700
Message-ID: <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pshier@google.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Aug 25, 2021 at 2:27 AM Marc Zyngier <maz@kernel.org> wrote:
> > Exposing new hypercalls to guests in this manner seems very unsafe to
> > me. Suppose an operator is trying to upgrade from kernel N to kernel
> > N+1, which brings in the new 'widget' hypercall. Guests are live
> > migrated onto the N+1 kernel, but the operator finds a defect that
> > warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
> > Any guests that discovered the 'widget' hypercall are likely going to
> > get fussy _very_ quickly on the old kernel.
>
> This goes against what we decided to support for the *only* publicly
> available VMM that cares about save/restore, which is that we only
> move forward and don't rollback.

Ah, I was definitely missing this context. Current behavior makes much
more sense then.

> Hypercalls are the least of your
> worries, and there is a whole range of other architectural features
> that will have also appeared/disappeared (your own CNTPOFF series is a
> glaring example of this).

Isn't that a tad bit different though? I'll admit, I'm just as guilty
with my own series forgetting to add a KVM_CAP (oops), but it is in my
queue to kick out with the fix for nVHE/ptimer. Nonetheless, if a user
takes up a new KVM UAPI, it is up to the user to run on a new kernel.

My concerns are explicitly with the 'under the nose' changes, where
KVM modifies the guest feature set without userspace opting in. Based
on your comment, though, it would appear that other parts of KVM are
affected too. It doesn't have to be rollback safety, either. There may
simply be a hypercall which an operator doesn't want to give its
guests, and it needs a way to tell KVM to hide it.

> > Have I missed something blatantly obvious, or do others see this as an
> > issue as well? I'll reply with an example of adding opt-out for PTP.
> > I'm sure other hypercalls could be handled similarly.
>
> Why do we need this? For future hypercalls, we could have some buy-in
> capabilities. For existing ones, it is too late, and negative features
> are just too horrible.

Oh, agreed on the nastiness. Lazy hack to realize the intended
functional change..

> For KVM-specific hypercalls, we could get the VMM to save/restore the
> bitmap of supported functions. That would be "less horrible". This
> could be implemented using extra "firmware pseudo-registers" such as
> the ones described in Documentation/virt/kvm/arm/psci.rst.

This seems more reasonable, especially since we do this for migrating
the guest's PSCI version.

Alternatively, I had thought about using a VM attribute, given the
fact that it is non-architectural information and we avoid ABI issues
in KVM_GET_REG_LIST without buy-in through a KVM_CAP.

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
