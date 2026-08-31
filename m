Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3453CC313
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163825; cv=none; b=J/mzL5Ud0GNSNTpicWvng6atCLa7mJ7QSWdkrHAFSuXVrf3mFFkFEhWJ6mr6agHtZgrM7vfFKfLi8syjOUcyL9LOJgKm+nRtcTQI8f2ORggHTJadOz3la1RasqIkSufWD1klukXXjhvNW4fUdXhKgW6sgXFpSCzDRmLp/QbqGNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163825; c=relaxed/simple;
	bh=Aob392KCiPwYOZ26v4z6ameSKdVNEWay1hUTRybnICw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ENMKQMvnAXFs1urQ3YjElemi1lajzre2OtgK7SPx4dtLpReZfd3mJOustvqYnfX9qHKJ+1h1fK5QvZP+D8dcMMPyA465GXoiKhdHw1/lyTd7izsD2cpYf1f7ytLPiXRwxEt+YKSYVq6l/np0TMcGbSbFA6LeQsHeS9yYYVuDX30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L582K2+h; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L582K2+h"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49954b88fffso21390565e9.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788163822; x=1788768622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DQe0/H8SNUjRW9auKFahnt1W5WCW5fFGWugsoqcSd7E=;
        b=L582K2+hlymqO9gtbw3PCk2X9QFrykYcyjOexLCy7jVDQ0s3S+jGR6bxmq0W1XKVeI
         Lk+nrYetH1YKI5GWX9uqZxVhUc7DeRVhjwz46qtg7dHL7Bugj8YdqNK/MXqf8R3+lhJ9
         w7qoXaCKwjNRbj7W0vpHj4UF/Lpv8R+4x8hrlv1bD888JKhSQ+LmoSV5nDHDRbgxKiPu
         yyCIb+KbkH+Vh6qzwYeb+spaAs+Dthc2o77OMiUCAfK7kPogKfVUTwx8Erc8UGSY6HqC
         O3w6J/RUeFwXSOCEEf47u4otzTCHJZmRBwcXebLiz/it2id5RCNpk2udUD8NvAkB9bOl
         PH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788163822; x=1788768622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DQe0/H8SNUjRW9auKFahnt1W5WCW5fFGWugsoqcSd7E=;
        b=EAfOvITT1ya8X7bFBK7UIPJcKxmKuz/j/dmOPfPd4OwHB4FjTB2Wn4ygGJxw19yFfw
         wHRGypa/c9GSeo3KzAW/xrjziMlYV7jASJVoM4JyLVkUyRaKsq6nSaBNjJHm1Ai3MmAo
         6ToYLMimI3ZET8O4d99z0rl0tEWwhJK5YecqTn2HVUkaEHlPUNDtKVu6QG36o/QyD/Uj
         mN4ipetMLZtduE82VoLH/TxxwRKZhLHOlJXDKiNYV/gPQgcsJlMcRHERUKmcaKIRUS1h
         bqU9Ky00DE0qdpSaAxMJQukQGcK/Eri+gfOgBc7D7mRGlzjcrbm9+Lz+5XuWKyX76i6g
         xHdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8BBFEOE4GACpoONqjxW9Ehcy1EVBQ6emq7xhN+TROHDYgHUAJMOcEQhKti9imLl2apHLdeKU=@lists.linux.dev
X-Gm-Message-State: AFuF++lquOgMs3U84wUjwQ2h1G+5PC68D96J5A0aYYycxFmt80b8WVKk
	gKyldmO8NJ8hW1BSX+KyKxbw/56BcAQyY+dc4e2JEhPTbPMV4xzwrXzE
