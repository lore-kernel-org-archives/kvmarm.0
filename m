From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 05/14] KVM: arm64/sve: Clean up UAPI register ID
 definitions
Date: Mon, 15 Apr 2019 17:17:39 +0200
Message-ID: <20190415151739.svfcwoybfr5js3wc@kamzik.brq.redhat.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CD14A4AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:17:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYUMUaPoSwQb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 11:17:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05CF44A48F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:17:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
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

On Fri, Apr 12, 2019 at 05:28:09PM +0100, Dave Martin wrote:
> Currently, the SVE register ID macros are not all defined in the
> same way, and advertise the fact that FFR maps onto the nonexistent
> predicate register P16.  This is really just for kernel
> convenience, and may lead userspace into bad habits.
> 
> Instead, this patch masks the ID macro arguments so that
> architecturally invalid register numbers will not be passed through
> any more, and uses a literal KVM_REG_ARM64_SVE_FFR_BASE macro to
> define KVM_REG_ARM64_SVE_FFR(), similarly to the way the _ZREG()
> and _PREG() macros are defined.
> 
> Rather than plugging in magic numbers for the number of Z- and P-
> registers and the maximum possible number of register slices, this
> patch provides definitions for those too.  Userspace is going to
> need them in any case, and it makes sense for them to come from
> <uapi/asm/kvm.h>.
> 
> sve_reg_to_region() uses convenience constants that are defined in
> a different way, and also makes use of the fact that the FFR IDs
> are really contiguous with the P15 IDs, so this patch retains the
> existing convenience constants in guest.c, supplemented with a
> couple of sanity checks to check for consistency with with the UAPI

s/with with/with/

> header.
> 
> Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++++++++++---------
>  arch/arm64/kvm/guest.c            |  9 +++++++++
>  2 files changed, 32 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
