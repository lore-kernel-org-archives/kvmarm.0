Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCA2C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:08:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B22CF60F46
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B22CF60F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 422864B0C6;
	Thu, 29 Jul 2021 16:08:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5x+MOSWTvAue; Thu, 29 Jul 2021 16:08:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 061B54B0BD;
	Thu, 29 Jul 2021 16:08:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 918084AEE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 16:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yaf8plM274Rz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 16:07:58 -0400 (EDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 559224A198
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 16:07:58 -0400 (EDT)
Received: by mail-lf1-f47.google.com with SMTP id u3so13175945lff.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jTmFh8dBUxxfIA7MnCPlfr2/MF7WnSFwZKcouyPXsrI=;
 b=j3mDa6/bGguSlBEB/5YxoKvbffgwh8rRFdcJJYMuubkjWC7CzKoNOZD3yPNxJ5HXdP
 hr+DzfA66ATd4M7E2M+M9zIPjJABeU+0Z61nfoY9yQ7zilP+BKfpzFqjtu00y0DbImoJ
 FTcarWb2JwjnWDYZCTMQ30Lw2y2/cEPmgU5RxAZDbsvJT9r52Z8AErywhCQ5AHiYBGnj
 LQrDuL/pl8MB2hzSyUiTTaSfvn+bLP1LwIqLrY+bKAdNRfLwWBAQXSPX5vOgARcuEjHW
 8gM3Rf16RdRVskU9QL4fMLoKQ1RhQ6RpT/7d83kUJ4+MU9JieNSqBmgPZyqNihnU1eaq
 XeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jTmFh8dBUxxfIA7MnCPlfr2/MF7WnSFwZKcouyPXsrI=;
 b=bqyps5gZnhgk9MndBxkFULRKM1POe6fRkabKl12W6RUV+jmz7o6O1oBk4beJaV1TLa
 vhp+KxsGFf6qPriJqc4qqohaliXmA9aWMtC89iJTVweyZX5LCl4p6bABMgdmEjSzCUkL
 TWDaPaca6iMU1sR2pAhdUSh+0oHebc1VyyRXi3+uxzbJswub2nDiuyr23AOc6vtC+YzD
 rKnn5iJbwgG7Kf3RdI55ieh44BBFUTG/BV7OOHkn0LWPWgBHsP8MUbO2JhQ9xMp/hGHx
 OrUK4BVUhcWSqO8I8+9kxJJm/AGDyVlnO15YM48bzSppB9SyqmT+AMW4m+d9CIcGKj+h
 yl4g==
X-Gm-Message-State: AOAM5328ZNwxXeBose+8qx5h5PMHi8mUUrgYKLnR9WjT39GGAJWe1VCd
 kFv0LvGKpGlA0pkmR/0rPQkgvtVvoXc7egGSlvfgRQ==
X-Google-Smtp-Source: ABdhPJyCK1cfhDjBCUWkIafk33w1RKfYfFOKKupy9ZzcP8PGybq89vd6BezAvcQkfzUv0BhjixrwfA9GUnzLCWOGh0E=
X-Received: by 2002:a19:6b14:: with SMTP id d20mr5099285lfa.359.1627589276715; 
 Thu, 29 Jul 2021 13:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
 <20210729195632.489978-2-oupton@google.com>
In-Reply-To: <20210729195632.489978-2-oupton@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 29 Jul 2021 13:07:45 -0700
Message-ID: <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU
 stat
To: Oliver Upton <oupton@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, KVM <kvm@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Thu, Jul 29, 2021 at 12:56 PM Oliver Upton <oupton@google.com> wrote:
>
> Most other architectures that implement KVM record a statistic
> indicating the number of times a vCPU has exited due to a pending
> signal. Add support for that stat to arm64.
>
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 1 +
>  arch/arm64/kvm/guest.c            | 3 ++-
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41911585ae0c..70e129f2b574 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
>         u64 wfi_exit_stat;
>         u64 mmio_exit_user;
>         u64 mmio_exit_kernel;
> +       u64 signal_exits;
>         u64 exits;
>  };
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..60d0a546d7fd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 if (signal_pending(current)) {
>                         ret = -EINTR;
>                         run->exit_reason = KVM_EXIT_INTR;
> +                       ++vcpu->stat.signal_exits;
>                 }
>
>                 /*
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 1dfb83578277..50fc16ad872f 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>         STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
>         STATS_DESC_COUNTER(VCPU, mmio_exit_user),
>         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
> -       STATS_DESC_COUNTER(VCPU, exits)
> +       STATS_DESC_COUNTER(VCPU, exits),
> +       STATS_DESC_COUNTER(VCPU, signal_exits),
How about put signal_exits before exits as the same order in
kvm_vcpu_stat just for readability?
>  };
>  static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
>                 sizeof(struct kvm_vcpu_stat) / sizeof(u64));
> --
> 2.32.0.554.ge1b32706d8-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
