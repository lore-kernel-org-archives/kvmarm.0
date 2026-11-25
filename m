Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795599164;
	b=TTiDB3zAJYhW1C0Fh64cfwysO6/Np/R2lldgWliIK87I1w1hqHOo3UIIYDcg4bbv/mxy
	 yl5LowiN7DiBuetsaDcA20qIO3Yh8UpLiONwLSXgXqgTTSlSRu/FFuVZOEJK5r9ZxBiLG
	 ExrwRt7E0O/UIC1Ti8WK5dWO6rUyIsCiZLRUridzJ7vYb3OQiWhoeC8jFcp6xt3pdCaUz
	 sU2avpWyyhu++pZoXTFdnYAh6bSMwwTJ6BjyYkZGZSs53gGMHgl/bSgjzDEgSV7w+K8Xi
	 ZWoQ9d0tHWN5YSLs4mqlfYqmtR8oaFnISefEUSFZTZX504PTVM0jJ5xhlAYXZhOxzUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795599164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=vz6xI/WxixrEpdd3ywwOb3jpy1gOGMCFJ8JE8A5AwCg=;
	b=ZCJH+kOqEHDYgQnpiJlHZbNdZ7R2DX8alV0f7GAQ8y7OQAyBTW6o7eZ7Ui8qj9mOlrTe
	 6ZtOmDV1B49QYlz7Us0HHqhfU65ZczXa0/uXUJmht+tVXOWqVczhfNnWHuLHxpjaKd+J7
	 /ktCVVIMYm1iqYL5RfQlUpi656MioIQ6K5b9Y8UHbGSfXy2KLkF/9DlPAQrksa14wtXOB
	 lbdkZXotqmRsgIS+xWA7G2rdUTUWVxbI2Ap3Y5/ZMHDnLytbCV71MN3wOSqbBNu1lHsGE
	 fq56Jls3JuWoW9CYt5kx4OqBMPIVJ5JqmKTCv5MlcGEULg7NqohC0JL5xWUyrQehbuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=OIX8W9c0;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C2606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D17C2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=OIX8W9c0
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso43544755e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 01:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795599162; x=1796203962; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vz6xI/WxixrEpdd3ywwOb3jpy1gOGMCFJ8JE8A5AwCg=;
        b=OIX8W9c0sBFlwjgYgiKiH9TAEqcdOr2TicMrKQ1b595YrvFoqUfnaFvWEvJaFhQTnj
         H0SsRJynKOovG1qfwaTMeOJK/cPYKUldgdtDlFwxqfySYdA67twyumpa2+0jl10sb0In
         KmP71qrg/QPKT+UpWexeY17iyH2oU60zpv1r8kCLLPc9gPX1n2dO+q5FfshLvbcIcxQX
         nrh+2Jo6pu91kXVJt1ayJROqdtTfCbPl4dUsGcqIm5/zWPEDSriqBL+Kt+bCzo1r9c3f
         FacElrXGK8hV/a6UAH9G26HyijbNW5zPvQDoFWYxltpR+FS43xC08GVCNF8N3LXx/f6G
         ZmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795599162; x=1796203962;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vz6xI/WxixrEpdd3ywwOb3jpy1gOGMCFJ8JE8A5AwCg=;
        b=pMmx1Q/64i/TUQyxyMRFvXU5ScviwH042EymB7Xx2KnWNXsKphVxKtfWewl2mh3UNr
         UeKiJN61FkrA1zIaqEdTKFyjqcI/7NOvK62tiseDFpTE7bRRb0KATBGIxWwJBeufHPKG
         A1gIgcb1gRV4OGzxwj0G5Sg16gubeQRF1tLuKHdefLvzrsyY+EvwDAcD/vlVmoO9zRH1
         EkQt6Ai7r2bbTAxovJeUCl7H20RVhpzpaozQ4XiQaMwsBd6WO8vTIObn4y5IWBK/wmyf
         F7fr3GzCoR+xIBuAlHTIyBm0okXw3tUb/wBJThvbRV0leyEO9a5TBmBL17hVGqlpgIzE
         YMJQ==
