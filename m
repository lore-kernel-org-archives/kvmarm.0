From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS
 array sizing
Date: Wed, 17 Apr 2019 15:01:34 +0100
Message-ID: <20190417140134.GA3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-10-git-send-email-Dave.Martin@arm.com>
 <20190415152037.d4ewqbxw7fbbbo3b@kamzik.brq.redhat.com>
 <20190416124142.GO3567@e103592.cambridge.arm.com>
 <20190416130054.6kv3tmpejnyrdart@kamzik.brq.redhat.com>
 <20190416141054.GR3567@e103592.cambridge.arm.com>
 <20190416142831.pmcctqrphquouq3z@kamzik.brq.redhat.com>
 <20190416155228.GT3567@e103592.cambridge.arm.com>
 <20190417041656.spoe62ztefhguf3y@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190417041656.spoe62ztefhguf3y@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 17, 2019 at 06:16:56AM +0200, Andrew Jones wrote:
> On Tue, Apr 16, 2019 at 04:52:28PM +0100, Dave Martin wrote:
> > On Tue, Apr 16, 2019 at 04:28:31PM +0200, Andrew Jones wrote:
> > > On Tue, Apr 16, 2019 at 03:10:55PM +0100, Dave Martin wrote:
> > 
> > [...]
> > 
> > > > arch/arm64/include/uapi/asm/kvm.h:
> > > > 
> > > > #include <asm/sve_context.h> /* which we already have anyway */
> > > > 
> > > > #define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
> > > > #define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
> > > > 
> > > > /* Vector lengths pseudo-register: */
> > > > #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> > > > 					 KVM_REG_SIZE_U512 | 0xffff)
> > > > #define KVM_ARM64_SVE_VLS_WORDS	\
> > > > 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> > > > 
> > > > 
> > > > Then document as follows:
> > > > Documentation/virtual/kvm/api.txt:
> > > > 
> > > > __u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
> > > > 
> > > > if (vq >= KVM_ARM64_SVE_VQ_MIN && vq <= KVM_ARM64_SVE_VQ_MAX)
> > > >     (vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
> > > > 		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1)
> > > > 	/* Vector length vq * 16 bytes supported */
> > > > else
> > > > 	/* Vector length vq * 16 bytes not supported */
> > > > 
> > > > 
> > > > Does that work for you?
> > > > 
> > > > Doing things this way avoids people having to include <asm/sigcontext.h>
> > > > (and the consequent clashes with glibc headers).
> > > >
> > > 
> > > I like that.
> > 
> > OK, are you happy with the following on top of this patch?
> > 
> > Cheers
> > ---Dave
> > 
> > --8<--
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index 68509de..03df379 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -2171,13 +2171,15 @@ and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
> >  KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
> >  lengths supported by the vcpu to be discovered and configured by
> >  userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
> > -or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
> > -encodes the set of vector lengths as follows:
> > +or KVM_SET_ONE_REG, the value of this register is of type
> > +__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
> > +follows:
> >  
> > -__u64 vector_lengths[8];
> > +__u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  if (vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX &&
> > -    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
> > +    ((vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
> > +		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1))
> >  	/* Vector length vq * 16 bytes supported */
> >  else
> >  	/* Vector length vq * 16 bytes not supported */
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 2a04ef0..edd2db8 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -258,9 +258,14 @@ struct kvm_vcpu_events {
> >  	 KVM_REG_SIZE_U256 |						\
> >  	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
> >  
> > +#define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
> > +#define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
> > +
> >  /* Vector lengths pseudo-register: */
> >  #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> >  					 KVM_REG_SIZE_U512 | 0xffff)
> > +#define KVM_ARM64_SVE_VLS_WORDS	\
> > +	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> >  
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index f025a2f..5bb909c 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -208,10 +208,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> >  
> > -#define SVE_VLS_WORDS (vq_word(SVE_VQ_MAX) + 1)
> > -
> >  static bool vq_present(
> > -	const u64 (*const vqs)[SVE_VLS_WORDS],
> > +	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> >  	unsigned int vq)
> >  {
> >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > @@ -220,7 +218,7 @@ static bool vq_present(
> >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >  	unsigned int max_vq, vq;
> > -	u64 vqs[SVE_VLS_WORDS];
> > +	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  	if (!vcpu_has_sve(vcpu))
> >  		return -ENOENT;
> > @@ -244,7 +242,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >  	unsigned int max_vq, vq;
> > -	u64 vqs[SVE_VLS_WORDS];
> > +	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  	if (!vcpu_has_sve(vcpu))
> >  		return -ENOENT;
> >
> 
> Yup
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

OK, thanks
---Dave
