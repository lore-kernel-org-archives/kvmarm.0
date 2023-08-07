Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6BA11C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:18 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bc46ebab95so43745805ad.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425338; x=1692030138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvlKkKGF/kFP9AffqyFNxO/Nk3ZjRfMjltkT5eP+nnI=;
        b=yaywMyegsUVAykdodkjlqrjCgSVozCCG3p2WYuAfCvJ1RQmLkZzmt+qbDqmQHDzUJK
         7UxZAcE/TzVEVtDSSRETGTWUcRgTjRkPvRfGB0uQxpPlJyuYQc5ITAUUk9YCHRKShjoq
         WrOWqdHDFoKUYacc8pKTxYAAB/9nRCMYHvblka8Fp0OdQp0knuaFjpCO/TGJfIuceGBe
         Djp3idxnp9oKc/JhAUuRNSZDv0CWkJ1p+SnsetlZYE1IBYTqVW8x6dfx7hBEUVI2+d8h
         Hhes5lNy2UIgD8VNCi8kZiXYqqHnl7KJJD4xFD4atVxXKToc3y5Z4dI2ewVfWTed3V9V
         5Qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425338; x=1692030138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvlKkKGF/kFP9AffqyFNxO/Nk3ZjRfMjltkT5eP+nnI=;
        b=lhwadGNqDMT1DZcPko7HKeW5oe+H/NKUy6cfB2UWbrloNXaAp3vwwwFNXrE9ddSA0R
         2Kkeefp6x/C+3nYWjBh1wAcJ/xvm1ueJJVIg1sQpq9bvdF1xc0cjqcSelSSJJHsZhmQk
         dLvYxdSVqhiLRQTf7NNfks4s29NwbNQgBPq8d3IZvNNixwS7SMaJ5CI3vITZXc40gtXg
         EM+ELAR1Kg9BgEpA73jJNo5jy2jVTlCggjWOf8icHMY17dECt2zPhZMKbYryj+YXTl84
         fbrXVHeARqt7oSXoGWftDT9g1KF4EONttmAvfdI7yEppTRz5LdlyPhApeYEvqmGTiP02
         WZfA==
X-Gm-Message-State: AOJu0YztehyZhRvojI4boH5jqtjZAOtg/k4zZOZwsN9Cr+sUWhGs31Rc
	vgUt6N132psVU4bgiFwAgFx3PHaDYTwSpRfFdA==
X-Google-Smtp-Source: AGHT+IGuXkq8LTZnL60VWKI+SwwrejjgXSyjSRwPgRFDyLKb6Xmr9dv6PXaPAY+M9cQo6KA3Zecp2f5PvwBqysYNpA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e748:b0:1b3:e4f1:1b3f with
 SMTP id p8-20020a170902e74800b001b3e4f11b3fmr36931plf.2.1691425337815; Mon,
 07 Aug 2023 09:22:17 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:00 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-3-jingzhangos@google.com>
Subject: [PATCH v8 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
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

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..92a9b20f970e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: none
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u64 reserved[7];
+        };
+
+This ioctl would copy the writable masks for feature ID registers to userspace.
+The Feature ID space is defined as the System register space in AArch64 with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+To get the index in the mask array pointed by ``addr`` for a specified feature
+ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
+This allows the userspace to know upfront whether it can actually tweak the
+contents of a feature ID register or not.
+The ``reserved[7]`` is reserved for future use to add other register space. For
+feature ID registers, it should be 0, otherwise, KVM may return error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.41.0.585.gd2178a4bd4-goog

