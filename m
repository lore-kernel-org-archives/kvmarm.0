Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABEB488747;
	Thu, 10 Sep 2026 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044277; cv=none; b=MNO8j9R+LWKN8z1sjBDifLsZzbbWkri4LGE8PZA1QZczUT43YItPSjvLh7JfOU9O2SRX/HxxVcwBAPkIw36dp9tb8msv5gQV1hNVYDwbxaoil3ipwWeDaKGBcw4CbXZDd3TRw7DVG87vIAx2zHmRUimWQJ7M+h7By19TLkH79e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044277; c=relaxed/simple;
	bh=mWkbpWT4DcWBDnuPciUuXTxSlxhpPhycuu8HUKXHUOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EVUjg445xXNfM8+Q7wVJNP+o4+PTR2FUrRzB86vPyt4vVv8wzDkGpEFfKVHgqeCqp3fsZ9vkIAFowS6srk/r9hacBFr7Eae9/MxET0Jf9G3Jqtab0GowZsm1s57NaPQvaFZGJqwdnYYLfyYxLsEeTtOO6+hGMCrMElv/p5yI3JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SLmLCa+f; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SLmLCa+f"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA328153B;
	Thu, 10 Sep 2026 05:44:27 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C66C3F7B4;
	Thu, 10 Sep 2026 05:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789044271; bh=mWkbpWT4DcWBDnuPciUuXTxSlxhpPhycuu8HUKXHUOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SLmLCa+f5BtxsTBKm8tudDDP9I7m2Cg/u7128g6wS0ro1bz11aFjbBGu9n2eIc41B
	 FUtlcYL2cz0Ua7c9tQZiKMZrQEHR995V9VnblJ8o99wKmNn9v9nIsWoV87xmmnPX4v
	 5teVkErMcFb7+nGSTnihU+gv7YTvkrknmBC8DZxk=
Message-ID: <be145c81-62e6-4aee-bea1-91357c36ad82@arm.com>
Date: Thu, 10 Sep 2026 13:44:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 10/20] KVM: arm64: coco: Disable Steal time accounting
 for coco guests
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
 <20260908162223.1683432-11-suzuki.poulose@arm.com>
 <CA+EHjTw9ReyvsNT=y+-P6ng7VQ6Pvz9PFK9bO71qvTR1pOxx5Q@mail.gmail.com>
 <6152fc41-65f0-460f-90b4-1454c11bcba6@arm.com>
 <CA+EHjTxjk1JLR7Tf5LEfB_xypbUWnw3G3H-FT7bTE=nWTTRgAA@mail.gmail.com>
 <d22c863b-ea81-472c-b2a9-28f99e5b6f92@arm.com>
 <CA+EHjTx744tg1c3vX0Ugo8YN7n-wtq9-rWdjjSP+UXi8_vvq7g@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTx744tg1c3vX0Ugo8YN7n-wtq9-rWdjjSP+UXi8_vvq7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/09/2026 13:42, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Thu, 10 Sept 2026 at 11:28, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> ...
>> Just to make sure I understand the picture:
>>
>> For coco VMs:
>>
>>    - check extension on coco KVM, KVM_CAP_STEAL_TIME => 0
>>
>> And a follow up DEVICE_HAS_ATTR => -EPERM ?
>>
>> But we tell the VMM, look you don't have the capabilit on this VM.
>> But if you try to set the attribute isn't it more appropriate to
>> say:
>>    -ENXIO - No you don't have that feature on this VM (-ENXIO)
>> rather than
>>    -EPERM - No, I won't let you do that.
>>
>> Remember we are doing only in the "VM" context. It is a minor nit
>> but I wanted to make sure we understand what we are thinking.
> 
> -ENXIO it is. I went back to api.rst for KVM_SET_DEVICE_ATTR: ENXIO is
> for a group or attribute that's "unknown/unsupported for this device",
> and EPERM for one that "cannot (currently) be accessed this way", a
> state or access-mode refusal, so a VM type that doesn't have the
> feature is the former. KVM_HAS_DEVICE_ATTR only documents ENXIO at
> all. Your patch is good as it is.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,

Suzuki

