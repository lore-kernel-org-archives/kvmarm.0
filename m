From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Mon, 12 Oct 2015 10:14:24 +0300
Message-ID: <016b01d104bd$a048f140$e0dad3c0$@samsung.com>
References: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
 <20150929072518.GC9002@cbox> <01b701d102a0$8b19c5c0$a14d5140$@samsung.com>
 <20151010150036.GC29128@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151010150036.GC29128@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> It is really up to whoever adds support for LPIs to make sure it's done
> correctly.  So I think this is for Andre to work out in his ITS series.
> 
> This patch fixes an issue with the current code in the correct way as
> far as I can tell.

 Ok. An alternate way is to introduce a function which would check for any pending LPIs. I will
suggest a fix on top of the current series after some time.
 I'm cc'ing this whole discussion to Andre.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


