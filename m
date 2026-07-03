Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F18377EB8;
	Fri,  3 Jul 2026 08:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068271; cv=none; b=PhautWoXz62oJy+nNZIQbRrKVR3rTR0Yqj+7hcSt2BQlMQhVtOhZoDo74njKxSi2WRd9UlwooAtNmQLiKOa6aMAv6zxmO0CnBg+eR2oKL0ikurijphcHX28lvFpWLViz9KrCn14AfUMDd9wdwZJpu1had2qb1jVtogVs9G/lPBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068271; c=relaxed/simple;
	bh=oTR0QYp0D6kx27vJQf+ZQQaSYN71KVPnmD4RUS8AJmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kh8o0VhZrM2Rgk2Bi85QriofkFQLM87T2mUG+NrCN1d3ryrDGgyI0ZO3KMLhMtiQSQWt2ln8VZnqT/0/hdgn4JFdHSE5vShVeTZ0n4EscZQCJRKW8mu9FrwBERf7kmQAhM2aJGmghz1h/Wju0DMe4kx5LOJaVcMCmNQgbMFQd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsfpiLy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsfpiLy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8679B1F000E9;
	Fri,  3 Jul 2026 08:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783068269;
	bh=Xbiv26FHbfLf0wVsvdHwVvR9Wk+crDjoJ+R6NvqGcgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SsfpiLy9yFYoaVhOKrn3YF4pqDQ6u3afASgqNCHEaDaoz8Bs8/vPhCPQL26k/4z9Y
	 8YQufP6hG5gyCyWEHKO1cyrMbelALLjg+mUkS2Sncr9TeEq0cMcSYxaPDirWrUNfq9
	 Usftl62Kgewx0Cr3QRURS0OOcksnaI/A1kKkv1OaIzqJDBC9TBACAAsW/c6haJxd6n
	 L28DgRLNKneBBViOw7tpWdFb0LM0v1RfqPpFaQ5fnu0/Cwf+01ZphnInFCIeXpI1pP
	 H89s8f8qSa6xy0o10kHlUwaifghXpuSx+9F17r6mZqZAscnOhPBlCIIlZrTch1V9R9
	 cqtbIAy04/tuQ==
Date: Fri, 3 Jul 2026 01:44:28 -0700
From: Oliver Upton <oupton@kernel.org>
To: Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] KVM: arm64: vgic: Fix race between LPI release and
 re-registration
Message-ID: <akd2bIjF34e3m6TQ@kernel.org>
References: <20260703021508.2593100-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703021508.2593100-2-clopez@suse.de>

Hi Carlos,

Thanks for reporting this ugly bug.

On Fri, Jul 03, 2026 at 04:15:08AM +0200, Carlos López wrote:
> To fix the direct release path, move the reference count drop inside
> the xarray lock, making sure that vgic_add_lpi() never encounters the
> to-be-released LPI.

As Sashiko pointed out, this is going to massively regress performance
of LPI injection. I don't think this is going to be a viable option.

> To fix the deferred release path, since the refcount drop must happen
> under a raw spinlock, the same solution does not work. Instead, update
> vgic_add_lpi(), so that if it evicts a non-NULL refcount=0 LPI from the
> xarray, it takes on the responsibility of releasing it. If this happens,
> vgic_release_deleted_lpis() will iterate the xarray normally and will
> simply not find the already released structure.
> 
> Reported-by: Claude:claude-opus-4-6
> Fixes: 3a08a6ca7c37 ("KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs")
> Fixes: d54594accf73 ("KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks")
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
> v2:
> * Address Sashiko's review. Fix the direct release path by decrementing the
>   refcount under the xarray spinlock, preventing a UAF that would have been
>   introduced in v1.

So I actually agree with your approach in v1, vgic_release_lpi_locked()
should do an __xa_cmpxchg() to only erase if the to-be-deleted IRQ that
it owns remains in the xarray.

I believe the UAF could've been avoided by unconditionally calling
kfree_rcu() in vgic_release_lpi_locked() and not attempting to cleanup
dead LPIs in vgic_add_lpi(). IOW, whoever takes the refcount of an LPI
to 0 always has the responsibility of freeing it.

Maybe below would be enough?

Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5a4768d8cd4f..4c79e1096af4 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -132,7 +132,14 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq)
 {
 	lockdep_assert_held(&dist->lpi_xa.xa_lock);
-	__xa_erase(&dist->lpi_xa, irq->intid);
+
+	/*
+	 * Another LPI could've been inserted prior to taking the xa_lock, as
+	 * vgic_add_lpi() can only take a reference on a pre-existing LPI if
+	 * the refcount is nonzero. While freeing the object is always done here,
+	 * only delete the entry @INTID if it is this IRQ.
+	 */
+	__xa_cmpxchg(&dist->lpi_xa, irq->intid, irq, NULL, 0);
 	kfree_rcu(irq, rcu);
 }
 
