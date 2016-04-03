From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 04/12] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Sun, 3 Apr 2016 12:08:45 +0200
Message-ID: <20160403100845.GE5261@cbox>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-5-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 231314053F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2016 06:07:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DIiA38KR2sCl for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2016 06:07:28 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1213A400E9
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2016 06:07:27 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id c62so129481087lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2016 03:08:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458958450-19662-5-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 26, 2016 at 02:14:02AM +0000, Andre Przywara wrote:
> In the GICv3 redistributor there are the PENDBASER and PROPBASER
> registers which we did not emulate so far, as they only make sense
> when having an ITS. In preparation for that emulate those MMIO
> accesses by storing the 64-bit data written into it into a variable
> which we later read in the ITS emulation.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h       |  8 ++++++++
>  virt/kvm/arm/vgic/vgic_mmio.c | 26 ++++++++++++++++++++++----
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 11344e6..8ea5dd7 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -145,6 +145,14 @@ struct vgic_dist {
>  
>  	struct vgic_io_device	*dist_iodevs;
>  	struct vgic_io_device	*redist_iodevs;
> +
> +	/* Address of LPI configuration table shared by all redistributors */
> +	u64			propbaser;

is this an architectural requirement or an implementation decision?

> +
> +	/* Addresses of LPI pending tables per redistributor */
> +	u64			*pendbaser;

have we considered having an array of redistributors and putting the
field in each one of those instead?

> +
> +	bool			lpis_enabled;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 7d5d630..252b9aff 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -771,7 +771,9 @@ static int vgic_mmio_read_v3r_propbase(struct kvm_vcpu *vcpu,
>  				       struct kvm_io_device *this,
>  				       gpa_t addr, int len, void *val)
>  {
> -	/* TODO: implement */
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +
> +	write_mask64(dist->propbaser, addr & 7, len, val);
>  	return 0;
>  }
>  
> @@ -779,7 +781,11 @@ static int vgic_mmio_write_v3r_propbase(struct kvm_vcpu *vcpu,
>  				        struct kvm_io_device *this,
>  				        gpa_t addr, int len, const void *val)
>  {
> -	/* TODO: implement */
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	if (!dist->lpis_enabled)
> +		dist->propbaser = mask64(dist->propbaser, addr & 7, len, val);
>  	return 0;
>  }
>  
> @@ -787,7 +793,12 @@ static int vgic_mmio_read_v3r_pendbase(struct kvm_vcpu *vcpu,
>  				       struct kvm_io_device *this,
>  				       gpa_t addr, int len, void *val)
>  {
> -	/* TODO: implement */
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u64 pendbaser = dist->pendbaser[iodev->redist_vcpu->vcpu_id];
> +
> +	write_mask64(pendbaser, addr & 7, len, val);
>  	return 0;
>  }
>  
> @@ -795,7 +806,14 @@ static int vgic_mmio_write_v3r_pendbase(struct kvm_vcpu *vcpu,
>  				        struct kvm_io_device *this,
>  				        gpa_t addr, int len, const void *val)
>  {
> -	/* TODO: implement */
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u64 *pendbaser = &dist->pendbaser[iodev->redist_vcpu->vcpu_id];
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	if (!dist->lpis_enabled)
> +		*pendbaser = mask64(*pendbaser, addr & 7, len, val);
>  	return 0;
>  }
>  
> -- 
> 2.7.3
> 
