From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Tue, 1 Sep 2015 15:46:58 +0100
Message-ID: <CAFEAcA_dg7Sh2XsR-qWHUVBOd1sNZOyWDGNwUV+Ww-M4X6DP+g@mail.gmail.com>
References: <cover.1440766141.git.p.fedin@samsung.com> <cb311e13e56311c535362f32177313850c51af66.1440766141.git.p.fedin@samsung.com>
 <20150830164237.GD24113@cbox> <55E5AD8F.80304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55E5AD8F.80304@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 September 2015 at 14:52, Andre Przywara <andre.przywara@arm.com> wrote:
> Also the GIC specification says that everything must be accessible with
> 32-bit accesses. Correct me if I am wrong on this, but vCPUs are not
> supposed to run while you are getting/setting VGIC registers, right? So
> there shouldn't be any issues with non-atomic accesses to 64-bit
> registers, which means you could just go ahead and do everything in
> 32-bit only. This would also help with supporting 32-bit userland and/or
> kernel later.

We should design the userspace API based on the natural size
of the registers in the GICv3 spec, not on what happens to
be convenient for the kernel to implement. There's only one
kernel but there can be multiple userspace consumers of the API...

I don't see any reason why a 32-bit userland wouldn't be able
to handle 64-bit accesses via the KVM_SET/GET_DEVICE_ATTR
ioctls, or am I missing something?

thanks
-- PMM
