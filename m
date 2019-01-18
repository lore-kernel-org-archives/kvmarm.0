From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 01/12] guest: Add generated file guest/guest_init.c to
 .gitignore
Date: Fri, 18 Jan 2019 16:14:10 +0000
Message-ID: <1547828061-20462-2-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <Julien.Grall@arm.com>, Andre Przywara <andre.przywara@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

guest/guest_init.c is a generated file, but git doesn't currently
ignore it.  This can be annoying when running git status etc.

This patch adds a suitable .gitignore entry for this file.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 guest/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 guest/.gitignore

diff --git a/guest/.gitignore b/guest/.gitignore
new file mode 100644
index 0000000..8e2da94
--- /dev/null
+++ b/guest/.gitignore
@@ -0,0 +1 @@
+guest_init.c
-- 
2.1.4
