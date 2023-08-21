Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED94C9E
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:51 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-68a3cae6e20so2148598b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652971; x=1693257771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TZjKmN2RwCOaKmK2FOh0/B5JVNZ5GZx+ppkHECabwV4=;
        b=Ytn1S2ChtywK+UFTQgJsDSmGueC/W1riOOQ+i/E0TNd+rxq/9sFkJufp3hCciYfUtS
         mKhC0SN5+CT/cesFvisgkOKIfcAZxRZEvFt7R6J9nQG4AAxaNLIh8u8JAC8IUfW8yJEt
         c6BoR6SRk0/RFht2Lq1/0wTviTg5WvlUpGmVKpay6Ff+XHJ3iXtpleI9+5sYC+Riv0gS
         FZ0EfRCFCEhX0pJqQjlXiEV6g02iGGeM1BMAAFfkSHPSBw+AOr3/l2nfb3A5bn9CF7OL
         1WJmEkVGBMiRaXLdalj6d/syC7V8apkmsXs0wWajN0gk+QHGnhRXYpqWIPBphvyGKDYF
         mMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652971; x=1693257771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZjKmN2RwCOaKmK2FOh0/B5JVNZ5GZx+ppkHECabwV4=;
        b=XpkLmxvS6okXWR1BAFMtfVqf0rdM4GB71GSCIbTy1fqZr0Om/3qCFEqbh8tRWB+fxQ
         q26WzgIMY/pxpl4EQ7VPigOHH8wX9YZV8n8fEBUrAGFrK31FfMpID/IYN7VZAxyM79pn
         PY1sG5jTs26w1EMOiDjiI28XMsLrrDHl3LiVsjqsSDY0fiioWsMMS5O7igT5PsL8ZWTu
         xSdfY0Nfz0XZLtRqqhNT1H9U352WF400LYwMTuKTmnjMe8/DZhGUbI2y6pANt+S93AjB
         LQX3/0T6rDUiaVtB5en+/W1dd6hOYAtYRlQlXjXpzt/s5O/qeSZQVZDOCux5db7uBfYH
         xxBw==
X-Gm-Message-State: AOJu0YyoCtHoYxvMjPMY2swuixXOM63nGwLWe6E0sdpdzVNrylb2R6IB
	PNQOOMSbK+Gi8H/+teEuEk6UYINGEH7mTpT3QQ==
X-Google-Smtp-Source: AGHT+IEcDg6B/oh1rCoCGlC92/2TOpx8G/XgwPNB4nOK1QwRTXWaoMm1LBpe2JKxMruWdz+Xn7e2Ok5ygaxUgEeMWA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2284:b0:686:df16:f887 with
 SMTP id f4-20020a056a00228400b00686df16f887mr4852466pfe.6.1692652970907; Mon,
 21 Aug 2023 14:22:50 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:34 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-3-jingzhangos@google.com>
Subject: [PATCH v9 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
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
2.42.0.rc1.204.g551eb34607-goog

