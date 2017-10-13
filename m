From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] KVM: arm64: its: Fix missing dynamic allocation check
 in scan_its_table
Date: Fri, 13 Oct 2017 16:00:18 +0200
Message-ID: <20171013140018.2js6hwctwprunad3@kamzik.brq.redhat.com>
References: <20171013131734.16485-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171013131734.16485-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 13, 2017 at 03:17:34PM +0200, Christoffer Dall wrote:
> We currently allocate an entry dynamically, but we never check if the
> allocation actually succeeded.  We actually don't need a dynamic
> allocation, because we know the maximum size of an ITS table entry, so
> we can simply use an allocation on the stack.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f51c1e1..1d2668b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1801,37 +1801,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>  static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>  			  int start_id, entry_fn_t fn, void *opaque)
>  {
> -	void *entry = kzalloc(esz, GFP_KERNEL);
>  	struct kvm *kvm = its->dev->kvm;
>  	unsigned long len = size;
>  	int id = start_id;
>  	gpa_t gpa = base;
> +	char entry[esz]

Might want a semicolon here :-)

drew
