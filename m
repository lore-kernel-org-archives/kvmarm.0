Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DD36BFC0
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751277924; cv=none; b=PM0pBbnMlS+QNEzQzDlbLZMTGbY/D9PHz31qd50cOBOXUc7Fr8Ux3SI7ibzwTNU1ANaL7jsb2ZOv8re5fQHlLPWJSd3qOOwF+RiVlb9ZnjdMN4EJoC+6XtCUlStpzGGwTCFvwf1W0tpMNSIzxslmNBDMm5Fr2YlTtjjR7s9mI9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751277924; c=relaxed/simple;
	bh=QQGT174PX3/LjslGR9uakewdT3W7VpHe5+lxPz565X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mA52p1yLmBL66fawq7c0KWpEd2ywiqNfhfiLHonWCXR6pKP/10W2pgD3Nz4oNR5nAjFQe04lph4yeDQQ2Qb7GAmDjB1R5iKhP2u6maS0klSOMIAN2QkAFp54RWmEkGyUG7ilyqPYSMTD3cU/J1QugO30FZ2s58Oz1vov8/EkwSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CA581D34;
	Mon, 30 Jun 2025 03:05:06 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14EF53F58B;
	Mon, 30 Jun 2025 03:05:19 -0700 (PDT)
Message-ID: <77dd46da-85ea-442a-a05e-d54c56b51786@arm.com>
Date: Mon, 30 Jun 2025 11:05:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] arm64/hwcap: Add hwcap for FEAT_LSFE
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <20250627-arm64-lsfe-v1-0-68351c4bf741@kernel.org>
 <20250627-arm64-lsfe-v1-1-68351c4bf741@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250627-arm64-lsfe-v1-1-68351c4bf741@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/27/25 18:20, Mark Brown wrote:
> FEAT_LSFE (Large System Float Extension), providing atomic floating point
> memory operations, is optional from v9.5. This feature adds no new
> architectural stare and we have no immediate use for it in the kernel so
> simply provide a hwcap for it to support discovery by userspace.

nit: s/stare/state/

Thanks,

Ben

