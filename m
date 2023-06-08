Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C797464
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 22:06:23 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bac6a453dd5so1580005276.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 15:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686261982; x=1688853982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tdKizssFsMQJzj8/wSt0vRuPFuTT8IrX+6c5/ZqQtUU=;
        b=pYi5twzK16pe/u6UpDUsq5/gZ7VstFYaQpSoVInd6hIj+oSGhYPXPylVFxcNSuyTfw
         wCt/PuskPgVKlLP4RTlX1/zs0+7HkXHCX4XS7if1kU6ECFkPaPA6XhFNVqu9JjsX2WO/
         6WqFpH3dBOcrzKhywdtBIapeXoWXFx6aay6wJ/Qn7Ov7MwhcjCvIcth7YseBLy8rA6Ov
         3DWI59xmNFppvf7woPF6SLT4FB7lfdwPzuUsRo9pwvg0hPnS8pOlnHx7+zVUdbb0FVld
         p5m22USbLg8gn8rqzTBnF1FE/reHbyRKFfM6g+eovhC7zK7inCcLfL8yF7dcAeB22C5F
         IZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261982; x=1688853982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tdKizssFsMQJzj8/wSt0vRuPFuTT8IrX+6c5/ZqQtUU=;
        b=eqHUvPTxhYoQbMHGW0dnZ3ao6HpkWja4zTltRP0JNJiEquf8yzh05YXdq+a0NMZRJT
         Big3pDaewVSEl2ROnOZLb05NQBM3QDVwkaUU5qBAGvSI+RII0k+1xwuI884McdBWGRKH
         auHrJkLA2ddmmLh+s9RboOlGylp505SSEcTiHTes0wDywhb7FdVeHovfYGABk7Gc9Esh
         M3A/ylL7UU31DX3c5LA1g/Ci+xy3gCAwUhUqWmzWMkV7jnNbIbuB2nySlsfp+i0wveE5
         6zZtLjY45yow7R4ICYkGpW0fcW1Bdzx17YqVnoFnIlKfCDSw2ysKHjWR2XRWIjR1h/4M
         dFsA==
X-Gm-Message-State: AC+VfDzN9bHAJ6KNW5Jvu7Ns9ci9eMDYY8FZ/kCagY1OfPPHDKOMUTbV
	oJeFJQXGUSgiZHZTpDZPo4tieV2fTR4=
X-Google-Smtp-Source: ACHHUZ4KfiB8l1+dUoVGrkHr93Y38MLg1AxejqBfztTpsuysMtbSy6a+JxAixUHY2sVHAQ46IvK3wvSRaY8=
X-Received: from colette.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5cff])
 (user=ctshao job=sendgmr) by 2002:a05:6902:691:b0:ba8:1f20:ff4f with SMTP id
 i17-20020a056902069100b00ba81f20ff4fmr517992ybt.12.1686261982675; Thu, 08 Jun
 2023 15:06:22 -0700 (PDT)
Date: Thu,  8 Jun 2023 15:05:39 -0700
In-Reply-To: <20230608220558.39094-1-ctshao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230608220558.39094-1-ctshao@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230608220558.39094-2-ctshao@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Only initiate walk if page_count() > 1 in free_removed_table()
From: Chun-Tse Shao <ctshao@google.com>
To: linux-kernel@vger.kernel.org, yuzhao@google.com, oliver.upton@linux.dev
Cc: Chun-Tse Shao <ctshao@google.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Page table walk is unnecessary in free_removed_table() being called from
the stage-2 unmap path while PTEs on the table is empty. It can be
fast-pathed by only initiating a walk if page_count() > 1

Original disussion can be found in:
https://lore.kernel.org/kvmarm/ZHfWzX04GlcNngdU@linux.dev/

Suggested-by: Yu Zhao <yuzhao@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Chun-Tse Shao <ctshao@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cc1af0286755..d8e570263388 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1319,5 +1319,6 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
 		.end	= kvm_granule_size(level),
 	};
 
-	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
+	if (mm_ops->page_count(pgtable) > 1)
+		WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
 }
-- 
2.41.0.162.gfafddb0af9-goog

