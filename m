From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG FIX: Do not inject spurious interrupts
Date: Fri, 28 Aug 2015 12:11:17 +0300
Message-ID: <00ca01d0e171$7ff1c710$7fd55530$@samsung.com>
References: <1440676282-2152-1-git-send-email-p.fedin@samsung.com>
 <20150827124442.GD29439@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150827124442.GD29439@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> It's a bit weird to just sned this as a new patch without replying to my
> mail from yesterday with feedback

 Sorry. But changes are actually minimal, and i remember that i replied to you with the promise of
testing your suggestion. So, done, works fine. :)

> I think you're missing a potential change to the irq_pending_on_cpu
> field here, which you have to compute by calling vgic_update_state()
> like we do elsewhere when we change status bits

 I have just checked this. vgic_update_state() never resets this bit. This bit is reset only in
__kvm_vgic_flush_hwstate() and only if we have consumed completely everything. I have followed
through the code and looks like it's perfectly safe to have this bit set while nothing is actually
pendng. Following __kvm_vgic_flush_hwstate(), having this bit cleared is actually a shorthand for
"no interrupt is pending at all". If it is set without any interrupt actually being pending (this
ends up in pa_percpu and pa_shared being all zeroes), all three for_each_set_bit() loops will just
not do anything, and we still get to "epilog:" label, just after a bit longer check. And, since we
are here, the guest has already been disturbed.

> different from the incorrect approach I suggested yesterday where we
> always just clear the bit for that vcpu).

 Yes, it is extremely bad idea to clear it because this bit summarizes all interrupts for this vcpu,
and clearing it means that we are going to lose everything.
 An alternate would be: clear the bit, THEN call vgic_update_state() which would set it back if
necessary. But does this extra bit of complexity worth anything, given one paragraph above?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


