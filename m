Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1637F8AF
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222799; cv=none; b=e8Iu03cd4F6U4WnDBBqLNwLqHI1MTebi0a3/DG9LghryKCyngyCoGb1QvNZFBb8RZN2q0jpW4Ch/OpLwVUxrkCkCYnrwTTjQJCy8550J/B94R4ExQMFjQyUiBXYKcbObCPfy+t201B/ZwqdarmM51iF2I/bhY2c7SqbBotSRpMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222799; c=relaxed/simple;
	bh=1o0WCwZHMY3uypHMuN4YOm0dIFASQauJbJMcvj4x1I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwGNxYHsK9OBUcy27GzcTdMkbh5w3SG4owgc5j08dkCGOL6gpinjguQVDOE+yK/YlhAkzlHsyqlKrnBXftJzAm+WfGz+R9S8Tb6ZHnp9mWBKjGQ1+WjnGgKAqqxBJgByVthfMQRXhjlm0PJiK2+mpKTaX8BIWWXvjFmdOcODRGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAGAjGGN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAGAjGGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A961F000E9;
	Tue, 23 Jun 2026 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782222798;
	bh=L9/a/ByR+6e6AgnT12no1rQ92q6rJU6hCcMBOsENejM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAGAjGGNKQMkx/4a/w1mFszlzhZZmQRLsr2GfGkTK11g8cM8Q6YDDNkn+o1VNMulI
	 luPq3QDVOYksOZ4PHpjYyZ48EOVcIllDltvtZNuGRsRPACogNuilj/tNWgXDWOJd9a
	 GPJ4H4mKRQQ0RdFiaMxDCEZrK9a/fHDu6qGvzz719wNALMq7W0eXaaQzNz7GOHOJN9
	 yWg+RavxR6KXB9Z3Od1RbmOdUJiLviRc9y45g01m3HI2VRBQWQFx4Ahvzj6CfvjyG9
	 liDTsC1CQyIDGk5kTMAZUMYNBbukv6Lx2NM1eCzmW77/ckYCxSDAzuL5YnnRd+26bf
	 +tKZZEtMSGIrQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wc1Yy-0000000FJ2A-3WoR;
	Tue, 23 Jun 2026 13:53:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: nv: Even more VNCR fixes
Date: Tue, 23 Jun 2026 14:53:14 +0100
Message-ID: <178222278584.523236.12722425960537513848.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618234207.1063941-1-oupton@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, weilin.chang@arm.com, seiden@linux.ibm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 18 Jun 2026 16:42:01 -0700, Oliver Upton wrote:
> Addressing most of the issues that came up with v2. Of note, I left
> Sashiko's (valid) feedback about HWPOISON PFNs not signalling userspace
> unaddressed because it requires untangling the return code mess a bit.
> That and the bugs fixed in this series are quite a bit worse :)
> 
> Applies to kvmarm/fixes.
> 
> [...]

Applied to fixes, thanks!

[1/5] KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
      commit: 2684e02bac41c5220f6c1ab2bdcc957b71812977
[2/5] KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN
      commit: 9f3e83345a56280efffe235c65593c7e544c0fcc
[3/5] KVM: arm64: nv: Re-translate VNCR before injecting abort
      commit: bb645aa0a4caeaf7f9cd32e9a948594d434c1a8f
[4/5] KVM: arm64: nv: Inject SEA if guest VNCR isn't normal memory
      commit: 4bd7dbe0b2243e6aa735cae4d5e1ff988b30b2a6
[5/5] KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort
      commit: 265b58aba51b6aaaad81678fbc57fcdb2d4ed480

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


