Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D7A23D1
	for <kvmarm@lists.linux.dev>; Sat,  1 Oct 2022 09:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F69C433D6;
	Sat,  1 Oct 2022 09:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664615919;
	bh=2rogGG85HQXuD7WibeMAU+YBXmWNjHZnGMq/xPogXoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvjoaMOBB+Kv0oI1Nl9I1Ld8FdNCf8olrDdCMMiwlybjRtn/uQb9tKjfcCbxlajKP
	 H/4YJpJtYRPiJ/6mEQEothYZBhzkPzalbnxiSfPJShr5DuARt4oGt9vSs+EQd20p9L
	 FYX3xoy2PGCq0EeSTk9YdxCHPGmuIGDXiGzoX49iLyOwtV2kUYiuUU8umij0eUGyoe
	 aeVK8FsBedk0AI/ndMGhcI8X7p9G1oeUXGDuvMabdcA3REehvuWEzTNwqGF6EUe+fO
	 zsc1/YSHil3yVEx6JkybkDXlSkAUmwdahoI3rKUODIYbfw0fCqSpu2C8ZwXOkHXujp
	 oFqPC9aZP3CGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1oeYdp-00DwbH-8I;
	Sat, 01 Oct 2022 10:18:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Advertise new kvmarm mailing list
Date: Sat,  1 Oct 2022 10:18:34 +0100
Message-ID: <166461590369.3900755.9396637331085967058.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001091245.3900668-1-maz@kernel.org>
References: <20221001091245.3900668-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, will@kernel.org, alexandru.elisei@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221001091834.UeeQnnwhMvkXvCKAb3d2PmEtK_Y7NFc0rH32iCYkncQ@z>

On Sat, 1 Oct 2022 10:12:45 +0100, Marc Zyngier wrote:
> As announced on the kvmarm list, we're moving the mailing list over
> to kvmarm@lists.linux.dev:
> 
> <quote>
> As you probably all know, the kvmarm mailing has been hosted on
> Columbia's machines for as long as the project existed (over 13
> years). After all this time, the university has decided to retire the
> list infrastructure and asked us to find a new hosting.
> 
> [...]

Applied to kvm-arm64/misc-6.1, thanks!

[1/1] KVM: arm64: Advertise new kvmarm mailing list
      commit: ac107abef197660c9db529fe550080ad07b46a67

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


