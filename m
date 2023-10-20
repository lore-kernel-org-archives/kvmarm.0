Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EB813AC4
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67BA22F4;
	Fri, 20 Oct 2023 06:22:25 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0712C3F5A1;
	Fri, 20 Oct 2023 06:21:41 -0700 (PDT)
Message-ID: <59a62837-1adf-43a5-8716-8068ddbdb7cf@arm.com>
Date: Fri, 20 Oct 2023 14:21:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] arm64/mm: Update non-range tlb invalidation
 routines for FEAT_LPA2
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <20231009185008.3803879-2-ryan.roberts@arm.com>
 <87zg0f59ae.wl-maz@kernel.org> <dc65e68c-379f-4dfa-a7af-f066e943177c@arm.com>
 <86edhpn2gd.wl-maz@kernel.org> <8a098442-4de8-42f1-9308-848a1d54f21a@arm.com>
 <87v8b15twh.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <87v8b15twh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 14:02, Marc Zyngier wrote:
> On Fri, 20 Oct 2023 13:39:47 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> On 20/10/2023 09:05, Marc Zyngier wrote:
>>> Maybe. There is something to be said about making the range rework
>>> (decreasing scale) an independent patch, as it is a significant change
>>> on its own. But maybe the rest of the plumbing can be grouped
>>> together.
>>
>> But that's effectively the split I have now, isn't it? The first patch
>> introduces TLBI_TTL_UNKNOWN to enable use of 0 as a ttl hint. Then the second
>> patch reworks the range stuff. I don't quite follow what you are suggesting.
> 
> Not quite.
> 
> What I'm proposing is that you pull the scale changes in their own
> patch, and preferably without any change to the external API (i.e. no
> change to the signature of the helper). They any extra change, such as
> the TTL rework can go separately.
> 
> So while this is similar to your existing split, I'd like to see it
> without any churn around the calling convention. Which means turning
> the ordering around, and making use of a static key in the various
> helpers that need to know about LPA2.

I don't think we can embed the static key usage directly inside
__flush_tlb_range_op() (if that's what you were suggesting), because this macro
is used by both the kernel (for its stage 1) and the hypervisor (for stage 2).
And the kernel doesn't support LPA2 (until Ard's work is merged). So I think
this needs to be an argument to the macro.

Or are you asking that I make the scale change universally, even if LPA2 is not
in use? I could do that as its own change change (which I could benchmark), then
add the rest in a separate change. But my thinking was that we would not want to
change the algorithm for !LAP2 since it is not as effcient (due to the LPA2 64K
alignment requirement).

Sorry for laboring the point - I just want to make sure I understand what you
are asking for.


> 
> 	M.
> 

