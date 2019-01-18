From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 10/26] arm64: kvm: Unmask PMR before entering guest
Date: Fri, 18 Jan 2019 16:25:47 +0000
Message-ID: <20190118162547.GI118707@arrakis.emea.arm.com>
References: <1546956464-48825-1-git-send-email-julien.thierry@arm.com>
 <1546956464-48825-11-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1546956464-48825-11-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, daniel.thompson@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, james.morse@arm.com, joel@joelfernandes.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 08, 2019 at 02:07:28PM +0000, Julien Thierry wrote:
> Interrupts masked by ICC_PMR_EL1 will not be signaled to the CPU. This
> means that hypervisor will not receive masked interrupts while running a
> guest.
> 
> Avoid this by making sure ICC_PMR_EL1 is unmasked when we enter a guest.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
