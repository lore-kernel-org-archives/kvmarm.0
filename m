From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: BUG ALERT: ARM32 KVM does not work in 4.4-rc3
Date: Tue, 01 Dec 2015 12:29:43 +0300
Message-ID: <012701d12c1a$cfd28ff0$6f77afd0$@samsung.com>
References: <00fe01d12c09$576ca200$0645e600$@samsung.com>
 <565D677E.8000505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <565D677E.8000505@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> The same kernel is used both as a guest and a host with v4.4-rc3.
> 
> So until you bisect it to an exact commit and configuration, I declare
> the alert over. ;-)

 By this time i have also tried it on another machine, and there it also works. Looks like it's triggered only on some particular
HW. I'll try to figure this out.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


