From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 13/40] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Tue, 27 Feb 2018 14:35:27 +0100
Message-ID: <20180227133527.efdcaqtpdjpz7gul@kamzik.brq.redhat.com>
References: <20180227113429.637-1-cdall@kernel.org>
 <20180227113429.637-14-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180227113429.637-14-cdall@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 27, 2018 at 12:34:02PM +0100, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> So far this is mostly (see below) a copy of the legacy non-VHE switch
> function, but we will start reworking these functions in separate
> directions to work on VHE and non-VHE in the most optimal way in later
> patches.
> 
> The only difference after this patch between the VHE and non-VHE run
> functions is that we omit the branch-predictor variant-2 hardening for
> QC Falkor CPUs, because this workaround is specific to a series of
> non-VHE ARMv8.0 CPUs.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v4:
>      - Unified has_vhe() conditional calls in kvm_arch_vcpu_ioctl_run
>      - Added isb() on exit path of VHE-specific kvm_vcpu_run(), because
>        otherwise 32-bit guests can crash the system on reentry to the
>        guest, because writes to FPEXC32_EL2 will cause a trap at EL2
>        which leads to a hyp panic.  This can be observed on the model
>        where writing FPEN to CPACR_EL1 on guest exit doesn't take effect
>        prior to entering the guest again.
>     
>     Changes since v3:
>      - Added BUG() to 32-bit ARM VHE run function
>      - Omitted QC Falkor BP Hardening functionality from VHE-specific
>        function
>     
>     Changes since v2:
>      - Reworded commit message
>     
>     Changes since v1:
>      - Rename kvm_vcpu_run to kvm_vcpu_run_vhe and rename __kvm_vcpu_run to
>        __kvm_vcpu_run_nvhe
>      - Removed stray whitespace line
> 
>  arch/arm/include/asm/kvm_asm.h    |  5 ++-
>  arch/arm/kvm/hyp/switch.c         |  2 +-
>  arch/arm64/include/asm/kvm_asm.h  |  4 ++-
>  arch/arm64/include/asm/kvm_host.h |  7 +++++
>  arch/arm64/kvm/hyp/switch.c       | 66 ++++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/arm.c                | 12 ++++---
>  6 files changed, 87 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
