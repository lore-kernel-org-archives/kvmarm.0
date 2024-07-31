Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD5E1396;
	Wed, 31 Jul 2024 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722452358; cv=none; b=PDtlivMRGGJsFIRoZ3JAo7gpxwse3Re6k/1EiMYpfOUp7UZAWPnZo6K3A/O+Aqi0BTdjXNiAXLaLjEa0i9D7w2QWA0TAWEFFtWuMweMKdzK8nfAglfV8NODveT2QvlOTRuwxS56v81Z8uOPCdcZskNJLGzIcG4Fcewvl9BAGUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722452358; c=relaxed/simple;
	bh=IIxkJ+LLHYSF5s/zfFF1eKcKu6RdZFrjQL0BFWoTo/o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=P0m1UmqhaC+lf5STWgU9LNzo2HZB4OWi0ncw8qgPhvsZ3Br0VvaRx+/EgURxSO1Hh86phksFPPzjINkHoHlFQsD7DSc+73YDVpAcaztV4sZo9WwhZDEKW1H2dyptC4Djh+/0do4h18qI6Kvm0E7eZrorGqniquFITlTOtPQlr6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcwZZh1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcwZZh1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6017C116B1;
	Wed, 31 Jul 2024 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722452357;
	bh=IIxkJ+LLHYSF5s/zfFF1eKcKu6RdZFrjQL0BFWoTo/o=;
	h=From:Subject:Date:To:Cc:From;
	b=jcwZZh1XgVTFtdiGExPIP7jFzmY0PpPU30sHhUcK8L/S2Yg4ijFU5xbGYm3S3kyYV
	 FeJgvkBIwiWrRA8FonjBsmw+9n9xgiZhbDeJUcy1E+26/B1ZUe180QwPOxd91AjdYG
	 W7bdefqPLDXoD+Fnd+YfAK6bwYFzXGKW6lJ6MJe4y4hn8GT/imKOPAg8yo6EFgsDCp
	 VuKPWz3eM622QWeEXv2FoLjipBvhqs/KlYd5sirwlyw4aY6rKGtP9fuTMA+DWRYbri
	 pUA6ccbktEaCVw/88FJKUtYdCklDeDs3M/JtT3HreH5HY/w552Kkh8IBS1L96BWMZ8
	 dkKjmR0jJNrMg==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Fine grained traps documentation
 clarification
Date: Wed, 31 Jul 2024 19:58:36 +0100
Message-Id: <20240731-kvm-arm64-fgt-doc-v1-0-abb364f8fe57@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAF2JqmYC/x3MTQqAIBBA4avErBuwsjG6SrSQHGuIftCIILx70
 vJbvPdC5CAcoS9eCHxLlGPPqMoCpsXuM6O4bKhVrZVpFK73hjZspNHPF7pjQkuku5a8NY4gd2d
 gL8//HMaUPtlErV1jAAAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=691; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IIxkJ+LLHYSF5s/zfFF1eKcKu6RdZFrjQL0BFWoTo/o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqomBCLHIbVaYACy/dLCOdZqN+VAb+rwmgXoapvB7
 oU+PVwSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqqJgQAKCRAk1otyXVSH0A5EB/
 0QurbYEG/u2OyMRbdKZa6f1yyjuNQh0ZsYGWibl2UJ63RPg23h1L8aeo/IyC20qYw2adus+iyEhtXk
 c8BUxBwAFP8jJv8ov/BjizHGutauGR779w2ylyPuhTKNpzHjqHCAvM+F28wvhYANyVtn0wWmHtfnT3
 HdrtO2afgS31K73HoHK+WEGb6wYBXJDD+2LIbRwOGQ08Lgy+1mp/uLqnjRrDyYm889lkr5F/ylcFPF
 U05Szpkv1sPMRujAj0uTMhx/l/3Phy9a1LqPhV6H7Vq0fFPsJRZQ5Da1JNqQSKUe2Cm5mCZ2qCJgOe
 d5bfBxQaxZaye7kGvh+mWLOtcJXcxN
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When looking at the code for management of fine grained traps I noticed
that some comments were out of date, and that there's some potentially
suprising usage which could usefully be clarified.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark Brown (2):
      KVM: arm64: Fix outdated comment about incomplete FGT bitmask definitions
      KVM: arm64: Clarify meaning of _MASK and _nMASK for FGT registers

 arch/arm64/include/asm/kvm_arm.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
---
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240730-kvm-arm64-fgt-doc-a664856fa7d6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

