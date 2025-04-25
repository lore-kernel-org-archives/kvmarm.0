Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8EB23AE84;
	Fri, 25 Apr 2025 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745578435; cv=none; b=XIZ0XAYPiJJmQeosoX6fauuHE9UVIOBzaBtHrOPPPKxGufpCiep1S87dtb33Gms1aQRbzfFUdgScH1BK91KQla8wQEXbMM8tmbm6mZttI9SsPwRF2G3uUq3zuLp6XXUM5bm/SAfygV+G3kAcPxmnroSu2p1LYZIXotFsXN29SmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745578435; c=relaxed/simple;
	bh=/why4+36fOBzV86P+8y59rtkY6eWvvw3yaTU795qQi8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NT5ldXgrZwic0wzkiu8jWu58dxKduj5zHy2eQoFoI8qZMEnaECNBP/fUGw3kQNjO1qHyDoDOmtzvnOKQqXtKmzezYVYdxREycclXJ34xHyX1t1sHclIVCCK9/6dr0irIREiiIetdKNk/0J9Q2K+Q9RlkBZe7rfLzoSLnskS+Nfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC1D3106F;
	Fri, 25 Apr 2025 03:53:47 -0700 (PDT)
Received: from [10.57.45.160] (unknown [10.57.45.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DAD963F59E;
	Fri, 25 Apr 2025 03:53:49 -0700 (PDT)
Message-ID: <202ff57d-f88c-4cd8-995a-c9bdec7f8b18@arm.com>
Date: Fri, 25 Apr 2025 11:53:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/43] arm64: RME: Add wrappers for RMI calls
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-5-steven.price@arm.com>
 <d43d1813-5402-488c-aadc-6336dedeccbe@arm.com>
In-Reply-To: <d43d1813-5402-488c-aadc-6336dedeccbe@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/04/2025 11:48, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 16/04/2025 14:41, Steven Price wrote:
>> The wrappers make the call sites easier to read and deal with the
>> boiler plate of handling the error codes from the RMM.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v7:
>>   * Minor renaming of parameters and updated comments
>> Changes from v5:
>>   * Further improve comments
>> Changes from v4:
>>   * Improve comments
>> Changes from v2:
>>   * Make output arguments optional.
>>   * Mask RIPAS value rmi_rtt_read_entry()
>>   * Drop unused rmi_rtt_get_phys()
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h | 508 ++++++++++++++++++++++++++++++
>>   1 file changed, 508 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/ 
>> asm/rmi_cmds.h
>> new file mode 100644
>> index 000000000000..27cd2751f3bf
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -0,0 +1,508 @@
> 
> ...
> 
>> +
>> +/**
>> + * rmi_rtt_destroy() - Destroy an RTT
>> + * @rd: PA of the RD
>> + * @ipa: Base of the IPA range described by the RTT
>> + * @level: Depth of the RTT within the tree
>> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
>> + * @out_top: Pointer to write the top IPA of non-live RTT entries
>> + *
>> + * Destroys an RTT. The RTT must be non-live, i.e. none of the 
>> entries in the
>> + * table are in ASSIGNED or TABLE state.
> 
> minor nit: It may be worth emphasising that you mean HIPAS here and not
> RMI_ASSIGNED (as returned by RTT_READ_ENTRY). The key is, an unprotected
> live leaf mapping  (i.e., HIPAS=ASSIGNED_NS) is considered non-live.

Ah, I went back to the spec and TABLE is not a HIPAS ( :facepalm ).
They are indeed RmmRttEntryState type. So, the comment is fine as it is.
Please ignore ^

> 
> Either ways:
> 


> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Suzuki
