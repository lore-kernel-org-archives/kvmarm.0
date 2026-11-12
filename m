Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476499;
	b=pnJOtCmeHjH8T5SC3v+VsIRVymX7xvKRPGfM09HVPzVr+Ipk4gxzgYCoW+GxtHfY8sso
	 4Y/kXcCmtMGEbptXi23fNrncgo/U2bRp8Wta7yYIWQ7tclwYUO7SfwlwSqD2qufRvMEe6
	 b2qlm+iJvevPZ5uej7v5z9AkrM+ze9sN3eIyvNGxIt1eV9uGgnKPjtK17Uht2/2iSq0R3
	 aTAeQxud4Vk4ZBto/eZqJqLSOL2/MDoh4FdjEKqtmjhlcUYY+SEDU0HrP2Bx8zttaNnKd
	 LMUCb4j6j/Fkg7kapx+ltBJDTLbXk1Nu61TILYMKHFAUzjuRL44CpjxOLSoxLWMsetg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476499;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=220ugqDuyQyPHtA/XrNCqAcUUimFC+lFQ4mNPAn6NRA=;
	b=aWGBEVJi5H7hoL9o6vkBWT3vu/GgfSrl6lhfRKDlGgOsQkkoGJ8eElocApMvjPJesfez
	 vOKFZSud8j/1BBgEkGaXQV+QR/TJqdhUv7wus7R9elye2M2IJQiLJxVcdJI8zlHNdfSHM
	 SzIt5t2NQGUB7KJ8ckxDekvz5buujrzmH2OKpabWKZoNMgZqZ3wjLV//w6p8zFs9oJ4Vj
	 S8/CpWQD0J3D+EMiqOfMx7lywaIzyA40JfZ6tVDfx5hQ7a61g/O+HA1pyKImbJQlPAxoF
	 fI4vALLV1AqIAa/JZ47F+LJJR+zluc2scD7FDEz0/qHihNnTxV/A1T1o5BlcGcK03wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="vmzj/Kff";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D78606A886;
	Thu, 12 Nov 2026 09:41:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5D78606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vmzj/Kff
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09344153B;
	Thu, 12 Nov 2026 01:41:35 -0800 (PST)
Received: from [10.0.129.47] (e122027.cambridge.arm.com [10.0.129.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C443D3F632;
	Thu, 12 Nov 2026 01:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794476498; bh=wsUciV+efeTQCIVGRFWUTHzo6OWjjig7oVL2Hlvu3Do=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vmzj/KffMUnSTgxJ9oWy92AHHsu+KlvSL1PYaGD6G5XriiSu8w8KE7KGTzZaTN6U5
	 CER5uSOeYHgUJTU2rmyJyLEMApaNv/fSaEtfVj0gBCjwmC88P/COYdfHvGwPi1GTMG
	 BNkhuxNjxLgDR3CtZUwX6xR3qq/K74GnFMcPcVQY=
Message-ID: <a25321ce-7593-4c75-a529-e19c273638ef@arm.com>
Date: Thu, 12 Nov 2026 09:41:26 +0000
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
Subject: Re: [PATCH v2 00/12] KVM: arm64: CCA: Prepare Realm memory management
To: Kohei Enju <enju.kohei@fujitsu.com>
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
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261111145758.217946-1-steven.price@arm.com>
 <avV-P2_fOkFWQVnM@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <avV-P2_fOkFWQVnM@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/2026 09:08, Kohei Enju wrote:
> Hi Steve,

Hi Kohei,

> On 11/11 14:57, Steven Price wrote:
>> This series adds the memory management plumbing for CCA, building on the
>> basic RMM support [1]. Thank you to those who reviewed v1 - I'm
>> attempted to address all the comments.
>>
>> The patches introduce internal Realm VM state and RMI feature checks,
>> prepare Realm stage-2 setup and teardown, and provide RTT mapping and
>> invalidation helpers. Realm memslots are restricted to the lower half
>> of the IPA space because the protected and shared halves alias each
>> other. The final patch connects the helpers to KVM's stage-2 MMU
>> operations.
>>
>> This is the memory management portion of the larger Realm host series.
>> Realm descriptor creation, REC entry and exit, activation, and the new
>> uAPI follow in the integration stack. This series alone does not enable
>> Realm creation.
>>
>> As before there's an integration branch[2] that includes the realm
>> creation, REC entry/exit etc building on top of this series. I've also
>> pushed a git branch[3] of just this series.
>>
>> Changes since v1:
>> - Add a guest_memfd prerequisite patch that checks whether the backing
>>   file supports mmap when preparing an arm64 memslot.
>> - Combine the RMI availability and feature checks into one patch, and
>>   move Realm vCPU feature restrictions to the integration stack.
>> - Correct Realm IPA sizing and RTT teardown, including teardown before
>>   activation, RTT accounting, and handling of missing or folded RTTs.
>> - Rework RTT mapping to respect IPA and physical alignment, handle
>>   partial RMI progress, and retry interrupted operations.
>> - Preserve private mappings when a Realm guest_memfd memslot deletion is
>>   rejected, and tighten Realm fault handling and stage-2 destruction.
>>
>> [1] https://lore.kernel.org/all/20261007073537.2454351-1-suzuki.poulose@arm.com/
>> [2] https://gitlab.arm.com/linux-arm/linux-cca
>>     branch: cca-host-mm/v2/integration
>> [3] https://gitlab.arm.com/linux-arm/linux-cca
>>     branch: cca-host-mm/v2/mm
>>
>> Steven Price (7):
>>   KVM: arm64: CCA: Reserve the RMM mode
>>   KVM: arm64: guest_memfd: Check mmap support when preparing memslot
>>   KVM: arm64: CCA: Check RMI support and features at init
>>   KVM: arm64: CCA: Add basic infrastructure for creating a realm
>>   KVM: arm64: CCA: Tear down RTTs
>>   KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
>>   KVM: arm64: CCA: Support runtime faulting of memory
>>
>> Suzuki K Poulose (5):
>>   KVM: arm64: CCA: Introduce Realms
>>   KVM: arm64: Handle attributes in stage2_unmap_range
>>   KVM: Allow architectures to reject memslot changes before invalidation
>>   KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>>   KVM: arm64: CCA: Add Realm stage-2 MMU operations
> 
> I've tested the integration branch [2] including this series on our
> hardware using the QEMU-VMM proposed in:
>   https://lore.kernel.org/qemu-devel/20261002202026.1204110-1-mathieu.poirier@linaro.org/
> 
> The Realm guest VM (32 vCPUs, 16 GiB RAM) booted successfully. To
> exercise the guest with a more realistic workload, I also performed a
> full Linux kernel build, which completed successfully.

Awesome - thank you very much for testing.

> A Tested-by tag might not be carried over to the next revision, if any,
> but anyway, for this series:
> 
> Tested-by: Kohei Enju <enju.kohei@fujitsu.com>

Thanks,
Steve

