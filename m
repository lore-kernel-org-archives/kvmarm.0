From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug, add stub
 KVM_SET_GUEST_DEBUG ioctl
Date: Mon, 13 Apr 2015 14:12:31 +0200
Message-ID: <20150413121231.GO6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FE04C3CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:04:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gtqnAxuzPkFi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:04:40 -0400 (EDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
 [209.85.217.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 277CB4C3C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:04:39 -0400 (EDT)
Received: by lbcga7 with SMTP id ga7so56916316lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:12:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:02PM +0100, Alex Benn=E9e wrote:
> This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
> ioctl. Currently any operation flag will return EINVAL. Actual
> functionality will be added with further patches.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>.
> =

> ---
> v2
>   - simplified form of the ioctl (stuff will go into setup_debug)
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index b112efc..06c5064 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2604,7 +2604,7 @@ handled.
>  4.87 KVM_SET_GUEST_DEBUG
>  =

>  Capability: KVM_CAP_SET_GUEST_DEBUG
> -Architectures: x86, s390, ppc
> +Architectures: x86, s390, ppc, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_guest_debug (in)
>  Returns: 0 on success; -1 on error
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 5560f74..445933d 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -183,6 +183,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>  	case KVM_CAP_ARM_PSCI:
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_SET_GUEST_DEBUG:
>  		r =3D 1;
>  		break;

shouldn't you wait with advertising this capability until you've
implemented support for it?


Thanks,
-Christoffer
