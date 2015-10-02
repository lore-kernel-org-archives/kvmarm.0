From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in the
 distributor
Date: Fri, 02 Oct 2015 15:39:44 +0300
Message-ID: <00f301d0fd0f$6b21ac10$41650430$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
 <00cb01d0fcf8$6a906000$3fb12000$@samsung.com> <560E5D2F.1000401@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <560E5D2F.1000401@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Can't you use the ELRSR bitmap instead? The idea of lr_used sounds like
> a moot optimization to me.

 This perfectly works on 4.2, but will break HW interrupt forwarding on 4.3. If you look at 4.3
__kvm_vgic_sync_hwstate(), you'll notice that for HW interrupts lr_used and elrsr_ptr will diverge
at this point, and this function actually brings them into sync. And it relies on lr_used for the
loop to operate correctly (no idea why we use "for" loop here with extra check instead of
"for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr)", looks stupid to me).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


