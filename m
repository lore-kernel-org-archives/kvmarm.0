Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092224;
	b=esmIIsI41BjI4i87ZBh6Pg8LKhCNKhhk3HPZSkhJvxYfeFOVIRAd8NRS3oYVypZ6dKvh
	 QYDvaprrs+WPwqJXKOlnqTTNfdYO6WyKEu0khiX3nDdcasBIs3swBgrhhGYQyiWZVTKu1
	 te6yz0O/xs9u480wWgFO6zQo/QjYX6a27zCbkNstg7jModGThD4Gf/Q1J6/FQdcxRnY8N
	 g4ZeDA6c37AD6RERj8C5l0KV/Rkc351qPr0km3mMg2TyMavHH2HH900tQLo1Ak/KrbnqE
	 RIVytxzE1hldnLeVHxq/AI6C9yNQOOirbBeh32awqC23Yg2gEoyN0zXaHv4H6G/5Oog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092224;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=MV1WHVPKTUVmKoT81wiPNJQZT0AAyhIPe0JlDUZG48k=;
	b=bRJFTL9naBow5sJArn9Roh16AcmWZYSdmrEpXfGUsfvKsVl8rOSMVwBQhqn/GhEEUynd
	 mvIyNmN4KR0zvRSLWehBrCO9qe8+t8LUaiAhp421UKj9McMq9siMpRyQAIy53rEOyDL4e
	 Y0YmqKnith0ydP6wwH2G04QLuVyy7bZQpRJrE5Xpw8pdoATyymwVi0wemiv5dQ4fY2Lf9
	 aXJxNvVfbZgaMDbSxx4OxpPIMW0onQJCerDha9I6BawV4UdcL7a+3c5C4cg9gmVaxm/zK
	 nlrVKEMbUHwHEcQKbCpTSQf6GpBUubax89cRlxpxyI0mdYy0SVYjHXn1fX8NPYMMmaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B0V/A88E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB8A606A324;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B0V/A88E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581AF1F000C6;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092224;
	bh=MV1WHVPKTUVmKoT81wiPNJQZT0AAyhIPe0JlDUZG48k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0V/A88E2oQSG9Ls6HnPzc/w2ZSYH5a/v/VvtYjLpNGlgxEyecPSwIq9gYsL7nv+W
	 YTHvvCwoZbgSbU8W/1k7HV5Df4a/f1Seaf7asEczEi+T+stt9NZHdcuh4gnxQbmYiA
	 jORqWFjaE1iT7k/NbqK7D7OoAMDMm6ywZhSwWtb4aGgzB2yENGXtKjltDWDzuB0tf6
	 TTO8nvF5ExsAhurVhrnr6DpvevtDInxhZJAlHRAkDDiD24n5Qwj77OZnLesHcD9cXh
	 XJS4aZ5jHsf+F7bsZzySIw6dem4RvviGWkgYkMVXDPfxgeXE3kezOjrqbp8bHxlEmx
	 alHcHH2b55xsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xU1UM-00000000RvW-0fF3;
	Thu, 19 Nov 2026 12:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Colton Lewis <coltonlewis@google.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
Date: Thu, 19 Nov 2026 12:43:30 +0000
Message-ID: <179509215927.3938200.1755215677942737645.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118203625.743428-1-coltonlewis@google.com>
References: <20261118203625.743428-1-coltonlewis@google.com>
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
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, coltonlewis@google.com, leo.bras@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, fuad.tabba@linux.dev, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 18 Nov 2026 20:36:23 +0000, Colton Lewis wrote:
> When commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive
> fixed-value bits") migrated HCR_EL2 fixed-bit masking to hcr_feat_map[],
> feat_nv2_e2h0_ni() was written as !kvm_has_feat(kvm, FEAT_E2H0). Because
> ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where IMP is 0, NI is -1,
> and NI_NV1 is -2, !kvm_has_feat(kvm, FEAT_E2H0) evaluates to true when
> E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1 writable instead of
> RES0 for VHE-only nested guests where KVM advertises E2H0 = NI_NV1.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
      commit: 0f1bdabb82be5d1b5401364cd828caf0985dad48
[2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when E2H0 is NI_NV1
      commit: accc93b77267b739b48ab34cb5bcaffd1fbb5db9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


