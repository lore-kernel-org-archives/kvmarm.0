Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1AD306744;
	Wed, 13 May 2026 13:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678352; cv=none; b=eCQjHv3KJBmPZBkh9M3TsTYHj3wqe6ee7Ii4wCWsHgCbjbHlHEzowhzUUUJZnEplqLXPez7KKCtW7DYMNYdOSUt0nxy88Wx5jv+do+Qg3/vTEIYDRptkEh8e6DY0p4SFx6x4SxL6u3IqmLEXc864R9M/E4+suumBG+OitS+2QLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678352; c=relaxed/simple;
	bh=sx0iPudOyRt31pW2A4BbkZbmKOR/eNhzTqthXdGUyuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vx7M/WMVb7f1i2mWAkrMwruOswd5pzUnWS6ldMo6anb0t1SGHs6UFVLd6mWNYkFvp3/8NbBtqKP9emD9WJHrcd9kC8Ys5tKtifWbRU3gn5npqW2sJAokeDbflof34zpn+e832sNkGsM5ppA+JTvKoYeKskl+nG6G97udqsocP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=boCCdDlN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="boCCdDlN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3A7B237B;
	Wed, 13 May 2026 06:19:04 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D0A13F836;
	Wed, 13 May 2026 06:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678350; bh=sx0iPudOyRt31pW2A4BbkZbmKOR/eNhzTqthXdGUyuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boCCdDlNsLYglc9bVoTTBEiphxVWEoPHT/wZskPfKZWoo3t3cb8m8vMtM4N/So8Di
	 5kYlUvXlZTVfyT1MuwPjBsMWyeDjqBraHUXrudJa/tBj1nevq5P7nqfsSdsEAbdoQS
	 oWo8FH6ovh1zwT+VL/KNOWROwJtWPDdEqnYZHpi0=
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 09/44] arm64: RMI: Provide functions to delegate/undelegate ranges of memory
Date: Wed, 13 May 2026 14:17:17 +0100
Message-ID: <20260513131757.116630-10-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM requires memory is 'delegated' to it so that it can be used
either for a realm guest or for various tracking purposes within the RMM
(e.g. for metadata or page tables). Memory that has been delegated
cannot be accessed by the host (it will result in a Granule Protection
Fault).

Undelegation may fail if the memory is still in use by the RMM. This
shouldn't happen (Linux should ensure it has destroyed the RMM objects
before attempting to undelegate). In the event that it does happen this
points to a programming bug and the only reasonable approach is for the
physical pages to be leaked - it is up to the caller of
rmi_undelegate_range() to handle this.

Signed-off-by: Steven Price <steven.price@arm.com>
---
v14:
 * Split into separate patch and moved out of KVM
---
 arch/arm64/include/asm/rmi_cmds.h | 13 +++++++++++
 arch/arm64/kernel/rmi.c           | 36 +++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 9078a2920a7c..eb213c8e6f26 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -33,6 +33,19 @@ struct rmi_sro_state {
 } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
 	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
 
+int rmi_delegate_range(phys_addr_t phys, unsigned long size);
+int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
+
+static inline int rmi_delegate_page(phys_addr_t phys)
+{
+	return rmi_delegate_range(phys, PAGE_SIZE);
+}
+
+static inline int rmi_undelegate_page(phys_addr_t phys)
+{
+	return rmi_undelegate_range(phys, PAGE_SIZE);
+}
+
 bool rmi_is_available(void);
 
 unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
index 52a415e99500..08cef54acadb 100644
--- a/arch/arm64/kernel/rmi.c
+++ b/arch/arm64/kernel/rmi.c
@@ -12,6 +12,42 @@ static bool arm64_rmi_is_available;
 unsigned long rmm_feat_reg0;
 unsigned long rmm_feat_reg1;
 
+int rmi_delegate_range(phys_addr_t phys, unsigned long size)
+{
+	unsigned long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	while (phys < top) {
+		ret = rmi_granule_range_delegate(phys, top, &out_top);
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
+			return ret;
+	}
+
+	return ret;
+}
+
+int rmi_undelegate_range(phys_addr_t phys, unsigned long size)
+{
+	unsigned long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	WARN_ON(size == 0);
+
+	while (phys < top) {
+		ret = rmi_granule_range_undelegate(phys, top, &out_top);
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
+			return ret;
+	}
+
+	return ret;
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
-- 
2.43.0

