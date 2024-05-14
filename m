Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757F856B79;
	Tue, 14 May 2024 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682428; cv=none; b=Hw14OJ14WRu6ri4/qHBmf2RG4kqbSuWcSm15J9ZbwTLcxiqnHnjk7UwShWdnRhIEdk/Lim9rmxPCksUvwMGMBsfDDBgqdga/0l1gcZxhOwzXKE+UiZ/PRngOcstZL0QBSVulSATpG0W7GWhMZ6AQG6nanZI0SgFPaF7FACJ6VvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682428; c=relaxed/simple;
	bh=ePBONPtPxyYMzaFhoGos4Fz1besShTBvxLyuaOpYTkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrmZimh5Zy9BYGElRTEbWzhpVAVnmEvwTgU6FN/CYBarkgOdW/V/SU3+llfVOXNTF6k4jY+An4t94mHCggK2Twv+SVR44sSoOCjZVbjsCHuiFb/cA21yit4xO4L3A00W8Y07FrIZprbC9v0BD+9Q9wHFEkJWgIOeN670+4o00qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D61141007;
	Tue, 14 May 2024 03:27:29 -0700 (PDT)
Received: from [10.57.81.220] (unknown [10.57.81.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CF5C3F762;
	Tue, 14 May 2024 03:27:02 -0700 (PDT)
Message-ID: <fc8b0464-7f10-4ef1-b1f5-48a708ef6efd@arm.com>
Date: Tue, 14 May 2024 11:27:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 18/33] arm: realm: Add test for FPU/SIMD
 context save/restore
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com,
 james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com,
 eric.auger@redhat.com, Subhasish Ghosh <subhasish.ghosh@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-19-suzuki.poulose@arm.com>
 <20240510-7e7f794ddf51316b15b57113@orel>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240510-7e7f794ddf51316b15b57113@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10/05/2024 16:28, Andrew Jones wrote:
> On Fri, Apr 12, 2024 at 11:33:53AM GMT, Suzuki K Poulose wrote:
>> From: Subhasish Ghosh <subhasish.ghosh@arm.com>
>>
>> Test that the FPU/SIMD registers are saved and restored correctly when
>> context switching CPUs.
>>
>> In order to test fpu/simd functionality, we need to make sure that
>> kvm-unit-tests doesn't generate code that uses the fpu registers, as that
>> might interfere with the test results. Thus make sure we compile the tests
>> with -mgeneral-regs-only.
>>
>> Signed-off-by: Subhasish Ghosh <subhasish.ghosh@arm.com>
>> [ Added SVE register tests ]
>> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arm/Makefile.arm64        |   9 +
>>   arm/cstart64.S            |   1 +
>>   arm/fpu.c                 | 424 ++++++++++++++++++++++++++++++++++++++
>>   arm/unittests.cfg         |   8 +
>>   lib/arm64/asm/processor.h |  26 +++
>>   lib/arm64/asm/sysreg.h    |   7 +
>>   6 files changed, 475 insertions(+)
>>   create mode 100644 arm/fpu.c
> 
> When I build and run this test with EFI I get an SVE exception.
> 
> ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
> qemu-system-aarch64 -nodefaults \
> 	-machine virt -accel tcg -cpu max \
> 	-display none -serial stdio \
> 	-kernel arm/fpu.efi -append fpu.efi \
> 	-bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
> 	-smp 2 -machine acpi=off
> 
> UEFI firmware (version edk2-20230524-3.fc38 built at 00:00:00 on Jun 26 2023)
> ...
> 
> Address of image is: 0x43cfd000
> PASS: fpu: FPU/SIMD register save/restore mask: 0xffffffff
> PASS: fpu: FPU/SIMD register save/restore mask: 0xffffffff
> Load address: 43cfd000
> PC: 43d0b4e4 PC offset: e4e4
> Unhandled exception ec=0x19 (SVE)
> Vector: 4 (el1h_sync)
> ESR_EL1:         66000000, ec=0x19 (SVE)
> FAR_EL1: 0000000000000000 (not valid)
> Exception frame registers:
> pc : [<0000000043d0b4e4>] lr : [<0000000043d0b4d8>] pstate: 000002c5
> sp : 0000000043d2bec0
> x29: 0000000043d2bec0 x28: 0000000043d2bf58
> x27: 0000000043d2bf60 x26: 0000000043d2bf68
> x25: 0000000043d2bf70 x24: 8000000000000002
> x23: 0000000043d2bf88 x22: 0000000000000000
> x21: 000000004661b898 x20: 0000000043d2bfa8
> x19: 0000000043d38e60 x18: 0000000000000000
> x17: 00000000ffffa6ab x16: 0000000043d07780
> x15: 0000000000000000 x14: 0000000000000010
> x13: 0000000043d0d4b0 x12: 000000000000000f
> x11: 0000000000000004 x10: 0000000000000066
> x9 : 0000000000000066 x8 : 0000000043d3abf0
> x7 : 0000000000000080 x6 : 0000000000000040
> x5 : 0000000000003bce x4 : 0000000000043cfd
> x3 : 0000000040101000 x2 : 0000000000040105
> x1 : 0000000000000040 x0 : 1301001120110022
> 
> 	STACK: @e4e4 752c 1050
> 
> EXIT: STATUS=127

Thanks for the report. We will take look.

Suzuki


> 
> 
> Thanks,
> drew

