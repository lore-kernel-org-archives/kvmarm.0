Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F371F28F2;
	Fri, 27 Jan 2023 11:39:54 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86EAB15BF;
	Fri, 27 Jan 2023 03:40:36 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F3FB23F64C;
	Fri, 27 Jan 2023 03:39:51 -0800 (PST)
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
Subject: [RFC kvmtool 02/31] script: update_headers: Ignore missing architectures
Date: Fri, 27 Jan 2023 11:39:03 +0000
Message-Id: <20230127113932.166089-3-suzuki.poulose@arm.com>
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

Ignore missing architectures for header updates, for use with
older kernels.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 789e2a42..bdfb798c 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -48,6 +48,7 @@ copy_optional_arch () {
 
 for arch in arm64 mips powerpc riscv x86
 do
+	[ -f $LINUX_ROOT/arch/${arch} ] || continue;
 	case "$arch" in
 		arm64)	KVMTOOL_PATH=arm/aarch64
 			copy_optional_arch asm/sve_context.h ;;
-- 
2.34.1

