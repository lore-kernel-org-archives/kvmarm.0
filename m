Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641292;
	b=mHmxHECmOAhrizulKbF5ixAI+gw4XJ6CyMhXpduZczc53QR2Zeptwn4u5Oa76DTMoAQj
	 OB/JscgDxfKHNx5GzfFYIlyTsTk1JxTVE8VC3Tzlbvmfk1Jozq4WZ+nt0LIDg+0UWyXX6
	 +7VvuB21AoNhRJyyT8AOIqIwbiAxch30ltbRi9BUERuSr2M+xLh86PHNw4TLYYyjxddKw
	 4uvnUAmMC/6qDCxcY3Pk8LUTlyXvUPy3okvWyUbZH6tVsOx+cTmnH5wzqnaL6wCXgzf7l
	 JCx9SX/vL7pc33k7TdkkKBKS1CQ/2hi7mBUYixbnGThVcD2hHIdcPdg1pBLIoTZZO0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641292;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PBEIXDYSZhPvi+xwUi+57gi1esg8AVh0L9UwO82CfuA=;
	b=wbkhR7n0ZdFdtLhtOY2qdNo3Z52H0MY9nAVOGUs5IwjJsz1DLPuI+kgNznBjw+26Il/Y
	 ETgyfjjRY5RHq94DOc3JaTjOc8+gRZCJNomGLmlbCRqSdHNe0GNPrM/g8Dtj8bljK4HK3
	 cLCEp6nNsnl39h62q1zNiPQeRsysd9Qx7XGM9VlBgjxgQzQ7ELtb3VFH9YKQ39Shcpgwa
	 MzAfjgBv6WYWxjRHKEf0epoi3aE0FEG90S9e9rOtmuKv6pZu/7Swr7EBRP3hShY8GNnfi
	 T02RcZ50pFBOhC5vzBeJ1jsq0IhqKp9t7/iZAV+NC4/Pfi3Suqae/PvK/YF3njXnYlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JMLUDvhk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1B6606B0FD;
	Mon,  2 Nov 2026 17:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1B6606B0FD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JMLUDvhk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55AAC16F3;
	Mon,  2 Nov 2026 09:41:27 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFADB3F59E;
	Mon,  2 Nov 2026 09:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793641290; bh=MKrsrXvnksc9uVbWgxUeFRcvdgMBazd2ajdJ/vsY5cw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JMLUDvhkSzgz/cwRz6Odw7weRfBS3JjnVQfE5M6ZCeONxMJgBHHI67mzfX9h0ZhNN
	 g3jm9BlMK7eauloURX5Y+GS5E82C3dTQtfGnoKxQyNx2vLITKCgHBKU6Lt1Uxl3am6
	 I7GdioFswVzqToAhxYWirSOyRW0ACN34ZXm45VAo=
Message-ID: <5f14af71-45ae-4175-9ba0-22b873d12f15@arm.com>
Date: Mon, 2 Nov 2026 17:41:28 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: arm64: gic-v5: Add ITS userspace register
 access
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-11-sascha.bischoff@arm.com>
 <sashiko-outbox-174627@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174627@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/10/2026 17:19, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] gic-v5: userspace override omits guest-side guard without post-restore validation
