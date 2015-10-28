From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v5 0/7] KVM: arm64: Implement API for vGICv3 live migration
Date: Wed, 28 Oct 2015 15:24:06 +0300
Message-ID: <008601d1117b$8a995810$9fcc0830$@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
 <CAFEAcA_SpUa9Czk4=95h-0RpHTBKVVf8CkX_5S7XOO7kt7at-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0EC41145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 08:21:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pT8zeTrfjNPq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2015 08:21:15 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D341640FF5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 08:21:15 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWX00M9ZJS78300@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 28 Oct 2015 12:24:07 +0000 (GMT)
In-reply-to: <CAFEAcA_SpUa9Czk4=95h-0RpHTBKVVf8CkX_5S7XOO7kt7at-Q@mail.gmail.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Peter Maydell' <peter.maydell@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > v4 => v5:
> > - Adapted to new API by Peter Maydell, Marc Zyngier and Christoffer Dall.
> >   Acked-by's on the documentation were dropped, just in case, because i
> >   slightly adjusted it. Additionally, i merged all doc updates into one
> >   patch.
> 
> Could you tell us what you changed in the doc patch from the version
> that got sent out with the acks, please?

 Sorry, completely forgot to answer this one...

 The major differences / things to review are:

1. Both GICv2 and GICv3 use the same value of KVM_DEV_ARM_VGIC_CPUID_MASK, which is extended to 32 bits. So GICv2 attribute layout also looks like:
--- cut ---
    bits:     | 63   ....  32  |  31   ....    0 |
    values:   |  vcpu_index    |      offset     |
--- cut ---

2. KVM_DEV_ARM_VGIC_CPU_SYSREGS documentation originally says (error code description):
--- cut ---
    -EBUSY: One or more VCPUs are running
--- cut ---
 While my version says "VCPU is running". Since this is CPU interface, it does not affect other CPUs, so for simplicity i check only current vCPU in my code.

 That's all. Just i'm maybe too careful about fundamentals...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
