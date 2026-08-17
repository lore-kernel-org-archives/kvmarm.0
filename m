Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B0E436361;
	Mon, 17 Aug 2026 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978608; cv=none; b=IKqq1VW50inC8RC8vQpdT4eP9NebM43thXbCYL5SyLjd+V0d67jDWxZV0WoJs/KjUYWsneyO+R+EeaZo98FB/hmnFn1f65YN73HgKZA2YwBkzIDgTXcZuyrbbIdx2iJtzlzYSqMJY01qSFQSpO3e+muyjXAF2aqIMcR4q9NrwLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978608; c=relaxed/simple;
	bh=7dV1b0+NGUpOKXsz67zjTQC+6a3hvUjM7P7OhPtyxIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hu2lUvi6p8sW+ncebrN5rZkdhhowAARodDTYDzguneBU5GqKY0TtGmgf9lQ0a6AnVBicdZeoAXblFaLa4Kg0IGgUfoDeHW/4hQyX1OOdqX2PIXZRlBKyWXYniVkz3aAH8VXCa9X6vqlnRigMsSh3bSLfHMenltY+DYJzV9XI5vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q5wKL9yY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q5wKL9yY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E4E41655;
	Mon, 17 Aug 2026 07:56:41 -0700 (PDT)
Received: from [10.57.6.69] (unknown [10.57.6.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FE1C3F85F;
	Mon, 17 Aug 2026 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786978605; bh=7dV1b0+NGUpOKXsz67zjTQC+6a3hvUjM7P7OhPtyxIE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q5wKL9yYbuGRY/uGjrp33K0BjcVaRkndDml2ZllOx/okMsecfi5ciq2H+sGKap3oC
	 NUkS+R6TSobgrDxcCGygOjo5lWeDdxj0chx0YrvZic/n1ZqD/avNmguzL0ZjzkSjin
	 PlJZPTCryTIf522sTi+GLdO0M4W/LFndBPB9b6bQ=
Message-ID: <4e0a7f4d-740f-47df-b601-1cfb0b79090e@arm.com>
Date: Mon, 17 Aug 2026 15:56:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI calls
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-3-steven.price@arm.com>
 <anR1xZrKkrsJhrGe@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <anR1xZrKkrsJhrGe@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/08/2026 12:53, Will Deacon wrote:
> On Wed, Jul 15, 2026 at 03:27:33PM +0100, Steven Price wrote:
>> The wrappers make the call sites easier to read and deal with the
>> boilerplate of handling the error codes from the RMM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v14:
>>  * Update to RMM v2.0-bet2 spec.
>>  * Move SRO related wrappers to a later patch due to dependencies.
>>  * Common wrappers are split into include/linux/arm-rmi-cmds.h.
>> Changes from v13:
>>  * Update to RMM v2.0-bet1 spec including some SRO support (there still
>>    some FIXMEs where SRO support is incomplete).
>> Changes from v12:
>>  * Update to RMM v2.0 specification
>> Changes from v8:
>>  * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
>>    rmi_rtt_read_entry() for consistency.
>> Changes from v7:
>>  * Minor renaming of parameters and updated comments
>> Changes from v5:
>>  * Further improve comments
>> Changes from v4:
>>  * Improve comments
>> Changes from v2:
>>  * Make output arguments optional.
>>  * Mask RIPAS value rmi_rtt_read_entry()
>>  * Drop unused rmi_rtt_get_phys()
>> ---
>>  arch/arm64/include/asm/rmi_cmds.h | 67 +++++++++++++++++++++++
> 
> This doesn't need to be in the arch code. Please work with Aneesh to put
> this somewhere else.

v16 moved the bulk of these to include/linux/arm-rmi-cmds.h [1] but left
the KVM related ones in arch/arm64/include/asm/rmi_cmds.h [2].

Do you want me to move the KVM related ones out of arch code also? It
seemed sensible to me to leave it in arch code because these RMI
functions are only used by KVM arch code.

Thanks,
Steve

[1] https://lore.kernel.org/r/20260803134403.80630-3-steven.price@arm.com
[2] https://lore.kernel.org/r/20260803134403.80630-11-steven.price@arm.com
