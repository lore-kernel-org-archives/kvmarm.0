Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467352FF657;
	Thu,  2 Apr 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137045; cv=none; b=beU2s3JcDAuyxFJzBMNROIN0qmmediu6o9XuSqLy8AmILyQVjqZwpyKjJHkpeJN86gGEbUfbXEySPhQk8caEt+Y7cFHuv3axaVlwmo/A6Sd/lhTb2fLHvL9t6hMJw/c58qWU5xjNHBChgaTwWOeuAMBP0QCKBU6zA5bCg2CrKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137045; c=relaxed/simple;
	bh=zOLl2zJty3v/3SL++/5OhGWVR+MQwoy8O/9OeF3iLhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htLOOOCluF/4S8SUq97w6MVgfYYBhm+n9Hg81hBnuCiE+JH9urBY4dkoJ1YkPp/eOOdxd6MSHE4Cz0thu9W63elngTj1eynQJklv29g6iK0Wtjj0yQW6MXPaxP0LpHmZ7ox0ZmwNaUxFZ39RE/B2ejJe76k7UUrVlcfpyyxW8Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWiykH+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWiykH+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC369C116C6;
	Thu,  2 Apr 2026 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137044;
	bh=zOLl2zJty3v/3SL++/5OhGWVR+MQwoy8O/9OeF3iLhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWiykH+KnngwBxMMvwHVo54ng/SX4xFjoSNIDL1dbVb2mBcaFR3BK5KB2irAnW/4r
	 ivqHaM6wmllhW6UxJUZJEtD/C0hYKIbeHtDzXw8NVXnxVC2noc2gyiCdCROUADqo2b
	 ApmhdLms6RfiZw/iLWL3UmdoH5orkqczBz1ub8tu/a6ksVmWoQHG0lfH0YPdnoB/7z
	 eEI/puXtacydPFcjzmI0C/s8ZLq6vw70Gzoilww8s+0kBR8kcTdOesJUyQ6f/u7r7m
	 a101EgFqks3HOHXgIK/bdBaIRuYZ9ob2469ZCkapI6Pe/06u/gVvBckNgrGzpZigN9
	 Z+Mk4TReMe6vg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w8IEc-00000008H22-2YVF;
	Thu, 02 Apr 2026 13:37:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	broonie@kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH] KVM: arm64: vgic-v5: Fold PPI state for all exposed PPIs
Date: Thu,  2 Apr 2026 14:37:19 +0100
Message-ID: <177513703760.453570.13515415348349688517.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401162152.932243-1-sascha.bischoff@arm.com>
References: <20260401162152.932243-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, broonie@kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 Apr 2026 16:21:57 +0000, Sascha Bischoff wrote:
> GICv5 supports up to 128 PPIs, which would introduce a large amount of
> overhead if all of them were actively tracked. Rather than keeping
> track of all 128 potential PPIs, we instead only consider the set of
> architected PPIs (the first 64). Moreover, we further reduce that set
> by only exposing a subset of the PPIs to a guest. In practice, this
> means that only 4 PPIs are typically exposed to a guest - the SW_PPI,
> PMUIRQ, and the timers.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic-v5: Fold PPI state for all exposed PPIs
      commit: 9c1ac77ddfc90b6292ef63a4fa5ab6f9e4b29981

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


