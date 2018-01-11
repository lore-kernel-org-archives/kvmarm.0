From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-its: Fix vgicv4 init
Date: Thu, 11 Jan 2018 19:55:38 +0100
Message-ID: <20180111185538.GI15307@cbox>
References: <1515405174-21066-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F14E049D6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jan 2018 13:50:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FjKdorHLqnne for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jan 2018 13:50:53 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F422149D32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jan 2018 13:50:52 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id 143so7443361wma.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jan 2018 10:55:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1515405174-21066-1-git-send-email-eric.auger@redhat.com>
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
Cc: cdall@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 10:52:54AM +0100, Eric Auger wrote:
> Commit 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization
> issues") moved the vgic_supports_direct_msis() check in vgic_v4_init().
> However when vgic_v4_init is called from vgic_its_create(), the has_its
> field is not yet set. Hence vgic_supports_direct_msis returns false and
> vgic_v4_init does nothing.
> 
> Let's move the check back to vgic_v4_init caller.
> 
> Fixes: 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization issues")
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - move the check to the caller

Why this change, I slightly preferred the first version of this patch,
but I will admit that the "has_its = true; no_wait(); has_its = false;"
things is pretty ugly...

> - identify the right commit this patch fixes
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
>  virt/kvm/arm/vgic/vgic-its.c  | 2 +-
>  virt/kvm/arm/vgic/vgic-v4.c   | 3 ---
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 6231012..40be908 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> -	ret = vgic_v4_init(kvm);
> -	if (ret)
> -		goto out;
> +	if (vgic_supports_direct_msis(kvm)) {
> +		ret = vgic_v4_init(kvm);
> +		if (ret)
> +			goto out;
> +	}
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_enable(vcpu);
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 8e633bd..aebc88d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1687,7 +1687,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	if (!its)
>  		return -ENOMEM;
>  
> -	if (vgic_initialized(dev->kvm)) {
> +	if (kvm_vgic_global_state.has_gicv4 && vgic_initialized(dev->kvm)) {

... but now we're using vgic_supports_direct_msis() in one part of the
init path and a half-open coded version of that in another path, which
is not very pretty.

So I actually would suggest doing the init stuff more open-coded,
because init of the gic/its/gicv4 is a mess anyway.

Something like this:

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 62310122ee78..743ca5cb05ef 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	ret = vgic_v4_init(kvm);
-	if (ret)
-		goto out;
+	if (vgic_has_its(kvm)) {
+		ret = vgic_v4_init(kvm);
+		if (ret)
+			goto out;
+	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 4a37292855bc..bc4265154bac 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -118,7 +118,7 @@ int vgic_v4_init(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i, nr_vcpus, ret;
 
-	if (!vgic_supports_direct_msis(kvm))
+	if (!kvm_vgic_global_state.has_gicv4)
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)

Does that work?

Thanks,
-Christoffer
