Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44CD21C16A;
	Mon,  3 Aug 2026 22:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785797684; cv=none; b=prMy4QL1KwnpMYkZHXkNPELd0zgBaMEOiyig8aAEhDD3QSz2/IDZzK3zRRMx+oazCmhHydcCUWvjso8In6MLwe9M6tNmxFSwH5t3frg3FzNWSmofTB6DnK4mqXZhNozakgFthS+BcOEIyvOIiTayVE1RucQJnYmnWq5dsLIpPOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785797684; c=relaxed/simple;
	bh=V4qHD6wmZpYcTYENc2vY0BXAauqtQOOFlUChMEa50ew=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WuPE5MmQCZJapXB3sdiVPrVzuNmNei1fj3yQDpOCJ66NJXCxvDOprO8zgexvgBeKhgjxXT3Fk8gce1w7sLwr10Ivr7zv8iwViOqBboIwOYKOj+mP+YSttXfTVMth8JKjBVNqQQtcc34zHzGlJS7gUrzfAorpAcHU2PqS2c1ACd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0xaIsmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0xaIsmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E408B1F000E9;
	Mon,  3 Aug 2026 22:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785797683;
	bh=BEW95Jao0151ROBkWIkQ/c3IVqod1+b1uzS5PXnlhQs=;
	h=From:Subject:Date:To:Cc;
	b=S0xaIsmkwE9+7yCcnSMQJWK3J7F0OFInFjkXFlV+P+ty4SKfWRu9i7HDhapYLa6d6
	 vRWdDaocM0jmLWzWtEAB862KxgBmcvRsEvemV0QUeizbiJkIR6+/o9KFs+uhiqe5n9
	 mCQZvOJQC+078BPfo/cmmHKGefu9a3ZDbMo067PjMBQwXkjRcWiNM6WPG02b9pXVY6
	 AP55PhwnsUz/pMfHOD05FkOfcO1JY+WPOSpKUqpaEG23gXbGRMECP6T21xFP9T3UZJ
	 QnMOLMA5qGqKTIuspcItXv+1WeaQEdeB1PoCqwtIMSqFppxL384RfQEdnRR6erC3qF
	 WJNzdKpSeQUEQ==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: ID register finalisation fixes
Date: Mon, 03 Aug 2026 23:53:52 +0100
Message-Id: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAccWoC/3WNTQ6CMBBGr0JmbQ0tUNSV9zAsShmgAq2ZYqMh3
 N2Cbl2+fD9vAY9k0MMlWYAwGG+cjSAOCehe2Q6ZaSKDSIVMS3FmQ5iYoknmMSDsWGusGllZ6lr
 nsi6Kk4K4fRC25rX/3qov+2d9Rz1vZ1ujN3529N7FgW+9nyPjfxyBs5RlDQpVSC4bLa8DksXx6
 KiDal3XDwurGW/NAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1254; i=broonie@kernel.org;
 h=from:subject:message-id; bh=V4qHD6wmZpYcTYENc2vY0BXAauqtQOOFlUChMEa50ew=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcRwu+9cjYoT+wsVjiSdM9k9zLaEiXyPB7wQbW
 h4C6otVi+SJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEcLgAKCRAk1otyXVSH
 0GQKB/9JXGkNVh2kHc2ud+7IKZzXysC2frp1oeRF51FTY7Uw2yhaXEYIOvTGwXRPuMA1Yr80peS
 msZ4MU51slV8qN0Vuo38Uz6zmX5+FZtAle/WTnQYhi8HhI2icVVe14FzgKgqA5EtGogNWJO+vMU
 P5NuJNOjnM8vO+jYZhvqHjrWS0FtB5pZ57Z/3P6I3qpwkuo1jJdZHHCzzBp2bY6Y2Cgw4QJlJW3
 /NM6oC6xs2KciSP/d1eG1ftIDlpWd6A0TOKLOMgBOb8v/1CV62YjvHuFTP63WESQNSLstBQW3Fk
 OlQaCNc2Eoe5bxRG+slGHIQCC9meMndC2LZBzUhIuV/QT9yR
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While looking at some feature enablement I noticed that there are some
scenarios where we can end up with an inconsistently configured vCPU due
to finalizing configuration based on ID registers before we have blocked
writes to the ID registers. This series aims to clean up these issues.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Also replace the kvm_vm_has_ran_once() usage in kvm_set_vm_id_rg() and
  kvm_vm_finalize_sys_regs() with kvm_id_regs_final().
- Link to v1: https://patch.msgid.link/20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org

---
Mark Brown (2):
      KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
      KVM: arm64: Block ID register changes after we rely on the values

 arch/arm64/include/asm/kvm_host.h |  8 ++++++
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/sys_regs.c         | 57 ++++++++++++++++++++++++---------------
 arch/arm64/kvm/sys_regs.h         |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c   |  6 ++---
 5 files changed, 48 insertions(+), 27 deletions(-)
---
base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
change-id: 20260729-kvm-arm64-idreg-final-77cbc46b558a

Best regards,
--  
Mark Brown <broonie@kernel.org>

