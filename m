Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD122DA756;
	Wed, 15 Apr 2026 11:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250878; cv=none; b=QrdtqXyreFocOmaOuhKIwo2cDfNaJn7Js362eGwkNrFFl60wDnym19n/qEtybwFcFsP0JVq1Z4JuFALjIPg9KwsABXvgGxNU1XB6/nNdmODBoax1Uy5olHgftdTqhAghwJbmPi285t2tQKEeH2Aa00RTjaW94TiAQeE5mYHOnn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250878; c=relaxed/simple;
	bh=NzEKcgytpfU97DicbGiWl3bAhmdduI6FBslfTibPQpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4n1xOb/SoGKyQEFveNn4KN+2nOuYT6zjm3q5lmEMwA3lv1gFGKPxCmf5vZLpsAcnw6M75g91yscFnEQMM62cooH5kH0Ewm5MI2I3EqfkUtvHaTIws9KVy5gE3sNsam/yje/T2hc3Wulm+IyXicfJlTxpoYQauHBVk7P9VzlAaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RQI2AU3/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RQI2AU3/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C28B44FD5;
	Wed, 15 Apr 2026 04:01:09 -0700 (PDT)
Received: from [10.57.61.136] (unknown [10.57.61.136])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB8F53F86F;
	Wed, 15 Apr 2026 04:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776250875; bh=NzEKcgytpfU97DicbGiWl3bAhmdduI6FBslfTibPQpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RQI2AU3/9HJQ3DCygIxuFntue21kAtZGjYmq2oeYxB5funNDUWj27KuLS6+o8P6EW
	 ywh6dckswaimSu/YRjs5FId01ljwKyU73eG067hQCEkQDWa8EO4hxfYl7SefgZQodi
	 +mwRKU/aoeiFRzW7Ai3tgQj+Q0Q3fcGWbd8mYtY0=
Message-ID: <d661a24c-6619-4734-96bd-075d3416e809@arm.com>
Date: Wed, 15 Apr 2026 12:01:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Alper Gun <alpergun@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 14/04/2026 22:40, Alper Gun wrote:
> On Wed, Mar 18, 2026 at 8:54 AM Steven Price <steven.price@arm.com> wrote:
>>
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA).
>>
>> New major version number! This now targets RMM v2.0-bet0[1]. And unlike
>> for Linux this represents a significant change.
>>
>> RMM v2.0 brings with it the ability to configure the RMM to have the
>> same page size as the host (so no more RMM_PAGE_SIZE and dealing with
>> granules being different from host pages). It also introduces range
>> based APIs for many operations which should be more efficient and
>> simplifies the code in places.
>>
>> The handling of the GIC has changed, so the system registers are used to
>> pass the GIC state rather than memory. This means fewer changes to the
>> KVM code as it looks much like a normal VM in this respect.
>>
>> And of course the new uAPI introduced in the previous v12 posting is
>> retained so that also remains simplified compared to earlier postings.
>>
>> The RMM support for v2.0 is still early and so this series includes a
>> few hacks to ease the integration. Of note are that there are some RMM
>> v1.0 SMCs added to paper over areas where the RMM implementation isn't
>> quite ready for v2.0, and "SROs" (see below) are deferred to the final
>> patch in the series.
>>
>> The PMU in RMM v2.0 requires more handling on the RMM-side (and
>> therefore simplifies the implementation on Linux), but this isn't quite
>> ready yet. The Linux side is implemented (but untested).
>>
>> PSCI still requires the VMM to provide the "target" REC for operations
>> that affect another vCPU. This is likely to change in a future version
>> of the specification. There's also a desire to force PSCI to be handled
>> in the VMM for realm guests - this isn't implemented yet as I'm waiting
>> for the dust to settle on the RMM interface first.
>>
>> Stateful RMI Operations
>> -----------------------
>>
>> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (SROs)
>> which allow the RMM to complete an operation over several SMC calls and
>> requesting/returning memory to the host. This has the benefit of
>> allowing interrupts to be handled in the middle of an operation (by
>> returning to the host to handle the interrupt without completing the
>> operation) and enables the RMM to dynamically allocate memory for
>> internal tracking purposes. One example of this is RMI_REC_CREATE no
>> longer needs "auxiliary granules" provided upfront but can request the
>> memory needed during the RMI_REC_CREATE operation.
>>
>> There are a fairly large number of operations that are defined as SROs
>> in the specification, but current both Linux and RMM only have support
>> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXMEs
>> in the code where support is missing.
>>
>> Given the early stage support for this, the SRO handling is all confined
>> to the final patch. This patch can be dropped to return to a pre-SRO
>> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purposes.
>>
>> A future posting will reorder the series to move the generic SRO support
>> to an early patch and will implement the proper support for this in all
>> RMI SMCs.
>>
>> One aspect of SROs which is not yet well captured is that in some
>> circumstances the Linux kernel will need to call an SRO call in a
>> context where memory allocation is restricted (e.g. because a spinlock
>> is held). In this case the intention is that the SRO will be cancelled,
>> the spinlock dropped so the memory allocation can be completed, and then
>> the SRO restarted (obviously after rechecking the state that the
>> spinlock was protecting). For this reason the code stores the memory
>> allocations within a struct rmi_sro_state object - see the final patch
>> for more details.
>>
>> This series is based on v7.0-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
>>
>>
> 
> Hi Steven,
> 
> I have a question regarding host kexec and kdump scenarios, and
> whether there is any plan to make them work in this initial series.
> 
> Intel TDX and AMD SEV-SNP both have a firmware shutdown command that
> is invoked during the kexec or panic code paths to safely bypass
> hardware memory protections and boot into the new kernel. As far as
> I know, there is no similar global teardown command available for
> the RMM.

Correct, the RMM specification as it stands doesn't provide a mechanism
for the host to do this. The host would have to identify all the realm
guests in the system: specifically the address of the RDs (Realm
Descriptors) and RECs (Realm Execution Contexts). It needs this to tear
down the guests and be able to undelegate the memory.

It's an interesting point and I'll raise the idea of a "firmware
shutdown command" to make this more possible.

> What is the roadmap for supporting both general kexec and
> more specifically kdump (panic) scenarios with CCA?

I don't have a roadmap I'm afraid for these. kexec in theory would be
possible with KVM gracefully terminating all realms. For kdump/panic
that sort of graceful shutdown isn't really appropriate (or likely to
succeed).

There is also some RMM configuration which cannot be repeated (see
RMI_RMM_CONFIG_SET) - which implies that the kexec kernel must be
similar to the first kernel (i.e. same page size).

Thanks,
Steve
