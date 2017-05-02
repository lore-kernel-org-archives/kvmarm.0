From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 18/22] KVM: arm64: vgic-its: vgic_its_check_id returns
 the entry's GPA
Date: Tue, 2 May 2017 10:29:28 +0200
Message-ID: <CAMJs5B9T0WFDTnBhkv9aFF-p=uG1wNLBHN6oagpEJ9G_MufOZg@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-19-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B9D40992
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 04:26:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BZQHv26MNV+C for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 May 2017 04:26:27 -0400 (EDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com
 [209.85.161.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 492F840966
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 04:26:27 -0400 (EDT)
Received: by mail-yw0-f180.google.com with SMTP id u70so65538678ywe.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 May 2017 01:29:29 -0700 (PDT)
In-Reply-To: <1492164934-988-19-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Juan Quintela <quintela@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:30PM +0200, Eric Auger wrote:
> As vgic_its_check_id() computes the device/collection entry's
> GPA, let's return it so that new callers can retrieve it easily.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
> v3 -> v4:
> - check eaddr is not NULL to allow passing NULL eaddr parameter
>   to vgic_its_check_id
>
> v2: new
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 484e541..35b2ca1 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -645,7 +645,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>   * is actually valid (covered by a memslot and guest accessible).
>   * For this we have to read the respective first level entry.
>   */
> -static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
> +static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> +      gpa_t *eaddr)
>  {
>   int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
>   int index;
> @@ -665,6 +666,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
>   addr = BASER_ADDRESS(baser) + id * esz;
>   gfn = addr >> PAGE_SHIFT;
>
> + if (eaddr)
> + *eaddr = addr;
>   return kvm_is_visible_gfn(its->dev->kvm, gfn);
>   }
>
> @@ -697,6 +700,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
>   indirect_ptr += index * esz;
>   gfn = indirect_ptr >> PAGE_SHIFT;
>
> + if (eaddr)
> + *eaddr = indirect_ptr;
>   return kvm_is_visible_gfn(its->dev->kvm, gfn);
>  }
>
> @@ -706,7 +711,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  {
>   struct its_collection *collection;
>
> - if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
> + if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
>   return E_ITS_MAPC_COLLECTION_OOR;
>
>   collection = kzalloc(sizeof(*collection), GFP_KERNEL);
> @@ -889,7 +894,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>   gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>   struct its_device *device;
>
> - if (!vgic_its_check_id(its, its->baser_device_table, device_id))
> + if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
>   return E_ITS_MAPD_DEVICE_OOR;
>
>   if (valid && nb_eventid_bits > VITS_TYPER_IDBITS)
> --
> 2.5.5
>
