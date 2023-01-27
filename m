Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981D928F0;
	Fri, 27 Jan 2023 11:41:00 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D1C71764;
	Fri, 27 Jan 2023 03:41:42 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9B35E3F64C;
	Fri, 27 Jan 2023 03:40:57 -0800 (PST)
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
Subject: [RFC kvmtool 25/31] arm64: realm: Double the IPA space
Date: Fri, 27 Jan 2023 11:39:26 +0000
Message-Id: <20230127113932.166089-26-suzuki.poulose@arm.com>
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

The Realm's IPA space is divided into 2 halves. Protected
(lower half) and Unprotected (upper half). KVM implements
aliasing of the IPA, where the unprotected IPA is alias of
the corresponding protected ipa. Thus we must double the
IPA space required for a given VM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index fca1410b..344c568b 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -189,6 +189,9 @@ int kvm__get_vm_type(struct kvm *kvm)
 	/* Otherwise, compute the minimal required IPA size */
 	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
 	ipa_bits = max(32, fls_long(max_ipa));
+	/* Realm needs double the IPA space */
+	if (kvm->cfg.arch.is_realm)
+		ipa_bits++;
 	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
 		 max_ipa, ipa_bits, max_ipa_bits);
 
-- 
2.34.1

