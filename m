Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ADA3E48B
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 23:04:23 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696374261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/UrZnLuF+ZbxfpRS+fSnVui/k86GriMGDer7kkeJmIs=;
	b=TQLUxO+RzzcAwaXhMQ067a1wfoP8qX/6Vkn+9MUssqQtXE81PQL19Z4BY0r69kqO2XAV2M
	o+vZSarHkiZ9RPFmz42JQSucmphuGgBWrLcxpB2Vv10vwfUSuCC8jsoxDX2LknReUWabL/
	hvV23PAGCvTgQKpA8WgOVczYuKlxpTY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 02/12] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
Date: Tue,  3 Oct 2023 23:03:58 +0000
Message-ID: <20231003230408.3405722-3-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jing Zhang <jingzhangos@google.com>

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..d55c2b68c0a9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6070,6 +6070,54 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define KVM_ARM_FEATURE_ID_RANGE	0
+        #define KVM_ARM_FEATURE_ID_RANGE_SIZE	(3 * 8 * 8)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u32 range;            /* Requested range */
+                __u32 reserved[13];
+        };
+
+This ioctl copies the writable masks for a selected range of registers to
+userspace.
+
+The ``addr`` field is a pointer to the destination array where KVM copies
+the writable masks.
+
+The ``range`` field indicates the requested range of registers.
+``KVM_CHECK_EXTENSION`` for the ``KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES``
+capability returns the supported ranges, expressed as a set of flags. Each
+flag's bit index represents a possible value for the ``range`` field.
+All other values are reserved for future use and KVM may return an error.
+
+The ``reserved[13]`` array is reserved for future use and should be 0, or
+KVM may return an error.
+
+KVM_ARM_FEATURE_ID_RANGE (0)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The Feature ID range is defined as the AArch64 System register space with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+
+The mask returned array pointed to by ``addr`` is indexed by the macro
+``ARM64_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+to know what fields can be changed for the system register described by
+``op0, op1, crn, crm, op2``. KVM rejects ID register values that describe a
+superset of the features supported by the system.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.609.gbb76f46606-goog

