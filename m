Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016083;
	b=pNJLg10wRIyhnsF+K5Q00g4afIYzo9EMpPU5HdvOrkDaZWo5V24z++hO2wU+L5CIzMrL
	 hT+Qt3HUE+PaCy6IKqzKNSbZBwa6aGqAgud/TZ/KNIHJ7TX+PqRbFrbwBGLWV6VpACH7C
	 +Deyd9hsRszmf1TVxEenJ7eULg/8H2MhzNjiuPv5fW+5jKtmxhapqcnTfiu5M50EDGnkS
	 k3rEbc/Z26+50/mV/9QIrM8VtRZtQyXLSTA39joF7kJyntFw6sAprHYTyH57vtjuXdPm2
	 fdm1gxvwLUGs+wtqTRD8I9q66KRw+0zPdhw9+jHnrIfgxgUo/DS03qiIWNqSHGR1iSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016083;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=+HC72Y1jKdcbuWDLnQBb8Fp4fKK/OIykYftoe6H0k2o=;
	b=ZQgY9WUWMMA9TD01wLwMfYLAsuRgEJw23z9HRoKHYo46ZhuRpE5x1PyAQO8nb3NKDMOB
	 d+dhvO2f+s67gh9qVFxy1HAqO/LEgQrrP1QUji1HcQZOx9V/BirCtOZFQrHijfirSxiJG
	 f1sj0i5oxebeUgwvdMHfrYTfCmvqmc/IFdf4RMq9o/uKBlv/B46vGXSZQDcpwxqYH3sET
	 f2RxKjfQv23/CypOkspVmfl3f5bBQ/PsKXb4RDmQgpI4LzGBjNcdG3CuYg7D41/oiX0e4
	 JNOITrVkrMm7XiC5bNAgjjZlaxHD7QOnV8C9lAsgQy6Lrppl27A1pPj4Tx+Ng/l+7Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d4w8gOM9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C6606A324;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d4w8gOM9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1751F01825;
	Mon, 26 Oct 2026 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016077;
	bh=+HC72Y1jKdcbuWDLnQBb8Fp4fKK/OIykYftoe6H0k2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4w8gOM9JmL0XNVTh4Q53d7oRI5ss1U4vYzcbfoJvM8QcKcNnrYW4DDaur8Me2LpX
	 kqVbb0xenDVMDlPVR++8Qo3VyCYxi9U/YQ7Uob3rdjEUdFa8t/lQpk/WLN5c7p2l4g
	 F38TxfpzaCnnyLi3vF/Q6N/PdYORpb7hVJhq+ivHCgHfkRWRLbCkv1OuG1L+XbYNGc
	 7kayykz7VYnhinzVcYyTQa+ddxhRGKK44T7DP/fZJKjKj8QqmGYAqrqhWEcrxZ2ZtE
	 o1v0N2Pn0tQI8diuCvb5PAKTj4flWbairPg/h/QcYA7jV50ElUkJORWKlLOp2hg0qG
	 tfTD6SG3Zs3Eg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO8-00000007Fr6-0u1z;
	Mon, 26 Oct 2026 12:01:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-its: Fix LPI double mapping and DISCARD
Date: Mon, 26 Oct 2026 12:00:59 +0000
Message-ID: <179301587180.2527370.8777107405308568501.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013081646.933312-1-fuad.tabba@linux.dev>
References: <20261013081646.933312-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 13 Oct 2026 09:16:44 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Dropped the second mapping of an LPI at MAPTI, instead of keeping a
>     doubly mapped LPI out of GICv4 forwarding. (Marc)
>   - Keyed that check on whether an ITE maps the LPI, not on whether its
>     vgic_irq exists.
>   - Added a patch that makes DISCARD remove the pending state. (Marc)
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic-its: Don't map an LPI from more than one event
      commit: de81b28f0b83b22163d7d9a9b708d7aa912e0ef7
[2/2] KVM: arm64: vgic-its: Remove the pending state of a discarded LPI
      commit: e99ff76f4a02be8542e2c3ecc8843d7339a0200d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


