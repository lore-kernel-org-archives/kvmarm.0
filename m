Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B5E79C8
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177017; cv=none; b=AUxLycdK9bh5FvwIRyaiTnIFibWJVPc4aQZze+SCrBHZTSm/YBZiTLc+sQmyq9H62ZtgeWBNRyE6kBns4lEFfQ0Qzya9931E+Vbb+NH2xEe7E85RUyG5EEDS9rkGhk6Q6maSTBCYbhXtZU7XTPPbowvZ0xVmCPpncpii3wZmFNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177017; c=relaxed/simple;
	bh=84KXIXsEPdYPW/hv00MCC50tWgoa2u/e9pMLHA0Eugw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lY6/imkDKqA3BK9j0qd4u1Gu9ARLPOFtQHMEaqkDH4teIF5Garnq5SSEIlJFO6iMh6KDlWncFzHF/PSpI7P4qf6D/Qpe38GqYIxAccnAwzEw3f46crAzfSLk70g5XEs5vHB05l/ocanl5X7db3zJ6/ooYY4WknuvYM8Dk63cewM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56BE8168F;
	Wed, 26 Nov 2025 09:10:07 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA9AE3F66E;
	Wed, 26 Nov 2025 09:10:13 -0800 (PST)
Message-ID: <26d62f83-c5e2-4706-84ad-b3dbe313dfd1@arm.com>
Date: Wed, 26 Nov 2025 17:10:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Report optional ID register traps with
 a 0x18 syndrome
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-5-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251126155951.1146317-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 11/26/25 15:59, Marc Zyngier wrote:
> With FEAT_IDST, unimplemented system registers in the feature ID space
> must be reported using EC=0x18 at the closest handling EL, rather than
> with an UNDEF.
> 
> Most of these system registers are always implemented thanks to their
> dependency on FEAT_AA64, except for a set of (currently) three registers:
> GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> and SMIDR_EL1 (depending on SME).
> 
> For these three registers, report their trap as EC=0x18 if they
> end-up trapping into KVM and that FEAT_IDST is not implemented in the
> guest. Otherwise, just make them UNDEF.

Missed it before but there is a stray 'not' in there. You get the
EC=0x18 trap if FEAT_IDST is implemented.

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

The code looks good.

Reviewed-by: Ben Horgan

Thanks,

Ben

