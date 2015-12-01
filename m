From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: BUG ALERT: ARM32 KVM does not work in 4.4-rc3
Date: Tue, 01 Dec 2015 13:03:22 +0300
Message-ID: <013201d12c1f$83f93250$8beb96f0$@samsung.com>
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
Cc: 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > My project involves ARM64, but from time to time i also test ARM32
> > KVM. I have discovered that it stopped working in 4.4-rc3. The same
> > virtual machine works perfectly under current kvmarm/next, but gets
> > stuck at random point under 4.4-rc3 from linux-stable. I'm not sure
> > that i have time to investigate this quickly, but i'll post some new
> > information as soon as i get it

[skip]

> So until you bisect it to an exact commit and configuration, I declare
> the alert over. ;-)

 The commit in question is e6fab54423450d699a09ec2b899473a541f61971 ("ARM/arm64: KVM: test properly for a PTE's uncachedness").
Reverting it fixes the problem.
 Study in qemu shows that the CPU gets stuck at PC = 0x0C with LR = 0x10. So i quickly decided that it might have to do with
caching, and my first hit was correct. The guest crashes in this state very early, sometimes it even cannot fully print
"Uncompressing kernel".
 The machine which reproduces it is custom Samsung's out-of-tree board. I'll investigate it further in order to determine how
exactly the commit could harm. I know that it passed reviews and testing, and i was involved too. Perhaps it's board's code fault,
however.

Cc'ed to others involved.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

