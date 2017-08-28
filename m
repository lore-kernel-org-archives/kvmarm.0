From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v6 3/7] acpi: apei: remove the unused code
Date: Mon, 28 Aug 2017 18:38:17 +0800
Message-ID: <1503916701-13516-4-git-send-email-gengdongjiu@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

In current code logic, the two functions ghes_sea_add() and
ghes_sea_remove() are only called when CONFIG_ACPI_APEI_SEA
is defined. If not, it will return errors in the ghes_probe()
and not contiue. Hence, remove the unnecessary handling when
CONFIG_ACPI_APEI_SEI is not defined.

change since v5:
1. remove the SEI notification type handling, because the SEI is
   asynchronous exception and the address is not accurate. so
   not call memory_failure() to handle it.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 drivers/acpi/apei/ghes.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d661d452b238..c15a08db2c7c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -813,7 +813,6 @@ static struct notifier_block ghes_notifier_hed = {
 	.notifier_call = ghes_notify_hed,
 };
 
-#ifdef CONFIG_ACPI_APEI_SEA
 static LIST_HEAD(ghes_sea);
 
 /*
@@ -848,19 +847,6 @@ static void ghes_sea_remove(struct ghes *ghes)
 	mutex_unlock(&ghes_list_mutex);
 	synchronize_rcu();
 }
-#else /* CONFIG_ACPI_APEI_SEA */
-static inline void ghes_sea_add(struct ghes *ghes)
-{
-	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
-	       ghes->generic->header.source_id);
-}
-
-static inline void ghes_sea_remove(struct ghes *ghes)
-{
-	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
-	       ghes->generic->header.source_id);
-}
-#endif /* CONFIG_ACPI_APEI_SEA */
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
-- 
2.14.1
