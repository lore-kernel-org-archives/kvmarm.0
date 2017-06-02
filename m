From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 02 Jun 2017 11:16:10 +0100
Message-ID: <59313AEA.2060705@arm.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <20170601222235.GN20919@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63FF540C58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 06:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nbdMNptjRnAR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 06:12:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A782E40960
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 06:12:57 -0400 (EDT)
In-Reply-To: <20170601222235.GN20919@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 01/06/17 23:22, Christoffer Dall wrote:
> On Wed, May 24, 2017 at 05:32:50PM +0100, James Morse wrote:
>> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64, notifications for
>> broken memory can call memory_failure() in mm/memory-failure.c to deliver
>> SIGBUS to any user space process using the page, and notify all the
>> in-kernel users.
>>
>> If the page corresponded with guest memory, KVM will unmap this page
>> from its stage2 page tables. The user space process that allocated
>> this memory may have never touched this page in which case it may not
>> be mapped meaning SIGBUS won't be delivered.

> Sorry, I don't remember, what is the scenario where KVM can have a
> mapping in stage 2 without there being a corresponding mapping for user
> space?

(looks like I mean more than one thing by mapping... oops.)

Mapping in that there is a physical page for this user-space address, but when
qemu first touches it, it will be faulted in as its not been touched before.

(rambling on:)
When mm/memory_failure.c:memory_failure() walks the rmap for the poisoned page
it doesn't find qemu, so no user-space processes gets signalled.

If qemu were to touch the page, fixup_user_fault() will return -EHWPOISON and we
deliver sigbus to qemu.

This doesn't happen when the guest touches the page as kvm's core code maps
-EHWPOISON to KVM_PFN_ERR_HWPOISON, which the arm/arm64 kvm code ignores and
drops -EFAULT on userspace instead.


>> This works well until a guest accesses that page, and KVM discovers
>> pfn == KVM_PFN_ERR_HWPOISON when it comes to process the stage2 fault.
>>
>> Do as x86 does, and deliver the SIGBUS when we discover
>> KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
> 
> But this part about the stage 2 mapping size is not what the code does.
> It uses the granularity of the mmap region, if I'm not mistaken.

Yes. This is what I got wrong last time, Punit put me right, but I forgot to
update the commit message.

I will change this 'Use the'... sentence in v3 to:
> Use the hugepage size as si_addr_lsb if this vma was allocated as a hugepage.
> Transparent hugepages will be split by memory_failure() before we see them
> here.


Thanks,

James
