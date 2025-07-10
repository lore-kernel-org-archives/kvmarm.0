Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA34629E113
	for <kvmarm@lists.linux.dev>; Thu, 10 Jul 2025 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188981; cv=none; b=TCOR0eZUHkgXXH2ttJZHi+txb8ZImcOQ32gbnzBAuQtCBMESCJFLRQRcI3aun6ob5P0OIWlgqGTtuxY8ky4pzIkm6qPl6s89a8UdMj5yfUV7/YC5e2uLgviroI9UQEn+BET8KhUwsM/6wXKOmrcs2mF05tZmlUuExepmmlSD6Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188981; c=relaxed/simple;
	bh=Imhpk93MYLp8xwLOAgb07FPvQgj67wyrPnSesGvWOhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MFIsJ4Wan9DID1KolyZB3d/te84X0TLXjie1X6qythbiB/je1HaJfQjvG5SFR8qhfJrw4HuQ9aHTDW1Xjm7lwITyx7Nrt+bLhdJ9FIljkIhfdWBnLdXKi0Igz8tEuweJwn27xgLGaD1SdZiTCBlvQzi09Lurc89cBFe3ll9Al2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sutu9nZc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sutu9nZc"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31cc625817so2100130a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Jul 2025 16:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188979; x=1752793779; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vc4gFx6otObzph4vmcdpjljmy/wmOvcgw6O6DXvqQUk=;
        b=sutu9nZcAVQn5OtIq2TWRrrGnw0xnGsBOPy9nEYeYAvODEqa9l7fBx88JapAovkUqC
         9pwLQd4mTQdwsGoVr27O2TBULL+iiGGK6ZeMIHK8AMfhFScnCY7rjW/NtSlttVBk39xy
         wggpY3RIph5k1e3WkkcGU2kkC/LWw/XKuZbuxkNNhm/AhiLZULXYiDvMX4oAhI7Y81v4
         RNEoMkwXkxTi/LLshdy2cSX8t7uj4PPtOubZrcQ/qieNYqzNtRUIH0DKEfV5XdQKOaHF
         Z0rXY+PpMWoRadQaD8FQVBTcTFHBR7b6TUMFc8kmnJprxyYoJpiIRcsb7iPnS/u+mBlX
         d9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188979; x=1752793779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vc4gFx6otObzph4vmcdpjljmy/wmOvcgw6O6DXvqQUk=;
        b=nwKXzxlXfLLfcx5AJYrZQOwa3TenE/MZTYzUoQbN8nLoUqyqbRnxLQpRNOx91vuYs/
         gqlti0vYzQB61HVG/aXCrVvNafoUev5RKp7ErXLKasUW2m3dWuiDmQLJGuSqvP9C1hj0
         y7c2S4TqJ1A2Dq9DZY5dqNfD94Lwrsh7sya0bNoEeFQx9ovtFdPNS5R48akcXXkICBaJ
         IS5RTXBdmvLH2xTy5n2mnsfoblCxhMwkXkRYuwFAhIzX1Hzs7PMSdR64I926Wg7Ng2UK
         ZYMocm1NgrnER8f6ix3qGrBQ6WInJ+eiY52xIacqHFcxfcyR30Rp0OkMZbuNCbJiYx19
         kgjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNOKXIXVaxxHj4AMxyppqurD9lnP37bwklKfb3w6YJ3bNygrdzxpCv8F3KEkaQ1lGXzAmhv/w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwN4omZr7ueWFsSploMdaJUUe3GU/IIckj4A/h5nJc6uW8LWxNb
	BalvkPiaez5t1EXG0+qcSTCIGcs0zTY1RS98oTVdGJ4b6qTpMxCMK7wEfSfffCJ1kKYPDQXZItu
	Cs1N4gw==
X-Google-Smtp-Source: AGHT+IE+dyK2d0uR86qfpkwgq8AVI1vUVbhbMbwUukxTkGUUqxum4AWqrZhpfpFloZnZbssgldsJ/GbSzP4=
X-Received: from pjbee8.prod.google.com ([2002:a17:90a:fc48:b0:31c:2fe4:33b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568f:b0:313:d7ec:b7b7
 with SMTP id 98e67ed59e1d1-31c3d0c25b6mr8663625a91.13.1752188979183; Thu, 10
 Jul 2025 16:09:39 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:50 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218136720.1489574.7636607289998193683.b4-ty@google.com>
Subject: Re: [PATCH v5 0/5] KVM: x86: Provide a cap to disable APERF/MPERF
 read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 25 Jun 2025 17:12:20 -0700, Sean Christopherson wrote:
> arm64 folks, y'all got pulled in because of selftests changes.  I deliberately
> put that patch at the end of the series so that it can be discarded/ignored
> without interfering with the x86 stuff.
> 
> 
> Jim's series to allow a guest to read IA32_APERF and IA32_MPERF, so that it
> can determine the effective frequency multiplier for the physical LPU.
> 
> [...]

Applied to kvm-x86 misc, with the thean typo fixed.  Thanks!

[1/5] KVM: x86: Replace growing set of *_in_guest bools with a u64
      https://github.com/kvm-x86/linux/commit/6fbef8615d35
[2/5] KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
      https://github.com/kvm-x86/linux/commit/a7cec20845a6
[3/5] KVM: selftests: Expand set of APIs for pinning tasks to a single CPU
      https://github.com/kvm-x86/linux/commit/e83ee6f76c33
[4/5] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
      https://github.com/kvm-x86/linux/commit/df98ce784aeb
[5/5] KVM: selftests: Convert arch_timer tests to common helpers to pin task
      https://github.com/kvm-x86/linux/commit/95826e1ed359

--
https://github.com/kvm-x86/linux/tree/next
