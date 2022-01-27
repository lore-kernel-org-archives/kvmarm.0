Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35B2C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 03:09:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D60149ED2;
	Wed, 26 Jan 2022 22:09:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J2y5oLh1XuhF; Wed, 26 Jan 2022 22:09:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA6749EC5;
	Wed, 26 Jan 2022 22:09:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B44F149EC0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tCgIMqe1w4IN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 22:09:03 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CEF240BD6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:03 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 q21-20020a170902edd500b0014ae79cc6d5so784469plk.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 19:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=qQhHuHqO4mFrHPSE8WimHoA11N0d1fYrE1SY2mGY6Qc=;
 b=AeahOZQjcsgIAlBb1KD/OZ8PVPYBQ2ylDADyPOudw4Z4kXmYPJ1MrGdcSVR5uLaI67
 +LrpE7Pm7x8uzhzrkEpct9nGSwUhH+sprWnwFAVs0iZ+iUDWTgBxg+bV+qJ7FuA4I5Hl
 5TJbhQNlDMOuLzuCiQ2uWYF16f0T0pTJWe1ctXitY60ZEW6Zbj08b1baBBDl2Dgc6rnn
 l5vachi7RMN0G0V0sGLeWL+FiFK9io56q3X9SfSbF7O1Q+S4i5jk1316hGU1XPzpIIRo
 h9Zv71Ewj5zg7Mf64bT8zyYz4N1Tx/iAYF8ftqeuZgbvcjNzz473OFeBybIJKB34qsbs
 QBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=qQhHuHqO4mFrHPSE8WimHoA11N0d1fYrE1SY2mGY6Qc=;
 b=Mlxljcv6xtPZHyGvI7dfRvLQgykUEvRZrDmqVU6HdkdPWS1E8SqYB36Iph/m69F4/T
 HCKPjXV5lR8YGLMZLD66axnwLPkWVubau7Om+XqOqtCZTXa/uCrjXbTbutXj782jITC3
 KpdGFtQ/Y/jovsrYjlBAj21lRbgIJagba0PIy+f7Lojso8P7JN7873weTVWxIQqhC5FW
 bY07Qx0Pl6GkNFLLTCgq/U/WxQvdRO9Zk4nK0PjDG2kPvzdp9eXb+uAkhTq4vjuFsl1o
 TKkcQOW75q5VDHBD9OFwzkdurTkD8hL+HOAi8sjvUggFCElr3OCkl4hUP9suISHdbs2s
 v12g==
X-Gm-Message-State: AOAM533T23iJxoWkIns7cpIcJ0qzpPPXSo2IzkbmZEzQXjupKAM/y7G6
 yw8S8MLyNghpe9XVn3nJxxE3iLYA3V6QfA==
X-Google-Smtp-Source: ABdhPJwUKp1D8NergYPjzU7Dnd2HDvJg74lXmpzVjlCsIjbC/2nBeb7exjp/OrMe5BZ5inmqkLiTId0amwMHIQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:5292:: with SMTP id
 g140mr1282751pfb.55.1643252942452; Wed, 26 Jan 2022 19:09:02 -0800 (PST)
Date: Wed, 26 Jan 2022 19:08:53 -0800
Message-Id: <20220127030858.3269036-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 0/5] kvm: selftests: aarch64: some fixes for vgic_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

Reiji discovered multiple issues with the vgic_irq series [0]:
1. there's an assert that needs fixing.
2. some guest arguments are not set correctly.
3. the failure test in kvm_set_gsi_routing_irqchip_check is wrong.
4. there are lots of comments that use the wrong formatting.
5. vgic_poke_irq() could use a tighter assert check.

The first 3 issues above are critical, the last 2 would be nice to have.  I
haven't hit the failed assert (1.), but just by chance: my compiler is
initializing the respective local variable to 0. The second issue (2.) leads to
not testing one of the injection methods (irqfd). The third issue could be hit
if we tested more intids.

v1 -> v2:
- adding 3 more fixes: 2, 3, 5 above. (Reiji)
- corrected the comments in 4 above. (Andrew)
- dded drjones@ reviewed-by tag.

[0] https://lore.kernel.org/kvmarm/164072141023.1027791.3183483860602648119.b4-ty@kernel.org/

Ricardo Koller (5):
  kvm: selftests: aarch64: fix assert in gicv3_access_reg
  kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
  kvm: selftests: aarch64: fix the failure check in
    kvm_set_gsi_routing_irqchip_check
  kvm: selftests: aarch64: fix some vgic related comments
  kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()

 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 45 +++++++++++--------
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 12 ++---
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  9 ++--
 3 files changed, 38 insertions(+), 28 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
