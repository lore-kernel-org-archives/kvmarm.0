Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422C2374EB
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175493; cv=none; b=HPDUClv2MVbfpNqj4kStKMA0SfFcV0W2LX6OWc5a4nSsp6CwJFzO5L3l/AWPU/aRHqJaGP5zbq5A2yphpHT5lnaFgrMIGcQWdLoEDjZcQ23rsrI58hjltuIz2nxxDRxd6sIpNzEdwWf91b6mI9smBAHKQfQBvA8/qVxZQmr5Jo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175493; c=relaxed/simple;
	bh=4TOA+r5FgQu9r7XyUG+jnEXfKZGB1J0B4LAWQX2lpPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6/6zvs4vRX/e5gxIW+Axuq5ogz8zcI3aEmSDSioGGiodfw1gtH8sTGYLzLED6Lb4N7NctUeGyEf2yN1awhhnqc9UosW86z43smOWXC5whOKbYYDQXr0hoXd9tVf/EnR51SFKNO0Rn5OF130NvtSIav5wrZZdki2sAp6NmjNtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mNFVNgNp; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mNFVNgNp"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e49833ccdfso174859a34.2
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 18:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175491; x=1709780291; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8gBHZBcb2YMWItHZ5v52k75LYEpNNA/oZohojyoTqA=;
        b=mNFVNgNpE/YweQUEl6Hgoz9sjskBh0aHkt1YyiGBF+GUuTNH6t3LlgzP8tdOdt30tJ
         p32lOWVgzT1MBQT8ybneDb41b3Injqw/npNuT/6kXiBWsb60n0fMF6awYgm88ZkOpMJM
         dI0zIKK85yZUPJYXRpAxOCCdHagKbk9r9ZalY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175491; x=1709780291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8gBHZBcb2YMWItHZ5v52k75LYEpNNA/oZohojyoTqA=;
        b=ISv3xNBpGBlQrg8YVbOCLDd8GHIyLuecSObHqJkjj++BeKEmMKrS5kWN1Vsv5ibszi
         zknfZ/3rMEy0bOTpXXvmIgAOI98KDaJsXlQOtz9hSM1s7ZKWXdPGbG4IFnQs3d+4+VS7
         p+N4bZl9vuxtzircbhvKoQwocTuCTWVZ9QBfoC1iNMKykeD1x7S+dVmew0lbN+Zrcccg
         kmtYlyXL+JeMGqeWodVobmL72ICkFpaZhEbnN5PenPgkDNqLub0CkycFN5Mah/B5NahD
         cuWSVekKRO/lVMLAHXiI99k1FqDwf9mj+ta1AWHo0DXY7h3lx/iX6yl5l64G6KZkCKS+
         fiYA==
X-Forwarded-Encrypted: i=1; AJvYcCWln+Ak//HtbQj2PBT4KNdOGJmxDF0tfBLiFuVMur0x+LKpsftAxtbMz/jNsaId8Q8ho5gKivI/cTva5F0PHAmrWrqHTDRS
X-Gm-Message-State: AOJu0YxKfsTOyzH9NDXDMLdggOJu3FXFF8ff14yiHRuTjfQEoNBX6Xxz
	xFIewc5JV/6t2FZV4JxY7z3UfE2KNHo/cLEYbKTuYnyIYK+H9KhmC23PiYQgVw==
X-Google-Smtp-Source: AGHT+IEzcIYIV1hTiSnL4EPI23CXk8BeKzYnMBwtI8PGGd225Hl71snn2MsVWt1anzA1zrdbxElYnQ==
X-Received: by 2002:a05:6358:6f12:b0:17b:c624:b0a1 with SMTP id r18-20020a0563586f1200b0017bc624b0a1mr1060447rwn.23.1709175491359;
        Wed, 28 Feb 2024 18:58:11 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id r37-20020a632065000000b005dcc075d5edsm190825pgm.60.2024.02.28.18.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:10 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v11 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Thu, 29 Feb 2024 11:57:52 +0900
Message-ID: <20240229025759.1187910-2-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Assert that a page's refcount is elevated, i.e. that _something_ holds a
reference to the page, when KVM marks a page as accessed and/or dirty.
KVM typically doesn't hold a reference to pages that are mapped into the
guest, e.g. to allow page migration, compaction, swap, etc., and instead
relies on mmu_notifiers to react to changes in the primary MMU.

Incorrect handling of mmu_notifier events (or similar mechanisms) can
result in KVM keeping a mapping beyond the lifetime of the backing page,
i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
a freed page as accessed/dirty doesn't prevent badness as KVM usually
only does A/D updates when unmapping memory from the guest, i.e. the
assertion fires well after an underlying bug has occurred, but yelling
does help detect, triage, and debug use-after-free bugs.

Note, the assertion must use page_count(), NOT page_ref_count()!  For
hugepages, the returned struct page may be a tailpage and thus not have
its own refcount.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..c5e4bf7c48f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3204,6 +3204,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
+	/*
+	 * Assert that KVM isn't attempting to mark a freed page as Accessed or
+	 * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
+	 * (typically) doesn't pin pages that are mapped in KVM's MMU, and
+	 * instead relies on mmu_notifiers to know when a mapping needs to be
+	 * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
+	 * KVM returns from its mmu_notifier, i.e. the page should have an
+	 * elevated refcount at this point even though KVM doesn't hold a
+	 * reference of its own.
+	 */
+	if (WARN_ON_ONCE(!page_count(page)))
+		return false;
+
 	/*
 	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
 	 * touched (e.g. set dirty) except by its owner".
-- 
2.44.0.rc1.240.g4c46232300-goog

