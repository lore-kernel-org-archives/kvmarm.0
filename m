Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CB72046B1
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299474; cv=none; b=rd72fOlWTFhbDiumRzq8jTx0qOzL1PfwE9Us7t7fVPT/ZkcL8cXz2mo+sc2jAeXFgOxobNa6PwO7XV7k8mmQ3SdP5gQH9aEc0XKuGXbptwUiHKCX2ezGSpzaiNmDlPSMsnDekOrUObq+69w7GQ4dYyOohRIV7aSWCpVKxyeeRi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299474; c=relaxed/simple;
	bh=/FZ+fFNm+64U8nsHdUxFHPg8V089nq1ZzC25VJ9QFGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VJqlAkhUYt0Od+CtQXqRfh2PcgNAFgcvBMZZLToDr+REHt+sry66EUxD0ttshPcac9VAA6iuWe2tOtYBIfW11MOP2dAxPrFHQXj6RUJ5Ssi4z2e3qRSqx0FBXAlJwIylKyf1Hp/a1cFCNmUzUxSU+HnYVjyrEFLUzYSnu/Btbww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YUysVN+F; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YUysVN+F"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223d86b4df0so33348185ad.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 14:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741299472; x=1741904272; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fVM2KE3EoOsuu2EWcqC1HC9DuBoPNNqkucuTCqqHCw=;
        b=YUysVN+FXb/GwoBFvqxqK5ThhbqO5rIyOUgMFtTbEhcYWdQYmYtSdrpfdzEQZRsZsL
         2VcwNXZl5mN/DCscWTt3CJNGsADHEctESFcDWbI3EE4DQciZ6MJ1KEJ0nkqQMZnsv8kR
         H5JoJSTv/u8bnUP8ZiTiVmvCFO8iyCSH3d1p4rW000IhFd2nsqpyWTl/eNkjiHMHwNS/
         mFmvhHFPb9qR234hp/R2fN5fSwoQgX1u02PSgzUHaNd+iSV1fce6WkQxlmUWic9UEqNo
         H/uzF6EWepNmUlGGPc2XdRz/9wGcT7DYWRBgA3vdSMOG4vaxOm6p35fWbZ9BbXhvuRe+
         D29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741299472; x=1741904272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fVM2KE3EoOsuu2EWcqC1HC9DuBoPNNqkucuTCqqHCw=;
        b=HprEsaKCa+R8GQxL1MX11nIlODXKMu64Z++GGhgq5z/tLZCGRLvnsrPZqPuCRG2gu/
         8xppLtkkAbtqb8F4TPnMXhsOReVeSd7mJalbRXlG1cPyoXIykS5FGEpAXYD5ABNjGNyx
         TVfl2u3wHVR0duof4Sdq5kcT/siMcKaOzw2hebtC7biyRgHH+cU05mdNTOp+ZriaUUz6
         bV4VG3fz4iuS52cVQfdggkjK9xfw3XsX60cTm5Ix1QquALDnnlJyMP8AjDzXkutJE1ng
         YM/Gk46viIncXOcww3mBxwUnYQuomcYCqDAvxIZVkcJzp7qK1ymn1TlnX6S/lot3wqxk
         Vw4w==
X-Forwarded-Encrypted: i=1; AJvYcCVamBgUnFvf/QUzgNPfGU0v2owB5g65uPKvM5pogEZvmL13SDtQYi3fAAST1G2WcHYYFRUvPjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvdolvK0m0UEwVXa+FZS69JaEOscCtuiXSSadBrv7J+pOXN7Jj
	1Lvlroz6o21IaAODIXXNJXhxZc+Ieup5QhDVX1XwHocuu6/USZswXi8hx7NldLjDHhZahTY91WE
	kBQ==
X-Google-Smtp-Source: AGHT+IHj9hf+RSGnxoRCsNAWfapX74dbG0cv1fVCIplmAgCoqTHkKkEEOlwzNxPnN2S64GQaJbv4Oc/F+lY=
X-Received: from pfjg21.prod.google.com ([2002:a05:6a00:b95:b0:736:415f:3d45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b4a:b0:736:a8db:93b8
 with SMTP id d2e1a72fcca58-736aa9b3970mr1923671b3a.3.1741299471981; Thu, 06
 Mar 2025 14:17:51 -0800 (PST)
Date: Thu, 6 Mar 2025 14:17:50 -0800
In-Reply-To: <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250222014526.2302653-1-seanjc@google.com> <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Message-ID: <Z8ofDmVbhjfLVwQD@google.com>
Subject: Re: [RFC kvm-unit-tests PATCH] lib: Use __ASSEMBLER__ instead of __ASSEMBLY__
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Laurent Vivier <lvivier@redhat.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 06, 2025, Thomas Huth wrote:
> On 22/02/2025 02.45, Sean Christopherson wrote:
> > Convert all non-x86 #ifdefs from __ASSEMBLY__ to __ASSEMBLER__, and remove
> > all manual __ASSEMBLY__ #defines.  __ASSEMBLY_ was inherited blindly from
> > the Linux kernel, and must be manually defined, e.g. through build rules
> > or with the aforementioned explicit #defines in assembly code.
> > 
> > __ASSEMBLER__ on the other hand is automatically defined by the compiler
> > when preprocessing assembly, i.e. doesn't require manually #defines for
> > the code to function correctly.
> > 
> > Ignore x86, as x86 doesn't actually rely on __ASSEMBLY__ at the moment,
> > and is undergoing a parallel cleanup.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Completely untested.  This is essentially a "rage" patch after spending
> > way, way too much time trying to understand why I couldn't include some
> > __ASSEMBLY__ protected headers in x86 assembly files.
> 
> Thanks, applied (after fixing the spot that Andrew mentioned and another one
> that has been merged in between)!
> 
> BTW, do you happen to know why the kernel uses __ASSEMBLY__ and not
> __ASSEMBLER__? Just grown historically, or is there a real reason?

AFAICT, it's purely historical.
