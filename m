Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F771E89C
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733999854; cv=none; b=GQ9sgw1FZuBuKV4utl1NGoApnjrY5Ldhv/BJkKinWMnwAeeyq5VhYkHpJAR/+c/89e3vkZz1e2qlMNxaYePcNIxGMddCKKgbpzaBXn3lXPyggL4tk9hwiZq+fo9tR1aoJH9ObLLYIIosS+kZxONQXJgxnRLXJ3VJV5uo9taoALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733999854; c=relaxed/simple;
	bh=yy/4XN030xD33beCc1FfwV0Weof0Er6ZiG6oMzwCIWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7dYJbDJkgzGzIJVgdSlU8D5tB7ndIYjzq0rzmCzRNa7Z5iTsvvt6XC6LywZBzDPOcADP4nNUgGUlDMunQLlQcRj2K9aCoGsl5BQ91fJXO96m1sGR5tC8DZMxyVttvyujpagcF48dWisxMQ++IVMZjcTm8FtHWfxW9GVYf5HMzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F35C0169E;
	Thu, 12 Dec 2024 02:37:59 -0800 (PST)
Received: from [10.57.92.2] (unknown [10.57.92.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77FB63F58B;
	Thu, 12 Dec 2024 02:37:29 -0800 (PST)
Message-ID: <342b9c16-690d-42ed-a6f4-bb3972193a8f@arm.com>
Date: Thu, 12 Dec 2024 10:37:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND RFC PATCH v1 1/5] arm64: Add TLB Conflict Abort Exception
 handler to KVM
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
 catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-2-miko.lenczewski@arm.com>
 <86o71irucr.wl-maz@kernel.org> <5d4ccb2c-da45-4471-9bb1-90212b50dad7@arm.com>
 <86msh1rzpq.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86msh1rzpq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/2024 09:57, Marc Zyngier wrote:
> Hi Ryan,
> 
> On Thu, 12 Dec 2024 09:23:20 +0000,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> Hi Marc,
>>
>> I believe the intent of this patch is to protect the host/KVM against a guest
>> that is using BBML2. The host/KVM always assumes BBML0 and therefore doesn't do
>> any operations that are allowed by the arch to cause a conflict abort. Therefore
>> the host doesn't need to handle it. But a guest could be taking advantage of
>> BBML2 and therefore it's architiecturally possible for a conflict abort to be
>> raised to EL2. I think today that would take down the host?
>>
>> So really I think this could be considered a stand-alone KVM
>> hardening improvement?
> 
> I'm not disputing the need for a TLB Conflict abort handler. It will
> be a good addition once we agree on what needs to be done.

OK great, glad we are on the same page. I'll leave Miko to work through the details.

> 
>>> However, it doesn't seem to me that the host is equipped to deal with
>>> this sort of exception for itself. Shouldn't you start with that?
>>
>> If the host isn't doing any BBML2 operations it doesn't need to handle it, I
>> don't think? Obviously that changes later in the series and Miko is adding the
>> required handling to the host.
> 
> Yes, and that's what I overlooked yesterday, and I replied to that
> change this morning.
> 
> Thanks,
> 
> 	M.
> 

