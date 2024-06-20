Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0B81BA073
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 20:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913754; cv=none; b=FQ6IH5N4kVm86YjgtRYbo/IGYqLabQu2F9bTjPF3R5sCATp8YI9rHAMlz0wyROSwJo5aXtbDaqTe1WLG3fQDUJt/sHHf/BlUTNRz4Wy8jnXt+xV7zeYFfNdJ6Rbzmg4S7fLeZdfx0knYNgCQ2Rlp/im/V+SPmOCsg3y1HM9AFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913754; c=relaxed/simple;
	bh=VDY/dojho9FmUZgoyKFtZumvBLXJf1S7KMkLsL/WMRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l45Ou8lB52dkixxHdLG6wAKm3lR9nWozm2QYMOD0bKSaOUY3nkfrgWpqU11VziPMpTax1SmjF/1LTYFQunnlSrRrKj24jXouUnthQ89x4O9JzRhEVNvTP3NaqUxZNfLgqgcZMANgD14Kg/za2v9IcE0FK7akopUy14jaqzi2TXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E6J4tK5o; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E6J4tK5o"
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718913748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F12fg/sXDEkx3twihwscxjVtQ1sgpSri3JbwJrHWX4o=;
	b=E6J4tK5osGCoSaCL/hsQ2+dMba772o2+T7UazJMIUzA2JjXWH7nFYo5pVTM+z+wzVzQry6
	mAeusYyXVrlFlW9f+mjQISdILP6AKzNr/VQ13wqxWfF0ucayUHaA5Btp5YcH4PV2rqhF9I
	WOAsXihF0moT5In+y16htXBkF2XVUw8=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: tabba@google.com
X-Envelope-To: maz@kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 00/15] KVM: arm64: nv: FPSIMD/SVE, plus some other CPTR goodies
Date: Thu, 20 Jun 2024 20:02:19 +0000
Message-ID: <171891373622.1451089.1128648683109308549.b4-ty@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 20 Jun 2024 16:46:37 +0000, Oliver Upton wrote:
> v2 -> v3:
>  - Reorder patches to fix bisection (Marc)
>  - Use helper that returns ZCR_ELx offset, so it can be used to handle
>    reads and writes (Marc)
> 
> v2: https://lore.kernel.org/kvmarm/20240613201756.3258227-1-oliver.upton@linux.dev/
> 
> [...]

Applied to kvmarm/next, thanks!

[01/15] KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor
        https://git.kernel.org/kvmarm/kvmarm/c/d2b2ecba8ddb
[02/15] KVM: arm64: nv: Forward SVE traps to guest hypervisor
        https://git.kernel.org/kvmarm/kvmarm/c/399debfc9749
[03/15] KVM: arm64: nv: Handle ZCR_EL2 traps
        https://git.kernel.org/kvmarm/kvmarm/c/b3d29a823099
[04/15] KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
        https://git.kernel.org/kvmarm/kvmarm/c/069da3ffdadf
[05/15] KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
        https://git.kernel.org/kvmarm/kvmarm/c/b7e5c9426429
[06/15] KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
        https://git.kernel.org/kvmarm/kvmarm/c/9092aca9fe9a
[07/15] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
        https://git.kernel.org/kvmarm/kvmarm/c/2e3cf82063a0
[08/15] KVM: arm64: Spin off helper for programming CPTR traps
        https://git.kernel.org/kvmarm/kvmarm/c/1785f020b112
[09/15] KVM: arm64: nv: Handle CPACR_EL1 traps
        https://git.kernel.org/kvmarm/kvmarm/c/493da2b1c49a
[10/15] KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
        https://git.kernel.org/kvmarm/kvmarm/c/0cfc85b8f5cf
[11/15] KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/5326303bb7d9
[12/15] KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
        https://git.kernel.org/kvmarm/kvmarm/c/0edc60fd6e9e
[13/15] KVM: arm64: nv: Add trap description for CPTR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/e19d533126ac
[14/15] KVM: arm64: nv: Add additional trap setup for CPTR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/cd931bd6093c
[15/15] KVM: arm64: Allow the use of SVE+NV
        https://git.kernel.org/kvmarm/kvmarm/c/f1ee914fb626

--
Best,
Oliver
