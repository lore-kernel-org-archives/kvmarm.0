From: Claudio Fontana <claudio.fontana@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 25 Jun 2015 10:59:33 +0200
Message-ID: <558BC2F5.9010303@huawei.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
 <20150625080457.GD28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129C656F95
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 04:49:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RGz5MgUTQsOc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 04:49:24 -0400 (EDT)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B307556F91
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 04:49:24 -0400 (EDT)
In-Reply-To: <20150625080457.GD28244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 25.06.2015 10:04, Christoffer Dall wrote:
> On Wed, Jun 24, 2015 at 03:54:57PM +0100, Marc Zyngier wrote:
>> Userspace is allowed to set the guest's view of CNTVCT, which turns
>> into setting CNTVOFF for the whole VM. One thing userspace is not supposed
>> to do is to update that register while the guest is running. Time will
>> either move forward (best case) or backward (really bad idea). Either way,
>> this shouldn't happen.
>>
>> This patch prevents userspace from touching CNTVOFF as soon as a vcpu
>> has been started. This ensures that time will keep monotonically increase.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>
>> QEMU seems to trigger this at boot time, and I have no idea why it does so.
>> It would be good to find out, hence the RFC tag.
> 
> Is this at kernel boot time you see this, or at system startup time?
> 
> IIRC, QEMU creates a throw-away VM with the default CPU target time,
> reads out all the system registers to get the KVM reset values of those,
> then creates the real VM, and feeds back in all the system register
> reset values, as a method for QEMU and KVM to be in sync about the reset
> state of the machine.  If we do this, and include CNTVCT, then that
> would probably trigger this, but the VCPU really shouldn't have been run
> at that time...
> 
> We should prevent userspace from fiddling with this register post VCPU
> start regardless, but yes, it would be good to find out why this is
> happening in the first place.
> 
> How did you notice this and does it manifest itself in some user-visible
> ugliness?
> 
> Thanks,
> -Christoffer
> 


You can read the whole history here:

https://groups.google.com/forum/#!topic/osv-dev/2w101csH65E

It causes clock-related bugs with time jumping backward when relying on the virtual counter register in the guest, whenever a cpu is booted (primary, secondary via PSCI), and actually whenever the monitor is used to stop, info registers etc.

Once the VM is created, I think QEMU should not request kvm to change the virtual offset of the VM anymore: maybe an unexpected consequence of QEMU's target-arm/kvm64.c::kvm_arch_put_registers ?

Thanks,

Claudio
