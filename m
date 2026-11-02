Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628817;
	b=GdLZBNlVsRKDnC6JL6Sf5HnABsRFQ5M6NEkGysFYTNU+8WsvP6Va96O53E5TV1A4Oq2R
	 ar8PLnMnGUwwLeWQeL+mMmuoyFwWKa37LxwUP5hE98jlfZeN0pLclQO1+fPYxB4sxNP1Y
	 1uUhdaEX0ZacEh8kK1v7tnsRniUqaIuo5iqc2kZxsKw2jnRT18LJDmS7BQ8iZ5KDDe6GR
	 urNOcJSwjpME98AXHvvLo33WIcWKfiUXdkOZAYHVGxYr8ZQ8VaTUjaSMRcZfdsU1hg8Sp
	 me8DXVj8kS6kVttMdpR0NXEt6lmiv5YR4moG28gX2LdnD1XqnN0Nx82LBiACVt33CAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628817;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hBoCvN90n2kNl5TqLdsKoeXkUjH0fLvT8u+lK5yYPXU=;
	b=F3GiUarqCWu4fo0+KfXVOHrtfpZe8edrS034cFThdkgd7sJcpT00E8AYKpjzhOffCUZd
	 n+Ijaqb4aCWuLQAuO6z54FfassfOJl6S01MPAX/tHUc3xi72vA2jRfLSXJgN935ljpAXi
	 Ty3I3pPaioxa9XIvZCkTVKr/EV03VKn6eLbAS5BAMWm83csInHKvN2C6N5ZqsjMaf2t7F
	 6892U3H4mMnZNj9yV551rd575bZyFLg/2BV7KO43ayyKKfKcn6CAxrU51lBF6y2/aJsZL
	 WrwWs/i/q96I20j9fTlglYVFuWqm8q6swn2qf2hFYeLO0QdztYJeLN+bixjaoqnOKoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FAaV23A4;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C38606A33D;
	Mon,  2 Nov 2026 14:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3C38606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FAaV23A4
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1FBD19F0;
	Mon,  2 Nov 2026 06:13:31 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C84AD3F59E;
	Mon,  2 Nov 2026 06:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628814; bh=KoW+YqMwa9yLUI3NuylseR2UJKKrqQYGRZ3rfuc+be0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAaV23A4XLGLNycFYqUcI8RreKcQLiCbsiUq3t86DFqgQX0wNAUwgC3fzqotM+059
	 /4r+B7yhNxfJZSMUcvWfjB/nBYXe0VcZ45TFx9Qb8LGep+P9QhN2MuPwtAjizTMEC/
	 QpgkrAnhvCdP0FUv/O6Rria/9AH+PERympWtVUgQ=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 01/11] KVM: arm64: CCA: Reserve the RMM mode
Date: Mon,  2 Nov 2026 14:12:52 +0000
Message-ID: <20261102141304.126883-2-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102141304.126883-1-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
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

