Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793638043;
	b=K3PW4o06ZNw0EJIHgE2Q0V5SHGSU9PHMV4m9JMxiRsHadSS4WrMKvyMZYjbDjWhpLZxn
	 9/5u1GzA3E0YYkJaz1WaZBXgaNhGd1PHUp1wT8b/MeKtVFnv8jmDB3AaowShCLx6pzWu+
	 SwscW7u4g6mC1ygV0so/FSBb/omBXqPT5DSk3OnX0RbF4NVFqzHqd8VGZ52/5+cm9kqMk
	 0dycdELCiBOfXEFJD4FQBljZ0AhwkKgs+K0Bt3MYTLMse8UAiR900f0xpby3uJT00XJI9
	 P09DMpadqtcL2taXmPQaftuGzdeF0h7mKR0hRHn2ui2mxZrkTl6f3BiBSfrhH0HO8Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793638043;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xYFV2sIJXPeD/UT86NX1VHxUCYIwQd37eGSUNeH+Dsg=;
	b=EEj3ThTjhBcK2wfNeynQzhrRYj3DCtEMuSD2DRRjNIOyGi2lHvcXzgty72Nj2kbN1uzj
	 Qgx7YSfFQEMQhorAaHcQeeeDks3HOTllx++hcfqOCHNaERCZ9v14kPCl6G7iru26K6siT
	 9gLLxfx1UtsARSi9dPG9OqQgApCn6uuMYvKRHBQ6x+KDnxToMiNGrviC6uMvaCJcHRMr3
	 WLSGwAbxtz/XYxCxx10KlMFp+eCpMwi0yY/EW662+BZ/nV8GCH7/WoQgteVSlhjGmuU1Q
	 MzoUZeM4rX2WtovBTF9fMEarS4vBykJgEPS22Znn3LNpLQQQp9yTTGziSuPv1p0P9hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ItFSL5XZ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52D8606B0ED;
	Mon,  2 Nov 2026 16:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A52D8606B0ED
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ItFSL5XZ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E99A116F3;
	Mon,  2 Nov 2026 08:47:17 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ABB03F59E;
	Mon,  2 Nov 2026 08:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793638041; bh=NUIUbAV/c1P3Ein5UfxzQaJacNrd5uuAdVMFA2B5968=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ItFSL5XZ7whxs+V8JGslOJ4W3a0QhLN9KOslux0PmbV1HvS7s3rir1P/NcJX3m3A9
	 Pk/0aoT94mdXvYKZ5ai8Pseyr9+kFDmLd9lXU+01fX2q9WzVXXGETiy3E3YJc0dn+t
	 rru7/rqR8KK6cebQKQ8Vd07daiPj9XLuh/TvtMuY=
Message-ID: <8dfbbe68-f381-4aaf-8c1e-801b2c1a6a93@arm.com>
Date: Mon, 2 Nov 2026 16:47:18 +0000
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
Subject: Re: [PATCH 06/16] KVM: arm64: gic-v5: Add ITS MMIO state emulation
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-7-sascha.bischoff@arm.com>
 <sashiko-outbox-174609@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174609@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/10/2026 17:11, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] kvm: arm64: Data race and TOCTOU due to missing its_lock in MMIO handlers
> - [High] kvm: arm64: gic-v5: Userspace writes to ITS READ_EVENT_DATAR and ID registers are silently dropped
> --
> 
> commit cda638a2b9c74f59afeb5648c53ce1083d96d5c3
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: gic-v5: Add ITS MMIO state emulation
> 
> In order to expose a virtual GICv5 ITS to the guest, KVM needs to
> emulate the ITS CONFIG_FRAME and its translation-control registers.
> Replace the placeholder ITS IODEV region with the GICv5 ITS register
> layout and handlers for the architected MMIO state.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> index f8184b4ae0ccd..fda75314229a5 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> 
> [ ... ]
> 
>> +static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
>> +					unsigned int len, unsigned long val)
>> +{
>> +	struct vgic_v5_its *its = dev;
>> +	size_t offset = addr & (SZ_64K - 1);
>> +
>> +	switch (offset) {
>> +	case GICV5_ITS_CR0:
>> +		its->enabled = FIELD_GET(GICV5_ITS_CR0_ITSEN, val);
>> +		return;
>> +	case GICV5_ITS_CR1:
>> +		its->cr1.sh = FIELD_GET(GICV5_ITS_CR1_SH, val);
>> +		its->cr1.oc = FIELD_GET(GICV5_ITS_CR1_OC, val);
>> +		its->cr1.ic = FIELD_GET(GICV5_ITS_CR1_IC, val);
>> +		its->cr1.dt_ra = FIELD_GET(GICV5_ITS_CR1_DT_RA, val);
>> +		its->cr1.itt_ra = FIELD_GET(GICV5_ITS_CR1_ITT_RA, val);
>> +		return;
>> +	default:
>> +		return;
>> +	}
>> +}
> 
> [Severity: High]
> Does this code introduce a data race or TOCTOU vulnerability?
> 
> The vgic_v5_mmio_write_its_misc() function modifies the its->enabled flag
> and its->cr1 fields without acquiring its->its_lock. Concurrently,
> vgic_v5_mmio_write_its_dt_itt() uses guard(mutex)(&its->its_lock) to safely
> evaluate !its->enabled and modify table bases.
> 
> Allowing lockless modification of its->enabled could bypass the check
> if another vCPU is simultaneously writing to translation base registers.
> Additionally, this permits torn reads of the multi-field cr1 struct. Should
> this function acquire its->its_lock?

Agreed, this was an issue. I've updated the code to take its->its_lock 
for IRS_CR0 and IRS_CR1 reads and writes, so these will never be torn, 
and hence things should remain consistent for a single vCPU's view of 
the state.

> 
> [ ... ]
> 
>>   static const struct vgic_register_region vgic_v5_its_registers[] = {
>> -	REGISTER_ITS_V5_DESC(0, vgic_v5_mmio_read_its_raz,
>> -			     vgic_v5_mmio_write_its_wi, KVM_VGIC_V5_ITS_SIZE,
>> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
>> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR1, vgic_v5_mmio_read_its_misc,
>> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR2, vgic_v5_mmio_read_its_misc,
>> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> 
> [ ... ]
> 
>> +	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
>> +			     vgic_v5_mmio_read_its_dt_itt,
>> +			     vgic_v5_mmio_write_its_wi, 8,
>> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> 
> [Severity: High]
> Are userspace writes to restore migration state being silently dropped?
> 
> Both the ID registers (e.g. IDR0) and READ_EVENT_DATAR are configured
> with the vgic_v5_mmio_write_its_wi write-ignore handler. Since there is no
> explicit userspace override provided for these registers, a userspace write
> will fall back to the guest MMIO write handler, accepting the write and
> returning success (0) but discarding the value.
> 
> For ID registers, ignoring the write prevents the VMM from detecting
> incompatibility across migration. For READ_EVENT_DATAR, the result of an
> inflight READ_EVENTR command is lost. Does this violate the ABI contract
> that userspace writes must either take effect or return an error?
> 

This is not an issue with the current patch we are looking at, but is an 
issue for Patch 10 in this series.

Nevertheless: I've added userspace-only handlers (to patch 10) to 
restore the supported IDR0–IDR2 fields and READ_EVENT_DATAR. It returns 
-EINVAL for unsupported ID values,i.e., we sanity check what userspace 
writes against what we can/want to provide. Guest writes to the RO 
registers remain ignored, as they should be.

Thanks,
Sascha
