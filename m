From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 36/37] KVM: arm/arm64: Don't call map_resources when restoring
 ITS tables
Date: Tue,  9 May 2017 12:45:05 +0200
Message-ID: <20170509104506.30929-37-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FED140C74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3-U6PQ8hR+w4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:39 -0400 (EDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
 [209.85.220.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B13040F01
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:32 -0400 (EDT)
Received: by mail-qk0-f178.google.com with SMTP id u75so75020715qka.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:47 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The only reason we called kvm_vgic_map_resources() when restoring the
ITS tables was because we wanted to have the KVM iodevs registered in
the KVM IO bus framework at the time when the ITS was restored such that
a restored and active device can inject MSIs prior to otherwise calling
kvm_vgic_map_resources() from the first run of a VCPU.

Since we now register the KVM iodevs for the redestributors and ITS as
soon as possible (when setting the base addresses), we no longer need
this call and kvm_vgic_map_resources() is again called only when first
running a VCPU.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 89acaef..9aeaff0 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2308,20 +2308,12 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 		goto out;
 
 	ret = vgic_its_restore_device_tables(its);
-
 out:
 	unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
 
-	if (ret)
-		return ret;
-
-	/*
-	 * On restore path, MSI injections can happen before the
-	 * first VCPU run so let's complete the GIC init here.
-	 */
-	return kvm_vgic_map_resources(its->dev->kvm);
+	return ret;
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
-- 
2.9.0
