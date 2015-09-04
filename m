From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Fri, 04 Sep 2015 10:06:47 +0300
Message-ID: <012201d0e6e0$43de9db0$cb9bd910$@samsung.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
 <bc92849c39f24de8301df2f367c3ba0ed066e5e8.1441180858.git.p.fedin@samsung.com>
 <CAFEAcA8PDSnTX54mQAoVsuwWzv3CWo0B3-7YQP8=Nqi_Epoj6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAFEAcA8PDSnTX54mQAoVsuwWzv3CWo0B3-7YQP8=Nqi_Epoj6A@mail.gmail.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Peter Maydell' <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> > +  Attributes:
> > +    The attr field of kvm_device_attr encodes two values:
> > +    bits:     |  63  | 62  ..  40 | 39 ..  32  |  31   ....    0 |
> > +    values:   | size |  reserved  |   cpu id   |      offset     |
> 
> We should avoid imposing an accidental limit on the maximum
> number of CPUs in the userspace API. GICv3 doesn't have a
> limit at 256 CPUs

 Ops, my fault, forgot. :(
 However, it seems to be very simple. "cpu id" is actually an index, not a real affinity ID (see http://lxr.free-electrons.com/source/include/linux/kvm_host.h#L427). Would it be OK just to enlarge KVM_DEV_ARM_VGIC_CPUID_MASK?

    bits:     |  63  | 62 ..  32 |  31   ....    0 |
    values:   | size |  cpu id   |      offset     |

 I think 31 bits is more than enough for CPU index.
 And, since id is actually an index, may be we should fix up docs?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


