Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027212F39
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 05:39:14 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id 4so13275788pli.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 21:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=pX6VgGpaHvdKTM88fKF6h+KUF3O77mh0+c1HXzX7JZbimWAsukiwISCkLK0bx7cW3R
         N4Wd9A2jVLk4N8I6uquA230Oq05HQoo7blpDzqNrvMQn1A1F9+ERgrMqkdlJX+0HXWSh
         /tU7W3wuFXw5b8lgOCuKPTKoDpUYrnT/riD47YgL3ol9+AdpQVjfNQmflTlD4hzTJGp7
         UQbYeNiAUTELn/AQkuE/Xn8qc8YF68TdoovXTnYdLeXrE32y+VGf9OswMVoMuPRQtZII
         VXfTFIRAyF9ilgHEKJ0pB7J0g1hVfABlyJ0+AU527n05hyOUXdsBZuDdt9AEqWPMTgy7
         j00A==
X-Gm-Message-State: ACrzQf0mvMxrm5Nkh8pFtKDhCTf6GUngzQq5hdvlqMi1H+pHDqQtzYFT
	VEb3cLq+33WBMkDS6MmlQQfAuh2dKPHeMyGDotpdCA==
X-Google-Smtp-Source: AMsMyM4s6UBfXivryrOibC1CJghXZh+LewJC7EVe1bijyzWBrmOnmSw5hn3QDTcMQZSqMPexbYbexJp1QaywwsPftvw=
X-Received: by 2002:a17:903:3252:b0:186:59e9:8dca with SMTP id
 ji18-20020a170903325200b0018659e98dcamr949010plb.154.1667885954190; Mon, 07
 Nov 2022 21:39:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org> <20221107085435.2581641-12-maz@kernel.org>
In-Reply-To: <20221107085435.2581641-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 7 Nov 2022 21:38:57 -0800
Message-ID: <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221108053857.hP4neMoWfrPvRWeKoU2QrFzH4b8ete9SBfudKWSdBW0@z>

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
