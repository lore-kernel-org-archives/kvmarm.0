Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CAF4EFFD4
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563471; cv=none; b=JrBED8JROtIipMqveqksr3iOLt197ag54HHd/SC5egKD0ooP5M45jTaYsFG4XNW2rr4i8B5hgkMHJwoZvCn+n98vdMoMyU2WSOxq3N2oQUx0SgL2wI87GgB9hDEkMPzf/2pHQJbTwo8MXLfYnoYCteEUn42QmD9rITVLnRHlTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563471; c=relaxed/simple;
	bh=lb0DeCf/KMhA4VhiVFBNKtdZtnLIGHb27hHQyGK+1W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d97TMyKiF/2r2D5ToRGKmuhSm30Ub+WaHSDxlAnWib9uTTRBse9U07nPkKaF8v0sMKtIHxsZq8u5y6uEpP/ONN67vvfK0bOF3iBwOePH3GKxl1kOLKD6+dHSjB26GiMDZM0YkG1W5jfOVZDC+1z92V1ss/pQI/s574nnh6c2YfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m9UDeTbF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m9UDeTbF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA7EF1D14;
	Fri,  9 Oct 2026 09:31:04 -0700 (PDT)
Received: from gentoo-vm (kajpuc01-mac-mini.manchester.arm.com [10.33.9.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB3983F66F;
	Fri,  9 Oct 2026 09:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791563468; bh=lb0DeCf/KMhA4VhiVFBNKtdZtnLIGHb27hHQyGK+1W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m9UDeTbFdfgXuDllcP0z+USXUbNALllDc1DrHcUzL3liG/CBnASY0XhUCXBbbzmAO
	 Kz/iBNI9RzRw2LPWu/iPYZUBCVHY4dZzx62fu9BxbmdsvbTZEg9hkbFRFoqAx4clpt
	 QWOeK+lXzn91zzicw8rbyu1fp88aCGpscI7oibxQ=
Date: Fri, 9 Oct 2026 17:30:59 +0100
From: Kajetan Puchalski <kajetan.puchalski@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Jing Zhang <jingzhangos@google.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] KVM: arm64: nv: Don't loop on AT S12E{0,1}{R,W}
 with an invalid VTCR_EL2
Message-ID: <k6hsxo35ou3b5bcdo5xiew56zo25c4dmxqocnxszjvuqd7ct44@owruwfstprrh>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
 <20260928152507.2116110-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928152507.2116110-4-fuad.tabba@linux.dev>
User-Agent: NeoMutt/20250109-134-7b7c50

On Mon, Sep 28, 2026 at 04:25:00PM +0100, Fuad Tabba wrote:

(..)

>  	stride = wi->pgshift - 3;
>  	input_size = get_ia_size(wi);
> -	if (input_size > 48 || input_size < 25)
> -		return -EFAULT;
> -
> -	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
> -	if (ret) {
> +	if (input_size > 48 || input_size < 25 ||
> +	    check_base_s2_limits(vcpu, wi, level, input_size, stride)) {
>  		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
> -		return ret;
> +		return 1;
>  	}

While at it, we could also add a check to validate that the ipa being translated actually conforms
to the configuration. As per the Arm ARM (R_DRRZZ):

> When all of the following apply, the stage 2 translation IPA size check generates a stage 2 level 0 Translation fault:
> • Stage 2 translation is enabled.
> • The input address to stage 2 translation, whether or not stage 1 translation is enabled, is larger than the IA size
> configured in VTCR_EL2.T0SZ or VSTCR_EL2.T0SZ, as appropriate for the IPA space.

Currently we just clear out the upper bits of an address larger than the IA size and proceed, but
the architecture requires that to cause a L0 translation fault. Not that it's a particularly common case.
That is to say, I'm suggesting something like the following:

+ if (input_size > 48 || input_size < 25 || (ipa >> input_size) ||
+    check_base_s2_limits(vcpu, wi, level, input_size, stride)) {

