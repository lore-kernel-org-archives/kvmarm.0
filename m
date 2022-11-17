Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EBBEB1C
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 06:51:04 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id b62so1235509pgc.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 22:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
        b=COdBKeWciEUcxRjfv54pacO7y07o7BOLG2qNenQAwJZp0M8UcST5OLdENV5peqP150
         Lld+WqcJLCLA+svE//sI6HZ6boKGiC065GyL/C0UlhvdTHZ5Meyas0NOdL7b7ZTEU28Q
         QLyIkqxH2KQnHACOB7hgCx24pGu5v7lo6J9P8KPO1SdtyT1QdItekW+gmj2e75LB+Abb
         7Vz+f0D6/pT4wBL1tP/5/3ue0NtF0FKlpOScalgJvQq4lHJCJ3neX4zMR2gLkiQifGyx
         /CtxNEeSMt8duyrk6Q8s95bPhQFa4YdeIoinYBLMM+OR1Ywg6jMqEoVCkufjCJXEcqHY
         bHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0y7VdxwHLwhJHQkWTFwHzknojiHUon3RH8OwCo8MxdU=;
        b=l+QHsr4iVl6CfLJQuJvN6jWBz/BKG8YOrWqvh4t17w60qlnWtPwIX2fIa2+q/2+4Zw
         TOHRtgsrLqiX5Gsso5VyUoAVulD4Lxq2WVz9Wmz25x9mcN67QjZKPLXSPvGUIrGsfA7F
         6Y3D420nJ+jPW9z5knqyF0esKgn+UGr8BtGYRUqDgospCOq8At0mV2gdAjSpQGVe/otX
         DsTZth43YT97BUk2hJzAkboF2eIm+UQVsBiSrV2oSNxzjCbBZWfYm81ci5vjIeZc839k
         3iTjwkG8txjTpo80hLpmXpMYa1ESKhdk9kGbIY0jVhOiTrKDThuGKGyw8CoU09rpLkmz
         SfWg==
X-Gm-Message-State: ANoB5pmAFn7lfMQLPCrdhpICFSXuCUYhrj7MwyAFHX7Yyozfw+lU+pJ4
	UX1HNoaI7OoTEhpSvrYVxnlHtqXBy4HlVlci65e4+A==
X-Google-Smtp-Source: AA0mqf7ZAaFwtnsQ/o31Qma+1YQJIdWkjS6YTmda5EJO78rYJYD90n/VB3W/Ch7Q9Uxv6tcnOHnWL1HG6hz+RkFwHUk=
X-Received: by 2002:a62:1b0b:0:b0:56d:384:e13a with SMTP id
 b11-20020a621b0b000000b0056d0384e13amr1555432pfb.75.1668667863849; Wed, 16
 Nov 2022 22:51:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-6-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-6-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 22:50:47 -0800
Message-ID: <CAAeT=FzO4_bzOY3m6X=2a4VWxwfBPP8u0wQ0VTeK+64NVe+e3w@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] KVM: arm64: PMU: Narrow the overflow checking
 when required
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117065047.oMS3tI954Va50gLHJp-a_RhxqSEId3oueUqFqUXvl-Y@z>

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For 64bit counters that overflow on a 32bit boundary, make
> sure we only check the bottom 32bit to generate a CHAIN event.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index d050143326b5..9e6bc7edc4de 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -417,7 +417,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>                 reg = lower_32_bits(reg);
>                 __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>
> -               if (reg) /* No overflow? move on */
> +               /* No overflow? move on */
> +               if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))

A few lines up, the 'reg' is unconditionally updated with
"lower_32_bits(reg)". So, the change initially confused me
(until I checked the following patch).  IMHO it might be more
clear if this patch and the next patch are folded into one patch.

Anyway:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji



>                         continue;
>
>                 /* Mark overflow */
> --
> 2.34.1
>
