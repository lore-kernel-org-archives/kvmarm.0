Received: from out-206.mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F297134B6
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ft5UZ5Eq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696539360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJvpeX8dRZRs8G3JgP1/dgBnAZGzrRNm5drTSTvXqgg=;
	b=Ft5UZ5EqgZBx2djNqKbw1/QXaF7Yw0xytQNnfbAVcMLMy93gyEweR8JDS+MksVHZvpi5+f
	v2Zj/ZQMK+cvP/EDXo5M/yiDClAXymEKPG9cz2uO0uSleHmKuKKvn7UgdAK4enMy+NrfyK
	76gjiNvOAHaYsnKigehyqF5pgJnqadQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Cleanups for managing SMCCC filter maple tree
Date: Thu,  5 Oct 2023 20:55:50 +0000
Message-ID: <169653934673.541059.14944448680189862613.b4-ty@linux.dev>
In-Reply-To: <20231004234947.207507-1-oliver.upton@linux.dev>
References: <20231004234947.207507-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 4 Oct 2023 23:49:44 +0000, Oliver Upton wrote:
> Small series to clean up the way KVM manages the maple tree
> representation of the SMCCC filter, only allocating nodes in the tree if
> the SMCCC filter is used.
> 
> The other ugly bit that this fixes is the error path when 'reserved'
> ranges cannot be inserted into the maple tree, instead returning an
> error to userspace.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/3] KVM: arm64: Add a predicate for testing if SMCCC filter is configured
      https://git.kernel.org/kvmarm/kvmarm/c/bb17fb31f00e
[2/3] KVM: arm64: Only insert reserved ranges when SMCCC filter is used
      https://git.kernel.org/kvmarm/kvmarm/c/d34b76489ea0
[3/3] KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured
      https://git.kernel.org/kvmarm/kvmarm/c/4202bcac5e65

--
Best,
Oliver
