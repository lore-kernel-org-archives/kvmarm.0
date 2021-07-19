Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A4AC07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1667610FB
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1667610FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 967554B098;
	Mon, 19 Jul 2021 06:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aR9LkENLElLD; Mon, 19 Jul 2021 06:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 775F34A3A3;
	Mon, 19 Jul 2021 06:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5260C4B096
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pzPLVMjUmxKo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:56 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA11F4B0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:55 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 o21-20020a05600c4fd5b029023448cbd285so4626506wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4jouoD7WbUci7xn3YtWW0XHxA5H2d8wOqC0fOlAh9f8=;
 b=Uv/xPNZZd0zvHFvxq2GpDnhKRoZfKfkYeT7JrfEvu+elD14GHfRJV2UfPlcuLH0Nv9
 xGP4lSDAuHT744H30Nr3FuQqtA7zcfsuBVg1gpqjrcW0+SAKgbz3XsLytXwgeRD38gsy
 5U18heYUtdx1QOOER3ojuOyNMtIncmDBZRxyoXBEp12SJ5nq8mYIRIOoWUAxkLpxFWf/
 0MCRFOXhNv1Q4vAH+jiL5e8tyam8wKhtdPh0pvlTNUJuICxDUt4OlVPGpz2JloawDALr
 robsnCnc2EuFshx4qttMo42h1bgE0+RRFB1TJsGSde7AB8wG/OeSkfs/zeHYYE7cARWQ
 ybpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4jouoD7WbUci7xn3YtWW0XHxA5H2d8wOqC0fOlAh9f8=;
 b=jho+gz3A3b8I7X0lfiRHBP5xeoa01oen5IbryoFyAc1iI8CmRz2LfkV27aL15EzVXs
 7VbpFrF2JxmT3uvMcksDnkAbKNGDPojyaF91VX96qW9tlwXrDpM6crD/1YY6Q+o+OPFf
 HN+aTFXXYF9kT6SqbqlFHPhcWUr+Soi/O6Ukh/O5fYf3Pc2oWpxAjo0Uv24Z4glb4kZp
 V6oLZWqvIE3KRrppRFlYJ2d9+qDHWXYuW2wtnKlbXMOmDgIuavvvhFOBqWXN0K4P/Cmn
 Mac8elwcZeBJbdPaqOtQXOoG3ONLx2J1hlWmSL6ZmrRVYo5QHKhNMVSgvT/8hAgm39D8
 zDmQ==
X-Gm-Message-State: AOAM532CagYOSv+q4Qluaoms0IiXwf9LE55sfb4QW9zgE9Yd3h7p9vJf
 sKNoV6Xib/pmXm4a1Ie+H3fSgjvGJmjO
X-Google-Smtp-Source: ABdhPJy/15n8M0Ndba/dPTUyDBcKgkjR9P3nSTL+iqL9mRoICMhdiGix+x/jfDLh68tcSqBfBCw3QGLbUiX4
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a1c:1bd0:: with SMTP id
 b199mr25225892wmb.108.1626691674895; Mon, 19 Jul 2021 03:47:54 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:27 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-7-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 06/14] KVM: arm64: Tolerate re-creating hyp mappings to set
 ignored bits
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The current hypervisor stage-1 mapping code doesn't allow changing an
existing valid mapping. Relax this condition by allowing changes that
only target ignored bits, as that will soon be needed to annotate shared
pages.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a0ac8c2bc174..34cf67997a82 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -362,6 +362,17 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	return 0;
 }
 
+static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
+{
+	if (old == new)
+		return false;
+
+	if (!kvm_pte_valid(old))
+		return true;
+
+	return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_IGNORED);
+}
+
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
@@ -371,9 +382,12 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	/* Tolerate KVM recreating the exact same mapping */
+	/*
+	 * Tolerate KVM recreating the exact same mapping, or changing ignored
+	 * bits.
+	 */
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (old != new && !WARN_ON(kvm_pte_valid(old)))
+	if (hyp_pte_needs_update(old, new))
 		smp_store_release(ptep, new);
 
 	data->phys += granule;
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
