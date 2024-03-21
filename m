Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973AA1EB24
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711035432; cv=none; b=W8uKUvwIkbUipjZwL7JsPzcGcdzo13bRQeqbw+nNcTVlOlKnIjJMr6/JPXBAdp1dNbfCTOLzr4OteU15n5iacNpczKSXkd+iY2uezsyh9eF+NHhzVsRV3dJpFGzmLUZR0B4Guog4dgxMKTgFKkhdf3pn2JJoP4HFLKZbcx/cQ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711035432; c=relaxed/simple;
	bh=x9fMqpnwiVCa+CYmjvEqhU7K9m8YgSlylHC6J7DYQ5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttoD1iHkvJZEc7EQoVvTdl7O6t+/CS5NWDOH7T97T6Buci1v3UlYHlrCdt1ZPsdbrvK1+W3OSa0BIZJcYT80bLA9j1RN8+yzfPp8O0cMcNk5sH6LqLahrabiTPhZ7yRLbD8b2+his277h0ALt689QC/xIMeVdOko1j1UXlKL1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 282C31007;
	Thu, 21 Mar 2024 08:37:43 -0700 (PDT)
Received: from [10.1.197.60] (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0742A3F67D;
	Thu, 21 Mar 2024 08:37:07 -0700 (PDT)
Message-ID: <890fefac-2df3-4d1a-b3d1-e063cb3da388@arm.com>
Date: Thu, 21 Mar 2024 15:37:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
Content-Language: en-GB
To: Jing Zhang <jingzhangos@google.com>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231207150804.3425468-1-james.morse@arm.com>
 <ZXoTG1Y4O16Cjq39@linux.dev> <f06ed418-922d-54c5-22a0-bde127146b5a@arm.com>
 <ZbAMxyGcSZY7Kl7Z@linux.dev>
 <CAAdAUtgr-AmQKUhAf4Dbg+jurzzDJ1xCzJkptwACuWAnZv_d_A@mail.gmail.com>
From: James Morse <james.morse@arm.com>
In-Reply-To: <CAAdAUtgr-AmQKUhAf4Dbg+jurzzDJ1xCzJkptwACuWAnZv_d_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jing,

On 08/03/2024 17:48, Jing Zhang wrote:
> Will you have a new version for this patch series?

Yes - sorry, I got bogged down in the x86 end of the MPAM tree, so wasn't ready to post
this until ~rc5 ... I figured the arm64 folk wouldn't be too pleased with head.S changes
that late.

I'm trying to get this series posted today, as I'm away for a few weeks.


Thanks for the nudge!

James

