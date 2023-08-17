Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24912125D8
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 09:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FB1C433C7;
	Thu, 17 Aug 2023 09:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692264574;
	bh=ATFhiqQYGtf7XSdLFtfhm7uPNRDZX+9/ckUNnAISAaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/yMp9yjVqE9oCBvNELwGcrG5nrZe0FTtWKEC7JDtkAJvbXyPiJCmE2pImgd2e2fw
	 iAf0bmFgkCgps1N86jj5fsmdFysRtqNVwaeHl3jonDVUsg66+L3Fd6hPQHaqaaV9x2
	 lQ5RoEvwAnsbC3zLgOCabnCqH9mHwVsfTfJ6EmQ4cMa+6U+MoUBKu2K0uMeMfiu5lT
	 zrg5s7udb1a15t/Uwt6C2vviMTaHNvl3Y6RGgJaAcpSeRU9tpVcFJLLOE4Yz/SDehF
	 vxBphZCvJUo8+ICHr5NWNvUud2j3xewhsMLwxxJ01cvuSxvZP0JpXqVpLlV8LKjCbf
	 e3BkN9Zff3vaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qWZJr-005dbs-OY;
	Thu, 17 Aug 2023 10:29:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: select XARRAY_MULTI to fix build error
Date: Thu, 17 Aug 2023 10:29:29 +0100
Message-Id: <169226452281.2753740.17444795240191131192.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230816210949.17117-1-rdunlap@infradead.org>
References: <20230816210949.17117-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: rdunlap@infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 16 Aug 2023 14:09:49 -0700, Randy Dunlap wrote:
> populate_nv_trap_config() uses xa_store_range(), which is only built
> when XARRAY_MULTI is set, so select that symbol to prevent the build error.
> 
> aarch64-linux-ld: arch/arm64/kvm/emulate-nested.o: in function `populate_nv_trap_config':
> emulate-nested.c:(.init.text+0x17c): undefined reference to `xa_store_range'

Applied to next, thanks!

[1/1] KVM: arm64: nv: select XARRAY_MULTI to fix build error
      commit: 60046980bf60ed8846113b484d666a5fdf413be4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


