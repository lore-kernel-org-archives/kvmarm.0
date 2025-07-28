Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1726F47D
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753722979; cv=none; b=QZZsYfQUAYQKAvmXbA5iFwh4yS8PdGtO92aFcxe4qQEXinFOTSnNGtWs2/pzrZUDv5x1ofLNFcicp37/DbHPAoC3j+XPvgqE/O5lgrcIAfkNG3fTb5pqRvliskuXoiJRjb+6Qkbf5ZZ3p4ocdMUMyKIYNnWZQLWQldJy0qKegKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753722979; c=relaxed/simple;
	bh=eVRH7hU/BEkpbT+UNE3rt80ufYBoEnkJ82722u4y4xc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pz38e4wIIH8P2T8vrdQx6No7mVzrE0VJ11uKIP3arvZvwwhdcTrZhbInoQRHYwSDDEevk7Hj/Qlisj5Io2UwESvj3cFR50UnVovf/PO0iXQNS80vwfVvVxIydEpgSZhNtAEBcWIpa/dq/KIv7YVF0AR/rmLTX7kpqnSyKH2DWFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qQyPBdtB; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qQyPBdtB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753722976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qanwvk4FNWGcQQuxR+Z8ks3qCPVT1ftop2jE8XIyIRg=;
	b=qQyPBdtBtA6l40BJjW1FLaTipwHcv8EIoQh/0k2caOQ6NFZKQxw8BOmcwJ6kYVvm83HwHj
	dtfzZm59VnUiRLMEl6tja5JV5MEIGccYLgox4ZKd5MXAf+Gnbg2ngrY4pN85oXm4IUfSTz
	k2TdcEbbDEEERKXVLgllKNezj8XzB7k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list
Date: Mon, 28 Jul 2025 10:15:50 -0700
Message-Id: <175372292710.2891555.9461288088593931461.b4-ty@linux.dev>
In-Reply-To: <20250728152603.2823699-1-oliver.upton@linux.dev>
References: <20250728152603.2823699-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 28 Jul 2025 08:26:03 -0700, Oliver Upton wrote:
> VDISR_EL2 and VSESR_EL2 are now visible to userspace for nested VMs. Add
> them to get-reg-list.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list
      https://git.kernel.org/kvmarm/kvmarm/c/18ec25dd0e97

--
Best,
Oliver
