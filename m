From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 06 Jul 2015 09:42:43 +0300
Message-ID: <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F8B57B24
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 02:31:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fe9K82vNT5qL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 02:31:21 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3421757B05
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 02:31:20 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR100KYCZZ8HR40@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 06 Jul 2015 07:42:44 +0100 (BST)
In-reply-to: <5596503E.6040902@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I like this approach, but it runs into problems:
> As you read above the current documentation says that the flags field
> must be zero and the current KVM_SET_GSI_ROUTING handler bails out if it
> isn't. So userland would need to know whether it's safe to set that
> field.

 This problem does not exist because:
a) Older platforms do not need this flag, so they expect to get zero.
b) ARM64 + GICv3 platform cannot work without this flag.

 This is perfectly OK combination IMO. Userland just knows, whether it needs to supply device ID or
not. For example, my modified qemu now has kvm_msi_flags global variable which defaults to 0. ITS
code, then, if activated, changes it to KVM_MSI_VALID_DEVID, and qemu starts supplying device IDs to
the related calls.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
