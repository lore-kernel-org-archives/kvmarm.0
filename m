From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/7] KVM: arm/arm64: Remove redundant preemptible checks
Date: Tue, 10 Oct 2017 11:06:10 +0100
Message-ID: <87sheruxkd.fsf@on-the-bus.cambridge.arm.com>
References: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
 <1505513994-77939-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C7249D3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 06:05:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H3rx38WRWAYR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 06:05:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F8149D33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 06:05:38 -0400 (EDT)
In-Reply-To: <1505513994-77939-2-git-send-email-christoffer.dall@linaro.org>
 (Christoffer Dall's message of "Fri, 15 Sep 2017 15:19:48 -0700")
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
Cc: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 15 2017 at  3:19:48 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> The __this_cpu_read() and __this_cpu_write() functions already implement
> checks for the required preemption levels when using
> CONFIG_DEBUG_PREEMPT which gives you nice error messages and such.
> Therefore there is no need to explicitly check this using a BUG_ON() in
> the code (which we don't do for other uses of per cpu variables either).
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/arm.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a39a1e1..04313a2 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -69,7 +69,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
>  
>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	BUG_ON(preemptible());
>  	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
>  }
>  
> @@ -79,7 +78,6 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>   */
>  struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
>  {
> -	BUG_ON(preemptible());
>  	return __this_cpu_read(kvm_arm_running_vcpu);
>  }

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
