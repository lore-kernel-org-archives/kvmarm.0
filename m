Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EA2368D79;
	Mon,  1 Jun 2026 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780340938; cv=none; b=asGNdOu/SzwjdXUD0fldhsG0/UqGaon1bxj8T0Eg/aT620VWJIRoo4RtRcH20jctvd99WLWahzkzkQCL+FUazYInglev/cmQedHWpTf04eCJI4bg5ZwujpbPHDAgtIW/f2V3+wdkWsBxGXeK/4oXpVjQYMNdRi4pLsk3zDPWoOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780340938; c=relaxed/simple;
	bh=560y4INcT3rA8822y8XgXTuuQop81lDWLxMR0lS9FD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5VBvf/MKq0QfIXPB45Le+G7S3YmAGSX+3lj1u7NFyng0HUTO82V+zmgyQhVCHIGxgBc/nnJ4mQDy8xKlwnHh0OM0/lgqSLsrjA+J2tVWuhxcxI6b+BxmObIfOr0dm9+G0AGodum7AZW5hWxJxS//V38sdJAdFwunsiMpZyTHUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mD5ROBon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mD5ROBon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29501F00898;
	Mon,  1 Jun 2026 19:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780340937;
	bh=elXuand+n/viDgsywhdjTLL4Sq6m2LCvhd5nnF4PGAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mD5ROBonnzUew3QCRjyhq+2GxLjZyXfTZHazuIgIgTKTCtPXlSpXOq2KTubw6Bafo
	 QQ1/jINkJySUG5j5QeHnxk/9GsW+g/QRB+iU1nS/HrWUqoF2M8w8e2wsi2vjCPiT0D
	 IltrUTYgiyn+GTxaIEx9FU9Ea/eDBFHTyLK3rkARAprsPrUUyD+ikKTg4YPS2Q5zvy
	 L7kXogwHSq5F9+C1bdWYar3dIK7rmQLvmiqi3V/2hFPoi1jSY13/NNiRUePLmgpk7M
	 YbbaeYe2Mu7Eg6aiv4Z4jrVem1AfqSuLYs0YAHTyHbvaR2zg6j15n64S0/oLfFMzD6
	 Ik1b337U8R9Bg==
Date: Mon, 1 Jun 2026 12:08:55 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Drop the translation cache
 reference only for the erased entry
Message-ID: <ah3Yx0fjguUdCk_G@kernel.org>
References: <ah2c5lu4JbUg7dj-@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah2c5lu4JbUg7dj-@v4bel>

Hi Hyunwoo,

Nice find.

On Mon, Jun 01, 2026 at 11:53:26PM +0900, Hyunwoo Kim wrote:
> vgic_its_invalidate_cache() walks the per-ITS translation cache with
> xa_for_each() and drops the cache's reference on each entry with
> vgic_put_irq(). It puts the iterated pointer, though, rather than the
> value returned by xa_erase().
> 
> The function is called from contexts that do not exclude one another: the
> ITS command handlers hold its_lock, the GITS_CTLR write path holds
> cmd_lock, and the path that clears EnableLPIs in a redistributor's
> GICR_CTLR holds neither. Two or more of them can drain the same cache
> concurrently, and if each one observes the same entry, erases it and then
> puts it, the single reference the cache holds on that entry is dropped
> more than once. The entry can then be freed while an ITE still maps it.
> 
> xa_erase() is atomic and returns the previous entry, so put only the entry
> that this context actually removed. The cache reference is then dropped
> exactly once per entry even when the invalidations run concurrently, and
> the behavior is unchanged when only one context runs.

Next time:

Cc: stable@vger.kernel.org

> Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 1d7e5d560af4..1e3706ac3b8e 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -597,8 +597,10 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
>  	unsigned long idx;
>  
>  	xa_for_each(&its->translation_cache, idx, irq) {
> -		xa_erase(&its->translation_cache, idx);
> -		vgic_put_irq(kvm, irq);
> +		/* Only the context that erases the entry drops its cache ref. */
> +		irq = xa_erase(&its->translation_cache, idx);
> +		if (irq)
> +			vgic_put_irq(kvm, irq);
>  	}
>  }

This definitely works but TBH I'd rather just plug the subtle race and
do invalidations behind the its_lock since it already nests with the
cmd_lock.

Could you give this a spin?

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2ea9f1c7ebcd..b2225da212ec 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -596,6 +596,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	struct vgic_irq *irq;
 	unsigned long idx;
 
+	lockdep_assert_held(&its->its_lock);
+
 	xa_for_each(&its->translation_cache, idx, irq) {
 		xa_erase(&its->translation_cache, idx);
 		vgic_put_irq(kvm, irq);
@@ -607,17 +609,16 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm)
 	struct kvm_device *dev;
 	struct vgic_its *its;
 
-	rcu_read_lock();
+	guard(mutex)(&kvm->lock);
 
-	list_for_each_entry_rcu(dev, &kvm->devices, vm_node) {
+	list_for_each_entry(dev, &kvm->devices, vm_node) {
 		if (dev->ops != &kvm_arm_vgic_its_ops)
 			continue;
 
 		its = dev->private;
+		guard(mutex)(&its->its_lock);
 		vgic_its_invalidate_cache(its);
 	}
-
-	rcu_read_unlock();
 }
 
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
@@ -1725,8 +1726,10 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 		goto out;
 
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
-	if (!its->enabled)
+	if (!its->enabled) {
+		guard(mutex)(&its->its_lock);
 		vgic_its_invalidate_cache(its);
+	}
 
 	/*
 	 * Try to process any pending commands. This function bails out early

--
Thanks,
Oliver
