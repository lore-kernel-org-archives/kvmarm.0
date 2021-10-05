Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17001C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80E586120D
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 80E586120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E21204B2DF;
	Tue,  5 Oct 2021 08:20:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e9z3uRJBc8H9; Tue,  5 Oct 2021 08:20:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17FD14B2E2;
	Tue,  5 Oct 2021 08:20:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9F64B2DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:20:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TMDrf7fJI5RU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 08:20:37 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDB6E4B2A8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:20:36 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 f7-20020a5d50c7000000b0015e288741a4so5652769wrt.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 05:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=m/O1dgx/6dc/3G/WHpfSWl4EY1iI+ZyzOq/yOOojIvY=;
 b=OD7BHJzoRVq9YndsXgA6wM/uouP19YQUkJYZ8SUt7BtxMUEI+dl3vAXpdyo4nfKnWt
 Vsk3eSZrnL0Xe2Kf7qXbwwa9X56ZprMhgVUSz8+b4KMXu1kWFP2HjR5vgHXhPoy3q2uk
 X3Ii7WpVkiUK2r48b53wLkrH/4pqCMMwoVCZy/1d9SHnKai8GthwWqAm0kbbsLwMqyTZ
 L1rwzgHNArnHLbBPv0/S6y4EUzjDFknvyxBXSxWd2aNnJOK/6Th6VsFTHqsxAsWAuz5N
 4/OkIdVv/6RiRMYvlaDGJumhw+2CBQPd+nv8BstqehoOILYGz0t1fie2R4BxE5Rh3G3V
 6DuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=m/O1dgx/6dc/3G/WHpfSWl4EY1iI+ZyzOq/yOOojIvY=;
 b=N+0k3tDarYZ4N62s8uObtd2sKP9o0N/lwiOr2SzxEP97U0/HMryrg98StpZGY1RXv0
 mQPKuv3C9ALDW74EjszukVkjPnZGNEd9GbsLnCd6WJ4qizRIfmuJ/ztJgiC1Bp3jfYit
 BBabBY0iDvvXlvOgFtzNplVYEeuhjMTiktdOV6wcilsL6pekThqjEmZim1BHHOQ5Rp/5
 jZfy2xwhHzXx5l4qMaVQtqKktI2OCCFI0uPZxfQ88G1Wxn+HwgnP/vWKJPwx1tbGXwDO
 sJvjiG20Qkjb9liYK+O5bIc5+GikBmhuGd9fH/flSY3qbzMBm8hB6jRP3dYsKUsulgGH
 aIXw==
X-Gm-Message-State: AOAM531LOUfegH55Idu5TrXAaoRJfcI3KWiDMXFwKF63qkrNvvM8D+rv
 56QIZXRaldFrynnBA6Awq9NFS4AYgR7e
X-Google-Smtp-Source: ABdhPJwmuoUenb0uSWOlCBVEwk5H7f0VMu8HbnUjMB8fSNcFpLR024d7GwmK+6XLgt3zfreUU7OOwG2C8UMa
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c8bd:fb02:d32e:faa0])
 (user=qperret job=sendgmr) by 2002:a05:600c:3b26:: with SMTP id
 m38mr612627wms.0.1633436435583; Tue, 05 Oct 2021 05:20:35 -0700 (PDT)
Date: Tue,  5 Oct 2021 13:20:31 +0100
Message-Id: <20211005122031.809857-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH] KVM: arm64: Release mmap_lock when using VM_SHARED with MTE
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

VM_SHARED mappings are currently forbidden in a memslot with MTE to
prevent two VMs racing to sanitise the same page. However, this check
is performed while holding current->mm's mmap_lock, but fails to release
it. Fix this by releasing the lock when needed.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..69bd1732a299 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1529,8 +1529,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		 * when updating the PG_mte_tagged page flag, see
 		 * sanitise_mte_tags for more details.
 		 */
-		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED)
-			return -EINVAL;
+		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
+			ret = -EINVAL;
+			break;
+		}
 
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
