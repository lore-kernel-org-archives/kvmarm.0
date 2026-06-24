Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE718340DB8
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322371; cv=none; b=eopmllZGkKZ25d4c+5HgDkoAU+AHkpw7WFh6tumPoVzpZmezU+2Hxf34/GFKazlLlMEfWwdU434UAydmqCbBmU9BY/+gclY04b/c7JMiY5vb3u6tiIYORWc3Usizlsl4u+PtDzcedwVxXgkjwyAYYF4ohAPo010VJ0eiWYYwn7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322371; c=relaxed/simple;
	bh=iikYRdViwRtzh9V9/K4oM7wLc4TMqwuuo3WzFq6sMBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TLTpFKRAOnhRjbfl8DTwMKNQlTa5E3o/C8F63lai+LcqJDyn4QPTyA+Nh4SMIviPA7kcozgoS57TOgceaQHfQMd2p8El/rJwgd3eGAPnLK3wxwBaFsHLDmJpIAVVan+w2mHBM70i9Zp6/SZ8u8mtB+LBsCh3ZNxxEFj6lxO2FM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YV0alfNh; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YV0alfNh"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8423efbfb61so996473b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 10:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782322370; x=1782927170; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NuCvG+ANEtYYDDfdrUYBmspYw8vstGpW69KsCXQmcQ4=;
        b=YV0alfNhH2idIGNgU+GJmWeaOU6BJ2tyC7fYARTn6fW1IWCiZ4IexUUA/hpM+S9hMk
         rq1spdbDZ/hQ6KZJURLXd4Evq86syFhP6ihP4yh8U8qLy7qnDIbbc1z1BRoKJkuM0+LS
         oScPDP4vyt2DDb8RFs8cT/jDqe6E5rBTN+inNcq6Qqf0sRymsdBQVOm7ZvnZqw42BF1s
         s2FNvCsFc2y/5fFArgUgGVusUPH583ujVoUBb9lo0CeXyHeQtl++58SnYNIC9RK08FO+
         o3NArCoDJBXY5rs04DVUo5O0XTL3XvyMub0jlzZHmVGr4xVuvdqQd+EVf6+bT2wAmVVf
         4isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782322370; x=1782927170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NuCvG+ANEtYYDDfdrUYBmspYw8vstGpW69KsCXQmcQ4=;
        b=iNB3vibYp8QOUbp64MFe82Pa0a/9ln9u7Zq5ROmI0fNCAKfAapTYn7DbQvZWu1xtyF
         Zrt8emjimouRZ4rbF2OOu6Fr/dldwIfq1GSnNRV/Ie5FhCxJULFJQkJfZUYIkWPLQWP2
         iJfJIxsqg0KPtzNbeN23w+35KytZv6/2frEmHD+8q2kngG/EumZepLdIZz0mNJlGhKYp
         pOyuuY+02xx7ZcQZ9774PPB+0IVT9HLWis7NQ/vShlMDKIr8/OSQCpimrsfVjl2JdqbB
         cEMHPTliAd63ku+X3WRmdusD9+flO6sC0K1aYNVgxv5T+gpVsAG28gTJKInK1mMqO9AD
         2p9A==
X-Forwarded-Encrypted: i=1; AFNElJ+dg9AB3AcRJWL2c1GM2dKFjskfFcT5dwykiYkv8nwnUvoXebrqW5myFrO+FnuvHQ99Bllybds=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWWQZdkBv2iwvrAFLev+X5Y/n2pvkj9VmrKAgIP9XxmTiu5c/N
	BkxIKoyNRb8AC3ezyNCvRIV4NOG558+f8c4Rg2vkqj8V9z1UGDDoIl4JB7xxhq/VjeWFJ+XgTGH
	BZcdpGg==
X-Received: from pfih1.prod.google.com ([2002:a05:6a00:2181:b0:842:9550:318a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:450f:b0:83a:ebec:452f
 with SMTP id d2e1a72fcca58-845a28d4650mr5767948b3a.42.1782322369734; Wed, 24
 Jun 2026 10:32:49 -0700 (PDT)
Date: Wed, 24 Jun 2026 10:32:49 -0700
In-Reply-To: <CAEvNRgE9cLfjDbXuR5wq3fEWZyHxYPxdExxNjXUFO1nT5m==1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org> <ajA6ogaNiI3KDv5i@google.com>
 <ajKcDRqT5m069PXK@raptor> <ajMPvgA2eHQCj-B0@google.com> <CAEvNRgE9cLfjDbXuR5wq3fEWZyHxYPxdExxNjXUFO1nT5m==1A@mail.gmail.com>
Message-ID: <ajwUwX2xIOLjACh0@google.com>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, sashiko-reviews@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 23, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > and purposes, we're conceptually treating conversions as free()+re-alloc().  So
> > while the page might still be in the page cache, it's effectively been "freed".
> > So in that case, KVM really does need to ensure it handles mmu_notifier events
> > correctly to avoid UAF.
> 
> Just making sure: "handle mmu_notifier events" here refers to
> gfn_to_pfn_cache and other parts of KVM that works with memory.

Yes. 

> There's no issue with a UAF between mmu_notifier invalidations and
> conversions, right?

Right.
