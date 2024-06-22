Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5F22084
	for <kvmarm@lists.linux.dev>; Sat, 22 Jun 2024 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719079886; cv=none; b=BRPpbZQ/ToVnOLpeMQbRuXwUbt8ml8aer8f2vUrKUxAc3XAzQImMKsydWr8naJzW7GlDUG1Xk+hjlYdOL7erPZqj4qb49ia1ZQn0IpqwdMTGyKygEFJ7zYd8BfjSZs6ZY3HuXlJ2zh5FuwWG1TZZroZHF1SP/tu5zxJTFwto2t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719079886; c=relaxed/simple;
	bh=dpnIIbuNmw/yXedwiT0BZEq/YFk4luywAuQejbAzBWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCSIXykTuDoPVOV72XG9Mu7RMCwH2bq5zQkfegJSQyKMclwXYuHJId/Lpll/tAuxlcme5FOOIxf3NqYjrMa0jVWf0DqVYfk17fYXt2795IZ0A78FyRRRezVpOAxLpeqcv8o/L0/PoJa3VdnVweN4yBQ7WpNmGa3G06lI2cj26vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q3Z7g/Zr; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q3Z7g/Zr"
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719079881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+fa/31WHXvK8y3wUSKWM7ddloPmwAShICM7ksLk7Ds=;
	b=q3Z7g/ZrawMO1Jj+2+8U/brpIx+aWSOofnGEA/zCtL73IAGZZKbmyaqJWEenWF2osTP97E
	TKwzUBL8Ykv3rysSrwqkzObpnlj6QqQcO4rZ7iQ+7iwcJNyffLXB3gcDBII8NdKDG9scFH
	6q5VBZwMOic7uwTjCnTcX9y7s27aHaA=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
Date: Sat, 22 Jun 2024 18:11:09 +0000
Message-ID: <171907984340.2922035.2124351086655706702.b4-ty@linux.dev>
In-Reply-To: <20240621224044.2465901-1-oliver.upton@linux.dev>
References: <20240621224044.2465901-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 21 Jun 2024 22:40:44 +0000, Oliver Upton wrote:
> Marc reports that L1 VMs aren't booting with the NV series applied to
> today's kvmarm/next. After bisecting the issue, it appears that
> 44241f34fac9 ("KVM: arm64: nv: Use accessors for modifying ID
> registers") is to blame.
> 
> Poking around at the issue a bit further, it'd appear that the value for
> ID_AA64PFR0_EL1 is complete garbage, as 'val' still contains the value
> we set ID_AA64ISAR1_EL1 to.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
      https://git.kernel.org/kvmarm/kvmarm/c/33d85a93c6c3

--
Best,
Oliver
