Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AADD34567
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 19:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sZ143lJR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700508111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vzrrZq9ytY8Rewnx1/LbL/B9hFkRInU9eyjNfEWPyo=;
	b=sZ143lJRzKcxT6rLMjlWyn69+lZKEE8DYBNp02X15reLSa3m7sZ2zQtN7hGdTfBm6T3Lv9
	vhIqVDuPJw5wYFGFV66EiPBEKjzF7WVJr5wE3MNhmgOFfu53vCwWkgpDiThEVlrBtnvthS
	XzJ0N7fbElBYcLeA/L7TSdaaYjynt+Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: Kunkun Jiang <jiangkunkun@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	eric.auger@redhat.com,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH v3] KVM: arm64: GICv4: Do not perform a map to a mapped vLPI
Date: Mon, 20 Nov 2023 19:21:34 +0000
Message-ID: <170050808707.568776.18148802695411382186.b4-ty@linux.dev>
In-Reply-To: <20231120131210.2039-1-jiangkunkun@huawei.com>
References: <20231120131210.2039-1-jiangkunkun@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Nov 2023 21:12:10 +0800, Kunkun Jiang wrote:
> Before performing a map, let's check whether the vLPI has been
> mapped.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: GICv4: Do not perform a map to a mapped vLPI
      https://git.kernel.org/kvmarm/kvmarm/c/8e4ece6889a5

--
Best,
Oliver
