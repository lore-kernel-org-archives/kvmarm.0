Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6FD50F
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:45:33 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-c64521ac8d6so5151054276.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698733; x=1692290733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJAEm87EHCeOWjKJA30wa69olvlB7/s8Sl9tx5zF2lQ=;
        b=tfkUfwMnUrklnQXtS24STivSqw+iQ+fA4TFwL7HBlnVEqzpPO8wCQ0LzpDSsOXDIpq
         x1/xbW5Lhl6F4kgls2JBqjroHcaQnRMYYJLqW0gMXBA7aLWFZfF7BOvE2ePSI4YJGRyq
         tywUlFjWuB1m0rig8gPtAG6ItxfiXWgZks/sD6CDikU55wFiKZseByVkSBlcnOcVegfQ
         +i69uPR777tzcJrLjb0dFAMyV7mgl0lLfmDOUSf99DAyjF20886gF+hjgJTC1GBY8SF/
         +MkAxzuIn0PQYGkJCzAuprDebJHw1S8ISx4qq165nToNntEQ+6B/I30mZedwjS5SCiro
         8iBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698733; x=1692290733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJAEm87EHCeOWjKJA30wa69olvlB7/s8Sl9tx5zF2lQ=;
        b=aDOfSZUljexmUBfHNajkp34nbnS89P7lj+kdRtD7uOuWeYT1UjmOO60wMp+1811XmQ
         wFRToBzJcg6mgCglVfsC+fjWNP1QpJxGQbHgIl6nlHi2px2XzscAL4jtpqTf+6K4wyhf
         Rq+z8zKwu59UKrQYMbhFse2KGu6nIP0pDWtcoo+xyz6FNB96EcJTQjeN1ZtRCzE96ahW
         h/0no3GqVFOZ5f0qViXonHtLmwAgm9M3CwbJMSMotPlwUdpWkynqf6R3nBL8YvwMls/w
         2l/+YCzMVb9QTf7LZZCL/k+G+7pQLbXXLMQWQEoPo3n7495s0us81pgd/+9ZAsfokOUO
         M2AQ==
X-Gm-Message-State: ABy/qLZJJzNuXF14Ml6MTCm1R5Cj4l2dBB16BPix8X/Q7t/yROViAQaR
	+H+Y7gTPbUVc3q4zxPQ7w5yGt1eWdtKp9N5JbQ==
X-Google-Smtp-Source: APBJJlG7+TffRkqMu2lcoVZqj2J4kwXnhwITwWw6ib/WW3uqG7zZKtjT/gjSzmWi7SNVPapr4h2k9BU/V5PlgHmjwA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:9745:0:b0:ce9:4c77:bc0b with SMTP
 id h5-20020a259745000000b00ce94c77bc0bmr2571ybo.11.1689698732911; Tue, 18 Jul
 2023 09:45:32 -0700 (PDT)
Date: Tue, 18 Jul 2023 16:45:19 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-4-jingzhangos@google.com>
Subject: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from usrespace with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 053d8057ff1e..f33aec83f1b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.255.g8b1d071c50-goog

