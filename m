Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30441F543D
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734559942; cv=none; b=OIU0zlWkIP9WH9AEqZiEtSXYS2TliCYpSdXYnIJO3fj4Yrmp2veFAzlZwFozamm/YvXKwld8r39jKAHE+NawTgkOE2PXYmo8dwwqHRHshrEoKn6dqteMC01EfLEXXRlEk0cMwxInoiegfrO0mtGXPhnbcdo4c5NSO4dZ/OywuPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734559942; c=relaxed/simple;
	bh=9ElCmbEdpmXTkkl32gV25N180alLg2mTUaxIcxwRA9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QObZ+E1eE4AD1xQBFVxO5AgERAF1iBcgdFobBUP0iNHu0fgqezxLuvsNvvqnxsj/E5Azoy20mZzHJVkthx6c1IZptVyEcENW9OFdDnvsPNprtf5bfPsxsgalEgnzQKZH8nrVztAabtyBQwXu4xpWNOEKs7pXmj52EibMKjkTmDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Np4zYN0r; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Np4zYN0r"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso138551a91.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734559939; x=1735164739; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8/Bx7vVXdjG8Qup6CRv0EW1z1SiIeJxiXGSb6iiEaI=;
        b=Np4zYN0rtHG18tRLXHz5DgXizvKizKNjN/1KXDPEBUdbjUFAQVW7R2zr7WQar/UBSW
         uY7V0guO/6/YrYr270pujVUbwI+dsYZa6Zsi2tRgt7dCMXTj3P+97YQ+2W1/VIP1HXqj
         0/h7T1YIM83FlyNSKtBUsxOgDRRyFqZp9Vq7eOJD4Lc/B/sDi9UhNE+dt0ZMoL+Mg9PB
         DrY3YAqvuL1h7KNKVG6mTxEW9Tib0NPXSQdy9rRpHy09ieqShZPpr4McMqe2vez0+YVV
         80K4UPv892iXITe3hIBRDJClFajzxklxkbVt0B9NU1UI2FbA+4rGQHEE0TW+zZO6iSgy
         Sj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734559939; x=1735164739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H8/Bx7vVXdjG8Qup6CRv0EW1z1SiIeJxiXGSb6iiEaI=;
        b=mztGzYZTQDLPfd7cv+iOXMVKQViN5mrG2EU6qPHfvwlREsuKYAypehfzr9Wl/df+gL
         cP6Ev7Q2AkOiueAos4bIwpL7+fRFizLdsxbRiiHgN+jherb6w9nMrptRaqlQxu4PBSnU
         U9UMuMIx46V+rP/ybBaZC2CgQ31KsEnsnEXQDxhiG2F3s3JpTpkogC8lK9IKCQKy1nQw
         unhcKib1u3HrH7KMI5OhKQJCf/jftoeYkDTWbv4trPW4z9SqrRwf/yGMjvdEWujJrDLx
         d2o0NA6L7NznW66cG/dfnpy2LnOHsjNBDuSEAch9HkUXNaaRW2x5dASQOrZn1wE4v6d9
         jffg==
X-Forwarded-Encrypted: i=1; AJvYcCV4Y/U0EDf4unPKL+IdeoOJmMcCmGjlbuAlzdgTqebjnKaNJr3pfdIyQz2TXBM7T6uuFBnGUP8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqPPxKZ/64fIz+yMeRRq6s4gBemhiD9mPXC4i7a9afKH8AGGz2
	Vz480BRjdrkgsY2HW7X+OWXR13af2yov10/ubT7C1ZyE0ODDSSPrpmlVGIXV6JONclTKBlCZ38j
	Kcg==
X-Google-Smtp-Source: AGHT+IErnWAR5psGjYVEFgNdPO9Ra9c1ykxsWobkdL6749/rPBHLJQjHXddkE3dKVeRJv5MVr7RsZhgUpzE=
X-Received: from pjuj8.prod.google.com ([2002:a17:90a:d008:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134d:b0:2ea:37b4:5373
 with SMTP id 98e67ed59e1d1-2f443ce8daamr1395725a91.10.1734559939355; Wed, 18
 Dec 2024 14:12:19 -0800 (PST)
Date: Wed, 18 Dec 2024 14:12:18 -0800
In-Reply-To: <173455833964.3185228.5614329030867008316.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com> <173455833964.3185228.5614329030867008316.b4-ty@google.com>
Message-ID: <Z2NIwmRDaZBc_V4o@google.com>
Subject: Re: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 18, 2024, Sean Christopherson wrote:
> On Wed, 27 Nov 2024 16:55:31 -0800, Sean Christopherson wrote:
> > Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
> > avoid unpleasant conflicts, and because I hope to land both in kvm/next
> > shortly after 6.12-rc1 since they impact all of KVM selftests.
> > 
> > mmu_stress_test
> > ---------------
> > Convert the max_guest_memory_test into a more generic mmu_stress_test.
> > The basic gist of the "conversion" is to have the test do mprotect() on
> > guest memory while vCPUs are accessing said memory, e.g. to verify KVM
> > and mmu_notifiers are working as intended.
> > 
> > [...]
> 
> As I am running out of time before I disappear for two weeks, applied to:
> 
>    https://github.com/kvm-x86/linux.git selftests_arch
> 
> Other KVM maintainers, that branch is officially immutable.  I also pushed a tag,
> kvm-selftests-arch-6.14, just in case I pull a stupid and manage to clobber the
> branch.  My apologies if this causes pain.  AFAICT, there aren't any queued or
> in-flight patches that git's rename magic can't automatically handle, so hopefully
> this ends up being pain-free.
> 
> Paolo, here's a pull request if you want to pull this into kvm/next long before
> the 6.14 merge window.  Diff stats at the very bottom (hilariously long).

Argh!  I completely forget to build test this on non-x86, and missed that arm64
snuck in 75cd027cbcb1 ("KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely 
ignored").  *sigh*

Given that I just sent out mail, I'm going to cross my fingers and hope that no
one has merged the above branch/tag.  I've deleted the branch and tags from the
remote, but kept the tag locally just in case.

Please holler if you managed to grab the broken branch/tag.  If no one screams,
I'll assume I got luckly and will push a fixed version (with different names) later
today.
