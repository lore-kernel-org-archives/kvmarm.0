Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A885324B221
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736535009; cv=none; b=uMSJPf01UXY9XZcOA8YfttXM24s4lWDlRxToxFUf/yGxJEeCCr7l8auw7BHh/8+/n62MYUEvKf6Kv82WO0PYU0/d/CbyAjOoMSM/KwstzM4XB3zmu3QexZaFLYCNfLT2Beb49mjngE7RFEuFmsu42ha3W+J7pMuMd5HNrLrlJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736535009; c=relaxed/simple;
	bh=/gIkmsQZB37jgMlTTmkv/z2Ny4uHY6HLddCtlLMpaqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut2rghKS4Kxh9E4DenT2LlfVQpaAUBdkVwoisajWxZlWsYmkuYA6uhyYpq1oWhXsBH47s/KaGJWzwvF3uaRTHShI6bKkRLl5oAJJGkpy2r7m8crFKDUDbD+hr7ZvBFGFGBfKxkthUQ70ITWc4JlIWVkdoDfhwtUSesXP5GSGi5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XmxUH1K5; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XmxUH1K5"
Date: Fri, 10 Jan 2025 10:49:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736535004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5jSwLJoG7dee5g+IYw1k00x4GMomga97dhl8oz4ghiw=;
	b=XmxUH1K5Mz1roIxUU7KJg0dQeedtL5n23up15s5LS/dj7Up5NaHx4HgmVCh6Yp9hO5Rv/x
	S1eOcB1PZHFwK0fXE1P1Ld6v3O4dQ1lC3tr/1Fruf8GAt1hWQGUxaeLaar/sZxXfNOL7W1
	9V+VAo3LXUJUUiJb9eZUTmEV0DcnMks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com,
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1] arm64: Add TLB Conflict Abort Exception handler to KVM
Message-ID: <Z4Fr1HkKCm9AXSIA@linux.dev>
References: <20250110172411.39845-3-miko.lenczewski@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250110172411.39845-3-miko.lenczewski@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 05:24:07PM +0000, Mikołaj Lenczewski wrote:
> Currently, KVM does not handle the case of a stage 2 TLB conflict abort
> exception. This can legitimately occurs when the guest is eliding full
> BBM semantics as permitted by BBM level 2. In this case it is possible
> for a confclit abort to be delivered to EL2. We handle that by
> invalidating the full TLB.

typo: conflict

Also, a bit of a nitpick, but mentioning that TLB conflict abort routing
is implementation defined when S2 is enabled is valuable information.

> @@ -1756,6 +1756,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>  
> +	if (esr_fsc_is_tlb_conflict_abort(esr)) {
> +
> +		/* Architecturely, at this stage 2 tlb conflict abort, we must
> +		 * either perform a `tlbi vmalls12e1`, or a `tlbi alle1`. Due
> +		 * to nesting of VMs, we would have to iterate all flattened
> +		 * VMIDs to clean out a single guest, so we perform a `tlbi alle1`
> +		 * instead to save time.
> +		 */

I'm not sure I follow this.

At this point we've taken a TLB conflict abort out of a specific
hardware MMU context, and it's unclear to me why a conflict abort in one
stage-2 MMU has any bearing on the other stage-2 MMUs that could be
associated with this guest.

Even in NV, KVM is always responsible for the maintenance of hardware
stage-2 MMUs. So stage-2 TLBI elision in the guest hypervisor should
not lead to a stage-2 TLB conflict abort.

TLBI ALLE1 is a larger hammer than what's actually necessary here. Could
you perhaps introduce a new invalidation routine,
__kvm_tlb_flush_vmid_nsh(), that does a TLBI VMALLS12E1 behind the
scenes?

If an NV guest is playing games at stage-1 across VMIDs then it gets to
suffer the consequences (additional TLB conflict aborts).

-- 
Thanks,
Oliver
