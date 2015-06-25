From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 25 Jun 2015 09:48:43 +0100
Message-ID: <558BC06B.3090204@arm.com>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com> <20150625080457.GD28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150625080457.GD28244@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 25/06/15 09:04, Christoffer Dall wrote:
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

When the kernel boots. The OSV guys also have seen this (time going
backward), and this patch seems to have solved their problem.

> IIRC, QEMU creates a throw-away VM with the default CPU target time,
> reads out all the system registers to get the KVM reset values of those,
> then creates the real VM, and feeds back in all the system register
> reset values, as a method for QEMU and KVM to be in sync about the reset
> state of the machine.  If we do this, and include CNTVCT, then that
> would probably trigger this, but the VCPU really shouldn't have been run
> at that time...

I definitely see this process happening, but that doesn't seem to be the
problem.

> We should prevent userspace from fiddling with this register post VCPU
> start regardless, but yes, it would be good to find out why this is
> happening in the first place.

My main problem is that I cannot easily correlate what is happening in
the guest at that time with something touching CNTVCT. That's just odd.

> How did you notice this and does it manifest itself in some user-visible
> ugliness?

It was first reported by the OSV guys, and I then spotted some
interesting hrtimers taking too long at guest boot time. Putting some
traces quickly identified the issue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
