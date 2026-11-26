Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713298;
	b=KRY0dwrfU35x4fUND8OvARP3jSJt10Ph4dg/zSjy1IItuRA+OJpb1OTRyJRoK1yh5Ekw
	 5EO9RIrEPrm3hXZ9HMN47DIJsVtvgpsy/igVVTmC358lpwqDXjd0JuQ0VccKFd2e7Ooha
	 /KqtgTRmzzwc5BBqtnfY5p1CjRRPT93XjWHH4NDWRkfIOlYOl3qdkX2IPDCpVfdg5lKk6
	 4V2E8V7QOY60MDsqhmB/v93K3hvFVh+X/VACNcbYiCyYrE3k/uTUdqK0HptpBBXZCKVcy
	 bxzWK+uR3H4NIT5m8xpOwNGWLIlSKCkp1oVonLUAQ9RaTOr7rDCRkjH0f0E58InsPwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LNLrvcxnQvJha1qURA3bNFc1ECDgKKs6fCmI6FYzJRk=;
	b=inzYP2OdaYpgSK/LyJbWDdiiVNKMZwoeEiWH+0KNmqfN7/ffw8YxM0Y0Saj7flieAzEp
	 yTgkzqdAv/IRlaAAlMHpsHNOq7w3hNZVJMOzpCoIIPX4xm6zYUCkvAFdK9EW4Tv93MYF3
	 Q+o0Y6Zs6f6cxumMVVoFrCHp4/TWFK4XBlhFYq1/zt05BmBHy20vbH+cMPpwDYi3pCoRI
	 IkBg6TflTKXeQ1wVAzPyjyxKMTQBNzsdHOSIREO2ebj9ml+fMdCp+FaTNZ4Fvv1gCHRvs
	 097J8Hm9aNEkxfUaAXk0E16EnEkUiTvV21aMAtVwuPI5/aaa6iwdYF2At9/e4niG0Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOXIp9jH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FF1606A31C;
	Thu, 26 Nov 2026 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOXIp9jH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF621F000CA;
	Thu, 26 Nov 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713297;
	bh=LNLrvcxnQvJha1qURA3bNFc1ECDgKKs6fCmI6FYzJRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOXIp9jHYazwntO8Ap2zx03XbW7xKMdrftiXk1FFY7GSAv8oYyQ01wLqYpj1RpOmk
	 2xIknPlzCAi0jdZxpZHleDe8E2EtpLIi3cElLPZf5KnuMn40b4s6rOL8dsWVkCX0fa
	 oYTO33VwWlQnTFQsflbPhJy1MO/rYfkoW1FmqeapdgnbyrQJbUdLNUcQquOLtW6QxQ
	 3P5vMz8OOfJ5MrYGDdr1tE1TWhVl91VilO+QKsiC/+G2dxt+EVFAwhj+XLzDtb5n0A
	 MwesCwPrl29TX0YTIkwvEnyaxM7MH+5L4k5fdVoOntnz3mt+DsO7Mq3SpvBOTWs5BX
	 Tm8R+sTcD+VTw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool 0/5] Fix diagnostics and capability probes for protected VMs
Date: Thu, 26 Nov 2026 17:14:32 +0000
Message-ID: <179570893511.2890117.634086321709624460.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
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

On Mon, 31 Aug 2026 20:24:01 +0100, Fuad Tabba wrote:
> These are the kvmtool changes that go with the pKVM series confining a
> protected VM's vCPU state to EL2 [1].
> 
> That series stops the host reading a protected vCPU's registers once it
> has run, and stops it setting the PVTIME attribute. kvmtool dies on
> both. Its arm64 register-dump helpers call die() when KVM_GET_ONE_REG
> fails, which turns a diagnostic into a VMM abort.
> kvm_cpu__setup_pvtime() runs into the new -EPERM and fails vCPU init.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/5] arm64: Do not abort on register-dump failures
      https://git.kernel.org/will/kvmtool/c/65d45d30d900
[2/5] kvm: Bound-check the exit-reason string lookup
      https://git.kernel.org/will/kvmtool/c/470428ef30b4
[3/5] kvm: Name every exit reason the UAPI header defines
      https://git.kernel.org/will/kvmtool/c/c6f61255f665
[4/5] arm64: Query steal-time support on the VM fd
      https://git.kernel.org/will/kvmtool/c/d2d15431d8f6
[5/5] arm64: Query counter-offset support on the VM fd
      https://git.kernel.org/will/kvmtool/c/eac6efc9fefb

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
