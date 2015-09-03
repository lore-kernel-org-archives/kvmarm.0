From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/9] arm/arm64: Implement GICD_ICFGR as RO for PPIs
Date: Thu, 03 Sep 2015 16:03:58 +0100
Message-ID: <55E8615E.30300@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-5-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-5-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/15 14:54, Christoffer Dall wrote:
> The GICD_ICFGR allows the bits for the SGIs and PPIs to be read only.
> We currently simulate this behavior by writing a hardcoded value to the
> register for the SGIs and PPIs on every write of these bits to the
> register (ignoring what the guest actually wrote), and by writing the
> same value as the reset value to the register.
> 
> This is a bit counter-intuitive, as the register is RO for these bits,
> and we can just implement it that way, allowing us to control the value
> of the bits purely in the reset code.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
