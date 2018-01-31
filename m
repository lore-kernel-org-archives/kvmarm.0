From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix arch timers with userspace irqchips
Date: Wed, 31 Jan 2018 14:16:31 +0100
Message-ID: <20180131131631.hecvgdsa67bhf2gv@kamzik.brq.redhat.com>
References: <20180130124609.15076-1-christoffer.dall@linaro.org>
 <9eb4f221-2aad-8656-912a-4a7e068a23eb@arm.com>
 <20180131100530.GZ21802@cbox>
 <560b5cbc-4ac7-a55a-3f11-9a32b1ffc9e0@arm.com>
 <CAMJs5B_H16cxgAmzZ1+xU9FJWpaG3pHgziN=RBb62nMbQrZdhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMJs5B_H16cxgAmzZ1+xU9FJWpaG3pHgziN=RBb62nMbQrZdhw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Stable <stable@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 31, 2018 at 12:23:09PM +0100, Christoffer Dall wrote:
> Did I mention that I hate this feature, which keeps breaking, and
> which really isn't covered by a simple kvm-unit-test script?
>

Doesn't running the kvm-unit-tests' timer tests with
'-machine kernel_irqchip=off' exercise at least some
of these paths? If so, then the kvm-unit-tests patch
below may help

Thanks,
drew


diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 44b98cfc7afde..7c0041e44d5f3 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -116,3 +116,10 @@ file = timer.flat
 groups = timer
 timeout = 2s
 arch = arm64
+
+[timer-userspace-gic]
+file = timer.flat
+extra_params = -machine kernel_irqchip=off
+groups = timer
+timeout = 2s
+arch = arm64
