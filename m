Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F05C30B507
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762944899; cv=none; b=dpPBvSnlTpSZ1m7QF/YvUMiRKVuxSvNsjvHi+fCh86zINb53IggZCG4jnAi4T3eD1MFVtHbh64xpcndrt4L81/7OKheWctcpWvDf0+tjYpDpaibxBTCZYP7HD3Kp7bwJpKtD7FJME4oSmkjr2WLLu+2TThi1KT7fFeCbakC8ix0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762944899; c=relaxed/simple;
	bh=W51dKg5AAstr6djaoD8uG/T3R+JrK/bE16/j24kPxSc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=InKSqb3VaFu4mT52bg9bZyuK168dKyKDlBt8Lx5HS+5fJsOMit/WN7rn3lU2Pw5uwrejBxYtNQKwOvMC7NHK5DM6KKXA0lSOtQkWc8x0ZgVHRh4+QAP5TiYSutI82etOY1GhvbR5uvPCifc81WP+fs6OZkh4w8U3aklmkRKeGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qu9C9cIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qu9C9cIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D6CC116B1;
	Wed, 12 Nov 2025 10:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762944898;
	bh=W51dKg5AAstr6djaoD8uG/T3R+JrK/bE16/j24kPxSc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qu9C9cIXLuXFWuyGDg1uBYoRwByiVd1c5b2SUc0CWhywiOcSJ92iu7cn7IbmsJ+NV
	 Wva7Om/yNmnG2qu2qLiCZjed3u8uY2nHLWHmnJXQ/ZWFNnXXlAxaAFsBVMeAGB6oQD
	 Evxo0hSlLGBjcGiWBKYdlQzfWD7AhMNXdec5XuG88Aq1VckKBoDaGKgnZ8+TBi784P
	 NyR5qevJIIWdEqGBdsq9NZumjHNQrUHV9gHta5If/u21whj9HSm+DfOIl7PfBDKCUW
	 93z3iFlzl59Qyz7TrdCIHmPCOAv0AoFPjOCHPxJmXLmKqv9SLTy1F2Er3uAD25ij8F
	 8oaJHWzC4qk9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vJ8V6-00000004VdI-2xmh;
	Wed, 12 Nov 2025 10:54:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: VHE: Compute fgt traps before activating them
Date: Wed, 12 Nov 2025 10:54:53 +0000
Message-ID: <176294489353.2146675.1598964023376256637.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112102853.47759-1-alexandru.elisei@arm.com>
References: <20251112102853.47759-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, oupton@kernel.org, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 12 Nov 2025 10:28:53 +0000, Alexandru Elisei wrote:
> On VHE, the Fine Grain Traps registers are written to hardware in
> kvm_arch_vcpu_load()->..->__activate_traps_hfgxtr(), but the fgt array is
> computed later, in kvm_vcpu_load_fgt(). This can lead to zero being written
> to the FGT registers the first time a VCPU is loaded. Also, any changes to
> the fgt array will be visible only after the VCPU is scheduled out, and
> then back in, which is not the intended behaviour.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: VHE: Compute fgt traps before activating them
      commit: 85592114ffda568b507bc2b04f5e9afbe7c13b62

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


