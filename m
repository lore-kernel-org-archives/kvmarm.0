Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A1224B03
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756972831; cv=none; b=jJkl5T7CMWJAvqtNZQyAx+NplbERwkOczA1lTYwDy/VIA0nJgZyhhzofL8ANcbTtT/pp4x91Xvusvqm/JB3hNXTIWDjeIJRk1CQNdrdUsoBoPnY3ot87jNSWU1wjZgkEGwsVC8Hd5IKGP2fZ3tge3RnD5PhG3Kh3f6slitPVOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756972831; c=relaxed/simple;
	bh=uKzJr6A+/f1KPZ+p0swkJX5VeTzM4DDwaeveKoHzKFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3vo31x9lLP4nMTthAGfUJlHh3Ux1x+cbIiw8z2TM5k6/1f/czDskMv1/i/6ZiMHi9WHPbi4lw2nb7VsPrFDCmNhMb25dUPFaMRFl15bH0XnuehfvcSQ3zkVzqZ495yQbLAuuTMCKj3JRy+BvfY6/Jlo3FHkwCIkQn8HOeRxcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tbjDuSDa; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tbjDuSDa"
Date: Wed, 3 Sep 2025 23:55:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756972826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OmX5Pq7jfd5FzhfjR9wnPLjhNm2M1cF7IIhjksMYdsI=;
	b=tbjDuSDakHEfcVYr/n/bNLfegBIaJ9t8nplAQtUlsEpGaIkGxJRojABDG/FyPnxsLCSME9
	PwzS6R+OywkMOUAhHb53Iuj8KvV+wvMlxzTKSNpK4EPHBw1yJ3Qv2EJb4Ko2/xEYB0y6Ua
	pR9LjKNOgTeVqHe0ooImOyHQkTbLfuU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: VHE: Save and restore host MDCR_EL2
 value correctly
Message-ID: <aLk38kyxyoe0CYq-@linux.dev>
References: <20250902130833.338216-1-alexandru.elisei@arm.com>
 <20250902130833.338216-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902130833.338216-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 02, 2025 at 02:08:33PM +0100, Alexandru Elisei wrote:
> Prior to commit 75a5fbaf6623 ("KVM: arm64: Compute MDCR_EL2 at
> vcpu_load()"), host MDCR_EL2 was saved correctly:
> 
> kvm_arch_vcpu_load()
>   kvm_vcpu_load_debug() /* Doesn't touch hardware MDCR_EL2. */
>   kvm_vcpu_load_vhe()
>     __activate_traps_common()
>        /* Saves host MDCR_EL2. */
>        *host_data_ptr(host_debug_state.mdcr_el2) = read_sysreg(mdcr_el2)
>        /* Writes VCPU MDCR_EL2. */
>        write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2)
> 
> The MDCR_EL2 value saved previously was restored in
> kvm_arch_vcpu_put() -> kvm_vcpu_put_vhe().
> 
> After the aforementioned commit, host MDCR_EL2 is never saved:
> 
> kvm_arch_vcpu_load()
>   kvm_vcpu_load_debug() /* Writes VCPU MDCR_EL2 */
>   kvm_vcpu_load_vhe()
>     __activate_traps_common()
>        /* Saves **VCPU** MDCR_EL2. */
>        *host_data_ptr(host_debug_state.mdcr_el2) = read_sysreg(mdcr_el2)
>        /* Writes VCPU MDCR_EL2 a second time. */
>        write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2)
> 
> kvm_arch_vcpu_put() -> kvm_vcpu_put_vhe() then restores the VCPU MDCR_EL2
> value. Also VCPU's MDCR_EL2 value gets written to hardware twice now.
> 
> Fix this by saving the host MDCR_EL2 in kvm_arch_vcpu_load() before it gets
> overwritten by the VCPU's MDCR_EL2 value, and restore it on VCPU put.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
