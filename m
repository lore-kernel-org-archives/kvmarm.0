From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Thu, 15 Feb 2018 17:55:00 +0000
Message-ID: <5A85C974.70500@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com>
 <5A70C5A0.1050600@arm.com> <d1b17dae-9d9c-970a-d164-a41c618d449b@huawei.com>
 <5A7DDDEE.9050306@arm.com> <93d07d3e-8388-7814-d674-538071d84e2a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A17401CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Feb 2018 12:51:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SwtMrnevxd7f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Feb 2018 12:51:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E4E40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Feb 2018 12:51:09 -0500 (EST)
In-Reply-To: <93d07d3e-8388-7814-d674-538071d84e2a@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "lv.zheng@intel.com" <lv.zheng@intel.com>, Huangshaoyu <huangshaoyu@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "devel@acpica.org" <devel@acpica.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 12/02/18 10:19, gengdongjiu wrote:
> On 2018/2/10 1:44, James Morse wrote:
>> The point? We can't know what a CPU without the RAS extensions puts in there.
>>
>> Why Does this matter? When migrating a pending SError we have to know the
>> difference between 'use this 64bit value', and 'the CPU will generate it'.
>> If I make an SError pending with ESR=0 on a CPU with VSESR, I can't migrated to
>> a system that generates an impdef SError-ESR, because I can't know it will be 0.

> For the target system, before taking the SError, no one can know whether its syndrome value
> is IMPLEMENTATION DEFINED or architecturally defined.

For a virtual-SError, the hypervisor knows what it generated. (do I have
VSESR_EL2? What did I put in there?).


> when the virtual SError is taken, the ESR_ELx.IDS will be updated, then we can know
> whether the ESR value is impdef or architecturally defined.

True, the guest can't know anything about a pending virtual SError until it
takes it. Why is this a problem?


> It seems migration is only allowed only when target system and source system all support
> RAS extension, because we do not know whether its syndrome is IMPLEMENTATION DEFINED or
> architecturally defined.

I don't think Qemu allows migration between hosts with differing guest-ID
registers. But we shouldn't depend on this, and we may want to hide the v8.2 RAS
features from the guest's ID register, but still use them from the host.

The way I imagined it working was we would pack the following information into
that events struct:
{
	bool serror_pending;
	bool serror_has_esr;
	u64  serror_esr;
}

The problem I was trying to describe is because there is no value of serror_esr
we can use to mean 'Ignore this, I'm a v8.0 CPU'. VSESR_EL2 is a 64bit register,
any bits we abuse may get a meaning we want to use in the future.

When it comes to migration, v8.{0,1} systems can only GET/SET events where
serror_has_esr == false, they can't use the serror_esr. On v8.2 systems we
should require serror_has_esr to be true.

If we need to support migration from v8.{0,1} to v8.2, we can make up an impdef
serror_esr.

We will need to decide what KVM does when SET is called but an SError was
already pending. 2.5.3 "Multiple SError interrupts" of [0] has something to say.


Happy new year,

James


[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
