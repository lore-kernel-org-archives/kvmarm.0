From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 08/26] arm64/sve: Enable SVE state tracking for
 non-task contexts
Date: Tue, 26 Feb 2019 15:49:00 +0000
Message-ID: <b1d64e84-1c59-d1a6-7893-212b5cd3a7ac@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-9-git-send-email-Dave.Martin@arm.com>
 <dc379691-ab3a-79a6-b760-59a02aa40717@arm.com>
 <20190226120713.GL3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 795C24A34E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 10:49:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KpLeE2OOR7lV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 10:49:04 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D11749E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 10:49:04 -0500 (EST)
In-Reply-To: <20190226120713.GL3567@e103592.cambridge.arm.com>
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

On 26/02/2019 12:07, Dave Martin wrote:
> On Fri, Feb 22, 2019 at 03:26:51PM +0000, Julien Grall wrote:
>> Hi Dave,
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> The current FPSIMD/SVE context handling support for non-task (i.e.,
>>> KVM vcpu) contexts does not take SVE into account.  This means that
>>
>> NIT: Double-space before "This".
> 
> See patch 2...
> 
> [...]
> 
> Does the code look reasonable to you?  This interacts with FPSIMD/SVE
> context switch in the host, so it would be good to have your view on it.

I wanted to look at the rest before giving my reviewed-by tag.
FWIW, this patch looks reasonable to me.

Cheers,

-- 
Julien Grall
