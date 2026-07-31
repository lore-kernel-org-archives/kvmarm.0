Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BF736EA99
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534100; cv=none; b=ILDrpDcN7TEOYO+HWoVcrM4ERZnAJ//OV6+p5fNeh+x6CtP4/vdE4U6MbIcBqEGYYhPJ22FJyhBQHRWhYtDmODH1GZslOJH57AOSQW3bXEUcl07JpGLtsbwr8C9rp4sFShXUdawUd+702XvHW4pS8jN2SNxd3s2H0dUWA4xDKEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534100; c=relaxed/simple;
	bh=bq31RPSAnTvewVks7PBfBFUyA5BKHmft85kpTD6XW0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VeQlIBWO/eNYjRtnFxYYFLYqkJYuY2jxb7HVHwowH+CUXPMOg7HTve2wtR9dLtNnfs0fO4RSog6uunmMCp8koVgRuZFUdnxQTEcuKO+xVULR1SiKN50+VH6N8Sb/DabIx463JdRXdUJtlGnmvpXD9WaxftQtIutllwgeiIOZXVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGHVjZBs; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGHVjZBs"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so26897285ad.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534099; x=1786138899; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PVR8QujnOvE/gsZcroLlAokjVOxh8pMAit+Zm+cALWs=;
        b=MGHVjZBsv/TP1yoRq/q4vMOcYMuoUcfb25KIqxAXYPPgv8UsZ4upbFnawX5em/pQUx
         FuLoFxOyh6X0a0zyvqi7X7Pt8CyGU8OBQWAmtdZCf/mpwghP4vBTnGrJ5qaDqN/kh42u
         ca+qoCFag2eOm9JRmKjzFegvqE9vvpgABXlIPX8mrHSKxfz4ADcb43NqlAmSi36qXSEy
         rxMtRjInvzCLUFc42QrhasPrtN/kbyK7tfK4IqX4wuWn/noAI4YYo+gicSOsnw0DxNjm
         6iqJfWagn7P9H43+P3r/9WVvzBFCy8EhBGkwxXmdHWnIgvBCykBQKok/3/x8PJPv2cV5
         bPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534099; x=1786138899;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PVR8QujnOvE/gsZcroLlAokjVOxh8pMAit+Zm+cALWs=;
        b=HPjKnr0ToVWgsXa3mfH1cu7hwc+ZFqnf4+LBQuAD7pivYHZWDsEyy1/wM/j9WjWRj7
         A6JRX0dxtNA5IjNr9sreFyaStokpQFHBa2XKISpT1qu4KZl/nDmXkOpxf/7ZB6oPpllx
         NTXXlK47kx9ZoZpmCa/lhuJNl6EZlpEgUu3zCfBg5NptZQeo4jQXGH/0vYZOCfpAlNdz
         LamdMFE/uUbhbqxOXkuv/7qUKGvN1ehjsvBcBGd+UJ5n8enYI/pLIUMwnzMa4aSFGbU3
         f7mRmZdkNINnlV2voZgalP5QAy1DMNaVHL7qeQf/tYUms7L0TRpXQD4QkME1X9I0nNFf
         UHLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrKhpvCJhSaPbfs1+DHLKUJCoRFj2/uus0k2eWI0vOFSk3oLmSGGV1mZgFBBFy0vQw04C8ZGro=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVLtwFH+a5oU7/dLx21S5UccpYuwIq65bMw8UHdknyz3i82UjU
	j1B9KjssFEW0FBdFpVpOzuniVUHjQmLcB55spjVvnBvKNzW8hvXk760U/ZA683x5KkP7QUJuGo+
	FYZ71ug==
X-Received: from plpm7.prod.google.com ([2002:a17:903:3de7:b0:2cc:77e3:3ef0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2d1:b0:2cc:6817:d9bc
 with SMTP id d9443c01a7336-2d0523e6ee5mr13779535ad.38.1785534098681; Fri, 31
 Jul 2026 14:41:38 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:41:37 -0700
In-Reply-To: <CAO9r8zO-eCz-4Gpa_FUjRKPaDj82PP7et7KON4S5QfhRU2J-Ug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com> <CAO9r8zO-eCz-4Gpa_FUjRKPaDj82PP7et7KON4S5QfhRU2J-Ug@mail.gmail.com>
Message-ID: <am0Wkak_vhy1n_xu@google.com>
Subject: Re: [PATCH v3 00/12] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> On Fri, Jul 31, 2026 at 12:56=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > Third time's a charm.  Sorry for the spam.
> >
> > Buried in the middle of this is a fix for the hardware_disable_test whe=
re
> > it can end up with a runtime of multiple minutes when running a preempt=
ible
> > kernels on a large NUMA system.  Turns out my analysis/guess in v1 was =
wrong;
> > the problem isn't direct CPU contention, it's that letting the workers =
do any
> > amount of "real" work on any CPUs leads to pthread_create() slowdowns f=
rom
> > the perspective of the caller.
>=20
> How long does the test take to run with this series?

Less than 5 seconds if nothing else is running.  ~12 seconds if I run it
concurrently with mmu_stress_test using default settings, and ~25 seconds i=
f I
run it on an overloaded system (naively running all selftests in parallel).
