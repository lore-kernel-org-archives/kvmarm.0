Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79423FD14
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733922722; cv=none; b=p6LCIuFKFfVhw5B8WeurnTLKgbJqnCS6C/GR4LmKLzv0BoVHojgOg6ctLVIqSWcOmfsk0RmSDGCCP2wR8c5dSDqvjUfd+HHdXm5bkCJbVqqJBs+wPEHhYQln9DsMhKNt1jmyiqUiFnXVf5hYw6Xg1Jlq/c/DIV5R8XGvgPIysUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733922722; c=relaxed/simple;
	bh=2bOroIvbtA2JFMR2DeSrnhFbxHGRRbwy2U1x57WiKpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJlHMJ9u+92rjjT4Iw+saz2NBnaalah1v89pBwUXej239cqcO3wYC1vNtFdFSimH9TkIlYFeT9eqCEpJvKJjv8AXHbk0N7wxmehXlDZNdng8XdgnTgE8BV+7KU9sob6K2PZpyEUpSSpJj2LSJNETGiaQN6+wCDNqB2UaDzXb2Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=19lnMYJ0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="19lnMYJ0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso3115e9.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 05:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733922719; x=1734527519; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SpgIVXJPCWJq+BvZ7U8OZJJ7fZhImEdZ13gLAjbI154=;
        b=19lnMYJ0kaQQGBi9I5PbW/XXtQvmxQAYUreW5ZZ10i+3j+itL/AFFoE028KaM0e5UL
         crAJ7wNcxQ5L9DGP55DN9ADjKquFB4jUAdxkShZ4gY2ClpKEteufzrNqp7DmLo+hw8D8
         6jrmHxgqdLgJU/2DPOLaxrdf2gTwtgx/dDFxHE8zMP1GyRIC3eNM6UKy9SpkX3pBkv+I
         IYeBAjZYUWaZkL+PEukqk91qpa2yNtXmNdMPN6iGp98yCfhDFb37KAeNpPf9PWlRg8A3
         TVF/KTcuwMPM0XbfsU6S/Yw2EuoLcmgfXnHcUxrNMh3hLleeiadwgYPZ0AD8BdBG6+em
         8dhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733922719; x=1734527519;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpgIVXJPCWJq+BvZ7U8OZJJ7fZhImEdZ13gLAjbI154=;
        b=bP6A9bly8HYK684Mwd48lWxrR19MkrC5hCI35AffBJ6VqODPNN41KdqAR8UJTc3/V1
         1Rc12km0X/sJ7TRJdW0NT1JXsZyfj9fIDl7GUV6R3HNsOpOgklf6Wfxq5wvBnqxL/ax0
         Wa4560yyT+oBnvPUvydiJNJjTYWcD8sg1SZrM5Yc8jvMuxx5Z2/l+Ntlvy/tQqcqD4Rn
         nHPi7uM75BEIox4LiZ0iJEks93m1Klt6t/pby70IsQmvEJcnwNbIRMbmknGgnb0X6vH3
         J2vBDM+i8L2qbNxD+NAUITMEh3dR1WUEQqCiht74MvE05CcoZIuzsQfeacDq8bFMjwOp
         87Mg==
X-Gm-Message-State: AOJu0YxkNaI70E3aN/vBk+sFWy/aDpko3VxxBKFA5zL+atfc2NtkOx9C
	poTGM3yCyiY5MBNpasGqCG8HbEsj4oxz8geEP5CMkLYePEWNvAeC17bBFyaItvPnLcqaCZ6IBTw
	qk2Hn7F+EhFDWtJAYPuUMQJvqGpoIP+po6x1b
X-Gm-Gg: ASbGncsy7+k2ba46KCJm3S5eLormF2T9d+ZoStbhgYZWB8QZtq3hl4eM6++dd6zIBYK
	c46Nj99+Kl1c6/70mBhDmWcBmUbzPdeZ2bWhcs871XMqyhNsOJYpy3RNfHpypkWVd
X-Google-Smtp-Source: AGHT+IEfuetELzIWhfEeFRhYatZdwR7CYhn8kG7Vcp2ICa4z5Mba1kHJ461NL/L61xviWIJRhaUMxTdQVlaJz2Q/5Lg=
X-Received: by 2002:a05:600c:6c8a:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4361dc51b9bmr958645e9.5.1733922718921; Wed, 11 Dec 2024
 05:11:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-8-tabba@google.com>
 <Z1mGzwZqVQCWWSTX@google.com>
In-Reply-To: <Z1mGzwZqVQCWWSTX@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 13:11:22 +0000
Message-ID: <CA+EHjTzaVadZgO++bSYopQpy8DyfP1W8ytoOd6Q7yy+yEVqfeA@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] KVM: arm64: Rework specifying restricted
 features for protected VMs
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 12:34, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:34 (+0000), Fuad Tabba wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f333b189fb43..230b0638f0c2 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1422,6 +1422,7 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
> >       return test_bit(feature, ka->vcpu_features);
> >  }
> >
> > +#define kvm_vcpu_has_feature(k, f)   __vcpu_has_feature(&(k)->arch, (f))
> >  #define vcpu_has_feature(v, f)       __vcpu_has_feature(&(v)->kvm->arch, (f))
>
> Nit: I see nested uses the raw __vcpu_has_feature() helper, so I guess
> we should try and be consistent. Either way works, we can do the same
> thing in sys_regs.c, or convert nested.c to use kvm_vcpu_has_feature().

I'll add a patch on the respin to fix the nested callers. The lines
that call these macros/helpers are already quite long, and even though
it will add a bit of churn, imo the resulting code is more readable
with a kvm_vcpu_has_feature() helper.

Cheers,
/fuad
