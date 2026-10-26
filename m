Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793043563;
	b=YvWAfQk9dGCNZISSbZIp7QAEi3FrdH2q3hU2+gEaEQ259g4ts1BRQJXv0/xO4zXdx/GV
	 /7ZYPwcRPMVg4Q+jfudIlzSe4sfaTMjAfmI9rQGGxzcy5NUgCaF27sXLjF5MW5zE9P3sr
	 HUgO/kiXW2elo9vsoJ1z+h33KNlg+DORur0EE+o6vteDroxCpKj5elqRarfXEKF0VbjKF
	 cJk1TIWLbJXlhPGt0qhm5IPyiBXeDjS1Ux3iHpXvuqQtpXoqJBJ+u3r8AYxCXRpTb+7F/
	 uJh9CRaC4El0bg2EpDwDgU6OFmwdditNZeovkjknCECDSZLM+SqznjlldFGqRW1gAoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793043563;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Iz8nEeRUoSx59BuYet9dNiyHKe/fPrgbXO6zBJt1wYU=;
	b=Mrec3l/EHJ1dOu35gVkgtO0nHsD7VtFOgfpoDtO5WK2WXN5ChrU2kpk2zKqaIQ6yJiuu
	 FWRDyHB12TE79FMAYIqhyYhIIN3fdgUzuX9RLa8/ZjlzqPnUoHQwZMawYaIvsUdWvQchU
	 5To0HUe9u2qJufpsUUdkmYL18SQjzox7bTF7NUzIQSky4nOgpxhvHUiD1O5qQW+oPn/8/
	 QTdFVf/T/PPLw+XltjvEyHOQUNol5TB3sidhJpBNwt5vIRgl71r1vyXwZVqOhr4GKl+57
	 2FDtdgh4CiUGMALQc1llnr5tRrMwx5tudpcmYsZDrynQxv9VE5Vx5r1B7zeXG40rG/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVYlDZxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DC8606A31D;
	Mon, 26 Oct 2026 19:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVYlDZxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED12B1F01825;
	Mon, 26 Oct 2026 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793043563;
	bh=Iz8nEeRUoSx59BuYet9dNiyHKe/fPrgbXO6zBJt1wYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PVYlDZxAsoEZDhQ1SN8wVNatwEHENQSAY05RbTkmfvFILekO3ZTUsJBpd/6La9FsX
	 fWathrT5ToN3EwPvWnXF6G00oEC3og7IisJsTcVxMRaSOO7rK4JyN7yF6ukAh2xDbm
	 i2OdwD2yxqXwWw+7CCFuZSMt0DrMhlSdPxpu0X1War4kn/iHShJIpkqXd5yR7s23Pv
	 2TiHkS4SNPeK19GQjB6hmrGLHTXQ9dFnpGTdvA1NYIX8aPeSHhom2vcRstngeSVQ6B
	 /O/xkR4QUlFFa1ZpwKIgT+BULORX1zf8IDIiA+PsekM149JYZ1C2cM2oeUHtBxTyIv
	 wu80iWmo9V2hw==
Date: Mon, 26 Oct 2026 12:39:21 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when
 userspace clears nASSGIcap
Message-ID: <at-saZT_ixQxsZIr@kernel.org>
References: <20261026152639.3926498-1-fuad.tabba@linux.dev>
 <20261026152639.3926498-3-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026152639.3926498-3-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Oct 26, 2026 at 03:26:39PM +0000, Fuad Tabba wrote:
> Since commit c652887a92887 ("KVM: arm64: vgic-v3: Allow userspace to
> write GICD_TYPER2.nASSGIcap"), userspace can disable vPE allocation for
> a VM on a GICv4.1 host with vSGIs by clearing nASSGIcap before the vgic
> is initialised. vgic_init() then skips vgic_v4_init(), and
> kvm_vgic_dist_destroy() skips vgic_v4_teardown(). vgic_its_create()
> still calls vgic_v4_init() for an ITS created after the vgic is
> initialised, though, and vgic_v4_init() allocates the vPEs and requests
> a doorbell IRQ for each vCPU. Destroying the VM leaks them, and leaves
> each doorbell handler registered with a vCPU that's about to be freed.
> 
> Rather than gate on vgic_supports_direct_irqs(), which reads has_its
> before vgic_its_create() sets it, check for a cleared nASSGIcap in
> vgic_v4_init().
> 
> Fixes: c652887a92887 ("KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index a01de4de608a6..12a57921f6af3 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -251,6 +251,10 @@ int vgic_v4_init(struct kvm *kvm)
>  	if (!kvm_vgic_global_state.has_gicv4 || dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
>  		return 0; /* Nothing to see here... move along. */
>  
> +	/* Userspace disabled vPE allocation by clearing nASSGIcap */
> +	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
> +		return 0;
> +

Looking at both of the patches now, I'd rather we just fix the
predicates and use those to consistently gate GICv4. Untested as always:

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9e782a4fea7e..2b22f096a504 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1866,9 +1866,16 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
+	/*
+	 * Make an early indication that this VM has an ITS so calls to
+	 * vgic_supports_direct_irqs() work as intended, rolling back state
+	 * if we fail to setup GICv4.
+	 */
+	dev->kvm->arch.vgic.has_its = true;
 	if (vgic_initialized(dev->kvm)) {
 		ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
+			dev->kvm->arch.vgic.has_its = false;
 			mutex_unlock(&dev->kvm->arch.config_lock);
 			kfree(its);
 			return ret;
@@ -1893,7 +1900,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	xa_init(&its->translation_cache);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
-	dev->kvm->arch.vgic.has_its = true;
 	its->enabled = false;
 	its->dev = dev;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d..c65bd8783284 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -248,8 +248,8 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
-		return 0; /* Nothing to see here... move along. */
+	if (!vgic_supports_direct_irqs(kvm))
+		return 0;
 
 	if (dist->its_vm.vpes)
 		return 0;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae514..bd1614c9ff05 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -509,6 +509,10 @@ static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
 	if (vgic_is_v5(kvm))
 		return true;
 
+	/* GICv2 never supports direct IRQs */
+	if (!vgic_is_v3(kvm))
+		return false;
+
 	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
 }
 
-- 
Thanks,
Oliver
