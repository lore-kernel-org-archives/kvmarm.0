Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC032C432C0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 16:22:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E54020748
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 16:22:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SCzLJ+PI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E54020748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88A594AE9A;
	Mon, 25 Nov 2019 11:22:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a-CAj5H2oo1b; Mon, 25 Nov 2019 11:22:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 584C94AC89;
	Mon, 25 Nov 2019 11:22:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA9B4AC89
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 11:22:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VAbnnXRWcU54 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 11:22:06 -0500 (EST)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 632404AC7D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 11:22:06 -0500 (EST)
Received: by mail-oi1-f196.google.com with SMTP id x21so6531477oic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 08:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tybePqhSuTf9QS4Iu+fqHWsuU+Zk3KtWDnwVhCKRykw=;
 b=SCzLJ+PI1XyRTcM0Y1O4K5g8aWka2wte94q/YL2xEngC65vh9OqPIfBuGqeRjqaciR
 el4xA0vhac7RigIsZ5WcEld2epHlUskeOLJoH8BuCiPY41ic3+cGFl8gDOP49ZpWgrLb
 JTpmCQcqLmqcw3/WmTsQMiH8mzvynsYqIqkZ3Gs7Ma8JcQXSq48gDxsSLq+kZccZ3/is
 LpJ1XWTUVmg+OiN8B11pFUFcEC8h75PnpScAiMj92pR4cMgD6wa8CYOg5DPLBnFKNXSd
 3DD1o0Zl0cmyxjKesC3fiB/wy6NvAQuUlW2NtWnNVbr11IF3eL7axvSvzkpQipcE1H3Q
 yBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tybePqhSuTf9QS4Iu+fqHWsuU+Zk3KtWDnwVhCKRykw=;
 b=Jmfs9EwXFt0Jy75IkvXjmpa33RVmLIIULY7W9l3FuhmTjVP240WrB4Yi706U14u1X0
 8AfDwj7/bKmGSf8FtsuIwZWYRo0GapFR/JZ91oj3RCnqFjeSRTXqHyKiJ5A2CCqYLNSb
 WirTP7cKUrwL0eQ+onP1yQSwxRrhBcSnAYYfGOIX91TnRpkzhML7YHGCGNWB+qzCOuSe
 YwC2nHedXlsmqXmIsRoiU9EHJbwb4Taw/hkTvp0PuZNJciLN7NUzriPkj6RdvQHMlW6u
 khNyupfwKLCZZOQALAVdBkAlmcpZDoGOGtgK4mEtYuIP3f+KbxszvRU5Kc+2OE0g+x6D
 eCiQ==
X-Gm-Message-State: APjAAAVp9ATocaFAKa8TQeGk+eWbkyp/zRGIJZlkxFE8iIwdA4u3uE8k
 9hmdlzI4Q8slxY0PpmjX6XQQW1tsDHxoyo2BLpQ1nQ==
X-Google-Smtp-Source: APXvYqwEzoGQrHDks+ODGmcAGu4Dy2Ca1feu5KO4QLEtfauG8WwYgG4d+tOoa0j8MnwkclMKKDfI3lXChnXTGL7RW3w=
X-Received: by 2002:aca:a9d4:: with SMTP id
 s203mr22607366oie.146.1574698925675; 
 Mon, 25 Nov 2019 08:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20191123115618.29230-1-maz@kernel.org>
In-Reply-To: <20191123115618.29230-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 25 Nov 2019 16:21:54 +0000
Message-ID: <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
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

On Sat, 23 Nov 2019 at 11:56, Marc Zyngier <maz@kernel.org> wrote:
>
> HCR_EL2.TID3 mandates that access from EL1 to a long list of id
> registers traps to EL2, and QEMU has so far ignored this requirement.
>
> This breaks (among other things) KVM guests that have PtrAuth enabled,
> while the hypervisor doesn't want to expose the feature to its guest.
> To achieve this, KVM traps the ID registers (ID_AA64ISAR1_EL1 in this
> case), and masks out the unsupported feature.
>
> QEMU not honoring the trap request means that the guest observes
> that the feature is present in the HW, starts using it, and dies
> a horrible death when KVM injects an UNDEF, because the feature
> *really* isn't supported.
>
> Do the right thing by trapping to EL2 if HCR_EL2.TID3 is set.
>
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> There is a number of other trap bits missing (TID[0-2], for example),
> but this at least gets a mainline Linux going with cpu=max.

I guess this ought to go into 4.2, given that it gets recent
Linux guest kernels to work.


> @@ -6185,11 +6221,13 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>              { .name = "ID_AA64PFR0_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 0,
>                .access = PL1_R, .type = ARM_CP_NO_RAW,
> +              .accessfn = access_aa64idreg,
>                .readfn = id_aa64pfr0_read,
>                .writefn = arm_cp_write_ignore },
>              { .name = "ID_AA64PFR1_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 1,
>                .access = PL1_R, .type = ARM_CP_CONST,
> +              .accessfn = access_aa64idreg,
>                .resetvalue = cpu->isar.id_aa64pfr1},
>              { .name = "ID_AA64PFR2_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 2,
> @@ -6198,151 +6236,188 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>              { .name = "ID_AA64PFR3_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 3,
>                .access = PL1_R, .type = ARM_CP_CONST,
> +              .accessfn = access_aa64idreg,
>                .resetvalue = 0 },

Missing .accessfn for ID_AA4PFR2_EL1_RESERVED ?

>              { .name = "ID_AA64ZFR0_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 4,
>                .access = PL1_R, .type = ARM_CP_CONST,
> +              .accessfn = access_aa64idreg,
>                /* At present, only SVEver == 0 is defined anyway.  */
>                .resetvalue = 0 },

>              { .name = "MVFR0_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 0,
>                .access = PL1_R, .type = ARM_CP_CONST,
> +              .accessfn = access_aa64idreg,
>                .resetvalue = cpu->isar.mvfr0 },

These are the AArch64 accessors for the aarch32 MVFR registers,
but this trap bit is also supposed to trap aarch32 accesses to
the MVFR registers, which are via the vmrs insn. That needs
to be done in trans_VMSR_VMRS(); we can do that with a
followup patch, since the mechanism there is completely different.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
