Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.197])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B88428E1
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=PwJ2E
	WawDDGnu3De6KZ9qNSUZJy0dPE5mcjMyJRz3FQ=; b=frjD8UIdO+bhbLL7tpZal
	p9GuAlJs+JRzSZhQAoDC3zXQftPhPVz0dwMgYk98KMG/mH2BpMKBHylOk6IJfnTX
	88BDqIrB4T+UjJ8acQNbwGzLOeTYJDA8371D9YCF6GGq+qz/hfgtsHOZZO1HNnAf
	Si3o2FDEVjyU3ZiNNJ87UA=
Received: from f00160-VMware-Virtual-Platform.localdomain (unknown [103.208.12.108])
	by zwqz-smtp-mta-g2-3 (Coremail) with SMTP id _____wDntuHYkQlkl8qtCg--.12999S4;
	Thu, 09 Mar 2023 15:59:47 +0800 (CST)
From: Jingyu Wang <jingyuwang_vip@163.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jingyu Wang <jingyuwang_vip@163.com>
Subject: [PATCH] KVM: arm64: fix repeated words in comments
Date: Thu,  9 Mar 2023 15:59:19 +0800
Message-Id: <20230309075919.169518-1-jingyuwang_vip@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDntuHYkQlkl8qtCg--.12999S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF48GF4DZFWDWFyUWF4Uurg_yoW3GFgEva
	yxta1Sgr4rAr1I9r15tay2yFyIy398J34furn7GFn2qr9rXr97GrWUWFW8Wr1UWw45Gr43
	XF4DAr13Aw1SgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRMmiiDUUUUU==
X-Originating-IP: [103.208.12.108]
X-CM-SenderInfo: 5mlqw5xxzd0whbyl1qqrwthudrp/xtbBaRUtF1Xlza9LNgAAsp

Delete the redundant word 'to'.

Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
---
 arch/arm64/kvm/inject_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 64c3aec0d937..0bd93a5f21ce 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -204,7 +204,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	 * Size Fault at level 0, as if exceeding PARange.
 	 *
 	 * Non-LPAE guests will only get the external abort, as there
-	 * is no way to to describe the ASF.
+	 * is no way to describe the ASF.
 	 */
 	if (vcpu_el1_is_32bit(vcpu) &&
 	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
-- 
2.34.1

