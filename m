From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 05/12] ui: remove pointless double const in keymap declarations
Date: Fri, 17 Jul 2015 17:02:11 +0100
Message-ID: <1437148938-5394-6-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 728E558CF5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 99rjYNY6P0Wd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 11:50:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09FE58CD2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:24 -0400 (EDT)
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

clang does not like two const specifiers in one declaration, so
remove one to let clang compile kvmtool.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 ui/gtk3.c | 2 +-
 ui/sdl.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ui/gtk3.c b/ui/gtk3.c
index b2335bc..1e08a8f 100644
--- a/ui/gtk3.c
+++ b/ui/gtk3.c
@@ -34,7 +34,7 @@ struct set2_scancode {
 	.type = SCANCODE_ESCAPED,	\
 }
 
-static const struct set2_scancode const keymap[256] = {
+static const struct set2_scancode keymap[256] = {
 	[9]	= DEFINE_SC(0x76),	/* <esc> */
 	[10]	= DEFINE_SC(0x16),	/* 1 */
 	[11]	= DEFINE_SC(0x1e),	/* 2 */
diff --git a/ui/sdl.c b/ui/sdl.c
index a260002..f97a511 100644
--- a/ui/sdl.c
+++ b/ui/sdl.c
@@ -36,7 +36,7 @@ struct set2_scancode {
 	.type = SCANCODE_ESCAPED,\
 }
 
-static const struct set2_scancode const keymap[256] = {
+static const struct set2_scancode keymap[256] = {
 	[9]	= DEFINE_SC(0x76),	/* <esc> */
 	[10]	= DEFINE_SC(0x16),	/* 1 */
 	[11]	= DEFINE_SC(0x1e),	/* 2 */
-- 
2.3.5
