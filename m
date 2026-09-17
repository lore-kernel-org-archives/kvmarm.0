Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DFB49EC5E
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644306; cv=none; b=NFhaBRCbsg+X1qO0B5KIQZ3DpMVK8HBJe9D4KgLEQljmbox+r2CGMmoFiJrfQXJqTu791FhrZ0rtLNfB9Xr4RdJrcHxOlwF54l1Hqyfy5AIg3ghb0ZC9WoQmK/guke3u7wtwFYX+ZTyGcenXE3kAXwl5CCRyD6ZRoSxrR0hb37o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644306; c=relaxed/simple;
	bh=6cLtGQr3NeN6cuI+wwoUX8J3Vbq5/m8fhyoeTXSQu5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jPfSbfP6rnahJ9o6Yo4dXL1Su40LhH+nPCp0CQlAdeUFlJ6u4+HTeDjJG75d1VDdkWR/0W1Myszv6grRidAseagxLewgv9+Jk4RoA+8LmngRvuY6nQoqXKz3ZLYu94Wiq4h6K/r3cAn6GLNn2K/A2ewtUG07Svugifa0YsaMEHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qC9k0bfm; arc=none smtp.client-ip=91.218.175.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qC9k0bfm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6cLtGQr3NeN6cuI+wwoUX8J3Vbq5/m8fhyoeTXSQu5k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789644302; v=1; x=1790249102;
 b=qC9k0bfm/iQfsofJonIYzADcO87fOSekzQP2hDmHHo8izbCSh6qJzz4uJ8x/vWOaFr/tiKHi
 C44LZxPIuPK15c9ZEvUAesJbjhWPoDNWblUYMf463VuA+GhudcCQ3OMXj1Fr934agqq4rRg6an4
 tIhlmm1Xbn2lePWHK9qsM+N4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1b45eebb5321840a;
	Thu, 17 Sep 2026 11:25:02 +0000
X-Mizu-Trace-ID: 1b45eebb5321840a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso867e87.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 04:24:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzBjP1EOi8l2dcarD3+04phGKVrgQ4DkHCJZAqB5L1tSD8sVYURD+qS/Xs/c1MmyFS50gfgboY=@lists.linux.dev
X-Gm-Message-State: AFuF++ndnPp53nW7UthQfOlqsQcebbZIIl38QE2+kaeXsweHoivckWHJ
	q0OH2Y64t5ozSXmB8TjbhZoLHkRDnFRo/3SsFEfubSDzUIcrNyp7uFVEb61KpyvtinbwIBojKQY
	/R/dE9mPaSWY57jrVjGzVw4CRQ+4vyMKjSLzEZNEz
X-Received: by 2002:a05:6512:3054:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8bff4a5d7mr13058e87.15.1789644298430; Thu, 17 Sep 2026
 04:24:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-6-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-6-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 17 Sep 2026 12:24:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
X-Gm-Features: AcwNN1VFMe-nqpetX5NFULE-T8FsNAG-h344sw-wYzui_i8Ztl6ucWB9ep0N7uI
Message-ID: <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
Subject: Re: [PATCH v18 05/23] KVM: arm64: Track the type of VM in kvm_arch
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 15 Sep 2026 17:01:23 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
> +#define kvm_vm_hyp_is_pkvm(kvm)                (is_protected_kvm_enabled())

I'd keep is_protected_kvm_enabled() at the three call sites: this
takes a VM and ignores it, so it reads as per-VM when it's the mode,
and patch 20's comment about not being able to use the kvm_vm_ helpers
with a NULL kvm goes away too.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[...]
> @@ -432,7 +432,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>
>          hyp_vm->host_kvm = host_kvm;
>          hyp_vm->kvm.created_vcpus = nr_vcpus;
> -        hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
> +        hyp_vm->kvm.arch.vm_flavor = READ_ONCE(host_kvm->arch.vm_flavor);

Could EL2 reduce this to VM_PKVM or VM_PROTECTED_PKVM here instead of
storing what it reads? The host supplies the value, and it's now an
enum rather than a bool. Patch 12 relies on EL2 only ever seeing those
two, and with VM_REALM above the marker a host-written value passes
kvm_vm_is_protected() but not the == form, if EL2 ever adds one.

Both hunks are new since v17, which is where I gave the Reviewed-by.
Happy to keep it if you can settle these please.

Cheers,
/fuad
