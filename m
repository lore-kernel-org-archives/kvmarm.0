From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/3] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Tue, 01 Sep 2015 17:27:40 +0300
Message-ID: <011101d0e4c2$5bf3ff50$13dbfdf0$@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <cb311e13e56311c535362f32177313850c51af66.1440766141.git.p.fedin@samsung.com>
 <20150830164237.GD24113@cbox> <55E5AD8F.80304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55E5AD8F.80304@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I agree on this, actually I consider this dangerous. Currently the
> memory behind addr in QEMU (hw/intc/arm_gic_kvm.c:kvm_arm_gic_get() for
> instance) is only uint32_t, so you have to take care to provide uint64_t
> backing for those registers, which means that there must be a match
> between the register size the kernel knows and the size userland thinks
> of. So I'd rather see the access size controlled by userland

 Ok, i will implement it this way.

> Also the GIC specification says that everything must be accessible with
> 32-bit accesses. Correct me if I am wrong on this, but vCPUs are not
> supposed to run while you are getting/setting VGIC registers, right?

 Right.

> So there shouldn't be any issues with non-atomic accesses to 64-bit
> registers, which means you could just go ahead and do everything in
> 32-bit only.

 I thought about it too, it's inconvenient. In the userland you would have to do two accesses and
merge the result. It's just tedious. After all this API is not emulating guest behavior, it's just
for reading/writing GIC state.
 So on next respin i'll add size bit.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

