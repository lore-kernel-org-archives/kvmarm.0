Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC93043CE
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781226432; cv=none; b=gimW+MLQYmmOoqeKb+h2W1iRbm2N7flh9oPXoSfiz7ibQNPD0DFJKfHjs5cksF7ZtKs0VsV3BuLm9kHSyMsDULwti89Qh+vZ9ALsd0iR+/wqfQYfXcR63+Npc1Yf9GWA9WAcnY5SDRaUw2H0oha+tQSVOhfNZbXOS0Akj33DJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781226432; c=relaxed/simple;
	bh=EIdxZ9tCemDGSxRT7l/259cIzPqZovEd7qIl+4+bbZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MeBMfhe+lEzAH6SDPeqnNJrgxAy7ATS7FxNrHnesNSL2uSBa4BKpeY7mHW/wtgqR85R9p+eHi68ocbGFg1B+OjoQSICjinVhOKuzl7UqAEf8Jir4qLmasOrRRrgtombto+5WkZeWUbIhHFf6OszCI7ZxvcYBLrwkSIubAPYSzK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K9xSO6XP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K9xSO6XP"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8581f7723aso203504a12.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 18:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781226430; x=1781831230; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ltYTnUEFnoWpppzAgPG27GJdcRnPuw2iznLkjvKvVEY=;
        b=K9xSO6XPJml0ssNAyHhNPUMYp3HUEY5eRi8kgJYoit3d//it980kLyhZHhoPqYsJ4L
         19ROGmdS0gbC4WhaFcbvlBOqjtC7ph60FnnUDN1Sf9uC5gL7hIWuwi/A4s+0OENaKmt6
         Eo4KGPp1wjxlHijMx/4s8Sxr0KAJ1/quuTz+vXwQ/VeOkuabXh2GFP7C6F2y9mdhYK0Y
         eLoFT3HNBQjDfRvaSDDPxqj4askoF9m8kcox5KO1lbHVGXGztkc48GK/l3wliw7u3nH2
         aE6o0sGUVUt0w3OaHHqKi8GvzTzjNhOfOXPtpNxCIdpafuXZ4d30zocf5JlTdqZH6UmQ
         YuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781226430; x=1781831230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ltYTnUEFnoWpppzAgPG27GJdcRnPuw2iznLkjvKvVEY=;
        b=HaaYupfvBILU19ViXkS5oXfFJIDF42D06JqHq80yQZS2CDcJFOZ1SAwzSM7xQR/jaf
         AVwKUZugnNghlTuHD6xymX/AeIxOtRcEXnHMkswRrNs7rOCtCxW5mklUdoLF3m7IN8vy
         Y154j/J5CSyWpzT/eMnoGZlrkCXf6F7nrtJo8M4NMAbvXGn+2YtKrFhbWLsHvzQEl/l0
         Nk+vSFH7ts/kE+auEGnVxOl6LtHcqPzmN+e6lCpHuTAQ5t1GT6hwSW9qO/E3RXU6tylx
         yj02R/84Ermr0hxBQLFxXnpoA4aXHdLFPWh/22Uj8AytG+V9qdhIQEfsw4mzJ7vxRvYM
         LGPA==
X-Forwarded-Encrypted: i=1; AFNElJ/UrVZAuJ5zXtdaAHljBf0ga40iOGzK72Bld6U/2ku0AUDQ/YDB6zVMxTnLyl3Ido0Xnp40pUc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjDMt11OQKUAl3sTVjmmNWjZlw7sfQQLfTh/Z/e/JKQPmh9lCA
	KsfOliLvvRJWKDee0zIJRNAi+1EuGg3qf1mb3nMDRkWdIoq+0z7Yopxkh98LjJFse39qD3uBvSg
	J2HC2sg==
X-Received: from pgam22.prod.google.com ([2002:a05:6a02:2b56:b0:c82:7761:9941])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d8f:b0:3b4:6cae:4a51
 with SMTP id adf61e73a8af0-3b783b5ffdcmr817576637.11.1781226429893; Thu, 11
 Jun 2026 18:07:09 -0700 (PDT)
Date: Thu, 11 Jun 2026 18:07:09 -0700
In-Reply-To: <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
 <aisHySKe0PwM5DSg@google.com> <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
Message-ID: <aitbveI2Sdx4s4BP@google.com>
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 11, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Jun 10, 2026, Ackerley Tng wrote:
> >> Vipin Sharma <vipinsh@google.com> writes:
> >> My (future) use case is that with hugepages, I want to run something
> >> like
> >>
> >>   ./guest_memfd_test --order=0
> >>   ./guest_memfd_test --order=9
> >>   ./guest_memfd_test --order=18
> >>
> >> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
> >> tested. I'd like to iterate over supported HugeTLB orders at runner
> >> runtime instead of at build time.
> >
> > No.  The right way to handle this is to define testcases for the "interesting"
> > sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
> > is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.
> 
> That should work too. So at build time I'd make it define all the
> possible HugeTLB sizes on every arch, and then skip as necessary.

Not necessarily at "build time", the testcases can also come from your local
environment.

> Why though, why not find the supported sizes at runtime?

You can find the supported sizes at runtime, just not in the test runner.  I want
the runner itself to be largely oblivious to what's its running.  Disallowing
more or less _any_ test specific configuration/setup in the runner is the only
way I see of keeping the runner strictly focused on running tests/testcases.

