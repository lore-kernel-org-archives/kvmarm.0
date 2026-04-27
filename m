Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1513815E7;
	Mon, 27 Apr 2026 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272730; cv=none; b=YijK4CIcE/9utkyx5AiZJmPVAQIPfpS8iXn1oKqA00rLTWhLiYy14ZMFzPoewD2HdIQhVsvG3kYQteU3ekUluM5iytJC6iNGZZ8Z6qMBPSJAnQESuL9kgjc7MCTEGJooja38wn0ho2Sxj0pANlI1pC67Vg5kEg/hrPy/cYc5RQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272730; c=relaxed/simple;
	bh=rj2gZrREi98L5OW7DVFeQ4A3D6mJm8/gxjqIgpOv8+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTJ1a6HezkBhgl1zGgTs824x/UDHCLGAHFav4ZGCCwlkzIt0JCggtRmU9O0Ck0WSMIThEjK7B/9RqJlSZhoA8eS8Y4zGbRTmvouhfdC7/0yZh+Zl8dSCJkjE5mrpGxZCa5OHbYSUC0/xz6cvQlqOyBSxOcYDlczzjKTCmzB2u1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFJUaGtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFJUaGtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462D8C2BCF4;
	Mon, 27 Apr 2026 06:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272730;
	bh=rj2gZrREi98L5OW7DVFeQ4A3D6mJm8/gxjqIgpOv8+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFJUaGtkSDKRTJn0s95vHYtgPBOZQJp+FgE/V8/RpViupAsg2NyZBF4GqZd1U3upp
	 bfjr2M1p2y7Me0vmTz+wIWxBaQf6EbaOLrESfg7MB3EL3kY7c4dXG2Irb2HGi6wj5u
	 Od512jDVj0LAbOKIebViKfGL+seKnzHgzha6ObdQnsNMdwVkS8vPv4XBCXehV/wI3I
	 KkhePzLOVbLq4Rv9gcShzwhF1rsnUDhBQXSZu8X6C29Dt2bP6PV5RgRFdTANPVXMpQ
	 uvPopa6fTBjNGwJZqyv2eTfWWAkOUg0MQDbgK5+AZ3Zf/Epk2TjZVIWXs2tkjs/s3L
	 862inefcNPsjw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [RFC PATCH v4 06/14] X.509: Parse Subject Alternative Name in certificates
Date: Mon, 27 Apr 2026 12:21:13 +0530
Message-ID: <20260427065121.916615-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

The upcoming support for PCI device authentication with CMA-SPDM
(PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
in X.509 certificates.

Store a pointer to the Subject Alternative Name upon parsing for
consumption by CMA-SPDM.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 9 +++++++++
 include/keys/x509-parser.h                | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 37e4fb9da106..d81b7de4236c 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -596,6 +596,15 @@ int x509_process_extension(void *context, size_t hdrlen,
 		return 0;
 	}
 
+	if (ctx->last_oid == OID_subjectAltName) {
+		if (ctx->cert->raw_san)
+			return -EBADMSG;
+
+		ctx->cert->raw_san = v;
+		ctx->cert->raw_san_size = vlen;
+		return 0;
+	}
+
 	if (ctx->last_oid == OID_keyUsage) {
 		/*
 		 * Get hold of the keyUsage bit string
diff --git a/include/keys/x509-parser.h b/include/keys/x509-parser.h
index 8b68e720693a..4e6a05a8c7a6 100644
--- a/include/keys/x509-parser.h
+++ b/include/keys/x509-parser.h
@@ -38,6 +38,8 @@ struct x509_certificate {
 	unsigned	raw_subject_size;
 	unsigned	raw_skid_size;
 	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
+	const void	*raw_san;		/* Raw subjectAltName in ASN.1 */
+	unsigned	raw_san_size;
 	unsigned	index;
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
-- 
2.43.0

