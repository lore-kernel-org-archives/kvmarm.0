Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F61BA895;
	Fri, 30 Aug 2024 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725034359; cv=none; b=kpEuxqCl0pqtS6J4yjdFZPYD76Fs0uD5JIjvqIzW0EhRXCiH+oO6TZXdOc3spYDzb927HvGvaBtzpiflmOp2jcm6q4PEJ2w2urTFRegWfcqXWi83DlWA4p4yFi5Vug7l3pqs8ww848FpgZu68MNHCiot+JHKohVcZfkVwgliW64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725034359; c=relaxed/simple;
	bh=3WluTfM/2AVhxXsBLbvXkfr2Sb1Vu7quEX6AURpIYLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeqO0gjPGZuRiuSTXSvljmzzE8BSZv+e2KfY/s9xztGTH0MulFRxKhYAkgFDoCGZVcHoUXl2TIHD0QfRB/dAgVYiUYPQs251b/nrpAiercvSZTybzZNIYf3DyPMXaGHPq+oA67X5wwA9+rjMjvKqZh97+JNJTiqTmTinLMIjbe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlgeXMb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlgeXMb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D521C4CECE;
	Fri, 30 Aug 2024 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725034358;
	bh=3WluTfM/2AVhxXsBLbvXkfr2Sb1Vu7quEX6AURpIYLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlgeXMb0X4+qYvg0gChNumy+x9ky+IO+bQnWAcrv3u6WHp06a7VWn7swrgwYZIlRr
	 L1N+EWl8JXzffHxEM57PlHWH1d2NyS/kWOERzXBa5F74vkcX0HhnZocWLX5o7v7SFS
	 XECCrpQjiNxQjZBQlHCg8DazRKGqS34tVz/7R7TxveJgo0ebQuqiYIV3dm7JS9el/6
	 bqh4ffYP9h9J4Ro1Dw+NGki6Tqcg+KT2oHn5HgzFilMcN9375o8dJkme9I2abig4KR
	 vLuZn+KVW61A2l9ESZorJNqsz5s8oPVyC4b6bzjlZlWyqvFcKNtdJWyMjWEVKdU+t1
	 CNNye97Dw74/Q==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	D Scott Phillips <scott@os.amperecomputing.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Rob Herring <robh@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@amperecomputing.com,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2] arm64: errata: Enable the AC03_CPU_38 workaround for ampere1a
Date: Fri, 30 Aug 2024 17:12:13 +0100
Message-Id: <172502412797.2650729.128588861974374748.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240827211701.2216719-1-scott@os.amperecomputing.com>
References: <20240827211701.2216719-1-scott@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 27 Aug 2024 14:17:01 -0700, D Scott Phillips wrote:
> The ampere1a cpu is affected by erratum AC04_CPU_10 which is the same
> bug as AC03_CPU_38. Add ampere1a to the AC03_CPU_38 workaround midr list.
> 
> 

Applied to arm64 (for-next/errata), thanks!

[1/1] arm64: errata: Enable the AC03_CPU_38 workaround for ampere1a
      https://git.kernel.org/arm64/c/db0d8a84348b 

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
