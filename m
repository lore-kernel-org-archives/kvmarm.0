Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8BB158218
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 23:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825302; cv=none; b=rB9bROoxFE9w4HkdeQeM358gltykXsee7ZIopw06ppEb9SutB051f4deNh7VhCHkaTeCqR3ZxS1+sZHwFpEMkf4fP0P3wZD7rsnD6Py/K0U7sqg66ziRrcQF4XcuRPJo42dzHEqpBrQZ3LRqX8XN0NX/YIU8kKl4HhSi7TbJCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825302; c=relaxed/simple;
	bh=URaS21lxsrvli0OFExDTV2P+EnHET3qehdmO6/xClsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jf3ROoAvsRPGAO4i5EIU9VU2I0k6BxehA6F3Z/FULHlY3TR9XZN+B/GxU9ExnjEAEisPfg9O+phHarOkPMG+0uqqOKrWhcxjwpBJuSpY8pykM7abXjii2S8jracztQj90JFDJkQW9WOfpLZ1clq+GrBr1wA8SgtMJ54/jQWRf5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OuJdvuaU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OuJdvuaU"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d7124939beso98759737b3.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Oct 2024 16:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727825300; x=1728430100; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fqx0eoYDpxDf/AGbKjGil2p5l2k+gj5ioLs3IZX1FiE=;
        b=OuJdvuaUw+yV2B4gH/B8H3i6MMf5TjIM5bNF6YkueOsokN3rSsyFI88wQP2pre8cbw
         URgKJ57kQL39amSZV3arux1fZMfK81mqNHvOZ4DfFrUNm+ilawEdKcZXwE0njsNjdi34
         J4eiB4E83Di7AKtv/+dPG2BSifkEpCoeVUY7zFQq+haYNn0M3NannGSJ5Pw/LkT0zdRJ
         4TTssfwg/coImRjYiZza5yAXyGe8WtBS3IutBLR01jh68SK0skTeooeRG+QoDGKhhZfg
         vyAjoOEYh+wD+RHz87Sbj39I26hSEFtPWTtIQVks7RxJvpovkJJaPbHCoehT2w+xRCXS
         AKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825300; x=1728430100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fqx0eoYDpxDf/AGbKjGil2p5l2k+gj5ioLs3IZX1FiE=;
        b=nqlIaLVib1MvFdXbuh91aI+qGAuh5+LbhAWyLMy8cKG/49dbsKaxgCSEMFs+DZhU5Q
         SmMrQsAa34aJzpMlJJyTp21+K2lxBOYztD2lFnxYNMfrFXRPjRWfTrq2m9l9fG0wZxUF
         0pxKYX2ogADmq5LaNaYlX9PftQ0wvS8kn816yPpFGHYz+w3JmaxEPhhDqi1dbAcHofQS
         ed+KyP3hr/FuSqEu1Ko7McziLLLa3XTbWuJsfvvWZvtOSzsceJ2B4ysAP6nOwVPVs2MI
         TH2s5M7ZpFVIuv1yl7U/1A/bf61S6JAJpm1lS8Vg1Qcy5k52XWZjl+3d52d/BaDqqQ3i
         MzCg==
X-Gm-Message-State: AOJu0Yw8H20K9U7BA1496LFgRqb2Tzqvo3Rh79EhG4zHDu8++9STik4M
	hNKRavqEH9hySzPqJi5TiiayyBIF7NZGwXgs5fwwrdJTrXabta7HV5bsXoYqaT6DpaMJJtHBY/i
	r5g==
X-Google-Smtp-Source: AGHT+IGOIITmS8E3kuK0Dr84DAJUsfABas8WiwqYbwTxIipxRe4Lksm8mh1qLq9+QNSBOD/UmDgI1hv2VE8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3583:b0:6d5:df94:b7f2 with SMTP id
 00721157ae682-6e2a2e457d7mr339617b3.5.1727825299934; Tue, 01 Oct 2024
 16:28:19 -0700 (PDT)
Date: Tue, 1 Oct 2024 16:28:18 -0700
In-Reply-To: <ZvxeeVn8LphHxWeS@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev> <ZvxH3el9SNuNWwi8@google.com>
 <ZvxeeVn8LphHxWeS@linux.dev>
Message-ID: <ZvyFkqsRFBAYwqP7@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 01, 2024, Oliver Upton wrote:
> Hey,
> 
> sidebar: I was a bit confused by the diff for a second, since it looks
> like your email client lowercased some stuff :)

Wasn't my mail client, it was PEBKAC.  I copy+pasted a large chunk in Vim because
I wanted to pull in the changelog (which I had deleted from my response), but then
I changed my mind, and in doing so I managed to fat-finger something that converted
everything to lowercase.  And yeah, it confused me too.

> > >  out:
> > > +	if (s2_mmu->pending_unmap)
> > > +		kvm_make_request(kvm_req_nested_s2_unmap, vcpu);
> > 
> > If I followed everything correctly, I don't think a request is needed.  the
> > request will never be cross-vCPU, and each vCPU holds a reference to the MMU, so
> > the MMU can't be recycled, i.e. pending_unmap is guaranteed to be relevant to the
> > vCPU's usage of the MMU.  More thoughts below in check_nested_vcpu_requests().
> 
> I'm (ab)using the request to prevent the vCPU thread from actually
> entering the VM without first having done the laundry. We have other
> examples of strictly per-vCPU tasks that are tracked with a request so
> this doesn't stick out that much.
> 
> Otherwise we'd need an open-coded check in kvm_vcpu_exit_request() to
> catch a 'dirty' MMU or take a pin on it from the point we check the
> dirtiness to the point we disable preemption.

Ewww, because kvm_arch_vcpu_put() puts the nested stage-2 when the vCPU is
scheduled out.  Mostly out of curiosity, why?  99.9% of the time, the vCPU will
be scheduled back in.

Now that vcpu->scheduled_out is a thing, retaining the nested s2 MMU should be
quite straightforward.  kvm_arch_vcpu_destroy() would need to put the MMU, but
that should also be straightforward.

It wouldn't magically fix the mmu_lock bottleneck, but it would make hw_mmu
stable (obviously except for the flows that explicitly change it).