X-Forwarded-Encrypted: i=1; AL+hErHGJRK93z9EjrenKXVejFt3PN9DvqxNENPUh4qG+c4Ar8lqZfCGYBu8PA+7rOQvzhZ3WBbOypo=@lists.linux.dev
X-Gm-Message-State: APuU4Z/1X2M/M/8NQpIicD5QE7ZfBN0WMS0hYYtnntGQHI2Z3MC0VvAN
	Dug60yl6tuPotNstz9qXsgtvGpPwnXNXFwtmCzR4e9fUr7URb+Nj4NvYN+aZa1/7TMA=
X-Gm-Gg: AZFdTZeg5Mdb6PW3aJv1oxUIF/crW12MKnkqULBMQRrX0DQ981DvxJuLyE94LlwKzbX
	GAFUcNKNAmqWqxYYmUkaMiTbTeeml8UYIGbGsPVoHHRXh4Lli1MGw3u0m4qLAR8+6nR9QbSnZf0
	oSLEQAzmbjIqW1drm8Le7VpRwfGkdZ7GSXhhA113FMADcq8PujKocc2UHqtASzjqo6LtCIRB/JV
	BIDuzmWdsGqSeROPm0oYdov2JgZG8SjP1qs8iIwR1ZhgQL8WNTSWYVf2rbfZ9+V5fSkJrgfkqXe
	Fa2Vl/6O14x6tWiIOVJzfcoLv5F/NhIIkTUiTupffcWo35nJbSYqgbrX2khxZ829p5v+MWAmlE7
	+2WDcRyjRzmTMhUrsq9pvfajODQub7RQwTaJvqiMQYHJsMiz76q7HFgIJFsHG+Q4WE/+SUYWPi5
	btQNHOeOZznO4bQ45HDpX3CE/F3Kp0WDx/zK8nOc6USqOUMdMP9gxeulbCedeoDh74f7FYmzXxB
	GQVbvHN8IJ93MHHlKqR09KnCyr4WiFeo70y0YvLyWMR9CBwdfL1gAG0g//HgeHIOdTf8mcoW72b
	rK/GWmWlW7VJ3Zv2sfs=
X-Received: by 2002:a05:600c:1c28:b0:4bb:867b:f0f0 with SMTP id 5b1f17b1804b1-4bb88810708mr406437605e9.15.1795599162309;
        Wed, 25 Nov 2026 01:32:42 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bba6a0d65fsm32122755e9.3.2026.11.25.01.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:32:41 -0800 (PST)
Date: Wed, 25 Nov 2026 12:32:38 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <c.dall@virtualopensystems.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
Message-ID: <awarNqNt6Kec5G0M@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
 <0c7c59df-69cd-40fe-830f-60c0f3cedafa@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c7c59df-69cd-40fe-830f-60c0f3cedafa@arm.com>

On Wed, Nov 25, 2026 at 09:08:36AM +0000, Suzuki K Poulose wrote:
> On 25/11/2026 06:56, Dan Carpenter wrote:
> > Resetting a vcpu keeps the old values of SP_EL1, ELR_EL1 and SPSR_EL1.
> > Commit e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> > changed the reset to only clear the general purpose registers, SP, PC
> > and PSTATE, and later commits moved these three registers to the system
> > register array without a reset value.  Commit 85d703746154 ("KVM: arm64:
> > Fully zero the vcpu state on reset") fixed the FP registers and the
> > 32-bit SPSRs the same commit missed, but not these three.
> > 
> > The impact is that the guest that boots next can read the previous
> > kernel's stack pointer and exception return address.  KVM_GET_ONE_REG
> > also returns the old values to userspace, and a rebooted VM doesn't
> > start in the same state as a new one.
> > 
> > Zero them in kvm_reset_vcpu().
> > 
> > Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dan Carpenter <dan@pereq.eu>
> > ---
> >   arch/arm64/kvm/reset.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 26081d273408..9c1b42890c96 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -199,6 +199,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >   	/* Reset core registers */
> >   	kvm_reset_vcpu_core(vcpu);
> > +	__vcpu_assign_sys_reg(vcpu, SP_EL1, 0);
> > +	__vcpu_assign_sys_reg(vcpu, ELR_EL1, 0);
> > +	__vcpu_assign_sys_reg(vcpu, SPSR_EL1, 0);
> 
> nit: Please could we move these into kvm_reset_vcpu_core() where we
> reset other registers ?

Will do, thanks!

regards,
dan carpenter

