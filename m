From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 17/22] KVM: arm64: vgic-its: Collection table
 save/restore
Date: Fri, 28 Apr 2017 19:42:50 +0200
Message-ID: <20170428174250.GA31666@cbox>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-18-git-send-email-eric.auger@redhat.com>
 <20170428104448.GB1439@lvm>
 <e866c4bd-8ec5-9cac-fa43-aa442b1d2dac@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e866c4bd-8ec5-9cac-fa43-aa442b1d2dac@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 28, 2017 at 01:05:15PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 28/04/2017 12:44, Christoffer Dall wrote:
> > On Fri, Apr 14, 2017 at 12:15:29PM +0200, Eric Auger wrote:
> >> The save path copies the collection entries into guest RAM
> >> at the GPA specified in the BASER register. This obviously
> >> requires the BASER to be set. The last written element is a
> >> dummy collection table entry.
> >>
> >> We do not index by collection ID as the collection entry
> >> can fit into 8 bytes while containing the collection ID.
> >>
> >> On restore path we re-allocate the collection objects.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v4 -> v5:
> >> - add macros for field encoding/decoding
> >> - use abi->cte_esz
> >> - rename flush into save
> >> - check the target_addr is valid
> >>
> >> v3 -> v4:
> >> - replaced u64 *ptr by gpa_t gpa
> >> - check the collection does not exist before allocating it
> >>
> >> v1 -> v2:
> >> - reword commit message and directly use 8 as entry size
> >> - no kvm parameter anymore
> >> - add helper for flush/restore cte
> >> - table size computed here
> >> - add le64/cpu conversions
> >> ---
> >>  virt/kvm/arm/vgic/vgic-its.c | 109 ++++++++++++++++++++++++++++++++++++++++++-
> >>  virt/kvm/arm/vgic/vgic.h     |   9 ++++
> >>  2 files changed, 116 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index c22b35d..484e541 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -1785,13 +1785,97 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
> >>  	return -ENXIO;
> >>  }
> >>  
> >> +static int vgic_its_save_cte(struct vgic_its *its,
> >> +			     struct its_collection *collection,
> >> +			     gpa_t gpa, int esz)
> >> +{
> >> +	u64 val;
> >> +	int ret;
> >> +
> >> +	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
> >> +	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
> >> +	       collection->collection_id);
> >> +	val = cpu_to_le64(val);
> >> +	ret = kvm_write_guest(its->dev->kvm, gpa, &val, esz);
> >> +	return ret;
> >> +}
> >> +
> >> +static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa,
> >> +				int esz, bool *valid)
> >> +{
> >> +	struct its_collection *collection;
> >> +	struct kvm *kvm = its->dev->kvm;
> >> +	u32 target_addr;
> >> +	u32 coll_id;
> >> +	u64 val;
> >> +	int ret;
> >> +
> >> +	*valid = false;
> > 
> > I don't see why you need this.
> I initialized it here in case kvm_read_guest() fails

If the caller looks at the valid setting when it receives an error code,
that's really weird.

> > 
> >> +
> >> +	ret = kvm_read_guest(kvm, gpa, &val, esz);
> > 
> > hmm, we better not have an esz larger than sizeof(u64) here then.
> Yes this could be part if the ABI ops but is that worth the effort now?
> I can add a comment somewhere to mention that trap.

I wasn't really sure what we should do here, but I think we should add
BUG_ON(esz > sizeof(val)) when going over this again.

Thanks,
-Christoffer
