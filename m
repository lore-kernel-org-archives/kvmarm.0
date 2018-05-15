From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v7 07/16] KVM: arm64: Repurpose vcpu_arch.debug_flags for
 general-purpose flags
Date: Tue, 15 May 2018 12:55:30 +0200
Message-ID: <20180515105530.GD38551@C02W217FHV2R.local>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-8-git-send-email-Dave.Martin@arm.com>
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

On Wed, May 09, 2018 at 05:12:56PM +0100, Dave Martin wrote:
> In struct vcpu_arch, the debug_flags field is used to store
> debug-related flags about the vcpu state.
> 
> Since we are about to add some more flags related to FPSIMD and
> SVE, it makes sense to add them to the existing flags field rather
> than adding new fields.  Since there is only one debug_flags flag
> defined so far, there is plenty of free space for expansion.
> 
> In preparation for adding more flags, this patch renames the
> debug_flags field to simply "flags", and updates comments
> appropriately.
> 
> The flag definitions are also moved to <asm/kvm_host.h>, since
> their presence in <asm/kvm_asm.h> was for purely historical
> reasons:  these definitions are not used from asm any more, and not
> very likely to be as more Hyp asm is migrated to C.
> 
> KVM_ARM64_DEBUG_DIRTY_SHIFT has not been used since commit
> 1ea66d27e7b0 ("arm64: KVM: Move away from the assembly version of
> the world switch"), so this patch gets rid of that too.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
