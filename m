Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185E746C
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270DC433EF;
	Thu, 16 Feb 2023 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557889;
	bh=QqKWnxVCmWjaRHHpFhF9lvt+Kt1/5o5W5NIuE4VWNwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBVBIVKxfN+otxuDh6tjITGWlD2qZDMmlePf2P+zsLwLtBZNJml2UZXr9wo/KzhfD
	 +DLAftqcKO6kMhOlxQELU7as2b7dfitiOvkVwlY10gpOBFJFZPHS6sIuU6AE+V5RYt
	 pVv+G9Sk34MHxhtlqfNthRXYV6d+lnZRLOkQyZVzprLW7rYrfV2Rd4E4UezXAA04FW
	 W1uo3lEp0Hh/Qbo3JiraAVfgDlNBoRfdUwUUjgHwIjgpYxS+DJDtlE7RIVJZDW/Gz0
	 5j+AQZjL6T7Ch/3llwQjP97zZBhI8X3ThnLoq5JGtoCH9cyU9OoK1yt9IcWC5DUA7y
	 vqMnS8MLWR9Iw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8v-00AuwB-OE;
	Thu, 16 Feb 2023 14:21:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	dwmw2@infradead.org
Subject: [PATCH 11/16] KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
Date: Thu, 16 Feb 2023 14:21:18 +0000
Message-Id: <20230216142123.2638675-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add some basic documentation on the effects of KVM_ARM_SET_CNT_OFFSETS.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0a67cb738013..bdd361fd90f4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5937,6 +5937,53 @@ delivery must be provided via the "reg_aen" struct.
 The "pad" and "reserved" fields may be used for future extensions and should be
 set to 0s by userspace.
 
+4.138 KVM_ARM_SET_CNT_OFFSETS
+-----------------------------
+
+:Capability: KVM_CAP_COUNTER_OFFSETS
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_counter_offsets (in)
+:Returns: 0 on success, <0 on error
+
+This capability indicates that userspace is able to apply a set of
+VM-wide offsets to the virtual and physical counters as viewed by the
+guest using the KVM_ARM_SET_CNT_OFFSETS ioctl and the following data
+structure:
+
+	struct kvm_arm_counter_offsets {
+		__u64 virtual_offset;
+		__u64 physical_offset;
+
+	#define KVM_COUNTER_SET_VOFFSET_FLAG   (1UL << 0)
+	#define KVM_COUNTER_SET_POFFSET_FLAG   (1UL << 1)
+
+		__u64 flags;
+		__u64 reserved;
+	};
+
+Each of the two offsets describe a number of counter cycles that are
+subtracted from the corresponding counter (similar to the effects of
+the CNTVOFF_EL2 and CNTPOFF_EL2 system registers). For each offset
+that userspace wishes to change, it must set the corresponding flag in
+the "flag" field. These values always apply to all vcpus (already
+created or created after this ioctl) in this VM.
+
+It is userspace's responsibility to compute the offsets based, for
+example, on previous values of the guest counters.
+
+With nested virtualisation, the virtual offset as no effect on the
+execution of the guest, and the nested hypervisor is responsible for
+the offset that is presented to its own guests.
+
+Any flag value that isn't described here, or any value other than 0
+for the "reserved" field may result in an error being returned.
+
+Note that using this ioctl results in KVM ignoring subsequent
+userspace writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the
+SET_ONE_REG interface. No error will be returned, but the resulting
+offset will not be applied.
+
 5. The kvm_run structure
 ========================
 
-- 
2.34.1

