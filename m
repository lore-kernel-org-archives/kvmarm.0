From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: Extensions for KVM MSI related ioctls
Date: Mon, 13 Jul 2015 16:32:53 +0300
Message-ID: <03b901d0bd70$6c2f4b50$448de1f0$@samsung.com>
References: <55A39231.4050904@arm.com> <55A3B090.6090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55A3B090.6090002@redhat.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Paolo Bonzini' <pbonzini@redhat.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Eric Auger' <eric.auger@linaro.org>
Cc: kvm@vger.kernel.org, 'Gleb Natapov' <gleb@kernel.org>, 'Jan Kiszka' <jan.kiszka@siemens.com>, 'Marcelo Tosatti' <mtosatti@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I think I prefer the flag.  Offhand it sounds easier to add support for
> it to non-ARM architectures, compared to KVM_IRQ_ROUTING_EXTENDED_MSI.

 Actually i also voted for flag, because it is already introduced in (2), and i'm not a fan of
adding new definitions where we can reuse existing ones. IMHO using flag would make an API more
consistent.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


