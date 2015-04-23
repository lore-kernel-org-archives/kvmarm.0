From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Thu, 23 Apr 2015 11:30:59 +0200
Message-ID: <5538BBD3.9040404@redhat.com>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D46F4E4D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:23:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 134plUhTtu8p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 05:22:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF0B44E4D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:22:54 -0400 (EDT)
In-Reply-To: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/04/2015 10:49, Eric Auger wrote:
> This series introduces a new callback function in IRQState, named
> get_gsi_cb. It is supposed to be populated by the interrupt controller
> and its role is to convert the interrupt controller pin number into
> the global system interrupt (gsi) number. The gsi is used when setting
> irqfd up.
> 
> With PCI there is a PCIINTxRoute bus lookup mechanism that enables to
> retrieve the gsi from the PCI host controller/bridge pin. The conversion
> is implemented by the PCI host controller. With platform devices, this
> conversion function is implemented by the interrupt controller.
> 
> Besides the callback member, a setter is introduced. First user is
> arm_gic_kvm. A public function wraps the callback, qemu_irq_get_gsi.
> 
> The first user of qemu_irq_get_gsi might be the VFIO platform device.
> This will come in the "KVM platform device passthrough" series.

I'm sorry, I cannot understand the point of this without seeing a user.

Why can't you just use a GHashTable?  This mustn't be a hot path, since
VFIO does all the signalling in the kernel via irqfds.

Paolo