X-Gm-Gg: AR+sD13JKdHLjs5a2zPSVFSvtwhEQsT97OsVDOi1WgZ7JU8YBUZYtPWLRyripsh9tHq
	oKH8NZiu84k72qGdRUdF2zjKn9zgPF0ON2foprGZArfr28IAaw7kaSEq4sG0Y72D6ewL8IhKfJG
	NCfONu4LJOMjylPEVc5yDu29JtXuBOiaVuGW8wQ5yN0WDgSEx864D5EgiJCifw2x1QarFnJyH5N
	f4DGUchW09nySH9sL0eIEsyLqx9JRZY5mtxlowuixe5LbNn8WpbuN1EJ3ipkQcJEtA0o8o9nc1Z
	BcUB/nDjykQ+/RKw2iM/Lhs3I5h1xjG4h/Ewu1pnL87mi4fAk4Hax+dnkng6qC7YqDkA4GpsyKi
	XLUQsg79Al82++oNNkjtfT2fIvyc22xAbzv7h5eQwKebYXmFDBogZC5bpwbQCsedAVEyPh3CNMM
	jU5dTTE5Ehq6v5TSEgYa/+5h+gHH/XR5m1jqoXMTuSVpr5IanMS4t0Yd7/y5y3bUI9g8Ei1/rT2
	/WUaFswwG0Sy9xvkESuV7sD4jPHT6X3kEvH+ctkvEJfZ+31A+vrNaJzlCm+Si4CF2vH33looGLN
	Rss0pc3VVfgZAMDlNUN9qn16R4PAHJ6MXyF9jb/3dKAhe21n8J0weBheyYd8uDmGAP8c4ow=
X-Received: by 2002:a05:600c:c3cf:10b0:49b:8f18:714a with SMTP id 5b1f17b1804b1-49b91c47b76mr281088265e9.12.1788163821808;
        Mon, 31 Aug 2026 01:10:21 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013d06sm370393515e9.12.2026.08.31.01.10.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 01:10:21 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 2/4] KVM: arm64: vgic-v3: Roll back assignments from the new region
Date: Mon, 31 Aug 2026 10:10:02 +0200
Message-Id: <20260831081005.41346-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260831081005.41346-1-kmehltretter@gmail.com>
References: <20260831081005.41346-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed REDIST_REGION write unregisters the redistributor iodevs of every
vCPU processed before the failure. This includes vCPUs assigned to older
regions. Their assignments remain cached, so a retry does not register the
iodevs again.

The vCPU whose registration fails has no assignment to roll back. For vCPUs
processed earlier, limit rollback to those assigned to the new region. The
region is removed on failure, so its free_index does not need restoring.

Resetting assignments from older regions is unsafe because a vCPU can own
one before kvm_for_each_vcpu() can see it. Rollback could then move
free_index behind that live assignment.

kvm_vgic_addr() holds slots_lock across the REDIST_REGION write. vCPU
creation takes the same lock before assigning a redistributor. A concurrent
vCPU cannot acquire an assignment from the new region before rollback
completes. The lock also keeps rdreg valid across the config_lock drop
required by MMIO-bus registration.

Fixes: c011f4ea106b ("KVM: arm/arm64: Check vcpu redist base before registering an iodev")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 32 +++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 22897ce64dbf..77aa8433701a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -855,7 +855,25 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
-static int vgic_register_all_redist_iodevs(struct kvm *kvm)
+static void vgic_rollback_redist_iodev(struct kvm_vcpu *vcpu,
+				       struct vgic_redist_region *rdreg)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	lockdep_assert_held(&vcpu->kvm->slots_lock);
+
+	if (vgic_cpu->rdreg != rdreg)
+		return;
+
+	vgic_unregister_redist_iodev(vcpu);
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+	vgic_cpu->rdreg = NULL;
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+}
+
+static int vgic_register_all_redist_iodevs(struct kvm *kvm,
+					   struct vgic_redist_region *rdreg)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long c;
@@ -870,12 +888,12 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	}
 
 	if (ret) {
-		/* The current c failed, so iterate over the previous ones. */
+		/* Undo assignments made from the region being added. */
 		int i;
 
 		for (i = 0; i < c; i++) {
 			vcpu = kvm_get_vcpu(kvm, i);
-			vgic_unregister_redist_iodev(vcpu);
+			vgic_rollback_redist_iodev(vcpu, rdreg);
 		}
 	}
 
@@ -984,10 +1002,13 @@ void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdre
 
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
+	struct vgic_redist_region *rdreg;
 	int ret;
 
 	mutex_lock(&kvm->arch.config_lock);
 	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
+	if (!ret)
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 	mutex_unlock(&kvm->arch.config_lock);
 	if (ret)
 		return ret;
@@ -996,12 +1017,9 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
 	 * afterwards will register the iodevs when needed.
 	 */
-	ret = vgic_register_all_redist_iodevs(kvm);
+	ret = vgic_register_all_redist_iodevs(kvm, rdreg);
 	if (ret) {
-		struct vgic_redist_region *rdreg;
-
 		mutex_lock(&kvm->arch.config_lock);
-		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 		vgic_v3_free_redist_region(kvm, rdreg);
 		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
-- 
2.39.5 (Apple Git-154)
