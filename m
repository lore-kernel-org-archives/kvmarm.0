From: Colin King <colin.king@canonical.com>
Subject: [PATCH] KVM: arm/arm64: fix spelling mistake: "auxilary" -> "auxiliary"
Date: Sun, 17 Feb 2019 22:36:26 +0000
Message-ID: <20190217223626.16686-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a kvm_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7fcc1c8c4020..99c37384ba7b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1563,7 +1563,7 @@ static int init_hyp_mode(void)
 
 	err = hyp_map_aux_data();
 	if (err)
-		kvm_err("Cannot map host auxilary data: %d\n", err);
+		kvm_err("Cannot map host auxiliary data: %d\n", err);
 
 	return 0;
 
-- 
2.20.1
