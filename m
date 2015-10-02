From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 02 Oct 2015 17:54:53 +0300
Message-ID: <012601d0fd22$4c7425a0$e55c70e0$@samsung.com>
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

> So let me put it another way. The only way I look into this is when we
> have this particular platform fully supported in mainline.

 I am sorry for possible misunderstanding. Please give me one more minute to defend myself...
 So far, we are not putting back timer disable hack. So, i'd like to clarify some things about
variant 2. From kernel's point of view, this is not a hack, but pure feature enhancement. The idea
is to add KVM API which would allow to emulate system registers, unhandled by KVM, in userspace.
Currently KVM just prints error message about unhandled system register access and feeds guest with
"illegal instruction" exception. What i actually propose is to add an API which would allow to
handle these things in userspace. This will even be architecture-agnostic, and it can be useful for
emulating absolutely any future peripherials which could use system register (or coprocessor, on
ARM32) interface.
 The rest of timer-related stuff would be needed to be implemented in userspace, and this would have
absolutely nothing to do with kernel. By the way, this would also allow to run under KVM legitimate
guests which for some reason expect both timers (are there any? RTOS?)
 So, what is your final word? Would you consider this improvement?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


