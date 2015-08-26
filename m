From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 17:26:55 +0300
Message-ID: <014c01d0e00b$42de2060$c89a6120$@samsung.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
 <20150826140214.GB29439@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150826140214.GB29439@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, =?ISO-8859-1?Q?'Alex_Benn=E9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Hmm, there is definitely an inconsistency in the vgic code by getting
> here, but this is the wrong fix.  I think you want something more along
> the lines of the following (completely untested, not even compile
> tested):

 Thank you very much. I also tried to propose an alternate solution like this, i will test it, and
adjust if needed. My "bad codebase, broken HW and buggy userspace" appears to be particulary prone
to finding these problems, i think it's going to be a nice testbed. :)

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


