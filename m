Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB7644E042;
	Mon, 14 Sep 2026 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387444; cv=none; b=eKpw/xyBCTkaM64EJE9MwhjlLKYLp4W6aUmJ1gp4jxC0n9nlgWAua5MMCVqyPGq/QyPRUZghcKJ2HuI6JwkfLJtac8HArYrXp0JG2gNo6bWPHx+3xLR/YDDqR0/HLITOUr8M8eO1khzGyQoUaFmDNFCyORK+iIMbRUjw3CDUyZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387444; c=relaxed/simple;
	bh=AQ75v7+BdkIzbZIO2o7ig31fgvuJI6ZzVDgLtuNq2oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjD47IVWghDgbpOusJ7+bRx5OcgcMeVMN5fUyoTC3t9udD1C+9qW16rJddFQTVYQBBjKrGkMpm1a2er9EbLPOoQ/O6LQWA/2hbvIH4MZb/XTo7fRGF+JepK5te3eY9AKMb2dda5UYg7sA4rMb5p9sWMbV1JeGBtGHo/kMnFiZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=As1LDNmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="As1LDNmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FF31F00893;
	Mon, 14 Sep 2026 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387442;
	bh=1+r7yrwNWfO4qWrGcEbhhzbX1H6jV4wg/ZwNYAWuumI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=As1LDNmPcO+bItnYVTrRKyXFzsST2WVwN3NsdjQa+gtH0tYltoOvs/MvYiID8ZYMW
	 uGcSz+i1kPv1x36C8Y/isIgOBDyE9Hrth8etpgzTc39DCl4L+uNHxMQJ+fFols0dLT
	 u99jdYYXODnOaAWr7x75JEjatufXdb91zP1l7lIKL0ci3ZixB0jm/E/dzAuenS9yuW
	 E+dKsuLKYVWdFjUlxefmmKtR7mmq12sVUXLGOYCMooxkkvOV9MBv7UqGXYRXmCn26R
	 mYGVT4baTKo77Li+8p2NNsO7aFlqgn3tBGrUuxKLyNCqK5hAj6lFz77RNkJBOtpadP
	 /tv8LyrvBbZMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pk-00000008bCx-0CSI;
	Mon, 14 Sep 2026 12:04:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Reword the comment on a collection-less ITE
Date: Mon, 14 Sep 2026 13:03:58 +0100
Message-ID: <178938739490.3215146.14243922330046405279.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817092705.1112634-1-fuad.tabba@linux.dev>
References: <20260817092705.1112634-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, eauger@redhat.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, sascha.bischoff@arm.com, sebastianene@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 17 Aug 2026 10:27:05 +0100, Fuad Tabba wrote:
> The comment above the NULL collection check in vgic_its_save_ite()
> names only MAPC with V=0, which is UNPREDICTABLE. The route that
> requires the check is clearing GITS_BASER<coll>.Valid on a disabled
> ITS, a legitimate operation that orphans every ITE at once. Name both
> routes.
> 
> No functional change intended.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic-its: Reword the comment on a collection-less ITE
      commit: 356abf7cedff742621c9b7ae8ecfa7d0febb0b9e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


