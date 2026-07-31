Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E34F489880;
	Fri, 31 Jul 2026 20:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785530793; cv=none; b=nTqbVHwxhT9xllrV/U0tRdty+0WSs52BKVWJTf5HQmrX5zTBTtNSuaHfxxpCYRVu3olr6StSbsiJTEIF7+0PSganXRJqJNhZIjmJ4hVsdyHrKFAw4wB00PB4kOfavZ0Y71Oy14MoDkDK4GgHVtmfJco1nmkg442jmejc46emocY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785530793; c=relaxed/simple;
	bh=PdJJXOt98kzJz4gtUFAIu6dqJF4USgdFMdWL3Slu3eA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kYXKJczHuwEnjMB8n8orrUSlWpB7H3JEJNIug5C+HUZ8GgXKId4Q64iGWj3BN8UDADHbklUEq6SuWmt/Ia9wPKVJPlUFifCqiSlRIy7KhAo7kJ++elKwR6cbtj+1b71HwZPEfinDUocEAMRlVd6P5opxo1T3quiicqGisEhiy78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhT89E5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhT89E5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7BC1F00AC4;
	Fri, 31 Jul 2026 20:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785530792;
	bh=6yW61SMZr04gIIPBlCEQvBwEJCF0yd/ErxiSOHKrD2E=;
	h=From:Subject:Date:To:Cc;
	b=RhT89E5uH9wfvNQkQCaD3r7jsXJWIYCgk07+k8KUc3rvJLcAMedqZmsPc2s/JSeBB
	 lWlQoQdqkrI1Fyw3gS6/y8msYqNVbf6bCIXPSUGMS6OdGSrf0BSfoTDIAY17HoAQSe
	 UVlXiY4TCB7d2pP40Li9MruFvaMHkaURwRU/EQqA/JjQAdqPCvgnH9RBoxZgTePe3l
	 21tFIpLArR7bhFBoewm3mQ2qg+jMahg/L0YUb3WYg/y8Gp3JT7k4vREvVhgzg0mFuL
	 SbWTZ3XKe5n8SAEWVAMpq2ZvRiwvVr1PrjtOW7e9YxZAOiwOuKUFZD2bJdMlfBzXET
	 /Zpv6cNpxINvw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: ID register finalisation fixes
Date: Fri, 31 Jul 2026 21:44:44 +0100
Message-Id: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD0JbWoC/yXMQQ6CMBCF4auQWTMJNqVVr0JYtGXAUalkisSEc
 HcLLL+8vH+FRMKU4F6sILRw4k/MuJQFhIeLAyF32aAqZSqrbvhaRnQyGp0HoQF7ju6N1gYftPF
 1fXWQv5NQz7+j27Sn09c/Kcx7DLbtDzVMynl5AAAA
X-Change-ID: 20260729-kvm-arm64-idreg-final-77cbc46b558a
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1001; i=broonie@kernel.org;
 h=from:subject:message-id; bh=PdJJXOt98kzJz4gtUFAIu6dqJF4USgdFMdWL3Slu3eA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbQmjpvTPrvJBcFud78RS/97Dw9ezyY2aHz2fO
 Vv/3qRYOuiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCam0JowAKCRAk1otyXVSH
 0I/FB/96JM8c0/VQoss2cShl+HCAfsRCd7T1f+E29p24JbAVPFrCvcvRUnSTfw4i9JqfjX3Go7b
 J7IL+afUmtjwtAqvQAvogbCc0TE0GLNHou6Wg0mjq/6u1ecVxS5kkFHRv1LwluJsvIhuniVS8F8
 XyHrDFvZpV8eVEf6Pprg4oYXskgDvi/hDo08A4w6fUoRR99Rn1mheh7FNvAlS5k1ldq3sn3LATN
 VTajkc+O6YrEo9WaHYCNnvvWPuhaU4boMlStqXsfdtc34Jj1JqXbAAoZkcx02TLBv8zePXcs88p
 O+fg2BNdYOapB+aE8ulcVcmHs72ulkDvo3wHopZmNKXOXkWk
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While looking at some feature enablement I noticed that there are some
scenarios where we can end up with an inconsistently configured vCPU due
to finalizing configuration based on ID registers before we have blocked
writes to the ID registers. This series aims to clean up these issues.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark Brown (2):
      KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
      KVM: arm64: Block ID register changes after we rely on the values

 arch/arm64/include/asm/kvm_host.h |  8 ++++++
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/sys_regs.c         | 53 +++++++++++++++++++++++++--------------
 arch/arm64/kvm/sys_regs.h         |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c   |  6 ++---
 5 files changed, 46 insertions(+), 25 deletions(-)
---
base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
change-id: 20260729-kvm-arm64-idreg-final-77cbc46b558a

Best regards,
--  
Mark Brown <broonie@kernel.org>

