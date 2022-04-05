Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CB7C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Apr 2022 01:53:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3E24B0B6;
	Mon,  4 Apr 2022 21:53:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9qCaMqxYrGFK; Mon,  4 Apr 2022 21:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1C444B133;
	Mon,  4 Apr 2022 21:53:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA144B133
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wvKoQKmXSdkF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 21:53:31 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68BE74B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:53:31 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id u14so6629247pjj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 18:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=s1jP08lvjc+iEpUnhqHS81takUv7ectwk3mZXZaMX7A=;
 b=hKqK2Pm2eE7pi3Ug4MDSplWp6AxG/hOn5Qku1eSKQhG9yDshjLSjZBsk1GryTF+1Ye
 LMX8CJHD2NmLxUjWfI432ZBJm3E8MZAz1B82TFwrvg6H6JZ5SXBqwZyupGGPYmVOm8d7
 orqCrKIGjiH5ewtJlE2rGiQwCxTSLtIXPnF1kNbyl7/gVPSVvPQFAlG6oJHzsi2iXQmr
 iNg/aNvho1x1E9wnQ4GTOxGYdXlWWVbthRX0NHng5F+dYV4m7GFYpWFkeE12KcI+LMy7
 YCITxwMBqEAXS7JbfWHZcHEEyT+/LLTHlCXzri/ju5TTcYmDleiEmRL+QGKc5Kk3NH52
 cHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=s1jP08lvjc+iEpUnhqHS81takUv7ectwk3mZXZaMX7A=;
 b=FCFonAVyOkK4ZaQN1vG31xuQB12RO+jnjq0tuTw4lSggNgI6B9knon8yUZ50ZYSEtv
 I+tXa9tcBGdcyoKJYvap2JIeS3xf80R6762wCleTIDBpT1YVmHpdUyJ2HVsS1Lq/Ihbn
 LPtx2ryIAW12D90kQuZLOuW8avZ8ETILZF05O0+u0xeWjRY0N4fbhdCmnACxcNlGzn0r
 9U/9ecyHHVfRvCmdGV6g9fgK7ybCtaClxvTZ2BWmx7xDeMaPw16CERXbKQQjHGCjY+NK
 L0Ihg7Nx2NWG3HAmIygCzYFrNRkqvdCdkmp6r46ZVIz7DkpTMe9NtdsE8jiNRQdVMbbO
 X6Qg==
X-Gm-Message-State: AOAM530yV9W3a2e+H1g69bw/PyJ+uIM21jrrE7Hw/+t+1NcGpi6ltKnO
 c2ZkZ8trL9oARkFiFUJC3IxO1nV5ACchbUuUDfAFSA==
X-Google-Smtp-Source: ABdhPJy3M4KOifOVTacqoNTW1CPwfWP6Y9YsIhhYUubrpWrjIexOpeAwjfsgkWyb/C+hfOn/XAg/ItUHqA6cerQoWLA=
X-Received: by 2002:a17:902:c1ca:b0:156:a187:b7ee with SMTP id
 c10-20020a170902c1ca00b00156a187b7eemr1035059plc.122.1649123610270; Mon, 04
 Apr 2022 18:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-4-oupton@google.com>
 <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
 <YkqGP/OaKK7LpKF2@google.com>
In-Reply-To: <YkqGP/OaKK7LpKF2@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 4 Apr 2022 18:53:14 -0700
Message-ID: <CAAeT=FzeV=zL68EjeX0hWfQ5LLBBqoxFdqZXP=VRW5jZ15rc7Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit
 guests
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

On Sun, Apr 3, 2022 at 10:46 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Apr 03, 2022 at 09:45:15PM -0700, Reiji Watanabe wrote:
> > On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > To date KVM has not trapped ID register accesses from AArch32, meaning
> > > that guests get an unconstrained view of what hardware supports. This
> > > can be a serious problem because we try to base the guest's feature
> > > registers on values that are safe system-wide. Furthermore, KVM does not
> > > implement the latest ISA in the PMU and Debug architecture, so we
> > > constrain these fields to supported values.
> > >
> > > Since KVM now correctly handles CP15 and CP10 register traps, we no
> > > longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> > > emulate reads with their safe values.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> > BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
> > become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
> > but it affects migration.  I'm not sure how much we should care about
> > migration of the aarch32 guest though (and it will be resolved once ID
> > registers become configurable anyway).
>
> I believe userspace has been accessing the sanitised values of these
> feature registers the entire time, so we should be OK on the UAPI side.

You are right:)
I totally forgot this was just about trapping. Sorry for the noise.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
