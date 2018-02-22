From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 25/40] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Thu, 22 Feb 2018 17:40:48 +0000
Message-ID: <b9edba7e-bc31-b101-5bcc-8233547e731a@arm.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-26-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180215210332.8648-26-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 15/02/18 21:03, Christoffer Dall wrote:
> We are about to defer saving and restoring some groups of system
> registers to vcpu_put and vcpu_load on supported systems.  This means
> that we need some infrastructure to access system registes which

NIT: s/registes/registers/

> supports either accessing the memory backing of the register or directly
> accessing the system registers, depending on the state of the system
> when we access the register.
> 
> We do this by defining read/write accessor functions, which can handle
> both "immediate" and "deferrable" system registers.  Immediate registers
> are always saved/restored in the world-switch path, but deferrable
> registers are only saved/restored in vcpu_put/vcpu_load when supported
> and sysregs_loaded_on_cpu will be set in that case.
> 
> Note that we don't use the deferred mechanism yet in this patch, but only
> introduce infrastructure.  This is to improve convenience of review in

NIT: double space after the period.

> the subsequent patches where it is clear which registers become
> deferred.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>      Changes since v3:
>       - Changed to a switch-statement based approach to improve
>         readability.
>      
>      Changes since v2:
>       - New patch (deferred register handling has been reworked)
> 
>   arch/arm64/include/asm/kvm_host.h |  8 ++++++--
>   arch/arm64/kvm/sys_regs.c         | 33 +++++++++++++++++++++++++++++++++
>   2 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 68398bf7882f..b463b5e28959 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -284,6 +284,10 @@ struct kvm_vcpu_arch {
>   
>   	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
>   	u64 vsesr_el2;
> +
> +	/* True when deferrable sysregs are loaded on the physical CPU,
> +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */

NIT: I think the preferred style comment is
/*
  * Foo
  */

Cheers,

-- 
Julien Grall
