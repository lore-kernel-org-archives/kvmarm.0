Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537BF2874FA;
	Wed, 22 Apr 2026 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776872344; cv=none; b=fNdodfCrUhl9reRrbWk9IDxj4tyr8AlCINOAcLOTA9k+ifxf2hRTxuz+XNP+fjclNwhxljCS0CszQbBbMDQELSUdja1098RH5E9pJl1BfQvrnbIGzatNplp00csCKXHDUYPHTgQHFbjTr5tBDUBHIpafxfbpqhBitD/gBdks148=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776872344; c=relaxed/simple;
	bh=Fz0I0zdiIejPqo2fAKgtSisMhx3AW0yDRfF1JcO1hXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6xLZQr/WCLdlmWFx7XVdDtVXPUq5/l9FoD5rAT4ugkJoXo3YjRnpDzjO4vz/aeQ3C/d6cBdzRKlCGpR5DPWIzOhYP5pEeBM1KHVd4HyJBMXXwpwwfm/7KAomBl+aGVh+2qQvwdkBi8aND8ZAzJSCgEwjNaluSAPP6Lg+z3Dorw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BZINp1L1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BZINp1L1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBD571F91;
	Wed, 22 Apr 2026 08:38:55 -0700 (PDT)
Received: from [10.57.32.235] (unknown [10.57.32.235])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF6DE3F8C6;
	Wed, 22 Apr 2026 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776872341; bh=Fz0I0zdiIejPqo2fAKgtSisMhx3AW0yDRfF1JcO1hXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BZINp1L1XdBSrjIHRvb4H2Iv16+MM4n2gTpPZqbFR+wEP5MiLzcvOi51Qfxb0Gkgm
	 IqRuVK5wHQCKCQ2rN8MeGr2NyCbM/PH5fjSTuwwi+UODPfWinLpHFI11tOI8dRLwZF
	 1SBxy806RBkOJB1+oFVWfjVzSvnY4w4lruszIoWw=
Message-ID: <49681ba6-da62-4d1b-8f82-34a6488abe97@arm.com>
Date: Wed, 22 Apr 2026 16:38:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Jiahao zheng <jahao.zheng@gmail.com>
Cc: alexandru.elisei@arm.com, alpergun@google.com, aneesh.kumar@kernel.org,
 catalin.marinas@arm.com, christoffer.dall@arm.com, fj0570is@fujitsu.com,
 gankulkarni@os.amperecomputing.com, gshan@redhat.com, james.morse@arm.com,
 joey.gouly@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 sdonthineni@nvidia.com, suzuki.poulose@arm.com, tabba@google.com,
 vannapurve@google.com, will@kernel.org, yuzenghui@huawei.com
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260421135145.14789-1-jahao.zheng@gmail.com_quarantine>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260421135145.14789-1-jahao.zheng@gmail.com_quarantine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/04/2026 14:51, Jiahao zheng wrote:
> Hi Steven,
> 
> I've been testing CCA patch series and noticed Realm VM cannot boot successfully when the host is forced to run in nVHE mode (e.g., via `kvm-arm.mode=nvhe`). The kvmtool debug information will be truncated in set_guest_bank_private_gpa. 
> 
> Currently, in `kvm_ioctl_vcpu_run()`, running a Realm VM (REC) bypasses the standard nVHE EL2 stub. `kvm_rec_enter()` directly executes the SMC instruction to transition to the RMM. Upon returning to the EL1 host, the code falls back to `kvm_vgic_sync_hwstate()`, where the VGIC save operation is explicitly skipped for nVHE. Since the EL2 stub was bypassed, `__vgic_v3_save_state()` is never executed, and `ICH_*_EL2` states are lost.
> 
> To resolve this, I have a couple of thoughts:
> 1. If Host nVHE mode is not intended to be supported for Realms:
> Since RME implies ARMv9 which mandates VHE, running a Realm with an nVHE host might just be an unsupported edge case. If so, we should explicitly reject RME initialization or REC creation when `!is_kernel_in_hyp_mode()`. This would cleanly prevent the undefined behavior.
> 2. If Host nVHE mode is intended to be supported:
> Since RMM should remain agnostic to the Non-Secure VGIC states, the burden of saving these states falls strictly on KVM. However, the EL1 host cannot access `ICH_*_EL2`. Therefore, KVM needs to add specific logic for this scenario. We would likely need to route the REC exit through a dedicated nVHE EL2 stub to invoke `__vgic_v3_save_state()` before dropping back to EL1, rather than jumping straight back to `kvm_ioctl_vcpu_run()`.
> 
> I might have missed some documentation or comments regarding nVHE restrictions for CCA. If this is an oversight, it would be great to see a check added in the next iteration of the series.

Thanks for the testing. Yes indeed this is an oversight. For now option
1 is what I'm going to go for. There's nothing stopping nVHE mode being
supported but as you note any platform with RME will have VHE so it's
not an immediate priority to support.

One interesting case of nVHE is of course pKVM and for that there needs
to be some significant work to ensure that the EL2 hypervisor
understands the RMM communication and prevent any confused-deputy style
attacks. E.g. the host must not be able to map a pVM's private memory
into a realm guest.

I don't have any immediate plans to work on nVHE - my focus is getting
the basic support merged. But I know there was some interest to ensure
that pKVM and CCA would be able to co-exist on a platform so I expect it
will come in some form or another.

Thanks,
Steve
