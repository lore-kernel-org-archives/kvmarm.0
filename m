From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v10 8/8] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Mon, 23 Jan 2017 17:03:55 +0530
Message-ID: <CALicx6vqdLvbYmbdQkqUns_v1O+RGq0EYpOEMNJAiBWTigM1Qw@mail.gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-9-git-send-email-vijay.kilari@gmail.com>
 <7d82df18-debd-72e7-af6e-3816b8aaee85@redhat.com>
 <20170120195722.GJ13531@cbox>
 <CALicx6twCMrK8gb=zR1wt1eH-eiPDyA3=BnLPFy=22O5wW52ew@mail.gmail.com>
 <20170123112019.GC15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6323C40971
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:33:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k0Q2Hb4d9KSk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 06:33:51 -0500 (EST)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7919340190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:33:51 -0500 (EST)
Received: by mail-oi0-f67.google.com with SMTP id w144so10504673oiw.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 03:33:56 -0800 (PST)
In-Reply-To: <20170123112019.GC15850@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 23, 2017 at 4:50 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Mon, Jan 23, 2017 at 04:22:39PM +0530, Vijay Kilari wrote:
>> Hi Christoffer,
>>
>> In the document,
>>
>>     The mpidr field is used to specify which
>>     redistributor is accessed.  The mpidr is ignored for the distributor.
>>
>> We still rely on MPIDR for KVM_DEV_ARM_VGIC_GRP_DIST_REGS to fetch
>> vcpu info. So don't we need to remove this restriction?.
>> Or force to use vcpu[0]?
>
> Does the data we return ever change if you supply a diferent MPIDR and
> access a distributor register?  If not (and I don't think it should),
> then the API is properly defined but the internal implementation should
> not rely on the value provided by user space.

Data does not change. However the common uaccess code expects vcpu.

>
> Thanks,
> -Christoffer
>
>>
>> On Sat, Jan 21, 2017 at 1:27 AM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > On Fri, Dec 16, 2016 at 01:18:09PM +0100, Auger Eric wrote:
>> >> Hi Vijaya,
>> >>
>> >> On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
>> >> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >> >
>> >> > Update error code returned for Invalid CPU interface register
>> >> > value and access in AArch32 mode.
>> >> >
>> >> > Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >> > ---
>> >> >  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 9 ++++++++-
>> >> >  1 file changed, 8 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> >> > index 9348b3c..0f29850 100644
>> >> > --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> >> > +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> >> > @@ -142,10 +142,12 @@ Groups:
>> >> >      KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
>> >> >      CPU specified by the mpidr field.
>> >> >
>> >> > +    CPU interface registers access is not implemented for AArch32 mode.
>> >> > +    Error -ENXIO is returned when accessed in AArch32 mode.
>> >> >    Errors:
>> >> >      -ENXIO: Getting or setting this register is not yet supported
>> >> >      -EBUSY: VCPU is running
>> >> > -    -EINVAL: Invalid mpidr supplied
>> >> > +    -EINVAL: Invalid mpidr or register value supplied
>> >> >
>> >> >
>> >> >    KVM_DEV_ARM_VGIC_GRP_NR_IRQS
>> >> > @@ -193,6 +195,11 @@ Groups:
>> >> >
>> >> >     Bit[n] indicates the status for interrupt vINTID + n.
>> >> >
>> >> > +   Getting or setting the level info for an edge-triggered interrupt is
>> >> > +   not guaranteed to work.
>> >> I don't get this statement. is the API applicable to edge triggered IRQs?
>> >>
>> >
>> > I guess this could be clarified to "is ignored", but with the earlier
>> > implementation you might be able to get away with doing
>> > "line_level=x; config=LEVEL;", but you could then at the same time break
>> > something with edge-triggered IRQs, so...
>> >
>> >
>> > Thanks for looking at this in detail.
>> >
>> > -Christoffer
