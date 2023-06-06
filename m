Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB2A37B71
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 14:29:18 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-569ca440bf0so26377697b3.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 07:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686061757; x=1688653757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mrmslx87A+AZGfHGJkL0tEHV/zprTybhJszuOn39+0U=;
        b=UPqTBByhBMUtPGT9UfJhbHwP88I/lwRPfVkLFjZ4pMiAJ3eAnWGbLNiOA07VUWHtEf
         Q26Yn+yHleID76NwX7JbREPS9S+YFy11RdrjEIbl/g32K49RZbVacl8pnxDld+c0dglB
         Q3TS33PiiXpcrELcOAvuMcCJRviH2e0XPhaIJxPDY+1nCVhVYl4RgpJOemKcxMgLIAUC
         BelYAfKJjVywy49mPXc7oKz+slBIruOfNCNJsMcV+vFOM4x/iMddFj50JZykpMJIa+Uo
         HAwJV/HQRwh/US8AFYSBxwOYY1aF4D5xwXBs9zpBkAtPqdFWtErKftUw5Gi4TN36RVa4
         MfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686061757; x=1688653757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mrmslx87A+AZGfHGJkL0tEHV/zprTybhJszuOn39+0U=;
        b=BKnrb//QlZJwrCMCtFSa6oNuCByiw85UcmvN2YMVjFEZXxvBAbgOIfyR4QF/IPQmz7
         iWXV4ZYtqdPfTvrscqOD1Jofs7SN/JnVQMs2grQNwfwLU4oB0riaPWJCgVdQfhOsTA8K
         MEtFySH5cp7g9fth8wRk+grTRvsh0pryKWWNtyQ3rlOX73w/kpVT6llzmxFoBBZwxTT0
         u2sRpOBATvQHMZ+A5yFvif2NBzQIXNEY/CPFyxtVsZO/9L13DuSWsf8KZOUhnSjUAXj9
         C0tyGyGz8/3foyh4tABCT0+zVXXzMU62i8gyw6C3x1SyGTL54lkhNtvCYmyGmMq29LZs
         Yd9w==
X-Gm-Message-State: AC+VfDxB2IBsH2DgXlfq7ttfsVzQAgiQEk9u221IX6Add7cIhxqzP6OZ
	aOUa+rESnZI35NLekWR/5AT1HW6DfbM=
X-Google-Smtp-Source: ACHHUZ4Cl9QaCN+iZoQhs5r7QH5SzDjvwgOS9YmErQUF6o30gzflB1KRF/zhyfkgFYKWnwOFMO+gxRQzMsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ec4c:0:b0:560:c30c:75f7 with SMTP id
 r12-20020a0dec4c000000b00560c30c75f7mr1162947ywn.2.1686061757665; Tue, 06 Jun
 2023 07:29:17 -0700 (PDT)
Date: Tue, 6 Jun 2023 07:29:16 -0700
In-Reply-To: <ZH8+ZG7DOX9TYcIY@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com> <ZH8+ZG7DOX9TYcIY@linux.dev>
Message-ID: <ZH9CvE54NSVXqjlO@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible context
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 06, 2023, Oliver Upton wrote:
> The call from a preemptible context is intentional, so this really
> should just be raw_smp_processor_id(). Do you mind if we fix it with the
> following?

...

> Nonetheless, there's no functional requirement for disabling preemption,
> as the cpu # is only used to walk the arm_pmus list. Fix it by using
> raw_smp_processor_id() instead.

As a partial outsider, that needs an explanation, and the code could really use a
comment.  I assume KVM's ABI is that it's userspace's responsibility to ensure that
the CPU(s) used for KVM_RUN is compatible with the CPU used for KVM_ARM_VCPU_PMU_V3_CTRL,
but neither the original changelog nor the above state that, nor does anything
explain what happens if userspace doesn't uphold its side of things.  That stuff
might be covered in documentation somewhere, but for someone just looking at git
blame, this is all very magical.

> Fixes: 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for default PMU")
> Reported-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/pmu-emul.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 491ca7eb2a4c..933a6331168b 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -700,7 +700,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
>  
>  	mutex_lock(&arm_pmus_lock);
>  
> -	cpu = smp_processor_id();
> +	cpu = raw_smp_processor_id();
>  	list_for_each_entry(entry, &arm_pmus, entry) {
>  		tmp = entry->arm_pmu;
>  
> 
> base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 
