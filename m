Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F3237B3FE
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788015888; cv=none; b=dtkq5y2HhVAeXOBT6jz6541jQ70WS9ou8Qs/vIrNHtk+9Rj2L4rDBq2c4ktIxkCREGTjGUGtga0MQfODm0OI0Whw3q6iIaQaI0iNjKsjreloteZJ6rgsL5bjKUCBTt+2I7MudRbqAuVvqwXTRKZKm8YVonrFfkoQ3OgKajwRZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788015888; c=relaxed/simple;
	bh=x/JQhwvlkrIqW5ek4nBfeiZRWKci9ObkZOfoQkBKemw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZtW9kbfURxLJ0vk3HqnWJlIHu5RXoPZ+NTHLpGq+NxoZ/0HP0++CCz9mdAHUqW4qfwx+sIL6XyYZnyEHlAE74Gw+9KbXbIRSIhloQGJU3YSeAuuPEPE4Bmv62BjPVfA+pqBBcnWutwr0pHRD9QxnvAGrZldU+1DzLrugJiHbJz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vmOOca88; arc=none smtp.client-ip=95.215.58.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vmOOca88"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=x/JQhwvlkrIqW5ek4nBfeiZRWKci9ObkZOfoQkBKemw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788015883; v=1; x=1788620683;
 b=vmOOca88C6VacUde8CsXaCakOIRVdUcCZ2aMnUdmdfb7AV/KrCsPLz3jG+15EzX0t278MYAl
 VnbyvmXDhAfAOZuwu1B2BrDe6F3jucgPjZKhy6wPPBYYCanBkO67uYUN/GeiZofsOkDNaNWrxdq
 1NiFlYtBuH2w1o3xos0Gt9CQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 30ca0acdabe8d465;
	Sat, 29 Aug 2026 15:04:43 +0000
X-Mizu-Trace-ID: 30ca0acdabe8d465
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so4205e87.0
        for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 08:04:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzoo9SDumvtcE2sblYNs6kNnzI6pXUXsFwGqBtobpTf7Tmb1iLyosXulDIaYuvXfuJ35ig+Z+c=@lists.linux.dev
X-Gm-Message-State: AFuF++kLtnACQ6yRegtKDxCJ4PoMucEdSR+0HkD+hk1igKEDY0KvSaGQ
	Oto6KOjkaxAl6fLgZGHL8p0yFCmD54GXPLypQuIe/vNj6nsQyerL8NwnkS3K0hEQauuK5PEi77Q
	srQ+atKZOfGY6gqwcBWKQS/vx1B6Nkj6VNO6hfT7p
X-Received: by 2002:a05:6512:224a:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b5ef1fb727mr121680e87.8.1788015877648; Sat, 29 Aug 2026
 08:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260829054856.70549-1-kmehltretter@gmail.com> <20260829054856.70549-2-kmehltretter@gmail.com>
In-Reply-To: <20260829054856.70549-2-kmehltretter@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 29 Aug 2026 16:04:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzQM0bf1x2X-Y+eMmUHSYUmJXpt_jQ4Csu7JpkjtFT72Q@mail.gmail.com>
X-Gm-Features: AcwNN1WqEb1cXih1LXw2p4NMTSnPI5p1Ks0puLT5RmXOdUojQc3MhAEKYKD99sE
Message-ID: <CA+EHjTzQM0bf1x2X-Y+eMmUHSYUmJXpt_jQ4Csu7JpkjtFT72Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter
 range at base 0
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Aug 2026 at 06:50, Karl Mehltretter <kmehltretter@gmail.com> wrote:
>
> kvm_smccc_set_filter() only rejects a range if its inclusive end,
> base + nr_functions - 1, is below base. That catches an empty range
> (nr_functions == 0) at every nonzero base, but at base 0 the end wraps
> to U32_MAX and KVM tries to insert [0, U32_MAX], which overlaps the
> reserved Arm Architecture Calls ranges. KVM_ARM_VM_SMCCC_FILTER then
> returns -EEXIST instead of the -EINVAL that the smccc_filter selftest
> expects for an empty range.
>
> Reject a zero function count explicitly.
>
> Tested with a userspace reproducer on an arm64 VHE host under QEMU TCG:
> EEXIST before, EINVAL after.
>
> Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
> Assisted-by: LLM

nit: this should be `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1]
[TOOL2]` rather than LLM

> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

I think Sashiko is onto something, but that's for another day.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/hypercalls.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b11b8821c9fb..dfa25bb6f25d 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -185,7 +185,8 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
>         start = filter.base;
>         end = start + filter.nr_functions - 1;
>
> -       if (end < start || filter.action >= NR_SMCCC_FILTER_ACTIONS)
> +       if (!filter.nr_functions || end < start ||
> +           filter.action >= NR_SMCCC_FILTER_ACTIONS)
>                 return -EINVAL;
>
>         mutex_lock(&kvm->arch.config_lock);
> --
> 2.39.5 (Apple Git-154)
>
