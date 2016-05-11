From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 23/29] irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
Date: Wed, 11 May 2016 15:30:16 +0200
Message-ID: <1462973422-10021-24-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AF749B66
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6GdOtz0l9lGg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:22 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BA4049B63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:15 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id g17so82951886wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:13 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

Currently, most of the pr_* messages in the GICv3 driver don't have a
prefix.  Add one to make clear where the messages come from.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.1.2.330.g565301e.dirty
