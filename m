From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 7/9] KVM: arm/arm64: vgic-its: Free caches when
 GITS_BASER Valid bit is cleared
Date: Mon, 30 Oct 2017 07:05:19 +0100
Message-ID: <20171030060519.GI2166@lvm>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-8-git-send-email-eric.auger@redhat.com>
 <86efpl725h.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE042406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:03:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q6qHJ52Quq2l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 02:03:57 -0400 (EDT)
Received: from mail-lf0-f67.google.com (mail-lf0-f67.google.com
 [209.85.215.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 377F940651
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:03:57 -0400 (EDT)
Received: by mail-lf0-f67.google.com with SMTP id e143so1455981lfg.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:05:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <86efpl725h.fsf@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 30, 2017 at 03:19:54AM +0000, Marc Zyngier wrote:
> On Thu, Oct 26 2017 at  6:23:09 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> > When the GITS_BASER<n>.Valid gets cleared, the data structures in
> > guest RAM are not valid anymore. The device, collection
> > and LPI lists stored in the in-kernel ITS represent the same
> > information in some form of cache. So let's void the cache.
> >
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >
> > ---
> > v5 -> v6:
> > - rename type into device_type and revert tthe u64 -> int change
> > - remove the default clause
> > - take the its mutex lock around vgic_its_free_device/collection_list
> >
> > v4 -> v5:
> > - add comment about locking
> >
> > v2 -> v3:
> > - add a comment and clear cache in if block
> > ---
> >  virt/kvm/arm/vgic/vgic-its.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> >
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index 5b7be85..2a92d4d 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -1428,7 +1428,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
> >  				      unsigned long val)
> >  {
> >  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > -	u64 entry_size, device_type;
> > +	u64 entry_size, table_type;
> >  	u64 reg, *regptr, clearbits = 0;
> >  
> >  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
> > @@ -1439,12 +1439,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
> >  	case 0:
> >  		regptr = &its->baser_device_table;
> >  		entry_size = abi->dte_esz;
> > -		device_type = GITS_BASER_TYPE_DEVICE;
> > +		table_type = GITS_BASER_TYPE_DEVICE;
> >  		break;
> >  	case 1:
> >  		regptr = &its->baser_coll_table;
> >  		entry_size = abi->cte_esz;
> > -		device_type = GITS_BASER_TYPE_COLLECTION;
> > +		table_type = GITS_BASER_TYPE_COLLECTION;
> >  		clearbits = GITS_BASER_INDIRECT;
> >  		break;
> >  	default:
> > @@ -1456,10 +1456,28 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
> >  	reg &= ~clearbits;
> >  
> >  	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
> > -	reg |= device_type << GITS_BASER_TYPE_SHIFT;
> > +	reg |= table_type << GITS_BASER_TYPE_SHIFT;
> >  	reg = vgic_sanitise_its_baser(reg);
> >  
> >  	*regptr = reg;
> > +
> > +	/*
> > +	 * If the table is no longer valid, we clear the associated cached data.
> > +	 * Note: there cannot be any race with save/restore code which locks
> > +	 * all vcpus.
> > +	 */
> 
> nit: I found this comment to be pretty confusing, as it talks about
> locks that we don't try to take here. The actual mutual exclusion is
> done by taking the its_lock, which is also taken on the save/restore
> path.
> 
> Christoffer: can you fix that when applying this patch? I don't think
> there is a need for a respin of the series just for this.
> 

Yes, no problem.

> > +	if (!(reg & GITS_BASER_VALID)) {
> > +		mutex_lock(&its->its_lock);
> > +		switch (table_type) {
> > +		case GITS_BASER_TYPE_DEVICE:
> > +			vgic_its_free_device_list(kvm, its);
> > +			break;
> > +		case GITS_BASER_TYPE_COLLECTION:
> > +			vgic_its_free_collection_list(kvm, its);
> > +			break;
> > +		}
> > +		mutex_unlock(&its->its_lock);
> > +	}
> >  }
> >  
> >  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
> 
> Otherwise:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Also,

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
