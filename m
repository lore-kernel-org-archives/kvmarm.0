From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU interface
 registers
Date: Mon, 31 Aug 2015 14:49:46 +0300
Message-ID: <018101d0e3e3$2285a690$6790f3b0$@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
 <CAFEAcA_+Q+byqn4=ByRZ_EtJ2LzF8dj1ac52R_MPbmJkDLSjhA@mail.gmail.com>
 <014001d0e3c0$b9d6ea40$2d84bec0$@samsung.com> <20150831090321.GK24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150831090321.GK24113@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I think it's worth moving the thing to device attributes, yes,
> especially given that I never expect us to trap and emulate GICv3 system
> register accesses from a guest in KVM.  Is that correct?

 Yes, but nevertheless, for GICv2 attributes we reuse the same code which is expected to trap MMIO
accesses from guest. And there we also have MMIO handlers for the CPU interface, which are also
never trapped from guest. So why cannot we do the same for GICv3 CPU interface, and simply reuse
existing APIs?
 I am currently working on full support in qemu, and it's not difficult to deal with CPU fd's.
Because anyway you have to iterate through all VCPUs in order to save state correctly.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


