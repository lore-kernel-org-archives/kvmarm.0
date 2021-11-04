Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3371C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 03:37:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34A1461186
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 03:37:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 34A1461186
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 959E24B130;
	Wed,  3 Nov 2021 23:37:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WCEDbyAXzyYl; Wed,  3 Nov 2021 23:37:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E3C4B0ED;
	Wed,  3 Nov 2021 23:37:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A824B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 23:37:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0gUeflFrhbCm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 23:37:49 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C295A4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 23:37:49 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id y1so4988789plk.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 20:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ElaBqdcFpl/MNZIl5634QwYYBAAW38SiF7mXocckqIU=;
 b=loBq9pJZVC8qjqv61AUlvq3vp6kX2bgSRAVnYX6biD4FKiUdIUNHSNwPsu/Nqf3Ni6
 4kllfRYw5mAo8Lmc2QhEhIa3bwW9ETiCgoa4D0qC8ZEQ8hBmDzu/ln1jDC+Eknb26Mh+
 ox1LUYmq7CWAtIunf8CszA2Vck8IBch3Ho8Awci8S64R9Yrcxxu6Vt4jpi3aKWV+C+4n
 g/9BNdJ8iRC/8P8zsYo5PVU9Ht4k6gFXIoFWae3983AtGwmKgHh9A6w03Zql+h36HbAA
 vMr8XTW+kX9c2ixS3qd760Od/JzSq9uQreXPwMGICwrse9CDBXToCFn2M0A2QvN2xk0L
 3ZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ElaBqdcFpl/MNZIl5634QwYYBAAW38SiF7mXocckqIU=;
 b=M9VZJz3FuXsZ53hZZ7QoZLoRf/NtX/horm+Li8L0kDn+m9gzRfQCVcWTz+IIn5ODfE
 3Xv7+9c45z4uKuTdz17CCug1y6VyHeeiE4yIuUyI8n+DWOuvroyIFDmcXobmrNrgr+EM
 WNM0FymFYdcxppWyvR09iNYgeV4Ebev1V/+iF6WLAV+OFQ/r6ZzVMtJUnmCCkWFPnzyj
 LAXfNOCrjTgjfjs5dXupaXeSbRypNlpzM8Bt8a0DUn9BSr6/aHemILClmKKyAYAmN7ht
 5cHUNbEtZ9MERdUXLtFC1dhLiDDA41XUr7m9BQ8V50MSkBmvzgn/4ygY+71q0zu3oYvx
 2PPQ==
X-Gm-Message-State: AOAM533e6kifhbM9qT4wt9VRFdMov4SK6OhIEU6ZZ8U5R7zKm4npbOgC
 9L/ILPqLp6l//wjwGTtICAWa8wFThqGNFfReOfyuEw==
X-Google-Smtp-Source: ABdhPJwNPFTCwA+7Dtt3rn91WionPFUP8QV9J1NB4jxb17C5XHsVckC/3AjrySdj5c7OH4UlyAFSgh5A1l8vckD8hls=
X-Received: by 2002:a17:90a:e506:: with SMTP id
 t6mr17420531pjy.9.1635997068721; 
 Wed, 03 Nov 2021 20:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-3-oupton@google.com>
 <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
In-Reply-To: <CAOQ_QsgqLVVwzOhC5QeRm4qvWA-OXPB+bA=JJk4ffAavO5KMqQ@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 3 Nov 2021 20:37:32 -0700
Message-ID: <CAAeT=Fy_nVirAnwM_-vvxx6OTo0tRy=cWGx7k_nnQfasg2OrSw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Nov 2, 2021 at 2:51 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> >
> > An upcoming change to KVM will context switch the OS Lock status between
> > guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
> > using the stored value.
> >
> > Wire up a custom handler for writes from userspace and prevent any of
> > the invariant bits from changing.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
> >  2 files changed, 25 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..c98f65c4a1f7 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -172,6 +172,7 @@ enum vcpu_sysreg {
> >         MDSCR_EL1,      /* Monitor Debug System Control Register */
> >         MDCCINT_EL1,    /* Monitor Debug Comms Channel Interrupt Enable Reg */
> >         DISR_EL1,       /* Deferred Interrupt Status Register */
> > +       OSLSR_EL1,      /* OS Lock Status Register */
>
> Sorry Marc, forgot to move this up per your suggestion on the last
> series. Only caught it once the patch went out the door.

Except for the above,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
