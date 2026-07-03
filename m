Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE14433E9B;
	Fri,  3 Jul 2026 22:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783116817; cv=none; b=tENWZlCGAsxwuWdokdINFmBaUpNJHIcG05cHnotrUda3ZrnlOz/gGf9BgdvAOSvqnmTm07pybD+hQ/0OC97SsjzJ8XdRK1pCV5a4lshv3VUPvmj8Hn7bkX/NNpoW/AQIuMhbIIYP/r5wz8zY/09WB/bczij3N6/oPULRsNRIHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783116817; c=relaxed/simple;
	bh=QxuAOEsERbQM3HJKcfRUWEnTRV+O532TXuxe2sDrtg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ais9rMzpIxuyGTFAcQ8DVuSvwsK0N4+4M1VgmC1qMto0PrTRojhb4tjKeCQUHVoiT2m7aFSnAVZd67Zw5T2+S2W565VIX47pu8qQYTCWhQf1KsuYQajVL1x5RTI5CCCc13DFD7NpKBZK5GibzEvd8IV6ZVZ/CuNs9a/9KQydQGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S88GP2AL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S88GP2AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0871F000E9;
	Fri,  3 Jul 2026 22:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783116816;
	bh=1zWq6d9o5oCGb91ldInP6TJuiRGBPDVvUdwGfjbWcn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S88GP2ALlLALevOAxjhC/nVg8Af4WWLOpceyxmu7ID76dWgbhfHOEZh09gQo9tzsn
	 cWBW5TXP+mmNFMdRPCofDEjDwdKDEtEk+rEh0L/241Z97cPEiC8ZOgcHlNf5MPJYH1
	 QV1LNChYQ3zON2ssUA6eLmMIRvA2vB6nSkC7k1DDSqEZ8HMg9hyN4nrZkc50WiDjlF
	 YPW0QDswGXCyeYjNv5RlrHejc/xlfCjRNOwDtpiT3FrzE9XEYt7cuxoQCkmCxRen3S
	 5uFs+LqS7NrfNy1EHPytjZ6BHxwWvU8rIoaaX9Ew/bqLXwEK590UG1Raop2dgDau6C
	 mVnsIQxo7rehA==
Date: Fri, 3 Jul 2026 15:13:34 -0700
From: Oliver Upton <oupton@kernel.org>
To: Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, maz@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] KVM: arm64: vgic: Fix race between LPI release
 and re-registration
Message-ID: <akg0DgQvu4lsESCG@kernel.org>
References: <20260703122601.2617577-2-clopez@suse.de>
 <20260703122601.2617577-3-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703122601.2617577-3-clopez@suse.de>

Hi Carlos,

Please wait a few days between spins, we were in the middle of a
conversation and I didn't have a chance to reply to you since yesterday.

On Fri, Jul 03, 2026 at 02:26:00PM +0200, Carlos López wrote:
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 67d107e9a77d..577286069368 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  		kfree(irq);
>  		irq = oldirq;
>  	} else {
> -		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> +		/*
> +		 * The entry is either empty or contains a dead LPI (refcount=0)
> +		 * from the deferred release path, pending cleanup by
> +		 * vgic_release_deleted_lpis(). Evict and free it if present.
> +		 */
> +		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		ret = xa_err(oldirq);
> +		if (!ret && oldirq)
> +			kfree_rcu(oldirq, rcu);

We need to assert the assumption here that the evicted IRQ has a nonzero
refcount and is pending release. Otherwise I feel like possibly leaking
memory is better than potentially introducing a UAF.

Untested diff below.

Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 4477f870c7b3..621a83399184 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -116,18 +116,28 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		kfree(irq);
 		irq = oldirq;
 	} else {
-		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		ret = xa_err(oldirq);
+		if (ret) {
+			xa_unlock_irqrestore(&dist->lpi_xa, flags);
+			kfree(irq);
 
-	if (ret) {
-		xa_release(&dist->lpi_xa, intid);
-		kfree(irq);
+			return ERR_PTR(ret);
+		}
 
-		return ERR_PTR(ret);
+		/*
+		 * The expectation is that only LPIs which are pending release
+		 * could possibly be evicted by storing the new entry. Free the
+		 * old IRQ only if this is the case, as otherwise someone else
+		 * could still hold a pointer on the outgoing IRQ.
+		 */
+		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount) &&
+					    oldirq->pending_release))
+			kfree_rcu(oldirq, rcu);
 	}
 
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in

