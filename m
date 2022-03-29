Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF87AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 13:36:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 628374A0FE;
	Tue, 29 Mar 2022 09:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uM3nb11mc5ro; Tue, 29 Mar 2022 09:36:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55B5C49F1B;
	Tue, 29 Mar 2022 09:36:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAAA49F01
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 09:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HN0M6ZgSum9O for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 09:36:53 -0400 (EDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
 [209.85.167.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37CC49EF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 09:36:53 -0400 (EDT)
Received: by mail-lf1-f42.google.com with SMTP id k21so30330991lfe.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sK7Bv0enNZHiUYvwnBleR2mEnCHV5OhHNBDPWeFOSoM=;
 b=hxmg270hpKoeWoqbPGY934y8sfl8R5GGyGznt4sQ9VewcKVEhpT2avtqbqnKKr5r2n
 yxgOPxPJWxAAjgTF/ws7wpdAy47HPS3TPeDkXaK8xVHByKO90ZUK6fo9q68b5Fn3Q3Gc
 NECfk4mv6PUm1HZuSK5V68fUfdxHqxV1456HSgAwjgvOP/wYc5vs3FfNuf8a09xpe+rZ
 nqO0xAY9BMbJzyrC/nYTSCeZJNV2OoKbTWZHRdZkhwX+EEnVBpcJLxC2RtjSR4prKGxv
 i9sv+p9kZOpmy6H31n19ugNZZsxZ0q3oXS7klG3MptUQX9PHbBIAR9b2+LRQdjQShRDj
 euHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sK7Bv0enNZHiUYvwnBleR2mEnCHV5OhHNBDPWeFOSoM=;
 b=W6bp+Bzjmixs7SEMZ9g9983+RA/4z3zV8AHomHvn0Sql5eGFv7MHnSoxNsj0ay1VFu
 D2cXpD6DjP88Sx+F7Hivfp40x/oxvGxvBm0mpT4MzGzeldixMrrnckPuGVOz9C7wUy3N
 gneQvZQsu/W0CSHNWHXqwkA1R3VPvRcOX0ArGmMpEbaMFeZuQ+z1N54BhBxDm4sv8IE+
 7iMOxLwYyy8odAlmzzn6r5TlyCDxXE5hpOVssRNizwOKVLAz2xL2zcn6yy1odM7klJZh
 vBBfZih5HIubJNjjwgJkFBrh3ZjvHk2gjQ1NqIner/3QFV0dkMG1HetaX8O2SEgMYsKJ
 lc6g==
X-Gm-Message-State: AOAM533NYyHCI0+MrQgMO/QrKcO4FK2DqwF4uo6a5ngEA77/lU6zP58b
 a16x2D5d5h8dYaHwZ9cFU3I7/RkLg+isTr755bjjNYrZ9f8oSQ==
X-Google-Smtp-Source: ABdhPJxjyigrkTxPmeqzxtaaevkTllMZZ2xDBoOTpl1q5n1TCVoKq7IWuJTHuJmECCV1gc/9xlpV/i9pCn3rWKtnIZQ=
X-Received: by 2002:a05:6512:12c3:b0:44a:27ac:c7a4 with SMTP id
 p3-20020a05651212c300b0044a27acc7a4mr2766629lfg.150.1648561011920; Tue, 29
 Mar 2022 06:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
 <20220329011301.1166265-4-oupton@google.com>
In-Reply-To: <20220329011301.1166265-4-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 29 Mar 2022 06:36:40 -0700
Message-ID: <CAOQ_QsiKa4UUvsfypGqiMoFb0c5f5gtyk7ADv0M15E0Gi04QPQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Start trapping ID registers for 32 bit
 guests
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
>
> To date KVM has not trapped ID register accesses from AArch32, meaning
> that guests get an unconstrained view of what hardware supports. This
> can be a serious problem because we try to base the guest's feature
> registers on values that are safe system-wide. Furthermore, KVM does not
> implement the latest ISA in the PMU and Debug architecture, so we
> constrain these fields to supported values.
>
> Since KVM now correctly handles CP15 and CP10 register traps, we no
> longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> emulate reads with their safe values.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d62405ce3e6d..fe32b4c8b35b 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>         if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>                 vcpu->arch.hcr_el2 &= ~HCR_RW;
>
> -       /*
> -        * TID3: trap feature register accesses that we virtualise.
> -        * For now this is conditional, since no AArch32 feature regs
> -        * are currently virtualised.
> -        */
> -       if (!vcpu_el1_is_32bit(vcpu))
> -               vcpu->arch.hcr_el2 |= HCR_TID3;
> -

This is obviously wrong. I deleted one too many lines! Will retest and
resend, this time hopefully with register reads _actually_ being
emulated :)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
