From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Increase GICV size to 64KB so !4KB page-size kernels are able to
 initialize KVM
Date: Thu, 23 Jun 2016 08:33:50 +0100
Message-ID: <576B90DE.5090004@arm.com>
References: <8b9c3e26-97b1-307f-8227-5ca3a4966c84@riken.jp>
 <576A630E.10800@arm.com> <57f56525-119a-8566-8d9b-43b7bcb23a49@riken.jp>
 <576A8298.20704@arm.com> <a168054f-b71c-944e-c91a-9a6a00404aa6@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C382649B30
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2016 03:28:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nY141d07HSnj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2016 03:28:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7122B49B2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2016 03:28:57 -0400 (EDT)
In-Reply-To: <a168054f-b71c-944e-c91a-9a6a00404aa6@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/06/16 04:17, Itaru Kitayama wrote:
> On 6/22/16 9:20 PM, Marc Zyngier wrote:
>> I'm only using DT, which works just fine on Overdrive, even with 64kB
>> pages.
>>
>> I think I understand the issue you're having, which is not what I
>> was thinking of. The issue is that because ACPI doesn't tell us
>> anything about the size of the GICV region, we have to assume that
>> it is 8kB, and cannot distinguish a safe platform from an unsafe
>> one, failing the size test on 64kB.
> 
> Is it likely in the future specification of ACPI the size information
> stored in the GIC subtable? In 6.1 or earlier, it seems optional to me.

I don't see any provision for that, and it is already too late (systems
exist in the wild).

> I also had to allow the not page-aligned physical address of GICV, below
> is an excerpt of apic.dsl
> 
> [054h 0084   8]     Virtual GIC Base Address : 00000000E116F000

Right, this is what I was referring to in my initial reply. The problem
is that we cannot know what is actually safe to map into a guest's
address space without any sizing information.

Also, we have the issue of mapping GICV at an offset in a page, which
userspace needs to be made aware of. So even with your hack, it is
unlikely that you'll be able to boot a guest because userspace has only
1/16th probability to map GICV at offset 0xf000.

Doing so requires reporting the page offset to userspace. I had this patch:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/264852.html

but that requires buy-in from QEMU (though I can do the corresponding
kvmtool change).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
