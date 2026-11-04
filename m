Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793767218;
	b=sRC9hZW7WbbK5JP0SLdnO5ird2ZvT8h5WaxL303blSdBhdBo/EMHrEc10nMjOhBhile9
	 0Z14gdwEhTTxCB/mnMHpvqo6KDgw8XkypArZ2FTcQkV1PbwPb/7n67qGO8dSn857oY5Ro
	 Dy6PrhtHIQL3Pgyjy9E2RC3G390sY5xOVy88SMTxWwIGoJxlY3xT25OBoyu9ofsvDiGou
	 ENXM0sM08s1uy7hw8dk+QDvGxyFOJmUKQe6L/qdVEnHgD5m+eEhhwOyI5EH3dOUn+b+Vz
	 C+WHERZRQ/IZdH6G1uWvVk70HPTfMwrEiamYBCBu2aB5EhhVQtEIy36UDHH7dNXIUVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793767218;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=eBo6m9TRt3u7jHWyqEJCuI7Yc7VAcSoHa3Ga9ETRxHs=;
	b=qzky27gXjRWRILEuOrmT6+cPIrXkUaBfvS/NCpCFP4BF/Akktjb7DP1v5ZYVkmuFaIyk
	 eWUpbd06oa3ukITLmiW1BkHXhL/tI95SaDJ2i3QJea5ulqvrSuowQfOL9uIR/lRK5RMJp
	 hqJIi+fqb9rUuFUkkrTrFBE+r2v62W4fMKu5JpjCRJQTRQwlp7MT6JqVtKKpKjJ6Awb/f
	 0HjlU0ESpcdb5CcaLjRimWUjFeeS30kF77sBoOBMbV2GATyEcC0tZbT5slAcVAk3kyWcb
	 f5c2HF12x3W9JctqVgH5gPeJnBBKb8+FuRpgd/ViYNwQSzGbzICBxalbzMZz4dbu5zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="boLE1g/z";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90174606A333
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 04:40:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90174606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=boLE1g/z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 652151650;
	Tue,  3 Nov 2026 20:40:12 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C303F632;
	Tue,  3 Nov 2026 20:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793767215; bh=YZ3YYPYr2zHwidf3F3F9tabWpHqTYPDIU+K4iUulZtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boLE1g/zO2Ri23iXDvZd1qeEEWBC6hbQf0IvlUxgMhL8fcikDjOVLMu4CTTYMvkq6
	 lQaRKgwZna9QxGZXzvQMMegY/pQZ0amgrw1ymvEW6bwDnsdbNBl9r+dBLNCTuzyDPV
	 67g+pF/Y/aieZ76OjWFLg0Lnt0aNNz/UkRTwZ1hY=
Date: Wed, 4 Nov 2026 04:40:04 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, 
	lpieralisi@kernel.org, timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 07/16] KVM: arm64: gic-v5: Add ITS guest table
 translation emulation
Message-ID: <hxqfrixbjm67mkub3cjziyv3c4sn7lf36fv6nlo6covwnzsglk@nbqwv3qd6yte>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-8-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102194454.4086911-8-sascha.bischoff@arm.com>

