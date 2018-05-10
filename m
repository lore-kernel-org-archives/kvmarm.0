From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 05/16] arm64: fpsimd: Generalise context saving for
 non-task contexts
Date: Thu, 10 May 2018 17:17:03 +0100
Message-ID: <20180510161702.vu6bwbnjlpq4erqk@armageddon.cambridge.arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-6-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-6-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 05:12:54PM +0100, Dave P Martin wrote:
> In preparation for allowing non-task (i.e., KVM vcpu) FPSIMD
> contexts to be handled by the fpsimd common code, this patch adapts
> task_fpsimd_save() to save back the currently loaded context,
> removing the explicit dependency on current.
> 
> The relevant storage to write back to in memory is now found by
> examining the fpsimd_last_state percpu struct.
> 
> fpsimd_save() does nothing unless TIF_FOREIGN_FPSTATE is clear, and
> fpsimd_last_state is updated under local_bh_disable() or
> local_irq_disable() everywhere that TIF_FOREIGN_FPSTATE is cleared:
> thus, fpsimd_save() will write back to the correct storage for the
> loaded context.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
