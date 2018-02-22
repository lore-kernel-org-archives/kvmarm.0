From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 33/40] KVM: arm64: Configure c15, PMU, and debug
 register traps on cpu load/put for VHE
Date: Thu, 22 Feb 2018 16:51:02 +0100
Message-ID: <20180222155102.6t4ptrtt7yvewn47@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-34-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7055D49FA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 10:44:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9MLAsd29EIJK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Feb 2018 10:44:26 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA95E49F9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 10:44:26 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-34-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:25PM +0100, Christoffer Dall wrote:
> We do not have to change the c15 trap setting on each switch to/from the
> guest on VHE systems, because this setting only affects EL0.
> 
> The PMU and debug trap configuration can also be done on vcpu load/put
> instead, because they don't affect how the host kernel can access the
> debug registers while executing KVM kernel code.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  3 +++
>  arch/arm64/kvm/hyp/switch.c      | 31 ++++++++++++++++++++++---------
>  arch/arm64/kvm/hyp/sysreg-sr.c   |  4 ++++
>  3 files changed, 29 insertions(+), 9 deletions(-)
>

The last patch 32/40 probably should have been closer to 13/40 in
this series. That would allow this patch to directly follow it's
preparatory patch 31/40, but I'm just whiny reviewer...

Reviewed-by: Andrew Jones <drjones@redhat.com>
