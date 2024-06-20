Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8D21B3F0E
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906215; cv=none; b=DlWcrcJZZ4x/WhnzLKRn/23RSPjR8L2BGj/Lt+lK+fSedppc+S3efSkwjEbKg9VTzhXBC6w64qQpPYBKXYc3wKNTadhjg/HYmJvKT/rvIF0UELslrhfjNNYQjOHTUo0XRYavjs8H0+PqhEVR43Wbo8BlzOEUMY1IuBN3do27RW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906215; c=relaxed/simple;
	bh=n6hp3k8lcxVbdJ0uskAlN68BSftj7G3bOsoW4GJLVwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvuW8DzKDrEhTbnY298WFXzYuCjLwskVn4uDXgeNwTcNVKdrRf09L2RAggxiljpSiEj2+pUKXNSgiMU/a+0OwiJo1IPdHVJZNe8rLCBmrpey7IAocf7AmAcoKTIN/XZT8dCw0GcbUCGa7e4U5RVon9svJ8UGxNfBkxIImeYvElc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t5PwznC8; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t5PwznC8"
X-Envelope-To: linux-arm-kernel@lists.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718906211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lH0FjWkUa2NvWTCtcK+z1I9epAtrzoNKr6kLos2zCLo=;
	b=t5PwznC8Zl8XZnPHBFzzbsydv54dtlIBVsYd79nLKsRtGnSbJtk1JTdIDayOXmDQ4r4K1z
	WlSvflqF3+smQNYARRAd1epXxCw1iaw2mb38Ke7HMaXYJojMZorODlmdn0cAe1ZiMzvMgw
	BhMfAhuUIOpWSakM0afhgyjUQh7IJgY=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: ptosi@google.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: vdonnefort@google.com
X-Envelope-To: will@kernel.org
X-Envelope-To: maz@kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 0/8] KVM: arm64: Add support for hypervisor kCFI
Date: Thu, 20 Jun 2024 17:56:40 +0000
Message-ID: <171890618315.1290599.7143742839497338484.b4-ty@linux.dev>
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
References: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 10 Jun 2024 07:32:29 +0100, Pierre-Clément Tosi wrote:
> CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
> runtime type checks before any indirect function call. On AArch64, it generates
> a BRK instruction to be executed on type mismatch and encodes the indices of the
> registers holding the branch target and expected type in the immediate of the
> instruction. As a result, a synchronous exception gets triggered on kCFI failure
> and the fault handler can retrieve the immediate (and indices) from ESR_ELx.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/8] KVM: arm64: Fix clobbered ELR in sync abort/SError
      https://git.kernel.org/kvmarm/kvmarm/c/a8f0655887cc
[2/8] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
      https://git.kernel.org/kvmarm/kvmarm/c/ea9d7c83d14e
[3/8] KVM: arm64: nVHE: Simplify invalid_host_el2_vect
      https://git.kernel.org/kvmarm/kvmarm/c/6e3b773ed6bc
[4/8] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
      https://git.kernel.org/kvmarm/kvmarm/c/4ab3f9dd561b
[5/8] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
      https://git.kernel.org/kvmarm/kvmarm/c/3c6eb6487693
[6/8] arm64: Introduce esr_brk_comment, esr_is_cfi_brk
      https://git.kernel.org/kvmarm/kvmarm/c/7a928b32f1de
[7/8] KVM: arm64: Introduce print_nvhe_hyp_panic helper
      https://git.kernel.org/kvmarm/kvmarm/c/8f3873a39529
[8/8] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
      https://git.kernel.org/kvmarm/kvmarm/c/eca4ba5b6dff

--
Best,
Oliver
