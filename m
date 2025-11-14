Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EB2DAFAE
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144756; cv=none; b=m0Ism/HVGmNL8yzJQiOEAd7WjmX/EP9qH2r+YL2JuqVrksefQvtU2Sp8Cat9axI2Xdnzc4borg7iqlT6TuKRRdWoOot325m76U3Aa5wkwIldFxHr610OE7jclW1AcxsDkE3PQBPv24ilyaiqV8xIwWJX63c0gSUWiDobso/qLAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144756; c=relaxed/simple;
	bh=TyDm6Trk2TRmYtcoRtnafyvYid4VPbQoPvuDmcSverI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RFWfk0vIrpNHUZF3qh+FlDiRwL+cMZpAt3fYxB1WDL9w7SobfBIWFoupfxS8Tgtq6udI0jgLXtsMM601N83xZespTLPT6/EGwZL6m/dyTkwR8WsdzMoSNuuNA3VrrLG3Xy3ntO7JW1JiarUYIzuk4ODGZrYUFgWilOg7zQkR7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cAxGrXhV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cAxGrXhV"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f11bso3241888a91.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 10:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763144754; x=1763749554; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CkxnX60eCRTyJOeHwP1COZ+iHv5clr9FGEnLCxZG7aE=;
        b=cAxGrXhVeHFVPfqnQsKoiv3nx2ZptmPS7G4uvuxWf2hmmzFDwSWWge51yogPzy5DTr
         2O5vD88aPpTGIuFy7H5HTMLmG0Y2BNkK88bhoEKV/ZnyYOLq8wADOK6g8FpvBH5PrQON
         5IvCVsQRGWiH0/9oNHnb0z8hTCp3Kd+pukQsXjK7gDTMvMRF1vSpKwCnG9Akru60Fc4l
         63iLgmsDb60pkgNiKHwRetJ3F/sFYvV1Gm0ydB+PhnSkuTVOMN/HdWhTrG3mcU+Le8hW
         UOuURDEgkxwXhLeiYIz0j0YZFohd5+fK5Mx4m5AGKiiwwspNVbNTE6QaF5uOE/gFwvht
         nzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763144754; x=1763749554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkxnX60eCRTyJOeHwP1COZ+iHv5clr9FGEnLCxZG7aE=;
        b=uNdGGX7KpGH6QtdziI1vBrDmn56FN7Eww7EZxHjQy1NLgfFriCH8lByIyfIuEBxLj7
         6kXxD6/1kOe2V9vu2zByx2bCuZ/AIAMBDIYcpZucNIlKS4mI58Qsbu7PDlyuxuR/B50U
         80moq2Rxw/KtSWOuX5vRmG65RZK829Cg0YJdXdr2KqK+8AwfcIjV2E2hVBfKZ4GPxEXU
         +643yGYAIDAsjrSB08Ie16XLvSKsyYoVhvtS5GoF6LUoqe9ZEAIN6WhqYYpZLQyArJQO
         WIyzKvlvQt9tNmvqaDfyPMA7DQkRD1KK5Ls1fp2ZVKtvKkwvNquWbL+RInTtLf3ChK7D
         Mssw==
X-Forwarded-Encrypted: i=1; AJvYcCV6n0WGZUsiFwCs9vY7mbW6V/ztpHsOaUgzsKUHK/0I8RdD6afffXwrWYmnFmurRkoOh4cvujU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkAonnUKB+mT0yPau2498JUd4ypnTsgIM7CNhpJz3iJlWqk9Cr
	asyOzBshgJrx+dmpgcA/T+xAnobS4lUCLui6bcWBmYg6W/xf3c8Er2PoN1elOz4Klwn4Lxzex8q
	NkRCGyA==
X-Google-Smtp-Source: AGHT+IEBbKG0iCMT8+liEbbKW7D6/cQKYjduaL41NtO3r/DiZWkEZg44si39Rqhc20QIfNAfZk3WsYo6DL4=
X-Received: from pjbfv24.prod.google.com ([2002:a17:90b:e98:b0:340:b55d:7a07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d43:b0:340:bfcd:6af8
 with SMTP id 98e67ed59e1d1-343f9e906d0mr4502734a91.4.1763144754348; Fri, 14
 Nov 2025 10:25:54 -0800 (PST)
Date: Fri, 14 Nov 2025 10:25:45 -0800
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176314469132.1828515.1099412303366772472.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
> This is v2 of [1], trying to enhance backtraces involving leaf
> functions.
> 
> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> fails hard for leaf functions lacking a proper stack frame setup, making
> it dereference invalid pointers. ARM64 just skips frames, much like x86
> does.
> 
> [...]

Applied to kvm-x86 next, thanks!

P.S. This also prompted me to get pretty_print_stacks.py working in my
     environment, so double thanks!

[1/4] Makefile: Provide a concept of late CFLAGS
      https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
[2/4] x86: Better backtraces for leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
[3/4] arm64: Better backtraces for leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/da1804215c8e
[4/4] arm: Fix backtraces involving leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/c885c94f523e

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
