From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm64: Decode basic HYP fault information
Date: Mon, 31 Aug 2015 09:33:40 +0300
Message-ID: <012d01d0e3b6$fa327c30$ee977490$@samsung.com>
References: <00aa01d0d408$1ba96ea0$52fc4be0$@samsung.com>
 <20150830174434.GG24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150830174434.GG24113@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> my overall concern with this patch is that it adds complexity to an
> already really bad situation, and potentially increases the likelihood
> of not seeing any debug info at all.

 Why? In this case we currently already drop into C code. I do the same, with some more useful
printout. What is fundamentally changed?

> do you encounter this kind of panic a lot?  I haven't experienced a
> great need for more hyp debugging help lately...

 I met it once, and i had a stable way to reproduce it. At the end it appeared to be another HW
quirk, but, still, this patch helped a lot to find out what was wrong. The main missing information
was vector number, and translated PC is also useful.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


