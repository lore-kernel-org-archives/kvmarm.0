Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713289;
	b=r36XUNSR+OxgIJCbbf3ThXCCF1y8jtC2U1MT1IPTI4Lk/aAGW8yONsHZhgDdDccdSMmr
	 zDUcJaSOpqjATQ21LH7fhqXldjILBwT6vaTw940+OU85b/ZbP14GDmpiCo09DwXBGfhgn
	 FZOq2HEeQVtyLCR8+deg90PV+IkTmimZd4bpoe02eY7fKMh2k5Om9mwKu7kjFFT5LPoXg
	 TtZPz3fNmb9XmdUqWK6raTs8uG53/w9Bgdtti014kABM9hQZv7f52bQxy6yaNkWaA0JHP
	 qElEjRnHoD2LBrJqRMzeg6wC3SSmYi00JaEwou43DDmZtPfFOjfvYToBhoe9LPk/Uuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=EoPzyDx6jm3ywF5UzK+QhQsk3HBLA419U9A5IMCSv1w=;
	b=GecPGmZQD8GspwGhiKdkECn4BuY5YBLkEQrfJDvZBdvGoefwoRQ1GLb6+Ysf9cuDQdTh
	 5RIRd+c7x5EqZft18rfqdd9s/z1TS3hN/1wWYzOmlV22OBuj7GS/nrQDL1AyPvKGtWofE
	 c7EtXFwaB+t1kOoLL/0JQ3rj+4Zm3r3Iv72uJuZo/npEkXL4rdknbBHcjUTUACXfZc1iz
	 rUhy55QxJndS2FqY8Kk9GRDs8Wx/HDNPhJd/qmc1sX/Vk85NaxZcVkE42xsbWxl3r7S5P
	 PYxwo4HHW/9DZaEbIi5UG7kZk+GyPEGPIQEAUaTAWgvwjXVWFXmsd9AVEg4kSrC0YUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huB7NYJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E7606A31C;
	Thu, 26 Nov 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huB7NYJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A5B1F000CA;
	Thu, 26 Nov 2026 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713289;
	bh=EoPzyDx6jm3ywF5UzK+QhQsk3HBLA419U9A5IMCSv1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huB7NYJDpSHPgRRvYHILvOLy6xpry/OMA/sp5FlAVJvkdE0mutJURugvi49jT4MPd
	 l4ijVqdne7xmGkbHP7AZv9qxMtxjMgbZhrcmv7i83SnC3LnaL7QPMK4ZGqJ2fuFBJa
	 xVFwQYh2ZC+5GHc/Vv2NtS1D/A4QNWLS5WyeHKt2cDLQe46UZtShiAYws3KoR9wMDy
	 rH7iB2fSv4xuu3omk8ZEKcmGqyc9agT+URqfvp/rQTRQAqsr4wBxG4Nt325jGV2SlY
	 wTzjXRYYKa4pa5yaWiSE6BS9hg638eVZzvkoE1Y+QaV6pJZnpDP24gB/SbyxOz31g7
	 wZAluRl9B2Yww==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool 0/7] Fix --vcpu-affinity
Date: Thu, 26 Nov 2026 17:14:29 +0000
Message-ID: <179570874285.2888674.1910692252028588031.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917154932.193943-1-alexandru.elisei@arm.com>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
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

On Thu, 17 Sep 2026 16:49:25 +0100, Alexandru Elisei wrote:
> This is my attempt at fixing --vcpu-affinity, which I introduced. Patches #1-#4
> are straightforward fixes, and they don't modify the current (broken) behaviour
> in any way. Patch #5 fixes is most of the fix: with it, the VCPU threads run on
> the physical CPUs passed to --vcpu-affinity, and most of the kvmtool threads,
> except the virtio threads, use the main thread affinity.
> 
> The virtio threads are special because they are spawned from the VCPU threads,
> and they inherit the VCPU thread affinity. Note that there might be other cases
> where this happens.
> 
> [...]

Applied first five to kvmtool (master), thanks!

[1/7] arm64: Pass the number of elements as the first argument to calloc()
      https://git.kernel.org/will/kvmtool/c/5b707c29743a
[2/7] arm64: Consistently treat vcpu_affinity_cpuset as dynamically allocated
      https://git.kernel.org/will/kvmtool/c/c1c630e7d331
[3/7] arm64: Free the temporary cpumask in vcpu_affinity_parser()
      https://git.kernel.org/will/kvmtool/c/e6fbd872f1b1
[4/7] arm64/pmu: Consider kvmtool's affinity when searching for a PMU
      https://git.kernel.org/will/kvmtool/c/8c3912c087d1
[5/7] Correctly apply --vcpu-affinity to the VCPU threads
      https://git.kernel.org/will/kvmtool/c/4c90ccf4c593

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
