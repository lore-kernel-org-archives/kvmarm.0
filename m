From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 14/26] KVM: arm64/sve: Context switch the SVE registers
Date: Tue, 26 Feb 2019 16:56:36 +0000
Message-ID: <82b7b947-7e92-15df-5c71-6d562141264e@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
 <83fa5587-24a0-5bbb-c113-cddc74571ea2@arm.com>
 <20190226121321.GQ3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D27AD4A330
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:56:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J6VPufxKg4Ec for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 11:56:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C14024A2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:56:40 -0500 (EST)
In-Reply-To: <20190226121321.GQ3567@e103592.cambridge.arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 26/02/2019 12:13, Dave Martin wrote:
> On Wed, Feb 20, 2019 at 04:46:57PM +0000, Julien Thierry wrote:
>>
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> In order to give each vcpu its own view of the SVE registers, this
>>> patch adds context storage via a new sve_state pointer in struct
>>> vcpu_arch.  An additional member sve_max_vl is also added for each
>>> vcpu, to determine the maximum vector length visible to the guest
>>> and thus the value to be configured in ZCR_EL2.LEN while the is
>>
>> "While the <guest> is active"?
> 
> Hmmm, yes.  Thanks for deciphering that.  Done.
I think it would be more consistent if you use "vcpu" over "guest". After all 
ZCR_EL2.LEN is per vCPU.

Cheers,

-- 
Julien Grall
