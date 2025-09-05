Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1827AC2F
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757065293; cv=none; b=g9aUrx6UFYN6B9yxIHJ+wc0R0u7//KfvYDasH91au6Uo4U/om0rq9PE9Sgsf8aofUVmcJZ48y5ymSkVKIkg9Nnb4cyJG5cizwPVWs9mF7xISi9Q5VqSLBFcFoPXFdlojzLJgrQF7HNBFmoaM508Qs+0Nw5cTyM8qsinkUe7l3EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757065293; c=relaxed/simple;
	bh=UtIKjhPKtVp/Ev2m8ZxuRxUlX/4+cWY+T+yhu2JKPv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlKV0wZaRw7KqfAjuMkhF2Hh/hEXFikzG/9UC9skI0oJOc8mabyENu3R53ncFH4fyUYEm+2uge7ZCzU8jjS10lvHNwdUGSISMmfMc78l/eslKRoeoqVtTILuLF6K6k1c7Omx3JZG7azSbRp9Lb/1BoGNoAZkuAL+41WiHGKZbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RcSiBCNN; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RcSiBCNN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757065289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wYu23m2CGRj9yPMF5CKJbFvo7EQpD5YOel74mRguMFA=;
	b=RcSiBCNNRimpDRhKWJPXFCegVh4ntJIXK4/UrQn6MYwBec6HP9v8CYUlCImEKs1w5y0SN0
	RUWD7B+dXcStCk93p6Gp/01tBiHpgoerHh80Y3yc+v0In6cXAVjSCj2q+s5+K18Emv1W5g
	CLvW1cVs6TEfOBvWoeKqoojQ+iH4wMc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH] KVM: arm64: Only free fully unmapped tables in stage2_free_walker()
Date: Fri,  5 Sep 2025 02:41:09 -0700
Message-Id: <175706523467.1669883.16451846246676541664.b4-ty@linux.dev>
In-Reply-To: <20250904101746.275795-1-oliver.upton@linux.dev>
References: <20250904101746.275795-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 04 Sep 2025 03:17:46 -0700, Oliver Upton wrote:
> syzkaller caught a terminal use-after-free in the free walker resulting
> from a premature put_page() on a partially unmapped page table.
> Previously KVM performed a single walk covering the entire IPA space,
> but now that the range of the walk is up to KVM_PGTABLE_MIN_BLOCK_LEVEL
> worth of memory it is possibly to only partially free a table.
> 
> Fix it by only dropping the table reference if the page count of the
> table is 1 (i.e. no longer contains valid PTEs).
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Only free fully unmapped tables in stage2_free_walker()
      https://git.kernel.org/kvmarm/kvmarm/c/3095864771d8

--
Best,
Oliver
