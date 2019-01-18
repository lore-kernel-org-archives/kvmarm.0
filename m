From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 04/12] Makefile: [HACK] Pass relevant flags when checking
 for libfdt
Date: Fri, 18 Jan 2019 16:14:13 +0000
Message-ID: <1547828061-20462-5-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11FC94A3DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PK+Ym4CLjKBd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1984A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:28 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CPPFLAGS and LDFLAGS may be telling us where libdft.h and -lfdt are
to be found, so don't ignore them when looking for libfdt.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e8e9376..d6bcce7 100644
--- a/Makefile
+++ b/Makefile
@@ -310,7 +310,7 @@ $(warning No static libc found. Skipping guest init)
 endif
 
 ifeq (y,$(ARCH_WANT_LIBFDT))
-	ifneq ($(call try-build,$(SOURCE_LIBFDT),$(CFLAGS),-lfdt),y)
+	ifneq ($(call try-build,$(SOURCE_LIBFDT),$(CPPFLAGS) $(CFLAGS) $(LDFLAGS),-lfdt),y)
           $(error No libfdt found. Please install libfdt-dev package)
 	else
 		CFLAGS_DYNOPT	+= -DCONFIG_HAS_LIBFDT
-- 
2.1.4
