Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D50296BA2
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756156294; cv=none; b=ZUSCw4NrGo7QT3VGvOD9tXMZuQrn874rc6kd5u8uLDB4mlAczcuYAvFVPloWkmJ0zVAyYiypgM2JcLkj/U1/hTJxG6Of/O5/10Pa5gb0zDKxlbN9UH5/VTQTKReCtFnwxy3/nABRkgL3gG+6q+dNYjtPc9I1qThEmIS5+pjWEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756156294; c=relaxed/simple;
	bh=nFbTNjxctDGMu7gKAPNA3RP/CMiZt9a/yh8OXsYC9xE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n7OYcxaYg8XUclbjgmSZ6s1ci+zaYqJ2XU1KyXfC2YHYoKhvRpZNgWsZL5o7ckyy8q/YX431Hv2XtzLfYwfQGt3ndoe98fsk+tpMJr6voScrUUOS9nPZp5eJsSaQMO2gpe+8h/p7BIxzZ+Av3/iprkTLsYLPXXg8U/QFYF8telU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j8kGkLbt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j8kGkLbt"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244582bc5e4so59655105ad.2
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 14:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756156292; x=1756761092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bU/VP3KImYxnarLk0B3IOiENhi91lMJDhOtDAwiONbw=;
        b=j8kGkLbtY/GWaBrj+gSD5VKL+/AmpQro90XF0SYuBSorCzZIbXiMdPtYlMZ/FbWYLx
         0JS7nvPcDrfM0BCyrzjt5TGZDdEPz+mup+AEiCX9Jzrlil2sipOEjgdb5QD096AJWp2R
         r/iq+0f8kiSLiTe35SEoIGEtlFpom2ixmH83gMwZUh+2DidRXpO6a47lAyddlNDSa6Mx
         lK2c1sclDGNCtuEo0SQLqeEDP1jjLHoOo9tfxHIpQ36W1i7QRSnr/PQi/OLFbwWOMkQI
         TeGV3mAhSeh0gGiKnEtMGorYQ6Kb+GWv/rmkqXivF9W8NOUD4cC65bz8OSWeZc3g7HXs
         hrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756156292; x=1756761092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bU/VP3KImYxnarLk0B3IOiENhi91lMJDhOtDAwiONbw=;
        b=mZ15n3nUXpCidr/kPDdeh4WncwBX+U1N2IyhneCe19Y+dryBxkbN/a/4CdiY+vpxYJ
         SBabiet3gZJ9hiHK0A8JJnQzQV21Ld1WA5QNSbDlyJ8FtBHfun5ZbrlpXnbcQn1B0+ZC
         03uoRDCYyhtxOn6MKFtT34NemTGDCO73CI/hCqV5BdX1xMjogirvoI9jB6wrP+yuPWNz
         6whWr8hsZPODWh4YXmn2YYQHQKqhSk3MTWf3nxWwL3wuG1/UClM3RZZQMYmh/WPrMrPq
         wk/1Dg3KlQT5q2C5v65cpsFHorXt/F8lzQwevBqu8VX/ikmlDes1S7eokl9/yAhqnWQZ
         /GaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9/msGnID2DCtN5qQXl4p2yXzXjR2il4BOgeYBO9rxFm5N1JBAeydlKjO4dvqbAqEWqzwx1qQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3k80v2g5+uyITg7vrQqRFox0j/QMDU3Mb8LhI6GFKyf6FAYIV
	/3pEmrw45wSH84fsJqMKI8JDeFKX/fdzI9M5ercNl4qTmh3Em0uotsImEU1MuENQVOhLfiz3Lsq
	EdrOFPQ==
X-Google-Smtp-Source: AGHT+IEmXw+WuOyMgM65AZf9fTrlI3TioKulbn9TFehdZm7hjH7SGdKKkkNUobg2k6tabLgV7nQdbhXUq2U=
X-Received: from pjbsm17.prod.google.com ([2002:a17:90b:2e51:b0:325:238b:5dc6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c8:b0:244:9913:2fe2
 with SMTP id d9443c01a7336-2462eec67a9mr166879855ad.27.1756156292252; Mon, 25
 Aug 2025 14:11:32 -0700 (PDT)
Date: Mon, 25 Aug 2025 14:11:30 -0700
In-Reply-To: <87zfbnyvk9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825155203.71989-1-sebott@redhat.com> <aKy-9eby1OS38uqM@google.com>
 <87zfbnyvk9.wl-maz@kernel.org>
Message-ID: <aKzRgp58vU6h02n6@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ott <sebott@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Marc Zyngier wrote:
> On Mon, 25 Aug 2025 20:52:21 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > Is there a sane way to handle vGIC creation in kvm_arch_vm_post_create()?  E.g.
> > could we create a v3 GIC when possible, and fall back to v2?  And then provide a
> > way for tests to express a hard v3 GIC dependency?
> 
> You can ask KVM what's available. Like an actual VMM does. There is no
> shortage of examples in the current code base.

Right, by "sane" I meant: is there a way to instantiate a supported GIC without
making it hard/painful to write tests, and without having to plumb in arm64
specific requirements to common APIs?

E.g. are there tests that use the common vm_create() APIs and rely on NOT having
a GIC?

> And ideally, this should be made an integral part of creating a viable
> VM, which the current VM creation hack makes a point in not providing.
