Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A038DD6
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967065; cv=none; b=B89o0GKnHyYDC6/ZB8ZCu8zi+D+FLfsZPc4ogrXNo5XZeqZF4DrQ9LWaRmc7JwWB1HcrdkEED++HUPp0aXCn61cgEqtJ2ZcPy4Ti4etjO5006H6qZ1QnkLBGhnFQFIrsl63q3e/9dw+ouDYjORpn3dURmyXgj+rnu52YlGn/fFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967065; c=relaxed/simple;
	bh=G90cXSfr9iD6UrYu8t8TRAEdrbF1AtSu9ILl8KCzb/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GN+MTLtfbzdpIHtsteHNMuCSaF7Vp3THk8b+aJ0N9p8r6Qxg3YzW2mcflGp6I94MwVPADNbk9OP6yblMsGw1VSr56+oiKyS1tmKy43FrDk2J2OIc3apXdUd4NXXzxohL+eeBUQZkRscfBWnhrDvA12uvhkSEp5AW93i7CCiuMHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=blwCIWlz; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="blwCIWlz"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715967059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PauZknEQMacybh/AcgeLdUGz8PBpDzU4I7xOaTQN274=;
	b=blwCIWlzAe6chjJZYFihbfc2hNxDdnazjj4Qb5FEb6O1snlFySZSjC+P94ySmym51qFkGq
	14kR9VRwNp/AtFN7C0vvSorqq6GCOTj1x+F1AQknNwNg1WTyZsMOMHYLMj5b1d+wR2QJYF
	Uy6muBmTMLW66vDQOCY4o40rG9hECGE=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Fri, 17 May 2024 17:30:54 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
Message-ID: <ZkeUTix0Ojn5eHKP@linux.dev>
References: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Fri, May 17, 2024 at 02:18:07PM +0100, Fuad Tabba wrote:
> With the KVM host data rework [1], handling of fpsimd and sve
> state in protected mode is done at hyp. For protected VMs, we
> don't want to leak any guest state to the host, including whether
> a guest has used fpsimd/sve.
> 
> To complete the work started with the host data rework, in
> regards to protected mode, ensure that the host's fpsimd context
> and its sve context are restored on guest exit, since the rework
> has hidden the fpsimd/sve state from the host.
> 
> This patch series eagerly restores the host fpsimd/sve state on
> guest exit when running in protected mode, which happens only if
> the guest has used fpsimd/sve. This means that the saving of the
> state is lazy, similar to the behavior of KVM in other modes, but
> the restoration of the host state is eager.

Hmm... Is there any reason why we need to be concerned about preserving
host SVE state?

The syscall ABI has it that only the first 128 bits of the vector
registers are preserved by the kernel, and I see no reason why we
couldn't apply a similar restriction to KVM_RUN HVCs into EL2. We'd need
to eagerly flush the vector registers on entry to avoid disclosing guest
usage of SVE.

What you have is certainly correct, I just wonder if we're going out of
our way to save/restore 0's for larger VLs.

-- 
Thanks,
Oliver
