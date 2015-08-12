From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: KVM Live migration with GICv3
Date: Wed, 12 Aug 2015 17:17:25 +0100
Message-ID: <55CB7195.2070505@arm.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
 <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
 <CALicx6s4BOuHsP40r2zuqgiLh+Rx=e=UQvwV5_R7LJB9-dpkig@mail.gmail.com>
 <019101d0d449$c6721210$53563630$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7290A5AD19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:04:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wG1sutBsLB4Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 12:04:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CBA5AD15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 12:04:20 -0400 (EDT)
In-Reply-To: <019101d0d449$c6721210$53563630$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Vijay Kilari' <vijay.kilari@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 11/08/15 16:24, Pavel Fedin wrote:
>  Hello!
> 
>> I mean CPU interface registers GICC* defined for vgicv2 under
>> "vgic_cpu_ranges[]" in
>> virt/kvm/arm/vgic-v2-emul.c needs to be saved and restored for vgicv3 as well.
>> So to  access vgic_cpu_ranges[] for vgicv3, we need to register device
>> for CPU registers space
>> similar to gicv2 in QEMU for gicv3.
> 
> This thing is optional and can be missing. It is for backwards
> compatibility only, it allows to run GICv2 guests on GICv3. You
> should not use this API for accessing system registers.

Even more than that.

The KVM emulation of GICv3 doesn't have *any* GICv2 compatibility. And
that's on purpose. So trying to save the GICC registers should give you
an error, because these registers *do not exist* as far as a guest is
concerned.

If you plan to do anything for GICv3, you should only deal with with the
system register version of the CPU interface.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
