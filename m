From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 12/24] KVM: arm64: vgic-its: Interpret MAPD ITT_addr
 field
Date: Thu, 4 May 2017 19:16:27 +0200
Message-ID: <20170504171627.GW5923@cbox>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-13-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493898284-29504-13-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:32PM +0200, Eric Auger wrote:
> Up to now the MAPD ITT_addr had been ignored. We will need it
> for save/restore. Let's record it in the its_device struct.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
> v5 -> v6:
> - fix its_cmd_get_ittaddr and pass 44 to its_cmd_mask_field
> 
> v4 -> v5:
> - its_cmd_get_ittaddr macro now returns the actual ITT GPA
> 
> v3 -> v4:
> - in vgic_its_cmd_handle_mapd, itt_addr directly is shifted
> - correct ittaddr bitmask to support 48bit GPA
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 06e01d1..6da548d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -106,6 +106,7 @@ struct its_device {
>  	/* the head for the list of ITTEs */
>  	struct list_head itt_head;
>  	u32 num_eventid_bits;
> +	gpa_t itt_addr;
>  	u32 device_id;
>  };
>  
> @@ -576,6 +577,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
>  #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
>  #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
>  #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
> +#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 44) << 8)
>  #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
>  #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
>  
> @@ -847,6 +849,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>  	bool valid = its_cmd_get_validbit(its_cmd);
>  	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
> +	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>  	struct its_device *device;
>  
>  	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
> @@ -878,6 +881,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  
>  	device->device_id = device_id;
>  	device->num_eventid_bits = num_eventid_bits;
> +	device->itt_addr = itt_addr;
>  
>  	INIT_LIST_HEAD(&device->itt_head);
>  
> -- 
> 2.5.5
> 
