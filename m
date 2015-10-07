From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Wed, 07 Oct 2015 21:09:07 +0300
Message-ID: <02c301d1012b$42cb8270$c8628750$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <029601d1011a$026e1000$074a3000$@samsung.com> <561546AF.90903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <561546AF.90903@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> LPIs do not have an active state, at the redistributor or otherwise.

 Then what do they become after they were ACK'ed and before EOI'ed?
 I tried to google up this thing, and came up with this email:
http://www.spinics.net/lists/kvm-arm/msg16032.html. It says that "SW must issue a write to EOI to
clear the active priorities register, hence the CPU interface still requires an active state for
LPIs". They give a link to some document which seems to be top-secret and never published, because
my arch reference manual does not have section 4.8.3 named "Properties of LPI".
 And another thread, http://lists.xen.org/archives/html/xen-devel/2014-09/msg01141.html, says that
virtual LPIs actually do have active state in LR.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


