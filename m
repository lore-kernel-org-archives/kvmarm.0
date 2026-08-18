Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7933C18B
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787092468; cv=none; b=NkhwllfHD6PmKUNS0brlsj6pBHrxLBUQL75tbNJ4uAyq1mT7xHNzIinLpJ9JhQA+HSVYpIqwJ76Kexaurad0mjFi+XUOjgKlN7cpfCLse1mw6YaOS2RWYf81RT6QS+PRzoWhyfyzEXFqcwyhQvKWd10YwHqpoF6J0QWST/Z5XME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787092468; c=relaxed/simple;
	bh=iN8fKR5wtoJaEfAlwqO2ijAfhLGA/7arzUP99yGxMUU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pe4OaP1vt2PbvFzI6xM+eTtAP0CRWqs1Dwzb550N8kHvPIZkjot0w8JZXZjSBcffqLaXMeaRukG7jzZGuuM0RwLz9t4EsvD3jWNO9yW5wB5KtvmRsPPqQ5iRbEMm6jieWmQ59SVMiM6AvUZY5u6d/pCxexO5sAQOSAbxs6Ca4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lHxvjNqb; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHxvjNqb"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so247248a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787092467; x=1787697267; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7xwBYfLUKLPOpkt5/GQYGFfBN9yGyR+1iH1KFRGKS2I=;
        b=lHxvjNqb9XazlvZKjrzIs0VOuOO6xS612RsIkzeciprwKOUKez6vArYJDCTXASBEmW
         dkznwL1FjVQbFu0jcLZZ3+CYn63Eza44oBuA7hdNn4q1KKjG2TFMuaqzvQvfBcQDaaL+
         /zBkVYVOVeSY2/Cp4lxGMTbR//UQq+MEgByNIrGvNPqGD5vlqvLOacaLCPoaYMNmrTnl
         tATLrUMOkJMCuPKHz9l9D58keg8XcLeCPaYL3wwdtp7lNDAJ69e2YC2Xr8fziWH5cJtZ
         F20f9ardgeRoTr4iZpoYmvuan0GZtG3kzk05JOv+Em+PWSQBN/qEX7neJvz+gy6+p3/h
         7x6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787092467; x=1787697267;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7xwBYfLUKLPOpkt5/GQYGFfBN9yGyR+1iH1KFRGKS2I=;
        b=fHOhE3CCbOvSyUCUhRJtAPLE0GGmVdh+JD8JCW43uWzKMJ0Ndg/bAksWXC+OG5FGFR
         /SJNcGX1LDApXHl4M7LOfvtalzA9riXLVyQW17pgIEPwW3ICARNawvQFckBPu7jrbT51
         yDrHekcIKAoi00sm9/iZIxB8mnn+NmEsFSSUOHWVlhwDkf135IcJADcUk1ZMCs/MDQSC
         rEADmFQu1pxVoZeYjNVV8bnkjrD+W/z0Ibo82cqZ5LRUnft6W/rbKJ+viLJwq3agG9xq
         WaEJHmsnpO1icCv31fJ37HEbN1MddaC19AYsGz/JZaNjfhynGMTqU6GdBCk/4+Bx3IXK
         mXdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrZ/eOaQMU1aVm5a4bM+Sc/BrBGfCqcYm4bQT2JXqkRmjKkeGDEdCnIRxkYGoKL2IwnU53nUIc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE0gtCI6wMtzu4XGwKKi4qRSoCocO317H+sBHUNPvwUzKAkohg
	vlRpo4JSgiav4RNdHBQqfl9priq8zfnbdCR1KcKYORcNfeqeorTn7lpE7kHbZmuB1Z59MckwaQV
	OeDQhIzA4SkZN1gg68K0ytkoH6w==
X-Received: from pgbdo4.prod.google.com ([2002:a05:6a02:e84:b0:c8a:3e7c:1e5d])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a10f:b0:3cc:51ff:c2e7 with SMTP id adf61e73a8af0-3cd0193b93cmr466456637.10.1787092466770;
 Tue, 18 Aug 2026 15:34:26 -0700 (PDT)
Date: Tue, 18 Aug 2026 15:34:22 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.737.g08866a6d13-goog
Message-ID: <20260818223422.367803-1-jingzhangos@google.com>
Subject: [PATCH] KVM: arm64: vgic-its: Fix O(C*I) loop in vgic_its_free_collection_list
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

When destroying the vgic-its collection list,
vgic_its_free_collection_list() iterates over every collection and for
each, calls vgic_its_free_collection(). This function walks every
Interrupt Translation Entry (ITE) across all devices via
for_each_lpi_its() to nullify the collection pointer.

A guest can allocate up to 65536 collections and hundreds of thousands
of ITEs. By clearing GITS_CTLR.Enable and writing Valid=0 to
GITS_BASER1, the guest can trigger this teardown path from a single MMIO
exit. The resulting O(Collections * ITEs) nested loop executes billions
of iterations without a single cond_resched(). This pins a physical CPU
and stalls RCU grace periods for seconds or minutes on PREEMPT_NONE
kernels.

Fix this by replacing the O(Collections * ITEs) teardown with an
O(Collections + ITEs) pass. Since the entire collection list is being
freed, we can safely bulk-clear the collection pointers from all ITEs in
a single pass, and then free all the collections in a second pass.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 36ab3e4929154..a8e819fe97898 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1133,9 +1133,21 @@ static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
 static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
 {
 	struct its_collection *cur, *temp;
+	struct its_device *device;
+	struct its_ite *ite;
 
-	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
-		vgic_its_free_collection(its, cur->collection_id);
+	/*
+	 * Bulk-clear the collection pointers for all ITEs.
+	 * This transforms the teardown complexity from O(Collections * ITEs)
+	 * to O(Collections + ITEs), avoiding guest-triggered host RCU stalls.
+	 */
+	for_each_lpi_its(device, ite, its)
+		ite->collection = NULL;
+
+	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list) {
+		list_del(&cur->coll_list);
+		kfree(cur);
+	}
 }
 
 /* Must be called with its_lock mutex held */
-- 
2.55.0.737.g08866a6d13-goog

