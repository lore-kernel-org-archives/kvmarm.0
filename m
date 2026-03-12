Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02792E718B;
	Thu, 12 Mar 2026 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302564; cv=none; b=YCpYB0bKyXWt+NUzmzn9iQ+tuNlcVjXUaXu4WEQzFbNREknRtu97m9oPns9s6MJq4YZLMmqf4qsl7fMD2qCTWiWRMXH9l60v1X0IhpRBK0f6XxbiSYNRFliUEMo+qNDAaDK9tfZZf9FFSfdS0+CuXAGC7DnAB3ebi/DlQCxr4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302564; c=relaxed/simple;
	bh=rj2gZrREi98L5OW7DVFeQ4A3D6mJm8/gxjqIgpOv8+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SOUceDfQvq0HDCTjVM04/a4p3z+2uV9iqsE2rkrWkStYCvnEUDPxAEx149+8ePXpFuw73SQyAZid/aTHOGu8GSbp37+Al5phA5qQ8zBRbhw+R91GVnsuK+ux4duADMFrsXMW6hFqrQ1C/sugGKOUrQ4Ra31iEROOJNHiVaD1Wwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCCgYEnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCCgYEnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D1C2BCAF;
	Thu, 12 Mar 2026 08:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302564;
	bh=rj2gZrREi98L5OW7DVFeQ4A3D6mJm8/gxjqIgpOv8+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCCgYEnN4wxBqbiELTtD0Q7L1zRqUtOHaqxSGbRTDlja+it7z4nj/jPPjtfiMM8eR
	 R4DEFYXR/85OcR9uN7U+KqmlyCklYGLl7+CIIhvgKw+DCRZyk0iOSMxS8XtTPm7AiJ
	 XwCe99MN8IJpYfX2fZTrwZCxTx9huehSdWR/+aXUHcp0RyNSuYPhRfj9GU8/BhQCTV
	 ImvN2W2g717TVK8WERXJjklq/kDQImPCeUkjYPD4KnOPtbnRDmE9G+6MWgdLNWOuTT
	 IBzBQhrM/4B8Cea52U+5+vwPGLb4yvF2SEElhw5e5fND6VS5NvvNivulu4XoeFd+IY
	 IMKHWjgQHWuxA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH v3 08/10] X.509: Parse Subject Alternative Name in certificates
Date: Thu, 12 Mar 2026 13:31:27 +0530
Message-ID: <20260312080129.3483585-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
References: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
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

