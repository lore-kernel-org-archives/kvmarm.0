From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: KVM Live migration with GICv3
Date: Wed, 12 Aug 2015 17:34:25 +0100
Message-ID: <55CB7591.5080408@arm.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DCC35AAFE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YRX2zVZ2KlSE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 12:21:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A1E5A91F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:21:20 -0400 (EDT)
In-Reply-To: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, p.fedin@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/08/15 06:25, Vijay Kilari wrote:
> Hi,
> 
>    I have prototyped Live migration with GICv3.
> For this I have made following changes
> 
> 1) Save and Restore of GICv3 registers in QEMU.
>     - For GICv2, QEMU is saving/restoring GICD, GICC  registers. For GICv3,
>      we have to save/restore GICD, GICR and ICC registers.
>      However ICC registers are system registers which cannot be
> accessed @ EL0 level (SRE=1). So these ICC registers should be
> accessed as mmio registers by QEMU, for this we have to add ioctl to
> access ICC @ EL1 level similar to GICC registers of GICv2.

I've already replied to this. The ICC_* registers *must* be exposed as
system registers. There is no GICC_* state to save. And I don't get your
EL0 access thing.

> 
> 2) KVM ioctls in kernel provides only 32-bit register access to GIC
> registers, where
>    as some registers in GICD/GICR requires 64-bit register access. I
> propose to use mmio.flag to specify 32/64 bit access.

I don't believe the MMIO registers *require* 64bit access. The spec says:

"For the GITS_*, GICD_* and GICR_* registers, the upper 32 bits and the
lower 32 bits can be accessed independently, unless the register
requires a 64 bit access."

and as far as I can see, no register mandates a 64bit access.

> 
> 3) KVM ioctls to access ICC registers for GICv3
> 
> Please provide your initial feedback. Let me know if some of this
> issues are already fixed
> 
> I am attending KVM-forum next week @ Seattle. We can discuss there as well.

Feel free to come and talk to us.

	M.
-- 
Jazz is not dead. It just smells funny...
