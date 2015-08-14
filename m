From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/3] Detect vGIC presence at runtime
Date: Fri, 14 Aug 2015 16:41:30 +0300
Message-ID: <018c01d0d696$edd8a0e0$c989e2a0$@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
 <cad42f98c38c042430da47bf69ac2db81cb957af.1438770954.git.p.fedin@samsung.com>
 <55CDD056.8010703@arm.com> <017201d0d68c$82ae4950$880adbf0$@samsung.com>
 <55CDE8CB.5040205@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55CDE8CB.5040205@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> This is completely Linux-specific, unfortunately.

 Yes. But better than nothing.

> And it relies on
> userpace to expose a modified DT, so you need to be able to report back
> to userspace that you can't deal with the virtual timer.

 Easy. If KVM_CAP_IRQCHIP == 0, then we apparently don't have vGIC, and since we know that vGIC and
vTimer are paired, we know that there is no vTimer too.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

