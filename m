From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 06/26] arm64/sve: Check SVE virtualisability
Date: Thu, 21 Feb 2019 13:36:26 +0000
Message-ID: <ea9a0255-5829-883c-d28c-0c34716bbbdb@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C4F4A200
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 08:36:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T5e0JY8FDzPM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Feb 2019 08:36:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1C2C4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 08:36:30 -0500 (EST)
In-Reply-To: <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/02/2019 19:52, Dave Martin wrote:
> +	/*
> +	 * Mismatches above sve_max_virtualisable_vl are fine, since
> +	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
> +	 */
> +	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
> +		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
> +			smp_processor_id());

Would it be worth to print the unsupported vector length?

Cheers,

-- 
Julien Grall
