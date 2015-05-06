From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Wed, 6 May 2015 16:12:49 +0200
Message-ID: <20150506141249.GA6796@cbox>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221685073C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 10:04:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9+pUYz-RXPn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2015 10:04:02 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ED65506A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 10:04:02 -0400 (EDT)
Received: by lbbuc2 with SMTP id uc2so8536000lbb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 May 2015 07:12:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?B?Suly6W15IEZhbmd16GRl?= <j.fanguede@virtualopensystems.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi J=E9r=E9my,

On Tue, May 05, 2015 at 11:13:11AM +0200, J=E9r=E9my Fangu=E8de wrote:
> To maintain cache coherency on ARM, we may need a mechanism to flush
> the data cache.

In addition to generally just making this functionality available (see
below), do you have an actual use case in mind for this?  To solve the
VGA issue, for example, we already have a patch series from Drew trying
to address this.  Does that not work for you?

There was a long discussion about this here:
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-February/013593.html

Drew then created a patch set, here:
https://lists.nongnu.org/archive/html/qemu-devel/2015-03/msg01254.html

and replied to himself, here:
https://www.marc.info/?l=3Dandroid-virt&m=3D142670523929132&w=3D3

Which basically says that he doesn't like having to do flushes all over
QEMU (IIUC), so he sent this version instead:
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-March/014027.html

Which he now said he'd respin.

Meanwhile there was also the idea of simply convincing the guest to
access devices as coherent through added DT properties etc., but I'm not
sure where that landed.

I think it would be better to agree to the overall approach before
sending out further patches.

On this particular patch, it does feel like sidestepping general kernel
functionality for arm64 through KVM, which I think is a bit weird.  I'd
like to hear Will and Catalin's thoughts on this before we'd go ahead
with something like this.

> =

> This patch implements KVM_FLUSH_DCACHE_GPA vm ioctl which flushes the
> data cache at a specified address range. The input argument is a
> struct kvm_mem_addr containing the guest physical address and the
> length.
> =

> Signed-off-by: J=E9r=E9my Fangu=E8de <j.fanguede@virtualopensystems.com>
> ---
>  arch/arm/kvm/arm.c       | 13 +++++++++++++
>  include/uapi/linux/kvm.h |  6 ++++++
>  2 files changed, 19 insertions(+)
> =

> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..8638fd2 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -886,6 +886,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  =

>  		return 0;
>  	}
> +	case KVM_FLUSH_DCACHE_GPA: {
> +		struct kvm_mem_addr mem_addr;
> +		hva_t hva;
> +		gpa_t gpa;
> +
> +		if (copy_from_user(&mem_addr, argp, sizeof(mem_addr)))
> +			return -EFAULT;
> +
> +		gpa =3D mem_addr.addr;
> +		hva =3D gfn_to_hva(kvm, gpa_to_gfn(gpa)) | (gpa & ~PAGE_MASK);
> +		kvm_flush_dcache_to_poc((void *)hva, mem_addr.len);

In case you end up moving further with this, see the following commit:

0d3e4d4 (arm/arm64: KVM: Use kernel mapping to perform invalidation on
page fault, 2015-01-05)

I think you end up with the same problem here.

-Christoffer
