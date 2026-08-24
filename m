Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0044E45090A;
	Mon, 24 Aug 2026 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787587339; cv=none; b=bNGriDsgk6ww/33b49lwjdlhZ4hqNKEMDQTDQ0qgWfj8nav/eL9F1OA8Qqw29itRB2qKgVDK9Gw0ZBlWsVSrb0vgKq7pmprsFXXgGS5hyOmk1rtMtPHs0J80bIQj5oMio1qrxOskKFPedy/+A662L8l57NHTyyXbFA09ayShxWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787587339; c=relaxed/simple;
	bh=OuEuuVDsQIU86m+JZgDF7i1IaRiOC6ZzryaqZNvCmGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THptJ/eHtpp18ZLiYedfQxI6tUt/XgZvXgk5TU2LaoME+Owghn9qx4uOglGhwTUtk6Ar6tSUTA6aagYX4lPxtysKXgp5Clihz11Kgq1kljCll0HZHajCQ/I+SWUcY6UbQ24jkokprlJ+vOsqeJydcfWZipca4bKCFyN6CFgsdRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oL3MYuOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oL3MYuOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366391F000E9;
	Mon, 24 Aug 2026 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787587337;
	bh=wdoFeUu5GvTX8rBFW3cJrIUVf+aY84rF9rqx5dNRKh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oL3MYuOo1TlVQzpRjyI9MYDJjupL+OGdle/lbGRs24gLXCWfSvbXMzpZ26w8j6Wt7
	 so4DQmY9Vpwe5btinEUOafrffDEs+bX1qvdcgXuVjFDABJU3UhlplZsMEs+pn+KLiU
	 eFyQwioGfNqyHYn+4Avwf6lR2nSSxOb32VpzxcvmIvaNy+y+bO6LkEWd446Fpl+roM
	 Swjz3YGlKxnwymVXA2OcfSWQ8u85pPZTA2QoD/ROGDcL+TCmcJQBGO7dFuHpccgLTp
	 J6zuh+EMKWPnBtNg+0EbP2D+W0psfn8WYrDOzG2HVgF0TrteSW9/i3/AM7gtb09M/Z
	 a/cZ5XJ2MGr/g==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v3 0/2] arm64: ptdump flush fixes
Date: Mon, 24 Aug 2026 17:01:55 +0100
Message-ID: <178757828014.164243.15117526586847861889.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260814222458.584906-1-weilin.chang@arm.com>
References: <20260814222458.584906-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 14 Aug 2026 23:24:56 +0100, Wei-Lin Chang wrote:
> This series fixes two problems around ptdumps:
> 
> 1. note_page_flush(), which flushes out the last row of ptdumps, does
>    not account for address spaces that have IA < 64. Other than making
>    the last region extremely huge, the attributes of the last region
>    within the address spaces appear to extend all the way to 1 << 64.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/2] arm64: ptdump: Make note_page_flush() range aware
      https://git.kernel.org/arm64/c/902caade3cfd
[2/2] KVM: arm64: ptdump: Flush the last region
      https://git.kernel.org/arm64/c/beca1b97a21d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
