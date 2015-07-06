From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 6 Jul 2015 17:54:55 +0200
Message-ID: <559AA4CF.7060300@redhat.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559AA0D6.7070703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A41D457CCC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:43:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EBl+rL43oZ-4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 11:43:34 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D9CD57CC9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:43:34 -0400 (EDT)
In-Reply-To: <559AA0D6.7070703@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Pavel Fedin <p.fedin@samsung.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 06/07/2015 17:37, Andre Przywara wrote:
> Wouldn't:
>     if (kvm_vm_check_extension(s, KVM_CAP_MSI_DEVID)) {
>         kroute.flags = KVM_MSI_VALID_DEVID;
>         kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
>     }
> 
> be saner (without a global variable)?
> That would make the interface more consistent, with a new flag being
> protected by a new capability.

I agree that your version is niceer, but you still need to cache the
kvm_vm_check_extension result... in a global variable. :)

Paolo
