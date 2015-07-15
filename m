From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 15/15] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Wed, 15 Jul 2015 13:01:34 +0300
Message-ID: <012501d0bee5$3b9f2ca0$b2dd85e0$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-16-git-send-email-andre.przywara@arm.com>
 <00fa01d0bede$098f5570$1cae0050$@samsung.com> <55A62D50.9080101@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3D905896A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2015 05:49:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KFtme7PjU3F1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2015 05:49:47 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C02858964
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2015 05:49:46 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRI00GHTX6N3I10@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 15 Jul 2015 11:01:35 +0100 (BST)
In-reply-to: <55A62D50.9080101@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> But why would it need the capability to create models?

 Actually it doesn't.

> The idea is to
> check the capability before the actual KVM_SIGNAL_MSI or
> KVM_SET_GSI_ROUTING ioctl (and cache that result). I have a function
> with a static variable to do that, so it looks like:
> 
> +  if (check_for_msi_devid(kvm)) {
> +    irq_routing->entries[irq_routing->nr].flags = KVM_MSI_VALID_DEVID;
> +    irq_routing->entries[irq_routing->nr].u.msi.devid = device_id;
> +  }
> 
> > May be we should just set the capability to TRUE for
> > ARM architecture in general, and make GICv2m MSIs simply ignoring this flag and device ID?
> 
> Possibly, but it would be saner to tell userland that it's a per VM
> decision for ARM. Since you need extra support bits in the userland
> anyway (to set up GICv2M or ITS emulation), I think it is acceptable to
> require a late, per-VM capability check in userland in that case.

 Well, agree, and formally this is more correct. Just it would require slightly more additions to
qemu. But it's not a real problem.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
