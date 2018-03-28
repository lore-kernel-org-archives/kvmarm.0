From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [GIT PULL] KVM/ARM updates for v4.17
Date: Wed, 28 Mar 2018 22:00:34 +0200
Message-ID: <20180328200033.GA26753@flask>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, linux-arm-kernel@lists.infradead.org, =?utf-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>, Dave Martin <Dave.Martin@arm.com>, Christoffer Dall <cdall@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Alvise Rigo <a.rigo@virtualopensystems.com>, James Morse <james.morse@arm.com>, Pao
List-Id: kvmarm@lists.cs.columbia.edu

2018-03-28 13:51+0100, Marc Zyngier:
> Paolo, Radim,
> 
> This is the (rather big) set of updates for KVM/ARM for v4.17. The
> main features are the set of VHE optimizations taking advantage of
> CPUs implementing ARMv8.1, together with the EL2 randomization patches
> that are the foundation for mitigating the so-called variant 3a
> security issue (affecting Cortex-A57 and A72).
> 
> The rest is the usual mix of vgic fixes and minor improvements.
> 
> Note that the breakup below is slightly misleading, as it includes
> fixes that have already landed in mainline (I've done a direct merge
> of the fixes branch in order to spare everyone some horrible
> conflicts).
> 
> Also, we've had to revert a pretty important patch for Qualcomm
> servers due to some more conflicts with the arm64 tree). That patch
> will be resent once both trees have been pulled into Linus' (the
> sooner, the better).

KVM tree will likely be merged in the latter half of next week.

> Please pull.

Pulled, thanks.
