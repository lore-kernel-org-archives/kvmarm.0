Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A451741E8;
	Tue, 10 Sep 2024 20:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000540; cv=none; b=Pklz9mdlg4zK3/H+iJvJqZk+bm+Auzn8IdP6TIeYeWphYbfKhY0iqEZ5cZrvWFpNtcVNaOL04YloGfTSUKQ33D8l5YsEU7GojQHti09+YQUrZBx42NVBnD2NRCfN3S6CIUSK72XynRBpQ4XrzGPL26YrAOuyx2FyGu0hpydWAfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000540; c=relaxed/simple;
	bh=ZBvdMqjUSCBx/TtQ+mFeqJuGoEfmT4hpGxtbN9BKUzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bb3bsIteNVT1z18JYLFEMFYH8qzgGeysU+0L7xUMoUPr9dwEsVf23cVBMsD67C6s+oQ0FYiFxaAugcWEXc4SjRHEaqVbtibYX+ETtPx/yIrax1AExM7oFlAXMLNylmmRPraZiQWuslvFyuMdYp9OI6dHLF4w7wkF2Ejt/kKprHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Plh5EDmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Plh5EDmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D395C4CEC3;
	Tue, 10 Sep 2024 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726000539;
	bh=ZBvdMqjUSCBx/TtQ+mFeqJuGoEfmT4hpGxtbN9BKUzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Plh5EDmUDB3Ck7HOx2XXcxpVfImxu3quUJBIqWEwAEAYZAEH02wM4xFqWDLaTOEQX
	 4lSuQRfeJrMfmsTfEm+3cK0gVLKyJiOaTiuFLLiXZLLPM/nuAAGTD/wkYI+i20MfEH
	 4eV03xyfI5y0Hd73JhxAmh6hLmo+PZwPe3g6d0m85bnaGUI1HZh9QdJdbYVw6gljLS
	 HMyqb+sLW0B9uLv2O1Ie0pYJMD0VrIUYHdhSiTVUa4XN7hCGfovjdOmr/pfik4Izt1
	 34Zvfp7Y5vpF007iPyfWBrsFBrczFkocj31jV5V8DCpsCMxJYLq1+xBxz92xxkgnSf
	 j+R7RIA1Ta8Bg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1so7aL-00BsI0-42;
	Tue, 10 Sep 2024 21:35:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: akpm@linux-foundation.org,
	alexghiti@rivosinc.com,
	ankita@nvidia.com,
	ardb@kernel.org,
	catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu,
	james.morse@arm.com,
	vdonnefort@google.com,
	mark.rutland@arm.com,
	oliver.upton@linux.dev,
	rananta@google.com,
	ryan.roberts@arm.com,
	shahuang@redhat.com,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v10 0/5] arm64: ptdump: View the second stage page-tables
Date: Tue, 10 Sep 2024 21:35:33 +0100
Message-Id: <172600049355.391902.15401581703143159469.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240909124721.1672199-1-sebastianene@google.com>
References: <20240909124721.1672199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, oliver.upton@linux.dev, rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, sebastianene@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 09 Sep 2024 12:47:16 +0000, Sebastian Ene wrote:
> This series extends the ptdump support to allow dumping the guest
> stage-2 pagetables. When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump
> registers the new following files under debugfs:
> - /sys/debug/kvm/<guest_id>/stage2_page_tables
> - /sys/debug/kvm/<guest_id>/stage2_levels
> - /sys/debug/kvm/<guest_id>/ipa_range
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Move pagetable definitions to common header
      commit: 29caeda359da15d16963096043cda39530f81cc4
[2/5] arm64: ptdump: Expose the attribute parsing functionality
      commit: acc3d3a8176651a839056c7da4b925ea0bcc38c2
[3/5] arm64: ptdump: Use the ptdump description from a local context
      commit: 9182301a7bd2564fb050ade9820333c8b1adfcc2
[4/5] arm64: ptdump: Don't override the level when operating on the stage-2 tables
      commit: 79c4c7284f92d5e780c8532c343ca2cacfaf5125
[5/5] KVM: arm64: Register ptdump with debugfs on guest creation
      commit: 7c4f73548ed15476daf1101f66648085eda65067

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


