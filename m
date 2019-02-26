From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 02/26] arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on
 task state flush
Date: Tue, 26 Feb 2019 12:35:41 +0000
Message-ID: <3d60d05b-05e5-efe8-f174-a449dbc97445@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-3-git-send-email-Dave.Martin@arm.com>
 <7e358d11-4896-1f09-0496-70a78eb60736@arm.com>
 <20190226120601.GF3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E306D4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:35:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l1qyXqYDMhIA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:35:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C193E4A321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:35:44 -0500 (EST)
In-Reply-To: <20190226120601.GF3567@e103592.cambridge.arm.com>
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



On 26/02/2019 12:06, Dave Martin wrote:
> On Thu, Feb 21, 2019 at 12:39:39PM +0000, Julien Grall wrote:
>> Hi Dave,
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> This patch updates fpsimd_flush_task_state() to mirror the new
>>> semantics of fpsimd_flush_cpu_state() introduced by commit
>>> d8ad71fa38a9 ("arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
>>> invalidating cpu regs").  Both functions now implicitly set
>>
>> NIT: Double-space before "Both"
>>
>>> TIF_FOREIGN_FPSTATE to indicate that the task's FPSIMD state is not
>>> loaded into the cpu.
>>>
>>> As a side-effect, fpsimd_flush_task_state() now sets
>>> TIF_FOREIGN_FPSTATE even for non-running tasks.  In the case of
>>
>> NIT: Double sppace before "In".
>>
>>> non-running tasks this is not useful but also harmless, because the
>>> flag is live only while the corresponding task is running.  This
>>> function is not called from fast paths, so special-casing this for
>>> the task == current case is not really worth it.
>>>
>>> Compiler barriers previously present in restore_sve_fpsimd_context()
>>> are pulled into fpsimd_flush_task_state() so that it can be safely
>>> called with preemption enabled if necessary.
>>>
>>> Explicit calls to set TIF_FOREIGN_FPSTATE that accompany
>>> fpsimd_flush_task_state() calls and are now redundant are removed
>>> as appropriate.
>>>
>>> fpsimd_flush_task_state() is used to get exclusive access to the
>>> representation of the task's state via task_struct, for the purpose
>>> of replacing the state.  Thus, the call to this function should
>>
>> NIT: Double-space before "Thus".
>>
>>> happen before manipulating fpsimd_state or sve_state etc. in
>>> task_struct.  Anomalous cases are reordered appropriately in order
>>
>> NIT: Double-space before "Anomalous".
> 
> A habit rather than a mistake [1], and I don't propose to change it ;)

I wasn't aware of this. Thank you for the pointer! Please ignore the comments on 
it :).


Cheers,

-- 
Julien Grall
