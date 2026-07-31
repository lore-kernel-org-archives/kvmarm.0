Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C1647D47D;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523914; cv=none; b=c0CbdEQTxGTZUjwwM4GnGbZiWncDXiEOIMtkYDAy0MV/Ec412DXNTXlzuCVXiErnWqk5tGg8FwvU7RG3EsWF08CI+gAXGjCf4Gvi5cKYFrtbZdeUoejJa5/uU0muNyN4Rxo7Jwf3T6U8EeDQB+m1ahEmyKXEBJyL4HaGkOhhRBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523914; c=relaxed/simple;
	bh=UHlkNh16JUcEv10OEylQzEQp8c15D3lx9jdjWR5HwaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjASvI/qhzFTGwpD/bdPbxjgK/8ZFEOnwyUgogqFSij9m6hLDepWD8bOmkSrkiDsW8FSJiqgVsKebfyGgmgwlq+2wId9ExMOFL8WhgJST8XpQumvmJlq3zwUZWp4c2SC6FZS5j4kUL1Zv9OKUJL1b2szkFlMT9gpm6naNjPVLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUKHKA1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUKHKA1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8C81F00ADE;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523913;
	bh=8KTNxMlIN0pnUs3TRuIuX660Ecy/2UP8DgaHWLgMlGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUKHKA1wuLnW5C0nJ6eCTWgN2NNB2COcAONC9dmowBvJRyotWWR8nJjY800XArEqm
	 ShwKrH1J/wpVbLwroRnNcWXS2yTGwg+Xmn1DG0kfYC/i9lqP4XQC1LyQguPB2rBJW4
	 LvAyR2GZISsiCYTTWJyK2hyGmHHWUnTUEraodNLsn/YhThYMIliE28HLD3aeUSnDrp
	 hXzLGiV/dfTSLQaAFJrW3bK/JOxT81dKGG3NQ+fHJHoG5i6WbVy2lnEvSG1uYkQM3o
	 Dn7yZytY4lSMzlxVyDiFZZ+FV2g9hKegE2LYD3Ypc+7ccfI49uPxsAZo0qn+rf7+4f
	 vuM3y+awkqg1A==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host-directed debug for non-protected pKVM guests
Date: Fri, 31 Jul 2026 11:51:45 -0700
Message-ID: <178552142330.30097.7850333849629828287.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726143643.303456-1-fuad.tabba@linux.dev>
References: <20260726143643.303456-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 26 Jul 2026 15:36:41 +0100, Fuad Tabba wrote:
> Under pKVM, host-directed hardware debug of a non-protected guest
> (KVM_GUESTDBG_USE_HW) and userspace single-step never fire.
> 
> When the host owns the debug registers, the world switch loads
> MDSCR_EL1 from external_mdscr_el1, where the host's MDE/KDE/SS bits
> live. flush_debug_state() copies the guest's debug_owner and the
> owner-selected debug register state to the hyp vCPU, but not
> external_mdscr_el1, so the field reaches hardware as zero and the debug
> exceptions stay disabled. Patch 1 propagates it.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
      https://git.kernel.org/kvmarm/kvmarm/c/119a9a23fbae
[2/2] KVM: arm64: selftests: Add a userspace watchpoint test
      https://git.kernel.org/kvmarm/kvmarm/c/3be99f8751c9

--
Best,
Oliver
