Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3562623FD02
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 12:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733921755; cv=none; b=P+mi+qXxjN/jYJ5VjZ6LkH7oW8xXd4ltVJu+eISJ8rfHJ2GSOtnaVp3bhl7QveCzV58hAJ1zCOvIR44FmPQadr94YEEBYv0XVledoajGcihqMrKCH8yzsN9HxH1F9CV3g+9+ORBnI+0iYY71cnx5rpnCtSU0qFeo/dNlgdncFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733921755; c=relaxed/simple;
	bh=YRLzPnsRFyvCzJ3QMXzqfU+0b1eB+yM33ZVyUzKbYP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5GEIzdY5Dr8m8deWY4a27QfxpcR6eTPzTu3nsVeuk6SBuanDL1iewrPWpsBlgs2ZscPc9K28NMMA/o/rYaXNWUS55ntn7x2uAuWYN2+HBNAAHqKOw7q1d952v5bt7rkybe6RHvIdSG/8svQPHdH4FfQlPAXf3MyEERpaltGNkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JzuATLYa; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JzuATLYa"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso37415e9.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733921752; x=1734526552; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tp1qrh2uE1dCCEghnnvrSjtwgId1DtRFpj1taeMf/RI=;
        b=JzuATLYanDy5Dt/f1VB3OHLAIggw75syuNOAx2MCV15Cwhxb/x7WHvWfTyDPfXdbzr
         LA4c6GqJzWpwn1YyvkCAb3x8771K+QTohfo8S6Zdz9msupqcO+bPHUmX3gsY6Hp2qy+M
         9oUZhWMqmiln4VJxGKBwHbuAX7sNj2lkZjm96ctH8MbVhIRk2jIO+LhN0tP7820PRf7g
         z78NLencAvtao+kVJ9nQaKeGAKz21CJ7o0q9sMcPevfu88kvEwiuFB903vLKsSiMcHuE
         6wjj81STY8Se/RkOnuVyEcw8EwkIUrMEVfuaC/VwXRVnHl+7oKBe/xh/WPJcClmlFhOZ
         gCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733921752; x=1734526552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tp1qrh2uE1dCCEghnnvrSjtwgId1DtRFpj1taeMf/RI=;
        b=KM1OjJHzsM4ngmiLuor2VL57U9tIAL/MOqSZDvdlP8j73tO/sqbVH+dq6ThzcM8f6z
         O42zi0IWkLB0XOH7l6huQxM1HXa6cAl703zWPRu65+WuYPMyyB2WTwsMuWfL/zQIfPPA
         mzLo1JL+qN7f7trIzmgm7ZOnWj+WyOwKRKozrkXThO26Zen+B//OFDzHcZ9uub3M8oy/
         PjIvZKyDCQxIIQv+E5caS3JFBbLXuwvB1krAU/hg9Ju/VVF+txekRhM0zc6UQYE5Q8oQ
         xfcF9eWVvBDUXCGpyaMiGiaVTwmyYXykNGaD/vEE++GxGRoDkH4JRwnrlHMptniZ7Jwx
         V6yA==
X-Gm-Message-State: AOJu0YzfOWc6L1hn7mcrCxCHHMtEZOQntq3nk5fDc7aVe9szB9tMy9Ta
	/uK3iTrO2IrF/nKj1Um1AkdPQ0iHjP7pgX+Kp2jrw4NbRLivfiDTgczOVrLAh08F4+K5FfZk21D
	8OmFcRWh+8FeYpmW0bwndk9espVd7Eav5cR8U
X-Gm-Gg: ASbGncuGXhD7ifl9YMmB272sLHfmbDCGho/6fg0oyyQLVqD3W2Q1AcSyuLE3hQAQdA8
	KtvcbZpqnA6iBMy5x4HAtjwzPP917LjMSazTkWyN2Q3sftPm9l1l0sOHvBS53NPMX
X-Google-Smtp-Source: AGHT+IF3dIT7fuJS+iL7UWob1CNU5m9rhIXgg1PTuH15dSwzo7oLBkZEFY6Rh4KIzkFLuEKi5aXZccIAjHgUrb//06M=
X-Received: by 2002:a05:600c:2105:b0:434:9fac:3408 with SMTP id
 5b1f17b1804b1-4361c0f4f80mr1205495e9.2.1733921752418; Wed, 11 Dec 2024
 04:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-11-tabba@google.com>
 <Z1mJlF-H5R_-f83I@google.com>
In-Reply-To: <Z1mJlF-H5R_-f83I@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 12:55:15 +0000
Message-ID: <CA+EHjTwDSo3XXxruPQSbJZJ7wNqyFX4fec-SFuYfd2XBqJX_DA@mail.gmail.com>
Subject: Re: [PATCH v4 10/14] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 12:46, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:37 (+0000), Fuad Tabba wrote:
> > -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> > -{
> > -     struct kvm *kvm = vcpu->kvm;
> > -     u64 val = vcpu->arch.cptr_el2;
> > -
> > -     if (!has_hvhe()) {
> > -             val |= CPTR_NVHE_EL2_RES1;
> > -             val &= ~(CPTR_NVHE_EL2_RES0);
> > -     }
> > -
> > -     if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
> > -             val |= CPTR_EL2_TAM;
> > -
> > -     /* SVE can be disabled by userspace even if supported. */
> > -     if (!vcpu_has_sve(vcpu)) {
> > -             if (has_hvhe())
> > -                     val &= ~(CPACR_ELx_ZEN);
> > -             else
> > -                     val |= CPTR_EL2_TZ;
> > -     }
> > -
> > -     /* No SME support in KVM. */
> > -     BUG_ON(kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP));
> > -     if (has_hvhe())
> > -             val &= ~(CPACR_ELx_SMEN);
> > -     else
> > -             val |= CPTR_EL2_TSM;
> > -
> > -     if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP)) {
> > -             if (has_hvhe())
> > -                     val |= CPACR_EL1_TTA;
> > -             else
> > -                     val |= CPTR_EL2_TTA;
> > -     }
> > -
> > -     vcpu->arch.cptr_el2 = val;
> > -}
>
> Mooh, wasn't this function added in this very series? Not a huge deal,
> but is there any way we could consolidate things a bit?

Yes it was, but it was added when I was doing the grouping in Patch
02, without changing the actual trapping, to make that commit easier
to read. If I were to consolidate them then Patch 02 would be changing
more than one thing at the same time, making it (imo) more difficult
to reason about things...

/fuad
