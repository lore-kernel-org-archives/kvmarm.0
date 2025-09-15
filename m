Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6256A1F4CB3;
	Mon, 15 Sep 2025 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757929934; cv=none; b=prAaStvuj8jbT59fiZ7vXPAmUQpKjjKmHOC9318C6pBpzUI0i1K1xjMdwr9vs8dLIp8eIIAWjxSytUkSWjl9f5GCrMUWgL60tR2DmiksnAVL3LgVeSBqcotMyuQz0hF8OLEMs+OUEFFjCI+78inFq/XBrvH+yxFuyKKVVHkIXGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757929934; c=relaxed/simple;
	bh=GjsbRcQ1rdxsj6BWFVjK+U7PKN7gG/WTi1mQQDE8eW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=osboKOc3LVJyIQrrentTqgU2j3ocg56o3l4Uh/duBy/A9i2pKsCnWM5AAeFzMeQlNaPBFprQlBPHQxp+tErgMBWukiMqK64wCXTmseYaY7m3CgFhP0GmrVj3+d6kfkbSqXVpK4K6SMSyHYlc1RyvFh1mDlaqWNtfR3a6KD+fXiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgAMqD5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgAMqD5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF4BC4CEF1;
	Mon, 15 Sep 2025 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757929933;
	bh=GjsbRcQ1rdxsj6BWFVjK+U7PKN7gG/WTi1mQQDE8eW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgAMqD5LBxWWoMnDPGyehZfx3mwCIVEBp227sZI8Bps+DLRwRCf7EjlySL6TkXYHu
	 RAN8tG0mZDilVFHBgATHxz5VQTi+zhdstpNWX3fgHLW7e5Euj2HDnv4cDIv444nd5P
	 IJGQ5Yy9OCzpiGCz9SlQVMvEPPT7/iZ6k89Z486a2B9YLLb01y1POsr3NM+6PWrFiT
	 KbvQRoQuLwoM72R+37FgV/ZEF8DphUiZz86yz2HCEsFf49dMtxUrVaDrt8V3zQ4yog
	 GzVMXByJgjcxqRXk1DMxKnGB4TnR+/FlXHMlt4APAlMDXzXbweNjnMLvjn9qbKGMyM
	 iw9wjC6BMYBmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy5sZ-00000006JY2-3pOS;
	Mon, 15 Sep 2025 09:52:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: ptdump: Don't test PTE_VALID alongside other attributes
Date: Mon, 15 Sep 2025 10:52:09 +0100
Message-Id: <175792991797.521490.13445837593336164540.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250809135356.1003520-1-r09922117@csie.ntu.edu.tw>
References: <20250809135356.1003520-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, r09922117@csie.ntu.edu.tw, oliver.upton@linux.dev, joey.gouly@arm.com, sebastianene@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, anshuman.khandual@arm.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 09 Aug 2025 21:53:56 +0800, Wei-Lin Chang wrote:
> The attribute masks and test values in the ptdump code are meant for
> individual attributes, however for stage-2 ptdump we included PTE_VALID
> while testing for R, W, X, and AF. This led to some confusion and the
> flipped output for the executable attribute.
> 
> Remove PTE_VALID from all attribute masks and values so that each test
> matches only the relevant bits.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: ptdump: Don't test PTE_VALID alongside other attributes
      commit: 8673e5b22e1e114213d3ca74f415034aed45e528

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


