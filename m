Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7802116F7
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742396131; cv=none; b=hRcj7QgjkFwbJJLTVc50I//YaL8ry2rigt1KVA88QYtodO7lEQfto1neF7OOcg98y+9RyyQlx/TigbfxDOmHw1Xb3k4ZPc2wg1fSyPVwNzNQKR6Ch/Yrs3NyJyHZUmUjJRSsbXGAtZ29Bi6Dfk0z61VrfOLviuQ2SlDD+5KtYs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742396131; c=relaxed/simple;
	bh=WnQ+FuFaF+koDcvuXC70dNnZjwr287lNrdYcRE2s+ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIS7lL1eMfbPRMCvOFITBLNRESCAm9NzLqiAuGlCPLPiLUdkMMIEwWirDSPiS4gf8XXsfBqFKhjjINiXyyP7o7wyPp8oWnEGnHM0yg+ZW/dmzqN84mZLylC/RCP+I0xtt8FjB8etPUzpMEHz6sbTTzmLmMkqIQwQ/FTPJTwZdgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66DB0106F;
	Wed, 19 Mar 2025 07:55:37 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FD2D3F694;
	Wed, 19 Mar 2025 07:55:27 -0700 (PDT)
Date: Wed, 19 Mar 2025 14:55:24 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kvmarm@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fast model boot failure with Linux next-20250312
Message-ID: <Z9ra3I2axii2HRVb@J2N7QTR9R3>
References: <CA+G9fYvPu+MQKhYyPZSSDpAn-zhRGmeHQ8hJksT_cdDdxfbB-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvPu+MQKhYyPZSSDpAn-zhRGmeHQ8hJksT_cdDdxfbB-g@mail.gmail.com>

On Wed, Mar 19, 2025 at 08:07:47PM +0530, Naresh Kamboju wrote:
> Regressions on the arm64 Fast Model (FVP-AEMvA) caused boot failures starting
> with Linux next-20250312 and persisting through next-20250319.
> 
> First seen on the next-20250312
>  Good: next-20250311
>  Bad:  next-20250312 .. next-20250319
> 
> Regressions found on FVP:
>  - boot
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducible? Yes
> 
> Boot regression: Fast model boot failure with Linux next-20250312
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders bisected this to this commit id,
> 
> # first bad commit:
>   [858c7bfcb35e1100b58bb63c9f562d86e09418d9]
>   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> 
> NOTE:
>   LKFT is currently running FVP Fast Models version 11.24.
>   Planned upgrade to the Fast Models version 11.28 in this sprint.

What firmware (and version therof) are you running within the model?

For example, if the EL3 firmware lacks support for FEAT_FGT2 or
FEAT_PMUv3p9, the kernel will trap to EL3 early during boot and die.

It would be really helpful if you could capture that in the report in
future.

Mark.

> 
> ## Boot log
>   <No crash log on the console>
> 
> ## Source
> * Kernel version: 6.14.0-rc7
> * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> * Git sha: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
> * Git describe: next-20250319
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319
> * DUT: arm64 Fast Model (FVP-AEMvA)
> * Toolchains: gcc-13 and clang-20
> 
> ## Build
> * Build log: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675685/suite/boot/test/gcc-13-lkftconfig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250319/testrun/27675691/suite/boot/test/gcc-13-lkftconfig/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2uX2EtC2pQdmVZ7ccoyhoi01Yy0/config
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
