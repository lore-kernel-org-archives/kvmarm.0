Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9D4D9EA
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602007; cv=none; b=uXnzJsplol1rD6l+guxMS1Mh5ot6SG+X1GzvBZQnTUI7x0eMJXmOHfMLlbN2EjQJQe7MMq6/QoGurjXUULrprDPRXAJY8RxrvNvu5ooD9HA5i6Pke0yze1gWjHm+U4teQIO7Ik+SlWg74iESwRQrtAnQyN7CjKqSRMGesy6CXEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602007; c=relaxed/simple;
	bh=m1LYgoHUiAKogGB26x5jAdpPt4ZQkpx9bPnSIFjUZ9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSS2lbLU3X9bxt1+9iUzeHsFaQ7vxsISfZ+bLojI9Dhz8p8hJE6XtbH/gBg1hhyG4RBnihIJfCiNTUCOPxW9ZmHx17577vbICTDGdWSqswzgg2lGOTPUSIMngi8P3U7QW8rsCbbwVm6YCCGu9lPlPr8McAGeNpBHLTVWKjzgVbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tOp5Wkkk; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tOp5Wkkk"
X-Envelope-To: kvm@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719602002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/9JYhYdnMggNZ1TxzECvRq0Hc0vaHqAODdO4MPdDjI=;
	b=tOp5WkkkcWWJQbF/XYRgDP6FEaIHFTF0m2MZLdQSweYi0il1/ajthqPTkQ3sHs6Sa9XICW
	IjM8GAMuYuXnU850OqaYAzFpXZ8QRb9IHsvjyHVfM5SS96/M1pgcQzG+HCddR98588NSIE
	Z9GaLqhvRLjYs28d7ZmCRUD1L1CRvw8=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: maz@kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: joey.gouly@arm.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 0/5] KVM: arm64: Fix handling of TCR2_EL1
Date: Fri, 28 Jun 2024 19:13:13 +0000
Message-ID: <171960186741.2925817.15322021924972289887.b4-ty@linux.dev>
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 25 Jun 2024 14:00:36 +0100, Marc Zyngier wrote:
> As I'm inching towards supporting FEAT_S1PIE in a NV guest (oh, the
> fun I'm having!), it has become obvious that we're missing the basics
> when it comes to:
> 
> - VM configuration: HCRX_EL2.TCR2En is forced to 1, and we blindly
>   save/restore stuff.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] KVM: arm64: Correctly honor the presence of FEAT_TCRX
      https://git.kernel.org/kvmarm/kvmarm/c/9b58e665d6b2
[2/5] KVM: arm64: Get rid of HCRX_GUEST_FLAGS
      https://git.kernel.org/kvmarm/kvmarm/c/a3ee9ce88ba3
[3/5] KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
      https://git.kernel.org/kvmarm/kvmarm/c/1b04fd40275e
[4/5] KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
      https://git.kernel.org/kvmarm/kvmarm/c/663abf04ee4d
[5/5] KVM: arm64: Honor trap routing for TCR2_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/91e9cc70b775

--
Best,
Oliver
