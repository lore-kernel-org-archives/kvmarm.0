Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655315;
	b=czhd4mWPsyuLRz6VzFzkoPJYrrmrlwaao9mi4VGLxpltfG6/paGZTxoOj7fa31DAtlEa
	 GsvnrbXod85ET2a59zjjDjzgKhx4Tm8Wtma7xq9lfXGQ4fJskhqXhHW5H1ehihht5iqT9
	 M62QvJfZ/RxAbfjKCh98RslwGX23oCjZqZ4dtdvEiyc8ewTN6gxTcYP2I7g5fHJNTV45o
	 mmXkR/8p+gKYpRDGkiAnToeXnZJOWTeMViUyozHykOPQ7ytRCdwW99fExaKkQ3EQfbAre
	 Bco7dm68jlcPbkgj810s2yH60WGHnNJUG69RXZCDR7d3XIWKdoB0eQcTNUv0+scioeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655315;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=J7iTRVnfrJr2JU2DzdPdjF4HGL0/oApU+EFz5weckSg=;
	b=g4kWuR5ezrXaAVSrpW6KFhb3+5sCNdwIe4QZnv0JW4cgdTi5aUz/3DU24aAxAzhkQJTw
	 NQFAPwguGQGsAn817hbfcu0yirycmnnlPcuvzOaarLLoNuNXlftUlbBQ3clUIYJEqh8cz
	 bvi7XSaqI5gipdfZ1qsNhqQmDvIgSApGyp7iLOZtNbua4heimp8G8CNu3qhz9oL0K/qgV
	 yodEQ0oJvIWQuVUnr7m+gxv7INeMuTnRILxRpKh6FiSO5wpfaumh/oxhazOQHNRcZ+SWI
	 Rk1BGARs4GysjgGn29nq/muFN6Mu7APXL15xOnW/baPSCYcjc5wrMMyEvKAgOdV+4QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="GhMev/n0";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2134606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2134606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GhMev/n0
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 662801595;
	Mon,  2 Nov 2026 13:35:11 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F02F3F871;
	Mon,  2 Nov 2026 13:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655314; bh=8erxUPpAC4HMUa/CSxOnOZSasi5glINz+cXXY6oBozM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhMev/n0MQ61gvJE00YJS0b8O3HXc8t1L3Qbx3wmHdp6jLiJJtYZM29JXz3R2Zi+t
	 7Q+YK0hI35ZXNo4XPd9vEy9psNgtMeYD1v4IFuSC7WL5B0OuXwwZrXAxtTMsqeBqfZ
	 zOeIMPhyfTFytqpMoaOBSLRc0C+oogjG1pOE+W6M=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 13/23] arm64: Assign CPU DT phandles
Date: Mon,  2 Nov 2026 21:34:03 +0000
Message-Id: <20261102213413.4136118-14-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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

Assign stable phandles to all arm64 CPU nodes. The GICv5 IRS DT node
uses them to map IAFFIDs to CPUs; they remain unreferenced for earlier
GIC models.

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 1 +
 arm64/include/kvm/fdt-arch.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 3cbd36e2..5413956d 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
 
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
 		_FDT(fdt_end_node(fdt));
 	}
 
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 8a0a460e..2b667c53 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -11,4 +11,5 @@ enum phandles {
 
 void generate_dma_region_prop(void *fdt);
 
+#define PHANDLE_CPU_BASE PHANDLES_MAX
 #endif /* ARM__FDT_H */
-- 
2.34.1

