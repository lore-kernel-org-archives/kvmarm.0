From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 13/26] KVM: arm64/sve: System register context switch
 and access support
Date: Wed, 27 Feb 2019 12:02:46 +0000
Message-ID: <5a7dc2f4-a6e7-28bb-64d7-4f64424eb5c2@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-14-git-send-email-Dave.Martin@arm.com>
 <8a0e6089-b77b-151b-eacd-34ad13f39ac6@arm.com>
 <20190226170105.GB3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852B24A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 07:02:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iENNSCm2AagI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Feb 2019 07:02:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 443544A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 07:02:52 -0500 (EST)
In-Reply-To: <20190226170105.GB3567@e103592.cambridge.arm.com>
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

On 2/26/19 5:01 PM, Dave Martin wrote:
> On Tue, Feb 26, 2019 at 04:32:30PM +0000, Julien Grall wrote:
>> On 18/02/2019 19:52, Dave Martin wrote:
>> We seem to already have code for handling invariant registers as well as
>> reading ID register. I guess the only reason you can't use them is because
>> of the check the vcpu is using SVE.
>>
>> However, AFAICT the restrictions callback would prevent you to enter the
>> {get, set}_id if the vCPU does not support SVE. So the check should not be
>> reachable.
> 
> Hmmm, those checks were inherited from before this refactoring.
> 
> You're right: the checks are now done a common place, so the checks in
> the actual accessors should be redundant.
> 
> I could demote them to WARN(), but it may make sense simply to delete
> them.

I think removing the WARN() would be best as it would avoid to introduce 
most of the wrappers for the registers.

> 
> The access_id_aa64zfr0_el1() should still be reachable, since we don't
> have REG_NO_GUEST for this.

__access_id_reg is taking a boolean to tell whether the register is RAZ 
or not. So you probably could re-use it passing !vcpu_has_sve(vcpu).

It feels to me we would introduce a new restriction to tell whether the 
register should be RAZ. Anyway, the new restriction is probably for a 
follow-up patch.

Cheers,

-- 
Julien Grall
