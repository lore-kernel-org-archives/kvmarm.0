From: Andre Przywara <andre.przywara@arm.com>
Subject: Extensions for KVM MSI related ioctls
Date: Mon, 13 Jul 2015 11:25:53 +0100
Message-ID: <55A39231.4050904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F68580C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 06:14:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D8TzKDOIl60z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2015 06:14:09 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 882F45801B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2015 06:14:09 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

we (Pavel, Eric and me) need your quick advice on how to proceed with a
small API extension:
(tl;dr: skip to the numbered list at the end)

For using MSIs in a guest when running on an ARM(64) system using a
GICv3 interrupt controller we need to have a device ID available. On
real hardware this information is sampled from the bus by the ITS part
of the interrupt controller.
To make this work for guests, we need to extend two ioctls which deal
with MSIs: KVM_SIGNAL_MSI and KVM_SET_GSI_ROUTING.

The idea that we sketched so far in [1] and [2] is to use a new
capability (KVM_CAP_MSI_DEVID) to advertise both a flag bit for
KVM_SIGNAL_MSI and a new type for KVM_SET_GSI_ROUTING.

Since current kernels bail out on any flag value != 0 in KVM_SIGNAL_MSI,
we need the new capability to tell userland about it in a reliable and
portable way (to avoid hacks like #ifdef ARM && USES_IRQ_ROUTING in
userland).

For KVM_SET_GSI_ROUTING there was the idea of using the very same flag
value in it's own flag field, but I find it saner to use a new routing
type instead (KVM_IRQ_ROUTING_EXTENDED_MSI). Both approaches would
piggy-back on the existing struct kvm_irq_routing_msi and re-purpose the
pad field in there.

Summarized:
1) Add a new KVM_CAP_MSI_DEVID to advertise the device ID extension.
2) Use a KVM_MSI_VALID_DEVID flag in KVM_SIGNAL_MSI to re-purpose part
   of struct kvm_msi.
3) Add a new routing type KVM_IRQ_ROUTING_EXTENDED_MSI for
   KVM_SET_GSI_ROUTING to add device IDs in struct kvm_irq_routing_msi.

Is that a sensible way to extend the KVM API?

Cheers,
Andre.

[1]:https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015622.html
[2]:https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015689.html
