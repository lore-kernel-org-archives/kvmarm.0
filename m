Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDC714AB4
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:41 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-577323ba3d5so85247697b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017081; x=1691609081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gk6Eirn5+X3nUAq9ec4RcBoQ+OOnriAJ9kIWX3vd7n8=;
        b=6yhBmxLd54UFd+7UosOkhtC1yZtaJfyjSwqd7QsKub+w3plBkYJTIb2IwzdzmkGe9E
         zH1XAU69YBWsEi5v7PyiygVcwUsdmGeK59qRWNhKjpzXIKEsOrhG3b5C7sPPVdLLYVUJ
         lN7g4rJ3TvJ5eSiSmAD1EW4z465s7oSkNbUVgYJV8Hn1luXbmbEOXqHl7Rc1bVoBXFAU
         cTFv8j1wxQNdGHcs3hr/h610kcTu/4zXd9JE3swftGBnSa2XpF1I1hVY61slterq39+A
         Ncf4P7nnr5DHH6ishg6E7ywNjAN0/RaiFLUxivulGmCjXmNAEnqwTPBSa0YA/PFJ32bT
         0+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017081; x=1691609081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gk6Eirn5+X3nUAq9ec4RcBoQ+OOnriAJ9kIWX3vd7n8=;
        b=LQbZ5pFV5igSPe+aQ0k1o1i4/QsaATWhxgF66ph6B833ekOyTvdmFwFy/ZWexYmJQ4
         BjYUm/7DOsygPUmcvIJEDdDo7gUAewb24dUSsRYVgk8xsdrJfBibdQrap+Xu6D65CvXx
         /ZzzSXPWh6LBGvA5Zw8K6Jgc4i9yGfesq8/y5eA7yUPfKI5TaWc6xOLcWAm92G4Sc5O5
         vEqBLoS1+FQjuB4A/5arthSktah4YlwDDuPn33sJKGUBdgAonZuy/xaP9KIJXWZWxGui
         s4lJ95oLeIs9XuzzfAnNLoF4Q7H/g36So+2bxTITb7UiJuP7at9ezR1YW3Pj6BL73XCh
         g4yw==
X-Gm-Message-State: ABy/qLb7qGBLHw7RN06mUAIvrZ2wmmPy7nc78Zu6Pjm9A6G7SltSeFgH
	nop59VY/xwsL0Y6BNZYHneRv06XyLZepe3ZHGw==
X-Google-Smtp-Source: APBJJlEyAOiilEAjTAf9LR5RX+k+0UPGMjGR8SkJvffevoDae5RhTEQQuHeKVSmDE6ilWmcPmE/Te8Fp11JLgQ9htQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a5b:88:0:b0:c2c:1b68:99b0 with SMTP id
 b8-20020a5b0088000000b00c2c1b6899b0mr173883ybp.5.1689017081007; Mon, 10 Jul
 2023 12:24:41 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:27 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-5-jingzhangos@google.com>
Subject: [PATCH v5 4/6] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
index c44504038ae9..967ecd57a86a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2026,7 +2026,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.255.g8b1d071c50-goog

