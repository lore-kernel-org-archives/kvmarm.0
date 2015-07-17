From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 08/12] Fix call to connect()
Date: Fri, 17 Jul 2015 17:02:14 +0100
Message-ID: <1437148938-5394-9-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C7B58D18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RswEXr8W764i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 11:50:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 018AC58D0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:28 -0400 (EDT)
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

According to the manpage and the prototype the second argument to
connect(2) is a "const struct sockaddr*", so cast our protocol
specific type back to the super type.
This fixes compilation on musl-libc.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 kvm-ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-ipc.c b/kvm-ipc.c
index a289d4b..857b0dc 100644
--- a/kvm-ipc.c
+++ b/kvm-ipc.c
@@ -99,7 +99,7 @@ int kvm__get_sock_by_instance(const char *name)
 	strlcpy(local.sun_path, sock_file, sizeof(local.sun_path));
 	len = strlen(local.sun_path) + sizeof(local.sun_family);
 
-	r = connect(s, &local, len);
+	r = connect(s, (struct sockaddr *)&local, len);
 	if (r < 0 && errno == ECONNREFUSED) {
 		/* Tell the user clean ghost socket file */
 		pr_err("\"%s\" could be a ghost socket file, please remove it",
-- 
2.3.5
