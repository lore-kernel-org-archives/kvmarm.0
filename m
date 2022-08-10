Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3104C3F6B0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 19:31:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64EDE4DA71;
	Wed, 10 Aug 2022 15:31:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ix9y0gzMt90N; Wed, 10 Aug 2022 15:31:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A2A4DA7C;
	Wed, 10 Aug 2022 15:31:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 736EC4DA63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0VO6nM-K9-Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 15:30:57 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A71F44DA70
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:56 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 ng1-20020a17090b1a8100b001f4f9f69d48so1599618pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 12:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=4ClZUMx8TnkVPiWPppNyKCT9yBDdrvfugyfW4aVoXbY=;
 b=eth5rcymjcTo6VYe4CYLR2cfYrhUHSgDwphDXVe5M9W77uVjamZK3zEQPkOaz8MeS4
 v18WcYItKk9ZR7udLSpcf89ncUrsRl8E52JO0GZ6cpgSHrfsX2fYCvuid4bHHF8HPf6M
 VsybieO28xH93+w4aUORM8rnRRWfPK8qg4uhN+vSJcDmX/KTUojSyVAaty4iu025crUn
 vhfdnOeVpgVQ0zQfeT5i0V29ivvaM60SPNcLfBkYjlU1gOQKl/2a8hwlEyB9SnHFD9wY
 ljJ/GYwGbhbF9yHI2U65mevgovogtg33yQx8TLgb2O2HkI/g6wZ4HGrZlviH543LdqlE
 x1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=4ClZUMx8TnkVPiWPppNyKCT9yBDdrvfugyfW4aVoXbY=;
 b=LyO/WdzA6EtqAAHG7Bavambkt10mdTo0dxtBNEsf1iA8Jys8XTn/QQ60nXddjNNdRC
 W4Zj3t7i+2TOX9psQymDjbsKnhUaqDzukvQhrsxTHYTMSkp6bq+Jt1W5Dkqta/i/w39l
 2THl/7SQ/bDpnri14+85INSz4pPfW7/c/JHqrO10Gx5efulxaR0JbK5/VCTL0z/zTM+8
 sgfJJzdeZ46Zk0f3VlGSPu16ac5PWwudyjE6bH1CCQOOPbs+4jMV+3W3DSiAdXXZlaBE
 LTd0BDLA9KXjInSiNBKi8YqQ0D3cRWIjaRAKm0FvqDw9VYXYP/+b+0X/J8EaMo5EHhSO
 mQwA==
X-Gm-Message-State: ACgBeo0dEl2l3aUcS30s0zLO64if5jSg4Djg2SgRsLMORAToQiPnNcXa
 3rOdUBuqPmK5UkIkV7lRIp0yS2c=
X-Google-Smtp-Source: AA6agR5ruBssTN91JyZyYKhtoX72CT7taSbOJaMPbA/aSzLBfq1S0116heTn2cGcPhGw5MM6Pcu1B5w=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a17:90a:fe10:b0:1f3:1de7:fe1b with SMTP id
 ck16-20020a17090afe1000b001f31de7fe1bmr5057895pjb.189.1660159855775; Wed, 10
 Aug 2022 12:30:55 -0700 (PDT)
Date: Wed, 10 Aug 2022 12:30:33 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-8-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 7/7] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9788b19f9ff7..30e0c35828ef 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7486,8 +7486,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
