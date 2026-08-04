Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0145FFD1
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 17:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866164; cv=none; b=dKgidhNpP/aNcCAgMWr5T4FF593Mai3xiP7kCG4A1LrnWAZALjzhBK20P2VjxCIn3DTmsr7CNg7Tqm6jkFlV60vRSBVQs9ZVYa+MCu5C0oJQSeBI5DW2vLHrRquPE31v1VsPqBKTJx66gIGa6nfd1vtDqJIQxIfe46t8PWzoC6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866164; c=relaxed/simple;
	bh=dLGzC+zLz6I8etI/1JXJDRBgaBzh0MkWAL3seshbA6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFGSa9CURsNCp42vjL2zMI4zs+g7CsSZ8LKZ8VURKpooZeqi/OvRCML8c4n4/UBm8p55izPzSzfuAys8ckU/KJUhdAVh6zrVejs7HTY2i5n1VtmPaEXpd33jm3t7cFp+0QE1INWGVeK/VJ68sHPzrQHsIzlC1XjKfiUSP4GlvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CB2d3TSw; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CB2d3TSw"
X-Forwarded-Encrypted: i=1; AHgh+RoDsfjdkKyGfuAn7+RxhTl7eMQlVym0A2ZwApzRov4U6LiBleMUAi/0sTv6awR2Ct2wWvgtwHE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785866160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/Vf4JqZOlRdkDX86iTvbq09jgwXW+/RtBV9DIZvhmE=;
	b=CB2d3TSw+Qy8niUthFfxGP7miRtC+/yegC4jVyZD7Nx+LRMTFZeyh0AF79DPuUX/5Wj+e3
	dqbwzfabHxMt6oOL2re0mAWjK7Bac9NHsXfJQmQVtQaiLyLEuUewAv6eyIzULObApLZ23Q
	ZPTNMg8Zgehcxz5qHOGQgzm1uVbx1HY=
X-Gm-Message-State: AOJu0YyyqoePywraqD08eXVhdLZ5pXYf9jA3h/CmzS6eLQVqhoVeGlqV
	E5bUZS2JcRgDDhQJSJk0XVwalauObeSyDDRkWAiUBdd234so8+LAFU0e+PCiKArLh1tM03S+VBx
	xdKInKftGYwbu+GyeS3YrKcI22qcDUMkIgbCCurK3
X-Received: by 2002:ac8:6903:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52ce6b25dcamr686141cf.10.1785866120314; Tue, 04 Aug 2026
 10:55:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260804092421.1728880-1-fuad.tabba@linux.dev> <599f665d-7474-4f17-a044-cc92b03d02aa@sirena.org.uk>
In-Reply-To: <599f665d-7474-4f17-a044-cc92b03d02aa@sirena.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 18:54:43 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzHSJnZ7YpJCVCvsHrvS0WtFmOEHUPST_+A9_0i7MXkow@mail.gmail.com>
X-Gm-Features: AUfX_mw54sYeUiJsXvDxqF1B0irs3Zmjh1gV7CnF488RmUDI8wbKkK8_cW6kwgw
Message-ID: <CA+EHjTzHSJnZ7YpJCVCvsHrvS0WtFmOEHUPST_+A9_0i7MXkow@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Check ID regs are immutable after
 a failed run
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 4 Aug 2026 at 17:14, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Aug 04, 2026 at 10:24:21AM +0100, Fuad Tabba wrote:
> > Add a set_id_regs case covering ID register immutability when a vCPU's
> > first KVM_RUN fails after finalization but before
> > KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
> > a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
> > KVM_SET_ONE_REG on an ID register and KVM_CREATE_DEVICE for a vGIC are
> > both rejected with -EBUSY.
>
> > +     for (int i = 0; i < ARRAY_SIZE(test_regs) && !found; i++) {
> > +             const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
> > +
> > +             reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
> > +             val = vcpu_get_reg(vcpu, reg);
>
> If we're doing a focused test for the specific issue there's the VM ID
> registers as well as the general ID registers and adding an irqchip.

Sure, I'll expand it and send something out tomorrow.

Cheers,
/fuad
