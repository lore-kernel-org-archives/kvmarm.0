Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CC25476CC;
	Wed,  9 Sep 2026 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953464; cv=none; b=CctKmmc71NiI6KwiEPia+22r+fgoOSAuYNAqN5lSedgu93GYN407kyjCEfRtEfQ9a5WBzU/OUbZOS8GLxO3hL3O3MBbsebZhbXxpwOPvRweIIzXF7Gn0c6U27ImuBV8s9WZMjZcjPIwuWd7vnoARNgBmAWK8FGW+PI8Nq4C82jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953464; c=relaxed/simple;
	bh=aaks7dx+zR/tpBzvxXxBPfKtmQBuOjd3Zh0Fj5FHgHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4oR19AUUB071FOTpPWV9OATg9eAqTR4A3McM/yzcaJHgfd0b01uP6TKf06f8fHmPM+05U/DMJnEiOtAfQ95gTnLZFif4Ry3ezjFH6bi3lp0aIRomICxlJ/uKfbeCJ2ZMb4vRw+jW5Cm8W3Ys3IvS01w+UkzUZsw8wXayCdj+rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lQJvoC0Q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lQJvoC0Q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B04761691;
	Wed,  9 Sep 2026 04:30:58 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D8803F528;
	Wed,  9 Sep 2026 04:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788953462; bh=aaks7dx+zR/tpBzvxXxBPfKtmQBuOjd3Zh0Fj5FHgHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lQJvoC0QzOh/jq7UI0GAjAsF1Q/iWY3o10jdXWoT7zw21KCbNnxAz5gfKurHMvfLu
	 mEI20XdJxFeoWkJ7JAon3rjfwkkBR1egM788NX6lI83FPrPP5JdxUh4It1jMLCQBak
	 p/xexTVknjsE6TV39WJPBmmPD5I0y63Rx5p+nJzI=
Message-ID: <3d75ad7b-cce9-4658-8af3-2269db91c76c@arm.com>
Date: Wed, 9 Sep 2026 12:30:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 03/20] KVM: arm64: Track the type of VM in kvm_arch
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-4-suzuki.poulose@arm.com>
 <CA+EHjTybMZ1TORs25En0eb7_41FBcB=BK1ygYPy5cOHUnQO84A@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTybMZ1TORs25En0eb7_41FBcB=BK1ygYPy5cOHUnQO84A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2026 12:28, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 8 Sept 2026 at 17:23, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> KVM arm64 has different types of VMs with all the different modes in which the
>> hypervisor code can be run. e.g., VHE, nVHE, PKVM etc. Then there is protected
>> VM and normal VMs with PKVM. We might soon add other types, e.g., Arm CCA Realm.
>> So in an effort to make the handling of these different types of VMs a bit more
>> friendlier to the eyes, add a VM flavor to the kvm_arch and we could then add
> 
> nit: "friendlier"
> 
>> handlers for different operations based on the VM type.
>>
>> Keep the flavor initialisation at the beginning to allow for the detection
>> early enough and fail out on any unsupported requests. (e.g., protected on !PKVM)
> 
> In the commit msg and later in the code (not in the enum though), can
> you please spell pKVM with a lower-case p?

Ack.

> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers
Suzuki


