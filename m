From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Thu, 7 Jan 2016 22:35:53 +0800
Message-ID: <568E77C9.4060004@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <568E6E94.8090106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C7474976C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 09:33:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0sMZDB0o-BdU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 09:33:05 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3166412ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 09:33:04 -0500 (EST)
In-Reply-To: <568E6E94.8090106@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/7 21:56, Marc Zyngier wrote:
> On 22/12/15 08:08, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
>> > the kvm_device_ops for it.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  Documentation/virtual/kvm/devices/arm-pmu.txt |  24 +++++
>> >  arch/arm64/include/uapi/asm/kvm.h             |   4 +
>> >  include/linux/kvm_host.h                      |   1 +
>> >  include/uapi/linux/kvm.h                      |   2 +
>> >  virt/kvm/arm/pmu.c                            | 128 ++++++++++++++++++++++++++
>> >  virt/kvm/kvm_main.c                           |   4 +
>> >  6 files changed, 163 insertions(+)
>> >  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
>> > 
>> > diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> > new file mode 100644
>> > index 0000000..dda864e
>> > --- /dev/null
>> > +++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> > @@ -0,0 +1,24 @@
>> > +ARM Virtual Performance Monitor Unit (vPMU)
>> > +===========================================
>> > +
>> > +Device types supported:
>> > +  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
>> > +
>> > +Instantiate one PMU instance for per VCPU through this API.
>> > +
>> > +Groups:
>> > +  KVM_DEV_ARM_PMU_GRP_IRQ
>> > +  Attributes:
>> > +    The attr field of kvm_device_attr encodes one value:
>> > +    bits:     | 63 .... 32 | 31 ....  0 |
>> > +    values:   |  reserved  | vcpu_index |
>> > +    A value describing the PMU overflow interrupt number for the specified
>> > +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
>> > +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
>> > +    same for all vcpus, while as a SPI it must be different for each vcpu.
> I don't see anything enforcing these restrictions in the code (you can
> program different PPIs on each vcpu, or the same SPI everywhere, and
> nothing will generate an error).
> 
> Is that something we want to enforce? Or we're happy just to leave it as
> an unsupported corner case?
> 

Yeah, it should add the check. How about below check?

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 0ccf273..c3347e9 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -435,6 +435,29 @@ static void kvm_arm_pmu_destroy(struct kvm_device *dev)
        kfree(dev);
 }

+static bool irq_is_invalid(kvm_device *dev, int irq, bool is_ppi)
+{
+       int i;
+       struct kvm_vcpu *vcpu;
+       struct kvm *kvm = dev->kvm;
+
+       kvm_for_each_vcpu(i, vcpu, kvm) {
+               struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+               if (!kvm_arm_pmu_initialized(vcpu))
+                       continue;
+
+               if (is_ppi)
+                       if (pmu->irq_num != irq)
+                               return true;
+               else
+                       if (pmu->irq_num == irq)
+                               return true;
+       }
+
+       return false;
+}
+
 static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
                                struct kvm_device_attr *attr)
 {
@@ -452,7 +475,8 @@ static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
                 * the interrupt number is same for all vcpus, while as
a SPI it
                 * must be different for each vcpu.
                 */
-               if (reg < VGIC_NR_SGIS || reg >=
dev->kvm->arch.vgic.nr_irqs)
+               if (reg < VGIC_NR_SGIS || reg >=
dev->kvm->arch.vgic.nr_irqs ||
+                   irq_is_invalid(dev, reg, reg < VGIC_NR_PRIVATE_IRQS))
                        return -EINVAL;

                return kvm_arm_pmu_irq_access(dev->kvm, attr, &reg, true);

Thanks,
-- 
Shannon
