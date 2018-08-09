From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Remove non-existent AArch32 ICC_SGI1R
 encoding
Date: Thu, 9 Aug 2018 09:41:35 +0200
Message-ID: <20180809074135.GE20606@e113682-lin.lund.arm.com>
References: <20180808131501.584-1-marc.zyngier@arm.com>
 <20180808131501.584-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180808131501.584-2-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 08, 2018 at 02:14:58PM +0100, Marc Zyngier wrote:
> ICC_SGI1R is a 64bit system register, even on AArch32. It is thus
> pointless to have such an encoding in the 32bit cp15 array. Let's
> drop it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 774d72155904..e04aacb2a24c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1622,8 +1622,6 @@ static const struct sys_reg_desc cp14_64_regs[] = {
>   * register).
>   */
>  static const struct sys_reg_desc cp15_regs[] = {
> -	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi },
> -
>  	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
>  	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
>  	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
> -- 
> 2.18.0
> 
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
