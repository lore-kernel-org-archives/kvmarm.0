Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1E20E016
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 19:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835283; cv=none; b=JlijsHzgxBsV6j0QdgA23vMZ+5ThxXd8PHQPrL8ux6dbBmH35KI1ZSVTP4dz8CfcPI9mg0hvW8ujmmKyLBOxk4fdWr/7xZle0HJoGErES1wlHRy1kD+BPUCpcbl7KFHTjRbtRB88d1ZBr/Sz96x3V/u166Q8je7kNb0c9jTO0L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835283; c=relaxed/simple;
	bh=xPd4i6jpgEFj3QDbxccFoSZ95IE5WTJsPwiUZwvNonU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uocHqkagKi/4GAh8axmXpEhAOd4rUekDZqgPifR4t/kVNDCz26qSsACRsKP06Xr7L+lx3rw2su9vqJ0OE2JP/eL8B1t7RH9Jl2JF5rptZT72IGzQU+N7Wy4pvCBgxQcqrvv5t/3JLY97BoslEYapWAs/3r7qMbcNVC/+Sp4Tnw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P5v0Y3dl; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P5v0Y3dl"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e291ac8dcf3so9451230276.3
        for <kvmarm@lists.linux.dev>; Tue, 05 Nov 2024 11:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835281; x=1731440081; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rG28HMeFmKNz149Y+Vw5VAUYNp3YmfGstywpzoeBNY=;
        b=P5v0Y3dlhfyGUJMg/nQtN0QTFplN2rSGuhGoML3IZL4MiMR4eVKiqsoJ3wsMq4BxWP
         +Vp3fcVl+HbMPsazEXB70+4TD2hqV0HVqQUPQSn1jMtiwNPhJ1RPihfxJghTgW5Q7yHZ
         aaYeqsoV1SdzFaVNeqKRqFicXANZNcByhBGLIsKqvy3tnu9LOag1DZGnQpBFulYCqfUi
         esLN7gPNqKnNYgfzPLNLPj9UJ/gq+mV73ajBiE6jm0Hq52Pw7WHS6qwbdxfDNpSv09IJ
         MiCPIOSipUjLwxKZlb0mwNn7+E5SXu2sZlTNJiiDEI0sy04dAzaDnyAlGti7ecXDyLuW
         QtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835281; x=1731440081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rG28HMeFmKNz149Y+Vw5VAUYNp3YmfGstywpzoeBNY=;
        b=dkZqw5QZpKckXa/qpLn3AL3nzbZw/wiCTB39EFEKYq3tpZON7JC7MuDfwWWEhlLNh/
         VW8nHhCYKbe61bsq+kCiezLN8Hd+qAQ8lN+z3wnm8pe0XUhA1aSKHNExaWWmk0x7ZUI4
         VC+xCcXsHHf9nWCPq2JLV3R4e+UIXCaD9fGXmdl9IEdHnOsVd+kXuhxO6v0p1Apqsxkq
         N3ew57blddU4+qtTZm0YAZZE3R9mof/GgYj9RU2beDIvBqaEzEEUAC2qmHZ8vRa7U/M9
         Fav9w/zyhtprcz8Gv7JxBn9MlRPoPaBxJJ6VvI4x+27LiB3z9degXAx6meaLawv0P+R7
         gSbw==
X-Forwarded-Encrypted: i=1; AJvYcCURti4F8nohX01u7Z9aLQLYJWfbUjXIlwD8I9SPSa4ohgf8gTXL+Zc+cTJUPP65NkUd0jYRhAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+XtlJKRDm0TynEXwDaPsYjStNtSdre4Z9O+eMz+7hWEvULhLj
	gDB8OXeVeLqCJHIPhcJOcupzmhicU0RlglsHoXHoq9SQIqj3wSPIRTl0TJ/A5ER63OZxk5Pa2ce
	3vzPXVziZ8c4OPRMb/qeD3g==
X-Google-Smtp-Source: AGHT+IHSwjlYAEmxZvE3K18uqtu/bNQVHl4DA7qztn64qZnoHG833wnp2QKrs1chSkfAHMYdTQ7wPLIAKTndfwX+xQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:d616:0:b0:e29:76b7:ed37 with SMTP
 id 3f1490d57ef6-e3302669387mr18225276.9.1730835281208; Tue, 05 Nov 2024
 11:34:41 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:22 -0800
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-5-jingzhangos@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: vgic-its: Utilize the dummy entry in ITS
 tables restoring
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Now, the first entry in tables is either a valid DTE/ITE or a dummy
entry pointing to the first valid DTE/ITE. Revise the DTE/ITE restore
process to utilize the dummy entry to avoid unnecessary (erroneous)
entry scanning.
This is not supposed to break the ITS table ABI REV0.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 46 ++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 867cc5d3521d..e07939613f5c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2129,23 +2129,30 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	u32 coll_id, lpi_id;
 	struct its_ite *ite;
 	u32 offset;
+	u32 magic;
 
 	val = *p;
 
 	val = le64_to_cpu(val);
 
-	coll_id = val & KVM_ITS_ITE_ICID_MASK;
 	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
 
-	if (!lpi_id)
-		return event_id + 1; /* invalid entry, no choice but to scan next entry */
+	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
+	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
+		return -EINVAL;
+
+	if (!lpi_id) {
+		magic = (val & KVM_ITS_ENTRY_DUMMY_MASK) >> KVM_ITS_ENTRY_DUMMY_SHIFT;
+		if (magic != KVM_ITS_ENTRY_DUMMY_MAGIC)
+			offset = 1;
+
+		return event_id + offset;
+	}
 
 	if (lpi_id < VGIC_MIN_LPI)
 		return -EINVAL;
 
-	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
-	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
-		return -EINVAL;
+	coll_id = val & KVM_ITS_ITE_ICID_MASK;
 
 	collection = find_collection(its, coll_id);
 	if (!collection)
@@ -2303,17 +2310,30 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	u64 entry = *(u64 *)ptr;
 	bool valid;
 	u32 offset;
+	u32 magic;
 	int ret;
 
 	entry = le64_to_cpu(entry);
 
 	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
-	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
-	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
-			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
 
-	if (!valid)
-		return id + 1;
+	/*
+	 * Since we created a dummy head entry for the DTE static linked list in
+	 * the table if necessary, no need to scan to find the list head.
+	 * But if the saved table was done without dummy entry support, we still
+	 * have to scan one by one.
+	 */
+	if (!valid) {
+		magic = (entry & KVM_ITS_ENTRY_DUMMY_MASK) >>
+			KVM_ITS_ENTRY_DUMMY_SHIFT;
+		if (magic != KVM_ITS_ENTRY_DUMMY_MAGIC)
+			offset = 1;
+		else
+			offset = (entry & KVM_ITS_DTE_DUMMY_NEXT_MASK) >>
+				  KVM_ITS_DTE_DUMMY_NEXT_SHIFT;
+
+		return id + offset;
+	}
 
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
@@ -2321,6 +2341,10 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 
+	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
+	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
+			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.47.0.199.ga7371fff76-goog

