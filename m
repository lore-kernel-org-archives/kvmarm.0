From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/9] KVM: Add kvm_arch_vcpu_{un}blocking callbacks
Date: Thu, 03 Sep 2015 15:21:17 +0100
Message-ID: <55E8575D.70603@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-2-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/15 14:54, Christoffer Dall wrote:
> Some times it is useful for architecture implementations of KVM to know
> when the VCPU thread is about to block or when it comes back from
> blocking (arm/arm64 needs to know this to properly implement timers, for
> example).
> 
> Therefore provide a generic architecture callback function in line with
> what we do elsewhere for KVM generic-arch interactions.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
