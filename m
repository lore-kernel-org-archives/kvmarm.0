Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD63624C5
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204274; cv=none; b=hEss2Z0+oCHRtTK6DnCJwT4BrdQLrdbozoBhLh87CHJzz5bCQt7T9VSU4pyJUugRNmD+vL2v/ZIF70VO5mCnfuiLwgRK/sP8oPqzrMboZPMNxzjGCublrfAzCGekIWuUYOV/vU9i0E/jWOVwgBnZFkJn8TWtx8fRZm+/u2L0Nfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204274; c=relaxed/simple;
	bh=+Rv0dNBtwd8Z04HMI+gXchXOXQm4e++IlDu+6ZF8ZFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DSdFQrGGJSiWKqoYZ4wCSnUGXTGz6Ug2T/ckIn7gfn1JL/RNKTYyyjf3QbAJC4CAwfu7w03pozUPf2DSe3MZKSx5hQSsOT4otGQgD+Bps/RpVnxUh7Ib96PfZnxYNRqzblc39aO2qJdU/fKFoWvKoOgz6gsUtLVRVm1CMM72A+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w8RYiEwz; arc=none smtp.client-ip=95.215.58.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w8RYiEwz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+Rv0dNBtwd8Z04HMI+gXchXOXQm4e++IlDu+6ZF8ZFo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204269; v=1; x=1788809069;
 b=w8RYiEwzyiXBX+h+cTMskJLWphKNUNQNuOJOnwW+C+0seUYjrRatgVpCE/f/mSPK3bKHysnu
 4EZ8Y3hbsWZ3oNpKpiA3X9fTQ5jYJMrLZiNSr5lWSC/vycGTNJjBM94JXuP5SBzA0KKrNyumicT
 V3ZIYm3oVIAXAaOjWPgdkWSo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dabc206c2f09337e;
	Mon, 31 Aug 2026 19:24:29 +0000
X-Mizu-Trace-ID: dabc206c2f09337e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool 5/5] arm64: Query counter-offset support on the VM fd
Date: Mon, 31 Aug 2026 20:24:06 +0100
Message-Id: <20260831192406.1341841-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm__arch_set_counter_offset() probes KVM_CAP_COUNTER_OFFSET with
kvm__supports_extension(), which issues KVM_CHECK_EXTENSION on the
global /dev/kvm fd. That reports the host's raw capabilities, unaware of
any per-VM restrictions.

pKVM does not offer the counter offset to a protected VM, and reflects
that on the VM fd alone. kvmtool's own check passes, and the
KVM_ARM_SET_COUNTER_OFFSET that follows is refused by
commit b12b3b04f6ba ("KVM: arm64: Check whether a VM IOCTL is allowed
in pKVM"):

  KVM_ARM_SET_COUNTER_OFFSET: Invalid argument

Query it on the VM fd via kvm__supports_vm_extension(), so
--counter-offset on a protected VM fails with kvmtool's own message:

  Fatal: No support for global counter offset

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arm64/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm64/kvm.c b/arm64/kvm.c
index 36b3284..0bb3535 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -155,7 +155,7 @@ static void kvm__arch_set_counter_offset(struct kvm *kvm)
 	if (!kvm->cfg.arch.counter_offset)
 		return;
 
-	if (!kvm__supports_extension(kvm, KVM_CAP_COUNTER_OFFSET))
+	if (!kvm__supports_vm_extension(kvm, KVM_CAP_COUNTER_OFFSET))
 		die("No support for global counter offset");
 
 	if (ioctl(kvm->vm_fd, KVM_ARM_SET_COUNTER_OFFSET, &offset))
-- 
2.39.5

