Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831002EB10;
	Mon, 30 Mar 2026 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774868293; cv=none; b=JnUTnOpJy7wzyIXafe3ji21bBpns8Acrzjt8XlDLp3V1q5mbliLiVfDUELuzJW0sBSk7hgAY+ez3H3Lo7vbQgV8Q+D6wTTZ9KNPv8VwrAiqrgMP2oIml6ls/6bC8PLI1orLa5thldkECiEAjtm8s/KzzRIiFLusj09oHLbFe4jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774868293; c=relaxed/simple;
	bh=mONBCtbmbPff0A3dabS2nwwbs9ct9e5u1BA9P4VrR5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JtqPYMoRSgarA0T9Zp3OjKx6WJZNJzaHy6NVs1bZacXwhyB7Ef3erMf2q6QSlPjFrrvf5wGBVDFT7o5+JkRMtLMFFYYG7MHaCNLDNBiRDz3td7nZ42E8QTAQwwUIcbtJurphoiI5iO4AACt1w2YSEJKGH3aehKF/s2eY7Uba3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O7cDYZFH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O7cDYZFH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B3351C01;
	Mon, 30 Mar 2026 03:58:02 -0700 (PDT)
Received: from [10.57.13.56] (unknown [10.57.13.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D4A13F915;
	Mon, 30 Mar 2026 03:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774868288; bh=mONBCtbmbPff0A3dabS2nwwbs9ct9e5u1BA9P4VrR5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O7cDYZFHXEzuxS8cQTR9gIEc1iShETlDG4sQ/XazlOkV5Mry75J+eICB0NiKv1k8b
	 vleJTNMbKT4ovAUQsnrDoU09OL258RoFomntVNwjHtTcFp2F0bgoQYw7qTcvmA15iV
	 0fBuYUY/dJ4ycbTn4G3WwWoi/4cWPdqxRX0+03BQ=
Message-ID: <053a048d-bcb7-46ef-a4c2-c5d0c84a3177@arm.com>
Date: Mon, 30 Mar 2026 11:58:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 34/48] arm64: RMI: support RSI_HOST_CALL
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-35-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2026 15:53, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Forward RSI_HOST_CALLS to KVM's HVC handler.

Minor nit: Please could we add a line or two, explaining what 
RSI_HOST_CALL is ? e.g.:

Realm's can talk to the hypervisor using the RSI_HOST_CALL, which
the RMM forwards to the KVM. Handle them as regular hypercalls.

Suzuki

> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v7:
>   * Avoid turning a negative return from kvm_smccc_call_handler() into a
>     error response to the guest. Instead propogate the error back to user
>     space.
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rmi-exit.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
> index b4843f094615..7eff6967530c 100644
> --- a/arch/arm64/kvm/rmi-exit.c
> +++ b/arch/arm64/kvm/rmi-exit.c
> @@ -116,6 +116,19 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return -EFAULT;
>   }
>   
> +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu->stat.hvc_exit_stat++;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	return kvm_smccc_call_handler(vcpu);
> +}
> +
>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -183,6 +196,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>   		return rec_exit_psci(vcpu);
>   	case RMI_EXIT_RIPAS_CHANGE:
>   		return rec_exit_ripas_change(vcpu);
> +	case RMI_EXIT_HOST_CALL:
> +		return rec_exit_host_call(vcpu);
>   	}

Probably we should move the RMI_EXIT_HOST_CALL case addition in 
kvm_rec_pre_enter() to this hunk to keep all in one place ?

Otherwise, looks good to me.

Suzuki


>   
>   	kvm_pr_unimpl("Unsupported exit reason: %u\n",

