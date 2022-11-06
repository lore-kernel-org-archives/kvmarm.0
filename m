Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.231.56.155])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 5F52115AC
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 06:39:57 +0000 (UTC)
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-1 (Coremail) with SMTP id AQAAfwCnIiAdpmhjcsnrAA--.24822S2;
	Mon, 07 Nov 2022 14:30:53 +0800 (CST)
Received: from centos7.localdomain (unknown [117.121.60.17])
	by mail (Coremail) with SMTP id AQAAfwDnQ_p8pmhj_SAaAA--.37504S3;
	Mon, 07 Nov 2022 14:32:28 +0800 (CST)
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: [PATCH] KVM: arm64: Fix typo in comment
Date: Sun,  6 Nov 2022 20:30:40 +0800
Message-Id: <1667737840-702-1-git-send-email-daizhiyuan@phytium.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID:AQAAfwDnQ_p8pmhj_SAaAA--.37504S3
X-CM-SenderInfo: hgdl6xpl1xt0o6sk53xlxphulrpou0/
Authentication-Results: hzbj-icmmx-1; spf=neutral smtp.mail=daizhiyuan
	@phytium.com.cn;
X-Coremail-Antispam: 1Uk129KBjvdXoW5KFykuw4rJF1ftF48Gr15urg_yoWxWFb_K3
	yfGr40gr1Fgrs29rWFga4rKr1vgws8XrZ8AFn5Xr4kAwnrXrW5WFyDXryIvF1Utr4agr4f
	taykWFyYqr1FyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrnU
	Uv73VFW2AGmfu7jjvjm3AaLaJ3UjIYCTnIWjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRUUUUU
	UUUU=
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Fix typo in comment (nVHE/VHE).

Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
---
 arch/arm64/kvm/hyp/vhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 96bec0e..3b9e546 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
+# Makefile for Kernel-based Virtual Machine module, HYP/VHE part
 #
 
 asflags-y := -D__KVM_VHE_HYPERVISOR__
-- 
1.8.3.1

