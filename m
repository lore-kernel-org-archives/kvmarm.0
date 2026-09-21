Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF7545D901;
	Mon, 21 Sep 2026 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981227; cv=none; b=PeUdnfrUCxGn5mbeBqk5zm3HGpEBOArj5Om/8G5cUlN8i6iWUyQCe05YIWxsoHJdrYcDwd37h3bDOLyJEk9RQJgirv+gO01WVqU8hp+9DCzvRFZKZkgQCGfLmMgFGpQ1yvKFmASOqpogeSDU6d5eveliZ4jH9bLKjjFT22a2ojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981227; c=relaxed/simple;
	bh=7FAGCstgztp6bQyjfL+K1zBPkIxsy8V7zCgPNPDJtbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4/uwjV0mEkJufe5VWYbfbENEiElhWqr8LY2x+Aem6VLuUtK1tbEFOpdCygBul1A1BqmNE2pmaF0BvWURbiPJW85L/gsc/7Q1PuGSIAvtOp28YgussKXlTMA+y1ARA1DdDjZDs8A1Seuuh2+rPUWCNR5HenfCPW4V3FErXxEDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oSa5Booe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oSa5Booe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39BAD1CE0;
	Mon, 21 Sep 2026 02:00:21 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECAE23F86C;
	Mon, 21 Sep 2026 02:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789981224; bh=7FAGCstgztp6bQyjfL+K1zBPkIxsy8V7zCgPNPDJtbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oSa5BooeCN2HgtM8aUls3mxHMY3MXyU2nS3pbxXQChhKBqdmgK734c/lj7eVm0YO9
	 ZSKEbPNyh17gcrccayHqVU+68ufFTY1lZApU7H+TSnRhywToCaqGZxCnn+xzsn72jW
	 7MGPpF9u5Wz+sBuB3BdBclgAlWKwK0iyJ/u15DDo=
Message-ID: <f0a4672d-c7f2-42d4-9fc7-b5a1d0ad3b83@arm.com>
Date: Mon, 21 Sep 2026 10:00:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 2/7] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-3-suzuki.poulose@arm.com>
 <178978126541.2352296.3637463397103730192.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126541.2352296.3637463397103730192.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
>> Query the RMI version number and check if it is a compatible version.
>> The first two feature registers are read and exposed for future code to
>> use.
>>
>> We only support this for Little Endian kernels, the Big Endian kernel
>> support is anyway marked BROKEN and is being removed.
> 
> Can we have a small comment here on why the default is y
> 
> It's a big thing to opt into by default.  Feels like defconfig
> material maybe but not in the Kconfig defaults unless I'm missing
> something.

We need this for KVM arm64. I could drop the default here and
KVM selects this anyways. But, how far do we go on this ?
Do we need to be able to disable this completely even for KVM ?

As such it is a relatively smaller blob:

$ size drivers/firmware/arm_rmm/rmi.o
    text    data     bss     dec     hex filename
    7477     572       1    8050    1f72 drivers/firmware/arm_rmm/rmi.o

Cheers
Suzuki

> 
> 
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
>> diff --git a/drivers/firmware/arm_rmm/Kconfig b/drivers/firmware/arm_rmm/Kconfig
>> new file mode 100644
>> index 000000000000..82724ee23186
>> --- /dev/null
>> +++ b/drivers/firmware/arm_rmm/Kconfig
>> @@ -0,0 +1,26 @@
>> +
>> +config ARCH_SUPPORTS_RMM
>> +	bool
>> +
>> +config ARM_RMM_RMI
>> +	bool "Realm Management Interface (RMI) Support"
>> +	depends on ARCH_SUPPORTS_RMM
>> +	default y
> Really? Why?

> 

