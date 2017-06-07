From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 00/11] arm64/firmware: Software Delegated Exception
 Interface
Date: Wed, 07 Jun 2017 10:45:32 +0100
Message-ID: <5937CB3C.6040800@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170606195944.GM9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F39040A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:42:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4g85pNRPuKyW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Jun 2017 05:42:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A137440905
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:42:12 -0400 (EDT)
In-Reply-To: <20170606195944.GM9464@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 06/06/17 20:59, Christoffer Dall wrote:
> On Mon, May 15, 2017 at 06:43:48PM +0100, James Morse wrote:
>> Running the event handler behind VHE-KVM's back has some side effects: The
>> event handler will blindly use any registers that are shared between the host
>> and guest. The two that I think matter are TPIDR_EL1, and the debug state. The
>> guest may have set MDSCR_EL1 so debug exceptions must remain masked. The
>> guest's TPIDR_EL1 will be used by the event handler if it accesses per-cpu
>> variables. This needs fixing. The first part of this series juggles KVMs use
>> of TPIDR_EL2 so that we share it with the host on VHE systems. An equivalent
>> change for 32bit is on my todo list. (one alternative to this is to have a
>> parody world switch in the SDEI event handler, but this would mean special
>> casing interrupted guests, and be an ABI link to KVM.)
>>
>> Causing a synchronous exception from an event handler will cause KVM to
>> hyp-panic, but may silently succeed if the event didn't interrupt a guest.
>> (I may WARN_ON() if this happens in a later patch). You because of this you
> 
> The last sentence here doesn't make much sense to me.

If this interrupts a VHE-guest, KVM's hyp-vectors remain in vbar_el2. If we then
take a synchronous exception, KVM will assume this happened during world switch
and panic.
In contrast if you didn't interrupt a guest, the kernel vectors are in vbar_el2,
so the fault will be handled.

This 'silently succeed' only occurred to me when writing the cover-letter,
(hence its probably worded badly). I plan to catch it by save-restoring the
exception registers, and warning if they've changed as this would hyp-panic if
you interrupted a guest.


> For the rest of the KVM part it looks mostly good to me, besides the
> points I raised in the individual patches.

Thanks for taking a look!


Thanks,

James
