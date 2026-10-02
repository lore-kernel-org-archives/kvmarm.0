Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD82032D42B;
	Fri,  2 Oct 2026 11:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790939156; cv=none; b=q+FSTd2GsE1kfm8oZ2SlVQ+paInfgLx0FF0+xfarXslsV6GbcOjUfpj9ZfXzRTmfIphNCBGRSYDyO5s8q7YaW3Tkvmo3e9Pl7YSiufTu+1WkUSMU9Jq5vR1gY8+qaU2/XEG1UzC0loJ6HeNqsSxL/9+gJ6CR/mWv9HK8xPCjeOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790939156; c=relaxed/simple;
	bh=mGxeAZM+Ponxf7bCZvYiqPovJdLJZY0Gu2OJSveg5yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S00D9tc8rxg5v5HIc9toZLPL1pZ/RXc+WtKvxqusIQdyOBbyNpfaXiNjugP+0HY1vIui6DxGihZaJJTwjr0m3OKRTm8ol9SFkLiJ52z76PcYre/l17XcAJUa4du6+5sCd8Vodz3q5hu3FZSulWe3xdXCIyTt9CC8r7seN/5bmCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sjtm30iC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sjtm30iC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C33882F;
	Fri,  2 Oct 2026 04:05:50 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDD4B3F85F;
	Fri,  2 Oct 2026 04:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790939154; bh=mGxeAZM+Ponxf7bCZvYiqPovJdLJZY0Gu2OJSveg5yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjtm30iC6/CPpL985bC1ofmm5brYJLUn0kVQO18G8RhH2Yh5XOrHs3SsdZSxVnIBr
	 Z/ZDfixwIcvnwqCiOApssi0HAtdlApZuOjb8i+fYedE9DrYrKTnkCguT5SitK9lTqa
	 twTPa+U5uMzBfeke9T34bxpoggTWrkDluMgnbhWw=
Date: Fri, 2 Oct 2026 12:05:47 +0100
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
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v22 09/10] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Message-ID: <ar-QC4vtcULyJ5dW@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-10-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002061507.1600269-10-suzuki.poulose@arm.com>

On Fri, Oct 02, 2026 at 07:15:05AM +0100, Suzuki K Poulose wrote:
> +/*
> + * rmi_smccc_invoke_once: Invoke the RMI call and return the results. Do not
> + * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
> + *
> + * @regs: Input parameters filled in. Updated with the ouptput results
> + * after the call.
> + */
> +static __always_inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args = *regs;
> +
> +	arm_smccc_1_2_smc(&args, regs);
> +}

Nit: I mentioned on v21 - is the copy to args still needed? Can we not
do just:

	arm_smccc_1_2_smc(regs, regs);

(no need to respin, I can fix it locally)

-- 
Catalin
