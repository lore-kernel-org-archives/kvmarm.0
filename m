Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3AF2DCBEC
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170873; cv=none; b=Snb5FEk6rYtuBxi2nXZZ8vZ2tPfJ+GZBfG0mo6lHG42x5NGxy1Xf850PncGrSNhfu1hSKIKTwNIH2VL1UqmlL8eYnrFrLAVBXvo0t5VqxbbS/jx5OMca6nl9PmU2JqkVIkH0nYwY8f0rCsxxDslioUJA1RXKsapNdPSGwFGEYLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170873; c=relaxed/simple;
	bh=qrrNz70FFr4gK34AJyCd9eOVfmuimB0x+lUYBwlFvF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzyugFRTy9HzTOtbLQVb5wymA4KkDm+HFlis7OEUxYfOMpkkhcVAJV2SetAr57e++Bt9bPdWLxJ9jV2GxEyqLWOKSXOzD0YV+kGEdcACgRaMt1GlmdK6UXCvtlIfnoTIq/LPaTDP1eqy0zgXYma9Q3TrdZvFB+Hn89w2jq5pDn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zohvO0sx; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zohvO0sx"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so16103345e9.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 04:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769170869; x=1769775669; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8vx9GwQUjLh0uv6iY/ZSwwZRSPo2xMq3kygdhRNHoE=;
        b=zohvO0sxxowDlgsywsFjhKJUK4j89iz+oj3Ks9Tu60pnp5CXqeHyhBo3O0gGhoAfO1
         rwOJG9orNPdcmeyJ+YYTw6cTjOUGaFQBRNHg/0dvCDz+IJdvPAZxfCav8s55T2aVDHRr
         vrRd7wSfZEC9SqYlE9csWa75+SzA764UO8Y6maGExwGK7hQzHxLs6BGo2Of2cXQ8YPee
         1BKHb6dcaGP3rOTbyKiBtMrZfHKmeqJfsJCXW4Bs1cLx//Mx5j8PkwNQuxUjzMrY/4vK
         qlbotIcnU5wgFA2TMl1t2ch9Df9idZF3lUCQ3EkJTKtLlec0MYy4Dvw6xMbx0IfDnAu7
         s1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769170869; x=1769775669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u8vx9GwQUjLh0uv6iY/ZSwwZRSPo2xMq3kygdhRNHoE=;
        b=rEKwsmJ3YLnf2Yonoa6Ebh8N9h49+NS95D/u2QNXl34KJXUyVUkz6VAWU0jiECYzOh
         6ES2i/WYE1fD4KcaNGcL2XoXLVhqRgzIS9UXNOaojqqpxunbCHu9rmvWHZlZ/WCu4i3W
         9wu40DxN7qIH2U3JublXuOdgTS6QSQDYly6Dnd7o2AEpRNN7ruEOPsiBVzI1v2A2T6bh
         zGN4vkYTsvGko7wUHsXKzOmgHRyV/e2AY8D+2R/WIpBqmaLA17Kloe0iL049gbT4LT23
         Fw8ub+0j3bk2RUSrzsoEFja0q+7uHWcX1JbgwEskxNtN5xEFKhIw75oV6JsbojVdDZfx
         4CPg==
X-Forwarded-Encrypted: i=1; AJvYcCWGPip2V7YYCjG2ttZMbqkNjaUx8ZyWZgY3zfDR5d2Qv25SAkcyeC1RTIvNEG7SV0kHbEK6PRI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKmPGMY+cVQ8ckBU1GZniftFfMK+gW7I8LifniAVxoOAHN7rlO
	s8+wezQ3s6dnYjYQE+PV/6ZkyG7gOew9TDnCHeSdT2sx3n48CMoNW+1TcU364sy5Rg==
