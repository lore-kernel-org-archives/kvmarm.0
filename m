Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4442B733
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 19:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781204940; cv=none; b=cBAhtFflOFCiYeILMk8BaNwRv5Qqkzz8YrUDshsvYRiIyWSTN5OnI0T9y/HSA/aTb4XPIvocZMHH8DPoBxmyViJiGPvMXQMY/QCKNd3uG8WjnLwinCA8EPb3jHaXXbtlB6ZzoCOAoGbBCutZFyeP64BP4rJ2fHvriFUabDlzKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781204940; c=relaxed/simple;
	bh=fhPyyRBuJXO+c1O4aIoSvv3vaX+DNXmCRBVMOMQ54mg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y6MmWbq/H1IcFZFTICdyRrhj62V7228puVNjkHHaIoKxxNBpR9iHfgcNHWG5UwGhR3KgvgX9rdYpnlF/vszRFONOhWZIVc4N9Dy1AtjhbQx9wCFrLVyiq87vvLPsZRQk/Cf0P9jVNt8mcsPBxXjVmgVHfqpaGRdI7JZ3sgyCqws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qou05zrY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qou05zrY"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bfdd99f6b7so2884205ad.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 12:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781204939; x=1781809739; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6cgKILDAticaRzulsJIYH9W464IRS0YMv9PGXESfrWA=;
        b=qou05zrYYjm4XjqruLRYTfBDjJrzngff8fKNhQwhw1labJO6DOUIAGOSUBbbfHjyfN
         N9q8f0v7ul/zzjJRORcgpZKsjNr95VoXimkwcZmFGIXsc2NneauaRLXgg6pX6z7YL+d0
         9aH7hfk7Lh6l2k1fDw1IBxOcnyrhIFK2ghTfbGLdBAQRX93hc6vFRUgc7ggF7Ux98Gb7
         br5rn+9TI65sQjc2/p/dPvxpuid+N+aT5U2+fDv2HDOs/yebESf06qTdhrwbbUSZFeAJ
         5/erna+dCxVlz4iYe/ermfWG56e4f9ZbRnt3d+rFqp9TLHj67yM6ihOTPalPSlo3Jyno
         SLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781204939; x=1781809739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6cgKILDAticaRzulsJIYH9W464IRS0YMv9PGXESfrWA=;
        b=eCuGZcXjQ2aUKsKU2XqFnHHmhTOCUDvHauBY7oAIam9/2KavUDQMDEjpRk0UzMIGR1
         PI42L/u+A27XVQoDI8YcQ+ksgSCPfMx/STgis29w24kd86BtKeshVG7ejwtf3SEg8ijn
         B8B8bvJvbeUZDBbYFMOhwQpks7kgbmRw+oIdd8GbtYWx+I7lKsMopfuI9KKv1SPTb17J
         FbTYVuuZOOMv/8bjJ6T41ustaQkrplx49+cNLf7LNwgjOkQRoeQiCCPVm0fMR9cDckuS
         uG4N1JbVtwRpnZvXprs5Nu4GFcl9eSB3Uiv3a92zKvPZBT+37jgmJJ77KzirUrOA2VjC
         ggrw==
X-Forwarded-Encrypted: i=1; AFNElJ8pNv1SgdMBbOBWDKOkasiWjU9MB3gixpyMJfKv9eroHXCXEmzUIkQJIxiweynaAv3+driBgKw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwUGjOxJqbAKFIvwKiMUMT3tVW29+I2GK62MTtYKZQXeDJhdD7
	gK1GUxtxBLE6wxxmN9+3LdPEKAjLz/BOywm22PWS9eha+6SrwvkQkWduQ+YvxmpsE3Iv892X6Bl
	szSDNVw==
X-Received: from plkn7.prod.google.com ([2002:a17:902:6a87:b0:2bf:10b7:41d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cccd:b0:2c0:c262:b917
 with SMTP id d9443c01a7336-2c2f0059f43mr46929825ad.5.1781204938424; Thu, 11
 Jun 2026 12:08:58 -0700 (PDT)
Date: Thu, 11 Jun 2026 12:08:57 -0700
In-Reply-To: <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
Message-ID: <aisHySKe0PwM5DSg@google.com>
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

On Wed, Jun 10, 2026, Ackerley Tng wrote:
> Vipin Sharma <vipinsh@google.com> writes:
> My (future) use case is that with hugepages, I want to run something
> like
> 
>   ./guest_memfd_test --order=0
>   ./guest_memfd_test --order=9
>   ./guest_memfd_test --order=18
> 
> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
> tested. I'd like to iterate over supported HugeTLB orders at runner
> runtime instead of at build time.

No.  The right way to handle this is to define testcases for the "interesting"
sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.
