From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 16/22] KVM: arm64: vgic-its: Add infrastructure for
 table lookup
Date: Wed, 3 May 2017 16:38:26 +0200
Message-ID: <20170503143826.GA28421@cbox>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-17-git-send-email-eric.auger@redhat.com>
 <20170430193325.GA1670@lvm>
 <8f162a7d-e629-5828-6230-f0b7b7a6f9db@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8f162a7d-e629-5828-6230-f0b7b7a6f9db@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 03:40:34PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 30/04/2017 21:33, Christoffer Dall wrote:
> > On Fri, Apr 14, 2017 at 12:15:28PM +0200, Eric Auger wrote:
> >> Add a generic lookup_table() helper whose role consists in
> >> scanning a contiguous table located in guest RAM and applying
> >> a callback on each entry. Entries can be handled as linked lists
> >> since the callback may return an offset to the next entry and
> >> also tell that an entry is the last one.
> >>
> >> Helper functions also are added to compute the device/event ID
> >> offset to the next DTE/ITE.
> >>
> >> compute_next_devid_offset, compute_next_eventid_offset and
> >> lookup_table will become static in subsequent patches
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v4 -> v5:
> >> - use kvm_read_guest
> >>
> >> v3 -> v4:
> >> - remove static to avoid compilation warning
> >> - correct size computation in looup_table()
> >> - defines now encode the number of bits used for devid and eventid offsets
> >> - use BIT() - 1 to encode the max offets
> >> ---
> >>  virt/kvm/arm/vgic/vgic-its.c | 93 ++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 93 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 56c5123..c22b35d 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -195,6 +195,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
> >>  
> >>  #define VITS_TYPER_IDBITS 16
> >>  #define VITS_TYPER_DEVBITS 16
> >> +#define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
> >> +#define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
> >>  
> >>  /*
> >>   * Finds and returns a collection in the ITS collection table.
> >> @@ -1674,6 +1676,97 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
> >>  	return ret;
> >>  }
> >>  
> >> +u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
> >> +{
> >> +	struct list_head *e = &dev->dev_list;
> >> +	struct its_device *next;
> >> +	u32 next_offset;
> >> +
> >> +	if (e->next == h)
> >> +		return 0;
> >> +	next = list_entry(e->next, struct its_device, dev_list);
> >> +	next_offset = next->device_id - dev->device_id;
> >> +
> >> +	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
> >> +}
> >> +
> >> +u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
> >> +{
> >> +	struct list_head *e = &ite->ite_list;
> >> +	struct its_ite *next;
> >> +	u32 next_offset;
> >> +
> >> +	if (e->next == h)
> >> +		return 0;
> >> +	next = list_entry(e->next, struct its_ite, ite_list);
> >> +	next_offset = next->event_id - ite->event_id;
> >> +
> >> +	return min_t(u32, next_offset, VITS_ITE_MAX_EVENTID_OFFSET);
> >> +}
> >> +
> >> +/**
> >> + * entry_fn_t - Callback called on a table entry restore path
> >> + * @its: its handle
> >> + * @id: id of the entry
> >> + * @entry: pointer to the entry
> >> + * @opaque: pointer to an opaque data
> >> + * @next_offset: minimal ID offset to the next entry. 0 if this
> >> + * entry is the last one, 1 if the entry is invalid, >= 1 if an
> >> + * entry's next_offset field was truly decoded
> >> + *
> >> + * Return: < 0 on error, 0 otherwise
> >> + */
> >> +typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
> >> +			  void *opaque, u32 *next_offset);
> > 
> > Just noticed.  All the table entries are 64-bit long at this point,
> > right?  So why not make entry a u64 * instead?  Could we end up with
> > some endianness mess with using void pointers the way it is now?
> the size of the entry is ABI dependent while this infrastructure is
> generic. 

Yes, for a single version of the ABI where all the entries are 64-bit.


> In each of such function we use
> 
> u64 entry = *(u64 *)addr;
> and we do a le64_to_cpu(entry).
> 
> Do you see something wrong? Otherwise I would be tempted to leave as is.
> 

I don't think there's anything wrong with the current version, and
you're right, this always points to an ITS data structure which is LE,
so there shouldn't be a problem.  I always just quiver when I see void
pointers cast to a type in the caller and callee.

Just leave it for now.

Thanks,
-Christoffer
