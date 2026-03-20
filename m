Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9D431E839;
	Fri, 20 Mar 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774033686; cv=none; b=UWz/qIy9i6VdpN60XrtXWvGzRDWlXVn5XPROYkwznZT9yAwka/BxMJXJeg7a5EJZZaEmXpbm8Pq9NlbJ00RSVp2buiq6wZA+M5BELxVwuvRVuoPulcHgGgAiO7bTyTPw/iwHW6+/kkZnlrqsE6SsOyHw14fgHPhItqxn/57ne+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774033686; c=relaxed/simple;
	bh=hubpgunOKqXmTqXQCt/h6pUXQ4Vod13YMoCr7vvGoG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GP7xSAEavq/FpqWU5NUp7xz0ntDRgzQFcm10l1Dt/+yGJ6n/yoGkOegkFmRLfLFqJmO/uJF9wdDXvZkF3M/NaVmET4EoK5GcGPizuzTB5/8dIgx4sRJU0Yn4szrZZqDNJSbRHLHsmHHs1bEBxz/6DLb5Ty6HAB997vvtTuLwT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GC4yGqB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GC4yGqB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664ECC4CEF7;
	Fri, 20 Mar 2026 19:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033686;
	bh=hubpgunOKqXmTqXQCt/h6pUXQ4Vod13YMoCr7vvGoG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GC4yGqB4yeYqXeADGrpxx0K2f3j7IwHZKEMV6bj+hzupr9ZLkVHkBaEhxlFI9bb0N
	 Ecv9rW0Uz7rzFnG/FJnyRR7uM6nQsgsJNJDSBZLkg3Sh0BEc/gTN+KMP0g0ozp/aFd
	 Q4k+i5T5O/HSJ0sJGazw1Iqav/y0hX/9/ulyIv2+QccmEAy1dxwO87IccNcTcEKjnw
	 XAuhnywnhv8nvcK49cY1+i0uhzU9KIhGFp17Z7pseM+K6tZ9rRZH5/030eHux9VDlN
	 kETmXrocVeO4Iq0WTrJ/X/LIaX2cp2SnmNvtqB5kTv0BXigwzldI5yapq0/ct3/S4M
	 MctZs3GyFuQIw==
Date: Fri, 20 Mar 2026 12:08:06 -0700
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Gogul Balakrishnan <bgogul@google.com>,
	Arman Hasanzadeh <armanihm@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	codemender-patching+linux@google.com
Subject: Re: [PATCH] KVM: arm64: vgic: Annotate struct vgic_dist with
 __counted_by_ptr
Message-ID: <202603201158.4EF7FCFF7@keescook>
References: <20260319015418.2871262-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319015418.2871262-1-morbo@google.com>

On Thu, Mar 19, 2026 at 01:54:10AM +0000, Bill Wendling wrote:
> Add the __counted_by_ptr attribute to the spis pointer field in struct
> vgic_dist. This pointer field points to an array of struct vgic_irq
> elements, and the number of elements is tracked by the nr_spis field
> within the same structure.
> 
> The nr_spis field is initialized in vgic_init() (or earlier via
> userspace) before the spis array is allocated in kvm_vgic_dist_init().
> The nr_spis value remains constant during the lifetime of the spis
> allocation, making it a suitable counter for the array.

This one eluded me briefly, but yeah:

int vgic_init(struct kvm *kvm)
{
        struct vgic_dist *dist = &kvm->arch.vgic;
	...
        /* freeze the number of spis */
        if (!dist->nr_spis)
                dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;

        ret = kvm_vgic_dist_init(kvm, dist->nr_spis);



static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
{
        struct vgic_dist *dist = &kvm->arch.vgic;
	...
        dist->spis = kzalloc_objs(struct vgic_irq, nr_spis, GFP_KERNEL_ACCOUNT);


It seems weird that nr_spis is passed to kvm_vgic_dist_init at all:
there's only 1 caller, and the value is stored in dist->nr_spis
(available through kvm) immediately before the call. For readability,
I'd almost prefer to see:


diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 9b3091ad868c..9e6ca2f04581 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -190,16 +190,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 /**
  * kvm_vgic_dist_init: initialize the dist data structures
  * @kvm: kvm struct pointer
- * @nr_spis: number of spis, frozen by caller
  */
-static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
+static int kvm_vgic_dist_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
 	dist->active_spis = (atomic_t)ATOMIC_INIT(0);
-	dist->spis = kzalloc_objs(struct vgic_irq, nr_spis, GFP_KERNEL_ACCOUNT);
+	dist->spis = kzalloc_objs(struct vgic_irq, dist->nr_spis, GFP_KERNEL_ACCOUNT);
 	if (!dist->spis)
 		return  -ENOMEM;
 
@@ -211,7 +210,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	 * require prior initialization in case of a virtual GICv3 or trigger
 	 * initialization when using a virtual GICv2.
 	 */
-	for (i = 0; i < nr_spis; i++) {
+	for (i = 0; i < dist->nr_spis; i++) {
 		struct vgic_irq *irq = &dist->spis[i];
 
 		irq->intid = i + VGIC_NR_PRIVATE_IRQS;
@@ -401,7 +400,7 @@ int vgic_init(struct kvm *kvm)
 	if (!dist->nr_spis)
 		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
 
-	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
+	ret = kvm_vgic_dist_init(kvm);
 	if (ret)
 		goto out;
 


The other question I'd have (which isn't related to this patch
specifically) is if dist->spis is guaranteed to be NULL before
kvm_vgic_dist_init() is called.

Regardless:

Reviewed-by: Kees Cook <kees@kernel.org>

-Kees

> 
> This patch was generated by CodeMender and reviewed by Bill Wendling.
> Tested with the KVM selftests.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Gogul Balakrishnan <bgogul@google.com>
> Cc: Arman Hasanzadeh <armanihm@google.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Cc: codemender-patching+linux@google.com
> ---
>  include/kvm/arm_vgic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index f2eafc65bbf4..1cca87623d92 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -284,7 +284,7 @@ struct vgic_dist {
>  	/* Wants SGIs without active state */
>  	bool			nassgireq;
>  
> -	struct vgic_irq		*spis;
> +	struct vgic_irq		*spis __counted_by_ptr(nr_spis);
>  
>  	struct vgic_io_device	dist_iodev;
>  	struct vgic_io_device	cpuif_iodev;
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Kees Cook