> - [High] gic-v5: userspace writes to stateful and capability registers are silently discarded
> - [Medium] gic-v5: missing state rollback on kvm_io_bus_register_dev failure
> - [Medium] kvm: arm64: KVM_HAS_DEVICE_ATTR fails on ITS registers before base address is set
> - [Medium] kvm: arm64: gic-v5: userspace writes to ITS ID registers are silently discarded
> --
> 
> commit 2fb8c28d93170f4ea49aeb17c5091f5d920592c9
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: gic-v5: Add ITS userspace register access
> 
> This commit exposes the GICv5 ITS register frame to userspace for inspection
> and restoration around VM reset and migration. It applies userspace access
> constraints and adds control handling for reset while preserving ITS
> defaults.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> index 5920fa1bcb2cf..62c1ca8004007 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> @@ -851,6 +851,19 @@ static u64 vgic_v5_read_its_dt_baser(struct vgic_v5_its *its)
>>   			  its->dt_baser.addr >> GICV5_ITS_DT_BASER_ADDR_SHIFT);
>>   }
>>   
>> +static int vgic_v5_uaccess_write_its_dt_itt(struct kvm *kvm, void *dev,
>> +					    gpa_t addr, unsigned int len,
>> +					    unsigned long val)
>> +{
>> +	struct vgic_v5_its *its = dev;
>> +	size_t offset = addr & (SZ_64K - 1);
>> +
>> +	guard(mutex)(&its->its_lock);
>> +
>> +	vgic_v5_write_its_dt_reg(its, offset, val);
>> +	return 0;
>> +}
> 
> [Severity: High]
> This userspace override in arch/arm64/kvm/vgic/vgic-its-v5.c intentionally
> omits the guest-side !its->enabled guard, which makes sense for permitting
> out-of-order restoration. However, when a guest-side refusal is omitted, a
> final validation step is required at the end of the restore sequence to
> re-establish the invariant.
> 
> Because KVM_DEV_ARM_VGIC_CTRL_INIT is handled as a no-op below and there
> are no RESTORE_TABLES controls exposed for GICv5, KVM never validates the
> final configuration. Could this allow userspace to leave the device in an
> illegal state (e.g., base address modified while active) that the guest
> could never produce?

GICv5's ITS works differently to the GICv3 ITS. The tables are in guest 
memory only, and there's no additional work required to restore them. As 
long as guest memory is correctly saved/restored and we retain the 
ITS_DT_BASER/IRS_DT_CFGR then we can recover all translations the guest 
has set up.

A guest can (well, MUST) program the table registers while the ITS is 
disabled and then enable the ITS; userspace can restore that same state 
in another order. Changes to table configuration or ITS enable state 
clear cached translations, and there is no decoded table state to 
rebuild. I've left CTRL_INIT as a no-op.

> 
> [ ... ]
>> @@ -1018,6 +1031,13 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
>>   		.its_read = rd, .its_write = wr,                       \
>>   	}
>>   
>> +#define REGISTER_ITS_V5_DESC_UACCESS(off, rd, wr, uwr, length, acc)    \
>> +	{                                                              \
>> +		.reg_offset = off, .len = length, .access_flags = acc, \
>> +		.its_read = rd, .its_write = wr,                       \
>> +		.uaccess_its_write = uwr,                              \
>> +	}
>> +
>>   static const struct vgic_register_region vgic_v5_its_registers[] = {
>>   	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
>>   			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> 
> [Severity: Medium]
> IDR0 is registered without a userspace write override, falling back to the
> guest's write-ignore handler vgic_v5_mmio_write_its_wi(). Because userspace
> writes are silently discarded here in arch/arm64/kvm/vgic/vgic-its-v5.c, a
> VM migrated to a new host will adopt the destination host's physical ITS
> capabilities (like pa_range in vgic_v5_its_reset()) rather than retaining
> its original configuration.
> 
> Will this break migration for heterogeneous clusters since capability
> mismatches are swallowed instead of rejected or applied?

This was a bug. I've added userspace-only write handlers for IDR0–IDR2: 
they restore supported fields and return -EINVAL for unsupported 
configurations or attempts to set RES0 bits. Guest MMIO writes remain 
ignored as these are RO from the guest's point of view.

> 
> [ ... ]
>>   	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
>>   			     vgic_v5_mmio_read_its_dt_itt,
>>   			     vgic_v5_mmio_write_its_wi, 8,
>>   			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> 
> [Severity: High]
> Stateful registers like READ_EVENT_DATAR also lack a uaccess_its_write
> override in vgic_v5_its_registers and use the guest write-ignore handler
> vgic_v5_mmio_write_its_wi().
> 
> Since the write-ignore handler silently accepts the write and discards the
> value, wouldn't pending event data be permanently lost during migration?
> 
> [ ... ]
>> +static int vgic_v5_its_has_attr_regs(struct kvm_device *dev,
>> +				     struct kvm_device_attr *attr)
>> +{
>> +	struct vgic_v5_its *its = dev->private;
>> +	const struct vgic_register_region *region;
>> +	gpa_t offset = attr->attr;
>> +	int align;
>> +
>> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base))
>> +		return -ENXIO;
> 
> [Severity: Medium]
> This runtime state check in vgic_v5_its_has_attr_regs() enforces a base
> address requirement during a purely capability-probing ioctl.
> 
> Userspace VMMs probing for supported GICv5 ITS registers via
> KVM_HAS_DEVICE_ATTR will receive -ENXIO if they probe before configuring
> the ITS base address. Could this cause the VMM to incorrectly assume the
> registers or device capabilities are unsupported, breaking device
> initialization or migration setup? Other VGIC implementations explicitly
> omit the base address check in their has_attr handlers to permit capability
> probing without prior configuration.

