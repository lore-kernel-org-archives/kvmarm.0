From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 08 Oct 2015 13:55:39 +0300
Message-ID: <007501d101b7$dedacfe0$9c906fa0$@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151008101408.GA20936@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I am a bit worries about how/if this is going to conflict with the ITS
> series and other patches in flight touchignt he vgic.

 Just to note: of course i test them together. This works fine at least with vITS v2, where it
replaces patch 0001 from the original series. I guess it should also work fine with v3, replacing
patches 0001 and 0002. Merging this at the moment.
 Yes, vgic_unqueue_lpi() falls out of use, but this is temporary, because it will be very useful for
live migration.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


