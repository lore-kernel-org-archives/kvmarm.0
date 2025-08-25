Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B526B08F
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 19:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756151545; cv=none; b=q81rXK/duwatTdGjXEk1Q2hf39n/lrKVLNuOAzJ0ZCa9CfmE8orXJO5L9aEkdYKgPECmHr8JLHBtPauLAPPiZlnU6w7+Vd01YJtGnihN3+8vRYkBLVqnY5KKY8hYHQlGgDAZEGlqIAjzjxMwyFOL7kfhj2/oetkoPQPSTvgASQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756151545; c=relaxed/simple;
	bh=27LVi33Piq79b4c8wVCJq9OIcPzQn7EWMYuMP0qjd6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iAuMcZrI9yj8roZyj100suJ4LedZpxcm1V4JV3tLWiSJ9uawAGLjnVWJ0JFO2sqpmIqVFlfjsUFcClCuz66XPGQ0aDFpsexd81QMKKGX0TxJrdiRop8AdEefWOl+bowt4pDQxrL555k/qs04Vvt3bDzQLJfD1VeYVr7F0NqZp7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mAyugerE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mAyugerE"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3234811cab3so4925409a91.3
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 12:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756151543; x=1756756343; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCEDB6kqaMG14n95AC3dXml5C4i7TOO+4ulWOjXNjDA=;
        b=mAyugerE5PLjQgPatJNETvp3y2g3Us8kXv1Wya7uSIH4LWQm/LpMVfJ2A5vZG5iQlL
         /2hr4FldHXv1hrIzTDU+c7zIyYAJkpYc2who0azD6M0GeCr0c/qz4H8c1PoM9sSTwEwC
         kk/NmBQeIrVfbZz+tPXmYVHU4uce/KC76mnvYsu0wO37anSTZ4fAxO9JuMni78W9kZBR
         W/EdcqY92WnefYVNFeb4GiwOpBq5u7HSRW84POKNzQ35f/V0VtElD9I/7IUCx0JzqNza
         4ikNZnkljp8D5+dDiuJhqOrgx6tEO4Ptp2i0ptrrsyny1sHGZVCX7ayvx2BVSwnWo3PJ
         PAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756151543; x=1756756343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCEDB6kqaMG14n95AC3dXml5C4i7TOO+4ulWOjXNjDA=;
        b=vPend4mmow5Z7mVfC2zH2q/HAQiTq3mgj66iuddwRn3h1Rm7l/drkJPYRuR8plb4Vj
         S0kMBBOaj3ROHUWkDkd5T7GcJlGizNY4DvMUg60d5TSxIAOEgH5cOMmU0+1e0Et0UWIF
         v1NTik5JljBWKDCy6tUU9sYMhN5ji5HuaNiJ8Lfg2J+pNwwlQ1uLwCQJ0ckR4LUvze4B
         MXKbZzyB2ckFqT67M00esuLmsXMJCs+dAUuO91K0SZh1FttQ6F1rSVH8uZDKU/6wT/rM
         UvLJmXQbU63ys6OnmTVfBOS2SCRwN+d2YkoieXmU8vi2pj+v1EdNF0PfRkPTPSWkzpMQ
         Rhgw==
X-Forwarded-Encrypted: i=1; AJvYcCVFb9wJetcfAxMcVNMIGR9u01oLdrwSAysECeszkzHTFfMIwShN5tWiOTKU92YQ0u4/cF2eZCA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbIjsz5iEP7CQvOc34OnT8Npbyg7wMMSaXdNSNkM8EsRkS24ts
	hH9+j2SOBbLLDvzzBDlOJFIseDr8H2us2ck3k5s+9A8sun37ekkYaiTnPfbb3me8gZRJyS5Lm+z
	1uLfZZg==
X-Google-Smtp-Source: AGHT+IGdV6Crel2hSBLJu5xj69LCA8mKZyILIoBXiyFz0c96jNGA0JlOa+svdw4ALPEpBZ5tb9n+dMFk9lc=
X-Received: from pjbsg1.prod.google.com ([2002:a17:90b:5201:b0:321:c1e3:6b16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcb:b0:31e:c62b:477b
 with SMTP id 98e67ed59e1d1-32515ec9f34mr13649374a91.11.1756151543426; Mon, 25
 Aug 2025 12:52:23 -0700 (PDT)
Date: Mon, 25 Aug 2025 12:52:21 -0700
In-Reply-To: <20250825155203.71989-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825155203.71989-1-sebott@redhat.com>
Message-ID: <aKy-9eby1OS38uqM@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Sebastian Ott wrote:
> irqfd_test on arm triggers the following assertion:
> ==== Test Assertion Failure ====
>   include/kvm_util.h:527: !ret
>   pid=3643 tid=3643 errno=11 - Resource temporarily unavailable
>      1  0x00000000004026d7: kvm_irqfd at kvm_util.h:527
>      2  0x0000000000402083: main at irqfd_test.c:100
>      3  0x0000ffffa5aab587: ?? ??:0
>      4  0x0000ffffa5aab65f: ?? ??:0
>      5  0x000000000040236f: _start at ??:?
>   KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)
> 
> Fix this by setting up a vgic for the vm.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
> @@ -86,14 +90,30 @@ static void juggle_eventfd_primary(struct kvm_vm *vm, int eventfd)
>  	kvm_irqfd(vm, GSI_BASE_PRIMARY + 1, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
>  }
>  
> +static struct kvm_vm *test_vm_create(void)
> +{
> +#ifdef __aarch64__
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	int gic_fd;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +	gic_fd = vgic_v3_setup(vm, 1, 64);
> +	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");

I don't think this test requires v3+, any GIC will do.

Is there a sane way to handle vGIC creation in kvm_arch_vm_post_create()?  E.g.
could we create a v3 GIC when possible, and fall back to v2?  And then provide a
way for tests to express a hard v3 GIC dependency?

Having to worry about things like this in fairly generic code is quite burdensome.

> +
> +	return vm;
> +#endif
> +	return vm_create(1);
> +}
