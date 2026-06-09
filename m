Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0A723ABA8;
	Tue,  9 Jun 2026 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781008643; cv=none; b=RyMvJvH0v1HBQy7m1Kf2Kbi4cbqd+msKqrqWJYsk9UzXcVcIZYkXCDXgmf+/a4xI4SCUG8gO7puloW/5+XQFlKib/HGU0JwY/zZ94U+kArJLKXce/sWTGT9yC/1WGFJWQF/noAcnS6QfwS9gPemJeo0X2aWHd1jVyPL0A8am0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781008643; c=relaxed/simple;
	bh=I8MfV8LIRqFznA4MUdahkkVUm3dHQTaN2smmLgCT5qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8F/vd/0DFBUsqrs65hHBJTZqOiis69Tgt6YBuqMgsen1uZrlzODxFkbdsGKcm6RB0AVNa8iHFjk9XQ3pFDddkTjGY9o7AjUH7pmcvEo416LhISDFd/8AQz9TYgVWs5b69ZUC2SUzF7sUp6jANovvOiYK4tQL8c3nqkEzhSxABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 05F52222D65;
	Tue,  9 Jun 2026 14:37:20 +0200 (CEST)
Date: Tue, 9 Jun 2026 14:37:18 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, michael.roth@amd.com, nsaenz@amazon.com, 
	anelkz@amazon.de, James.Bottomley@hansenpartnership.com, 
	Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org, 
	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Message-ID: <aigE2EvJyZlYDz0V@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
 <aib8n5lO6HKbLC4Y@8bytes.org>
 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>

On Mon, Jun 08, 2026 at 07:58:43PM +0200, Paolo Bonzini wrote:
> Related to this, let me know if you want me to pick up again the
> common part, especially with Sashiko being hard at work on it.

Yeah, that might be good, let me think a bit about it and discuss in tomorrows
PUCK call.

> The idea of the userspace scheduling was that you're not forced to use
> it - the kernel can always choose to override it if it's using an
> accelerated implementation of planes (and of plane switching). But it
> also leaves some leeway to different accelerated implementations, each
> of which can pick their own algorithm.
> 
> Conceptually I'd rather keep the possibility of userspace scheduling.
> But maybe it doesn't add much.

My preference is to keep plane scheduling at one place (in the kernel) to keep
it simple. But if you see a need for user-mode to interact there as well (only
really works for VSM), then I can add it.

I read a bit more about VSM and it seems their prioritization of VTLs is a bit
more complicated. VTL0 has the least privileges but boots first, then sets up
VTL1. But VTL1 is only higher-privileged once it is locked by VTL0. Another way
to look at it is that VTL0 de-prioritizes itself.

The patches here are built around the assumption that plane0 is the highest
privileged one and is always runnable. Running any lower-privilege plane must
be triggered by the guest. This is clearly not sufficient for VSM, the question
is how to solve that.

The answer depends on how IRQ delivery affects VTL scheduling in VSM. If a
VM has VTL0 (currently running), VTL1, and VTL2 (highest privilege), and an IRQ
becomed pending for VTL1, does Hyper-V schedule VTL1 directly or does it switch
to VTL2 (highest privilege) first to let it schedule VTL1?

When VSM switches to VTL2 first, then planes could just use a marker for the
highest-privilege plane (which can be non-zero). In the other case the solution
is likely to make the direction in which the vcpu->common->vcpus[] array is
traversed configurable.

-Joerg

