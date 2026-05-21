Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023FC31AABF;
	Thu, 21 May 2026 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376272; cv=none; b=DZ0O7xQ0F4aa6IgHwbxxlkf9uofGhLdiMHNk30gE+LU2nG73KQ6k+a1kQukyhCKOocBkx3XXxNfjLtw3iQysHd5gAOWKgXGjrZgD+4ZOQjz8+uNnxzLNeVYTo0ylvqCyo7uAs9AwM60/Vh6HGi7ugZnq1xFug5k/lKHHkGmc8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376272; c=relaxed/simple;
	bh=lURVKNWHaQQMr1aDM/akyvG2Umw+DyGtL0+tWM/BV7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbuzAXa7iI74rIBYbN96z/GYkry2i0NsLkRo1yTC9BkiLcxGgkUIfSlroq8/jIQecB+k0VoQXnkshuADUlAizAEjGPFnY4ZNti3zpES6RBSYYOEQhB16NspxQ6OMYxgYHiJgh6P/XQBL4PI2ixbWXOycN8u7UwElcaIRNHWcVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=u3NFvO4x; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="u3NFvO4x"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D8A73AEC;
	Thu, 21 May 2026 08:11:05 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 227D33F7B4;
	Thu, 21 May 2026 08:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779376270; bh=lURVKNWHaQQMr1aDM/akyvG2Umw+DyGtL0+tWM/BV7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u3NFvO4xDafCig5AMnrdFcWSuJDzd9h+wvXdbiLbNy20Fm1boueLW0cFvhRZnAUyb
	 bCOi61DAQklFrqk7oHqiR9nJlsDbAnGdNQ4iVDmPIpmaaFpSQDkIl1yQOiALQ51+1X
	 qLurKw/y5sBHO8XbDjtLNAtGRKEP3TcRMfdNR0r4=
Message-ID: <270333f9-8993-4b1a-b242-135099193e29@arm.com>
Date: Thu, 21 May 2026 16:11:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/44] kvm: arm64: Include kvm_emulate.h in
 kvm/arm_psci.h
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-2-steven.price@arm.com> <86jysxvze2.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86jysxvze2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 21/05/2026 11:19, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:09 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Fix a potential build error (like below, when asm/kvm_emulate.h gets
>> included after the kvm/arm_psci.h) by including the missing header file
>> in kvm/arm_psci.h:
>>
>> ./include/kvm/arm_psci.h: In function ‘kvm_psci_version’:
>> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>>    ‘vcpu_has_feature’; did you mean ‘cpu_have_feature’? [-Werror=implicit-function-declaration]
>>    29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
>> 	         |             ^~~~~~~~~~~~~~~~
>> 			       |             cpu_have_feature
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> Unrelated to this patch, but really easy to fix: the standard prefix
> for patches targeting KVM/arm64 is:
> 
> "KVM: arm64: [opt subsys:] Something starting with a capital letter"
> 
> where "opt subsys" could be "CCA" where applicable.
> 
> It'd be good to have some consistency.

Sure, I think back when I started this there wasn't great consistency so
I picked up something from git log. I'm happy to change this for the
next posting.

Thanks,
Steve

> 
> Thanks,
> 
> 	M.
> 

