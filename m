Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A421A4BD36E;
	Wed, 14 Oct 2026 12:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791981666; cv=none; b=qxC0kEP+0QkKzQVYA8AYex+jfoh1dgNcFng4X40NBHjGBMog/DPDypVQE4+89/95uXfIPkTsQg1XWlMvWStw2k7VCANpTMdrGDmeMaGZqx9yErCnFmfah8QcZKjYjmhBGBBQe6F+4QTeaIatEAluiMkWdossiiph6Zy+cTTiyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791981666; c=relaxed/simple;
	bh=DsC4q+4yg6eLHkPxNVJf1vPqliSRaUMAYV//mcmB3hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mepoXH8cWoPbQNH4P2te78b1XqAJ7wTKkrID4hUS9J5eagESjRuqGGyoMY71TLbfQeyPgjlabC4JVD/HubxEqUyShx7BzuKB5wRpTejbdzTI0l7Kva3Jfx3aB+fAVA1AeHXVGiI0hV+UNkPgzqBxB3Fl/oz2VxAj5h2/DF8VSdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ROgEgrXY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ROgEgrXY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55DFF153B;
	Wed, 14 Oct 2026 05:41:00 -0700 (PDT)
Received: from [10.57.9.28] (unknown [10.57.9.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BA443FA32;
	Wed, 14 Oct 2026 05:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791981663; bh=DsC4q+4yg6eLHkPxNVJf1vPqliSRaUMAYV//mcmB3hs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ROgEgrXYixPVhlypL/B3nQZg0NGcVidZSj5LI1vGmvHnBWnkZBR3nmYvDZqFGSXoa
	 rdsP3QHD0SE3MVRl57iZU0wCiBlAPMEVTuQ9oaL6PFoH/0DWlnAFhwODlogUaspq8p
	 27yz/Hkuy71iI+sCFzo3yKRvT8q61TcwFRVNFsX8=
Message-ID: <d943b66a-c779-4b85-a7c6-d73ef9941dd9@arm.com>
Date: Wed, 14 Oct 2026 13:40:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 02/10] firmware: arm_rmm: Check for RMI support at
 init
Content-Language: en-GB
To: Sudeep Holla <sudeep.holla@kernel.org>, Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 tabba@google.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-3-suzuki.poulose@arm.com>
 <2586e689-c27d-4e4c-8c69-03e24259cb96@redhat.com>
 <8be050e3-8af1-4f04-902f-9bc01b209dd0@arm.com>
 <3fbd4739-a4eb-4428-95ae-ead22e7cf9f2@redhat.com>
 <799fb810-c33e-4d0e-9a70-7092c0a681ff@arm.com>
 <0ceda99f-0352-474b-a30a-c5e79b817c2d@redhat.com>
 <ade8dd16-4f09-47d0-a821-636ca4c62565@arm.com>
 <20261014-victorious-prompt-kelpie-cf3a87@sudeepholla>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261014-victorious-prompt-kelpie-cf3a87@sudeepholla>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/10/2026 13:05, Sudeep Holla wrote:
> On Wed, Oct 14, 2026 at 12:06:54PM +0100, Suzuki K Poulose wrote:
> 
> [...]
> 
>>
>> Then it is RMM's problem if it doesn't check that the right level of
>> SMCCC version is not implemented by the EL3. Also, where do we stop
>> the checks ? e.g., We need SMCCC >= v1.3, when SVE is supported.
>> And >= v1.4 if SME is supported. Shouldn't we leave this to the RMM
>> to verify on init and fail the init ? I can raise this with the
>> tf-RMM team.
> 
> Fair enough for v1.3+/SME/SVE checks, but RMI interface relying on more
> that 8 input registers for one or more of it's interfaces (e.g.
> RSI_ATTESTATION_TOKEN_INIT, RSI_MEASUREMENT_EXTEND, ...etc) indicate
> it can't work with SMCCC v1.1 or below

Fyi, those are RSI interfaces (Realm Guest facing) and we could add the
checks there. This series is the Host facing interface. That said I
will send a fixup to add the check for v1.2 for RMI too.

Thanks for the feedback, both!

Cheers
Suzuki

> .
> So IMO check for v1.2+ is completely justified here.
> 

