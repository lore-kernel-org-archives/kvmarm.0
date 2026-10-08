Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE6B3DD50B;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461741; cv=none; b=nYmlVNEfClFeGWOOqvmT0xxVhuXU2kWRx73E31UqOAky7hpZLKE3Zu6HCiu51FCtx+JTZpKC+SiohPjYLVvdjOMQKg7EV2Xpmcr+8kCYmiBtlNl2Lb9M7wtnS7NshWYtG/NB7TBOIegq8bbiSqiNLUzLNiVkxoxQcnQz0Vd1/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461741; c=relaxed/simple;
	bh=4ODUPMV03VdBemqJmmhvAVMXz/2NymhIvG+Z8fEazdk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mCCbGTc4aHRu5R6F60ReuxsmOFHmPAi8fT/IdRct+vaXdj0xJVIvufshY/3SBMR3cv8nE+ppxssUHnHuzcwEHhKyppldKWG2EPBBzztEyAKoZ5j2LmYrPGUf6/d6KO3NVRqMZjMf0CQbvuq2gb5/4oydruWV8PqcPoTUjnS+TLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnIfY0MP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnIfY0MP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35D71C2BCC7;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791461741;
	bh=4ODUPMV03VdBemqJmmhvAVMXz/2NymhIvG+Z8fEazdk=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=WnIfY0MP30ldQmC7BEHmqnRO89oB7ldDTfgZZYxclJdeXEJtQHWpCEKPvNgT12cVQ
	 Cge24dhxgyo+EN2y1WJrzASc5+p0SzcoiMr36C6tp5MixvaybkKe09F8F00ZNxoIRE
	 GYb6fH+t2DG5tVoNhzWeu6KAnvTmkzsR4OLN0gbJXt3C1KSe5slhlYjR0qLPKaGNyi
	 b7MFrfef1aNOib7GtEVepNX241/YsJ4s/QIUV7AeMxfQH6c/7d0T9X8QUYF4+sSmtD
	 fLXJJQg12lHS36F1ZJGdZCeDqV9qSUpQvi4xdbtN4SKYBe1Pi13gYEf11YpCGeFs7x
	 6M+CfUR6biLOA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F432CA600C;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Subject: [PATCH 0/2] arm64: Add support for Apple M3 and M4 CPUs in KVM
Date: Thu, 08 Oct 2026 23:15:39 +1100
Message-Id: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGuJx2oC/yWMyw6DIBBFf8XMupMiGvv4laYLBsZKW5CANU2M/
 y7o8tzHWSBxtJzgXi0QebbJjj5DfapAD8q/GK3JDFLIrhbiiiqEL6Nr0LX4mR3ShW4kuWlJG8i
 vELm3/934eB6cfvRmPRVNWZBKjBSV10OJTFT9dD60uzDXsK4bk1jkupoAAAA=
X-Change-ID: 20261008-apple-m3-m4-kvm-b7b9b2e34bcd
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Myria Sarvay <myrialsarvay@gmail.com>, 
 Yureka Lilian <yureka@cyberchaos.dev>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>, 
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>, 
 asahi@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791461739; l=982;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=4ODUPMV03VdBemqJmmhvAVMXz/2NymhIvG+Z8fEazdk=;
 b=k9godCQ6k6IjLO6XtMj7BaWGkvsuz4j44cDDnNlgk3dwYIILYaqrFQ97KPhtRllK9LFE+rJd8
 0aEIs/00G9xCt0t6+sdBFeJJ0xjg+9U/gDMEq966ZXDfR7WTihdCdDr
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

Hi,

This series enables KVM support on Apple Silicon M3 series and base M4
CPUs.

The first patch adds the part numbers and MIDR definitions for M3
(base, Pro and Max) and base M4 CPU cores.

The second patch adds these CPUs to the existing Apple CPU workarounds
list, which is required for KVM to function correctly.

This series was developed from testing on:
- Apple M3 and M3 Pro by Michael Reeves
- Apple M3 Max by Myria Sarvay and Yureka Lilian
- Apple M4 by Yureka Lilian

---
Michael Reeves (1):
      arm64: Apply existing Apple CPU workarounds to M3 and M4

Myria Sarvay (1):
      arm64: Add Apple M3 and M4 CPU part numbers

 arch/arm64/include/asm/cputype.h | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c   |  8 ++++++++
 2 files changed, 24 insertions(+)
---
base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
change-id: 20261008-apple-m3-m4-kvm-b7b9b2e34bcd

Best regards,
--  
Michael Reeves <michael.reeves077@gmail.com>


