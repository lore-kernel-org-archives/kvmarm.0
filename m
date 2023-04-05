Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31741EC5
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 11:09:11 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75DD31684;
	Wed,  5 Apr 2023 04:09:55 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 102193F73F;
	Wed,  5 Apr 2023 04:09:09 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: will@kernel.org
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	alexandru.elisei@arm.com,
	maz@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] arm: Do not add padding alignment for hugetlbfs backed memory
Date: Wed,  5 Apr 2023 12:09:05 +0100
Message-Id: <20230405110905.669217-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The arm code tries to align the memory allocation size to 2M to potentially
make use of the transparent hugepages. But this would be problematic if we
try to allocate from the hugetlbfs, where the allocation size could be more than
2M. Given we support upto 1G, let use leave it to the user to align the
requested memory when hugetlbfs is used.

Without the patch:
 $ echo 1 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
 $ mount -t hugetlbfs -o pagesize=1G none /root/hugemem/
 $  lkvm run -m 1024 --hugetlbfs /root/hugemem/  ...
   # lkvm run -k ...  -m 1024 -c 6
   Fatal: Can't ftruncate for mem mapping size 1075838976

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/kvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index d51cc15d..9f958232 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -37,7 +37,9 @@ void kvm__init_ram(struct kvm *kvm)
 	 * 2M trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = kvm->cfg.ram_size;
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_size = kvm->ram_size;
+	if (!kvm->cfg.hugetlbfs_path)
+		kvm->arch.ram_alloc_size += SZ_2M;
 	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
 						kvm->cfg.hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
-- 
2.34.1

