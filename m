From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 14/14] KVM: arm64: Invoke FPSIMD context switch trap
 from C
Date: Tue, 8 May 2018 12:03:05 +0100
Message-ID: <5dc80121-63a2-3bf1-e24a-a8909fadea20@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525449935-31424-15-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/18 17:05, Dave Martin wrote:
> The conversion of the FPSIMD context switch trap code to C has added
> some overhead to calling it, due to the need to save registers that
> the procedure call standard defines as caller-saved.
> 
> So, perhaps it is no longer worth invoking this trap handler quite
> so early.
> 
> Instead, we can invoke it from fixup_guest_exit(), with little
> likelihood of increasing the overhead much further.
> 
> As a convenience, this patch gives __hyp_switch_fpsimd() the same
> return semantics fixup_guest_exit().  For now there is no
> possibility of a spurious FPSIMD trap, so the function always
> returns true, but this allows it to be tail-called with a single
> return statement.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
