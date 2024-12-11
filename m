Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B561C4A20
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 22:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954776; cv=none; b=fPW28fzdkyIND6wk1Hy/jODonK8qmiHtD2AI0USOIAzWuZ8Bz16kd9LtpAEpXVib2wF4XGN15c8UgTVG87MRXyvapQdhSwoJOdKDHMV10Wsq7uB+6WhiWwk+Le+W3GsCrUgKcJpkHAtM/6Vegi8dZJ6SLTrVqe+bwGhP7ZguHJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954776; c=relaxed/simple;
	bh=dc04m6m7A0zBx/3GsGuHlwEymHutsumTTMAD3LQrhZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dac8iXWEmwInW7lS2wf6H/5hDEY8WdKF6na2q7SJDRxsgRNI6xMqO8beaYTWEc+d/7DOvJ37/+C1L1IJwZmcp4Qt7LWC3aV7kq+jkGywiAR5RmK/howkOBUoJPwUYtL2CllI2otQ4DRJEPJLFWtvKQqUHctlihVOU87L0NA2iuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uEGbk+d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uEGbk+d"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21681a2c0d5so16172045ad.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 14:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733954774; x=1734559574; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTDUEy5ndzyMUOmAANu+2Q5dKv5CytQeXy0bYdZM4AE=;
        b=2uEGbk+dRjnCYmAx7b3BrqsQYGdcqv4WrdTQr4a/Fhhfj0fPF21G7SAmFZWa9RcJYh
         VTGnoakAT+eR+W164dqd0Cp+9znfg8Rdt+F3hO5yAym+8cp3xEUDoHPxTQ2fllamdvyO
         OU/oWjGFyPx9wShbApeLrjZPw3KDG+a68JMR3wwG28G58L15YKlaRgG9G8SrPjxOx8hy
         uSzcxaS/VYJM9nIokK+/4OodauVzFbPJVgOdzPpP8J6S0HkhkLiVMgcU++OPs2a/vEoI
         JKtaMJjWfVQ4OI94xawP0NL9Y61XzSe6b5X0ZXWeRqDo0IJrwsawpcXou9hui3WXeFAs
         Mybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733954774; x=1734559574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTDUEy5ndzyMUOmAANu+2Q5dKv5CytQeXy0bYdZM4AE=;
        b=k/L4FSVByE3pTAoxaOjVt/uBU7xp3mGmB3+gvJg1IxIXBP5rNi3Ypy3Wc/yMZ4m5Xt
         f5sQx9Hx02uCAVAm3RO9VNOr36tvSPa8+Skth0/ABscX4MHcSkTzdOKLapm+buEI61xs
         CERq75s06JawmQ4yxVushuWJl2JiYpQ/tLCVw+kQstbO+KSYvP5gbAPKsvxaKo1dCn1k
         QwfoOOV2q06k9Te3qk3IVTPkmfFVzTudDFli8Pnw0DSgjyLLKlPn155zbv2wT/oEwz8e
         LEZptSIarWY/t1CeYui5OJBEBdfVf7iRp1TKAgpbrVcBnB5sDplfwGt82Pzn1MqYFhpO
         L99A==
X-Forwarded-Encrypted: i=1; AJvYcCUdM6Tk+fsTDc/DW1X8JDFgr8vRljfQSY90Oq2RErfz7P0kFxnNS23Rsa7n6UIN8d08s+ZKxaI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWHkRfnkPJcV36e5ckS2Hxom/D08sJuC4T+xjVwsS+dvYAxEo3
	to4jORHzAQUUhqJyly0RKrYL5hVjwziV5I+IIVH6s6Cs1kMG8ms2RissB7/okn0EqA9Re5jQ/NI
	Bbg==
X-Google-Smtp-Source: AGHT+IHFSnyjPEDTcWJnAvaiGma2JfY/srzHSvKplMJ9OueXQOEiKTtjMmaF+b36NOyPghd7X0ZdCPZjbkA=
X-Received: from plgn1.prod.google.com ([2002:a17:902:f601:b0:216:499e:dadb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db04:b0:215:44fe:163e
 with SMTP id d9443c01a7336-21778397514mr77377935ad.1.1733954774653; Wed, 11
 Dec 2024 14:06:14 -0800 (PST)
Date: Wed, 11 Dec 2024 14:06:12 -0800
In-Reply-To: <20240910152207.38974-15-nikwip@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240910152207.38974-1-nikwip@amazon.de> <20240910152207.38974-15-nikwip@amazon.de>
Message-ID: <Z1oM1HQqXrIr1tij@google.com>
Subject: Re: [PATCH 14/15] KVM: x86: Implement KVM_TRANSLATE2
From: Sean Christopherson <seanjc@google.com>
To: Nikolas Wipper <nikwip@amazon.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Nicolas Saenz Julienne <nsaenz@amazon.com>, Alexander Graf <graf@amazon.de>, James Gowans <jgowans@amazon.com>, 
	nh-open-source@amazon.com, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Nikolas Wipper wrote:
> +int kvm_arch_vcpu_ioctl_translate2(struct kvm_vcpu *vcpu,
> +				    struct kvm_translation2 *tr)
> +{
> +	int idx, set_bit_mode = 0, access = 0;
> +	struct x86_exception exception = { };
> +	gva_t vaddr = tr->linear_address;
> +	u16 status = 0;
> +	gpa_t gpa;
> +
> +	if (tr->flags & KVM_TRANSLATE_FLAGS_SET_ACCESSED)
> +		set_bit_mode |= PWALK_SET_ACCESSED;
> +	if (tr->flags & KVM_TRANSLATE_FLAGS_SET_DIRTY)
> +		set_bit_mode |= PWALK_SET_DIRTY;
> +	if (tr->flags & KVM_TRANSLATE_FLAGS_FORCE_SET_ACCESSED)
> +		set_bit_mode |= PWALK_FORCE_SET_ACCESSED;
> +
> +	if (tr->access & KVM_TRANSLATE_ACCESS_WRITE)
> +		access |= PFERR_WRITE_MASK;
> +	if (tr->access & KVM_TRANSLATE_ACCESS_USER)
> +		access |= PFERR_USER_MASK;
> +	if (tr->access & KVM_TRANSLATE_ACCESS_EXEC)
> +		access |= PFERR_FETCH_MASK;

WRITE and FETCH accesses need to be mutually exclusive.
