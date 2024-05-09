Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE461D699
	for <kvmarm@lists.linux.dev>; Thu,  9 May 2024 04:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715229852; cv=none; b=bDVREpMcpH9l25+XpdpujDWvkW16a/Fw+iO5YFYhYaaKTEE1c6S+ciaD/m+C4xCYcyAddOD44x0DYLTCFTqCEmnwkGICJLJwGgrrBl+hXIahPDAmBRI/xuuPeVPbmmAkE+T52+ulkVaQ3vwFrlaPz0KzfXOMtrygbhT8+e3vGPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715229852; c=relaxed/simple;
	bh=Fc3E5HNqhMFRkZAZVGodrhk0AzqRqoxMkHauGrdrfMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BS+0+6j4A8q4Jmt6YZ4H2kTXr+qa8GjUiM2OClFGWYYM2KgzyoYmJkyuRdHW5CJY0H8x2S8GKEEz4aG8ctoFvxJhiR4f0UHXyoDRBWW8dWOgjGPJ8imlCoAWKssx3SkNbsUVRtNP8eMZASk+gMcpmpGR3yY9g/wKl1zlzi+LIZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19B15106F;
	Wed,  8 May 2024 21:44:36 -0700 (PDT)
Received: from [10.163.37.187] (unknown [10.163.37.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67F653F6A8;
	Wed,  8 May 2024 21:44:06 -0700 (PDT)
Message-ID: <416048ca-5b73-4fef-9a71-a9a8d08b7996@arm.com>
Date: Thu, 9 May 2024 10:14:09 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] arm64: Drop
 ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
Content-Language: en-US
To: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240418053804.2573071-1-anshuman.khandual@arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240418053804.2573071-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/24 11:08, Anshuman Khandual wrote:
> This series replaces custom macros usage for ID_AA64PFR0_EL1_ELx_64BIT_ONLY
> and ID_AA64PFR0_EL1_ELx_32BIT_64BIT fields, thus finally just dropping them
> off completely. This series applies on v6.9-rc4.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> 
> Anshuman Khandual (2):
>   KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
>   arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1

Hello All,

I am bit confused here, is there something more that needs to be done. It
seems like the previous discussion thread remained some what inconclusive.
Please do let me know. Thank you.

- Anshuman
