From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Thu, 6 Aug 2015 14:00:55 +0200
Message-ID: <55C34C77.7090303@redhat.com>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com>
 <55C240D9.5060900@redhat.com> <55C242C6.6060200@gmail.com>
 <55C31582.4000809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55C31582.4000809@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, nick <xerofoify@gmail.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "gleb@kernel.org" <gleb@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 06/08/2015 10:06, Marc Zyngier wrote:
> > If this structure of function pointers can handle function pointers with a return type of 
> > void I will be glad to do what you request otherwise this would require a major rewrite
> > of kvm arm subsystem for a very simple bug fix.
> 
> Just like Paolo said, the error you report should never happen, and
> would be caught by a WARN_ON() the first time anyone boots the kernel.
> Also, failing to register the device ops results in not being able to
> instantiate a VGIC. No harm done. I really don't understand why you want
> to rewrite the probe functions.

I think he just misunderstood my suggestion.  I didn't suggest making
the probe functions return void.  I suggested that
kvm_register_device_ops return void.

Paolo
