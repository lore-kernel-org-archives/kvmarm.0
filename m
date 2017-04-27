From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 06/22] KVM: arm/arm64: vgic: expose (un)lock_all_vcpus
Date: Thu, 27 Apr 2017 02:18:34 -0700
Message-ID: <20170427091834.GF50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C7640D55
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 05:15:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqksuaSNyYLb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 05:15:43 -0400 (EDT)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E75640D4A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 05:15:42 -0400 (EDT)
Received: by mail-wr0-f178.google.com with SMTP id l9so13457082wre.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 02:18:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1492164934-988-7-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:18PM +0200, Eric Auger wrote:
> We need to use those helpers in vgic-its.c so let's
> expose them in the private vgic header.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> 
> ---
> 
> v4 -> v5:
> - Add Marc's A-b
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  virt/kvm/arm/vgic/vgic.h            | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index d181d2b..859bfa8 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -259,13 +259,13 @@ static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
>  	}
>  }
>  
> -static void unlock_all_vcpus(struct kvm *kvm)
> +void unlock_all_vcpus(struct kvm *kvm)
>  {
>  	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
>  }
>  
>  /* Returns true if all vcpus were locked, false otherwise */
> -static bool lock_all_vcpus(struct kvm *kvm)
> +bool lock_all_vcpus(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *tmp_vcpu;
>  	int c;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 6cf557e..b87f1c6 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -184,4 +184,7 @@ int vgic_init(struct kvm *kvm);
>  int vgic_debug_init(struct kvm *kvm);
>  int vgic_debug_destroy(struct kvm *kvm);
>  
> +bool lock_all_vcpus(struct kvm *kvm);
> +void unlock_all_vcpus(struct kvm *kvm);
> +
>  #endif
> -- 
> 2.5.5
> 
