From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 02 Oct 2015 13:33:14 +0300
Message-ID: <00d601d0fcfd$bf3d3790$3db7a6b0$@samsung.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <20151002112224.73e46be1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151002112224.73e46be1@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> - How do you find out that your guest is Linux?

 Yes, i agree. No way. And it's not host kernel's job anyway.

> - How do you ensure that the guest will not require the virtual timer?

 Agree again. Except device tree, no way. If the guest has its own hardcoded assumptions, it's
doomed. (*)

> - Who is going to maintain this new ABI that would exist for the sole
>   benefit of broken hardware?

 The ABI is simple, just one more exit code. And it's not only for broken hardware. It is quite
legitimate thing to have GICv3 without v2 backwards compatibility.

> - What is wrong with exposing another, memory mapped timer and remove
>   the architected timer entirely?

 Well... qemu guys don't want to remove CP15, i already proposed it, and it was very simple thing to
do. :) But, again, this is also device-tree-based, the same concern applies as to (*).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

