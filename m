Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A7F218305
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731438827; cv=none; b=uT57Vyn7oxe8IgklouJuGHnNfwbcQF4LHGzz1u/pURXrFL5vncYkEJirz2oThcLm9h6RVRprTe3PQw3xm/MnW0WWnlE7TRwmLZAibmN6f6rpM3a4auhBhMNYkmSFZhNV9EgiMicAzg/b6SNAbYdqAUwmqe/TCCowSLPv8SOv4Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731438827; c=relaxed/simple;
	bh=z1I5Cnt8bb1hnH7BOsE+i9L1a9bYVhfqsKiQQEDYkbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2iLTpE9FGXUgwvPXfhHbwoieWxivKTAZc6vkUzaQZa0TPfczMAwjbdPyh+RIuqMHbWpPLD4h/rwxtSJ4gyxxqBBvj3lLCIz28DnAfw68Tc5PzeFa9455ppZELydIOwAu5KZEo/w5oBHFqe8+xntkvd+tSN2x2nVOUN+eeCrQXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nswQ7FZ5; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nswQ7FZ5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731438822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2wfruU0o5MqkGZQlyyUPdYIgcNLexv/NYFlVrUjaf0=;
	b=nswQ7FZ5qmBP/kugTAbcuj0+xAIgf8NB4/n/qS3hx7IGc3FCjrj6Xi6HelVeSqxa95yf2M
	6vYQz+5m1TTXmuhzGgcvf60p4YozmyoaeEF9pr1o/FbiSZVf8GjmQ3izmZlzs9iysdMUcL
	Rc8270A+I3YuY34i3envIE3Ka6Buct0=
From: Oliver Upton <oliver.upton@linux.dev>
To: tabba@google.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	James Clark <james.clark@linaro.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Pass on SVE mapping failures
Date: Tue, 12 Nov 2024 11:13:27 -0800
Message-Id: <173143830153.1780821.3252624992091199319.b4-ty@linux.dev>
In-Reply-To: <20241112105604.795809-1-james.clark@linaro.org>
References: <20241112105604.795809-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 12 Nov 2024 10:56:03 +0000, James Clark wrote:
> This function can fail but its return value isn't passed onto the
> caller. Presumably this could result in a broken state.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Pass on SVE mapping failures
      https://git.kernel.org/kvmarm/kvmarm/c/60ad25e14ab5

--
Best,
Oliver
