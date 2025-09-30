Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A2F2222C0
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 10:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228681; cv=none; b=udu3pJKJD+pfsUb2IW6WM/HMAxM3z2Zm1ky7X06pPWwSRkmBAMUirR/uXcOtRSil42onSueA7QL2YF+Q9RXujRBl37CuBlSgNLeXye52CKSyjXMyNu1RJXTAydHvx5Sx3dqs4Dk+k0IDwz3pguLLnQ8AMu8D8zRfNmhDVLdPLv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228681; c=relaxed/simple;
	bh=y4JDjPzSZQUmNDdZ57zXSn2NiK0vts9vcHgVa5jiiB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sohWWJJmsXDJa7apNmHYM8eQ/bfJ3xDm+taSCSRUcB9sbUS5ImAevZoXXxR84TllvNHeht1zNvxm+W7wVCmCQV6C6IKGlYvWi0OSxAnkau8MepWvciKlDj+EMokHYVm66aOclWRvVWeRouAvr9NvMDdrNu9FCoyCR7tePuyQEdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 831CC1424;
	Tue, 30 Sep 2025 03:37:51 -0700 (PDT)
Received: from [10.1.28.41] (Suzukis-MBP.cambridge.arm.com [10.1.28.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E73BD3F66E;
	Tue, 30 Sep 2025 03:37:57 -0700 (PDT)
Message-ID: <757bf2e1-c71e-4664-8cdc-7e2741993c32@arm.com>
Date: Tue, 30 Sep 2025 11:37:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 04/15] Import arm-smccc.h from Linux 6.16-rc1
Content-Language: en-GB
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
 oliver.upton@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
 aneesh.kumar@kernel.org, steven.price@arm.com, tabba@google.com
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
 <20250930103130.197534-5-suzuki.poulose@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250930103130.197534-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/09/2025 11:31, Suzuki K Poulose wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> Copy in the SMCCC definitions from the kernel, which will be used to
> implement SMCCC handling in userspace. Strip off unnecessary kernel specific
> bits.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Please ignore this patch, I fixed the subject to reflect the rebase to 
v6.17 and sent this in duplicate.

Suzuki

