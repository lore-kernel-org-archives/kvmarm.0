Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464BA346769;
	Thu,  8 Oct 2026 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449525; cv=none; b=NEgJGnEVwWOx4/Xfxlu15PBJeaUTESstKP+lxRIdWSuEuY8M/zlfr+fPd21R96sw23AwrRN463+X9Hiz3726inD4P2W9ww0HAcqwoweMyQW+QOJa8S6Ckj+iazco17UOSnnj/KaXN52hFu4rJ9jQcGYpgw1ojJwbxl3NSe62fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449525; c=relaxed/simple;
	bh=X072fEuKl2pqebo1yIskiav4B6oQoevvlg9BJsl+1zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djXTFQpN//zoYeVlOZmEFLpgW8oI/rDSZmIx+SR6Qz/VNxpzNq0c07+oRjf2yOTNJaZG4mksQSuOudS47SpLLTg6dDWtTbwQlsRVpjkFDqixfZgKIUZ2hWNKwK1Iu/A3BGyi++B/JZ/cZ54/aKaV1AqLPfo2Zr/C2eFWodyR8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FcFOF6yo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FcFOF6yo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1C051476;
	Thu,  8 Oct 2026 01:51:57 -0700 (PDT)
Received: from [10.57.10.184] (unknown [10.57.10.184])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD5033F763;
	Thu,  8 Oct 2026 01:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791449520; bh=X072fEuKl2pqebo1yIskiav4B6oQoevvlg9BJsl+1zA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FcFOF6yov50M43gMq00NFQk0QAaBq1r/HTi+aauN8hylw6FtKWQFC3JnYMgpOMxpV
	 p6yq7LD+lUNl//kIVCosM1EI9h1mB7tbiRmwoXAfDuO98j7UfJsSVtejyWHh++dv2v
	 3k6zBLtJOklseD1jlrbck3RHGUGr4ONIezBDHmmM=
Message-ID: <4cdd882b-832f-4968-9838-dcc29a899121@arm.com>
Date: Thu, 8 Oct 2026 09:51:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 13/14] KVM: arm64: Mandate VGIC v3 for pKVM VMs and
 Realms
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-14-suzuki.poulose@arm.com>
 <CA+EHjTy_1EekD472UH=CDSpC7oksdy3eS8AP0rPxKkhQ_PyXdg@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTy_1EekD472UH=CDSpC7oksdy3eS8AP0rPxKkhQ_PyXdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/10/2026 14:45, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Wed, 07 Oct 2026 08:35:36 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
>> pKVM does not trust the host. Realm VMs follow a similar trust model, with
>> the Realm Management Monitor owning the protected state instead of the
>> host. Add a helper to identify VMs that run under a host-distrusting
>> hypervisor.
> 
> When I reviewed this in v21, the Realm patches that use this came
> later in the same series. Without them, kvm_vm_hyp_is_distrusting() is
> true exactly when is_protected_kvm_enabled() is, and protected mode
> already doesn't register a GICv2, so this patch doesn't change
> anything on its own. Should it move to the series that adds Realms?

But the second part of the changes are required for pKVM today, right ?
and you requested that here. The check as such is useful, except that
it is using kvm_vm_hyp_is_distrusting() rather than 
is_protected_kvm_enabled(). I don't see this as a problem as this is
not a hotpath anyway.

https://lore.kernel.org/all/CA+EHjTzKjjEuAuoOuzGG0uKyVZE-r+CEreca2H2kEQYuRPpgUw@mail.gmail.com

Cheers
Suzuki>
> Cheers,
> /fuad

