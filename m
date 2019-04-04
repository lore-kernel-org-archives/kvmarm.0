From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 27/27] KVM: arm64/sve: Document KVM API extensions for
 SVE
Date: Thu, 4 Apr 2019 23:09:21 +0200
Message-ID: <20190404210921.7xz6o56wietd77li@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-28-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553864452-15080-28-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:52PM +0000, Dave Martin wrote:
> This patch adds sections to the KVM API documentation describing
> the extensions for supporting the Scalable Vector Extension (SVE)
> in guests.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> =

> ---
> =

> Changes since v5:
> =

>  * Document KVM_ARM_VCPU_FINALIZE and its interactions with SVE.
> ---
>  Documentation/virtual/kvm/api.txt | 132 ++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 129 insertions(+), 3 deletions(-)
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index cd920dd..68509de 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1873,6 +1873,7 @@ Parameters: struct kvm_one_reg (in)
>  Returns: 0 on success, negative value on failure
>  Errors:
>   =A0ENOENT: =A0=A0no such register
> + =A0EPERM: =A0=A0=A0register access forbidden for architecture-dependent=
 reasons
>   =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
>  =

>  struct kvm_one_reg {
> @@ -2127,13 +2128,20 @@ Specifically:
>    0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
>    0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
>    0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
> -  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
> -  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
> +  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    (*)
> +  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    (*)
>      ...
> -  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
> +  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]   (*)
>    0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
>    0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
>  =

> +(*) These encodings are not accepted for SVE-enabled vcpus.  See
> +    KVM_ARM_VCPU_INIT.
> +
> +    The equivalent register content can be accessed via bits [127:0] of
> +    the corresponding SVE Zn registers instead for vcpus that have SVE
> +    enabled (see below).
> +
>  arm64 CCSIDR registers are demultiplexed by CSSELR value:
>    0x6020 0000 0011 00 <csselr:8>
>  =

> @@ -2143,6 +2151,61 @@ arm64 system registers have the following id bit p=
atterns:
>  arm64 firmware pseudo-registers have the following bit pattern:
>    0x6030 0000 0014 <regno:16>
>  =

> +arm64 SVE registers have the following bit patterns:
> +  0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048=
*slice]
> +  0x6050 0000 0015 04 <n:4> <slice:5>   Pn bits[256*slice + 255 : 256*sl=
ice]
> +  0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 256*s=
lice]
> +  0x6060 0000 0015 ffff                 KVM_REG_ARM64_SVE_VLS pseudo-reg=
ister
> +
> +Access to slices beyond the maximum vector length configured for the
> +vcpu (i.e., where 16 * slice >=3D max_vq (**)) will fail with ENOENT.

I've been doing pretty well keeping track of the 16's, 128's, VL's and
VQ's, but this example lost me. Also, should it be >=3D or just > ?

> +
> +These registers are only accessible on vcpus for which SVE is enabled.
> +See KVM_ARM_VCPU_INIT for details.
> +
> +In addition, except for KVM_REG_ARM64_SVE_VLS, these registers are not
> +accessible until the vcpu's SVE configuration has been finalized
> +using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).  See KVM_ARM_VCPU_INIT
> +and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
> +
> +KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
> +lengths supported by the vcpu to be discovered and configured by
> +userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
> +or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
> +encodes the set of vector lengths as follows:
> +
> +__u64 vector_lengths[8];
> +
> +if (vq >=3D SVE_VQ_MIN && vq <=3D SVE_VQ_MAX &&
> +    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
> +	/* Vector length vq * 16 bytes supported */
> +else
> +	/* Vector length vq * 16 bytes not supported */
> +
> +(**) The maximum value vq for which the above condition is true is
> +max_vq.  This is the maximum vector length available to the guest on
> +this vcpu, and determines which register slices are visible through
> +this ioctl interface.
> +
> +(See Documentation/arm64/sve.txt for an explanation of the "vq"
> +nomenclature.)
> +
> +KVM_REG_ARM64_SVE_VLS is only accessible after KVM_ARM_VCPU_INIT.
> +KVM_ARM_VCPU_INIT initialises it to the best set of vector lengths that
> +the host supports.
> +
> +Userspace may subsequently modify it if desired until the vcpu's SVE
> +configuration is finalized using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).
> +
> +Apart from simply removing all vector lengths from the host set that
> +exceed some value, support for arbitrarily chosen sets of vector lengths
> +is hardware-dependent and may not be available.  Attempting to configure
> +an invalid set of vector lengths via KVM_SET_ONE_REG will fail with
> +EINVAL.
> +
> +After the vcpu's SVE configuration is finalized, further attempts to
> +write this register will fail with EPERM.
> +
>  =

