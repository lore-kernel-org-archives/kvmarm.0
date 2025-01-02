Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D0F3D68
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 12:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735819811; cv=none; b=qiodnkHZ5G9MWkNmaO8XVznEtChJNkwCqHvVhAUhAJsMUlA7S1BG1MQFUNEI8Hq4eCYmg3bEFPgy5jWAP2N2WB7+YzRPO4rlf6PKKbBmSqzWgx2LQXcXMq0Z4fOoi/tSQIZfjabLmVQQx5Dqwq1MKOZ2/S8De5qLXVKhG914J2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735819811; c=relaxed/simple;
	bh=S5Wz7QMpHKhmhdlY2UY4x2qiEYobGLTFNk9vqTQbUmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WGkS1yx9os4CBta5DWMC/VoDgi7RmSWfd+wyBogDgJHe2Q+DIe6kcFVQhe0458FZfOKHXqU/x2OLXfnrE+CBnblez6P3OQCBMBNojGzxSfdaar3lP+OHFEsh1cfOYchJpJ78PjQHmpwHMVtGBsb5BTYIap5iiNvbZb1yhA6Eh1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E437153B;
	Thu,  2 Jan 2025 04:10:36 -0800 (PST)
Received: from [10.1.25.140] (e121487-lin.cambridge.arm.com [10.1.25.140])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BFD43F673;
	Thu,  2 Jan 2025 04:10:07 -0800 (PST)
Message-ID: <6db97d9c-abe0-4418-903f-bc4662a8cab0@arm.com>
Date: Thu, 2 Jan 2025 12:10:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
 eric.auger@redhat.com
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor> <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor> <590394e4-b21f-4ff8-a250-0cbf50adfe38@arm.com>
 <Z3Z8ZHDLATOS1UH3@raptor>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <Z3Z8ZHDLATOS1UH3@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 1/2/25 11:45, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> On Thu, Jan 02, 2025 at 10:04:37AM +0000, Vladimir Murzin wrote:
> [..]
>> On 12/30/24 15:19, Alexandru Elisei wrote:
>>> Hi Vladimir,
>>> Interestingly though, when I try to run a test (either with ./run_tests.sh
>>> mte-sync, or by trying out your example), I get this error:
>>>
>>> qemu-system-aarch64: MTE requested, but not supported by the guest CPU
>>>
>>> My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
>>> model CPU. Changing the cpu to 'max' makes the test run. How are you getting
>>> around this on your end?
>>>
>> ./configure --arch=arm64 --processor=max
> Ah, so that explains it. Would you mind adding this information to the commit
> message, perhaps something like this:
> 
> If using TCG as the accelerator, qemu must emulate a CPU that supports MTE
> in order for the tests to run. Use configure --processor to set an
> appropriate CPU. If unsure about a particular processor, 'max' will most
> likely work with a new enough qemu version.
> 

Yes, I can add it when re-spin v4 (sorry just sent v3). Alternatively, we can
merge change defaulting processor to `max` for arm64 which IMO much better
solution (and does not require me to re-spin the patch) ;-)

Cheers
Vladimir

>> Thanks
>> Vladimir
>>
>>> Thanks,
>>> Alex
>>>

