Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4326FB9
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751996373; cv=none; b=Ve8tlcxibaRQ64UTtO4pbubIM6mhcFF4/bjKKVFKEHc02EPYd9V/lYYHu6FC04j0PjU84Tf+3zb+Jq0nOIqezb2NjbEE1MWMVqt2YlUy5kh/55SdR4qnzEYeTQZywny1K4+agBSCJWEFzaE6OcB9tL5R2LMBBAefK8Wdw55wYDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751996373; c=relaxed/simple;
	bh=g5v+Rqi6RSC18X58qMN2ePrxFCstWb22yWYkKhwFYCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rg1jN2DMgeXLP5QvEfA9dAjUr79Y78sWcxqiFLktrLVlTNDRp1H8nOOzlok8BV22X+z9tGmunF8bbqZ/ftAiLmLpSssHrvRF490iDN4LQkJVMGjQLRFgb1J1g4eyPR/TeAFrIy2g0h9HgFPip8GzWGYIx863JLCbqGIwRSkDeOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t06+9kG7; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t06+9kG7"
Date: Tue, 8 Jul 2025 10:39:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751996370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSgptzDkCeagBCMzSzSn5dUXX8T0l7PBWDrISp2A85A=;
	b=t06+9kG77LPLa1MO1u5J12SqRT3XLQlq/oEdNt1A747wfnfE+W3R1SVOqkE7/jjzPbPdyQ
	pj9xkF50HE2WDX/9113k3XPOnjlPTs9RLiLk3MU+rr+Xazb+CZE+Mx8ZSrr/pfN5eicHNz
	dHDZtf7VIoBIw7pxbBWiwku+6e6WJgA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 08/27] KVM: arm64: nv: Use guest hypervisor's vSError
 state
Message-ID: <aG1Xyi99JRpKCoIs@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
 <20250708172532.1699409-9-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708172532.1699409-9-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 08, 2025 at 10:25:13AM -0700, Oliver Upton wrote:
> When HCR_EL2.AMO is set, physical SErrors are routed to EL2 and virtual
> SError injection is enabled for EL1. Conceptually treating
> host-initiated SErrors as 'physical', this means we can delegate control
> of the vSError injection context to the guest hypervisor when nesting &&
> AMO is set.
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Grr, I scrapped a fixup by accident for this patch. Squashing this into
the series:


From 568c69139ced56362028b50fc4751295cea36985 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Tue, 8 Jul 2025 10:37:16 -0700
Subject: [PATCH] fixup! KVM: arm64: nv: Use guest hypervisor's vSError state

---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index faca2b7211f1..a17cbe7582de 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -308,6 +308,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 {
 	u64 pstate = to_hw_pstate(ctxt);
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
+	u64 vdisr;
 
 	/*
 	 * Safety check to ensure we're setting the CPU up to enter the guest
-- 
2.39.5
