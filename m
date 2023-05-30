Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A7F1EA76
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 18:01:53 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685469711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YTW2WZcJbmr3F/89QdtMcHmMfxHGHqRJaYPa9+0DRL8=;
	b=v/5QRLtEoombNtt+OOiLmFWsyg32+NKE+BEak9MXWHACKSaIj4LmJivYz+94pXHqf2WbFK
	1Xtqv05pJTvcYhpEQyTjyuUkuZQnOsIqs7bST5GMHi98Rck9LMVesKA7Qxs/3b+8SE8E/z
	f58m02RHd/vTGR+670um7/9j91svoHo=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-kernel@vger.kernel.org,
	Mostafa Saleh <smostafa@google.com>,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	bgardon@google.com,
	suzuki.poulose@arm.com,
	gshan@redhat.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	james.morse@arm.com,
	qperret@google.com,
	catalin.marinas@arm.com
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Date: Tue, 30 May 2023 18:01:40 +0000
Message-ID: <168546969288.1201076.8549235994369669662.b4-ty@linux.dev>
In-Reply-To: <20230530150845.2856828-1-smostafa@google.com>
References: <20230530150845.2856828-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 30 May 2023 15:08:45 +0000, Mostafa Saleh wrote:
> CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> However, the nvhe code doesn't make use of it as it doesn't map any
> pages with Guarded Page(GP) bit.
> 
> kvm pgtable code is modified to map executable pages with GP bit
> if BTI is enabled for the kernel.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Use BTI for nvhe
      https://git.kernel.org/kvmarm/kvmarm/c/b53d4a272349

--
Best,
Oliver
