Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5011EFF8D
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675523; cv=none; b=qAgVKHYAAFFIs0kDJq1QxjdE4fe9Jsl8M/YkbOiMzXnat/FpOBdM35NUilcKCry/+WAD0ENT3jtm/Pz6eJqaHrTClxCoUkzc2O3F7MNh3Su+ybf65Dvg3NMvz3F6kdmE0SjdBOVMXW/hPnT6cVFJ9P69xDiUaofnjnSw3M+fAXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675523; c=relaxed/simple;
	bh=/Mi5Vo1HxUbo9dd8pfGcvW2sk/WAnEGeOZy45URN640=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rD0KbJYRCBYjzo23DsRHWwXpalTFAj2dHk+aI1TsKOFJUHCYyfMbnxCd1CPd4ycXaeiTK5gkTrAJxOX8zeVlTc8ipEjrxY7NugKLLQhpIGYP3TY4TBX1yByiU2MukbJ3ObebR7C6wNETXUuVsjoXTrvMuonFfXTB7KThNgvhNho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MlkPO2yQ; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MlkPO2yQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0xo2PNgclIAHBnClwq+LrBXBtz3y6yq3dfP31cUd28=;
	b=MlkPO2yQ24PVP+nR4bYuz0GO3TcsGW2btDAOK9WNcQlyVq/dos8OLSoQmMvyjmEenbBujd
	hw+AJN4MVgTO09PsXAKseSw2qbxOLp2NhZY4YT2BAnz34U+aC54jHBsHQWBRXrdUDr58zr
	FgeEVfwAftRgA6A4T4NEWfSFIFjJ8Sc=
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
	catalin.marinas@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	sebastianene@google.com,
	keirf@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes to handling of restricted registers for protected VMs
Date: Fri,  8 Aug 2025 10:51:36 -0700
Message-Id: <175467548065.670500.5861388247591755272.b4-ty@linux.dev>
In-Reply-To: <20250807120133.871892-1-tabba@google.com>
References: <20250807120133.871892-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 07 Aug 2025 13:01:30 +0100, Fuad Tabba wrote:
> This patch series mainly fixes issues we've encountered in pKVM (in
> downstream Android code), related to the handling of protected VM access
> to restricted registers and injecting undefined exceptions into a
> protected guest.
> 
> The last patch in this series isn't pKVM specific, but a fix to the
> vgic-v2 code encountered while fixing the issues in this series. The
> issue it fixes was indirectly introduced into the code with hVHE.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VMs
      https://git.kernel.org/kvmarm/kvmarm/c/eaa43934b412
[2/3] KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception
      https://git.kernel.org/kvmarm/kvmarm/c/798eb5978700
[3/3] arm64: vgic-v2: Fix guest endianness check in hVHE mode
      https://git.kernel.org/kvmarm/kvmarm/c/f1edb159200a

--
Best,
Oliver
