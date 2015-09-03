From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Thu, 3 Sep 2015 16:20:41 +0100
Message-ID: <CAFEAcA8PDSnTX54mQAoVsuwWzv3CWo0B3-7YQP8=Nqi_Epoj6A@mail.gmail.com>
References: <cover.1441180858.git.p.fedin@samsung.com> <bc92849c39f24de8301df2f367c3ba0ed066e5e8.1441180858.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <bc92849c39f24de8301df2f367c3ba0ed066e5e8.1441180858.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 September 2015 at 09:09, Pavel Fedin <p.fedin@samsung.com> wrote:
> The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
> KVM_GET_DEVICE_ATTR ioctls.
>
> Some registers are 64-bit wide according to the specification.
> KVM_DEV_ARM_VGIC_64BIT flag is introduced, allowing to perform full 64-bit
> accesses.
>
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
> +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     |  63  | 62  ..  40 | 39 ..  32  |  31   ....    0 |
> +    values:   | size |  reserved  |   cpu id   |      offset     |

We should avoid imposing an accidental limit on the maximum
number of CPUs in the userspace API. GICv3 doesn't have a
limit at 256 CPUs, so I think we should define an attr format
which lets us specify a complete affinity specification.

thanks
-- PMM
