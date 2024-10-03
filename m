Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E3B13211C
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 03:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727927667; cv=none; b=Cdlmca5Ee62d+tPvx05MpA9ph5JcNdigvkHYyvfCGtykI0FxhZaIE876mBf2nL3jxwyXPfBoaDE4l7MvZDEbCuZ+L5UcbaSISyHHWQ1rTi0zrpq/rKFfhjpKb/KDOgmA40xsQ1+9sgZuAyX8Ak41o4+OHcs0ui98d5RULOezAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727927667; c=relaxed/simple;
	bh=iVJ57KsnvVa8MzMxTd7S1+VAd5K7Dj+OOYSi3DskIEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3UECLUof1/X1+TXQ/kWpHhmGCZr6q7lllkWJRBhKtwb6Zhp+u3GGPWKi6Q34gx7wC8IjHCtbPgQXkSSDF+a3v+ZGdwP0nzoipRBHs3aZAUKAKSnC5HKqrUWVBxui87bapM0wuWdFt4EPDWv1sxr8QyintEbasbwjwqqVZEUTPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C817339;
	Wed,  2 Oct 2024 20:54:54 -0700 (PDT)
Received: from [10.163.37.202] (unknown [10.163.37.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F18DF3F64C;
	Wed,  2 Oct 2024 20:54:21 -0700 (PDT)
Message-ID: <64743d42-7758-49fa-b388-1321cae2dc6b@arm.com>
Date: Thu, 3 Oct 2024 09:24:20 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/47] KVM: arm64: Enable FGU (Fine Grained Undefined) for
 FEAT_FGT2 registers
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <88783a82-6bfe-4b9e-abd6-a39169c2e223@sirena.org.uk>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <88783a82-6bfe-4b9e-abd6-a39169c2e223@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/2/24 21:22, Mark Brown wrote:
> On Tue, Oct 01, 2024 at 08:13:09AM +0530, Anshuman Khandual wrote:
>> This series enables fine grained undefined for FEAT_FGT2 managed registers
>> via adding their respective FGT and CGT trap configuration. But first this
>> adds many system register definitions in tools/sysreg, which are required
>> there after.
> 
> One top level comment: these are updates for DDI0601 2024-06 but we've
> now got 2024-09 available.

Right, guess this new release i.e 2024-09 just happened recently because
IIRC version 2024-06 was marked as the latest until last weekend. I will
revisit all the above register definitions for 2024-09 release update and
will also update their commit messages as required.
