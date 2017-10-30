From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/8] KVM: arm64: its: Fix missing dynamic allocation check in scan_its_table
Date: Mon, 30 Oct 2017 03:55:56 +0100
Message-ID: <20171030025603.23550-2-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently allocate an entry dynamically, but we never check if the
allocation actually succeeded.  We actually don't need a dynamic
allocation, because we know the maximum size of an ITS table entry, so
we can simply use an allocation on the stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1b3f70..77652885a7c1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1801,37 +1801,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
-	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
 	int id = start_id;
 	gpa_t gpa = base;
+	char entry[esz];
 	int ret;
 
+	memset(entry, 0, esz);
+
 	while (len > 0) {
 		int next_offset;
 		size_t byte_offset;
 
 		ret = kvm_read_guest(kvm, gpa, entry, esz);
 		if (ret)
-			goto out;
+			return ret;
 
 		next_offset = fn(its, id, entry, opaque);
-		if (next_offset <= 0) {
-			ret = next_offset;
-			goto out;
-		}
+		if (next_offset <= 0)
+			return next_offset;
 
 		byte_offset = next_offset * esz;
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	ret =  1;
-
-out:
-	kfree(entry);
-	return ret;
+	return 1;
 }
 
 /**
-- 
2.14.2
