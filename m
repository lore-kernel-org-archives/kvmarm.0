Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD443090C5
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530948; cv=none; b=ij4hplLytun0jbnJ1XppQtnT8V9+SepRKQfczeTD9Saw5hkB4YvtDHWlfDEuD0DNeHAWTxMXsB6U6xSlU9OCddbxNCvsN8Hg/KdGLLdfUg1vTKncBRGsGUvvp+/z+iN+lsAFF2UQL28WQjVeMraINCbzRfWoODvhFfeyB9eWCDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530948; c=relaxed/simple;
	bh=8YM89TR8ESlH9uXvQIG3bjZUMpzfvj2JghPjrLRps88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Izcq2bHxXtUNw3N347kTDYfq2mHmGiilCzd6sB2tvPCeVtqK8tcWrzUuPoaJj7/A/TqjK2mWNA8jnEUC3sXHEliYw8BwU9pKyvtOFDm8K75zPbS/8nqAX5N3jv8QToY6Bn1zGD1Zuf0uSKPxwuVCaOK2jat3rRhF0BBvh/XzRXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6opB5RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6opB5RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9D2C4CEF7;
	Thu, 19 Feb 2026 19:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530947;
	bh=8YM89TR8ESlH9uXvQIG3bjZUMpzfvj2JghPjrLRps88=;
	h=From:To:Cc:Subject:Date:From;
	b=e6opB5RIIBRRUufZz+aXCx+Uv/ghybkibkMn9KTUq6OF9QaCypEs7PWpSM2MG73wC
	 T8qvl/cX8C40crQqzgI0TdnD2ZHsIfhvGw1cv5mQjpR+zxU80wuBJ2wh8qyPi2RpSb
	 kH7F/cCwZtOmmcoqioIk7cGxqMsxxRu0LBv7i3v+T7agq8K1HJSau2oCjWIC7CCASP
	 KiYDKB5SNGeWXuI49HVDLB3qoTU2ttdCZAA1vqpNoYV1/t1kRHkpL8ZaENuC79LMqm
	 jX/90eZgUNFuf1DC+bQc42GXhsQLBiuhes+vNBIijEmJSlPntlNV071x+FIT6N7Qb2
	 WiWds5c57Xfmw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7l-0000000CGHL-12ja;
	Thu, 19 Feb 2026 19:55:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/9] arm64: Fully disable configured-out features
Date: Thu, 19 Feb 2026 19:55:23 +0000
Message-ID: <20260219195533.2455736-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Fuad recently reported [1] that when support for FEAT_S1POE is
disabled, but that the HW supports it, the sanitised idreg still show
the value the HW expose, even if this is hidden from userspace. This
ended up advertising S1POE to guests, without the state being
correctly switched. Huhum.

We have a point-fix for this, but it would be good to address the
whole class of similar issues which affect PAuth, SVE, SME, GCS, MTE
and BTI, on top of S1POE. Not we currently leak state S1POE-style, but
we're just pretty lucky. Hence this.

This series tries to align the behaviour of a config option being not
selected with that of the corresponding runtime option (arm64.noFEAT),
with the exception of BTI (but I'm not married with that particular
aspect).

There is a lot more that could be done (Mark has a lot of ideas on
that front), but I wanted to get this out and get the discussion
going.

Another thing is that the proliferation of config options is getting
in the way of maintainability, and at some point, we'll have to pick
our battles. I appreciate that some embedded uses rely on "tinyfying"
the kernel, but maybe we should think of introducing something less
granular, and have KVM to select that (the argument being that if you
want the smallest possible kernel, you don't want anything virt).

Anyway, 'nuf ranting. Patches on top of 6.19.

[1] https://lore.kernel.org/all/20260213143815.1732675-2-tabba@google.com

Marc Zyngier (9):
  arm64: Add logic to fully remove features from sanitised id registers
  arm64: Convert CONFIG_ARM64_PTR_AUTH to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_SVE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_SME to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_GCS to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_MTE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_POE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_BTI to FTR_CONFIG()
  arm64: Remove FTR_VISIBLE_IF_IS_ENABLED()

 arch/arm64/include/asm/cpufeature.h |  13 ++--
 arch/arm64/kernel/cpufeature.c      | 117 +++++++++++++++-------------
 2 files changed, 72 insertions(+), 58 deletions(-)

-- 
2.47.3

