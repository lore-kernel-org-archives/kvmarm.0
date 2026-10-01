Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1473C6600;
	Thu,  1 Oct 2026 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870041; cv=none; b=bnRbNudXdHo4dgIak9cVdCwfr/Nd63FMHXpe+D+OT14crx+bTlTxc/x9ky//gnWsMgOIp935SRys3a0FfTmfMoMACw6QF0hYaFxFgeIa63YiDfgPcAOLIx204K7XWE4MU/q5AWx3j2YipPNm337FH7QYyEaR7OIO2gf6mbeh9o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870041; c=relaxed/simple;
	bh=brRPLivSgp8jybcJZM5iSl0Fx44Zqh0P2ZiJmBX1NY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/bueafcXMOoMrc+mWHkPkRJT/OMS0o0vGD5uf4QDNCkhjNba2+O9LLhoqYlQLb66AeJDSST/IHjETCaBaRxIsafxEYYNMYPEHem/fUxLZsH2yhueQU9zJCTRuzNeveg9VnKkv1hZ35xM80q0MVNwesGTKy8rTcukMlK9+zpaL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=icz1EVIw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="icz1EVIw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84B8D497;
	Thu,  1 Oct 2026 08:53:55 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D9613F86F;
	Thu,  1 Oct 2026 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790870038; bh=brRPLivSgp8jybcJZM5iSl0Fx44Zqh0P2ZiJmBX1NY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=icz1EVIwOxQcL/dRlhcFbwaGgJVDPf80GpsgcCQIEVxmntd+cxXCmGFMpyhH6Dt7x
	 wJ4dmg1XSGLRP1OmqWrupvvlDQZque9l0VC0PMngzTd18jTryaimkSgOQCSlv5EJI/
	 1C9QbeeaLIaqeMZHTlRUAEfyPRQlLLAutMOOrYwU=
Date: Thu, 1 Oct 2026 16:53:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH v20 22/22] KVM: arm64: CCA: Control user register access
 for Realms
Message-ID: <ar6CEXfo-AIYtq1J@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
 <20260924160504.853911-23-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924160504.853911-23-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 05:05:04PM +0100, Suzuki K Poulose wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM restricts the access to the register states that the host can
> read/modify for a given Realm.
> 
> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>       While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>       requests.
>       MMIO emulation in the unprotected space.
> 
> Additionally we use the sysreg configuration to advertise/configure the
> following Realm parameters, which are required before the Realm Descriptor
> :w

Should use Emacs ;)

-- 
Catalin
