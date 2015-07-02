From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Thu, 02 Jul 2015 18:37:55 +0300
Message-ID: <02ea01d0b4dd$1186e690$3494b3b0$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
 <015501d0b49c$1f1349c0$5d39dd40$@samsung.com> <55955290.1030009@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1088576E8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 11:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CVn5Si5QWcwa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 11:26:43 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDB4B57685
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 11:26:42 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQV00H9FA390Y00@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 02 Jul 2015 16:37:57 +0100 (BST)
In-reply-to: <55955290.1030009@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  Given API change i suggest (using KVM_MSI_VALID_DEVID flag), we could get rid of all these
if()'s
> > here. Just forward all parameters to vGIC implementation code and let it do its checks.
> I don't understand this comment. Here this is the kernel struct that is
> used (struct kvm_kernel_irq_routing_entry) and not the user one
> (kvm_irq_routing_entry). The kernel struct does not have the flag field.

  Easy. ARM code can always use struct kvm_extended_msi, and flags can go to this structure.

> Another reason I think to keep using the type for homogeneity.

 Homogeneity is perfect IMHO.
 If that would be simpler for you, i could post a patch for this which i made on top of your series.
Sorry, i don't have time to respin the whole thing, busy with qemu GICv3 fight :)

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
