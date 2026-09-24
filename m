Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071F23515F1;
	Thu, 24 Sep 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790259051; cv=none; b=HTgDyCFkXZ0xXTCI5NaSyMOqpLgbyvT1XqOqpk6e/407PSyqI8Xv9rs+rn9OJKHIsB1arOkxS49J+AEYh9vdDKAOMem2ZuJcCmcSIquGDvO0dPUpn1/LGjf+EBuRq8xKfJxwTJXT3ilD4KN2d264+bP8O32XnTytIpZf6XSLvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790259051; c=relaxed/simple;
	bh=9TgDyFwJ+7DDH6AX96a9gn3Z9AGTUD/r7aNoQfYxkzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmXMF/VkL5ic2k8xY/pvP9AztbgccvS35Y0i7Ovdxg4WlwZeikri8kW/fayXtqfYLG3PKoMzGGaT8LQLiHzsGISLy7hI4Qt1OHiT0n0/+le2wHKoRV2WDHliasS82S9QjUrtVy/WQwR4Qo9+m9fucW0XiH3HoDWDao9kb4c/+Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af404a00e4ccc4fdbbd66590.dip0.t-ipconnect.de [IPv6:2003:f6:af40:4a00:e4cc:c4fd:bbd6:6590])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 561341C7465;
	Thu, 24 Sep 2026 16:10:47 +0200 (CEST)
Date: Thu, 24 Sep 2026 16:10:46 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, 
	michael.roth@amd.com, nsaenz@amazon.com, anelkz@amazon.de, 
	Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org, 
	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Message-ID: <arUtYyK25eKQYY7j@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
 <aib8n5lO6HKbLC4Y@8bytes.org>
 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
 <aigE2EvJyZlYDz0V@8bytes.org>
 <570f82e8b8bc968a31a4ba859145f6c324e41247.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570f82e8b8bc968a31a4ba859145f6c324e41247.camel@HansenPartnership.com>

Hi James,

On Fri, Jul 17, 2026 at 10:35:10AM -0400, James Bottomley wrote:
> So this all depends how the planes are started.  If you're starting
> them from an IGVM file that loads the most privileged code and then
> runs the guest in a different plane, absolutely, it can work as you
> describe.  However, the common use case for serviceable security
> enclaves is you start the kernel first (necessarily in plane 0) and
> then bring up the enclaves later which means the planes > 0 are
> technically higher privilege since they're running hidden security
> code.  HOWEVER, there's no reason at all to trust a security enclave
> that's doing something like guarding private keys to be able to poke
> anywhere it wants in the guest ... that's a security breach waiting to
> happen, so it would really be better if the model were not
> hierarchical, but more akin to the ability to seal planes off from each
> other, so the kernel can start the enclave, which would then set itself
> and the communication area up, but then the plane 0 kernel would remove
> access to most memory from the enclave.
> 
> In this sealing model, there's no absolute privilege levels; each plane
> would decide what the other planes can see of its memory space and, on
> security grounds, we'd likely configure the enclaves to have the least
> possible privilege.
> 
> Now, Windows applications expect VSM to be strictly hierarchical in
> terms of privilege, but if we create a sealing primitive as described
> above, we can get it to build the strict VSM privilege hierarchy in the
> hyper-v driver.

I mostly agree with this and have to say that my statement in the cover letter
about plane hierarchies was a bit broad.

The main assumption this patch-set makes about plane 0 is that it is the plane
which does the IRQ scheduling. Say a VM has Plane 0,1, and 2. A VCPU runs plane
2 and KVM wants to inject an IRQ into plane 1 of that VCPU. Now KVM needs the
VCPU to decide whether it wants to run plane 1 to handle the IRQ or continue
with plane 2 because it currently has higher-priority work to do.

This decision is made on plane 0 in this patch-set, which it needs to be for
VMPLs. Does VSM have a similar concept for IRQ scheduling between VTLs or will
the hypervisor take care to run a VTL when it has IRQs?


-Joerg
