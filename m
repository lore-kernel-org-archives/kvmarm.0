Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB83822A6
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779348244; cv=none; b=kI/h113HNo2617SIdwC85fawEtyKx2wb7wCsl2InrGQ2XajXhhlnhpFUVSmhBkN1sPwW6ABzyB8Wvmw+GpzmA5BTB3TSOws5JwgPSE4iEFZiAcsN4JaeoVuImi/tCbxBseKQtrkD2NrQkkUeichoEKyHFH/k69BJBCunOidDOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779348244; c=relaxed/simple;
	bh=+GtKe34NQJRkwWcpoH5k+38+Z/YnSzTWSKQDmveyYYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ULbwZq72NRtVk9109vfVIpvDR+CUhsYIn7p/K0f6UsJvgy5WfLmr9O7495lA5+ozSBB8SHHR84n+uDhnVDkIf7J8dm1ZhC3qSvhj6ZG9dcTDf/RdgrxeIl6rPA9bai96jxmiB8aFiI9MzyiGDzpavSL/almPtw2wssJ8lJwwcHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjqA0ycI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjqA0ycI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB94B1F000E9;
	Thu, 21 May 2026 07:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779348242;
	bh=c+BTPzwFHZ948TPCCS1PkFHsl/ijHllcNoizkXkiAko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjqA0ycIY0OPkblMWXDLTZoRMh9jRc21EsGC6/SPZ9vxmrdT6skIxTFPE3nq3GUq3
	 awRxuw0YNXqx6f/zVvpsnAirWc3EMi7KFiP3GVSblNcoRRzM0eqoPp1uj8sr0jCPJQ
	 gbZGryXlXAdd54pKv+XBHJNV/VA8OXQ+3l9XUlh2bHryK9mIEW5RpanmG2xoCzeFTK
	 GuYX9dS4C0Oa7zRY7u3WP3qauSu9GjaJei7ikUi8U+Mxcg12b5QqmSPBjjcaOyzzMz
	 N1lomy02lSb0O6Y4fb3LcqMvu6HnpgLLYtBiHYzhhLh3u8CB7Cne7/i5k1EN6J1wKj
	 C3Z3Xtnk9keyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPxlB-00000004hNd-03D7;
	Thu, 21 May 2026 07:24:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/6] KVM: arm64: Don't perform vgic-v2 lazy init on timer injection
Date: Thu, 21 May 2026 08:23:42 +0100
Message-ID: <177934819510.554756.1987942775987270934.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 20 May 2026 11:01:54 +0100, Marc Zyngier wrote:
> This is the third version of this series aiming at fixing issues with
> vgic-v2 being initialised from non-preemptible context.
> 
> * From v2 [2]:
> 
>   - Remove the PMU's irq level cache which was hidding in plain sight
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to kvm_timer_{pending,enabled}()
      commit: 68a612d4dbc7f2b9dac731c79676a21fce573d29
[2/6] KVM: arm64: Simplify userspace notification of interrupt state
      commit: 0d27b4b351493cb2fe1f87cd152856704d4e141d
[3/6] KVM: arm64: timer: Kill the per-timer irq level cache
      commit: ac7002031852ab8f75b3debb1a4c4b2d1ff5a26c
[4/6] KVM: arm64: pmu: Kill the PMU interrupt level cache
      commit: 2772383afc5c65d6242f62947b5c184ffb049359
[5/6] KVM: arm64: vgic-v2: Force vgic init on injection outside the run loop
      commit: 1a8685ed8cd1ded20d0c81070a49b1cddf70481d
[6/6] KVM: arm64: vgic-v2: Don't init the vgic on in-kernel interrupt injection
      commit: 958023d269e0312d10da85a6a49438d2e107dead

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


