From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Mon, 27 Jul 2015 11:36:46 +0300
Message-ID: <00d101d0c847$6039ac50$20ad04f0$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
 <55ACAC73.9090500@arm.com> <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
 <55B11AEC.4050804@arm.com> <008f01d0c625$45d91a90$d18b4fb0$@samsung.com>
 <55B26277.80205@arm.com> <007901d0c7a1$99981f50$ccc85df0$@samsung.com>
 <55B5DD88.5070203@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55B5DD88.5070203@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > And i agreed. So, i repeat the question. Will it be OK if we just
> > enable KVM without both vGIC and vTimer, and that's all we do? It
> > will be userland's problem how to handle them. I need to tweak my
> > first patchset a very small bit in order to do this.
> 
> I I'll repeat what I already said: "Show me the patches".
> 
> I'll only give you an answer once I exactly know what you're up to.

 You have already seen them, it is the very same patchset we are discussing in this thread.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


