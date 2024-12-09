Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F8215172
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 08:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731814; cv=none; b=Uv+zIto2kRFO4N24FXGIMpo6viqu9jU7DBhYZZJkX5EvYn5CLRGqsesHGcGP6J6CUSD35gQdKSJcKofApV78h6MyPXL9Xi3YnUkWqzX8b7134FQ54A6eN5/iRpnY7Ima7sgo4eGqcBggDX4hnNOuySo2ob3PVhfHGPBC65IzTXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731814; c=relaxed/simple;
	bh=PFlSvc+5Z3Xe44MU0qpEF86vpSSNPVhCpQ4kV8qHKP8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lawm99O6PavZye1slElj81znusN+Zod4/xoGRl+2K2DBZEzcMs4x5bbcq+71dh3XKQJLk9pCXilKmLm4AIaY2rn5gqvLXo0rRv9M4ViAzAbdnA9Hv6j8NPmusBEZYvL0EO+BAyA95fKAoJrZbpguA4rGz9toChVVVqE6MT9XgD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtMzLEdb; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtMzLEdb"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434e5e71a08so71165e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Dec 2024 00:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733731811; x=1734336611; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TJbTrtvGneL0K+ke9Gwc/0whnIda/bBfVk+UfsZChhU=;
        b=YtMzLEdbesS+b6jeymE8N52bnp97P+rLttUxDjyDzF4nfXEB9gHik6rIDZLYvv8r50
         vPzt/uwVljCX5KUuJSm70312fQF1V08Hn0kAwfwDmK5t9lkWbWs9jK+L5HJMEAzCi0mp
         bQmehR8H4R5CDbUljU4bh9STcevjswEqZBmMzj3kum6+TenDWZgPcAa/svcNa4XeiUeT
         Gg/tWe/roF18qaFTCNozu2UQVcV1iORLdjQ85VFa17XQYKBygj6OMnrX83rdgZAP9cr6
         DvJONsiQdsIQl5T+0hWTO8eF7P7LTwdx2oDOfja1o4oK+9La4nh/QLz+FDVnt6f+l559
         O71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733731811; x=1734336611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJbTrtvGneL0K+ke9Gwc/0whnIda/bBfVk+UfsZChhU=;
        b=nUbwjnSoTL5F0af72/CP8O5B1XDSbQcD0AmyLtsiLG3ndrFo2v1cb7kM65BahHzz7G
         YFzKQ03jRkl5O5FBOWwswk96ELQzf56+RwdhszDu6bOoeAtDI3CDFICPnIszP8jBjaQ1
         va7HVjIj0ybd0AIhLONhth+OlxAPi9hK2MW4yG8Xfh6YC9mH+XdbIS8tZP9I4B9g5keY
         IFtnbhrmT2TfPuurt+ZdmFDqKeNMBAsxyCkVUN4Fj5h7Tbfoggy/fKgwJM9l+7aEeKrY
         bEb7CJH199KWiRUntOszlPYA7xk5eexAg5IoCCBF1WUG6VM0bZ5ixU3RtOLeIa0nvH5a
         37RQ==
X-Gm-Message-State: AOJu0Yyb1mbKPBZegWa+EfJ5Pqb17+LH6YTUgDiKHrwiWJEPTtJuWZth
	VKMyGh1RV16q6uwkpIq2/J4Yd53MLwa7jaigK+lEcGVQ0gmL9DuBFrS61LSJkM18Oo//3S1DLF6
	sG8h8YGxD2+hg+kzPU7fscNCnAJjrrbUONeup
X-Gm-Gg: ASbGnctWsoAnocjJ9voKuqQuLOmUeudfE8uf7Pi9pQ0S+AAcgYW0W/EbPE5SZnQ1vUX
	ROqoaKMWthHlP61NpIWiO1GFz0mYLMA==
X-Google-Smtp-Source: AGHT+IHzonQzcQEPPJQ19YlDfCKStU1KuBNC12yGt6wg237N05KxGZu/6cvhmSjtaskyGSZGiX3jh152NoyInvIXc1I=
X-Received: by 2002:a05:600c:6c4e:b0:434:9fac:3408 with SMTP id
 5b1f17b1804b1-434e8347d19mr2392935e9.2.1733731811183; Mon, 09 Dec 2024
 00:10:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-6-tabba@google.com>
 <Z1MwuSh6jc94cem0@google.com>
In-Reply-To: <Z1MwuSh6jc94cem0@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Dec 2024 08:09:34 +0000
Message-ID: <CA+EHjTwSFW5hMFWhkOMBgO1QFq1t0LaGBns_-MnDZkzU6qdfXQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] KVM: arm64: Initialize feature id registers for
 protected VMs
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Dec 2024 at 17:13, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:32 (+0000), Fuad Tabba wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 59fb2f056177..1261da6a2861 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -204,8 +204,7 @@ static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
> >       return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
> >  }
> >
> > -/* Read a sanitized cpufeature ID register by its encoding */
> > -u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > +static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -240,10 +239,25 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >       }
> >  }
> >
> > +/* Read a sanitized cpufeature ID register by its encoding */
> > +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > +{
> > +     return pvm_calc_id_reg(vcpu, id);
> > +}
>
> That wrapper doesn't look particularly useful, perhaps we could drop it?

It does get dropped in the next patch.

Cheers,
/fuad
