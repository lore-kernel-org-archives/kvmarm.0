From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: ITS: avoid re-mapping LPIs
Date: Wed, 17 Aug 2016 10:59:07 +0200
Message-ID: <20160817085907.GC8808@cbox>
References: <20160816165106.25057-1-andre.przywara@arm.com>
 <20160816173038.GF14088@cbox>
 <a291bbd7-d8b4-2841-669b-721985eab81b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4C8410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:49:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E8oiY5FKQR8x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 04:49:40 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D832F40F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:49:39 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id f65so184853102wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 01:57:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <a291bbd7-d8b4-2841-669b-721985eab81b@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 17, 2016 at 12:45:17AM +0100, Andr=E9 Przywara wrote:
> On 16/08/16 18:30, Christoffer Dall wrote:
> > On Tue, Aug 16, 2016 at 05:51:06PM +0100, Andre Przywara wrote:
> >> When a guest wants to map a device-ID/event-ID combination that is
> >> already mapped, we may end up in a situation where an LPI is never
> >> "put", thus never being freed.
> >> Since the GICv3 spec says that mapping an already mapped LPI is
> >> UNPREDICTABLE, lets just bail out early in this situation to avoid
> >> any potential leaks.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++--------------
> >>  1 file changed, 13 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its=
.c
> >> index 9533080..4660a7d 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -731,7 +731,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kv=
m, struct vgic_its *its,
> >>  	u32 device_id =3D its_cmd_get_deviceid(its_cmd);
> >>  	u32 event_id =3D its_cmd_get_id(its_cmd);
> >>  	u32 coll_id =3D its_cmd_get_collection(its_cmd);
> >> -	struct its_itte *itte, *new_itte =3D NULL;
> >> +	struct its_itte *itte;
> >>  	struct its_device *device;
> >>  	struct its_collection *collection, *new_coll =3D NULL;
> >>  	int lpi_nr;
> >> @@ -749,6 +749,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *k=
vm, struct vgic_its *its,
> >>  	    lpi_nr >=3D max_lpis_propbaser(kvm->arch.vgic.propbaser))
> >>  		return E_ITS_MAPTI_PHYSICALID_OOR;
> >>  =

> >> +	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
> >> +	if (find_itte(its, device_id, event_id))
> >> +		return 0;
> >> +
> > =

> > By the way, this made me think how these errors are handled, and unless
> > I'm mistaken, the return value from vgic_its_handle_command() is simply
> > discarded, so even when we return things like -ENOMEM, this is just
> > ignored?  Is this really the intention?
> =

> Yes, at least at the moment. The spec does not specify how ITS errors
> should be communicated (IMPLEMENTATION DEFINED), only that an error
> condition itself can be signaled via an SError - for which atm we lack
> any code to inject, if I am not mistaken.
> Still I wanted to assign those error codes: IMHO it improves readability
> and simplifies any later extension in that respect.

It's fine to return error codes, but at the very least we should have a
comment saying "We throw away all errors because we cannot handle them
and this is always fine to do, because of X".

> =

> For the Linux errors (like -ENOMEM): Due to the asynchronous nature of
> the ITS command handling and also the guest triggering the commands,
> there is really no better way to report those OoM conditions, for
> instance, so I treated them the same as "proper" ITS errors.

I feel like a -ENOMEM should be reported back to userspace so we can
give up on our giant resource hogging VM instead of just grinding on.

Isn't this all done as part of a MMIO write, so you can return the error
from that thing?

If you were running this in a separate thread, it would be an entirely
more difficult matter.

Thanks,
-Christoffer
