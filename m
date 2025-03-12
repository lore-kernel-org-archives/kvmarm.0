Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DAD15853B
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 03:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741751202; cv=none; b=Dg58AnvWupkcPirMdQkF09onjdyylK0j0dBBfrJHZ5KP4a/OaGoSeBcmgUFGQEgaji/nhYqwUezrraGq1T6TmvXYSrhUf3QQGzcwNkIk8ejG43AIbmyWQ1/ZKoVCe6y9v7kZDwVCYmVw2oRcfL8Z/uL+AD7I7CTQV54RqTLfWiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741751202; c=relaxed/simple;
	bh=wSmsYXQwq2KIR0p4DlTdv2Vm5LsbunwE7dZD2K2TaAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riVSjj+hEFm8c9WnBZqtLm/hV10KLS5M4LW30ynNLNktE0XicxCiJzaPq8R2ZcgzGX8h8JnwMHHECAX4rjdW+zhwj7PadcO8nYpjVZEJeg+N/rkneBLF32Uy/+8xN823Rne1D2ssBxMkzUdMgRHyariCpIFAkaXAcN5C44mtcdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C775C152B;
	Tue, 11 Mar 2025 20:46:50 -0700 (PDT)
Received: from [10.163.43.50] (unknown [10.163.43.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 570513F673;
	Tue, 11 Mar 2025 20:46:36 -0700 (PDT)
Message-ID: <ddeb3df1-995b-44f4-ad20-50edfb906a28@arm.com>
Date: Wed, 12 Mar 2025 09:16:32 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
To: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, robh@kernel.org
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, stable@vger.kernel.org
References: <20250227035119.2025171-1-anshuman.khandual@arm.com>
 <174171335999.3659520.16613654046629962007.b4-ty@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <174171335999.3659520.16613654046629962007.b4-ty@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/11/25 22:47, Catalin Marinas wrote:
> On Thu, 27 Feb 2025 09:21:19 +0530, Anshuman Khandual wrote:
>> FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
>> access from EL1 requires appropriate EL2 fine grained trap configuration
>> via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
>> Otherwise such register accesses will result in traps into EL2.
>>
>> Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
>> grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
>> bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
>> PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.
>>
>> [...]
> 
> Applied to arm64 (for-next/el2-enable-feat-pmuv3p9), thanks!
> 
> [1/1] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
>       https://git.kernel.org/arm64/c/858c7bfcb35e
> 
> I removed Cc: stable since, if it gets backported automatically, it will
> miss the sysreg updates and break the build. Please send it to stable
> directly once it lands upstream, together with the dependencies.

Sure, will do that.
