From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 06/26] arm64/sve: Check SVE virtualisability
Date: Tue, 26 Feb 2019 15:43:06 +0000
Message-ID: <a313827f-ccb3-fb26-6e06-26665c1e436b@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
 <ea9a0255-5829-883c-d28c-0c34716bbbdb@arm.com>
 <20190226120647.GI3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FAFC4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 10:43:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z1gYvOKIPNxy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 10:43:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC094A2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 10:43:10 -0500 (EST)
In-Reply-To: <20190226120647.GI3567@e103592.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 26/02/2019 12:06, Dave Martin wrote:
> On Thu, Feb 21, 2019 at 01:36:26PM +0000, Julien Grall wrote:
>> Hi Dave,
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> +	/*
>>> +	 * Mismatches above sve_max_virtualisable_vl are fine, since
>>> +	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
>>> +	 */
>>> +	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
>>> +		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
>>> +			smp_processor_id());
>>
>> Would it be worth to print the unsupported vector length?
> 
> Possibly not, but admittedly the intent is a bit unclear in this patch.
> 
> See my reply to Julien Thierry (and respond on that subthread if you
> have comments, so that we don't end up with two subthreads discussing
> the same thing...)

I will have a look at the thread.

Cheers,

-- 
Julien Grall
