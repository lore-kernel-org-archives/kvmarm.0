Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EF1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D6766137C
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D6766137C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5FE44B192;
	Tue, 19 Oct 2021 08:13:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ENf-vM4x6sYm; Tue, 19 Oct 2021 08:13:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8E14B0EF;
	Tue, 19 Oct 2021 08:13:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1637F4B165
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id krjKWreMaEI5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:31 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06E0C4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:31 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 75-20020adf82d1000000b00160cbb0f800so10084516wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XSGm2ZIKVrWUlcjyigReTRCR+F+26tmq3jrTuKF0cGY=;
 b=Ff2j/4N+CqKMpFaKt5pCbLJb0KMSeXSN5oHh9p1pg7HOlQUt4WVieG3ZBh7ENNwFm5
 viyVQrMK1sbcJirVOPfonTx/8M/aJhkeJ5B0u39TrugRP37ewl3yR7JqNBkgGs5haXuK
 2fi9U7qJQGDInMSacShFQe6bjTZGdOvZEJjC2u9S3JYEC9A/zFpkeAbhlKyXkFOd6lwC
 oL4KmJI4uy8trhkrcZEQPwkbiQ5Bl3dvWof9sI+QQEALuNIQmcBzTtZ0TfprSuIPENHy
 ufCkQwqZGkNRKzejuz/j5PitlWgZX9pmE79oY8xDJrop9UJlUpRgizFQwE0bT83ExOBQ
 UJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XSGm2ZIKVrWUlcjyigReTRCR+F+26tmq3jrTuKF0cGY=;
 b=piw9p5djTXuSJE5Rd2K7x2wqhiUL51r05u48z9oKz7poL/qUK7+dFIyYCWhq/F534g
 qt5OG7ecHH5xSKuLAj+JDSEKiseJcIVkXJ/mcluAIiF2JF06hUHJyH24hTsVoEV3475S
 XEx/9fKOBkdYxVgM2nHiQy75xF0X1z/EKskVXKX0YR/Ld2JnNNfZhjleEjdv9m+k9afp
 pv4Uwvco5dkixYbOB4MftNKV+OOE/fyEQKE9Gc3vpZtHgTHMAJRCb86dLLGzXAmBf2FQ
 HKG+uIH1FGhmPpGxHwSzxXFVLTMvp7Wz2n2Xu/qNDgZUDppOA+TrXLVPTUjztWFJoyU1
 ImHw==
X-Gm-Message-State: AOAM530XdjFHdvXqKVestkVi5gxpNSw8sHnKu//RHoDGbKPUiSg3yihA
 hNqkv5RpUAvJAX4QfQefAMCLo7tU8gEf
X-Google-Smtp-Source: ABdhPJwm42LEsA7dym14pML9UYuqWVeZUfAiAtE2QfcZAOVwsec8LgosKo8zwZK3COAZq6Dpj3+/8mX1AvV+
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:adf:b302:: with SMTP id
 j2mr44597972wrd.285.1634645610149; Tue, 19 Oct 2021 05:13:30 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:59 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-11-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 10/15] KVM: arm64: Introduce wrappers for host and hyp spin
 lock accessors
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

In preparation for adding additional locked sections for manipulating
page-tables at EL2, introduce some simple wrappers around the host and
hypervisor locks so that it's a bit easier to read and bit more difficult
to take the wrong lock (or even take them in the wrong order).

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 32 ++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1f0fb0780622..c111e0fcfa0a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -27,6 +27,26 @@ static struct hyp_pool host_s2_pool;
 
 const u8 pkvm_hyp_id = 1;
 
+static void host_lock_component(void)
+{
+	hyp_spin_lock(&host_kvm.lock);
+}
+
+static void host_unlock_component(void)
+{
+	hyp_spin_unlock(&host_kvm.lock);
+}
+
+static void hyp_lock_component(void)
+{
+	hyp_spin_lock(&pkvm_pgd_lock);
+}
+
+static void hyp_unlock_component(void)
+{
+	hyp_spin_unlock(&pkvm_pgd_lock);
+}
+
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	return hyp_alloc_pages(&host_s2_pool, get_order(size));
@@ -327,14 +347,14 @@ static int host_stage2_idmap(u64 addr)
 
 	prot = is_memory ? PKVM_HOST_MEM_PROT : PKVM_HOST_MMIO_PROT;
 
-	hyp_spin_lock(&host_kvm.lock);
+	host_lock_component();
 	ret = host_stage2_adjust_range(addr, &range);
 	if (ret)
 		goto unlock;
 
 	ret = host_stage2_idmap_locked(range.start, range.end - range.start, prot);
 unlock:
-	hyp_spin_unlock(&host_kvm.lock);
+	host_unlock_component();
 
 	return ret;
 }
@@ -358,8 +378,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	if (!addr_is_memory(addr))
 		return -EINVAL;
 
-	hyp_spin_lock(&host_kvm.lock);
-	hyp_spin_lock(&pkvm_pgd_lock);
+	host_lock_component();
+	hyp_lock_component();
 
 	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
 	if (ret)
@@ -421,8 +441,8 @@ int __pkvm_host_share_hyp(u64 pfn)
 	BUG_ON(ret);
 
 unlock:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-	hyp_spin_unlock(&host_kvm.lock);
+	hyp_unlock_component();
+	host_unlock_component();
 
 	return ret;
 }
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
