Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7DBC43219
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 05:39:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 788374B8C9;
	Tue,  8 Nov 2022 00:39:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1sxKEOIaABAM; Tue,  8 Nov 2022 00:39:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340174B8BC;
	Tue,  8 Nov 2022 00:39:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 957194B864
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:39:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id drJW6z2x-I0f for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 00:39:15 -0500 (EST)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C2824B84E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:39:15 -0500 (EST)
Received: by mail-pl1-f177.google.com with SMTP id io19so13220651plb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 21:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Pz3TQvJYE17eelsCmAIKQH4K5ZpJA4fTVBa1z1nTTM8=;
 b=IOwNbZZGA7GQ46cWFdsY+B8zogEIS2IXjVotgY9MfbBfAfpoa5E/uc/8KrHVc/Pwg+
 F5ILEXrqOb0BxfkrFhUsLFMHq9NqlTWE1sy3CSju4txDxRFGMb7rJPZ3OHQeqh8pLGkV
 A8Ws3BEJX/fDhOtwYRrUAKJzX63a4TJHYV1t0p4jGmkELlOj0/CCnuid55gKcVbtfGp/
 hZU1/8MqdjbLhSC3XekuujoIMvuPvTczjvEZsK/3RwbQr+LLE/y93/zAYJZbq+CQpTOD
 Qcl0dEbAq+GZ8eGtx06f8ADzYtJZb3CS6jizD9O7H+v+y/WeV+1wvRI4H4DbkLh3tkTP
 mOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Pz3TQvJYE17eelsCmAIKQH4K5ZpJA4fTVBa1z1nTTM8=;
 b=Z4CJT9NniL8ikfByuSFKZnuIWXB/eRCumdfFOxYulrRB9BE7pz93ZRFB5YvbL0Ou8r
 vXVXYUide1SFet4/qmggc46EsLK9+ue72kyWAsQnFwPX03LjTOH2rAf2GQR1uv+kFLzW
 G6JYBLNA9lUQQT/HTzmo0v/kB0EWaX/htg7t0WCDSIobCwZK3TGNSMVQdRIGseCcReep
 tgz8Ga/VKkT/iil+A7S84C6wZ59TfRTUiz84hfAM07X/JEpA1eIH18b2W9jJKz04Aj4n
 jYBfpvjNeTecaqg9ovxFpmTI7Xs8qlyoMnBvTv+2EfYnKz071IpKB8ufNAD1htlOYp4e
 4nNQ==
X-Gm-Message-State: ACrzQf3bCXFJ7MfDpF5iNcav1FPY7ipk6BVeMIdFAw4UFAWwVujQKNjT
 B0HhVB7ZfCSDM3WGTXQdJgITkxVemzqqCH/F2NzPIdY8Bqk=
X-Google-Smtp-Source: AMsMyM4s6UBfXivryrOibC1CJghXZh+LewJC7EVe1bijyzWBrmOnmSw5hn3QDTcMQZSqMPexbYbexJp1QaywwsPftvw=
X-Received: by 2002:a17:903:3252:b0:186:59e9:8dca with SMTP id
 ji18-20020a170903325200b0018659e98dcamr949010plb.154.1667885954190; Mon, 07
 Nov 2022 21:39:14 -0800 (PST)
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org>
 <20221107085435.2581641-12-maz@kernel.org>
In-Reply-To: <20221107085435.2581641-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 7 Nov 2022 21:38:57 -0800
Message-ID: <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Mon, Nov 7, 2022 at 1:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7a4cd644b9c0..47c882401f3c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1247,6 +1247,43 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                              const struct sys_reg_desc *rd,
> +                              u64 val)
> +{
> +       u8 pmuver, host_pmuver;
> +       bool valid_pmu;
> +
> +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
> +       /*
> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +        * as it doesn't promise more than what the HW gives us. We
> +        * allow an IMPDEF PMU though, only if no PMU is supported
> +        * (KVM backward compatibility handling).
> +        */
> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
> +       if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver) ||
> +           (pmuver != 0 && pmuver < ID_AA64DFR0_EL1_PMUVer_IMP))

Nit: Since this second condition cannot be true (right?), perhaps it might
be rather confusing?  I wasn't able to understand what it meant until
I see the equivalent check in set_id_dfr0_el1() (Maybe just me though:).

Thank you,
Reiji


> +               return -EINVAL;
> +
> +       valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> +
> +       /* Make sure view register and PMU support do match */
> +       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> +               return -EINVAL;
> +
> +       /* We can only differ with PMUver, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +       if (val)
> +               return -EINVAL;
> +
> +       vcpu->kvm->arch.dfr0_pmuver = pmuver;
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1508,7 +1545,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         ID_UNALLOCATED(4,7),
>
>         /* CRm=5 */
> -       ID_SANITISED(ID_AA64DFR0_EL1),
> +       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5,2),
>         ID_UNALLOCATED(5,3),
> --
> 2.34.1
>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
