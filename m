From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 1/7] arm/arm64: vgic-new: Implement support for
 userspace access
Date: Fri, 23 Sep 2016 10:50:38 +0100
Message-ID: <57E4FAEE.3070003@arm.com>
References: <1474351965-11586-1-git-send-email-vijay.kilari@gmail.com>
 <1474351965-11586-2-git-send-email-vijay.kilari@gmail.com>
 <57E3C9D8.7070906@arm.com>
 <CALicx6uuL9xX3VxLCy+EZi0AqXrNM_O+F3MN+W4gbiriUyb7Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C90849B34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:41:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iuuQLZhZAtQj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 05:41:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF23249B1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:41:30 -0400 (EDT)
In-Reply-To: <CALicx6uuL9xX3VxLCy+EZi0AqXrNM_O+F3MN+W4gbiriUyb7Ug@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/09/16 15:01, Vijay Kilari wrote:
> On Thu, Sep 22, 2016 at 5:38 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 20/09/16 07:12, vijay.kilari@gmail.com wrote:
>>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>> +static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>> +                          gpa_t addr, u32 *val)
>>> +{
>>> +     struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>> +     const struct vgic_register_region *region;
>>> +     struct kvm_vcpu *r_vcpu;
>>> +
>>> +     region = vgic_get_mmio_region(iodev, addr, sizeof(u32));
>>> +     if (!region) {
>>> +             *val = 0;
>>> +             return 0;
>>
>> This is not the previous semantic of vgic_uaccess, and I cannot see why
>> blindly ignoring an access to an undefined region would be acceptable.
>> What am I missing?
> 
> AFAIK, the vgic_uaccess is not making any check on undefined region/register.
> However, dispatch_mmio_read/write are returning 0 if check of region is failed

Hmmm. Fair enough. I don't really like it, but that's something for
another day.

	M.
-- 
Jazz is not dead. It just smells funny...
