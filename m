Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0B21C862D
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682942; cv=none; b=qWEpZZEcpVOu82+WOZ9ImdGrUrtJHfSMMT2QCfzkkes6dL+E1t92MxnxUdohLk1crC6fB0AhKvwkgo/EWNgslHTP3DIie62+d5jydThQVRyYjL2MmGeKpyFYafIzYYtuSK3KX+rlmGWUFpM10Oir8YAOR30PfjCLdHJNmXvrNAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682942; c=relaxed/simple;
	bh=MJaTRmwCR/DGKIesmp2mo6CRb8Z4VCmZslfpkVNhqco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYUS4Wdz4arMfZfyMorDZ53TwR8j5elngZv1kG0Mw9ZNs1kiD8XbNs8cn3TN9bdHXmiHn/Ku822/dY/U12NL59bpEVqeGtGLA+4VUrKjWiIXHXNAMMbDi3lkkPHn6Zy+ys3GOUYOn+Pwwnv3ej1VoewvBmJiJw53SpOW5S4R/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D40CE1476;
	Mon, 16 Mar 2026 10:42:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F04F63F73B;
	Mon, 16 Mar 2026 10:42:15 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:42:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 03/30] arm64/fpsimd: Decide to save ZT0 and streaming
 mode FFR at bind time
Message-ID: <abhA9XcFk3_Jji85@arm.com>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-3-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-3-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:55PM +0000, Mark Brown wrote:
> Some parts of the SME state are optional, enabled by additional features
> on top of the base FEAT_SME and controlled with enable bits in SMCR_ELx. We
> unconditionally enable these for the host but for KVM we will allow the
> feature set exposed to guests to be restricted by the VMM. These are the
> FFR register (FEAT_SME_FA64) and ZT0 (FEAT_SME2).
> 
> We defer saving of guest floating point state for non-protected guests to
> the host kernel. We also want to avoid having to reconfigure the guest
> floating point state if nothing used the floating point state while running
> the host. If the guest was running with the optional features disabled then
> traps will be enabled for them so the host kernel will need to skip
> accessing that state when saving state for the guest.
> 
> Support this by moving the decision about saving this state to the point
> where we bind floating point state to the CPU, adding a new variable to
> the cpu_fp_state which uses the enable bits in SMCR_ELx to flag which
> features are enabled.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
