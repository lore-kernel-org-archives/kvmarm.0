From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Remove VLA usage
Date: Mon, 2 Jul 2018 09:36:44 +0200
Message-ID: <19f9ddb1-6009-850c-1949-3a8cdacdd2fc@redhat.com>
References: <20180629184618.GA37364@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180629184618.GA37364@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Kees,

On 06/29/2018 08:46 PM, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> switches to using a maximum size and adds sanity checks. Additionally
> cleans up some of the int-vs-u32 usage and adds additional bounds checking.
> As it currently stands, this will always be 8 bytes until the ABI changes.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 4ed79c939fb4..3143fc047fcf 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -168,8 +168,14 @@ struct vgic_its_abi {
>  	int (*commit)(struct vgic_its *its);
>  };
>  
> +#define ABI_0_ESZ	8
> +#define ESZ_MAX		ABI_0_ESZ
> +
>  static const struct vgic_its_abi its_table_abi_versions[] = {
> -	[0] = {.cte_esz = 8, .dte_esz = 8, .ite_esz = 8,
> +	[0] = {
> +	 .cte_esz = ABI_0_ESZ,
> +	 .dte_esz = ABI_0_ESZ,
> +	 .ite_esz = ABI_0_ESZ,
>  	 .save_tables = vgic_its_save_tables_v0,
>  	 .restore_tables = vgic_its_restore_tables_v0,
>  	 .commit = vgic_its_commit_v0,
> @@ -180,10 +186,12 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
>  
>  inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>  {
> +	if (WARN_ON(its->abi_rev >= NR_ITS_ABIS))
> +		return NULL;
>  	return &its_table_abi_versions[its->abi_rev];
>  }
>  
> -int vgic_its_set_abi(struct vgic_its *its, int rev)
> +static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
>  {
if vgic_its_get_abi is likely to return NULL, don't we need to check abi
!= NULL in all call sites.

abi_rev is actually set by vgic_its_set_abi() which is actually called
by vgic_mmio_uaccess_write_its_iidr() and vgic_its_create().

Only vgic_mmio_uaccess_write_its_iidr allows the userspace to overwrite
the default abi_rev. At this point a check against NR_ITS_ABIS is
already done. So to me the check is done at the source?

Thanks

Eric
>  	const struct vgic_its_abi *abi;
>  
> @@ -1881,16 +1889,19 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>   * Return: < 0 on error, 0 if last element was identified, 1 otherwise
>   * (the last element may not be found on second level tables)
>   */
> -static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
> +static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>  			  int start_id, entry_fn_t fn, void *opaque)
>  {
>  	struct kvm *kvm = its->dev->kvm;
>  	unsigned long len = size;
>  	int id = start_id;
>  	gpa_t gpa = base;
> -	char entry[esz];
> +	char entry[ESZ_MAX];
>  	int ret;
>  
> +	if (WARN_ON(esz > ESZ_MAX))
> +		return -EINVAL;
> +
>  	memset(entry, 0, esz);
>  
>  	while (len > 0) {
> 