This was a mistake. The HAS path incorrectly required the ITS base to be 
set. I've removed that check from KVM_HAS_DEVICE_ATTR while retaining it 
for GET and SET, and updated the selftests and documentation accordingly.

> 
> [ ... ]
>> +static int vgic_v5_its_attr_regs_access(struct kvm_device *dev,
>> +					struct kvm_device_attr *attr,
>> +					u64 *reg, bool is_write)
>> +{
> ...
>> +	if (is_write) {
>> +		if (region->uaccess_its_write)
>> +			ret = region->uaccess_its_write(dev->kvm, its, addr,
>> +							len, *reg);
>> +		else
>> +			region->its_write(dev->kvm, its, addr, len, *reg);
>> +	} else {
>> +		*reg = region->its_read(dev->kvm, its, addr, len);
>> +	}
> 
> [Severity: High]
> As mentioned above, userspace writes to several registers (IDR0, CR1,
> SYNCR, READ_EVENT_DATAR) fall back to the guest-side its_write handler in
> vgic_v5_its_attr_regs_access() when no override is provided. Because these
> guest handlers silently accept the write and discard the value, mutable
> guest state is lost across migration and invalid capability settings are
> silently ignored instead of being rejected.

Yeah, as above this was a mistake. I've added restore handlers for the 
ID registers and READ_EVENT_DATAR. These reject unsupported ID values 
for the ID registers. CR1 already stores its readable state. ITS_SYNCR 
has no retained state and reads as zero, so there's nothing to do here.

> 
> [ ... ]
>> +static int vgic_v5_its_ctrl(struct kvm *kvm, struct vgic_v5_its *its, u64 attr)
>> +{
>> +	int ret = 0;
>> +
>> +	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT)
>> +		return 0;
> 
> [Severity: High]
> The initialization/finalization control in vgic_v5_its_ctrl() is a no-op,
> meaning no end-of-restore validation is performed to check the invariants
> that were bypassed by the userspace overrides (like the !its->enabled
> check).

The guest can configure the tables while disabled and then enable the 
ITS, reaching the same final state. Any changes to the table 
configuration clear cached translations. There is no decoded table state 
to rebuild, so I've left CTRL_INIT as a no-op.

> 
> [ ... ]
>> +static int vgic_v5_its_set_attr(struct kvm_device *dev,
>> +				struct kvm_device_attr *attr)
>> +{
> ...
>> +		ret = vgic_check_iorange(dev->kvm, its->vgic_v5_its_base,
>> +					 addr, SZ_64K, KVM_VGIC_V5_ITS_SIZE);
>> +		if (ret)
>> +			return ret;
>> +
>> +		return vgic_v5_register_its_iodev(dev->kvm, its, addr);
> 
> [Severity: Medium]
> In vgic_v5_register_its_iodev() in arch/arm64/kvm/vgic/vgic-its-v5.c,
> its->vgic_v5_its_base is populated with the requested addr before
> attempting to register the IO bus device. If kvm_io_bus_register_dev()
> fails (e.g. due to ENOMEM), the error path fails to clear
> its->vgic_v5_its_base upon failure:
> 
> 	its->vgic_v5_its_base = addr;
> 	...
> 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
> 				      KVM_VGIC_V5_ITS_SIZE, &iodev->dev);
> out:
> 	mutex_unlock(&kvm->slots_lock);
> 
> 	return ret;
> 
> Will this leave the ITS permanently unusable? Subsequent attempts by
> userspace to correctly set the base address will fail with -EBUSY because
> IS_VGIC_ADDR_UNDEF() evaluates to false, leaving the ITS permanently
> unmapped.
> 

A failed registration does leave the base set, and a later address SET 
returns -EEXIST. The existing GICv3 ITS path behaves the same way. This 
follows a resource failure during ITS setup, when userspace cannot 
realistically continue running the VM as configured, so I have left this 
path unchanged.

Thanks,
Sascha
