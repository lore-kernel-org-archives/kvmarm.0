Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096D93812D1;
	Sat,  8 Aug 2026 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786214661; cv=none; b=Ffewpbg2UFLVxJT1R8IZXyOBRP+vmCFq851FaPboWTFB1lozWJ5touAudJBczETEqPveAhokbl8/vMzvo0nhGXVVZQS8R2g8woTqTfOHIhlj7Zm736oTJ2zOyUjzWZqcTSqitX1fv92BbWAaRHS2G2i8dVcdDvkDwn06hkxdVWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786214661; c=relaxed/simple;
	bh=OWVT8GhzRscDTiXdBnwxKhY61dH4eF7HeC9qYy2IdeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XS7pNT4qlBGxHuQSvKZ1XctRLMJMdZeMKZGAYvPAJzSTKP0OStMp7eqnDjRIHe5CfpvrOQ4aAHqSVUxMcrddEn3/mMqxUx8wFufhpRJK1kHIjtS1XD45YAlXTCfQGqIeIj6lMzHeddV9079Mc4xnK4IJCqdoziHRFgXycDqOaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cip1EV8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cip1EV8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5130D1F000E9;
	Sat,  8 Aug 2026 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786214659;
	bh=YfvtnhYlOjlLxdP08uU/4xA8PeOG0Ri4dShMX5YdVRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cip1EV8d7zjSlPE46VIKquUEHeGQCSQC85Gefg9BUPfQpyDoPpM5vYCWuKbId1/F1
	 k9FfuYqjH+7gok2ymhdrsGyvyJ+19L0opqNohl4gejlyfngpgYrNUzaDcDjnBAzWRr
	 KFoSkh3cFlda55Gk6pC6wtEVfqAXztlAvgb93Z96gkwcQyZw0DXWizC/NRz1TbOB7a
	 TTB0nEY0iBcI+pT2Ix+DyV2QGwvugdKOrnWnb4ebwyvk7ZndRjbUrQ7rjnjT8qZGh8
	 0uoAPDy6ONdabbxqr7qSkgu6J9TDEzp8WrMzbXWNdzIUUqx/5KUGGgd/sCOynO5cd1
	 sNTCHg+s6a6wg==
From: Oliver Upton <oupton@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mostafa Saleh <smostafa@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	seiden@linux.ibm.com,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	vdonnefort@google.com,
	tabba@google.com,
	sebastianene@google.com,
	keirf@google.com,
	yaoyuan@linux.alibaba.com
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for timers and pKVM
Date: Sat,  8 Aug 2026 11:44:11 -0700
Message-ID: <178621460524.381735.15023846552532101058.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260808085824.732659-1-smostafa@google.com>
References: <20260808085824.732659-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 08 Aug 2026 08:58:21 +0000, Mostafa Saleh wrote:
> What started as a  small patch ended up as a 3 patch series thanks
> to Sashiko.
> 
> First patch from Marc to consolidate the offset calculation,
> follow up patches fix issues with non-protected VM and timer
> offset and protected VM running with broken CNTVOFF_EL2.
> 
> [...]

Dropped the unintended SOB in patch 3 you mentioned.

Applied to next, thanks!

[1/3] KVM: arm64: Make timer_get_offset() work in all contexts
      https://git.kernel.org/kvmarm/kvmarm/c/2858600ecd01
[2/3] KVM: arm64: Fix timer offsets for non-protected VMs
      https://git.kernel.org/kvmarm/kvmarm/c/47d3eef780e3
[3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/2e813a6e8ebe

--
Best,
Oliver
