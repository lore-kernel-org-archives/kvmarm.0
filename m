Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FA7361DBE
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204252; cv=none; b=Uo/uXfy9UVmhOLxemHpvmt56iF2F2/ZuLEwJ7y+B9ABDDw97KGmd+6LqDQ4hBaquXh1gSgShGHT+5zY2wjs6xL9u3rbR6xwyujHXKTHXLW0icBi+v4fTdH4toDh6YCU2yXas9XDxjQQY6zsnWq1ZdfNX5pEzAVQeXNDKs9NfI6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204252; c=relaxed/simple;
	bh=0nCbwqo8niNQXZ1hU1KLWYqiifAAc7ANvBzpdtnL3G4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NhcUQmQBfcL48JDVBXJJqlghSzCxVsNYXMqoiTbTm00HPPFNPOVGfpAekP2G2kFOolaaHBEiJ/Vmfwf3gn5GbIU8gobNBMy4ZD4lEhwkCBoJTauT4yDuSLJQbIX0MDeLbtafZrqVdXAmtvEvhB+Hyh8hZ4jn31uNi2WjVJ3GdYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xPdEvrzn; arc=none smtp.client-ip=95.215.58.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xPdEvrzn"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0nCbwqo8niNQXZ1hU1KLWYqiifAAc7ANvBzpdtnL3G4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204248; v=1; x=1788809048;
 b=xPdEvrznuJOCGu8bzx8LkO6E1f1+AWmFaDR7N60uCDPWvl4CLDIw48zMnUyJ2e5d5KhaPF3A
 FVl5ysCYKovs8AGvHNAn7FmOD+oRs84LKUwHjF4Hi7g4P0YOsS39coWqa/hXPXo7el0n9AbdJKi
 faWUcViW61OKnfhG0EmNwQq0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 177cb63d3b85836f;
	Mon, 31 Aug 2026 19:24:08 +0000
X-Mizu-Trace-ID: 177cb63d3b85836f
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
Subject: [PATCH kvmtool 1/5] arm64: Do not abort on register-dump failures
Date: Mon, 31 Aug 2026 20:24:02 +0100
Message-Id: <20260831192406.1341841-2-fuad.tabba@linux.dev>
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

kvm_cpu__show_registers() and kvm_cpu__show_code() read the vCPU's core
registers with KVM_GET_ONE_REG, and die() if the ioctl fails. Both are
diagnostics. They run from the KVM_EXIT_DEBUG case in kvm_cpu__start(),
from the "lkvm debug -d" dump path in handle_sigusr1(), and from the
panic dump in kvm_cpu_thread().

Once a protected vCPU has run, its registers belong to the guest and
KVM_GET_ONE_REG returns -EPERM. Dying on that turns a diagnostic into a
VMM abort.

Report that the register state is unavailable, with the errno, and
return instead of dying.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arm64/kvm-cpu.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 3aa7684..c58d61f 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -476,15 +476,19 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 
 	dprintf(debug_fd, "\n*pc:\n");
 	reg.id = ARM64_CORE_REG(regs.pc);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (pc): %s", strerror(errno));
+		return;
+	}
 
 	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
 
 	dprintf(debug_fd, "\n*lr:\n");
 	reg.id = ARM64_CORE_REG(regs.regs[30]);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (show_code @ LR)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (lr): %s", strerror(errno));
+		return;
+	}
 
 	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
 }
@@ -499,23 +503,31 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	dprintf(debug_fd, "\n Registers:\n");
 
 	reg.id		= ARM64_CORE_REG(regs.pc);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (pc)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (pc): %s", strerror(errno));
+		return;
+	}
 	dprintf(debug_fd, " PC:    0x%lx\n", data);
 
 	reg.id		= ARM64_CORE_REG(regs.pstate);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (pstate)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (pstate): %s", strerror(errno));
+		return;
+	}
 	dprintf(debug_fd, " PSTATE:    0x%lx\n", data);
 
 	reg.id		= ARM64_CORE_REG(sp_el1);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (sp_el1)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (sp_el1): %s", strerror(errno));
+		return;
+	}
 	dprintf(debug_fd, " SP_EL1:    0x%lx\n", data);
 
 	reg.id		= ARM64_CORE_REG(regs.regs[30]);
-	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (lr)");
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
+		pr_err("register state unavailable (lr): %s", strerror(errno));
+		return;
+	}
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
 
-- 
2.39.5

