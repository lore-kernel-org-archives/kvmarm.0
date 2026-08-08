Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF033812D1;
	Sat,  8 Aug 2026 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786214145; cv=none; b=ICgxl7XyB1eVsFcHlphQubL+l50Nuo1/uyxeQiwO896Eqa90gKlTa/u+r8UWNkRgY9PHFJRVSCj3PFaFp42eeTbhMcirzgDBrA5tmhL0uoF9E05Ch2CzqWzlx5gDedo79gogU0/6ZPaRNsTSQ0KZGtMahXXl9KH4LDo1qx/f8I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786214145; c=relaxed/simple;
	bh=7RWuU35CZz/v0b9unC33TeTlY8cam8P7ITgCg0tBeMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8iie96v+JrXAw76p4H7zcLpNvCcNZDLkZaHwOFGJR/KlBAv1/RAB+AovXkqdj9ZD1bVYD1IvGBuO+86iD3CFwOxMMdt3Fw/BWOO2H5SyRxMq8v3K3QGCnylM/rb0vz1u1472JZCOl2MgJjrjgizp9TrhbFLAn8SUdDdZb3dH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpRcCBVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpRcCBVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5951F00A3F;
	Sat,  8 Aug 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786214143;
	bh=/SuFUBjQVnne/HL+wqlQZd+V6iBFMzeExDV/fn8/DYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpRcCBVUNaRKn1WHzyF6KhEFgSfBf09eLND3KW5ZP9WGguqOSFcLIg37rs8qq0ncN
	 VXeZ6cAxrgD/8aXv9eLEwEO8NUTPp7Gi/F8eNlTHRIv2OZT94/Sfpe7NtQ/OT7mrfg
	 kg+UYkXHVXKMQ0u9TzwTo2ar6PYjkfio2/dHZdX3eGp7bZi606TK8vJrjS7nRb86mm
	 x11LyHxVeoo0zho3MQVAVMwkoaqI7kNa/eFcrnd2HVc5+Tv3XJzvNK0fqeOVJwti+h
	 4rWaMp66GT/EoCFPRBDm5x1D9hF/Ew6v2J8FsYNL7BXJ9UXIN3xikumRgwCrznaM8+
	 VZSOlSyPvhpwg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	ljs@kernel.org
Subject: Re: [PATCH v2 0/8] KVM: arm64: VNCR TLB invalidation fixes
Date: Sat,  8 Aug 2026 11:35:39 -0700
Message-ID: <178621413203.380376.242769068720524648.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806091026.620700-1-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 06 Aug 2026 10:10:18 +0100, Marc Zyngier wrote:
> Prompted by a patch [0] from Hyunwoo Kim which was addressing a pretty
> annoying corner case, I spent some time looking at what was wrong in
> our VNCR TLBI code. And there was a few things to say about it...
> 
> - The TLB tracking to get into the slow path is wrong. It tracks what
>   is mapped, but not the established TLBs. Kind of annoying.
> 
> [...]

Applied to next, thanks!

[1/8] KVM: arm64: Remove VM-wide VNCR mapping counter
      https://git.kernel.org/kvmarm/kvmarm/c/c55bc773b6e8
[2/8] KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation
      https://git.kernel.org/kvmarm/kvmarm/c/8053393680d4
[3/8] KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
      https://git.kernel.org/kvmarm/kvmarm/c/8c774604b6ec
[4/8] KVM: arm64: Correctly handle end of VA space TLBI invalidation
      https://git.kernel.org/kvmarm/kvmarm/c/34af2c3e31f9
[5/8] KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping
      https://git.kernel.org/kvmarm/kvmarm/c/38640bc32be3
[6/8] KVM: arm64: Sign-extend VA for range-based TLBI invalidation
      https://git.kernel.org/kvmarm/kvmarm/c/239347008564
[7/8] KVM: arm64: Make VNCR invalidation participate in MMU invalidation retry
      https://git.kernel.org/kvmarm/kvmarm/c/2b7324f3a0c1
[8/8] KVM: arm64: Add VNCR TLB tracking again
      https://git.kernel.org/kvmarm/kvmarm/c/62e3bb894a6e

--
Best,
Oliver
