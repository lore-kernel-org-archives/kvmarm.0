Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041F31C56D
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355824; cv=none; b=ZqGVcj4J3XfTj624P585nu4GN1Whu7DWfIf2/go7PIp0lpxMMc1OHJWl+l87Rhk4dh0rmfOrvEcFxMJnJ+ri9WfRA0dlDO5/0SsCPagOslgu19BBommewkJs7d2aSnTCKk+ARu7/yUNzVQjgSeDuXrUlQCc8eReUyj+5k5Qqg60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355824; c=relaxed/simple;
	bh=D47X9oZMUae6rOCQpZKyzorXZpj9uUNk4f1+MQyWUL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKL8XQ15ED8LpJ/rUo0DGE1ov5pOj4689f2ZvpQgNFOoDBpVeY8SCTsFKnKUwucviqgYJmt/XuYGXE8W+sV+tHg+uWGl+bKSlHUPcEh0OBRDnfamn/d5s5dsPpvENzvBOa+dTg3iYWNPDpyssvHObsNVYa9tMx2JGHHGDUnCoUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iy2ixBtQ; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iy2ixBtQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757355820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TGELi6yptye/sf1/CYmtXIgm3boebepQSxmdLx8dxo=;
	b=iy2ixBtQe/M3IWHUkTU5wSwTQUt36l7G1x4iRU8i4wDJMqtcLGk5slMVa6KrMPbu8ljmxN
	TsiqZ8lZhvB8vbg6O5vhQRNPjZtjFWuOHq4RPqzXPjRqmTQZUi9N0/VCPm/bKU4eXtv0ej
	yAQ9Xws157BFdSQr/qBN1gZHyogF9Oc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	maz@kernel.org,
	will@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com
Subject: Re: [PATCH] KVM: arm64: Fix parameter ordering for VBAR_EL1 assignment
Date: Mon,  8 Sep 2025 11:23:25 -0700
Message-Id: <175735577926.2363175.17706140210241973919.b4-ty@linux.dev>
In-Reply-To: <20250908163557.2419780-1-tabba@google.com>
References: <20250908163557.2419780-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 08 Sep 2025 17:35:57 +0100, Fuad Tabba wrote:
> The __vcpu_assign_sys_reg() helper expects the register ID as the second
> argument and the value to be assigned as the third. However, the
> existing code was passing these parameters in the incorrect order.
> 
> Fix the function call to properly read the live value of VBAR_EL1 from
> the guest and update the vCPU value immediately before pending the
> exception. This ensures the vCPU's value is the same as the guest's and
> that the exception will be handled at the correct address upon resuming
> the guest.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix parameter ordering for VBAR_EL1 assignment
      https://git.kernel.org/kvmarm/kvmarm/c/9f8073411c13

--
Best,
Oliver
