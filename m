Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8748528EC
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 23:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674777316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kli5sE9lIHwCvZbbt0ccDIlIdit3t3RFH2I2s6WRBok=;
	b=ANe2B4vbUih/3t3MTfcuexWNmeGbLWcbS++Egab7siwFDxdMHS6Wbvo5ngAwQQ/H2TV7DL
	PMinLlnIZuo8atO+FlThx3SmCwKm8WTnQkanBo+0uXNvgLteTMiJiJ9HmWxurRCj49dLe7
	xpLjMF27Tb6lNSdM6JQHx/5C4Qh/s9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-RgZNoq5vNEqcDzBpmEVZzw-1; Thu, 26 Jan 2023 18:55:13 -0500
X-MC-Unique: RgZNoq5vNEqcDzBpmEVZzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF22B1C05AAA;
	Thu, 26 Jan 2023 23:55:12 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 647E92166B29;
	Thu, 26 Jan 2023 23:55:04 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzhe@nfschina.com,
	isaku.yamahata@intel.com,
	seanjc@google.com,
	ricarkol@google.com,
	eric.auger@redhat.com,
	renzhengeek@gmail.com,
	reijiw@google.com,
	shan.gavin@gmail.com
Subject: [PATCH v3 1/4] KVM: arm64: Include kvm_mmu.h from vgic.h
Date: Fri, 27 Jan 2023 07:54:48 +0800
Message-Id: <20230126235451.469087-2-gshan@redhat.com>
In-Reply-To: <20230126235451.469087-1-gshan@redhat.com>
References: <20230126235451.469087-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

We need a unified helper in 'kvm/vgic/vgic.h' to write guest memory. In
the helper, the check of no-running-vcpu context for dirty ring will be
applied. kvm_write_guest_lock(), defined in 'include/asm/kvm_mmu.h', is
going to be dereferenced by the unified helper.

Include 'include/asm/kvm_mmu.h' to 'kvm/vgic/vgic.h' to avoid including
the former header file when the later one is needed. With the change,
the duplicate inclusions of 'include/asm/kvm_mmu.h' are removed.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c      | 1 -
 arch/arm64/kvm/vgic/vgic-init.c       | 1 -
 arch/arm64/kvm/vgic/vgic-its.c        | 1 -
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 1 -
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 1 -
 arch/arm64/kvm/vgic/vgic-v2.c         | 1 -
 arch/arm64/kvm/vgic/vgic-v3.c         | 1 -
 arch/arm64/kvm/vgic/vgic.h            | 1 +
 8 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 78cde687383c..69201c2dfc6c 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -10,7 +10,6 @@
 #include <linux/kvm_host.h>
 #include <linux/seq_file.h>
 #include <kvm/arm_vgic.h>
-#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f6d4f4052555..de389a5bec45 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -9,7 +9,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 94a666dd1443..ad4bb69ab83e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -18,7 +18,6 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..552668a91bd9 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -8,7 +8,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <linux/uaccess.h>
-#include <asm/kvm_mmu.h>
 #include <asm/cputype.h>
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..8ba04f4fa63d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -13,7 +13,6 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 645648349c99..d8604fdfdfcd 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -7,7 +7,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 2074521d4a8c..5dfbd03e5e1a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -7,7 +7,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
-#include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
 
 #include "vgic.h"
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c8da72953f0..056425e3a490 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -6,6 +6,7 @@
 #define __KVM_ARM_VGIC_NEW_H__
 
 #include <linux/irqchip/arm-gic-common.h>
+#include <asm/kvm_mmu.h>
 
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
-- 
2.23.0

