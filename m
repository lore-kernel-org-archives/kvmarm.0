Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645534;
	b=KebsbGMtwam6hW2Xyzo3fMOgRJLY4vt8i2Ae21Z7LxnULpCsb6bUYR6BMOMNe2u+2BuB
	 O0US7+xcfrh73FmdZds5R9GLpfoHW4u+YXDfaEeo6N5WRaPPXot0Gzb4VRDo5eYykAaLO
	 ie3EU0pEZCxL3B9PxNMmKPwJzOKkVJCE50J9C0VllUmigeeU7FxA7NleSHxzi5zXtOln/
	 nI38MGwAZszSny5y8IIPcKZ0amujbL6xjgp2aThbp/YRy7sQ3M7WxEgWmglmgE7/9zDVo
	 imYLh6rLmzUZOPq6t2KhRLjlzWiE/pt2THEknXugARh0qFfsAcseW/TVXLQaE6msoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645534;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=IK5p9/oAjFQaLEk4iOn+2jSpIJGhuFIILB+nKJjM5W4=;
	b=r096VYwEBOcO6tcSwb41VDqoPXiRW+deWkRXc+YeYmoqS6AhBBpB5VfUGBuT4U8i8dii
	 v/94SqFy6URE5rd96zAOPZxvutc57aKJoFKXCu6lBwETO7BKns4XMYtFFzl1lY9b3xyYI
	 7hO6Bsde7I48o2pHc0MiFOEE1Td5LuZuyXBKrlvGPs4gl0ePIyEdYAhtSx+5YUBSKzMFc
	 VYodJU22aLM6LmJx4R7yugl14TPSjXu3EJgiwb4Bi1mN6dbSYDJKe2Qk0ZHRM8jTKcY5K
	 FZFsY0UHPmSsBYujZ9JeBoTLmfgT0gsls/kLtAZu425azJcweD7cat4fpWVzqU+pDfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rpf7QTW0;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402FF606A327;
	Mon,  2 Nov 2026 18:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 402FF606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rpf7QTW0
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 721EF1FC4;
	Mon,  2 Nov 2026 10:52:09 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D17523F673;
	Mon,  2 Nov 2026 10:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793645532; bh=eRT8EPlGmj8VVlfVMAD9ve9ebI+67LjsP9Gf4hzofTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rpf7QTW00lwV9uTdlfHmVNFktsConMIdlqcqODPOVAoWzTp/3ZRQLmYqIG/rB3/O2
	 B43c7J+phQXwSkzgHrVn+KcB5LCXoLOCtrWx8k8KB+MD49amIYjt2Wg0OljbJdEkDw
	 nQjecks+ITNlOMcG9zeZ9omftVPNSf4vFKcf0l94=
Message-ID: <ab0d81a4-da63-4f36-8412-0649153ebd49@arm.com>
Date: Mon, 2 Nov 2026 18:52:10 +0000
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
Subject: Re: [PATCH 16/16] KVM: arm64: gic-v5: Document ITS userspace ABI
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-17-sascha.bischoff@arm.com>
 <sashiko-outbox-174640@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174640@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:27, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] kvm: arm64: gic-v5: userspace writes to READ_EVENT_DATAR are silently ignored causing state loss
> --
> 
> commit 3a4606444ec9f90ae2360e066a229c789d9eca15
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: gic-v5: Document ITS userspace ABI
> 
> Document the GICv5 ITS device and its userspace ABI, including the
> MMIO address, reset control, register attributes, and MSI requirements.
> 
>> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst b/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst
>> new file mode 100644
>> index 0000000000000..250057e4445d7
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5-its.rst
> 
> [ ... ]
> 
>> +KVM_DEV_ARM_VGIC_GRP_ITS_REGS
>> +-----------------------------
>> +
>> +  Attributes:
>> +    The attr field of kvm_device_attr contains the ITS register offset from
>> +    the control frame base address. kvm_device_attr.addr points to a __u64,
>> +    regardless of whether the register is 32 or 64 bits wide. A 64-bit
>> +    register must be addressed at its base offset; userspace cannot access
>> +    its upper or lower half separately. Guest MMIO may use aligned 32-bit
>> +    accesses to DT_BASER, DIDR, READ_EVENT_DATAR, and GEN_EVENT_DIDR.
>> +
>> +    The ITS base address must be configured before this group can be used.
>> +    Writes to read-only registers are ignored. Writes to DT_CFGR and DT_BASER
> 
> [Severity: Medium]
> Does this design violate the rule that read-only attributes must return an
> error on set?
> 
> A device attribute documented as read-only whose set path does not return an
> error can lead to silent migration state loss. For example, READ_EVENT_DATAR
> is a stateful register that holds the result of the READ_EVENTR command. If
> userspace restores this state during migration, but the write path returns 0
> while ignoring the value, the restored state is silently dropped, corrupting
> the guest's view of the command result upon resume.
> 
> Looking at the implementation, READ_EVENT_DATAR is defined without a uaccess
> write override in vgic_v5_its_registers() and uses vgic_v5_mmio_write_its_wi.
> The userspace attribute set path in vgic_v5_its_attr_regs_access() defaults
> to calling the guest its_write handler, which invokes the Write Ignore stub
> and successfully returns 0 instead of returning -EINVAL or -EPERM.
> 

The posted userspace access patch in this series (patch 10) silently 
discarded READ_EVENT_DATAR, which was a mistake on my part.

I've added its restore handler in patch 10, and a read-back test in 
patch 14, and ABI text in this patch documenting that userspace can 
(read: must) restore it. Guest MMIO writes remain ignored, as this is a 
RO register from the guest's point of view, but it must persist across 
save/restore.

Thanks,
Sascha
