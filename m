From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 26/27] KVM: Document errors for KVM_GET_ONE_REG and
 KVM_SET_ONE_REG
Date: Wed, 3 Apr 2019 22:27:46 +0200
Message-ID: <20190403202746.yoxwokr5uitli5q4@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-27-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4574E4A332
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 16:27:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s+8ARmOX6Lik for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Apr 2019 16:27:53 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3654C4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 16:27:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553864452-15080-27-git-send-email-Dave.Martin@arm.com>
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

On Fri, Mar 29, 2019 at 01:00:51PM +0000, Dave Martin wrote:
> KVM_GET_ONE_REG and KVM_SET_ONE_REG return some error codes that
> are not documented (but hopefully not surprising either).  To give
> an indication of what these may mean, this patch adds brief
> documentation.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index 2d4f7ce..cd920dd 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1871,6 +1871,9 @@ Architectures: all
>  Type: vcpu ioctl
>  Parameters: struct kvm_one_reg (in)
>  Returns: 0 on success, negative value on failure
> +Errors:
> + =A0ENOENT: =A0=A0no such register
> + =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
>  =

>  struct kvm_one_reg {
>         __u64 id;
> @@ -2192,6 +2195,9 @@ Architectures: all
>  Type: vcpu ioctl
>  Parameters: struct kvm_one_reg (in and out)
>  Returns: 0 on success, negative value on failure
> +Errors:
> + =A0ENOENT: =A0=A0no such register
> + =A0EINVAL: =A0=A0other errors, such as bad size encoding for a known re=
gister
>  =

>  This ioctl allows to receive the value of a single register implemented
>  in a vcpu. The register to read is indicated by the "id" field of the
> -- =

> 2.1.4
>

Are we sure all architectures have these, and only these errors? A quick
grep indicates not. I'm not sure we can document this easily here due to
it addressing all architectures at once. Maybe we could add arch-specific
subsections, but I'm not sure it's worth it.

drew
