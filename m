Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409096;
	b=Fc8i6iFEmSXLCYAaLtzgR3GUMMJyRiwbg08N65SEkmyjPIG7eExojZ/h+s6W/dfw8RmS
	 mKVYNMWr5oIIvDeKQSITSCK/IbIabcogP36385DCgXTPouIP7QkTPxE0kb3ZyoNg67b30
	 wCNXpZ0c4RNnGOKIVXUfyz0Nkmt4Pz8CEdwSkzKzcbJjuCROx3cDwFTdX75QbdmYEwoIy
	 GjPqSO+Cs7R15KXI71tXktQocjAdgMB051JTfKRTXekTJkBsguvGCp30HfuqHS/RZMKW+
	 Mx9h1jYex0/ZBKr92sfHiZwrtCW4PhIsB4lNkvxJP/hxDzZf4m96H2guHIhD0tCxGCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409096;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hBoCvN90n2kNl5TqLdsKoeXkUjH0fLvT8u+lK5yYPXU=;
	b=3dWL+hxhCHMW3v21P8GmdT2azVYOJp344T+WrarS13PvvoTO89q0HMAoodEHVltP9T16
	 kj2qN/Qb6kdzw12SNIwqZSSonWgj+KweLPbNcHyLUvCU+4Nkuv5mYHjXwfwKLNqym8NnC
	 yccPx2hwGGRYASD2mhLioxJMa6cO5TuxNcX5x4nKX7+G8D1WsciVepXgHe+HMwUd/euhR
	 SiBExFaCeRigqV6H8P5ArdqGXDETSXtzVuY0QrnmprCvWqkfJc17j43zQpC3gUK66f+lc
	 lRRDXt+UlGBnd2d6PF3SnCWMZH9rkbbcGq1Y4YtTLAYkoLE08jPxuugNYEtJL1zAubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vCD5faBV;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2E060A380E;
	Wed, 11 Nov 2026 14:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F2E060A380E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vCD5faBV
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACC2B1682;
	Wed, 11 Nov 2026 06:58:12 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EFA83F632;
	Wed, 11 Nov 2026 06:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409095; bh=KoW+YqMwa9yLUI3NuylseR2UJKKrqQYGRZ3rfuc+be0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCD5faBVxOIGqS7zM/P/uLODjhlfhhQbsFUtbFmskhhIGTcprcoBRyJrA8ukaD13k
	 6/GAUz+inn/h4nmR+jwIESOChtZ6K7W5JA8Dqdq73JrDpEL/bsGbvtruBaE3qOGoLz
	 B7x673PVAnpaAWq5SpsQakjk82s91MXW+MYavL/o=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v2 01/12] KVM: arm64: CCA: Reserve the RMM mode
Date: Wed, 11 Nov 2026 14:57:45 +0000
Message-ID: <20261111145758.217946-2-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reserve KVM_MODE_RMM for CCA realm support. The kernel parameter that
selects this mode will be added when the Linux CCA implementation is
ready.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb130..ccd2dc8f73c3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -120,6 +120,7 @@ enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
 	KVM_MODE_NV,
+	KVM_MODE_RMM,
 	KVM_MODE_NONE,
 };
 #ifdef CONFIG_KVM
-- 
2.43.0

