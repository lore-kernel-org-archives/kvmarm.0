Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AA69DF2
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 08:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706690985; cv=none; b=h7j/9cXAy7vDQQdC9FJDwd8mEn4IYinT4KLjwehu/+KLWaQ4lhZW7u7IJwoUG5M1HBhE0QXJIuU9EtPWd+ugDgkze5F18+1DhmjCGWdlVsXzNHP8sdIHwBhzLXwtV+6fnGYfBTdHQdmMDjTswmNU6UE/zIASpywGuavxjKZWmkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706690985; c=relaxed/simple;
	bh=cp6hObYP6vO3TLjZQhgbViQN59Nd01J+jfFWB5Rty3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXawtwyaL3g1m3UsP3tlN0RPQ/H/8gWT2XyIkdVN8+Rl4Z2zRQYrosm0sYXJKXM4LfuOXo4dRxexHC5ZHRDxv9571qTTaoYQHvoHbtqxTjLDXh6+L1gE+PhuXYU7+KeOAmdtRgvDpfSotN90WIy8wL31BzJawSZj9xpuGzFpOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QdnxOPQB; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QdnxOPQB"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-55790581457so5997103a12.3
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1706690982; x=1707295782; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwrF8m8GQsGFceTJh31l3SS1YmhpII4/27Snk+jZIFo=;
        b=QdnxOPQB3SSkzFrrheqz0ojxPqCeqXFoECWzBbKylBvzcd8ToRQlZ2MM//o9Uspu/h
         q84+bfraf/VEUpZt5ltgEJmhytTCK1KFuDy8g8Ys1RDq2KoQ+KkUiJ2yRBtraJYBbFa7
         p4dyYIjnzmCW5kZ2YUqv8Faxa/XSJSKtI6sGMVktwpbkbSG+uiXiT9DzZbW6AaVAWtSh
         NG9iniIKVpADgM71bzTOktC1Yk+1Ly3KNkTRW/qfuGaEzTKlmycBy+Ho9ooF8i452bC/
         BrT2ZgumBe9+fLLSLQy9CLy+PjKM5gIFWL0Ub1yM6Rpljt8h4nUGYWqdY9v2BE17iL6S
         vL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706690982; x=1707295782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwrF8m8GQsGFceTJh31l3SS1YmhpII4/27Snk+jZIFo=;
        b=wMsZ07no6UPW/+A8Ud+GpsreCHbMOAJLkCO9whxoMhSF1WgxA5eGkz+uxjLzG9Gjba
         b9CJXzvSjx+K4Bx/98hiUgJ3aUFrtXdnNjkEMmP4yEX4LyCAONdFbCcQ9BhXeBFtmUOr
         Z/gWHztpFUjQmN5V5d+B3Fg+IPg7jlHmlWzju9m7IAbPnWz+s8uGe5CuewE7ALIDaD4S
         k9qSsObdiBoxBi5ry7oUS5YRPQ0hBXj3pbMLrijyirkMg7YzWzidIKjdLrJ0dxjWjeIF
         nwYRZxxCw+civ50cl0zsJmNkfYoTb9BlL8MLv4NPvtQWh23vwUYHt0wzbiyVes0as53w
         bEdQ==
X-Gm-Message-State: AOJu0Yya60cPRSiELikeSpIRIVIKSLdatgOkJ4q1h/OT8NxDfnmpU0E1
	n76k9gbk6EgPblgZlYHvoy47TaF6RXIL7QCUUC1GpcGtRmgi52u9pgDXV1vcxec=
X-Google-Smtp-Source: AGHT+IG59LQFPP5uvyfMTy1OF+ECx5mfRwwnUh01lCUMG3TenERfKODeoOZBRnXKky/WMQTQPIKPwA==
X-Received: by 2002:a17:906:48ca:b0:a35:1f1a:ca50 with SMTP id d10-20020a17090648ca00b00a351f1aca50mr647395ejt.11.1706690982080;
        Wed, 31 Jan 2024 00:49:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c2-20020a170906170200b00a33604d2a41sm5953449eje.132.2024.01.31.00.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 00:49:41 -0800 (PST)
Date: Wed, 31 Jan 2024 09:49:40 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Subject: Re: Re: [PATCH 5/5] KVM: selftests: x86_64: Remove redundant newlines
Message-ID: <20240131-aaad2df64c2f26b892623006@orel>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
 <20231206170241.82801-12-ajones@ventanamicro.com>
 <ZblbcUloeMqc-lR0@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZblbcUloeMqc-lR0@google.com>

On Tue, Jan 30, 2024 at 12:26:25PM -0800, Sean Christopherson wrote:
> On Wed, Dec 06, 2023, Andrew Jones wrote:
> > @@ -162,7 +162,7 @@ static void check_clocksource(void)
> >  		goto out;
> >  	}
> >  
> > -	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> > +	TEST_ASSERT(!strncmp(clk_name, "tsc", st.st_size),
> 
> This newline is functionally necessary.  It's in the strncmp() (*#$@ sysfs appends
> newlines to everything), not the TEST_ASSERT message.  I'll give you a pass and
> fixup when applying since I'm guessing you don't have x86 hardware ;-)

Thanks for the fixup!

> 
> I double checked the other arch patches and didn't see anything sneaky like this.

And for the double check!

drew
