Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B618B2309AA
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666785; cv=none; b=GNeUIV0ZmpgI2XL1w9yI815UGb8s0rY+zuddrAgcQyo9+/93IAOLAG93lDWBIXiQy9HNa9jOBo8O5h0qPb9OkE+xiNiW88Mzmkbo99/1M7cdG9QS2kfBnHzafz81Zmcec4Wuormsr8mnxXlzUY//jcNtlg4hxr9VRz+T/AsxH+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666785; c=relaxed/simple;
	bh=G6UrxkJ56AB/TP6g75nYF82dntSaDB56+LdaGsDO1vU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b19yBAuRirCcNftqf57s/C5/42pqA2HfDaozWcXo1zdYCFarE5ERgrSOVB6VwVG6RJtZ9xuaX1+jfhx9vNasR+oxABKhzKlG0Ju/Cgf17RMJJ0AftaAWkQCVMTnfvHimFCUghuqrmDP4DL6QrUR+AeC0L4riL5wNcH7dtCNu1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 809B42BCA;
	Thu, 27 Feb 2025 06:33:18 -0800 (PST)
Received: from [10.57.79.45] (unknown [10.57.79.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 181D33F673;
	Thu, 27 Feb 2025 06:33:00 -0800 (PST)
Message-ID: <c251961d-2efe-438a-bdef-5054db8ff909@arm.com>
Date: Thu, 27 Feb 2025 14:33:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3] arm64: Add basic MTE test
To: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, eric.auger@redhat.com
References: <20250102111020.130788-1-vladimir.murzin@arm.com>
 <Z4aHBrpgiyWNXac2@arm.com> <53d73ed1-567a-4428-b4ac-3c4741218ce3@arm.com>
 <Z8BvUkBIETJvRiln@raptor> <20250227-b48587a0c6e38bff00a30934@orel>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20250227-b48587a0c6e38bff00a30934@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/27/25 14:29, Andrew Jones wrote:
> On Thu, Feb 27, 2025 at 01:57:38PM +0000, Alexandru Elisei wrote:
> ...
>> But yeah, since most of the tests don't check for a NULL return value from
>> the page allocator I guess it doesn't happen too often. This test is really
>> useful and it has been on the list for quite some time, so I don't consider
>> this a blocker.
>>
> I'm happy to merge this if it's ready. Will there be a v4?
> 

Yes, Alex had some other useful comments which I'm planning to address.

Cheers
Vladimir

> Thanks,
> drew
> 

