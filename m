From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/13] fs: fix unsigned enum warning with gcc-4.2
Date: Fri, 16 Dec 2016 11:56:32 +0100
Message-ID: <20161216105634.235457-12-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0100B40797
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A0qbn+EHIxdn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:41 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9B9540697
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With arm-linux-gcc-4.2, almost every file we build in the kernel ends
up with this warning:

include/linux/fs.h:2648: warning: comparison of unsigned expression < 0 is always false

Later versions don't have this problem, but it's easy enough to
work around.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 398cf20a706d..782c2a292fd7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2645,7 +2645,7 @@ static const char * const kernel_read_file_str[] = {
 
 static inline const char *kernel_read_file_id_str(enum kernel_read_file_id id)
 {
-	if (id < 0 || id >= READING_MAX_ID)
+	if ((unsigned)id >= READING_MAX_ID)
 		return kernel_read_file_str[READING_UNKNOWN];
 
 	return kernel_read_file_str[id];
-- 
2.9.0
