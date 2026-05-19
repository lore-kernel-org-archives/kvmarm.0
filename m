Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8731F3E0C56;
	Tue, 19 May 2026 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179054; cv=none; b=J/D/FqLZ7DdtxtfvEEDJEUiOOe0AR+Dt0eHxRAoEzzTtU+OncRmG+LtuAM9+x6LSYSeVyGPxuVSdNG315eQ6o0hbn9rkMWhUg620t4PuuEAxL4M/9z3u62XOrlaza7UJMnoPQuRaWUtyJqxXwAiT/lNUGYWVKWYLE6rXN6el28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179054; c=relaxed/simple;
	bh=Y/ur6kXaqyutmulE6ALqWLW6OIukPW3L6JklRGunmRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HC8ksItoVrbqisjnmvferUPEegN304iFRB2X4CYb4brSBV4QhDU2pcUChiH0R7DYlWWQCe9hPRT9BVs1Qa08Fjvztlvh3WxCENdrPYzig5UvkSwRxadzIROZRT2DKNdIHwNve7+nvcsMiDKMPifwl3ytpXOMo4eYVTFnANp0CKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mZG8aox/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mZG8aox/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA7D91CE0;
	Tue, 19 May 2026 01:24:06 -0700 (PDT)
Received: from [10.57.21.217] (unknown [10.57.21.217])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 675043F85F;
	Tue, 19 May 2026 01:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779179051; bh=Y/ur6kXaqyutmulE6ALqWLW6OIukPW3L6JklRGunmRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mZG8aox/W/e6xzhn5RiTNydJTpx7flfHa/abZ3kd8KTqJJ71HHucb3bQGFflvCn0W
	 HgL59EE2AyG3IVbJqMMEyB0L/E7CCEYcO65lQY1jxB14er0PuDC3w9ukYW34JH66fw
	 YBFFE8XCuROPCyHeY83FCo4XfqVvlp+m8Qn9tncc=
Message-ID: <afca6cdd-f9e3-4b5f-9f70-940c8dbb7a80@arm.com>
Date: Tue, 19 May 2026 09:24:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 00/14] coco/TSM: Host-side Arm CCA IDE setup via
 connect/disconnect callbacks
Content-Language: en-GB
To: Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Cameron <jic23@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Samuel Ortiz <sameo@rivosinc.com>,
 Steven Price <steven.price@arm.com>, Xu Yilun <yilun.xu@linux.intel.com>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
 <agsNO9cc7H-b0H8L@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <agsNO9cc7H-b0H8L@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/05/2026 13:59, Will Deacon wrote:
> On Mon, Apr 27, 2026 at 12:21:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>   arch/arm64/include/asm/rmi_cmds.h         |  85 +++
>>   arch/arm64/include/asm/rmi_smc.h          | 168 +++++
> 
> Curious, but why does this stuff have to live in the arch code? Wouldn't
> it be better off somewhere like drivers/firmware/ or
> include/linux/arm-rmi.h?

Good point. RMI interface is only available for arm64 (not in Arm32). 
That said, it is indeed a firmware ! ;-) interface. The APIs are closely
integrated with the KVM Realm management. If the general consensus is
to move them under drivers/firmware (like PSCI), we could take that
approach.

Suzuki

> 
> Will

