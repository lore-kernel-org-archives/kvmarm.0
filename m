From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH V2 1/2] KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on
 arm/arm64
Date: Thu, 23 Feb 2017 11:10:27 +0100
Message-ID: <20170223101027.GA1409@cbox>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
 <1486538141-30627-2-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E0840C8A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:09:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQ0Itm+a7jDj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Feb 2017 05:09:42 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F7FC40C56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:09:42 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id v77so24418272wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 02:10:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1486538141-30627-2-git-send-email-linucherian@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linucherian@gmail.com
Cc: sunil.goutham@cavium.com, marc.zyngier@arm.com, linu.cherian@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 08, 2017 at 12:45:40PM +0530, linucherian@gmail.com wrote:
> From: Linu Cherian <linu.cherian@cavium.com>
> 
> Return KVM_USER_MEM_SLOTS for userspace capability query on
> NR_MEMSLOTS.

This feature seems to be undocumented (I cannot find it in
Documentation/virtual/kvm/api.txt).

Can we add documentation for it?

What does user space do currently without this capability?  Does it just
rely on some default?

Thanks,
-Christoffer

> 
> Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
> ---
>  arch/arm/kvm/arm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9d74464..b64b47f 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -221,6 +221,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MAX_VCPUS:
>  		r = KVM_MAX_VCPUS;
>  		break;
> +	case KVM_CAP_NR_MEMSLOTS:
> +		r = KVM_USER_MEM_SLOTS;
> +		break;
>  	case KVM_CAP_MSI_DEVID:
>  		if (!kvm)
>  			r = -EINVAL;
> -- 
> 1.9.1
> 
