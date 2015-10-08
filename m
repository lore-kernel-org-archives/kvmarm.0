From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 08 Oct 2015 15:45:22 +0300
Message-ID: <009901d101c7$3331b3b0$99951b10$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com> <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com> <20151008092858.GA16100@cbox>
 <561641F5.4060202@arm.com> <009501d101c4$dde8e2e0$99baa8a0$@samsung.com>
 <20151008123630.GC20936@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151008123630.GC20936@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> There's no rush, I don't think this will make it into v4.4 anyhow

 Did you mean 4.3 here?

> Speaking of which, does the QEMU side of this patch set require first
> adding the GICv3 emulation for the data structures or is there a
> stand-alone migration patch set somewhere?

 I rolled it out a week ago: https://www.mail-archive.com/qemu-devel@nongnu.org/msg325331.html. I
tried to get reviewed/accepted/whatever at least data structure part, but Peter replied that he
isn't interested before we have the kernel.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


