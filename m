From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm/arm64: GICv2 IGROUPR should read as zero
Date: Mon, 25 Jun 2018 10:59:32 +0100
Message-ID: <1ba85182-ff8e-195f-d7c3-ad14826e95a3@arm.com>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <20180624221103.15055-2-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180624221103.15055-2-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/06/18 23:11, Christoffer Dall wrote:
> We currently don't support grouping in the emulated VGIC, which is a
> known defect on KVM (not hurting any currently used guests as far as
> we're aware). This is currently handled by treating all interrupts as
> group 0 interrupts for an emulated GICv2 and always signaling interrupts
> as group 0 to the virtual CPU interface.
>
> However, when reading which group interrupts belongs to in the guest
> from the emulated VGIC, the VGIC currently reports group 1 instead of
> group 0, which is misleading.  Fix this temporarily before introducing
> full group support by changing the hander to _raz instead of _rao.
>
> Fixes: fb848db39661a "KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework"
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index ffc587bf4742..8d18f89397d3 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -362,7 +362,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>               vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
>               VGIC_ACCESS_32bit),
>       REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
> -             vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
> +             vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
>               VGIC_ACCESS_32bit),
>       REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
>               vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
>
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
