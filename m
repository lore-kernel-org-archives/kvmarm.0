From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 03/12] kvm-ipc: use proper type for file descriptor
Date: Fri, 17 Jul 2015 17:02:09 +0100
Message-ID: <1437148938-5394-4-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

A socket (as any other file descriptor) is of type "int" to catch the
negative error cases. Fix the declaration to allow errors to be
detected.
Found and needed by clang.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 kvm-ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-ipc.c b/kvm-ipc.c
index b1c43dd..a289d4b 100644
--- a/kvm-ipc.c
+++ b/kvm-ipc.c
@@ -34,7 +34,7 @@ static pthread_t thread;
 static int kvm__create_socket(struct kvm *kvm)
 {
 	char full_name[PATH_MAX];
-	unsigned int s;
+	int s;
 	struct sockaddr_un local;
 	int len, r;
 
-- 
2.3.5

