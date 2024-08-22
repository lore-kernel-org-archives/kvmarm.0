Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F641547EA
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724312521; cv=none; b=REfGBp6IPr5IEJL6U9OrecYkuAtldKv+Qm+8C5r6/RdnQN3FkLThA3NLta8AruJDJ9XI1Idi7kbDR8+WeopfXG1aYuley/onmKnrWWyB5kiAFNVIpdSlwNKkvSHeMIXZopR5S5kXJn2+Kh4aoVsknIUOzmW+4r/25MWypH1tDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724312521; c=relaxed/simple;
	bh=q9y2t5nUcxQ3W70A9lhWmsrgVVZr8gEfCWJ34bzMkg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGeylRnFHC2vUWNKSXGFW30WNi6EKmHHwLTIKZTMSFccIyjhsI0vDRpXK/7KeVNL7/18labx6nKyFVedZOVkVZ/cUuSXvA0ozTNz5A7MGjbE2UDg4kgBPh/t0jBbZL/LveFsEWirKuTloyGBhUOXMIUR1TxwBaoe1jwRBD1IxCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kzVo1LLq; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kzVo1LLq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724312516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcMwRFue1M148124CvwX/uZrRZ+SY+enr1KuPrMg2ow=;
	b=kzVo1LLqn1CWCuJYm2JymevjTFGG2l92FFxO+SuE7774axaHc3gXxZTQywQ9CqyqXlxoce
	1smkEsLI/kLh7iHUOY7drADwOjeogrbk42nfpea4jTrXFTXs9q4dyRK1MYClYtyzrGFh5J
	Lt0bkozQkrz6bpPIF1isK39B9GMuM/8=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Ensure canonical IPA is hugepage-aligned when handling fault
Date: Thu, 22 Aug 2024 07:41:27 +0000
Message-ID: <172431248188.2300140.11719556919990393962.b4-ty@linux.dev>
In-Reply-To: <20240822071710.2291690-1-oliver.upton@linux.dev>
References: <20240822071710.2291690-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 22 Aug 2024 07:17:09 +0000, Oliver Upton wrote:
> Zenghui reports that VMs backed by hugetlb pages are no longer booting
> after commit fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page
> faults").
> 
> Support for shadow stage-2 MMUs introduced the concept of a fault IPA
> and canonical IPA to stage-2 fault handling. These are identical in the
> non-nested case, as the hardware stage-2 context is always that of the
> canonical IPA space.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Ensure canonical IPA is hugepage-aligned when handling fault
      https://git.kernel.org/kvmarm/kvmarm/c/1d8c3c23a6bc

--
Best,
Oliver
