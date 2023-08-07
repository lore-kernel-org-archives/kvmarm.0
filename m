Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C736311C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:27 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-564b8c529bfso2069487a12.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425347; x=1692030147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsRHDCZY2W1L20MGQ1R2mKjwnOTJ8T3owj8sO8mRlH0=;
        b=ul3/+AA3mfZTCSzCXHXqKJo+qoz6rCkjTR/ECKE9Rc5xOZKwgZ63NQYLu44YoP2btC
         peNlkHtCxfI/lHiqdULMPrppDLDhaIcckXUkJhkwN+trV71OjvS5UY55OCjc7nghCXGg
         GmgTl4SjlSvJx/lzbT4Mh990rclXx1i0mXn4L2Om+nnn86bsbcIQVkDM7X9hb9fvFgdD
         a+Moj19kZRedoANRQmjX4vEc1bqOxpWkcVvk0bmW4XFcIhmu+BFAkbY0LrOKXRjgsjc4
         E6a8X2wlVeBmMML85hq+Ugg8hnaJwd/Hu0bZJ6wJm2tM36jTW05ackjsJ41Zn6H5endJ
         +QDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425347; x=1692030147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsRHDCZY2W1L20MGQ1R2mKjwnOTJ8T3owj8sO8mRlH0=;
        b=hzxwKbxsKv/Qr2rQddDqjNPpvfx5hTuDGTkr5tQ4giO06+HJo3kO3piZxUBe9OLDcp
         GcKpiaUNjiq77yIpj/HQhY6+rH1GZocA8vf+1UIFyQ/3PSbhCWIzHBH7T+pwpn8fsgEE
         5IjnGnlEZSGqO6k5yNmywOhk9Crz2Ilsr/qSse3eE6riiRta6oMRoKeDwZOMOY+gW64t
         GMDOz+ADAcz0OjC/W6igyOx19TIryj2LfNaJ2p3/6hjVG+iFHsIiTAlYBCt0MN9S7H9T
         tLWWcAZGZZOfydCLo/v1yCFq0F3DvotOGsbKYGxfRcRh2pmzRtpNM0z0535u+Y105rgM
         au5Q==
X-Gm-Message-State: AOJu0YyuJIDOyqksGhniC4tnMQcheTHC5L7wRD1gCIrg9itK/zMGky45
	Semh/72SvtOH6Y5/LIotyTWKAWMabvlJIFKiRQ==
X-Google-Smtp-Source: AGHT+IG3XnLIiKJ/NUMDcWl6umTr9qjJJRjx5yVZZ6JF18BZmo4OJCxIDtWTWTVmYGcfj/jYasJjX0lUk38VyXqTvg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:b504:0:b0:564:9d36:f3e7 with SMTP
 id y4-20020a63b504000000b005649d36f3e7mr49888pge.0.1691425347349; Mon, 07 Aug
 2023 09:22:27 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:05 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-8-jingzhangos@google.com>
Subject: [PATCH v8 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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

All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 879004fd37e5..392613bec560 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2041,7 +2041,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.585.gd2178a4bd4-goog

