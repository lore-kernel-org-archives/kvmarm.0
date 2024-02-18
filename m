Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E8E57E
	for <kvmarm@lists.linux.dev>; Sun, 18 Feb 2024 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708279548; cv=none; b=dCKRyX2OPtYmNYKQQVXnAVfy9TIWGYlVrnmQPrfrNDzzoBGYElt405npByeTsky6NfIBcpKTmiUfP09FT5CF01RTe/T4UYczMSf34rLtk+mdVSIvY680af7wTTm9yU5eRVqBmo5qId09+g6SEt0+9unH68czV4F8d8bOiWUzUc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708279548; c=relaxed/simple;
	bh=vWVIcKnpvzocSjV2NV3m3GpLSmyp7ylR5NPlCRCJaZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTpqyvD2udyBn0hYjcTax3kTbScB6RZIIjTgbckQ/v3aBtJ9n3OhywKsZXhQn8D/Ydg7NhfgKmH3g+hFY3f5OKs5tt/XJ27QcbKpANQKCqSl2ZBRKstKGrAjXykwmt5G9NfoZbPEe6OsWyciGCnbVYYbmgNTOQSiD01TO+oeuww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xs7qHF3e; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xs7qHF3e"
Date: Sun, 18 Feb 2024 10:05:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708279543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+NFOvyN6tcyqft/QfMQHusxypN7esItJ9glpfGKgmoY=;
	b=xs7qHF3exFPWwEGGZCKaakY0hjM+4cJ+uaKTQw5SkevF4h4GyYFP2wyvW5KmX1YzN8yq+b
	MKzjBUabBpGzC60uFsdnSptqMXgR3OGjle0P1LR2IQAbvdoMyoUHmxpG2tWXdkgxxaeikN
	zhNDYy7z2s0dz7qt1IKRUMEJv0DzjHg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/10] KVM: arm64: vgic-its: Walk the LPI xarray in
 vgic_copy_lpi_list()
Message-ID: <ZdJG8W-TLW8I6O07@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-5-oliver.upton@linux.dev>
 <beca07ad-833e-ca68-2fe7-a30a2cb9faef@huawei.com>
 <86frxq3w3g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frxq3w3g.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 18, 2024 at 10:28:19AM +0000, Marc Zyngier wrote:
> On Sun, 18 Feb 2024 08:46:53 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> > 
> > On 2024/2/17 2:41, Oliver Upton wrote:
> > > Start iterating the LPI xarray in anticipation of removing the LPI
> > > linked-list.
> > > 
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-its.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > > index fb2d3c356984..9ce2edfadd11 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > > @@ -335,6 +335,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> > >  int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
> > >  {
> > >  	struct vgic_dist *dist = &kvm->arch.vgic;
> > > +	XA_STATE(xas, &dist->lpi_xa, GIC_LPI_OFFSET);
> > >  	struct vgic_irq *irq;
> > >  	unsigned long flags;
> > >  	u32 *intids;
> > > @@ -353,7 +354,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
> > >  		return -ENOMEM;
> > >   	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> > > -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> > > +	rcu_read_lock();
> > > +
> > > +	xas_for_each(&xas, irq, INTERRUPT_ID_BITS_ITS) {
> > 
> > We should use '1 << INTERRUPT_ID_BITS_ITS - 1' to represent the maximum
> > LPI interrupt ID.

/facepalm

Thanks Zenghui!

> Huh, well caught! I'm not even sure how it works, as that's way
> smaller than the start of the walk (8192). Probably doesn't.
> 
> An alternative would be to use max_lpis_propbaser(), but I'm not sure
> we always have a valid PROPBASER value set when we start using this
> function. Worth investigating though.

Given the plans to eventually replace this with xarray marks, I'd vote
for doing the lazy thing and deciding this at compile time.

I can squash this in when I apply the series if the rest of it isn't
offensive, otherwise respin with the change.

-- 
Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index d84cb7618c59..f6025886071c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -316,6 +316,8 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	return 0;
 }
 
+#define GIC_LPI_MAX_INTID	((1 << INTERRUPT_ID_BITS_ITS) - 1)
+
 /*
  * Create a snapshot of the current LPIs targeting @vcpu, so that we can
  * enumerate those LPIs without holding any lock.
@@ -345,7 +347,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	rcu_read_lock();
 
-	xas_for_each(&xas, irq, INTERRUPT_ID_BITS_ITS) {
+	xas_for_each(&xas, irq, GIC_LPI_MAX_INTID) {
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
