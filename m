Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6AE1FBD
	for <kvmarm@lists.linux.dev>; Sat, 15 Oct 2022 14:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA375C433D6;
	Sat, 15 Oct 2022 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665845022;
	bh=hjYr8ko7iuj9JI15c9F/BNcYvy9KC3QyqushepyK85E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3m77UqeodsJurLzaU0UEfdz8Vdi51CiK5oP412O6zeXKCKKy9tHrmbngEVZnU2Mt
	 icoPqZtKpF9WR186V3H69VaC2mtparG/FWSonKgBpre9BX2tpcTCdnzyZxNvkeiwUk
	 qiO9fBlV5BUtnyb3TT9ynN8wv71sbZwa5xuAohjS04ZJaYVkzXdzls12hwe1vN7212
	 KrEhxs5I88evLZRg2loVGFl7Kwh16cCvXgmfpw8L9UXgn5M/mOCEUOJ2ZKtadp+yfT
	 9kyHEVpH4aVPlKnLLbkQ4MAu8SZ7uVQqmHinp4dWfTMhGSrzYLHUbkf4aKQqqd1TD1
	 h+Oc1Sygf13ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ojiO4-00GhUy-Rs;
	Sat, 15 Oct 2022 15:43:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Ren <renzhengeek@gmail.com>,
	eauger@redhat.com
Cc: yuzhe@nfschina.com,
	catalin.marinas@arm.com,
	eric.auger@redhat.com,
	ricarkol@google.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	justin.he@arm.com,
	suzuki.poulose@arm.com,
	alexandru.elisei@arm.com,
	will@kernel.org,
	gshan@redhat.com
Subject: Re: [PATCH V2] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
Date: Sat, 15 Oct 2022 15:43:38 +0100
Message-Id: <166584499561.1372561.8752919211867299710.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <d9c3a564af9e2c5bf63f48a7dcbf08cd593c5c0b.1665802985.git.renzhengeek@gmail.com>
References: <d9c3a564af9e2c5bf63f48a7dcbf08cd593c5c0b.1665802985.git.renzhengeek@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, renzhengeek@gmail.com, eauger@redhat.com, yuzhe@nfschina.com, catalin.marinas@arm.com, eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com, oliver.upton@linux.dev, justin.he@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, gshan@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 15 Oct 2022 11:19:28 +0800, Eric Ren wrote:
> Reproducer hints:
> 1. Create ARM virt VM with pxb-pcie bus which adds
>    extra host bridges, with qemu command like:
> 
> ```
>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.x \
>   ...
>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.y \
>   ...
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
      commit: c000a2607145d28b06c697f968491372ea56c23a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


