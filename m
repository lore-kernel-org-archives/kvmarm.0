From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 16/22] KVM: arm64: vgic-its: Add infrastructure for
 table lookup
Date: Wed, 3 May 2017 10:01:58 +0200
Message-ID: <20170503080158.GA8452@cbox>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-17-git-send-email-eric.auger@redhat.com>
 <20170430193555.GB1670@lvm>
 <303f2981-489e-ec38-ebaf-40d65429d820@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <303f2981-489e-ec38-ebaf-40d65429d820@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 08:53:36AM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 30/04/2017 21:35, Christoffer Dall wrote:
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
> > 
> > eh, also, did you mean -1 if the entry is invalid?
> no in case the entry is invalid, we tell the caller that it must inspect
> the next entry, hence the next_offset = +1.

hmm, but you say aftterwards that >= 1 if an entry's next_offset field
was truly decoded, so this is confusing.  Perhaps it would make more
sense to get rid of the parameter entirely and change the return value
to say:

  Return: < 0 on error, 0 if the entry was the last one, and > 0 to
          indicate the offset to the next entry that must be processed
	  when scanning a table.

  Note that we return 1 for an invalid entry, because scanning a table
  in this case simply requires us looking at the next entry, but we may
  return >= to 1 if we found a valid entry and decoded the next field in
  the entry.

What do you think?

Thanks,
-Christoffer
