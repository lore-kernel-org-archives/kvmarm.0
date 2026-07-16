Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A4E408606;
	Thu, 16 Jul 2026 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199546; cv=none; b=bKGv2WjaycfXsK5m5Aoxjbs72goDX1qMa9DQd6/lg/F8D0qraDvF5KJoeCXqexJQieSQobmeGzBPTZpaxG8+PyUwXo7D5W4gTTFq9Mnd8IRCs74gIIkcin+NZGU0JKjfTbP+OEaOZl8E1SrDu0TwmU+BMdYuFSA1TyvUsklFgNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199546; c=relaxed/simple;
	bh=RrtlIcDf/RFlWt5OyWTeJ+DmZPw/5Wm/dNhsmp2OJN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=srgvUKX8ilqP9FVInJsr6rceqgnvtcmqTbPS0vAiQVa5e5avt2b2fs5Zej95RiXiG5w9HaLCCe+4ertZH5aarV/BdKjkRos41zs/d78vf83+aWpB1bUT+xDq5yvxt8cpEPFwF5Ml+GsJoxaREmNnbQs75gAEr+9A1XYcuOlwSII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A7Ho2nGp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A7Ho2nGp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C5B3339;
	Thu, 16 Jul 2026 03:58:59 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C558E3F7B4;
	Thu, 16 Jul 2026 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784199543; bh=RrtlIcDf/RFlWt5OyWTeJ+DmZPw/5Wm/dNhsmp2OJN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A7Ho2nGpnvLv/Mg/MLAQTVrxOWePBOc+PMzBu/qHNH6KkfcDdKqy5l8te44nAlmb+
	 7Uga8n5tIWcNduzUBmEdWxmqyrP7oY2aANyEbOaabuOjiWmRJTC3MqzwIsygEkZPme
	 /TjbRo1goAE43yFgPNnEA5EMRrHIj/1BJBgPxRV0=
Message-ID: <6ec5f7d4-df0d-42b5-a882-824e2df017ec@arm.com>
Date: Thu, 16 Jul 2026 11:59:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] firmware: arm_rmm: Add SMC definitions for calling
 the RMM
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-2-steven.price@arm.com>
 <20260715143804.ADDF41F000E9@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715143804.ADDF41F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Low] `struct rec_exit` contains 4 bytes of implicit compiler padding between `padding9` and `plane`.
> - [Low] Discrepancy between the `PROT_MAP` macro prefix and the `DATA_MAP` comment and SMC command name.
> --
> 
> --- Patch [1]: [PATCH 1/6] firmware: arm_rmm: Add SMC definitions for calling the RMM ---
> commit c161f24da1669945cb4dc961f3a3c4ef452450b6
> Author: Steven Price <steven.price@arm.com>
> firmware: arm_rmm: Add SMC definitions for calling the RMM
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
>> new file mode 100644
>> index 0000000000000..c965e8867518f
>> --- /dev/null
>> +++ b/include/linux/arm-smccc-rmi.h
> 
> [ ... ]
> 
>> +	union { /* 0x600 */
>> +		struct {
>> +			u16 imm;
>> +			u16 padding9;
>> +			u64 plane;
> 
> [Severity: Low]
> Does this struct layout contain implicit padding? The sequence of two u16
> fields followed by a u64 field forces the compiler to inject 4 bytes of
> padding to align the plane field to an 8-byte boundary. While deterministic
> on ARM64, implicit padding in ABI structures shared with firmware is usually
> avoided. Should an explicit 32-bit padding field be added here?

Indeed this padding is broken. Amusingly I'd actually asked AI to write
a script to generate this file from the specification source (which had
identified a few minor issues that I'd already fix), but it managed to
preserve this bug :(

I've fixed the script and this now produces:

                struct {
                        u16 imm;
                        u8 padding9[6];
                        u64 plane;
                };

>> +		};
>> +		u8 padding6[0x100];
>> +	};
> 
> [ ... ]
> 
>> +/* RMI_RTT_DATA_MAP_FLAGS definitions */
>> +#define RMI_RTT_PROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
>> +#define RMI_RTT_PROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
> 
> [Severity: Low]
> This isn't a bug, but there seems to be a naming discrepancy. The comment
> mentions RMI_RTT_DATA_MAP_FLAGS, which corresponds to the
> SMC_RMI_RTT_DATA_MAP command, but the macros are prefixed with
> RMI_RTT_PROT_MAP_FLAGS. Should these macros use the DATA_MAP prefix instead?

These comments were manually generated - again I've fixed the script to
generate the comments automatically to avoid this mismatch in the future.

Thanks,
Steve

>> +
>> +/* S2AP Direct Encodings, used in RMI_RTT_UNPROT_MAP_FLAGS_S2AP */
>> +#define RMI_S2AP_DIRECT_WRITE			BIT(0)
>> +#define RMI_S2AP_DIRECT_READ			BIT(1)
>> +
>> +#endif /* __LINUX_ARM_SMCCC_RMI_H_ */
> 

