Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DBE28F2;
	Fri, 27 Jan 2023 11:39:57 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68AA515DB;
	Fri, 27 Jan 2023 03:40:39 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D6A303F64C;
	Fri, 27 Jan 2023 03:39:54 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: suzuki.poulose@arm.com,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-coco@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 03/31] hw: cfi flash: Handle errors in memory transitions
Date: Fri, 27 Jan 2023 11:39:04 +0000
Message-Id: <20230127113932.166089-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle failures in creating the memory maps and back in
transitioning the CFI flash. e.g., with MTE enabled, CFI
flash emulation breaks with the map operation, silently.
And we later hit unhandled aborts in the guest.

To avoid such issues, let us make sure we catch the error
and handle it right at source.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 hw/cfi_flash.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
index 7faecdfb..bce546bc 100644
--- a/hw/cfi_flash.c
+++ b/hw/cfi_flash.c
@@ -455,6 +455,8 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
 				KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
 	if (!ret)
 		sfdev->is_mapped = true;
+	else
+		die("CFI Flash: ERROR: Unable to map memory: %d\n", ret);
 
 	return ret;
 }
@@ -472,6 +474,8 @@ static int unmap_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
 
 	if (!ret)
 		sfdev->is_mapped = false;
+	else
+		die("CFI Flash: Failed to unmap Flash %d", ret);
 
 	return ret;
 }
-- 
2.34.1

