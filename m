From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Save two instructions in __guest_enter()
Date: Thu, 25 Aug 2016 15:31:22 +0200
Message-ID: <20160825133122.GA8016@lvm>
References: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Tue, Aug 09, 2016 at 08:15:36PM -0500, Shanker Donthineni wrote:
> We are doing an unnecessary stack push/pop operation when restoring
> the guest registers x0-x18 in __guest_enter(). This patch saves the
> two instructions by using x18 as a base register. No need to store
> the vcpu context pointer in stack because it is redundant and not
> being used anywhere, the same information is available in tpidr_el2.

Does this have any measureable benefit?

Thanks,
-Christoffer
