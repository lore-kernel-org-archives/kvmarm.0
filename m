Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353F513DB88
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157860; cv=none; b=pKl7hQelZ+QDtFcAn+bFXNaXXAUi8A/inQoMEy2Sf6hvAnIwxV/bSiHAuIw+YyJX/rkiH47Ui7ibaq5w+segwMEzCaDCQbhKpewfmNtNuDeasoEBSXyQzHi5LKEZFc2ml/AzpmmTK5zfGiGTm1eqGVjuADhTIuIErViRusx+eKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157860; c=relaxed/simple;
	bh=sqOCBmz0NeGoOmrLe8YUpkiZEdcp2a6gTbuVlBFKGwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fUWFoj3g2cNWQNapvQ+Y21cZ6OdRH0KRy9shmE2SS5D63giJAlY2w+p9lhKNP2ugIZOFTtU7NgZ8627Psq4bP12SJvtQ3weGce6i5YHS9t+nG36s+WhPYk+dd1V1ayZ2j0SOXKELlZ72uzMuO5MXvhdiT9EoSoY1lvZHFszy9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzfDE66U; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzfDE66U"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1ab008280aso2097114276.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726157858; x=1726762658; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CHc8H+AgFlKGz9oROxRBwufdfanAh7CzUD+9HRa3+GA=;
        b=DzfDE66ULygNOa00OL1gg9NpuMDNB9WfOfQB6bcQF1jwf8K4iYV6hqoJFbMfJ3s7cw
         e2/1Htjg4JaXdRElvBkpRmXQw3tAubPniXTCT/IEcRPIrdNNsYZRLbJviJgu7HCPBNeN
         jQ3vsDrRd1EUjMDZOTGQEJjRiyJ+qWff1eg3R3AKn66AyxWemn8R/irOXK1fVRlzovHW
         piAT626zy02XBRfOkN8z2LGWYm6sjRMli3Fnw3Va3k+hPTpnfoSnJ4NnoWAru/reQhPA
         YvuKxCgC31SLg0vIIs5P/kzUYCkjVmlLrxLC/7bJ8fczMCSaeahfJJY5RYQda0sETzew
         VzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157858; x=1726762658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CHc8H+AgFlKGz9oROxRBwufdfanAh7CzUD+9HRa3+GA=;
        b=fG3fEWlLimrpi6bSt8NqTPqqjLZjBaa56+nJyYwg5HTfXl9axNF8UZwTVzQC0cdsE4
         m0OJDGA54VKKpiCbvUPF4MYKnosT2B3XTdyf1TZB1GyNZ6ZlRNNfBU8LuSEZBeUIeBBt
         OGevxCsu9LqStqg6d0lJd0VGUxdzMSp7tSt/qb68ai+M1r788crp4t9JWgf2wy3VTHTj
         y+oX2SGUqn+em9c5OEnnk5dJx5xGoPO34u0uqOD4PVsFRt9AOm9z8wo0tRgS/C6JaxBV
         4WMU2MdxzARJREcQadQu45arZozHdAoroeI4ZTgcYXi9yUWNWl65CxuirZhakvMxJZMc
         t+pg==
X-Forwarded-Encrypted: i=1; AJvYcCX+Hu6W0ZvdYod5iD1fIuOVPSoNg0E1DXDhH0J07UvJI/aJkVnKHidA4uPRFMYeam91foiGi/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVwHaGye5NrWMgB4UFQ4mrr3z0eTedpe7ZjHgjFIKqJJsiRUkJ
	QN+rOn/b5cYlJ++PKd2ji7Xpz5ni78FAw9OrbTvTKOR1gTWohQvOMtX3xJYLoIgRGBVuC4s16CJ
	Gjw==
X-Google-Smtp-Source: AGHT+IEJVscKJvuinHeLuj6Vk0WsuDDxtUgSvi9YqWgJNhdyRuKGPX9aioKoGnIVhZDgsM2BQvZ5JjUQZqU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:86c4:0:b0:e11:5e94:17dc with SMTP id
 3f1490d57ef6-e1d9dbd0464mr4681276.5.1726157858129; Thu, 12 Sep 2024 09:17:38
 -0700 (PDT)
Date: Thu, 12 Sep 2024 09:17:36 -0700
In-Reply-To: <20240912-75f992936cd9878d0e507498@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-5-seanjc@google.com>
 <20240912-75f992936cd9878d0e507498@orel>
Message-ID: <ZuMUIPIu5iRuxLCC@google.com>
Subject: Re: [PATCH v2 04/13] KVM: selftests: Assert that vcpu_{g,s}et_reg()
 won't truncate
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 12, 2024, Andrew Jones wrote:
> On Wed, Sep 11, 2024 at 01:41:49PM GMT, Sean Christopherson wrote:
> > Assert that the the register being read/written by vcpu_{g,s}et_reg() is
> > no larger than a uint64_t, i.e. that a selftest isn't unintentionally
> > truncating the value being read/written.
> > 
> > Ideally, the assert would be done at compile-time, but that would limit
> > the checks to hardcoded accesses and/or require fancier compile-time
> > assertion infrastructure to filter out dynamic usage.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 429a7f003fe3..80230e49e35f 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -683,6 +683,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
> >  	uint64_t val;
> >  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
> >  
> > +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> > +
> >  	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
> >  	return val;
> >  }
> > @@ -690,6 +692,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
> >  {
> >  	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
> >  
> > +	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
> > +
> >  	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> >  }
> >  
> > -- 
> > 2.46.0.598.g6f2099f65c-goog
> >
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Shouldn't patches 3 and 4 come before patch 2 in this series?

Ideally, yes, but for this patch, it gets weird because the output param of
vcpu_reg_get() isn't actually restricted to a 64-bit value prior to patch 2.
E.g. if this patch were merged without that rework, then the assert would be
confusing and arguably flat out wrong.

As for the hack-a-fix, I deliberately ordered it after patch 2 so that it would
be easier for others to (try to) reproduce the bug.  I have no objection to
swapping 2 and 3 in the next version.
