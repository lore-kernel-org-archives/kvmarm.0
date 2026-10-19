Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5654E9C37
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792410252; cv=none; b=mE/4jMFu6iHkwR/aojifwy1WHhRmCEOdVI1A2Ge3dQeqhcNhGaUaQ2v+z0YFs8nXPr/k4sUPtXPIaA6HQrVTWfjpWqBAfaUwr2K9binevhnHpXnYku6I/cMcLFHAw7ytyZ10YKjLduXuNkAmR5j8S5Z1XmNWaEjr7l2dZwu/N5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792410252; c=relaxed/simple;
	bh=EEqi+37BMeU0EiUbFlxcrBA6Sxfs7ueAIK77z1KnAV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7trHyDf7GEi9gTxMMWUIwLOZWUqgdCviayPZvFRBpLDdzWG4QOlFMBf5oAJKY8Lz402Dc+stqYngOtJb6ArCjXriVL7HPr2xkP6VdLPoV8kq50C//EaJ0I7Hg6JopmirQsWKgKT/HGhU3AEZgsWzOawIFUryBDQgVjXKlwY2r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fB7SHMkm; arc=none smtp.client-ip=91.218.175.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fB7SHMkm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EEqi+37BMeU0EiUbFlxcrBA6Sxfs7ueAIK77z1KnAV4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792410236; v=1; x=1793015036;
 b=fB7SHMkm3uQNSY0AhU+GGqTiFGjrM2oSEEEGj2hQ23XpHLz3erPPHMs51KzLpyypqTYdsPJI
 YlKdO5QueIwFOp0E2ZJMoO25cReHDpg/EUZpwMrTBFXTcx6+Hy5K7dpzxexfKLdGXtnh8LuiR9R
 oD5vVj8f+B2197vSA+zGg9Tw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4431c74f09494a35;
	Mon, 19 Oct 2026 11:43:56 +0000
X-Mizu-Trace-ID: 4431c74f09494a35
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Track physical CPU number at EL2
Date: Mon, 19 Oct 2026 12:43:56 +0100
Message-ID: <20261019114356.3528307-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86y0buyo5s.wl-maz@kernel.org>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev> <20261014125510.2928306-2-fuad.tabba@linux.dev> <86y0buyo5s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Mon, 19 Oct 2026 11:34:23 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
[...]
> > +DECLARE_PER_CPU(int, hyp_cpu_number);
> > +
> > +#define hyp_smp_processor_id() (__this_cpu_read(hyp_cpu_number))
> >
> 
> Do we really need this? I was hoping that TPIDR_EL2 would give us a
> way to compute the CPU number more or less directly, without having to
> maintain per-CPU variable (which is pretty backward, when you think
> about it...).

No. There's no direct way from TPIDR_EL2 to the CPU number, since
init_hyp_mode() allocates each CPU's hyp per-CPU area separately, but
patch 2 can do without the number. I'll drop this patch in v2, and
patch 2 will keep the last vCPU in a per-CPU array indexed by the VM's
table entry.

Cheers,
/fuad
