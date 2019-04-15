From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 13/14] KVM: Clarify KVM_{SET,GET}_ONE_REG error code
 documentation
Date: Mon, 15 Apr 2019 17:21:32 +0200
Message-ID: <20190415152132.avwkmmuwolh7juhy@kamzik.brq.redhat.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B924A48F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:21:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gxE2J2QTBxU2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 11:21:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAD244A48D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:21:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1555086498-26691-14-git-send-email-Dave.Martin@arm.com>
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

On Fri, Apr 12, 2019 at 05:28:17PM +0100, Dave Martin wrote:
> The current error code documentation for KVM_GET_ONE_REG and
> KVM_SET_ONE_REG could be read as implying that all architectures
> implement these error codes, or that KVM guararntees which error

guarantees

> code is returned in a particular situation.
> =

> Because this is not really the case, this patch waters down the
> documentation explicitly to remove such guarantees.
> =

> EPERM is marked as arm64-specific, since for now arm64 really is
> the only architecture that yields this error code for the
> finalization-required case.  Keeping this as a distinct error code
> is useful however for debugging due to the statefulness of the API
> in this instance.
> =

> No functional change.
> =

> Suggested-by: Andrew Jones <drjones@redhat.com>
> Fixes: 395f562f2b4c ("KVM: Document errors for KVM_GET_ONE_REG and KVM_SE=
T_ONE_REG")
> Fixes: 50036ad06b7f ("KVM: arm64/sve: Document KVM API extensions for SVE=
")
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index b115b23..74c51c7 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1873,8 +1873,10 @@ Parameters: struct kvm_one_reg (in)
>  Returns: 0 on success, negative value on failure
>  Errors:
>   =A0ENOENT: =A0=A0no such register
> - =A0EPERM: =A0=A0=A0register access forbidden for architecture-dependent=
 reasons
> - =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
> + =A0EINVAL: =A0=A0invalid register ID, or no such register
> + =A0EPERM: =A0=A0=A0(arm64) register access not allowed before vcpu fina=
lization
> +(These error codes are indicative only: do not rely on a specific error
> +code being returned in a specific situation.)
>  =

>  struct kvm_one_reg {
>         __u64 id;
> @@ -2258,10 +2260,12 @@ Architectures: all
>  Type: vcpu ioctl
>  Parameters: struct kvm_one_reg (in and out)
>  Returns: 0 on success, negative value on failure
> -Errors:
> +Errors include:
>   =A0ENOENT: =A0=A0no such register
> - =A0EPERM: =A0=A0=A0register access forbidden for architecture-dependent=
 reasons
> - =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
> + =A0EINVAL: =A0=A0invalid register ID, or no such register
> + =A0EPERM: =A0=A0=A0(arm64) register access not allowed before vcpu fina=
lization
> +(These error codes are indicative only: do not rely on a specific error
> +code being returned in a specific situation.)
>  =

>  This ioctl allows to receive the value of a single register implemented
>  in a vcpu. The register to read is indicated by the "id" field of the
> -- =

> 2.1.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
