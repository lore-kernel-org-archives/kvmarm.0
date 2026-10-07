Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9424375F80;
	Wed,  7 Oct 2026 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367607; cv=none; b=juYdZCuB8g+oLozYMRVbRMiey+WVjLgXLu9wWZFwSUcP+XKncacJse3WoNmhe5DTblCOYKVbcr7gNQC6C3yIbZ53GaDaxboQ+YTmXW2ypICQ8/zVoNULR2eT+9nGZuswHSBQF/kLSM6RrsnQMm9bFpkR5UjYUTFVlAkqIHG5cxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367607; c=relaxed/simple;
	bh=FHEpNgNxPkwq5GnIJld6nsSUYUE7SblcN709gJQfZvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igdOXkZ0UyuPUhkwvYRv8bUq9YKhjvvrWfpSe/VwItArYBWNpjACbAdtYw53CF7FAMN1GpSEiDU3k7dG12cs+JA0IVJRnRJXpHFXt1/7UbPduG2IN8IRBnI8Y5wXh0HnpY1ouNgKpMtAtZDCxwOMrRAiQLAf0wUtQE8UcWwqs0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Peb6+4o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Peb6+4o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9BE1F0089B;
	Wed,  7 Oct 2026 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791367598;
	bh=APsB50ihhU3A5Y/b7mc2nvs0/aMHP/B00/9rsQ9YSxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Peb6+4o/Fn/871ib2bcjk6CVPyHsZ+t3auV/PL1ronyahYmQVdjngxwCs6X//kxNr
	 YK0UXr80xdGYqWr//KVL1FP4ErY2mQ3/Yi0Hp9C4cZAaaJzP6pe2wFn2Tled1Abeyf
	 fvf0gD+qSIk1LN2XC3lJzu/OlZ4x9OhnY3BNyumK3QDKj3ncenA92PbkY0hxofvgVj
	 uu4kbhRA5MxkCbm2sFKurjTlNHl1IObRD+Qg9PBEwxFOMB5nZa6E2Au4YzlJ8FcMtm
	 yR2R2CBs6YwiLLbvPt8TRczYHbMIOkmBaWOy0pOXhldTOrH8Nvq6G872nFft8g6/sf
	 d7GT5kCx2W/cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xEOXk-00000000Den-0sAt;
	Wed, 07 Oct 2026 10:06:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oupton@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: Replace VCPU_RUN with KVM_RUN in comments and docs
Date: Wed,  7 Oct 2026 11:06:33 +0100
Message-ID: <179136758616.696606.4614783559462928506.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915084441.3846947-1-fuad.tabba@linux.dev>
References: <20260915084441.3846947-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oupton@kernel.org, maddy@linux.ibm.com, fuad.tabba@linux.dev, seanjc@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, npiggin@gmail.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 15 Sep 2026 09:44:38 +0100, Fuad Tabba wrote:
> This one has been bugging me for a while. Five comments and doc lines
> name a VCPU_RUN ioctl (KVM_VCPU_RUN in book3s_hv.c, VCPU RUN in
> kvm_host.h). The ioctl that enters the guest is KVM_RUN.
> 
> The patches are independent and split by tree, one each for generic
> KVM, KVM/arm64 and Book3S HV, so each can go through its own
> maintainer. Nothing else in the tree refers to the ioctl by a wrong
> name.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: Fix comments that refer to the non-existent VCPU_RUN ioctl
      commit: 8233000034a630432a7da0311d94e8725207a095
[2/3] KVM: arm64: Fix references to the non-existent VCPU_RUN ioctl
      commit: 0ab1034969130967bda8e6eab5b8dd6745604f1b
[3/3] KVM: PPC: Book3S HV: Fix comment naming a non-existent KVM_VCPU_RUN ioctl
      commit: 6ce8b5c0effb227f5625b35965c0f74c0e953efb

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


