Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EA11C4A1B
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733906061; cv=none; b=hMmt41Qno5tmz5w4QLYynp+86wnGWI9SJ+ucsC4nRccmw0blbpHmMrXmsxg8ZBfHrWSurjRNIKJbwTij9otRZtj8VLVTMaxY94XVFs986mfVJ7klax2aVq575aiQB+rd4F1xU8b1gvNwPlAfbDLXZgxSYkVB5IaCGHizmAz4fJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733906061; c=relaxed/simple;
	bh=T8hktlKaRyGbVHCVpye89ZWee6gbJk6eenpzIhLg7YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vb9C5PNQnhiILcra7ZZFH4OREHv22OsjWeG2Y4RZoMPEMZlp7m+GZsdH7X4uzoR8s6A6eZRRtpE7BsnuXcT9Jt4Vl5AIrggVIQbHgWiw5ndsp+tvwhEZ9AvO1ufu78D6fT1oWcKUq3nE4PI9n2C82e0mVfDhipbfnFPNS/0vckM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E978E1063;
	Wed, 11 Dec 2024 00:34:46 -0800 (PST)
Received: from [10.162.16.49] (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7933F3F720;
	Wed, 11 Dec 2024 00:34:15 -0800 (PST)
Message-ID: <86ad5edc-ad57-43c3-86d2-0bd854a479c5@arm.com>
Date: Wed, 11 Dec 2024 14:04:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <Z1hzdLQLlIPg7eV5@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Z1hzdLQLlIPg7eV5@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 22:29, Mark Rutland wrote:
> On Mon, Oct 28, 2024 at 11:04:19AM +0530, Anshuman Khandual wrote:
>> This series enables FEAT_Debugv8p9 thus extending breakpoint and watchpoint
>> support upto 64. This series is based on v6.12-rc5 although this depends on
>> FEAT_FGT2 FGU series posted earlier, for MDSELR_EL1 handling in various KVM
>> guest configurations.
>>
>> https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/
> To avoid further confusion: since we discussed things further on the v1
> thread after this v2 thread was posted, I'm waiting for a v3 to be
> posted which addresses the comments there (e.g. ID reg field handling,
> mutual exclusion for breakpoint manipulation).

Agreed, although I am still working on the mutual exclusion for breakpoint
manipulation problem. Besides just carved out - MDCR_EL3.[TDS|TPM] related
EL3 boot requirement's document update in a separate series as discussed.

https://lore.kernel.org/all/20241211065425.1106683-1-anshuman.khandual@arm.com/
