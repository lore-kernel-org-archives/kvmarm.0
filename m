From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/21] arm64: KVM: VHE: Split save/restore of sysregs
 shared between EL1 and EL2
Date: Tue, 2 Feb 2016 16:19:44 +0000
Message-ID: <56B0D720.9000901@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-11-git-send-email-marc.zyngier@arm.com>
 <20160201135438.GL1478@cbox> <56B07ADD.60300@arm.com>
 <20160202154645.GE6190@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290B540B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 11:14:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FIVFl7ZF+8Jb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2016 11:14:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20311407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 11:14:25 -0500 (EST)
In-Reply-To: <20160202154645.GE6190@cbox>
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

On 02/02/16 15:46, Christoffer Dall wrote:
> On Tue, Feb 02, 2016 at 09:46:05AM +0000, Marc Zyngier wrote:
>> On 01/02/16 13:54, Christoffer Dall wrote:
>>> On Mon, Jan 25, 2016 at 03:53:44PM +0000, Marc Zyngier wrote:
>>>> A handful of system registers are still shared between EL1 and EL2,
>>>> even while using VHE. These are tpidr*_el[01], actlr_el1, sp0, elr,
>>>> and spsr.
>>>
>>> So by shared registers you mean registers that do both have an EL0/1
>>> version as well as an EL2 version, but where accesses aren't rewritten
>>> transparently?
>>
>> No, I mean that these registers do *not* have a separate banked version.
>> There is only a single set of registers, which have to be save/restored
>> the old way.
> 
> huh, ARMv8 clearly specifies the existence of TPIDR_EL0, TPIDR_EL1, and
> TPIDR_EL2, for example.
> 
> I cannot seem to find anywhere in the VHE spec that says that the
> TPIDR_EL2 goes away.  I'm confused now.

Nothing goes away, but these registers do not get renamed either. For
example, TPIDR_EL1 doesn't magically access TPIDR_EL2 when running at
EL2+VHE, and there is no TPIDR_EL12 accessor either.

So TPIDR_EL1 is effectively "shared" between host and guest, and must be
save/restored (note that the host kernel still uses TIPDR_EL1 even when
running with VHE, and that KVM still uses TPIDR_EL2 to cache the current
vcpu).

>>
>>>
>>> also, by sp0 do you mean sp_el0, and by elr you mean elr_el1, and by
>>> spsr you mean spsr_el1 ?
>>
>> sp0 -> sp_el0 indeed. elr and spsr really are the guest PC and PSTATE,
>> so I should really reword this commit message, it is utterly confusing.
>>
> I guess I don't understand the definition of a 'shared' register given
> your comments here...

Does this make it clearer?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