X-Gm-Gg: AZuq6aISHlaosDr6lI4+pKA62t503H+lZutr1xFPimPjkjnvHDDNvZ3somKzE/nkE04
	nuo3g+OdD7L2FOdEoyFmN9PHT4UZT8I/ILKpYZLusVKl6soMer3bbDgwmjIa5sZcJoTVCcnwqid
	4Z3vBk7GxnSJ7qsiK2beuW/i2C2byulV78HRIlzpPZF1BeLa2ysEE3VixnXc+wuMgSBJ/jovRJh
	+ONlRxT1gRyaAOr1boxhOqQ5XKKFddc+TOdX2QJEK+DpVQTlZWlfGZtf7qbi6zZ/3B51xizEsbE
	UbBiWg3zQDMionEzV/j1V/IDH6xicSNtvbOY2ScPtRX7kH6zFFEZ1QMGDswdaYD5sTtfT/BRDW/
	LMYWzO7utwaatRylhHJHwbZ5bX4xzEeAsG3B9GZSI7VKQU1iJ5AooI/7Pdq1ZGjzkzg8ayHl3YB
	gROje3p/QLp858923+T6aNziHPi952rvq81vnaa0ZLNdncB7mp1DZL5huw5OAu
X-Received: by 2002:a05:600c:3f0f:b0:479:1348:c614 with SMTP id 5b1f17b1804b1-4804c9c09efmr42530825e9.26.1769170868562;
        Fri, 23 Jan 2026 04:21:08 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804d61f1f8sm22563715e9.5.2026.01.23.04.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 04:21:08 -0800 (PST)
Date: Fri, 23 Jan 2026 12:21:04 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 29/30] KVM: arm64: Add selftest event support to
 nVHE/pKVM hyp
Message-ID: <aXNnsJqqsskXyJu7@google.com>
References: <20251202093623.2337860-1-vdonnefort@google.com>
 <20251202093623.2337860-30-vdonnefort@google.com>
 <868qe9mnx5.wl-maz@kernel.org>
 <aXNmKpHqVw93BegX@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXNmKpHqVw93BegX@google.com>

On Fri, Jan 23, 2026 at 12:14:34PM +0000, Vincent Donnefort wrote:
> On Wed, Jan 07, 2026 at 03:40:22PM +0000, Marc Zyngier wrote:
> > On Tue, 02 Dec 2025 09:36:22 +0000,
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> > > 
> > > Add a selftest event that can be triggered from a `write_event` tracefs
> > > file. This intends to be used by trace remote selftests.
> > > 
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 37c015b54ff6..e2de7ad64938 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -96,6 +96,7 @@ enum __kvm_host_smccc_func {
> > >  	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
> > >  	__KVM_HOST_SMCCC_FUNC___tracing_reset,
> > >  	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
> > > +	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
> > >  };
> > >  
> > >  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> > > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> > > index 268b3cd7a1b2..c276fd28e0bf 100644
> > > --- a/arch/arm64/include/asm/kvm_hypevents.h
> > > +++ b/arch/arm64/include/asm/kvm_hypevents.h
> > > @@ -42,4 +42,15 @@ HYP_EVENT(hyp_exit,
> > >  	),
> > >  	HE_PRINTK("reason=%s", __hyp_enter_exit_reason_str(__entry->reason))
> > >  );
> > > +
> > > +HYP_EVENT(selftest,
> > > +	HE_PROTO(u64 id),
> > > +	HE_STRUCT(
> > > +		he_field(u64, id)
> > > +	),
> > > +	HE_ASSIGN(
> > > +		__entry->id = id;
> > > +	),
> > > +	RE_PRINTK("id=%llu", __entry->id)
> > 
> > Not strictly related to this patch, but I find that the trace itself
> > lacks context. For example:
> > 
> > [001]	  323.847422: hyp_enter reason=hvc
> > [001]	  323.847423: hyp_exit reason=eret_host
> > [001]	  323.847688: hyp_enter reason=hvc
> > [001]	  323.847688: hyp_exit reason=eret_host
> > [001]	  323.847706: hyp_enter reason=hvc
> > [001]	  323.847707: hyp_exit reason=eret_host
> > [001]	  323.847722: hyp_enter reason=hvc
> > [001]	  323.847723: hyp_exit reason=eret_host
> > 
> > That's all fine as long as I'm dealing with a single guest, or even
> > with a single vcpu. Trying to trace multiple guests, or even multiple
> > vcpus makes the whole thing completely unusable, because I have no
> > idea what I'm looking at.
> > 
> > To make this useful, having some context provided by the host really
> > is required.
> 
> I could add to the event header the VM pid related to the currently loaded vCPU
> (if any). I can access it easily with host_kvm->userspace_pid. WDYS?

Or actually directly kvm_vcpu->pid?

> 
> > 
> > Thanks,
> > 
> > 	M.
> > 
> > -- 
> > Without deviation from the norm, progress is not possible.
