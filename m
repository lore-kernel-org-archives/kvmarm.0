Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF07292B54;
	Wed, 18 Mar 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849439; cv=none; b=Qmp8IS/G1O+rwqMpdda4uIvGgFFi2Mpcwa8jInJh2/mffFAODsRMtPOsGO6HHSZ/j+2bZNnAuAwjM8E6Cf0LLmy2r+nhglVgTaB5bUHAonWSVKE7l/1TfZ39J+SZWLNgq0st0aKIbTbN0341KSN0xWC8kxX4xZHzk0YvdI8fz5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849439; c=relaxed/simple;
	bh=tpMaT3H4K0K5FrDxoOJziGfY76hEdkQm1hMm34w+F+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hA8UJyEVORtQsBzHOGERqeBU/SZzNi2zqz4m/mYkznxSRdKUimbl7vMCh33G48RBznCfZpu4XX/zpLB5Tf6HKW+qdD596r3vJX6LatbVS3g5k//pCgjZO5dpnNlAG9M2zpl466JDDdup9zTB0gSLwm/geMJtFy/JQHbejpeAIjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6A0F2103;
	Wed, 18 Mar 2026 08:57:08 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAD883F73B;
	Wed, 18 Mar 2026 08:57:11 -0700 (PDT)
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 47/48] arm64: RMI: Enable realms to be created
Date: Wed, 18 Mar 2026 15:54:11 +0000
Message-ID: <20260318155413.793430-48-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the pieces are now in place, so enable kvm_rmi_is_available when the
RMM is detected.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index f69151d4235a..e76e58762f55 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1723,5 +1723,5 @@ void kvm_init_rmi(void)
 	if (rmi_init_metadata())
 		return;
 
-	/* Future patch will enable static branch kvm_rmi_is_available */
+	static_branch_enable(&kvm_rmi_is_available);
 }
-- 
2.43.0

