From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCHv2] arm64/kvm: Prohibit guest LOR accesses
Date: Wed, 14 Feb 2018 11:52:06 +0100
Message-ID: <20180214105206.GM23189@cbox>
References: <20180213133923.40002-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180213133923.40002-1-mark.rutland@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 13, 2018 at 01:39:23PM +0000, Mark Rutland wrote:
> We don't currently limit guest accesses to the LOR registers, which we
> neither virtualize nor context-switch. As such, guests are provided with
> unusable information/controls, and are not isolated from each other (or
> the host).
> 
> To prevent these issues, we can trap register accesses and present the
> illusion LORegions are unssupported by the CPU. To do this, we mask
> ID_AA64MMFR1.LO, and set HCR_EL2.TLOR to trap accesses to the following
> registers:
> 
> * LORC_EL1
> * LOREA_EL1
> * LORID_EL1
> * LORN_EL1
> * LORSA_EL1
> 
> ... when trapped, we inject an UNDEFINED exception to EL1, simulating
> their non-existence.
> 
> As noted in D7.2.67, when no LORegions are implemented, LoadLOAcquire
> and StoreLORelease must behave as LoadAcquire and StoreRelease
> respectively. We can ensure this by clearing LORC_EL1.EN when a CPU's
> EL2 is first initialized, as the host kernel will not modify this.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Vladimir Murzin <vladimir.murzin@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

Applied, thanks.
-Christoffer
