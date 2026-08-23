Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783F4361651
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499593; cv=none; b=DgSH8w2cDChIUVd0wCwKW9juBq+1eu98zCyb20LR2vPJF3+QZI3DYziHncHeU/4Y2Qb9h+dJmTJ8U0EXh+3LSbtiJNvTbyPiYGk5QW8pLFtx3sSY2JrK86DdvDYvAfy9L/KVjMVMYdAyXpRuYQE4IfDQaRZYV3PZxsKOTD+Tbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499593; c=relaxed/simple;
	bh=W0TlGb6F34q6Kl5UWG4lZXAn8pUN8AHkhRFYqa9i08k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=leIqd7GsJSXjxbBaU5FUygmk4hGzE6VUH/JpD1SMnWdVc+zy50F4ORpfBIRfJJKp3t037/98w/TWPOtzlPe7Y2l0q1NeZcIFQqQm7NAq6qnLoFikpdGZqWgcSPJzWAWDIfKuty2BDMueNTMmPl5PaVV/LO5KDAuB58TB6ZxAlHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b/tRiIGP; arc=none smtp.client-ip=91.218.175.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b/tRiIGP"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W0TlGb6F34q6Kl5UWG4lZXAn8pUN8AHkhRFYqa9i08k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787499588; v=1; x=1788104388;
 b=b/tRiIGPdhOV0e2DLocmqNoU8j0p0drjU2CPlRJIZrzTerB20k9WOvIinMsw8wQdXq5vq8IG
 CzdgnLcwL0ha6AdSJL2+WHwsoFhqdt2HW5sJ1KrFUW48YJPOyECthSAOXsl4ag8QjNTlfnsjYJD
 FnYU1Voj6d3HjEZLvzov/oU4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f51.google.com (209.85.167.51)
	by smtp.migadu.com with ESMTPS id 206daab687205f87;
	Sun, 23 Aug 2026 15:39:48 +0000
X-Mizu-Trace-ID: 206daab687205f87
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b2a8173142so5440e87.1
        for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 08:39:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrtpscNZHHK6AKxHGLMgm5YyeMWg5aWm8tenccascdkDG+BhYPv1ks4vJeVFtYr4d+YrQ8TSpA=@lists.linux.dev
X-Gm-Message-State: AFuF++nIUEYhm/0QXN1oWEHyO6BYrkHiMr3h3/aN6HvpziHcyPAjdBIX
	s1BypLBpJDRVMrNyyGNNdTId7IR6SR0JE1BrGvuQ0r6aFXHuIdPB6HtgOPXrERzTJ/K/NMzdmSB
	MHzEkVhDeNA99Fcdy6764ij4Q+NpebRwM8H6rwaKC
X-Received: by 2002:a05:6512:1093:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b48c2f784amr130059e87.3.1787499583194; Sun, 23 Aug 2026
 08:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260822095346.53882-1-kmehltretter@gmail.com>
In-Reply-To: <20260822095346.53882-1-kmehltretter@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 23 Aug 2026 16:39:06 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwcJ7zvw5bgqmt2-OiW7q01Vwm3rn1gTFn-39Lu4qDWJg@mail.gmail.com>
X-Gm-Features: AcwNN1U6KyA3LCwgTCyTTj8u2ge9LgDR8EDiemOl63d62mt3Rz0sod8kkzdxcH4
Message-ID: <CA+EHjTwcJ7zvw5bgqmt2-OiW7q01Vwm3rn1gTFn-39Lu4qDWJg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: fix VGICv3 redistributor rollback
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Karl,

On Sat, 22 Aug 2026 at 10:53, Karl Mehltretter <kmehltretter@gmail.com> wrote:
...
> Testing: built the patched kernel and the arm64 vgic_init selftest with
> GCC 13.3.0 in an arm64 Linux container. The selftest passed under QEMU
> 11.0.2 TCG with -machine virt,virtualization=on,gic-version=3 and -cpu max.

Applied this on kvmarm/next: protected and non-protected guest boots
under pKVM, plus VHE and nVHE, and the vgic_init, vgic_irq and
vgic_lpi_stress selftest. Also built the base with only patches 4-5
and confirmed the new test fails without patches 1-3.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
> Changes since v2:
> - Patch 1: limit free_index rollback to the immediate registration failure
>   under slots_lock instead of generic unregistration. (Sashiko)
> - Patch 2: reset all assignments and region counters after a failed region
>   update (Marc), and serialize REDIST and REDIST_REGION writes with vCPU
>   creation so rollback cannot miss an unpublished assignment.
> - Patch 3: add an already-locked unassignment primitive, move failed-vCPU
>   cleanup to kvm_vgic_vcpu_destroy(), and remove the redundant base_addr
>   reset. (Marc)
> - Patch 4: match vm_create_with_vcpus() by using void * for the guest-code
>   argument. (Sashiko)
> - Patch 5: document how the first three redistributors span regions 0
>   and 1; no functional change.
>
> Previous version:
> v2: https://lore.kernel.org/r/20260819224229.82948-1-kmehltretter@gmail.com
>
> Karl Mehltretter (5):
>   KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
>   KVM: arm64: vgic-v3: Reset redistributors after failed region setup
>   KVM: arm64: vgic-v3: Separate redistributor teardown from unassignment
>   KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
>   KVM: arm64: selftests: Test VGICv3 redistributor region retry
>
>  arch/arm64/kvm/vgic/vgic-init.c               |  46 +++----
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         |  20 +++
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  83 ++++++++-----
>  arch/arm64/kvm/vgic/vgic.h                    |   1 +
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 116 ++++++++++++++++--
>  5 files changed, 200 insertions(+), 66 deletions(-)
>
>
> base-commit: 57e7cf13ac26bf1a3dba6cfa601f7b2481811575
> --
> 2.39.5 (Apple Git-154)
