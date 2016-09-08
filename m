From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: ARM: cleanup kvm_timer_hyp_init
Date: Thu, 8 Sep 2016 12:54:15 +0200
Message-ID: <20160908105415.GY23592@cbox>
References: <1473331560-3103-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473331560-3103-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, "moderated list:KERNEL VIRTUAL MACHINE (KVM) FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE (KVM) FOR ARM" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 08, 2016 at 12:45:59PM +0200, Paolo Bonzini wrote:
> Remove two unnecessary labels now that kvm_timer_hyp_init is not
> creating its own workqueue anymore.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks, applied.

-Christoffer
