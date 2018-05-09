From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 11/15] KVM: arm64: Save host SVE context as appropriate
Date: Wed, 9 May 2018 10:30:05 +0100
Message-ID: <20180509093004.GN7753@e103592.cambridge.arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-12-git-send-email-Dave.Martin@arm.com>
 <606acf08-5af7-8045-221d-73737e730c3c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <606acf08-5af7-8045-221d-73737e730c3c@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 09:50:26AM +0100, Marc Zyngier wrote:
> On 08/05/18 17:44, Dave Martin wrote:
> > This patch adds SVE context saving to the hyp FPSIMD context switch
> > path.  This means that it is no longer necessary to save the host
> > SVE state in advance of entering the guest, when in use.
> > 
> > In order to avoid adding pointless complexity to the code, VHE is
> > assumed if SVE is in use.  VHE is an architectural prerequisite for
> > SVE, so there is no good reason to turn CONFIG_ARM64_VHE off in
> > kernels that support both SVE and KVM.
> > 
> > Historically, software models exist that can expose the
> > architecturally invalid configuration of SVE without VHE, so if
> > this situation is detected this patch warns and refuses to create a
> > VM.  Doing this check at VM creation time avoids race issues
> > between KVM and SVE initialisation.
> 
> I don't think the commit log now reflects the code, since we bail out at
> init time and disable KVM altogether.

Will fix to say that we simply disable KVM completely at kvm_init() time
in this case.

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c

[...]

> > @@ -337,8 +341,22 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
> >  
> >  	isb();
> >  
> > -	if (vcpu->arch.host_fpsimd_state) {
> > -		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> > +	if (host_fpsimd) {
> > +		/*
> > +		 * In the SVE case, VHE is assumed: it is enforced by
> > +		 * Kconfig and kvm_arch_init_vm().
> 
> Nit: this is now kvm_arch_init().

Will fix.

[...]

> Otherwise:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks
---Dave
