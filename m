Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD9E31B13E
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355822; cv=none; b=mFYz5LSIh8IIqLLzB2WZWJ9jnDXJWycWWKDO7IE+7US6GqM8Fems6MY98j68fq9RYIwITy+jj56iGk2L0RFlxRD7ko2Jg/ubhfeW6k9F0y0LBx3u9iSnlnjjW3heOGMzLFlgMEDR7K+5QXjIaa1aZxfyEGuoVJFAANcrAhj/X/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355822; c=relaxed/simple;
	bh=ZN5auoWNwkucX+8mRyjY7Bvceh7ymMYV0oFPboPYlLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPtnNKF5fGX/AGoKm6NDalWZwx+2WcbyzqdIODNbaCSmc/+WZn43+9sTjnMqerarOqsD6f/SMfpkZ+vcN05Mnl5JHe1zGPiQfXzVRYvfpVDQwqY7CuBziBTX+zOSeaYpP+c9tIkkOM32vkEEKvNHyrnQpdYtqENshKvLmadEt6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WVE9Ic1V; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WVE9Ic1V"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757355818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CnlFAVoCjOytx6Qrpgy/4Sf9XW0KPkCm2GkfJqhmFe8=;
	b=WVE9Ic1V1e40Rj5dce1HfALRsDV+uAObb1IUpr45wv2v/s/9lmu3pFajN3+z84O7eRwkii
	N1lg3UWPEd9U6b5EnJ10sMHAlSw1k4rJtMOWHUGkbqVKszHFRtmgz0zo/IHm5Jmklz4zk1
	PZAidQYANPFEkqm6qj6RO5EiMVt2V8A=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Remove stage 2 read fault check
Date: Mon,  8 Sep 2025 11:23:24 -0700
Message-Id: <175735577928.2363175.2398747869709964992.b4-ty@linux.dev>
In-Reply-To: <20250908064806.4093081-1-r09922117@csie.ntu.edu.tw>
References: <20250908064806.4093081-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 08 Sep 2025 14:48:06 +0800, Wei-Lin Chang wrote:
> In the non-NV case, read permission is always granted when mapping
> stage-2, so checking for it doesn't bring much. On the other hand,
> shadow stage-2 for NV guests could potentially have non-readable
> mappings when we align the permissions with those that L1 set for L2, we
> shouldn't be checking for read faults in this case either.
> 
> So just remove this check.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Remove stage 2 read fault check
      https://git.kernel.org/kvmarm/kvmarm/c/756491dd8329

--
Best,
Oliver
