Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9882E312836
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 11:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781697068; cv=none; b=rQBOBjSqo2o1jH8dnM6KbUYM3FSQ+wovveF8eBUHG2aVx9LA+Nyj7j+i2iJI77dxgS2f3lOk9ZtX0o9FUTEL+LJSATo16YKhjyvgmgUvTw6yG4GWMx1fFYcQuY/OH+SWaVcT9GOWmVoB9kD2hUvQTTZxJy41TNm/i19A93dZr30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781697068; c=relaxed/simple;
	bh=r4P6fqvvPlqC7mzElmKK2uCG7n1BWaR6PbMjjhRAw/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjN5982FSBQGl+MSEB10A1YQ5UtADQrw4SmxFkzmvLqTiP14Xfu8EmPdEK6h+hsqS2d/x7K39lPYeiPu4JQFxFCaxWLqUSeLRkVp+A8aHz3wjLYwVvjeuUhC39oNB43k30chbZ/PGKzG7mLDYkEJof5iCaQgJ77qEd01oSDbW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxImjCxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxImjCxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4484A1F00A3A;
	Wed, 17 Jun 2026 11:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781697067;
	bh=KgA1DgykL+BaLbXe50RwqPlxXpHwqTaPNyBnZhqCTY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxImjCxvE+lHto3qs4QaQj4Ltb4uvswB13be49XyOM1tQ0UXBgtA8nb9sY8StdBQr
	 ztYmWbcupuy5+8g4hrq9y8xRW9GiQacgluovZZdxh+Fe8/gp4S1b8+B7pDQ0O3Iqxo
	 8bAr+6m7Tddkz9kzQr8z7PX5q/3QWB6vsa14rQOlgqrKqX8N9N5rWMeHEm4OiCSUsL
	 3eoOenBhNRPyZC+5mVu9tnIV1MdmjxtPh3RiSvXx0VrbIW/kbdnDz7VIxXlU0GU6i2
	 RvLpS6SbJTOm/Q0dkZ4xVoJtQbhs44Me58IsBpD4Zslm7kl/0A4fTAHOskc2fxMnck
	 bjUUSmKLYMZIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZonR-0000000DfJC-16tQ;
	Wed, 17 Jun 2026 11:51:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Sascha.Bischoff@arm.com,
	jic23@kernel.org,
	timothy.hayes@arm.com,
	eric.auger@linaro.org,
	christoffer.dall@linaro.org,
	andre.przywara@arm.com,
	Hyunwoo Kim <imv4bel@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours before migrating it
Date: Wed, 17 Jun 2026 12:51:01 +0100
Message-ID: <178169701874.3049015.8446502456304236098.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aiHnI1mu6SGQrgnz@v4bel>
References: <aiHnI1mu6SGQrgnz@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com, jic23@kernel.org, timothy.hayes@arm.com, eric.auger@linaro.org, christoffer.dall@linaro.org, andre.przywara@arm.com, imv4bel@gmail.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 05 Jun 2026 05:59:15 +0900, Hyunwoo Kim wrote:
> vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
> an interrupt to another vCPU. After reacquiring the locks it only checks
> that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
> before moving the interrupt, which assumes that an interrupt whose affinity
> is preserved is still queued on this vCPU's ap_list.
> 
> That assumption no longer holds if the interrupt is taken off the ap_list
> while the locks are dropped. vgic_flush_pending_lpis() removes the
> interrupt from the list and sets irq->vcpu to NULL, but leaves
> enabled/pending/target_vcpu untouched. As the interrupt is still enabled
> and pending, vgic_target_oracle() returns the same target_vcpu, so the
> affinity check passes and list_del() is run a second time on an entry that
> has already been removed.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: Check the interrupt is still ours before migrating it
      commit: 0074b82cdfcb5fd13710a0ac308ade68ac6f6fbe

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


