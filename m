Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755AA3F3270
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198108; cv=none; b=LrsockQnvbBoNHGg/yCA7815m/zOn5294qbmMO3V/g9/CnddPNxZbOU6xdEK2i3e6qC9/V6n4SjE4aN9zyzAvtAlFMC2HDl1D2kzyOqc4vJZN5J/PNfWDZgyNSBpX3WFWhhHHAZL1NdlsBTvkiG2KEuGnTUJWkmiWKH2vj5BWhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198108; c=relaxed/simple;
	bh=m0WRfgoLVvWLfWPyz2JueBfGJeA6C308a9osjAlqI2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHMaDkAFmdFSuNImcDQCb1Fu3FUVAMkkKRBWyvw8ZFy5wt2gJHqDHNlNy5Ud4o3zRzsK744NpCF4eSlgkt7h/cuA/lLo+2/U8HcsS/kFuCzoQeM8LsZe2UxvLI3bIzQgr6TUaPnK82/gKrF8E8H/QuMFXCfOqsVRDVWomePrt14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sJyCGdWf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sJyCGdWf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1C8816F2;
	Sat, 12 Sep 2026 00:28:19 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0771D3F7D8;
	Sat, 12 Sep 2026 00:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789198103; bh=m0WRfgoLVvWLfWPyz2JueBfGJeA6C308a9osjAlqI2Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sJyCGdWf6QPD5xCxlFPe9fTeju5xiEEnFlo5+A27EXgp5BaWCMYC2O0RLoob+wvFv
	 Isg60tB4E1FM1gGzFqRskYrKuj85QhYLCgwXj1UCuYu9/cVf7zViQZ4c8HT86GS3bz
	 wC13szR9/bZZcy+Df48kKY8E3YOemXR1GCoCeav4=
Message-ID: <8d3b510e-d176-492f-8039-6c4c353117ba@arm.com>
Date: Sat, 12 Sep 2026 08:28:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 4/5] arm64: Query steal-time support on the VM fd
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-5-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260831192406.1341841-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 20:24, Fuad Tabba wrote:
> kvm_cpu__setup_pvtime() probes KVM_CAP_STEAL_TIME with
> kvm__supports_extension(), which issues KVM_CHECK_EXTENSION on the
> global /dev/kvm fd. That reports the host's raw capabilities, unaware of
> any per-VM restrictions.
> 
> pKVM does not offer steal-time to a protected VM, and reflects that on
> the VM fd alone. kvmtool goes on to KVM_HAS_DEVICE_ATTR, the kernel
> refuses the PVTIME attribute with -EPERM, and kvm_cpu__arch_init() dies:
> 
>    Fatal: Unable to initialise vcpu
> 
> Query it on the VM fd via kvm__supports_vm_extension(), as
> commit 84464ba0246b ("arm64: Query per-VM capabilities when selecting
> vCPU features") did for the vCPU feature probes. kvmtool then takes the
> no_pvtime path it already has when steal-time is unsupported.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arm64/pvtime.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arm64/pvtime.c b/arm64/pvtime.c
> index 2933ac7..839aa8a 100644
> --- a/arm64/pvtime.c
> +++ b/arm64/pvtime.c
> @@ -58,8 +58,8 @@ int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
>   	if (kvm_cfg->no_pvtime)
>   		return 0;
>   
> -	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> -						  KVM_CAP_STEAL_TIME);
> +	has_stolen_time = kvm__supports_vm_extension(vcpu->kvm,
> +						     KVM_CAP_STEAL_TIME);
>   	if (!has_stolen_time) {
>   		kvm_cfg->no_pvtime = true;
>   		return 0;

