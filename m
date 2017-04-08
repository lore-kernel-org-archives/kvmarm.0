From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 11/22] KVM: arm64: ITS: Interpret MAPD ITT_addr field
Date: Sat, 08 Apr 2017 19:58:54 +0100
Message-ID: <86lgrabua9.fsf@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
        <1490607072-21610-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-12-git-send-email-eric.auger@redhat.com> (Eric
        Auger's message of "Mon, 27 Mar 2017 11:31:01 +0200")
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27 2017 at 10:31:01 AM, Eric Auger <eric.auger@redhat.com> wrote:
> Up to now the MAPD ITT_addr had been ignored. We will need it
> for save/restore. Let's record it in the its_device struct.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
>
> v3 -> v4:
> - in vgic_its_cmd_handle_mapd, itt_addr directly is shifted
> - correct ittaddr bitmask to support 48bit GPA
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index ddd2780..89a0db7 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -103,6 +103,7 @@ struct its_device {
>  	/* the head for the list of ITTEs */
>  	struct list_head itt_head;
>  	u32 nb_eventid_bits;
> +	gpa_t itt_addr;
>  	u32 device_id;
>  };
>  
> @@ -553,6 +554,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
>  #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
>  #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
>  #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
> +#define its_cmd_get_ittaddr(cmd)	its_cmd_mask_field(cmd, 2,  8, 47)
>  #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
>  #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
>  
> @@ -824,6 +826,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>  	bool valid = its_cmd_get_validbit(its_cmd);
>  	u8 nb_eventid_bits = its_cmd_get_size(its_cmd) + 1;
> +	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd) << 8;

Same remark as previously. I'd rather have the macro returning something
that is directly useful rather than having to shift afterwards.

>  	struct its_device *device;
>  
>  	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
> @@ -855,6 +858,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  
>  	device->device_id = device_id;
>  	device->nb_eventid_bits = nb_eventid_bits;
> +	device->itt_addr = itt_addr;
>  
>  	INIT_LIST_HEAD(&device->itt_head);

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
