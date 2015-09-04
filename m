From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Fri, 04 Sep 2015 18:22:56 +0300
Message-ID: <023101d0e725$938927f0$ba9b77d0$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
 <55E9A267.4040404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55E9A267.4040404@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> > and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
> > KVM_GET_DEVICE_ATTR ioctls. Since GICv3 can handle large number of CPUs,
> > KVM_DEV_ARM_VGIC_CPUID_MASK has been extended to 20 bits. This is enough
> > for 1048576 CPUs.
> 
> I guess the 20 bits come from 8 bits for Aff2 and Aff1 and 4-bits for
> Aff0? If so, please mention this. But I am not sure we should limit the
> cpu index in this public API

 The documentation is confusing. It is actually not the affinity ID, but just number from 0 to N.
See http://lxr.free-electrons.com/source/include/linux/kvm_host.h#L427 - this is the function which
gets this "id" and returns vcpu structure.
 So, we can have up to 1 << 20 = 1048576 CPUs. Enough?
 If you are OK with this, i can post a separate patch to fix the documentation, or include it in
respin.
 
> we could push the size bit into offset and use the
> full upper 32 bits for cpuid, or at least 28 bits plus 4 reserved.

 Actually 20 bits comes from ARM64_SYS_REG() macro, which i reuse for KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
--- cut ---
    bits:   | 63 .. 56 | 55 .. 48 | 47 ... 40 | 39 .. 32 | 31 .. 0 |
    values: |   arch   |   size   | reserved  |  cpu id  |  reg id |
--- cut ---
 arch = KVM_REG_ARM64 and size = KVM_REG_SIZE_U64. I decided not to invent own macro.


Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

