Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422E93C10BE;
	Mon,  5 Oct 2026 08:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189070; cv=none; b=PKFwYOSE0BuWsjAgUErlpLXR7HscYuviBNzFJJRpUpdILtHI6qL3SgCOA2mEWPtLdc4xEF0ismnuU8u8nFW5IzcaRXEGdq5OQIaMwZ/txIT7glSHCLuZ2R0/ZBQQXXEcVQY2OiUR2Rt2RXvkeaVuenjFcx3k/oKVG4ECGozVagY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189070; c=relaxed/simple;
	bh=p5j1tVtGImF6mr2cxwmxFFMWCEsHi20IPSFC1HEmhaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hz8OcXcpJW13NDtxC6RaBOSYWJJhjqvVQrNKNtJ9h9rr3F/s2nkrGsHfnEBYe71AZSwqhZ0ryggnrOqV044bo045LCKJNDeXr6qLBdT68u7l/gawsAyMgoq3TYmUzc91y6aYPcGjXsd1YFiNsMekasO0iqpebsQuVtVd96rEOvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7coYvwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7coYvwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AC91F000FF;
	Mon,  5 Oct 2026 08:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791189064;
	bh=+vMssXeFUWuK2+atRP/yY0Yi3PMPF4xdx4cHzEXP+mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i7coYvwAbK+cQxKJ9kh7zGq3agGxzKHndRn15xPbhOADf5QKOA/QmN6EBGXpj+xgU
	 JLmUQ/mtLLln+nMvG1tlxw8rOf7Oh+RJqlXXRR1K8MB1OPpJWYsp3JrKhUHFUlKQ3/
	 EukvSCTM8MhAcOm1Pk5ul0Vrzj5m8RysAwXRZoArbtFeVx5ZqwfPb2gltLF7rMx1IR
	 QftH+u8ya46m6O8XLTIPMUf/QVgClpZAuv/roONQKKozDDh1tGXIy5gS2xIFOmeNKy
	 rHwVL4UqsZRSrzcpPknKZS8rwF1gipw4+GIXwJEHzjuA0rV0kVnNY1S8ids0vyouJt
	 MU3Vy+k1aSquA==
Date: Mon, 5 Oct 2026 01:30:56 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com
Subject: Re: [PATCH] KVM: arm64: Pend host SErrors for protected vCPUs
 through HCR_EL2.VSE
Message-ID: <asNgQDxNQP9Gll-p@kernel.org>
References: <20261005050352.836980-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005050352.836980-1-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Oct 05, 2026 at 06:03:52AM +0100, Fuad Tabba wrote:
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index d6c4fc16f8795..49a342b078365 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -378,8 +378,11 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
>  	 *
>  	 * As we're emulating the SError injection we need to explicitly populate
>  	 * ESR_ELx.EC because hardware will not do it on our behalf.
> +	 *
> +	 * A protected vCPU's PSTATE and SCTLR2_EL1 live at EL2, so pend through
> +	 * HCR_EL2.VSE and let the guest's own masking apply.
>  	 */
> -	if (!serror_is_masked(vcpu)) {
> +	if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu)) {
>  		pend_serror_exception(vcpu);
>  		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
>  		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));

The emulated injection is only necessary when vcpu_has_nv(), it was just
convenient for the sake of testing that everything short circuits to
emulation instead of VSE.

I see Marc suggests letting the stale PSTATE.A value force the desired
behavior which seems fine to me. If that doesn't work, I'd rather
emulated injection be predicated on vcpu_has_nv() than
vcpu_is_protected() with the appropriate rephrasing of the preceding
comment.

Thanks,
Oliver
