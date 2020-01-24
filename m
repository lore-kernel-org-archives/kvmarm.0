Return-Path: <SRS0=41R7=3N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7551C2D0DB
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 15:39:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 329C92072C
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 15:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RaKX4m8i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 329C92072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7902D4AF27;
	Fri, 24 Jan 2020 10:39:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncMAAJO1-Nhn; Fri, 24 Jan 2020 10:39:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F7B4AF16;
	Fri, 24 Jan 2020 10:39:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CACD4AF09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 10:39:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AYGs8wsN3oG4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jan 2020 10:39:41 -0500 (EST)
Received: from mail-il1-f195.google.com (mail-il1-f195.google.com
 [209.85.166.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33C114AEBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 10:39:41 -0500 (EST)
Received: by mail-il1-f195.google.com with SMTP id u14so1978672ilj.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 07:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QM/EtkwyClr/K/8UX2OIGcGSafCE4GTMwKR9OdqwWPI=;
 b=RaKX4m8iUPforfBmvz0ix1bxNr6D5/mBX8Gg0wTQeHNbHqSz6lTbB/PhA9V6kLV1ur
 zZJy5THuxHIRtxdmOOOT2Urr/QxVxq/C6Is7bV+Bx1JD08xjrHcCt0NzAyYLLhIVovv+
 rnQxyi6OJxZ5aJ/zyFhMNxj8eLXc5jMig9XM47pKioyWu5jzORE+JgD/LqydieXcCag8
 +CtlQsGeTiGsWXTSgg4pVQGSnBbqwhXkjtRW87hoOP34XmmqnvOP2/m/oZbC8oF2W9YI
 ibL7GRdV/K0QRd+2mx6Us9VNIETuhTVOlu4YiZ4c+vk4oFfbb5NaOla6+dDjTl1v4FI2
 2awA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QM/EtkwyClr/K/8UX2OIGcGSafCE4GTMwKR9OdqwWPI=;
 b=U46XOnqMGMe3Uf8aP5KXx0wBJJq7FXEkArLhPNiZrIIWs4Rx6ln1+QS2v1V66FBtaG
 JkRvd5A1+DRP2x8x7AuotjMFcz7KoFcpqBCMON9eC5CnsdTlTfsqiS0lmOpg5tGKisSs
 GV0dU1EvrrGTZZ6Ok35daLxnq+PtqSWr4Ow3/Mm84tbER8tuJ9CKUcbe3bMfP0smaf7u
 8iEhuTdsUn/yB93c4dO3VigekBa5b1Y2fqwg7W8i9x71Nr/yTw4vXxDLKnVUt0GiZptV
 xDTKONvKGgV1QVw5FyjcN0OqgQxTfqNXt8KGB6m0+Ptmvy4L/5z3wncwD+bDG6odoRPa
 wFUA==
X-Gm-Message-State: APjAAAX4rkdvDujeFmJ0Emof0d4a7Jr/DvWgn6GVBB2X9iLPZgzxTA2x
 qP+OixvXr5HZ2oDBFNP+LgZBLvh3VoAbcOjkM5uNuw==
X-Google-Smtp-Source: APXvYqzk39H6WK0GRTQGylIpatJ9EFAaNs9QKAf04kQ9GbnPaP9vyQ+237FsLkSZMxyGEf2CfaCa7mpPPm2E9kduWPo=
X-Received: by 2002:a05:6e02:685:: with SMTP id
 o5mr3531895ils.248.1579880380510; 
 Fri, 24 Jan 2020 07:39:40 -0800 (PST)
MIME-Version: 1.0
References: <20200121123356.203000-1-james.morse@arm.com>
In-Reply-To: <20200121123356.203000-1-james.morse@arm.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Fri, 24 Jan 2020 15:39:29 +0000
Message-ID: <CADSWDzubQHvG8_c6a7E=basbtXxW-7u_ZVRz6+M7zGOAYYxz7A@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm: fix KVM_CAP_ARM_INJECT_EXT_DABT for aarch32
 guests
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi James,

Thanks for the fixes - they work like a charm.

On Tue, 21 Jan 2020 at 12:34, James Morse <james.morse@arm.com> wrote:
>
> Beata reports that KVM_CAP_ARM_INJECT_EXT_DABT doesn't do the expected
> thing for aarch32 guests. We get the wrong register layout, and weren't
> even trying to set a 'external abort' in the first place!
>
> Both patches are intended as fixes, but patch 2 is somewhat in the eye
> of the beholder. I don't know why an imp-def exception was picked...
>
On a side note - currently KVM exposes capability that is not fully supported
(till the fix gets applied) and there is no easy way for the user space to
determine whether the injection will work as expected and whether it is safe to
use it or not. Although this is addressing a problem that is not that common
(I suppose) but still it might be worth to add a way for the kernel to inform
the user-space that it is all good to go? There has been a 'similar' case in the
past with KVM_SET_USER_MEMORY_REGION, where fixes where needed
and those were announced through new caps. Now, I'm not sure if adding new
capability would be the best approach here though it seems that there is not
much of a choice?

Best Regards
Beata

> Thanks,
>
> James Morse (2):
>   KVM: arm: fix DFSR setting for non-LPAE aarch32 guests
>   KVM: arm: Make inject_abt32() inject an external abort instead
>
>  virt/kvm/arm/aarch32.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> --
> 2.24.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
