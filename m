From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/21] arm64: KVM: VHE: Split save/restore of sysregs
 shared between EL1 and EL2
Date: Tue, 2 Feb 2016 09:46:05 +0000
Message-ID: <56B07ADD.60300@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-11-git-send-email-marc.zyngier@arm.com>
 <20160201135438.GL1478@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0F040F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 04:40:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s56Ii+uYDcR9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2016 04:40:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91AB640BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 04:40:47 -0500 (EST)
In-Reply-To: <20160201135438.GL1478@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/16 13:54, Christoffer Dall wrote:
> On Mon, Jan 25, 2016 at 03:53:44PM +0000, Marc Zyngier wrote:
>> A handful of system registers are still shared between EL1 and EL2,
>> even while using VHE. These are tpidr*_el[01], actlr_el1, sp0, elr,
>> and spsr.
> 
> So by shared registers you mean registers that do both have an EL0/1
> version as well as an EL2 version, but where accesses aren't rewritten
> transparently?

No, I mean that these registers do *not* have a separate banked version.
There is only a single set of registers, which have to be save/restored
the old way.

> 
> also, by sp0 do you mean sp_el0, and by elr you mean elr_el1, and by
> spsr you mean spsr_el1 ?

sp0 -> sp_el0 indeed. elr and spsr really are the guest PC and PSTATE,
so I should really reword this commit message, it is utterly confusing.

> 
>>
>> In order to facilitate the introduction of a VHE-specific sysreg
>> save/restore, make move the access to these registers to their
>> own save/restore functions.
>>
>> No functionnal change.
> 
> Otherwise:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
