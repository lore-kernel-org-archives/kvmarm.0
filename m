Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679D84E5339
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 11:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792410247; cv=none; b=Y9IGCr0fyzEi/uz3VcTP42LoewjBBjTUant35LoR4cSQGcnaJ+WHkoWXgeBH1KPTqm2x3z4thbNpmhBzOgLncpZZpYA3u89YzaolFFqXrsk+CnMYF0mFkZ6dHDMndL4gefupdRDKhAc+kDcWVaXLqivFG9AS11g2fIvZgMUpdEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792410247; c=relaxed/simple;
	bh=VZi/aOP2PUmoQrhPDl8klEmLUlL0sCZECFYs4qI2270=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rvp2vEBq30kmSb+48uLelsagSHZBupZqRX+mZI359+uCcyDNLIKDRD3kpU7pQ5X/XyuqaFaxiWgVeAUFEUNDD9qk45WR5QLSA2r7PyZ1lWchQLTahZ+htufXFhpyqEuAKnklGUP6af5dL7iB3lX6y9ybvySgwhwmkVebsB8m36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fgRZjkme; arc=none smtp.client-ip=91.218.175.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fgRZjkme"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VZi/aOP2PUmoQrhPDl8klEmLUlL0sCZECFYs4qI2270=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792410238; v=1; x=1793015038;
 b=fgRZjkmeg07XEsLARKqnyXpQFK6g6W4EB3nFk6THi4CJi1JzyxfAMr/2/jtHD4ccFjHesL3R
 CKkSrdvart1g2z1I4dXI5fXIxFjCY3msvwPz0IbBvaPQEiICuQGxB7XAvM8DNF5be0KNHQwhvb7
 xQmFb0GO4zdQmezK3BTl6CnE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c4850a772d6b8ee9;
	Mon, 19 Oct 2026 11:43:58 +0000
X-Mizu-Trace-ID: c4850a772d6b8ee9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM
Date: Mon, 19 Oct 2026 12:43:57 +0100
Message-ID: <20261019114357.3528498-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <atXqLxU5bBtJ8U9W@google.com>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev> <20261014125510.2928306-3-fuad.tabba@linux.dev> <atXqLxU5bBtJ8U9W@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Vincent,

On Mon, 19 Oct 2026 11:00:15 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
[...]
> > @@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
> >          unsigned short refcount;
> >          hyp_spinlock_t lock;
> >  
> > +        /* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
> > +        int *last_vcpu_ran;
> 
> Unlikely to be a problem in pratice, but vcpu_idx is "unsigned int". I wonder if
> this shouldn't be unsigned int here too and initialised to UINT_MAX?

I'd copied int and -1 from the host's mmu->last_vcpu_ran, but the
vcpu_idx it's comparing against here is unsigned int, so I'll switch to
unsigned int and UINT_MAX in v2.

Thanks,
/fuad
