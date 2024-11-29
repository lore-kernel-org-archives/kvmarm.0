Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04CA45C14
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 07:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732864877; cv=none; b=J14bjnLb/aYFd2KuLTeCsVaUzDwZXyoZ73MDl1RKC05zoTf0W2D24/TQjKfKV2oMYykbiOqaHIR6MKQARdw6C4hc7nsw9/vsoP9xEVlFREV3m3XHd35YHbnje1AVHwJFA8iQ9Uv+XAJjHgUwPlpmw843WR1KmSTmKoz7Sqn9D80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732864877; c=relaxed/simple;
	bh=lFYKy2bfbVArpmqIR0r5wqIcjalza1sXfVuuGhrCM3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ad12XTJ043F0TCpow0s5QycRt05caEg/8JiKFlE1fbigvY2pL/VOhBvtmxLqCOEUviL0dGM/hDg4nFyOwnIGrPGXgV3X8QkehAW+2crLp15GMZG6KaMSwZ/TEJhg5kT7D2d5ksSU9zZsZbQhUtHSvfTk/TZdEZh2lNREY3nVSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l8jDcI4i; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l8jDcI4i"
Date: Thu, 28 Nov 2024 23:20:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732864871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4tD95wEzzC7ua/VvyG4y/vO8ctyWBdq2dh2LRB0nY8=;
	b=l8jDcI4iye34mkZSkKkml7LqVOjXtSRZ9LRvvG6Rhz0dvsP7PTnFZQs5ybXAcUyWNmwt/C
	l9TqAIceTPIEthXOsJTAz1Qr7fGGi6mmGR4Xd375xgoaxaqyMcomAKj8Df6caOyAwuhxs0
	lmRyrJaCjs5nK6XhnuGlwzRGuOHFA8I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Add error handling in
 vgic_its_cache_translation
Message-ID: <Z0lrWynd3O8a1pG_@linux.dev>
References: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
 <Z0iujBMl1ypdwfBu@linux.dev>
 <a62e682d-c2e8-424d-84c5-4e64468124a9@inria.fr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a62e682d-c2e8-424d-84c5-4e64468124a9@inria.fr>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 28, 2024 at 08:04:01PM +0100, Keisuke Nishimura wrote:
> Hello Marc and Oliver,
> 
> Thank you for the replies.
> 
> On 28/11/2024 18:55, Oliver Upton wrote:
> > On Thu, Nov 28, 2024 at 02:45:34PM +0100, Keisuke Nishimura wrote:
> > > The xa_store() may fail because there is no guarantee that the cache_key
> > > index is already used in its->translation_cache. This fix (1) resolves
> > > the kref inconsistency on failure and (2) returns the error code.
> > 
> > xa_store() doesn't fail if an entry is already present at the specified
> > index. It returns the old entry, which is why we have a vgic_put_irq()
> > on the "error" path.
> 
> Sure. But to my understanding, this could be the first store to
> its->translation_cache with cache_key, and that is why old can be NULL? I am
> not very familiar with this code, so please correct me if I am wrong.

So we take a reference on @irq to represent the pointer to it that's
stored in the translation cache. There are 3 possible outcomes after the
store:

 - Store succeeds and no pre-existing entry.

 - Store succeeds and there's a pre-existing entry. put the reference on
   @old since it was evicted from the translation cache

 - Store fails because of a failed memory allocation / error in xarray
   library.

We don't handle #3, and the correct thing to do in this case is to put
@irq since it was never made visible in the translation cache.

So I think we'd want to do something similar to the following.

-- 
Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f4c4494645c3..fb96802799c6 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -608,12 +608,22 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
+	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
+
+	/*
+	 * Put the reference taken on @irq if the store fails. Intentionally do
+	 * not return the error as the translation cache is best effort.
+	 */
+	if (xa_is_err(old)) {
+		vgic_put_irq(kvm, irq);
+		return;
+	}
+
 	/*
 	 * We could have raced with another CPU caching the same
 	 * translation behind our back, ensure we don't leak a
 	 * reference if that is the case.
 	 */
-	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 	if (old)
 		vgic_put_irq(kvm, old);
 }
