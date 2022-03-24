Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A84C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 20:24:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6C594A417;
	Thu, 24 Mar 2022 16:24:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y0EvpxMwYriM; Thu, 24 Mar 2022 16:24:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 833FE4A104;
	Thu, 24 Mar 2022 16:24:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2FF049EE1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 16:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skmfoZ0xBlV4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 16:24:00 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A73F49E44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 16:24:00 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id t5so4837463pfg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+deFKAAvG1IExHzs7Ey5q7jagiNbsrjto223/L+snd0=;
 b=Znk/UqwO6g8KsGi2N1lmUXz1sgxGNyiUkGWZGoYcktt4qVmXNELV/cuiFM8vVcoG6V
 5LYbQfMxUkMyjkNmsBDR7Q1x/zXVNmiSMr9wd7y2fhNICdoqsIxWywmo2gxWT/JF1jQo
 FeLRbi2ORaHUo3DbO/F1JRhrMqb9nARAgsK1S6ATPfDD8U2E85M076204H0Pem8tssav
 R3nJc6Piyi21cn/P7+5/ka4ENAqFGOqReCQIpHHdU3ZoJBrGcTOtkizT/WPMtEUC9K5g
 jmBPepdm1skpcfaekubV4AB06LZrc/NAST30WQ+fMvYIxASJ5F5f+38VPSq35AyrK65J
 oKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+deFKAAvG1IExHzs7Ey5q7jagiNbsrjto223/L+snd0=;
 b=sjAse+NRAKYkf0+AIIxJ7got8BvpOrU8ZQlKPl89caBil1Fegxqrwwdoydstw9tkq8
 c0d6+OMXD+/b40gpqtgG7Dt6wNgM8HmcqCPiUBe14jKVk1Ph6p294X5YUom4RzMEd2WZ
 vALT+j7ITgpfVV4A3C/tAYNIp+2xunAbjnpwzyLo5tiqA3lraFz5A09KFpvYzMm87BT/
 udFeVN3eEihDocPguWkcC4ryOHlVhibbs7MaLeDTCSZk1MsgGbJWm0r42/w7wjpD9he7
 R2gsFPrLbEaWo+TDWJthR1/nT1FjXbmNoAeKpp9fD6nyOnk/5fl71a7SVT0oFXJvLc5G
 t1hA==
X-Gm-Message-State: AOAM5319W8NwnK5BWwr3W8Ow7cX8k0o3V14XKMYkaTAlQ2N0pF5+w3pc
 R1gRG2w5RhTnWaOHL7VrNed6K65M2IvMqRr0Ksx0skGSv5C5288e
X-Google-Smtp-Source: ABdhPJxTwFMhv13gS2/VlfiC3K4DQxqCgghC0iWGormtJ2+ksX6zo9S2rpGpYpjojaRk5suMxroWbFg91R/7jupEX7w=
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id
 w11-20020a6556cb000000b0037882ed0d74mr5346825pgs.491.1648153439287; Thu, 24
 Mar 2022 13:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
In-Reply-To: <Yjt6qvYliEDqzF9j@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 24 Mar 2022 13:23:42 -0700
Message-ID: <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

Hi Oliver,

On Wed, Mar 23, 2022 at 12:53 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > Add hidden or reserved ID registers, and remaining ID registers,
> > which don't require special handling, to id_reg_desc_table.
> > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > or reserved registers. Since now id_reg_desc_init() is called even
> > for hidden/reserved registers, change it to not do anything for them.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> I think there is a very important detail of the series that probably
> should be highlighted. We are only allowing AArch64 feature registers to
> be configurable, right? AArch32 feature registers remain visible with
> their default values passed through to the guest. If you've already
> stated this as a precondition elsewhere then my apologies for the noise.
>
> I don't know if adding support for this to AArch32 registers is
> necessarily the right step forward, either. 32 bit support is working
> just fine and IMO its OK to limit new KVM features to AArch64-only so
> long as it doesn't break 32 bit support. Marc of course is the authority
> on that, though :-)
>
> If for any reason a guest uses a feature present in the AArch32 feature
> register but hidden from the AArch64 register, we could be in a
> particularly difficult position. Especially if we enabled traps based on
> the AArch64 value and UNDEF the guest.
>
> One hack we could do is skip trap configuration if AArch32 is visible at
> either EL1 or EL0, but that may not be the most elegant solution.
> Otherwise, if we are AArch64-only at every EL then the definition of the
> AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> the problem altogether. What are your thoughts?

Thank you so much for your review, Oliver!

For aarch32 guests (when KVM_ARM_VCPU_EL1_32BIT is configured),
yes, the current series is problematic as you mentioned...
I am thinking of disallowing configuring ID registers (keep ID
registers immutable) for the aarch32 guests for now at least.
(will document that)

For aarch64 guests that support EL0 aarch32, it would generally
be a userspace bug if userspace sets inconsistent values in 32bit
and 64bit ID registers. KVM doesn't provide a complete consistency
checking for ID registers, but this could be added later as needed.

It might be a good idea to skip trap configuration to avoid being
affected by the issue.  On the other hand, this might provide a
good opportunity to detect such userspace issue.  As this could
happen only with new userspace code that changes ID registers,
I might rather prefer the latter?

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