>  MIPS registers are mapped using the lower 32 bits.  The upper 16 of that=
 is
>  the register group type:
> @@ -2197,6 +2260,7 @@ Parameters: struct kvm_one_reg (in and out)
>  Returns: 0 on success, negative value on failure
>  Errors:
>   =A0ENOENT: =A0=A0no such register
> + =A0EPERM: =A0=A0=A0register access forbidden for architecture-dependent=
 reasons
>   =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
>  =

>  This ioctl allows to receive the value of a single register implemented
> @@ -2690,6 +2754,33 @@ Possible features:
>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>  	  Depends on KVM_CAP_ARM_PMU_V3.
>  =

> +	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
> +	  Depends on KVM_CAP_ARM_SVE.
> +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> +
> +	   * After KVM_ARM_VCPU_INIT:
> +
> +	      - KVM_REG_ARM64_SVE_VLS may be read using KVM_GET_ONE_REG: the
> +	        initial value of this pseudo-register indicates the best set of
> +	        vector lengths possible for a vcpu on this host.
> +
> +	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> +
> +	      - KVM_RUN and KVM_GET_REG_LIST are not available;
> +
> +	      - KVM_GET_ONE_REG and KVM_SET_ONE_REG cannot be used to access
> +	        the scalable archietctural SVE registers
> +	        KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() or
> +	        KVM_REG_ARM64_SVE_FFR;
> +
> +	      - KVM_REG_ARM64_SVE_VLS may optionally be written using
> +	        KVM_SET_ONE_REG, to modify the set of vector lengths available
> +	        for the vcpu.
> +
> +	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> +
> +	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
> +	        no longer be written using KVM_SET_ONE_REG.
>  =

>  4.83 KVM_ARM_PREFERRED_TARGET
>  =

> @@ -3904,6 +3995,41 @@ number of valid entries in the 'entries' array, wh=
ich is then filled.
>  'index' and 'flags' fields in 'struct kvm_cpuid_entry2' are currently re=
served,
>  userspace should not expect to get any particular value there.
>  =

> +4.119 KVM_ARM_VCPU_FINALIZE
> +
> +Capability: KVM_CAP_ARM_SVE

The KVM_ARM_VCPU_FINALIZE vcpu ioctl isn't SVE specific, so it shouldn't
depend on the SVE cap. It should have it's own cap, or maybe it should
just be an KVM_ARM_VCPU_SVE_FINALIZE ioctl instead, i.e. not general.

> +Architectures: arm, arm64
> +Type: vcpu ioctl
> +Parameters: int feature (in)

This was called 'what' in the code.

> +Returns: 0 on success, -1 on error
> +Errors:
> +  EPERM:     feature not enabled, needs configuration, or already finali=
zed
> +  EINVAL:    unknown feature
> +
> +Recognised values for feature:
> +  arm64      KVM_ARM_VCPU_SVE
> +
> +Finalizes the configuration of the specified vcpu feature.
> +
> +The vcpu must already have been initialised, enabling the affected featu=
re, by
> +means of a successful KVM_ARM_VCPU_INIT call with the appropriate flag s=
et in
> +features[].
> +
> +For affected vcpu features, this is a mandatory step that must be perfor=
med
> +before the vcpu is fully usable.
> +
> +Between KVM_ARM_VCPU_INIT and KVM_ARM_VCPU_FINALIZE, the feature may be
> +configured by use of ioctls such as KVM_SET_ONE_REG.  The exact configur=
ation
> +that should be performaned and how to do it are feature-dependent.
> +
> +Other calls that depend on a particular feature being finalized, such as
> +KVM_RUN, KVM_GET_REG_LIST, KVM_GET_ONE_REG and KVM_SET_ONE_REG, will fai=
l with
> +-EPERM unless the feature has already been finalized by means of a
> +KVM_ARM_VCPU_FINALIZE call.
> +
> +See KVM_ARM_VCPU_INIT for details of vcpu features that require finaliza=
tion
> +using this ioctl.
> +
>  5. The kvm_run structure
>  ------------------------
>

I'm still not sure about EPERM vs. ENOEXEC.

Thanks,
drew
