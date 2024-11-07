Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A88218D64
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015705; cv=none; b=jnYBm4CQd5x/AkeNI6Op19BgFYkCNgeoeQUaP7MXJQTIiwpFuvtDBV/Lb8fQDyuCQz1AzfcBgLQ3XPeK6BiHkDBVDNTge/x/YC7Q334IqfrF3PZXozPIX4hzZ1VjPx1OY20fp4W5gcwsUYram4tep57Je7mwkvRsxiv3V8AczDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015705; c=relaxed/simple;
	bh=2pbUMDr5DJLxz76a4PYkqqphNu7dpq8aJ2XhdaDTv9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fqlxaSbfqAcTAD0RDw5xF3FwtHZ1STpO9tDM7REOQfFfGwzF0sWPmPR9+sly8ulll2dBlRuIOXRzYGS2Z7N6VmM+vyYdVXPA1QI835aSzFMVygJAxV4Ok1dYepuXDggmqqyFqQoss+PiR9Ru9JxeyFiABmCcqj2qca8jdnJJmm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4GTJSBnU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4GTJSBnU"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a5e862eso18866467b3.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 13:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015703; x=1731620503; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hiCU49kQ7nM6OEw67YOfyReqqCaE0LkMlzZtaslGJ+8=;
        b=4GTJSBnUZ5spcE+cJShq9z/Pi+kat4rd6Dx7ajuDslTdK+XiDifCMde5Ul9Je0STp8
         Ym7vwr5IHFJDKQYThVj+xROc/j05p3r6SO63oOK3G125hG8vRhprgp8kV/3LlWMlbq7D
         eTQCfwpZQD/hWVaHmvIOCZxi0F5189QjoYgivhJzE3UrqnmTS/y3qkjJyoiWWji1B0Zr
         28QHV7DoX4jX0ZqrY8UHc75HTb98jugtCGcO0Pl+9zPdgMfrGqEKB7quqfAJ4u/vQZn+
         ZsGRcFzNcrYGqHGKqb+XiKIR8MXybGDNatPWGXP3tkuZ2kfe8hDJGZFFLaaZ63AuxBAK
         lbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015703; x=1731620503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiCU49kQ7nM6OEw67YOfyReqqCaE0LkMlzZtaslGJ+8=;
        b=D87wskERw7uQVzSOTm10nnQuxqMjLMhpMaFAe1c2wi9byDcr+/5EPm6CSJxyk7lEMX
         uNFBNamMSzHAU3H8zD5nZVfaHj8uwaBqEzh2Ws1+tpFtvPhgmsexzDY3n3uYrW/zhUHK
         Xnm/BZPeYipNQLxhBl/RVKgtVlAscnKLi0yzxqNS73VXD5o921XfMLWowLD5nIVLELf6
         9KcoPIqhBwIm/hqsk6yF+ldpMwiORHKOA1k0MDtyqfxrk3SFgI+eiR36OqRiQSYViYbI
         iPYUFgTZrsTu++vvEx09lnsWh6/5FCERN2h2Eaq0n6recdXhv+p+GYli5eHElnA2PRJN
         o4FA==
X-Forwarded-Encrypted: i=1; AJvYcCVfuTMBLBOh/+iNNF5tw4pmDDWfYbPta8Ub1Ox4kYqlxd0jN1Z43mNedQupU8Z7DNs+vzoX7mc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzveBaaMYw6iWz8y+K/unhlHHSwd1LOgwRtc12TlaWq8Kv7rnmK
	EaxOs71+GpAiNQdWw/5dp13yUGruMHEthqj/Kyo2eXw6iuPZKSspQf8UzJDqnNrpCpL+N91HG4+
	lptp5VQoeJ5vaQBO3La3R7Q==
X-Google-Smtp-Source: AGHT+IFmgY5AoHS66JpJ0ifa3vDhWyv/RjJrFb6ac4d0BLBtWrLWqHo8sUtLA5mcEv0UhGNPrlRByVBRLG34IueAkQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:7407:b0:68e:8de6:617c with
 SMTP id 00721157ae682-6eade552a04mr73357b3.5.1731015703380; Thu, 07 Nov 2024
 13:41:43 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:34 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-3-jingzhangos@google.com>
Subject: [PATCH v4 2/5] KVM: arm64: vgic-its: Add read/write helpers on ITS
 table entries.
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

To simplify read/write operations on ITS table entries, two helper
functions have been implemented. These functions incorporate the
necessary entry size validation.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2486b4d9f95..309295f5e1b0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -146,6 +146,29 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
+static inline int vgic_its_read_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					   u64 *eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(*eval), kvm))
+		return -EINVAL;
+
+	return kvm_read_guest_lock(kvm, eaddr, eval, esize);
+
+}
+
+static inline int vgic_its_write_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					    u64 eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(eval), kvm))
+		return -EINVAL;
+
+	return vgic_write_guest_lock(kvm, eaddr, &eval, esize);
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
-- 
2.47.0.277.g8800431eea-goog

