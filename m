From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 08 Oct 2015 10:17:09 +0300
Message-ID: <003a01d10199$58e96590$0abc30b0$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> +    The mpidr encoding is based on the affinity information in the
> +    architecture defined MPIDR, and the field is encoded as follows:
> +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> +      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |

 One concern about this... Does it already have "We are Bosses, we Decided it, It's not subject to
change, We do not care" status? Actually, current approach with using index instead of Aff bits
works pretty well. It works fine with qemu too, because internally qemu also maintains CPU index,
which it uses for GICv2 accesses.
 Keeping index allows to reuse more code, and provides better backwards compatibility. So could we
do this?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


