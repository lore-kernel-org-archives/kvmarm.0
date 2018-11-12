From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC] [PATCH] kvm: arm: Introduce error code KVM_EINVARIANT
Date: Mon, 12 Nov 2018 10:06:35 +0100
Message-ID: <20181112090635.GA11669@C02W217FHV2R.local>
References: <1540290099-146109-1-git-send-email-mjaggi@caviumnetworks.com>
 <4bbb4e76-b714-eafe-f95b-aca1a258e9fe@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 301134A33D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Nov 2018 04:06:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2gk0-CzgmtJ0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Nov 2018 04:06:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3304A31B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Nov 2018 04:06:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <4bbb4e76-b714-eafe-f95b-aca1a258e9fe@caviumnetworks.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Manish Jaggi <mjaggi@caviumnetworks.com>
Cc: "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>, "quintela@redhat.com" <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "dgilbert@redhat.com" <dgilbert@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Jaggi, Manish" <Manish.Jaggi@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "Nowicki,
 Tomasz" <Tomasz.Nowicki@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Manish,

On Sat, Nov 10, 2018 at 10:18:47PM +0000, Manish Jaggi wrote:
> 
> CCing a larger audience.
> Please review.
> 
> On 10/23/2018 03:51 PM, Jaggi, Manish wrote:
> > From: Manish Jaggi <manish.jaggi@cavium.com>
> >
> > This patch introduces an error code KVM_EINVARIANT which is returned
> > by KVM when userland tries to set an invariant register.
> >
> > The need for this error code is in VM Migration for arm64.
> > ARM64 systems use mainly -machine virt -cpu host as parameter to qemu.
> > Migration requires both Source and destination machines to have same
> > physical cpu. There are cases where the overall architecture of CPU is
> > same but the next version of the chip with some bug fixes which have no
> > effect on qemu operation. In such cases invariant registers like MIDR
> > have a different value.
> > Currently Migration fails in such cases.
> >
> > Rather than sending a EINVAL, a specifc error code will help
> > userland program the guest invariant register by querying the migrated
> > host machines invariant registers.
> >
> > Qemu will have a parameter -hostinvariant along with checking of this
> > error code. So it can be safely assumed that the feature is opt-in
> >
> > Corresponding Qemu patchset can be found at :
> > https://lists.gnu.org/archive/html/qemu-devel/2018-10/msg05048.html
> >
> >
> > Signed-off-by: Manish Jaggi <manish.jaggi@cavium.com>
> > ---
> >   arch/arm64/kvm/sys_regs.c     | 9 ++++-----
> >   include/uapi/linux/kvm_para.h | 1 +
> >   2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 22fbbdb..78ffc02 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1111,7 +1111,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> >   
> >   	/* This is what we mean by invariant: you can't change it. */
> >   	if (val != read_id_reg(rd, raz))
> > -		return -EINVAL;
> > +		return -KVM_EINVARIANT;
> >   
> >   	return 0;
> >   }
> > @@ -2254,9 +2254,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
> >   		return err;
> >   
> >   	/* This is what we mean by invariant: you can't change it. */
> > -	if (r->val != val)
> > -		return -EINVAL;
> > -
> > +	if (r->val != val)	
> > +		return -KVM_EINVARIANT;
> >   	return 0;
> >   }
> >   
> > @@ -2335,7 +2334,7 @@ static int demux_c15_set(u64 id, void __user *uaddr)
> >   
> >   		/* This is also invariant: you can't change it. */
> >   		if (newval != get_ccsidr(val))
> > -			return -EINVAL;
> > +			return -KVM_EINVARIANT;
> >   		return 0;
> >   	default:
> >   		return -ENOENT;
> > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > index 6c0ce49..4358669 100644
> > --- a/include/uapi/linux/kvm_para.h
> > +++ b/include/uapi/linux/kvm_para.h
> > @@ -17,6 +17,7 @@
> >   #define KVM_E2BIG		E2BIG
> >   #define KVM_EPERM		EPERM
> >   #define KVM_EOPNOTSUPP		95
> > +#define KVM_EINVARIANT          96
> >   
> >   #define KVM_HC_VAPIC_POLL_IRQ		1
> >   #define KVM_HC_MMU_OP			2
> 

Eh, unless I'm severely missing something, I think you're confusing how
these error codes are used.

The error codes in include/uapi/linux/kvm_para.h are for hypercalls from
guests, not return values to userspace.  For the latter, we don't
have a habit of inventing new constants for something subsystem
specific, but instead we use the existing error codes which can be
understood by userspace software.

What's more, changing an error code is an ABI change and not something
you can just do at will.  If we are overloading EINVAL with the
KVM_SET_ONE_REG syscall (are we?), then you need to find some way to
communicate the additional information you need to userspace without
interfering with legacy userspace software's interaction with the
kernel.


Thanks,

    Christoffer
