Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70DB3064B5;
	Tue, 11 Aug 2026 11:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786446744; cv=none; b=LJRyYdkLsyR6BjFhiG/+lnD94OdhkRqkMZgjl9GkotT/sxz8+0Ev3FQRRbfvi37hcffbn+mmla76IGLyBfC5vopaX1KaNqMoaWS7xYDIyzztcOyd5vIwMPV+ovLZsEGYQXWfXMvuPRm1qNOPdVc2r+fUQuQix0vbsEzcYwXbe5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786446744; c=relaxed/simple;
	bh=gKplmCIiFWG5Z/6+s8DfAcg9pOxWbz0udY6YdKyPRlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3aCw8zSZC2Az2kgjDYxEQz94fsNHGU6K1znH1rdFco/KgFhAd1DItVhUWJlM5irMxdln+BXyeVJv7c4iDOebkz92GkI8+g6as6V6LarsEwtDPIPHn245abeABaoSJiUiRJVpuBXfnt7a33pD5gBBwjFZmRKdP3sXGLUuKb++n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nfXtQiXJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nfXtQiXJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 199711516;
	Tue, 11 Aug 2026 04:12:18 -0700 (PDT)
Received: from [10.1.39.55] (Suzukis-MBP.cambridge.arm.com [10.1.39.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71FAC3F632;
	Tue, 11 Aug 2026 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786446742; bh=gKplmCIiFWG5Z/6+s8DfAcg9pOxWbz0udY6YdKyPRlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nfXtQiXJZlO3Z3ZkFtj2dq7F/omTWRwxMP/XgMXxy7RMF2Fakdm3vNBGGkFHiMwzQ
	 9DGKaGuqAUF1DvUMVeteyOgBrG4pAzS0K5nfYhkHw1WfwldNzbE/xAZLDwXbSj/0U3
	 f4WlhUX2SrrjgWDWPIX365fpy62LEZOmYiB49AUk=
Message-ID: <5e86232a-89ed-40ff-89e2-9e48fbf9554e@arm.com>
Date: Tue, 11 Aug 2026 12:12:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
 <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/08/2026 05:44, Gavin Shan wrote:
> On 8/7/26 8:05 AM, Suzuki K Poulose wrote:
> 
> [...]
> 
>>
>> Here is a cleaned up version, rebased on to Will's kvmtool master
>> branch:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/kvm-v16
>>
>> (This works with the v15 of the KVM series too)
>> Build on top of Fuad's Guest memfd support patches.
>>
> 
> With the following combination, I'm able boot up the realm guest.
> 
>    tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf- 
> rmm.git            (branch: topics/rmm-v2.0-poc_2)


Please be aware that CCA KVM v15 onwards, the above branch is not 
compatible. You should be using rmm-v2.0-poc_3. Please could you
confirm if this is still an issue ?


Cheers
Suzuki


>    tf-a:     https://git.trustedfirmware.org/TF-A/trusted-firmware- 
> a.git  (branch: master)
>    host:     https://git.gitlab.arm.com/linux-arm/linux- 
> cca.git           (branch: cca-host/v16)
>    kvmtool:  https://gitlab.arm.com/linux-arm/kvmtool- 
> cca                 (branch: cca/kvm-v16)
> 
> However, the guest can't boot up and become stuck in 
> SMC_RSI_IPA_STATE_SET request,
> which can't completed by the host.
> 
>    tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf- 
> rmm.git            (branch: topics/rmm-v2.0-poc_3)
> 
> (1) Login the emulated host
> 
> machine$ ssh -o StrictHostKeyChecking=no root@10.26.1.240
> 
> (2) Start realm guest using kvmtool
> 
> root@host:~# lkvm run --realm -c 1 -m 256                   \
>               -k /mnt/linux/arch/arm64/boot/Image            \
>               -i /mnt/buildroot/output/images/rootfs.cpio.xz \
>               -p earlycon=uart,mmio,0x101000000
>                   :
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
> [    0.000000] Linux version 7.2.0-rc5-gavin-gf5098b6bae76 
> (gshan@nvidia-grace-hopper-01.khw.eng.bos2.dc.redhat.com) (gcc (GCC) 
> 14.3.1 20251022 (Red Hat 14.3.1-4), GNU ld version 2.41-65.el10) #47 SMP 
> PREEMPT Mon Jul 27 02:29:03 EDT 2026
> [    0.000000] KASLR enabled
> [    0.000000] Machine model: linux,dummy-virt
> [    0.000000] earlycon: uart0 at MMIO 0x0000000101000000 (options '')
> [    0.000000] printk: legacy bootconsole [uart0] enabled
> [    0.000000] efi: UEFI not found.
> [    0.000000] OF: reserved mem: Reserved memory: No reserved-memory 
> node in the DT
> [    0.000000] NUMA: Faking a node at [mem 
> 0x0000000080000000-0x000000008fffffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x8ff76dc0-0x8ff7ac7f]
> [    0.000000] psci: probing for conduit method from DT.
> [    0.000000] psci: PSCIv1.1 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] psci: SMC Calling Convention v1.2
> [    0.000000] RME: Using RSI version 1.0
> <... no more output from the guest ...>
> 
> 
> (3) The output from host's serial console
> 
> SMC_RMI_REALM_CREATE              12a4c7000 12a4c6000 > RMI_INCOMPLETE 0 
> 24 0 0
>        SMC_RMI_OP_MEM_DONATE       0 1002c7098 9 > RMI_INCOMPLETE 9 0 0 0
>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18f85c000 18fe00000 0 0 > 
> RMI_ERROR_RTT 2 0 0 0 0
> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > 
> RMI_ERROR_RTT 2 0 0 0 0
> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > 
> RMI_ERROR_RTT 2 0 0 0 0
> SMC_RMI_REC_CREATE                12a4c7000 12a392000 12a391000 > 
> RMI_INCOMPLETE 0 40 0 0
>        SMC_RMI_OP_MEM_DONATE       0 106406098 10 > RMI_INCOMPLETE 10 0 0 0
>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
> SMC_RMI_REALM_ACTIVATE            12a4c7000 > RMI_SUCCESS
> Unhandled write S2_0_C0_C2_2
> SMC_RMI_RTT_DATA_MAP              12a4c7000 8ffb4000 8ffb5000 1 
> 129f1d004 > RMI_INCOMPLETE 0 0 0 1
>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 8ffb5000 0
> PSCI_84000000                     0 0 0 0 0 0 0 > 10001 0 0 0
> PSCI_84000006                     0 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
> PSCI_8400000a                     80000000 0 0 0 0 0 0 > 0 0 0 0
> SMC_80000000                      0 0 0 0 0 0 0 > 10002 0 0 0
> SMC_84000050                      1 0 0 ffffacd67d1e8000 
> ffffacd67d124000 0 0 > ffffffffffffffff 0 0 0
> SMC_80000001                      80000002 ffff 0 ffffacd67d1e8000 
> ffffacd67d124000 ffffacd67cd5d000 ffffacd67cd5dd38 > ffffffffffffffff 0 0 0
> PSCI_8400000a                     c4000001 0 0 0 0 0 0 > 0 0 0 0
> PSCI_8400000a                     c4000012 0 0 0 0 0 0 > 
> ffffffffffffffff 0 0 0
> PSCI_8400000a                     c4000015 0 0 0 0 0 0 > 
> ffffffffffffffff 0 0 0
> SMC_8600ff01                      ffffacd67cfc0740 10002 0 0 0 0 
> ffffacd67cfb3cc8 > ffffffffffffffff 0 0 0
> SMC_RSI_VERSION                   10000 > RSI_SUCCESS 10000 10001
> SMC_RSI_REALM_CONFIG              81385000 > RSI_SUCCESS
> SMC_RSI_IPA_STATE_SET             80000000 90000000 1 0
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 
>  > RMI_ERROR_RTT 3
> <... the last message repeats ...>
> 
> Thanks,
> Gavin
> 
> 

