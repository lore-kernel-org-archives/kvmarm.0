Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624541;
	b=YO7anbE7KuDLDjt0ie8gebg0e4li+qIaa1z3+95ihGYigigFsu2KS0khBRiAvF5Nheuf
	 d3XdBSwiakVcXcrPtj1OxMi4Pxh3UvRGYWJLvoxnGQc63ye1nuwhS8LDDXEUi84lYg2Np
	 hhVFMHZS9qZz5PuLnAkuy2djoKs/U1012Ksc5j+3ZVTyywmJTVBYOQYDb00siOjpmjCAO
	 vnE/wby1M+wcWFq46DEIwQydahjKYh1VVm+AQaX5bVwf988XSU5PO+1TJEgwnRwRG7qma
	 VbXpZqTjaYaERnnHnsDDpyfWR0wL3y3XpcetD2SH4z1Aj923HFweembJ0hkIaw7+eGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624541;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MjI+KkE/DHdEAtZ+VS0VPmyG2kVLIeN4msuyxagZt3w=;
	b=s5fnk/0F5v3sgEYZg9jdZkmOc8ZVMbECCou/J1DARiWGpKeaEE3yPsqZf4YRFd8vb0Jv
	 A7A/Gc74lsPlZ+4gpQiscOXeCzVJ6ghOlRL8iZCkhsji4aPVAM/CPlTxQiMA2715RY0T9
	 ldL/Yn4atYurHmMXVDN4pM8sv24e/sYvKk/C89ca22MqPf9cTbLHhz0gzEfYGS7DoRH9a
	 pUaxNvV0iWW1BVgfZSvAzhngw0XzrA5NvHH+n3yZqXxdNBIj8QDwjcIYjxfe7w/RmoMWR
	 nBJzed1PV49yO2VbLUl/g5bib4kQjgTNn61+3NRExC0HtYu9e91ONF15Bcs8zdBiolA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mwADEu5x;
	arc=none smtp.remote-ip=91.218.175.23
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D3460A2614
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55D3460A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mwADEu5x
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=U4Ir26pDJYfRAMb+qjTuCOpUGkv3Z+5ql2B1l3nXv5c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624537; v=1; x=1794229337;
 b=mwADEu5xcHS72UDu2En+Gi6kPV9T2OeJ65zoS+ftWmjRg6WuHRS9JdGYaNyVexBOd6wdyM9u
 i0j8H855mLEuxew945yuVRWoOjAh9Vt6DkoNZ9MLMMOgV6GIqDvmBCMqybZPk3DtlZ36juj+ySp
 guym5hcg7oFNbAw/K5zUl63U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a61fcc296cb9e8c4;
	Mon, 02 Nov 2026 13:02:15 +0000
X-Mizu-Trace-ID: a61fcc296cb9e8c4
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/13] KVM: arm64: Deprivilege the host under stop_machine()
Date: Mon,  2 Nov 2026 13:01:27 +0000
Message-ID: <20261102130133.3684226-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pkvm_drop_host_privileges() installs the host stage 2 on every CPU with
on_each_cpu(), and each CPU goes back to running the host as soon as its
own __pkvm_prot_finalize() returns. The ITS takeover a later patch adds
has to run while every other CPU is stopped and still privileged, and
let them finalise only after it. Stopping them means no CPU can post an
ITS command while the driver switches to its copies of the queue and
tables. Keeping them privileged means a takeover that fails leaves the
host as it was.

Finalise from a stop_machine() callback instead: no CPU leaves it until
every CPU's callback has returned. An error from any CPU still reaches
finalize_pkvm(), which runs once at boot.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd23..16dfb249b4961 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -11,6 +11,7 @@
 #include <asm/kvm_mmu.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/stop_machine.h>
 
 #include <asm/kvm_pkvm.h>
 
@@ -312,25 +313,19 @@ int pkvm_init_host_vm(struct kvm *kvm)
 	return 0;
 }
 
-static void __init _kvm_host_prot_finalize(void *arg)
+static int __init __pkvm_drop_host_privileges(void *arg)
 {
-	int *err = arg;
-
-	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
-		WRITE_ONCE(*err, -EINVAL);
+	return WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)) ? -EINVAL : 0;
 }
 
 static int __init pkvm_drop_host_privileges(void)
 {
-	int ret = 0;
-
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
-	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
-	return ret;
+	return stop_machine(__pkvm_drop_host_privileges, NULL, cpu_online_mask);
 }
 
 static void __init pkvm_selftests(void)
-- 
2.47.3

