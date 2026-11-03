Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711186;
	b=IfqgoaNYu4mBR9o0T5kwcOXxS/IQOraoOQQozKjEWfEV0wmBmshod38gbd4bRPd6/SVA
	 XDG3Ia431E+UmjBdxn5hol5qr4tuLbzkqTDoEdSxzDmhelqp392ZQvMeAnHuJGgB1u820
	 JD8TQ1Kd+QTv+YM9kY0r8Nq2a5kuY8rskoU8lfU+xgsF+OxvHCQfXCfSV/moep4ydBo0J
	 FnvYwUJ/bf+gE/cTbHKZuNy8GFTnMvQkWykcUYdIsw5Jur+/sUMxoTBqVOdDnUYl/NZRf
	 dI2SJbzOLoRjqkL6BQKO4JIHudbJ6jaKlXk0QRDZP8yfXxtwjV7om/dL0Ap75hxPnDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711186;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=x/FsVPxFZdwretPYcMBzrm58LiH7fpqIQNmVBOK7HkE=;
	b=fkeeD0EONqgUgSAkk/xhuH0yndtNqVTRBheH4n2BQ5qnCtyTDhoTEDKp3DZ+yeiXRmjL
	 2h4URdiJrJvNpB5NOTawUX8zhg85v/0ypq8KQ/GbIzyUitNf6hmSjDLH6dN/IxgbBbC2M
	 gPP6a18PMD6yA/zrAvKT67tkzF0F2tnrZLIWxvBS6XyMU20hI6qf+3jamFFwyYtoR02TY
	 y31HLZ2zaCRCsOBGBffdjkTpoAZgxgOOQ+9kXKRkJhATFIXXZ6MrM5rBgpMkCq6Merpct
	 O4hQrO8KuhPOPwxUB4JGeefgI/qBOpfFdzm4xV1MUKyan3uyq0Ojv78fJ/F9Zl4N62Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfmHz4Fz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A68606D81F;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfmHz4Fz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8601F00A21;
	Tue,  3 Nov 2026 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711181;
	bh=x/FsVPxFZdwretPYcMBzrm58LiH7fpqIQNmVBOK7HkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfmHz4FzxU3w2f6jRloSc2Y/6x40zsf77FmNb/Foh3p4Ddi8OE4c1dyG/Nt0Td3P1
	 2bu28l1OXKmGYoxdGFrh1XlLJRsWqVlNo/Hxx8DwnZMwLKxKuUHTKYjL3jWjlv6dip
	 Mltp+8YTjUVtgPKhYdcCG9xZanU71Ppc2bCANdoxCMd9IZXfQMVFpb75hcAvgtEbn7
	 chdrUYNIoO0S99LN+I4SAlE0QYAN/Egc2Lh5MBNrn9YebJkNeCRSGQeLjVT4DczdKM
	 qwOil4H/LbiwXpQ16/pW1Zfy68zb20H6dozXRVo+Nx78UolqCu03HKyKyuQ/srQIw0
	 PJSuV5qWDtZDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDT-0000000ATWs-1Lis;
	Tue, 03 Nov 2026 13:06:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: Fix PMU handling in pKVM
Date: Tue,  3 Nov 2026 13:05:37 +0000
Message-ID: <179371111276.2844725.10156435514804417873.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028153152.1740044-1-fuad.tabba@linux.dev>
References: <20261028153152.1740044-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, vdonnefort@google.com, kernel-team@android.com, linux-kernel@vger.kernel.org, oculytic@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 28 Oct 2026 15:31:49 +0000, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Stop the host's counters with PMCR_EL0.E rather than the individual
>     counter enables. (Marc)
> 
> Two fixes and a hardening patch for PMU handling in pKVM, as one series
> [2].
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Synchronise kvm_host_data before host deprivileging
      commit: 9e29ea628848d29eea948200c4357f530b0e1768
[2/3] KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected guests
      commit: 8ee90ca40b10cc040544fdccf24b20115f46aa7d
[3/3] KVM: arm64: Disable host PMU counters for protected guests
      commit: a7dd36f7e381025bdf01d8665bf37167368754c4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


