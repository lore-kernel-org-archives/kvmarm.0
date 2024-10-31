Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0F1BC094
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404417; cv=none; b=pbcFVLa7dyHFjpUlMveNZH7ODsSeu9V2K0V0hKzf9y1KBvsgsyAmr0zVoe8GAmLW1y0klu0W8atHi4a/W02BVZtlywkN/ZJlwkdxPUCz0k/JPjVdq6UrBbMGJvKFk6X9ebdLmbgbkGQNWFhAlVenouchk+ds/6J67m3uuiJVjm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404417; c=relaxed/simple;
	bh=FroSOV/uD5rdzEaLIMdl9JXIy+2JWa3hTbW339w1cW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VjmVMEjr8UeZ3ovDfdu3408KXZTNao+xplUyl2ZEfr5jjk4sfiIHf1EqpVUl1Z0cYqsKyFaRWPK0OF8clo0cmrwm+4VJllER+koE+e8Bnzi11mwtMmHg8VDTFsZOdRYCuGNU5kQRWGvu72jxM3iAETtyT/XVKh9aTI8RBTsi5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XpjVHDnr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpjVHDnr"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eb0a32fc5aso1166418a12.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404415; x=1731009215; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDryuS3JwdKmtkDt/QNqzIISsjjDc6tSvCEk4zlonUE=;
        b=XpjVHDnr9IPDeD0W+y5idRmyV1H31JkTojqT9tvq5//KH874naK3K7JZYVVWdm8DLf
         3XNMqk59+5XXLNbLLRJ6InO2HeF1Rijx6nMu6W9dOpsBBrev9/Nv+sy3rSuTUqR7kwR6
         rAiEjLMog3DqNzDvaR50Fze4DsSlS2cchzGXx23zsKBh12C/juSk08Haq+9fHT15zWWZ
         56MKl7Jwhx3+tPuoXUSlvLqaevEcpdjj8oO4VskIEyTdYzcZOcuvoA8PbeBue0rsxrM7
         +2xnxSO9AUrq0j2Ltssc1WxrTAzl22oAHjiPGJ1n3D3e4FqLJPT7JQ/feFAKyCywVp6A
         w4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404415; x=1731009215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDryuS3JwdKmtkDt/QNqzIISsjjDc6tSvCEk4zlonUE=;
        b=M7hbY4aLVeXK/AxzZBHN//Edrw4n7KHSGFZuqyY/jw6SJ16xzRixmdEqZ84PhjR3jA
         lvLUW6HdI6r9th2MGpJ/+I3YrMHVHRG5UI7jwusBoAUAhqHsPsokcLJFxiDqNE+DjBMN
         jLB+rcM7xQxTMJMFJptjY06SeIE8YfGm1wtx1mQeb0rNIF8Yr7ez838d+KKlnbEwQdTc
         75B0xKrIeOCFCZzHaB8YR/exxxN66ahsjZWoiaSKdKFYknvd04+muP9ap2AgmACIzDVV
         ftHYHEIE9hNZ90TooNElLMxkLZDpF7RiBbKEn20ZVpoj1Ub5hmJizWEt3fDYCazaY/tV
         BZ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQHKAmJmaSnkgwm45T7ytITinnAkoHU4MIrAdnrSJEWKrhcU3K7daz6adlVFQCSSO74OKORMU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5YvviSR9bOlo5AI1s36qO1vxgGjU8kmJbob6p7Qk18WePMM+V
	IeTlaznnIPCXnmbEEWWoTOI2PpMywi/pTvfEUInkggybfUQcH+B0sKCNgUKlfGNzBjl9ibpDzZE
	VEw==
X-Google-Smtp-Source: AGHT+IEYQskIydQ17rOCvnDIIztIPwEtV42Xo/Yb7l4NrEHNVvMPUaIF0Ogt4/xaQ903hVU90IvPM22EQH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:385c:0:b0:7ea:999a:7930 with SMTP id
 41be03b00d2f7-7edd7b6c7e8mr28419a12.1.1730404414918; Thu, 31 Oct 2024
 12:53:34 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:29 -0700
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039527102.1510350.14562788857137656763.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: Protect vCPU's PID with a rwlock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:01:34 -0700, Sean Christopherson wrote:
> Protect vcpu->pid with a rwlock instead of RCU, so that running a vCPU
> with a different task doesn't require a full RCU synchronization, which
> can introduce a non-trivial amount of jitter, especially on large systems.
> 
> I've had this mini-series sitting around for ~2 years, pretty much as-is.
> I could have sworn past me thought there was a flaw in using a rwlock, and
> so I never posted it, but for the life of me I can't think of any issues.
> 
> [...]

Applied to kvm-x86 generic, with a comment explaining the vcpu->mutex is the
true protector of vcpu->pid.

Oliver, I didn't add the requested lockdep notification, I really want to make
that a separate discussion:

https://lore.kernel.org/all/20241009150455.1057573-7-seanjc@google.com

[1/2] KVM: Return '0' directly when there's no task to yield to
      https://github.com/kvm-x86/linux/commit/6cf9ef23d942
[2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
      https://github.com/kvm-x86/linux/commit/3e7f43188ee2

--
https://github.com/kvm-x86/linux/tree/next
