Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99FD49BD65
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461897; cv=none; b=TYMHBGLuUJNH0AA5UaisBrtxG6DhR3WNkBHdEHwEV4Mq4abFeiPnOfp/h+hcm6Ge+/Tx7+F0FWnx7pRHT3PTpSN/J6aCqdoRdLO0ZdNLT5nGHSgq7Ne4FaLrVq84tfbei0P17V/DYgKO5UGDG3zm7koB7WeIsFGs+IgeunwYJNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461897; c=relaxed/simple;
	bh=+4rM/vb9bgnywxjBITcpXSRkVe9CVyh/SFm0f0Uf3bA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O+CFCeXA9gvdGJmuhN1VUE4Qt6p35M2y48P40djXbbR4DL1+v8JYyiBey8HhvixAqc59X6GQNQ626w3H9I6KfP+4dVRhRaA8rZYIp3hi8pN7BAuMI2V5hknwgEd1ONNYhavPUnSY5tgJJaDyHZXbBV7IjVVuRT6w7qu+QqiZ2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UGCwd+Zj; arc=none smtp.client-ip=91.218.175.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UGCwd+Zj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+4rM/vb9bgnywxjBITcpXSRkVe9CVyh/SFm0f0Uf3bA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789461892; v=1; x=1790066692;
 b=UGCwd+ZjQJHmbHAhhb/dUJy+HvKCo+/LTTvnT6HZxGYBO/JvY31hKXEtgQDE+9ACWM9gbcCk
 rqmJJiDd5o5jJIXIPtP/0TiiCOGTO3XTMHteXLWJ9o29gV68r6nniisNizEUt5INJ2xMlFAhSZv
 6BxYO+5Qm9VjYB6w/HoM81pk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bf7d1fed5110460d;
	Tue, 15 Sep 2026 08:44:52 +0000
X-Mizu-Trace-ID: bf7d1fed5110460d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: PPC: Book3S HV: Fix comment naming a non-existent KVM_VCPU_RUN ioctl
Date: Tue, 15 Sep 2026 09:44:41 +0100
Message-Id: <20260915084441.3846947-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915084441.3846947-1-fuad.tabba@linux.dev>
References: <20260915084441.3846947-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no KVM_VCPU_RUN ioctl. The one that enters the guest is
KVM_RUN, so refer to it by that name.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dbac3573b2c89..db090f4c5e95b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -269,7 +269,7 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
  * stolen time for a vcore when it is inactive, or for a vcpu
  * when it is in state RUNNING or NOTREADY.  NOTREADY is a bit of
  * a misnomer; it means that the vcpu task is not executing in
- * the KVM_VCPU_RUN ioctl, i.e. it is in userspace or elsewhere in
+ * the KVM_RUN ioctl, i.e. it is in userspace or elsewhere in
  * the kernel.  We don't have any way of dividing up that time
  * between time that the vcpu is genuinely stopped, time that
  * the task is actively working on behalf of the vcpu, and time
-- 
2.39.5

