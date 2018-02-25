From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 31/40] KVM: arm64: Move common VHE/non-VHE trap config
 in separate functions
Date: Sun, 25 Feb 2018 22:29:43 +0100
Message-ID: <20180225212943.GH7396@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-32-christoffer.dall@linaro.org>
 <833c8ef7-dfd8-6b01-cab5-c97c86b705f3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <833c8ef7-dfd8-6b01-cab5-c97c86b705f3@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Grall <julien.grall@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Dave Martin <Dave.Martin@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 23, 2018 at 02:30:54PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 15/02/18 21:03, Christoffer Dall wrote:
> >@@ -85,37 +123,14 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >  {
> >  	u64 hcr = vcpu->arch.hcr_el2;
> >-	/*
> >-	 * We are about to set CPTR_EL2.TFP to trap all floating point
> >-	 * register accesses to EL2, however, the ARM ARM clearly states that
> >-	 * traps are only taken to EL2 if the operation would not otherwise
> >-	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> >-	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> >-	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> >-	 * it will cause an exception.
> >-	 */
> >-	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
> >-		write_sysreg(1 << 30, fpexc32_el2);
> >-		isb();
> >-	}
> >+	write_sysreg(hcr, hcr_el2);
> >  	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
> >  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> >-	write_sysreg(hcr, hcr_el2);
> 
> OOI, any reason to move the write to HCR_EL2 just before the if?
> 

Just to keep the two lines together where we read the value from the
vcpu structure and write it to hardware.  It's hard to tell from this
patch, but I think it looks nicer in the end.

Thanks,
-Christoffer
