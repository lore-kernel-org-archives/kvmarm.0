Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E374CC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 05:53:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4BE4BA81;
	Sat, 19 Nov 2022 00:53:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EvXc6yE0Ltvz; Sat, 19 Nov 2022 00:53:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB414BA8A;
	Sat, 19 Nov 2022 00:53:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 475564BA81
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Nov 2022 00:53:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 55BanYjOz30U for <kvmarm@lists.cs.columbia.edu>;
 Sat, 19 Nov 2022 00:53:14 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A75E4B973
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Nov 2022 00:53:14 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id k5so6227730pjo.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 21:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
 b=fUpTDtRxfjg6unyhlyNX9OdDnqKxaHSz88G5lgmqtHNpZpgAscvHJbdGqXZDnqpM9P
 aegcZohdOVti2VieOCToDG20TFNykHNuYhjenxkdyLHL/2PPEdFGHNMP9eEJ9oAH5UOF
 y2Na9pK/LY93pqbyMf57qVXQwmz9kFgYXmWVTwbmDd7YbTxFa0pNtmUbtL3bk+3yB42D
 wATYzmC1cI6yQnEwNioy14jOcYLzuE0qAxp2YRg39ebNgSzUbRALJWt7mpBOM0++z+RD
 royoIERiovEGL861hFzs//PxiAzc4W8TKiVEnINoQn/91VzXXHFS7vrLRQ9fWmJlMQT9
 0IKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
 b=j2ErZxfjxwvZgARjrmy0PBMAlWQlOdbo5zYgZEf1rryichuJsxO0w0FpTXi39dKabh
 ZOLGzHYtafjgodS7RjoHmASDbguCOzc7TEczotdCGpBAdVsTvqytFtd2TeQ11et+m5E5
 PJ4yDciVJwfFWfJnG48zbTdTHoTln2o8q85gSrx6vVVabdU3snissxir0Dh7CLgYiejU
 ey1PFVTgSGr1H/aIwYvNWdKlst5Lv+9GcQlqFsMQuo6HWowbz+2cmbELXHC5Okg8jcaT
 4ZNTvsZjRJ0b/nz+QYPP7LM4rRpNDjEfgCKM8VFN2wtuusTHlHKIq7nJS80lH7TtZVUD
 R6KQ==
X-Gm-Message-State: ANoB5pnsktgCCjsID+qFe3DeitApQ9ZbigwG30BacV+oZvxenfa3FVVd
 nKnqOqS9RWMoTFjQ4Psh/v6f1cqO6JbsucjEGJkgMw==
X-Google-Smtp-Source: AA0mqf4kXBS5cv71+AQu54rPe1r6va354rE1Kqu4awgYk/aGAewIyvsWXPmKv1Nwztx5XCKtF6ysqdChVX62y5oIrQk=
X-Received: by 2002:a17:902:cacb:b0:188:5e78:be0 with SMTP id
 y11-20020a170902cacb00b001885e780be0mr2780600pld.18.1668837192845; Fri, 18
 Nov 2022 21:53:12 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-13-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-13-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 18 Nov 2022 21:52:56 -0800
Message-ID: <CAAeT=Fwq8wcBvoWE+5RJt4og4uD5KgQ0kzhDZorGPjHmTguwzw@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be
 set from userspace
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

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_DFR0_EL1, on the condition that only
> the PerfMon field can be altered and be something that is compatible
> with what was computed for the AArch64 view of the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3cbcda665d23..dc201a0557c0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1070,6 +1070,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>         return vcpu->kvm->arch.dfr0_pmuver.unimp;
>  }
>
> +static u8 perfmon_to_pmuver(u8 perfmon)
> +{
> +       switch (perfmon) {
> +       case ID_DFR0_PERFMON_8_0:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP;
> +       case ID_DFR0_PERFMON_IMP_DEF:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;

Nit: Since IMP_DEF is 0xf for both PMUVER and PERFMON,
I think the 'default' can handle IMP_DEF (I have the same
comment for pmuver_to_perfmon in the patch-10).

> +       default:
> +               /* Anything ARMv8.1+ has the same value. For now. */

Nit: Shouldn't the comment also mention NI (and IMP_DEF) ?
(I have the same comment for pmuver_to_perfmon in the patch-10)

Otherwise:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

> +               return perfmon;
> +       }
> +}
> +
>  static u8 pmuver_to_perfmon(u8 pmuver)
>  {
>         switch (pmuver) {
> @@ -1281,6 +1294,46 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +                          const struct sys_reg_desc *rd,
> +                          u64 val)
> +{
> +       u8 perfmon, host_perfmon;
> +       bool valid_pmu;
> +
> +       host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> +
> +       /*
> +        * Allow DFR0_EL1.PerfMon to be set from userspace as long as
> +        * it doesn't promise more than what the HW gives us on the
> +        * AArch64 side (as everything is emulated with that), and
> +        * that this is a PMUv3.
> +        */
> +       perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_PERFMON), val);
> +       if ((perfmon != ID_DFR0_PERFMON_IMP_DEF && perfmon > host_perfmon) ||
> +           (perfmon != 0 && perfmon < ID_DFR0_PERFMON_8_0))
> +               return -EINVAL;
> +
> +       valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_PERFMON_IMP_DEF);
> +
> +       /* Make sure view register and PMU support do match */
> +       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> +               return -EINVAL;
> +
> +       /* We can only differ with PerfMon, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> +       if (val)
> +               return -EINVAL;
> +
> +       if (valid_pmu)
> +               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> +       else
> +               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1502,7 +1555,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         /* CRm=1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       AA32_ID_SANITISED(ID_DFR0_EL1),
> +       { SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> +         .visibility = aa32_id_visibility, },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
