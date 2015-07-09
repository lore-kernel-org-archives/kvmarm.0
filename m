From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/7] KVM: arm/arm64: gsi routing support
Date: Thu, 09 Jul 2015 17:37:22 +0300
Message-ID: <023601d0ba54$c4d6e020$4e84a060$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 765235841F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 10:25:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mOGEjTcVhyVf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 10:25:50 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 875BF5840F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 10:25:50 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR800H2S5YB6680@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 09 Jul 2015 15:37:23 +0100 (BST)
In-reply-to: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> v1 -> v2:
> - user API changed:
>   x devid id passed in kvm_irq_routing_msi
>   x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI

 Andre, you never replied to my last comment to the previous series. Are you going to do the same
change in your MSI API? Otherwise:
1. KVM_IRQ_LINE - we have completely own convention. Well, this was already done before us, we
cannot fix it.
2. KVM_SIGNAL_MSI - we use VALID_DEVID flag plus devid
3. KVM_SET_GSI_ROUTING - we use KVM_IRQ_ROUTING_EXTENDED_MSI plus devid

 Don't (2) and (3) together still look bad? Since we agreed on not using flags, i would suggest to
have KVM_SIGNAL_EXTENDED_MSI counterpart, which also doesn't use flags.
 I know, we were already talking about it, so, if this gets ignored for the second time, i assume
the Architects decided that fancy APIs are cool, and i promise to stop this.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
