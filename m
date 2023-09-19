Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB628E24
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 17:50:28 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d84acda47aeso2880724276.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 10:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145827; x=1695750627; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNgnTGU4YpsPoVFc3PtBmlT7XDV3ZwiZBqdVlE5z4mo=;
        b=rsvIJTCwcI9qFpUoTFzPHJWEZEu5lTlN9zoFuDPtShn+cEp2VHYD8yDBe6B269GBCb
         4v6tRHjfPtkgzguV49aSZu/Prw6AFzO85yLFDhI5WSeNxfeaZiIPVXu6zzywStoE9S/C
         bzsPDVtPJUofusz3pPsmZNpDutVoB5t45woJivf0yyl+A/RlRgNjmeH5jphsYRsGp0P6
         BjHALmKU4OB7VOhS4mpEJfBAi+QjcuRWcgZO3Q/4pUDlXvSAQulhQrUS4CxhwQM5GpY7
         xSUfo1TBhFQq4gvjghMNUls38lnnzjMPxlXMu7yyFQ8siYrOtsCJ2ln+4ucSHwU2oRha
         o0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145827; x=1695750627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NNgnTGU4YpsPoVFc3PtBmlT7XDV3ZwiZBqdVlE5z4mo=;
        b=nEjQY1gDqnqQKBLJb0aaygmQoiDarKK9spe5mtrjd6GToO0zS/6vnpRE5Ixg/3KqU3
         Eo280RKUVl5IBNM9Nrr/DG5CmWefAFXkpIO9ipI3KpLQpckA+e4u3yeCTCIjL+JlruSN
         XPRxiKvYzk0Nk8/xy7DuLQAYRjB+wA1M0BHfe2aa/vkWGRhBjss8P4lv3vkHxHk89Tym
         jfNqcW9KnJHGsuaWkDpghddELtcTumjOXaJySc9AKa9PffnvjzPEbsoNxojGdmUw6YYC
         7goIi/Fr0KhwypRFX8RA825PIoYEzNb3g6CXnB/4kSqLfLs0mUA7IyM28IBhkiqyhQWD
         pLhw==
X-Gm-Message-State: AOJu0YxhnW4wsHgM9MV+cBadLvXCj8hJPuLNR1Yl3RKB9kO/HW/qiLy2
	R/Y/+LaNRqQxAvQ00+dKz66mwed7FLjO4lEWPg==
X-Google-Smtp-Source: AGHT+IEu56riQdG7TAOdvAS2CxA7zpebYty6rvbyBf23leV5Zz1VX6/KIxfw4Os8Nq3PKH1WkglynetaSy09CpEecQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:8d0d:0:b0:d84:c154:9b7d with SMTP
 id n13-20020a258d0d000000b00d84c1549b7dmr6424ybl.12.1695145827325; Tue, 19
 Sep 2023 10:50:27 -0700 (PDT)
Date: Tue, 19 Sep 2023 10:50:14 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-3-jingzhangos@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..2defb5e198ce 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6070,6 +6070,48 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+        #define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u32 range;            /* Requested range */
+                __u32 reserved[13];
+        };
+
+This ioctl copies the writable masks for Feature ID registers to userspace.
+The Feature ID space is defined as the AArch64 System register space with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+
+The mask array pointed to by ``addr`` is indexed by the macro
+``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+to know what bits can be changed for the system register described by ``op0,
+op1, crn, crm, op2``.
+
+The ``range`` field describes the requested range of registers. The valid
+ranges can be retrieved by checking the return value of
+KVM_CAP_CHECK_EXTENSION_VM for the KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+capability, which will return a bitmask of the supported ranges. Each bit
+set in the return value represents a possible value for the ``range``
+field.  At the time of writing, only bit 0 is returned set by the
+capability, meaning that only the value ``ARM64_FEATURE_ID_RANGE_IDREGS``
+is valid for ``range``.
+
+The ``reserved[13]`` array is reserved for future use and should be 0, or
+KVM may return an error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.459.ge4e396fd5e-goog

