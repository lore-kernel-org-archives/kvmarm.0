Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3801A2C2B
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148984; cv=none; b=LaIzkDqAH97kwmoLkrwpA930bBLtMG8UIMD1WyUY3f8tr72ThrdxXfvmLiqiHDXcsEBtjl8tx7J/TtrLcwagUcKr7usD/nNB7TKGwOYhs2Kn6j0YFwEOT6Rl5c2nR3mXWZc6/PZ8ZxwACdcjUU5wsSHKm71WP3AwvvKlDmbFcXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148984; c=relaxed/simple;
	bh=TK63ZITwXiK1tpwBleYE7XvV84aecTotysnL7Q6Y+UI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ho7ijDtjXvR9VvrEVLsW/DLDn7HbcD/PHYLt7gDjnFzXG3QbsLlhem4cZkW65W+mxcrFcdB25NKwKZSg1y6RXcdl/pp2Bxw3kzoDEgdUEXJ00hHbX3sNHFgPUAUWR5uMk9uGeTSwz1NE5y7Hwyz3Ya1mNCSSAYVWm+wDyB+kVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CtKTGDcl; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtKTGDcl"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d6bb05f2e9so16964687b3.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 06:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726148982; x=1726753782; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XqdrXm4ZcBhMxArHEVqbh0H8bhyUvIJvDn8m8Oi5KOY=;
        b=CtKTGDclj4K5pSWhHsPcRO8HH/glHpVf/xEZvFJXLh1nv8Zw0vX0oHcta6wPy8o64W
         4XCiLju+WCvQE6sTMGdKpTxpyFu4AcRSZQ7IgfnYl+Imy80GdexX0f8tNnBxXyBtTxW1
         OopRr/vuj4tmYMcSIEgRCaDi1BmzOwF1bhULWpqJoF1tx5cQckb3ajEZf8hejiTueLCP
         CrbnOO19ja946k0vgZn4NA/o2y9Jg9HkKud26YCKLDqijTizz5jj8YrsnDsQ3CsXUn51
         KhxVTKDEgbdHdLQa+jwNCyKyEir7MD+6H0D6gRCi0BcdFh261azddVev4PDboS4P8hDE
         yhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726148982; x=1726753782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqdrXm4ZcBhMxArHEVqbh0H8bhyUvIJvDn8m8Oi5KOY=;
        b=MkkJQRvsTiRiEJ/PUgmrd9iEOH6tvVP0ED1UUKSQhWB5Nn9vX2Q1hk3k0Tz0CwUqR8
         ATgv8loZUGGDOSfcORN4wNqj9Sff12IYRS8xLNDgfwQFsbl5uRXsILOXPwFE4a70h/gl
         OGt8Ty/grtFOTeCHlGt/x3dN4NDkOAQT583mPbhShjwSoxWFGNHGyHFWOMylg1phXJQB
         l9Wt/P5N10KOBiscJ0PXIfQjiJdrirpMJ+BF6PPWyqx10el1c8m2CnpdlTMU1VWTEOzu
         seMQibEh8utkdbcIP4LW0uf3d16FytzxQQp15wpzPDpD+THqcBrJpuJaYOZMMWpv/V+M
         F/wg==
X-Forwarded-Encrypted: i=1; AJvYcCXZn3DjD8qCEckO6NDbbYPfzZ8eV33lfrKBqv2IfguhwR8i9E3wIcZGkgq+rg9mVLT38y+cG0Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxp0Sc1wsXOFB3A3REsWrLIuVPVO52YiHiC6L9B7ddRv6nZZV9b
	QAoQcMfnl7LWEAKGFyQBvkMeN7IxoDnrmpQvt3YHcxvvr/dV59N+GqEq4pquBlhKNzUDdhSL1NY
	Obg==
X-Google-Smtp-Source: AGHT+IERWDyZH0lw1THIMdF1ZNEMNfNEpIHjvdgU0tin44x4h90whZRVuXvE3+8fuo4JVbUfWmxTfJ+4tEs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:50c:b0:e1d:a616:602 with SMTP id
 3f1490d57ef6-e1da6160834mr2247276.7.1726148982380; Thu, 12 Sep 2024 06:49:42
 -0700 (PDT)
Date: Thu, 12 Sep 2024 06:49:40 -0700
In-Reply-To: <20240912-a3894135370bf3fe551ed018@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-3-seanjc@google.com>
 <20240912-a3894135370bf3fe551ed018@orel>
Message-ID: <ZuLxIjMT4QzrUaad@google.com>
Subject: Re: [PATCH v2 02/13] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
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
> On Wed, Sep 11, 2024 at 01:41:47PM GMT, Sean Christopherson wrote:
> > Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> > a pointer to storage, as none of the KVM_GET_ONE_REG usage in KVM selftests
> 
> "none of the vcpu_get_reg() usage"
> 
> (There is KVM_GET_ONE_REG usage accessing larger registers, but those are
>  done through __vcpu_get_reg(). See get-reg-list.c)

Doh, right, which was also part of my reasoning for making the conversion (tests
can use __vcpu_get_reg() if they need to get a larger register).
