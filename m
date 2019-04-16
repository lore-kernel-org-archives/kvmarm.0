From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS
 array sizing
Date: Tue, 16 Apr 2019 15:00:54 +0200
Message-ID: <20190416130054.6kv3tmpejnyrdart@kamzik.brq.redhat.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-10-git-send-email-Dave.Martin@arm.com>
 <20190415152037.d4ewqbxw7fbbbo3b@kamzik.brq.redhat.com>
 <20190416124142.GO3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825C44A4CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 09:01:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ivj+IiU+LZbO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 09:01:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 504FA4A4C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 09:01:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190416124142.GO3567@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 16, 2019 at 01:41:42PM +0100, Dave Martin wrote:
> On Mon, Apr 15, 2019 at 05:20:37PM +0200, Andrew Jones wrote:
> > On Fri, Apr 12, 2019 at 05:28:13PM +0100, Dave Martin wrote:
> > > A complicated DIV_ROUND_UP() expression is currently written out
> > > explicitly in multiple places in order to specify the size of the
> > > bitmap exchanged with userspace to represent the value of the
> > > KVM_REG_ARM64_SVE_VLS pseudo-register.
> > > 
> > > To make this more readable, this patch replaces these with a single
> > > define.
> > > 
> > > Since the number of words in a bitmap is just the index of the last
> > > word used + 1, this patch expresses the bound that way instead.
> > > This should make it clearer what is being expressed.
> > > 
> > > Since use of DIV_ROUND_UP() was the only reason for including
> > > <linux/kernel.h> in guest.c, this patch removes that #include.
> > > 
> > > No functional change.
> > > 
> > > Suggested-by: Andrew Jones <drjones@redhat.com>
> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > ---
> > >  arch/arm64/kvm/guest.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 73044e3..f025a2f 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -23,7 +23,6 @@
> > >  #include <linux/errno.h>
> > >  #include <linux/err.h>
> > >  #include <linux/nospec.h>
> > > -#include <linux/kernel.h>
> > >  #include <linux/kvm_host.h>
> > >  #include <linux/module.h>
> > >  #include <linux/stddef.h>
> > > @@ -209,8 +208,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> > >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> > >  
> > > +#define SVE_VLS_WORDS (vq_word(SVE_VQ_MAX) + 1)
> > > +
> > >  static bool vq_present(
> > > -	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
> > > +	const u64 (*const vqs)[SVE_VLS_WORDS],
> > >  	unsigned int vq)
> > >  {
> > >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > > @@ -219,7 +220,7 @@ static bool vq_present(
> > >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >  	unsigned int max_vq, vq;
> > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > +	u64 vqs[SVE_VLS_WORDS];
> > >  
> > >  	if (!vcpu_has_sve(vcpu))
> > >  		return -ENOENT;
> > > @@ -243,7 +244,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >  	unsigned int max_vq, vq;
> > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > +	u64 vqs[SVE_VLS_WORDS];
> > >  
> > >  	if (!vcpu_has_sve(vcpu))
> > >  		return -ENOENT;
> > > -- 
> > > 2.1.4
> > >
> > 
> > This is good, but I wonder if we could define the number of VLS words in
> > the documentation in terms of SVE_VQ_MAX too. Currently it's just the
> > hard coded 8 ("__u64 vector_lengths[8]").
> > 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> I see your point, but SVE_VQ_MAX isn't really part of the KVM API, so I
> was avoiding it here.

It's not part of the KVM API, but it is uapi (asm/sigcontext.h). I'd
prefer we use it than to encourage KVM userspace to scatter 8's around.

> 
> [8] is at least impossible to misinterpret, even if it's not the most
> self-explanatory option.

It's impossible to misinterpret, but also begs the questions of where
it comes from and if it will always be that way forever and ever.

Thanks,
drew
