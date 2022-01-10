Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46051C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 21:05:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A49924B128;
	Mon, 10 Jan 2022 16:05:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EcE8Bh63jDT1; Mon, 10 Jan 2022 16:05:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 786314B0A0;
	Mon, 10 Jan 2022 16:05:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCDAF4AC78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3dbdEQvKgP5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 16:05:01 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89E774A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:01 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 h33-20020a17090a29a400b001b20b7d48dfso12619641pjd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 13:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=+xkRNMzVKx3F4hTR2l9g6o1SV8RhdwtP8RMHusp+l7I=;
 b=AObAmtEyHI45ZgrB8Sj5Vu/ApzZfmOyQrtz0JmHqEM+XVtql8Mce6sxfPzUFewx95j
 SVqr+Gx+rtiErYtoFnWTzE69nChhEnDCvBFfCFW3o9CH9fGyG2EkEd5bMH3lm6g7XMlF
 65CP3UWa69wvK8jcOIps51wgCFjCGF0MM8S+ZSypXFPElAP+UTHV9SVn7TQ6n6Hwf571
 sgWL+dja0LYE2vRjYXVuinAksGkVh51pmOMmYrRagW296S2/Uac7HWd+TLFp86RueZlL
 X1O2Eh5SvxVKbLla9fHSshbwAaZf4GQg+9+io5DLbFON2PovFfsJ+YQdt92H4Yc6I9ff
 gOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=+xkRNMzVKx3F4hTR2l9g6o1SV8RhdwtP8RMHusp+l7I=;
 b=u6wrztLunBVnADLhkELfKNlfBUh38oYpfPdN2qGmfyxucVeqYHGd9O30Tagimb7339
 alsxW3qlYu3eQVFq3Qxk/hGdy4k6Ei2fl3ppYUnDiglQEZsSelOGUqRpbyYs3yMzfKmU
 cv238DnUPfdY1XntYAC3AF+LrtGhgUIZuXWCwkAw2VTNxDDecEOSVsX+jDZ9uGVRtOyh
 24ia0a2gNwhtbSwsM6sFK9J5d6jFFSg+QktGf9C3Ch6Bfvb9y85/0We6AZIuWf4tx/ay
 F+YnpVhdc5I9qdYOQD0dJ7cyCenbULkREi3WCPuo0x7Nr+k85Jn9RjzBCjaI9MM7Dq7Z
 TUqA==
X-Gm-Message-State: AOAM531P3/nEW4TKYv1EMkwFlE/QLbljJOeMf6RlN2DKFsbcrg44XCB5
 bdedP9gcJxIzEPI+yPWt/pg8IqMt0AkLPGX2Tg==
X-Google-Smtp-Source: ABdhPJxFRBmAmMe8jbeKGOEfOoHdKhddL97+ETMNT3AS9KzLOLyz8L2oKIa72v6dA1IYiIHelR8O7CThuAuNx91M8g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:7c8f:b0:149:9a8a:f941 with
 SMTP id y15-20020a1709027c8f00b001499a8af941mr1294901pll.148.1641848700626;
 Mon, 10 Jan 2022 13:05:00 -0800 (PST)
Date: Mon, 10 Jan 2022 21:04:38 +0000
Message-Id: <20220110210441.2074798-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>
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

This patch is to reduce the performance degradation of guest workload during
dirty logging on ARM64. A fast path is added to handle permission relaxation
during dirty logging. The MMU lock is replaced with rwlock, by which all
permision relaxations on leaf pte can be performed under the read lock. This
greatly reduces the MMU lock contention during dirty logging. With this
solution, the source guest workload performance degradation can be improved
by more than 60%.

Problem:
  * A Google internal live migration test shows that the source guest workload
  performance has >99% degradation for about 105 seconds, >50% degradation
  for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
  This shows that most of the time, the guest workload degradtion is above
  99%, which obviously needs some improvement compared to the test result
  on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
  * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
  * VM spec: #vCPU: 48, #Mem/vCPU: 4GB

Analysis:
  * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
    the number of contentions of MMU lock and the "dirty memory time" on
    various VM spec.
    By using test command
    ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
    Below are the results:
    +-------+------------------------+-----------------------+
    | #vCPU | dirty memory time (ms) | number of contentions |
    +-------+------------------------+-----------------------+
    | 1     | 926                    | 0                     |
    +-------+------------------------+-----------------------+
    | 2     | 1189                   | 4732558               |
    +-------+------------------------+-----------------------+
    | 4     | 2503                   | 11527185              |
    +-------+------------------------+-----------------------+
    | 8     | 5069                   | 24881677              |
    +-------+------------------------+-----------------------+
    | 16    | 10340                  | 50347956              |
    +-------+------------------------+-----------------------+
    | 32    | 20351                  | 100605720             |
    +-------+------------------------+-----------------------+
    | 64    | 40994                  | 201442478             |
    +-------+------------------------+-----------------------+

  * From the test results above, the "dirty memory time" and the number of
    MMU lock contention scale with the number of vCPUs. That means all the
    dirty memory operations from all vCPU threads have been serialized by
    the MMU lock. Further analysis also shows that the permission relaxation
    during dirty logging is where vCPU threads get serialized.

Solution:
  * On ARM64, there is no mechanism as PML (Page Modification Logging) and
    the dirty-bit solution for dirty logging is much complicated compared to
    the write-protection solution. The straight way to reduce the guest
    performance degradation is to enhance the concurrency for the permission
    fault path during dirty logging.
  * In this patch, we only put leaf PTE permission relaxation for dirty
    logging under read lock, all others would go under write lock.
    Below are the results based on the solution:
    +-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 803                    |
    +-------+------------------------+
    | 2     | 843                    |
    +-------+------------------------+
    | 4     | 942                    |
    +-------+------------------------+
    | 8     | 1458                   |
    +-------+------------------------+
    | 16    | 2853                   |
    +-------+------------------------+
    | 32    | 5886                   |
    +-------+------------------------+
    | 64    | 12190                  |
    +-------+------------------------+
    All "dirty memory time" have been reduced by more than 60% when the
    number of vCPU grows.
    
---

Jing Zhang (3):
  KVM: arm64: Use read/write spin lock for MMU protection
  KVM: arm64: Add fast path to handle permission relaxation during dirty
    logging
  KVM: selftests: Add vgic initialization for dirty log perf test for
    ARM

 arch/arm64/include/asm/kvm_host.h             |  2 +
 arch/arm64/kvm/mmu.c                          | 86 +++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       | 10 +++
 3 files changed, 80 insertions(+), 18 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