On Mon, Nov 02, 2026 at 07:44:45PM +0000, Sascha Bischoff wrote:
> The GICv5 ITS consumes guest-owned translation tables. Unlike the
> GICv3 ITS, KVM does not maintain a separate software device/table
> model for GICv5 translations; the guest's DT and ITTs are the
> authoritative source of DeviceID/EventID to LPI mappings.
> 
> Add helpers to walk both linear and two-level guest Device Tables and
> Interrupt Translation Tables. The walker reads the guest table entries
> under the ITS lock, validates the relevant valid bits and range fields,
> and resolves a DeviceID/EventID pair to the LPI encoded in the guest's
> ITTE.
> 
> Use the table walker to implement the translation side effects of the
> MMIO interface. READ_EVENTR now resolves DIDR/EIDR and reports the LPI
> through READ_EVENT_DATAR, while GEN_EVENTR resolves GEN_EVENT_DIDR and
> GEN_EVENT_EIDR and injects the resulting LPI into the VM.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its-v5.c | 300 ++++++++++++++++++++++++++++++
>  1 file changed, 300 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
> index f04161c315b78..caa68c4680d02 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -19,6 +19,302 @@
>  #define VITS_V5_DEVICE_ID_BITS		16
>  #define VITS_V5_EVENT_ID_BITS		16
>  
> +static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
> +			   gpa_t *itt_base, bool *two_level_itt,
> +			   unsigned int *event_id_bits, unsigned int *itt_l2sz)
> +{
> +	__le64 dt_l2_entry;
> +	gpa_t entry_addr;
> +	u64 val;
> +	int ret;
> +
> +	entry_addr = dt_base + device_id * sizeof(__le64);

I think dt_base needs to respect IDR0.PA_RANGE and treat the
unimplemented high bits as 0.

Also IIUC we should detect the alignment and ignore the lower bits.

> +	ret = kvm_read_guest_lock(kvm, entry_addr, &dt_l2_entry,
> +				  sizeof(dt_l2_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L2 DT\n");
> +		return ret;
> +	}
> +
> +	val = le64_to_cpu(dt_l2_entry);
> +	if (!FIELD_GET(GICV5_DTL2E_VALID, val)) {
> +		kvm_debug("Guest DT entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	*itt_base = FIELD_GET(GICV5_DTL2E_ITT_ADDR_MASK, val) << 3;
> +	*two_level_itt = FIELD_GET(GICV5_DTL2E_ITT_STRUCTURE, val);
> +	*event_id_bits = FIELD_GET(GICV5_DTL2E_EVENT_ID_BITS, val);
> +	*itt_l2sz = FIELD_GET(GICV5_DTL2E_ITT_L2SZ, val);
> +
> +	return 0;
> +}
> +
> +static int parse_two_level_dt(struct kvm *kvm, gpa_t dt_base,
> +			      unsigned int dt_l2sz, u32 device_id,
> +			      gpa_t *itt_base, bool *two_level_itt,
> +			      unsigned int *event_id_bits,
> +			      unsigned int *itt_l2sz)
> +{
> +	unsigned int device_id_l1_shift, l2_device_id;
> +	__le64 dt_l1_entry;
> +	gpa_t dt_l2_base;
> +	gpa_t entry_addr;
> +	u64 val;
> +	int ret;
> +
> +	switch (dt_l2sz) {
> +	case 0:

Perhaps use GICV5_ITS_DT_ITT_CFGR_L2SZ_* for these values?

> +		device_id_l1_shift = 9;

I can see ITS_L2SZ_*_L2_BITS for 9, 11, 13, but they are in
irq-gic-v5-its.c, maybe move them to irqchip/arm-gic-v5.h as well?

> +		break;
> +	case 1:
> +		device_id_l1_shift = 11;
> +		break;
> +	case 2:
> +		device_id_l1_shift = 13;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	entry_addr = dt_base +
> +		     (device_id >> device_id_l1_shift) * sizeof(__le64);

Same here, need to consider PA_RANGE for the high bits and the
alignment.

> +
> +	ret = kvm_read_guest_lock(kvm, entry_addr, &dt_l1_entry,
> +				  sizeof(dt_l1_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L1 DT\n");
> +		return ret;
> +	}
> +
> +	val = le64_to_cpu(dt_l1_entry);
> +	if (!FIELD_GET(GICV5_DTL1E_VALID, val)) {
> +		kvm_debug("Guest DT L1 entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	dt_l2_base = FIELD_GET(GICV5_DTL1E_L2_ADDR_MASK, val) << 3;

Same here. I believe the same issues also exist for ITT parsing below.

> +	l2_device_id = device_id % (1UL << device_id_l1_shift);
> +	if (l2_device_id >= (1UL << FIELD_GET(GICV5_DTL1E_SPAN, val))) {
> +		kvm_debug("DeviceID 0x%x out of range of guest DT\n",
> +			  device_id);
> +		return -ENXIO;
> +	}
> +
> +	return parse_linear_dt(kvm, dt_l2_base, l2_device_id, itt_base,
> +			       two_level_itt, event_id_bits, itt_l2sz);
> +}
> +
> +static int get_itt(struct kvm *kvm, struct vgic_v5_its *its, u32 device_id,
> +		   gpa_t *itt_base, bool *two_level_itt,
> +		   unsigned int *event_id_bits, unsigned int *itt_l2sz)
> +{
> +	unsigned int dt_l2sz, device_id_bits;
> +	bool two_level_dt;
> +	gpa_t dt_base;
> +
> +	dt_base = its->dt_baser.addr;
> +	two_level_dt = its->dt_cfgr.structure;
> +	dt_l2sz = its->dt_cfgr.l2sz;
> +	/* An oversized DT_CFGR value reads back as written but acts as IDR1's max. */
> +	device_id_bits = min(its->dt_cfgr.device_id_bits,
> +			     its->idr1.device_id_bits);
> +
> +	if (device_id >= 1UL << device_id_bits) {
> +		kvm_debug("Device ID out of range\n");
> +		return -E2BIG;
> +	}
> +
> +	if (!two_level_dt)
> +		return parse_linear_dt(kvm, dt_base, device_id, itt_base,
> +				       two_level_itt, event_id_bits, itt_l2sz);
> +
> +	return parse_two_level_dt(kvm, dt_base, dt_l2sz, device_id, itt_base,
> +				  two_level_itt, event_id_bits, itt_l2sz);
> +}
> +
> +static int parse_linear_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
> +			    __le64 *itt_l2_entry)
> +{
> +	gpa_t entry_addr = itt_base + event_id * sizeof(*itt_l2_entry);
> +	int ret;
> +
> +	ret = kvm_read_guest_lock(kvm, entry_addr, itt_l2_entry,
> +				  sizeof(*itt_l2_entry));
> +	if (ret)
> +		kvm_debug("Failed to read guest memory for L2 ITT\n");
> +
> +	return ret;
> +}
> +
> +static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
> +			       unsigned int itt_l2sz, __le64 *itt_l2_entry)
> +{
> +	unsigned int itt_split_bits, l2_event_id_bits;
> +	gpa_t itt_l2_base, entry_addr;
> +	u32 l1_event_id, l2_event_id;
> +	__le64 itt_l1_entry;
> +	u64 val;
> +	int ret;
> +
> +	switch (itt_l2sz) {
> +	case 0:
> +		itt_split_bits = 9;
> +		break;
> +	case 1:
> +		itt_split_bits = 11;
> +		break;
> +	case 2:
> +		itt_split_bits = 13;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	l1_event_id = event_id >> itt_split_bits;
> +	entry_addr = itt_base + l1_event_id * sizeof(itt_l1_entry);
> +	ret = kvm_read_guest_lock(kvm, entry_addr, &itt_l1_entry,
> +				  sizeof(itt_l1_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L1 ITT\n");
> +		return ret;
> +	}
> +
> +	val = le64_to_cpu(itt_l1_entry);
> +	if (!FIELD_GET(GICV5_ITTL1E_VALID, val)) {
> +		kvm_debug("Guest ITT L1 entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	itt_l2_base = FIELD_GET(GICV5_ITTL1E_L2_ADDR_MASK, val) << 3;
> +	l2_event_id_bits =
> +		min(FIELD_GET(GICV5_ITTL1E_SPAN, val), itt_split_bits);
> +	l2_event_id = event_id % (1UL << l2_event_id_bits);
> +
> +	if ((itt_split_bits != l2_event_id_bits) &&
> +	    (event_id & ((1UL << itt_split_bits) - 1)) != l2_event_id) {
> +		kvm_debug("EventID is out of range of L2 ITT\n");
> +		return -ENXIO;
> +	}
> +
> +	return parse_linear_itt(kvm, l2_event_id, itt_l2_base, itt_l2_entry);
> +}
> +
> +static int get_itte(struct kvm *kvm, u32 event_id, gpa_t itt_base,
> +		    bool two_level_itt, unsigned int itt_l2sz,
> +		    __le64 *itt_l2_entry)
> +{
> +	if (!two_level_itt)
> +		return parse_linear_itt(kvm, event_id, itt_base, itt_l2_entry);
> +
> +	return parse_two_level_itt(kvm, event_id, itt_base, itt_l2sz,
> +				   itt_l2_entry);
> +}
> +
> +static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
> +				     u32 device_id, u16 event_id,
> +				     struct vgic_irq **irq)
> +{
> +	unsigned int itt_l2sz, event_id_bits;
> +	__le64 itt_l2_entry;
> +	bool two_level_itt;
> +	gpa_t itt_base;
> +	u32 lpi;
> +	u64 val;
> +	int ret;
> +
> +	lockdep_assert_held(&its->its_lock);
> +
> +	if (!its->enabled) {
> +		kvm_debug("Cannot look up LPI; vITS is disabled\n");
> +		return -ENXIO;
> +	}
> +
> +	if (WARN_ON_ONCE(kvm->mm != get_current()->mm))
> +		return -EWOULDBLOCK;
> +
> +	ret = get_itt(kvm, its, device_id, &itt_base, &two_level_itt,
> +		      &event_id_bits, &itt_l2sz);
> +	if (ret) {
> +		kvm_debug("Error parsing guest's DT\n");
> +		return ret;
> +	}
> +
> +	if (event_id >= 1UL << event_id_bits) {
> +		kvm_debug("Event ID out of range\n");
> +		return -E2BIG;
> +	}
> +
> +	ret = get_itte(kvm, event_id, itt_base, two_level_itt, itt_l2sz,
> +		       &itt_l2_entry);
> +	if (ret)
> +		return ret;
> +
> +	val = le64_to_cpu(itt_l2_entry);

As NV is not supported yet, an ITTE with VIRTUAL == 1 should not be
signaled I think (R_TQFCT). The current code injects them as the guest's
physical interrupts.

Additionally, if DAC is programmed to a reserved value the interrupt
should be ignored too.

> +	if (!FIELD_GET(GICV5_ITTL2E_VALID, val)) {
> +		kvm_debug("ITTE is not valid\n");
> +		return -EINVAL;
> +	}
> +
> +	lpi = FIELD_GET(GICV5_ITTL2E_LPI_ID, val);
> +
> +	*irq = vgic_add_lpi(kvm, vgic_v5_make_lpi(lpi), NULL);
> +	if (IS_ERR(*irq))
> +		return PTR_ERR(*irq);
> +
> +	return 0;
> +}
> +
> +static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
> +		     kvm->arch.vgic.gicv5_vm.vm_id);
> +}
> +
> +static void vgic_v5_its_handle_read_event(struct kvm *kvm,
> +					  struct vgic_v5_its *its)
> +{
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	its->read_event_datar.valid = false;
> +	its->read_event_datar.lpi_id = 0;
> +	its->read_event_datar.vm_id = 0;
> +	its->read_event_datar.virt = false;
> +
> +	ret = __vgic_v5_its_resolve_lpi(kvm, its, its->didr.device_id,
> +					its->eidr.event_id, &irq);
> +	if (ret)
> +		return;
> +
> +	its->read_event_datar.lpi_id = vgic_v5_get_hwirq_id(irq->intid);
> +	its->read_event_datar.valid = true;

Should its->read_event_datar.vm_id and its->read_event_datar.virt be
updated? VM_ID and VIRT don't seem to be conditional on IRS_IDR0.VIRT?

> +	vgic_put_irq(kvm, irq);
> +}
> +
> +static void vgic_v5_its_handle_gen_event(struct kvm *kvm,
> +					 struct vgic_v5_its *its,
> +					 unsigned long val)
> +{
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	if (!FIELD_GET(GICV5_ITS_GEN_EVENTR_R, val))
> +		return;
> +
> +	if (FIELD_GET(GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN, val))
> +		return;
> +
> +	ret = __vgic_v5_its_resolve_lpi(kvm, its,
> +					its->gen_event_didr.device_id,
> +					its->gen_event_eidr.event_id, &irq);
> +	if (ret)
> +		return;
> +
> +	vgic_v5_its_inject_lpi(kvm, irq);

ITS_GEN_EVENTR generates a SET_EDGE event, but GIC VDPEND only generates
a SET event, is there a mismatch here?

Thanks,
Wei-Lin Chang

> +	vgic_put_irq(kvm, irq);
> +}
> +
>  static unsigned long vgic_v5_mmio_read_its_misc(struct kvm *kvm, void *dev,
>  						gpa_t addr, unsigned int len)
>  {
> @@ -252,7 +548,10 @@ static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
>  		its->inv_eventr.i = FIELD_GET(GICV5_ITS_INV_EVENTR_I, val);
>  		return;
>  	case GICV5_ITS_SYNCR:
> +		return;
>  	case GICV5_ITS_READ_EVENTR:
> +		if (FIELD_GET(GICV5_ITS_READ_EVENTR_R, val))
> +			vgic_v5_its_handle_read_event(kvm, its);
>  		return;
>  	case GICV5_ITS_GEN_EVENT_EIDR:
>  		its->gen_event_eidr.event_id =
> @@ -266,6 +565,7 @@ static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
>  			FIELD_GET(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, val);
>  		return;
>  	case GICV5_ITS_GEN_EVENTR:
> +		vgic_v5_its_handle_gen_event(kvm, its, val);
>  		return;
>  	default:
>  		return;
> -- 
> 2.34.1
> 
