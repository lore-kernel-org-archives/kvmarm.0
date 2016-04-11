From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v6 05/10] irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
Date: Mon, 11 Apr 2016 16:32:55 +0100
Message-ID: <1460388780-914-6-git-send-email-julien.grall@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84B92410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z9YOC-KARlqF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:31:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 615F640F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:45 -0400 (EDT)
In-Reply-To: <1460388780-914-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Currently, most of the pr_* messages in the GICv3 driver don't have a
prefix.  Add one to make clear where the messages come from.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
    Changes in v6:
        - Patch added
---
 drivers/irqchip/irq-gic-v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 5b7d3c2..6dc6f03 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -15,6 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#define pr_fmt(fmt)	"GICv3: " fmt
+
 #include <linux/acpi.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
-- 
1.9.1
