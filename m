From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 09/21] arm64: KVM: VHE: Differenciate host/guest
 sysreg save/restore
Date: Mon, 1 Feb 2016 14:59:33 +0100
Message-ID: <20160201135933.GQ1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453737235-16522-10-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:43PM +0000, Marc Zyngier wrote:
> With ARMv8, host and guest share the same system register file,
> making the save/restore procedure completely symetrical.
> With VHE, host and guest now have different requirements, as they
> use different sysregs.
> 
> In order to prepare for this, add split sysreg save/restore functions
> for both host and guest. No functionnal change yet.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
