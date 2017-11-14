From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Tue, 14 Nov 2017 16:11:03 +0000
Message-ID: <5A0B1597.3030809@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <20171113161445.xfqyuntza76ckdmq@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C99C49D4C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:10:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jL-moibD+SF2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Nov 2017 11:10:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7583E49D46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Nov 2017 11:10:44 -0500 (EST)
In-Reply-To: <20171113161445.xfqyuntza76ckdmq@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Jonathan.Zhang@cavium.com, Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 13/11/17 16:14, Andrew Jones wrote:
> On Mon, Nov 13, 2017 at 12:29:46PM +0100, Christoffer Dall wrote:
>> On Thu, Nov 09, 2017 at 06:14:56PM +0000, James Morse wrote:
>>> On 19/10/17 15:57, James Morse wrote:
>>>> Known issues:
>>>>  * KVM-Migration: VDISR_EL2 is exposed to userspace as DISR_EL1, but how should
>>>>    HCR_EL2.VSE or VSESR_EL2 be migrated when the guest has an SError pending but
>>>>    hasn't taken it yet...?
>>>
>>> I've been trying to work out how this pending-SError-migration could work.

[..]

>>> To get out of this corner: why not declare pending-SError-migration an invalid
>>> thing to do?
>>
>> To answer that question we'd have to know if that is generally a valid
>> thing to require.  How will higher level tools in the stack deal with
>> this (e.g. libvirt, and OpenStack).  Is it really valid to tell them
>> "nope, can't migrate right now".  I'm thinking if you have a failing
>> host and want to signal some error to the guest, that's probably a
>> really good time to migrate your mission-critical VM away to a different
>> host, and being told, "sorry, cannot do this" would be painful.  I'm
>> cc'ing Drew for his insight into libvirt and how this is done on x86,
>> but I'm not really crazy about this idea.

> Without actually confirming, I'm pretty sure it's handled with a best
> effort to cancel the migration, continuing/restoring execution on the
> source host (or there may be other policies that could be set as well).
> Naturally, if the source host is going down and the migration is
> cancelled, then the VM goes down too...

> Anyway, I don't think we would generally want to introduce guest
> controlled migration blockers. IIUC, this migration blocker would remain
> until the guest handled the SError, which it may never unmask.

Yes, given the guest can influence this it needs exposing so it can be migrated.


[...]

>> My suggestion would be to add some set of VCPU exception state,
>> potentially as flags, which can be migrated along with the VM, or at
>> least used by userspace to query the state of the VM, if there exists a
>> reliable mechanism to restore the state again without any side effects.
>>
>> I think we have to comb through Documentation/virtual/kvm/api.txt to see
>> if we can reuse anything, and if not, add something.  We could also
> 
> Maybe KVM_GET/SET_VCPU_EVENTS? Looks like the doc mistakenly states it's
> a VM ioctl, but it's a VCPU ioctl.

Hmm, if I suppress my register-size pedantry we can put the lower 32 bits of
VSESR_EL2 in exception.error_code and use has_error_code to mark it valid.
'exception' in this struct ends up meaning SError on arm64.

(While VSESR_EL2 is 64bit[0], the value gets written into the ESR, which is
32bit, so I doubt the top 32bits can be used, currently they are all reserved.)

I'll go dig into how x86 uses this...


Thanks!

James


[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
