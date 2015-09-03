From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 9/9] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Thu, 03 Sep 2015 18:07:15 +0100
Message-ID: <55E87E43.1090900@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-10-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-10-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laszlo Ersek <lersek@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/15 14:54, Christoffer Dall wrote:
> Provide a better quality of implementation and be architecture compliant
> on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
> reset of the timer, and call kvm_timer_update_state(vcpu) at the same
> time, ensuring the timer output is not asserted after, for example, a
> PSCI system reset.
> 
> This change alone fixes the UEFI reset issue reported by Laszlo back in
> February.
> 
> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Drew Jones <drjones@redhat.com>
> Cc: Wei Huang <wei@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
