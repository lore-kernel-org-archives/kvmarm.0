Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAE958211;
	Fri, 12 Apr 2024 10:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918116; cv=none; b=MsE0GKw87cTKzWyxTGHqVN5C2IddNSNlI119dp/pLb6XnhycCThex+GlbrOiZHYU+eWESHLp4OdvHzjW7sV2qfW09FGgDTMoHAnfCdTvCOtcY3cLiPsMbewoIFplaYFqUha5vCDJEpFyyLDptouu1bdcv5hgPn4PmGIYYLxS3AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918116; c=relaxed/simple;
	bh=qZBSMbMq8moFVkOkhTLUWb6wgcf/qtqL0nJ6qF8s7sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gNO2u/mDk8BY0ADkhWj3YKzv1tEfPaBgqa5ngBs/BibijfGVZz8dSMGswM4JaX6jmhAD6EaHAGjiDloB9itccH82vNYvpFhh+L1eXT5ApvDGIp0766JsGB9QnlunAuoiXFgOzGlAkFi9XcdQK62Wv9Uj12X5Lb7MzxhvE9msRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BE161596;
	Fri, 12 Apr 2024 03:35:44 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9E7BA3F7C5;
	Fri, 12 Apr 2024 03:35:13 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 28/33] arm: realm: Add helpers to decode RSI return codes
Date: Fri, 12 Apr 2024 11:34:03 +0100
Message-Id: <20240412103408.2706058-29-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM encodes error code and index in the result of an operation.
Add helpers to decode this information for use with the attestation
tests.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm64/asm/rsi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index 2566c000..c7d65333 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -16,6 +16,39 @@
 
 extern bool rsi_present;
 
+/*
+ * Logical representation of return code returned by RMM commands.
+ * Each failure mode of a given command should return a unique return code, so
+ * that the caller can use it to unambiguously identify the failure mode.  To
+ * avoid having a very large list of enumerated values, the return code is
+ * composed of a status which identifies the category of the error (for example,
+ * an address was misaligned), and an index which disambiguates between multiple
+ * similar failure modes (for example, a command may take multiple addresses as
+ * its input; the index identifies _which_ of them was misaligned.)
+ */
+typedef unsigned int status_t;
+typedef struct {
+	status_t status;
+	unsigned int index;
+} return_code_t;
+
+/*
+ * Convenience function for creating a return_code_t.
+ */
+static inline return_code_t make_return_code(unsigned int status,
+					     unsigned int index)
+{
+	return (return_code_t) {status, index};
+}
+
+/*
+ * Unpacks a return code.
+ */
+static inline return_code_t unpack_return_code(unsigned long error_code)
+{
+	return make_return_code(error_code & 0xff, error_code >> 8);
+}
+
 void arm_rsi_init(void);
 
 int rsi_invoke(unsigned int function_id, unsigned long arg0,
-- 
2.34.1

