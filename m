Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091C23A1DA;
	Mon, 15 Apr 2024 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713171572; cv=none; b=ZESdR09gnMNubviVQCwIHer0zgIE/fPPSMn5moyr1jF0DAHQQousdIi8XDly+708XR55FxIQLLQ7AWbj6nA7KbzV1ykZn2VMYU72u76VYHv8qWCJ9o2fJg5ikoUpkzzi+cXUrjeVOmFU3ybWJT4aTMx9T2Utd+l2q5lqMWs6g34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713171572; c=relaxed/simple;
	bh=cQefjCbFLFJbuXKCV4wQx4QliCH4tuRgWArq1MZKwHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDQqBHhRc2/r8v/B5YfyKoKagantyGqJIHEN6metPWJWls/L/xSnIde7AdIfGLdoMgCRhGe1cKI4xFCrlEUbXbcrqRdo6rAQbrQme8cy7hrmHI7UH5t5cMt+dcQ2zG98iVTBQAriU5DnOaEC5ngS3uyV9URtSolPbobreH6T9jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA30A2F;
	Mon, 15 Apr 2024 01:59:57 -0700 (PDT)
Received: from [10.57.84.28] (unknown [10.57.84.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3B0C3F64C;
	Mon, 15 Apr 2024 01:59:27 -0700 (PDT)
Message-ID: <23604d92-1d67-4d40-881d-c9a8e6b6fe05@arm.com>
Date: Mon, 15 Apr 2024 09:59:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential Compute
 Architecture
Content-Language: en-GB
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
 james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
 andrew.jones@linux.dev, eric.auger@redhat.com
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <Zha7mFYTPJk34+cO@vm3>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <Zha7mFYTPJk34+cO@vm3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Itaru

On 10/04/2024 17:17, Itaru Kitayama wrote:
> Hi Suzuki,
> 
> On Fri, Apr 12, 2024 at 11:33:35AM +0100, Suzuki K Poulose wrote:
>> This series adds support for running the kvm-unit-tests in the Arm CCA reference
>> software architecture.
>>
>>

...

>> Changes since rfc:
>>    [ https://lkml.kernel.org/r/20230127114108.10025-1-joey.gouly@arm.com ]
>>    - Add support for RMM-v1.0-EAC5, changes to RSI ABIs
>>    - Some hardening checks (FDT overlapping the BSS sections)
>>    - Selftest for memory stress
>>    - Enable PMU/SVE tests for Realms
>>
>>   [0] https://lkml.kernel.org/r/20240412084056.1733704-1-steven.price@arm.com
>>   [1] https://lkml.kernel.org/r/20210702163122.96110-1-alexandru.elisei@arm.com
>>   [2] https://github.com/laurencelundblade/QCBOR

...

> 
> Thanks for the update! I'll go through the series one by one in the
> coming weeks. Just curious one thing - do you guys wish to add Realm tests to the kvm-unit-test package, but not to kselftests?

Thanks for taking a look. kselftests is in plan but we wanted to make
sure the UABI is a bit more stable before we plumb all of that.

Kind regards
Suzuki

> 
> Thanks,
> Itaru.
> 
>>
>> -- 
>> 2.34.1
>>

