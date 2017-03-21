From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/9] KVM: arm/arm64: vgic: Get rid of live_lrs
Date: Tue, 21 Mar 2017 11:06:47 +0000
Message-ID: <af684b2d-9668-0164-cb87-1234e914c800@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-4-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170320105818.20481-4-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/17 10:58, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> There is no need to calculate and maintain live_lrs when we always
> populate the lowest numbered LRs first on every entry and clear all LRs
> on every exit.

Indeed, that's a leftover of the old vgic, where we were keeping things
in place and not always reallocating LRs like we do now.

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
