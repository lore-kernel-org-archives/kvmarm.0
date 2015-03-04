From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 1/3] update-linux-headers.sh: export virtio_types.h
Date: Wed,  4 Mar 2015 14:16:15 +0000
Message-ID: <1425478577-32556-2-git-send-email-eric.auger@linaro.org>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9170647A35
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zNBjnUh24rNr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:10:51 -0500 (EST)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF21F47A25
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:50 -0500 (EST)
Received: by wghn12 with SMTP id n12so47041215wgh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 06:16:52 -0800 (PST)
In-Reply-To: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, christoffer.dall@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, mst@redhat.com, b.reynal@virtualopensystems.com
Cc: alex.williamson@redhat.com, patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

virtio_ring.h now includes virtio_types.h. update-linux-headers.sh
now exports this latter.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index c8e026d..bbe6185 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -62,7 +62,7 @@ done
 rm -rf "$output/linux-headers/linux"
 mkdir -p "$output/linux-headers/linux"
 for header in kvm.h kvm_para.h vfio.h vhost.h virtio_config.h virtio_ring.h \
-              psci.h; do
+              virtio_types.h psci.h; do
     cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
 done
 rm -rf "$output/linux-headers/asm-generic"
-- 
1.8.3.2
