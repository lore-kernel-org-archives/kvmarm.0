Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861043595D
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 22:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396907; cv=none; b=ZM+QiX8c5Ig9ACO/qjqIrnpNg1qyWF0+lrkjmU0YZoqFR/hp7gzscblSvHtauiWRolfSjzR69i5nRM81+JL2uL2c8AGiwhqrcMqI2dzKGPWedU9omMDRdaESip72OvXKk64/fsLCeuO1Mg9wg9zeYBNIXirNORVeWD5vcE74xK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396907; c=relaxed/simple;
	bh=XP7SEwPZ4F56VY5lJapsTNraraT0bGVpygeXc7n5Ehs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uap2AfB7EckbE2RkeooR+YFsJSVDvby80n8+8DNQyyDqzbNKo5hxZIQSXMS/868SdW3/c2Mb/e5peBVq8bb42DvAxBpbK6624F1Og4kvhbH/DCL/1t44ChA6NT2e1J80oFodJaO/jLoilrIR1ruXvdCR15tGUxFO5JvQbfVFU5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VOUkQL6F; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VOUkQL6F"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso1529289a91.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 15:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396905; x=1754001705; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=VOUkQL6F2cwSSe5RujEThbeR5stghF7/y3Q3FDDXmpjFxb4SlXi/tTqZCYpYkXH96w
         ANSVXLghFrDZ+SsBYWmpsso7chc4N5x10ZsET8Q8Lf8ZWlQR634oDBU9pGrR8UTktkC0
         glU1f4s6jdm836edEL6fP70b8bquBCmHrkbEYsR+EzaoFRrXcPYCIchuQPXNlt5Plsky
         maOYTno37zChd2kyBhfnLjhLVj4StxFa0XAVVvNI6NLCytvRW1yCPBIjist8ZK3CmjJI
         ypQaTJAt11nnVPMRQXlJ+8MNhMW1jZouCuGcHhIy9q5CzXh8TpxXp7C0Hz7vHk1BA4Be
         5jwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396905; x=1754001705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=DjWTTAvSnrAjuD4bLbdI9zKGhRd4PL02PEJjfWhS5Nxs8PUGNjdjrLRReczmOJz9+T
         qkEqz+0CeukyjT+4T2AOtVX8o3dpaYlmesZa3c0MCUuujPfTi9sf+CbYSYyVwOtP2E7d
         SmP4rduZdvlTdPXwZ9LxW/D1pORc3njK/jkhnPN618HNcVL7FPQsYWtOIR7otvq5ffEq
         7RnvswlTec6BcXneVa0HTWa6fdCB54OIzKkYCIv/8cla5SIzc6V4qX+oWj4aa8RpqNCX
         KpVj7hA8UOyGgYwNX4kfZtOl9mab+0mCzP1fz7+s5IiN/HQ8SUb1+UPfP3kPU+4xdPcf
         eqYg==
X-Forwarded-Encrypted: i=1; AJvYcCWFRBQgPitnl8xahA4qnLZkvihcfxyvF+qClq85vkBpdMHVjs/CZ1rebU9rBspemfpn+/bpOOA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbsOB6nRqs7wW3Uf10lohdYicCEK5yjwcekATqj1UBtr7QkdtS
	My/oTEoZUR9extiY4MuOWYRB9pGm+ko21+Iy+qbw1zBYT7NuLCrlv1LFNlCGVLx9xnDyMAe6Ll7
	2mbdNqw==
X-Google-Smtp-Source: AGHT+IGEPOlZq7owpGUQ0/mQoz/iYL0juCcDdQmikLBP7yLM7Njsl8AJeWnJbZK3d5L+Zszkhv9RTa/c8fM=
X-Received: from pjbee6.prod.google.com ([2002:a17:90a:fc46:b0:312:14e5:174b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4985:b0:315:af43:12ee
 with SMTP id 98e67ed59e1d1-31e507e27a7mr12941229a91.16.1753396904788; Thu, 24
 Jul 2025 15:41:44 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:41:43 -0700
In-Reply-To: <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-6-tabba@google.com>
 <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Message-ID: <aIK2p9TgiNeQOI4s@google.com>
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> > The original name was vague regarding its functionality. This Kconfig
> > option specifically enables and gates the kvm_gmem_populate() function,
> > which is responsible for populating a GPA range with guest data.
> > 
> > The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> > option: to enable arch-specific guest_memfd population mechanisms. It
> > also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> > options.
> > 
> > This improves clarity for developers and ensures the name accurately
> > reflects the functionality it controls, especially as guest_memfd
> > support expands beyond purely "private" memory scenarios.
> > 
> > Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> > function. Therefore, ensure that the correct configuration is selected
> > when KVM_SW_PROTECTED_VM is enabled.
> 
> the changelog needs to be enhanced. At least it doesn't talk about
> KVM_X86_PRIVATE_MEM at all.
> 
> If Sean is going to queue this version, I think he can help refine it when
> queuing.

My bad, I simply forgot.  How's this?

--

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
minimize the churn, and to hopefully make it easier to see what features
require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
software-protected VMs.

As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
for all 64-bit KVM builds, at which point the intermedidate config will
become obsolete and can/will be dropped.
