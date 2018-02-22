From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 28/40] KVM: arm64: Defer saving/restoring 64-bit
 sysregs to vcpu load/put on VHE
Date: Thu, 22 Feb 2018 15:04:36 +0100
Message-ID: <20180222140436.jzk2fa7mzsasu64a@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-29-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3CD49EDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 08:58:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SsSy12ekIZny for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Feb 2018 08:58:00 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3071949E70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 08:58:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-29-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:03:20PM +0100, Christoffer Dall wrote:
> Some system registers do not affect the host kernel's execution and can
> therefore be loaded when we are about to run a VCPU and we don't have to
> restore the host state to the hardware before the time when we are
> actually about to return to userspace or schedule out the VCPU thread.
> 
> The EL1 system registers and the userspace state registers only
> affecting EL0 execution do not need to be saved and restored on every
> switch between the VM and the host, because they don't affect the host
> kernel's execution.
> 
> We mark all registers which are now deffered as such in the
> vcpu_{read,write}_sys_reg accessors in sys-regs.c to ensure the most
> up-to-date copy is always accessed.
> 
> Note MPIDR_EL1 (controlled via VMPIDR_EL2) is accessed from other vcpu
> threads, for example via the GIC emulation, and therefore must be
> declared as immediate, which is fine as the guest cannot modify this
> value.
> 
> The 32-bit sysregs can also be deferred but we do this in a separate
> patch as it requires a bit more infrastructure.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v3:
>      - Changed to switch-based sysreg approach
> 
>  arch/arm64/kvm/hyp/sysreg-sr.c | 39 +++++++++++++++++++++++++++++++--------
>  arch/arm64/kvm/sys_regs.c      | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+), 8 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
