From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 14/15] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Tue, 04 Aug 2015 09:53:07 +0300
Message-ID: <00b101d0ce82$38caa7a0$aa5ff6e0$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-15-git-send-email-andre.przywara@arm.com>
 <55BB7678.5080105@linaro.org> <55BE7BA1.40403@arm.com>
 <00a201d0cdb7$70a623f0$51f26bd0$@samsung.com> <55BF2F51.6020701@linaro.org>
 <00f101d0cdcd$146a6090$3d3f21b0$@samsung.com> <55BF8AB8.5050408@linaro.org>
 <55BF9FB0.6070804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55BF9FB0.6070804@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <Andre.Przywara@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I think this flag should be kept, as it really indicates what is valid
> in the MSI structure. It also has other benefits such as making obvious
> what userspace expects, which can then be checked against the kernel's
> own expectations.

 I'm OK with the flag despite it's indeed a small bit redundant. But i see that kernel's policy is
to have insurance against all possible and impossible bad inputs, and the flag really fits into the
concept.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

