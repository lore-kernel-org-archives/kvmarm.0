From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v7 16/16] KVM: arm64: Invoke FPSIMD context switch trap
 from C
Date: Tue, 15 May 2018 12:57:25 +0200
Message-ID: <20180515105725.GE38551@C02W217FHV2R.local>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-17-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-17-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 05:13:05PM +0100, Dave Martin wrote:
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
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
