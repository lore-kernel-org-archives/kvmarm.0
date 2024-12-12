Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A89323EA9C;
	Thu, 12 Dec 2024 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019125; cv=none; b=ZF+4UYYqKr9LJcfM3rWOSXcmt8blaRXolSzvk4xz6ZYFDIpUphhEDde4lqSN4oR6ATyNyYYOPILUMNJtYGMZ6Pn+9nm8z0SntJFYTWvHOHSB5Q5COltNm+wgdrX5D97nXFmsfRTbRRHIz2qvgew/Kqis31RuqmJ7sqbsEQOMcsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019125; c=relaxed/simple;
	bh=Lfr/17Q3X61HdKmSNl+WMkAzqoigndRCKXXkn435SPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm95a2DllornuStFWkDcVixqXJOV4KHE7XAB7EYcWEwfiVJ7grG8xj4L+zbxDvSl+rCgXuMFk2NppiS3joNcBYC134fLoKW7BgtY4f0dJUOZ/oJeWbFUen2J4HkZlf93DbUXHRgWjw96Qp+TocMniUyZ7T3dmX1hw4+O88hsZKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0814F1762;
	Thu, 12 Dec 2024 07:59:12 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.39.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B23ED3F720;
	Thu, 12 Dec 2024 07:58:40 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v6 33/43] kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
Date: Thu, 12 Dec 2024 15:55:58 +0000
Message-ID: <20241212155610.76522-34-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241212155610.76522-1-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For protected memory read only isn't supported. While it may be possible
to support read only for unprotected memory, this isn't supported at the
present time.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ae3596a25272..b6f63ab33354 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -377,7 +377,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
@@ -391,6 +390,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
 		break;
+	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = !kvm_is_realm(kvm);
 		break;
-- 
2.43.0

