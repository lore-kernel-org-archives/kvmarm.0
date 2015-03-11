From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: prefer IS_ENABLED to a static variable
Date: Wed, 11 Mar 2015 15:20:24 +0100
Message-ID: <20150311142024.GA23478@cbox>
References: <1425554766-4119-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425554766-4119-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 05, 2015 at 12:26:06PM +0100, Paolo Bonzini wrote:
> IS_ENABLED gives compile-time checking and keeps the code clearer.
> 
> The one exception is inside kvm_vm_ioctl_check_extension, where
> the established idiom is to wrap the case labels with an #ifdef.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks, I've applied this to my queue with a follow-up to remove config
options all together just like we have it on arm64.

I'll send out that patch based on yours and I've applied Eric's IRQFD
series on top of that.

Best,
-Christoffer
