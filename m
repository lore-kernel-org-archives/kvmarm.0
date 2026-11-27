Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795804797;
	b=dU5yeySxPc2/Lwr6nhqYzigUl0BjO+tFBDe20HHV7EXHu/sFs75TtmmzarrM58t40Oe+
	 83Mls1qQMPTmZcKlHadkWthxwxmJBZVSC1dSjkjnChJeay4Gy0k6QSbSegxq3LlW9cPvE
	 N1MMP9wJMMG8BP9pT+bO84N7LYO7Gyr9CKo7HKh1im8AFGAPt4IHQACOlzixmBILAMgg7
	 6Deg9b4ND8ySpAJTmu13U/YD+rYAUI7uUItbmgh462H5CjSpE42y+Lw0xElSSyxlfY5lY
	 FagRchtInlpmeT8wwIcDeZnTCSoIKI5IN6nZEig3+KMwQ/1qocuGdoV+3CDTbp/0XQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795804797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LvY8gpHqcKWeG4yrA+GvRV59Qao1sbgMMnjy/o9b65w=;
	b=L2ecHtj0Wtj5e2NI7rfuMYwf/o7bEj/b3MjRk9/SkrgyJLe5nUuX+/NOdbNyCQQZB0CX
	 1N1Fnll9hkJTQufmNDW2Mx7MWYRkVD3sGE3l3ALF2w2O14eRnZo88fWGqd0e46w0TLxTl
	 3gNHSF4AZUz9JyZmlD1JI8inlasajXIpmp5IzIOk20Igx3YrTklHSoMUAZAXRq2Rx17fo
	 JfUa4QKVWX5kvfAUbirzOD0oPA9CxwWTPy8FJDmu2tBCXnKeXSON+fxeFOgnPEbd6ZRRQ
	 Lh9Dvbr8RsNGTBhjBFNe9UmWz2S05X7VzXD1ctSAc3mOOhAnnqalwlOX4rt+scdU/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWxheuhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05660A2608;
	Fri, 27 Nov 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWxheuhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D361F0093B;
	Fri, 27 Nov 2026 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795804796;
	bh=LvY8gpHqcKWeG4yrA+GvRV59Qao1sbgMMnjy/o9b65w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWxheuhR0q4soGEPRstxNfAs/40rpsDgln8LJ7NfDzFSiP3D/3Ifd9+V7XEXB6ZN1
	 03KyNQyf5Zf1vCn9aiaTW5zjBpu5/864zYRAgUx8WQWHeloc7wkJAaCfqa3Tqycvv7
	 C3AuK1ilUA4XtozXCkO8WVMdlSHsXXFil5LC/FA2pmz0V9/vl4+tKsAy0CekDl1OE5
	 9KBbwpJYiXg9Cq2MJ9K3A5iE9nu/h82aOW1poOMd6k+Rosq9MjVpUV5i0MDvx2m3f6
	 n7xhB7tG/EV1hGQvyazwOCMCDNvYwhkQSfD3V8xq13NKDiqQOC3ER/PeXvZi8g35aB
	 aseIDyFeM1gnw==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	andre.przywara@arm.com
Subject: Re: [PATCH v2 0/2] arm64: THPs for systems with pages bigger than 4K
Date: Fri, 27 Nov 2026 18:39:18 +0000
Message-ID: <179580213399.1767284.8136918755635870447.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127165843.709034-1-vdonnefort@google.com>
References: <20261127165843.709034-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 27 Nov 2026 16:58:40 +0000, Vincent Donnefort wrote:
> Enable THP support for arm64 guests on hosts with a page size larger
> than 4K.
> 
> Changelog:
> 
> v2:
>   * Memoize sysconf(_SC_PAGE_SIZE) in host_page_size() and back
>     PAGE_SIZE with it to avoid repeated sysconf() calls. (Will)
>   * Rebase on origin/master (2f3abe56dcd2).
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] util: Use a memoized value for PAGE_SIZE
      https://git.kernel.org/will/kvmtool/c/fe0c220df025
[2/2] arm64: THPs for systems with pages bigger than 4K
      https://git.kernel.org/will/kvmtool/c/4b4aceb1dae7

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
