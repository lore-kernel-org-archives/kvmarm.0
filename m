From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 01/13] ioeventfd: Fix removal of ioeventfd
Date: Thu, 10 Jan 2019 14:12:38 +0000
Message-ID: <1547129570-14351-2-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23B104A422
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MUTRq9gAdC2W for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:12:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 183F64A3E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:12:59 -0500 (EST)
In-Reply-To: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

Fix three bugs that prevent removal of ioeventfds in KVM. Store the
flags in the right structure, check the datamatch parameter, and pass
the fd to KVM.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 ioeventfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ioeventfd.c b/ioeventfd.c
index 14453b8..3ae8267 100644
--- a/ioeventfd.c
+++ b/ioeventfd.c
@@ -172,7 +172,7 @@ int ioeventfd__add_event(struct ioevent *ioevent, int flags)
 		}
 	}
 
-	ioevent->flags = kvm_ioevent.flags;
+	new_ioevent->flags = kvm_ioevent.flags;
 	list_add_tail(&new_ioevent->list, &used_ioevents);
 
 	return 0;
@@ -192,7 +192,8 @@ int ioeventfd__del_event(u64 addr, u64 datamatch)
 		return -ENOSYS;
 
 	list_for_each_entry(ioevent, &used_ioevents, list) {
-		if (ioevent->io_addr == addr) {
+		if (ioevent->io_addr == addr &&
+		    ioevent->datamatch == datamatch) {
 			found = 1;
 			break;
 		}
@@ -202,6 +203,7 @@ int ioeventfd__del_event(u64 addr, u64 datamatch)
 		return -ENOENT;
 
 	kvm_ioevent = (struct kvm_ioeventfd) {
+		.fd			= ioevent->fd,
 		.addr			= ioevent->io_addr,
 		.len			= ioevent->io_len,
 		.datamatch		= ioevent->datamatch,
-- 
1.9.1
