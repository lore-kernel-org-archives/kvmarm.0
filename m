Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22D32D73B4
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 09:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024975; cv=none; b=EDhQX23B4BFcbWLBTgILJ1s6+FnL+AcGKiAlCn4Zb6Gr4ozRQyyuPfqFcXNS0Od45S3dUwWWFS5WcJtcNugAMzO4QxH9VgFc5HR9t0p/NX8c6qjXBFB50j9m7/ocN9oRTqo7whrYlMryDmQ1+rSmBHxuc+RPBma89CYlfjGMuaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024975; c=relaxed/simple;
	bh=WBZsViwp1w/94R7+GM2Cur4Lg1bIgbn0aJWLo1R31Y8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oh3P4bdNpyJKi4mBpMjTDeyiPCaE72E6hHhn/UkIXVitbjD7E10o5+0Ea4J8+xxyOn6C0OEPrJaHrNSlt4TH1NbzIiA3dzwqn1kWO/KGPcCrItdGDb7fvKpTZwsww3wnVZhsJEsfMaBbcPehmJwr/xZC17JCpNVm9AGTnmy7IE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0013B12FC;
	Thu, 13 Nov 2025 01:09:23 -0800 (PST)
Received: from [10.163.74.57] (unknown [10.163.74.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAB693F66E;
	Thu, 13 Nov 2025 01:09:27 -0800 (PST)
Message-ID: <dbc890f8-7105-4da5-a6fd-6f7b3a2b7147@arm.com>
Date: Thu, 13 Nov 2025 14:39:24 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 1/3] tools: header: arm64: Replace TCR_NFD[0|1] with
 TCR_EL1_NFD[0|1]
To: Leo Yan <leo.yan@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Namhyung Kim <namhyung@kernel.org>
References: <20251013052945.2197190-1-anshuman.khandual@arm.com>
 <20251013052945.2197190-2-anshuman.khandual@arm.com>
 <aQjm7wmvHa79hkyi@arm.com> <20251103180350.GZ281971@e132581.arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251103180350.GZ281971@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 03/11/25 11:33 PM, Leo Yan wrote:
> On Mon, Nov 03, 2025 at 05:31:27PM +0000, Catalin Marinas wrote:
>> On Mon, Oct 13, 2025 at 10:59:43AM +0530, Anshuman Khandual wrote:
>>> Replace TCR_NFD[0|1] (used in TCR_CLEAR_FUJITSU_ERRATUM_010001) with field
>>> definitions which are available in tool sysreg format. Helps in completely
>>> dropping off the adhoc TCR_NFD[0|1] macros later.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Cc: Namhyung Kim <namhyung@kernel.org>
>>> Cc: Leo Yan <leo.yan@arm.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  tools/arch/arm64/include/asm/cputype.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
>>> index 139d5e87dc95..dfa12df5e290 100644
>>> --- a/tools/arch/arm64/include/asm/cputype.h
>>> +++ b/tools/arch/arm64/include/asm/cputype.h
>>> @@ -243,7 +243,7 @@
>>>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
>>>  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
>>>  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
>>> -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
>>> +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
>>
>> Isn't this file usually updated automatically (well, someone running a
>> script to sync) from the corresponding arch/arm64/ one?
> 
> Yes, usually perf tools maintainers (Arnaldo or Namhyung) will sync
> headers in tools.
> 
> Seems to me, it is also fine to send this patch.  Please kindly remind
> perf maintainers after the kernel changes have been merged, so it is
> safe for picking up the change in tools.
> 
> BTW, I built the perf with this series and did not see any issue.

Agreed. I have not seen any problem around this as well.
