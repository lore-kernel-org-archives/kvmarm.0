From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Thu, 02 Jul 2015 11:41:07 +0300
Message-ID: <018f01d0b4a2$d74e29f0$85ea7dd0$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> What if we use KVM_MSI_VALID_DEVID flag instead of new KVM_IRQ_ROUTING_EXTENDED_MSI
> definition? I
> believe this would make an API more consistent and introduce less new definitions.

 I have just found one more flaw in your implementation. If you take a look at irqfd_wakeup()...
--- cut ---
		/* An event has been signaled, inject an interrupt */
		if (irq.type == KVM_IRQ_ROUTING_MSI)
			kvm_set_msi(&irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
					false);
		else
			schedule_work(&irqfd->inject);
--- cut ---
 You apparently missed KVM_IRQ_ROUTING_EXTENDED_MSI here, as well as in irqfd_update(). But, if you
accept my API proposal, this becomes irrelevant.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


