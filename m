Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F4C17838D
	for <kvmarm@lists.linux.dev>; Wed,  3 Jul 2024 23:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049131; cv=none; b=FbpFhlOvttlTTSOl5PDHcERpGpLRy1NOLnqmSzkUM+uDM3C9jysiRiq+8wPWNZcQyuV0DmUgygoU1tkUjq2qcXBynNVME1lPAOLFq60hxfB8ECe67Eo0Gc+EtJnLzgXjK7XOSz/cE/7Tn6B0GJO9w/e5chaeR0GEgDqlHm7pVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049131; c=relaxed/simple;
	bh=vQkkYYookm1SccwgPTp+zLqynes6an3LesJyQlYT2CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MgSHBMw+hRF/dUvPUCVWQ3+tflF1YgSMv8990x07oz6MjvLa9QTfY/SI/fRJGkUVsYIPvqNIgfqdkKN4zXPvGe5wgjsC11RFlgZUrpZbeyRTfy9dNZwcFdyBg9Q4d1XENJ2iB9WuAzn0qeItkMaEceyuK8RC89t85FnVTe9xrig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eRNfDrfN; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eRNfDrfN"
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720049125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f2C+uPQ7mJKJ1v22Tj4TxmB+gRhlgbNvzJmy/2m/Jw=;
	b=eRNfDrfNXEISri4PDKmyemc/LvaCQ/C1TkwtfkZ4SZJzWw0YKGv4loCnH2wosFHOaZofR0
	u55R1FmXOWJasCKtrsYl1aTlEEOT7D9rKvp8/zT3yu2GFYGI/7/IeZ3uZtCZc/GqIyoY4L
	chHbVI47z4JRpKIfFeeHVd8OlCN/NM8=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: james.morse@arm.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
Date: Wed,  3 Jul 2024 23:25:11 +0000
Message-ID: <172004909840.2946123.5315611063908366779.b4-ty@linux.dev>
In-Reply-To: <20240628222147.3153682-1-oliver.upton@linux.dev>
References: <20240628222147.3153682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 28 Jun 2024 22:21:47 +0000, Oliver Upton wrote:
> Ensure updates to the KVM/arm64 documentation get sent to the right
> place.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] MAINTAINERS: Include documentation in KVM/arm64 entry
      https://git.kernel.org/kvmarm/kvmarm/c/88a0a4f6068c

--
Best,
Oliver
