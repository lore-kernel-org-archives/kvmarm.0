Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424B72135AC
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 17:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118456; cv=none; b=uwmhBhMzkIJE9SYBGGl7Ck15Igd5T7ZTSi4ctJOb6I9LwXIJ/Nl+iWFKR/bGY4j0jcQgaH6WhKiG6VffnfrPCL5xgkXmQZ4ziFoSZZ3G5CuLm4uxQ15I/KTyhv1BHaohoH6Xzr7vK2HLzPO4Gy0lDSWKkzI6I+cT+hZnM2mWrvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118456; c=relaxed/simple;
	bh=0NlFb+qovKUIq/o0/4pCjyJKfbYaztgHRLswjYbe0qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C28VKnkC7hAiiehor5cZLOqWMLK0VV5wEFPQMzW4YDhQpcojk5/6jfGNC1bz99HORtRIv1of3jYaT1o4o70TbChaaC9uHtbbkr3tFxNUqiG7qRJ+GAk12wGvGLbbr5suAOeTHjKuUgjOyYxoeQxJxYhnphN3FYvuiwFqheWPLyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=M6lAY38n; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="M6lAY38n"
Received: from [10.137.184.60] (unknown [131.107.160.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id 82C482115836;
	Mon, 21 Jul 2025 10:20:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 82C482115836
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1753118454;
	bh=F0WeBj2bGuuRDUrwwzYEPFuv3oAaANMb0rzB3x/zEGs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M6lAY38nEFF6SPpxTb0jBP9+abnYKMYir5Krk+urbD9Y4Z3t0/8JxNOMoSNX0fUsO
	 FpNzv3YTYyKxz1aNCxTInjwirrXdr/tAAFV9m67PV5iaHZKfIqy5hqXiBd9RY4hSKN
	 QIvH+QrTMRImtRgveFS0jbwSC3/UPzX3dY5iu3vc=
Message-ID: <55e5f8d2-2b81-4883-a9ac-ad1a426c4222@linux.microsoft.com>
Date: Mon, 21 Jul 2025 10:20:54 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: kvm, smccc: Fix vendor uuid
To: Sudeep Holla <sudeep.holla@arm.com>,
 Jack Thomson <jackabt.amazon@gmail.com>
Cc: mark.rutland@arm.com, lpieralisi@kernel.org, arnd@arndb.de,
 wei.liu@kernel.org, mhklinux@outlook.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
 roypat@amazon.com, Jack Thomson <jackabt@amazon.com>
References: <20250721130558.50823-1-jackabt.amazon@gmail.com>
 <20250721-proficient-carrot-cockatoo-393ae1@sudeepholla>
Content-Language: en-US
From: Roman Kisel <romank@linux.microsoft.com>
In-Reply-To: <20250721-proficient-carrot-cockatoo-393ae1@sudeepholla>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/21/2025 9:15 AM, Sudeep Holla wrote:
> (I can't see this original patch in my mailbox, got only Marc's response)
> 
> On Mon, Jul 21, 2025 at 02:05:58PM +0100, Jack Thomson wrote:
>> From: Jack Thomson <jackabt@amazon.com>
>>
>> Commit 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for
>> getting hypervisor UUID") replaced the explicit register constants
>> with the UUID_INIT macro. However, there is an endian issue, meaning
>> the UUID generated and used in the handshake didn't match UUID prior to
>> the commit.
>>
>> The change in UUID causes the SMCCC vendor handshake to fail with older
>> guest kernels, meaning devices such as PTP were not available in the
>> guest.
>>
>> This patch updates the parameters to the macro to generate a UUID which
>> matches the previous value, and re-establish backwards compatibility
>> with older guest kernels.
>>
> 
> Nice catch. This is result of classic confusion with UUID and GUID especially
> coming from Microsoft who tend to use GUID more.
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> This also makes me wonder if the initialisation in arch/arm64/hyperv/mshyperv.c
> is also wrong or may be that's correct only MS guys can confirm as I couldn't
> find the UUID string for that.

MUCH appreciated!! Apologies for that miss in testing of the older
kernels. I'll check on our side and will fix what needs fixing.

> 

-- 
Thank you,
Roman

