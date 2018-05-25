From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCHv2] ARM64: KVM: use lm_alias() for kvm_ksym_ref()
Date: Fri, 25 May 2018 12:08:28 +0100
Message-ID: <1f54d71c-6ae1-732f-3ee0-99e38287a3b0@arm.com>
References: <20180510111347.32253-1-mark.rutland@arm.com>
 <20180525105010.qswcppfkybznmzka@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055794070F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 06:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gy32a2-F4k3P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 06:57:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E9640683
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 06:57:49 -0400 (EDT)
In-Reply-To: <20180525105010.qswcppfkybznmzka@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 25/05/18 11:50, Mark Rutland wrote:
> On Thu, May 10, 2018 at 12:13:47PM +0100, Mark Rutland wrote:
>> For historical reasons, we open-code lm_alias() in kvm_ksym_ref().
>>
>> Let's use lm_alias() to avoid duplication and make things clearer.
>>
>> As we have to pull this from <linux/mm.h> (which is not safe for
>> inclusion in assembly), we may as well move the kvm_ksym_ref()
>> definition into the existing !__ASSEMBLY__ block.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>  arch/arm64/include/asm/kvm_asm.h | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Marc, Christoffer, are you happy to pick this up?

I've queued it some time ago (see kvmarm/queue), but failed to mention
it on the list...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
