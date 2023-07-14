Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA513706
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 12:53:00 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689339178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bga3UyoBQrEb6aa9iKg780hSHkYu2az027j0ImcIWKw=;
	b=EsHBvqRJR7VIExJoTF2BIjKD13mKG+UTXGFE1DQuU/jy4bFfjBHwSgq1rc/avQFDSZIEzd
	3+lViTYbJw+VW5tLXuP+uzNvqnX1yt/lAOijAW63Xul4y8rSNLxOd7Gn/8mUdSHlOrviFX
	kyxds+uoxGp8GqDCWmAexniCJPojviI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH] arm/arm64: MAINTAINERS: Add reviewers
Date: Fri, 14 Jul 2023 14:52:58 +0200
Message-ID: <20230714125257.333242-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I've recruited some review help!

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe2c8418faf2..958735fbfd79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -76,6 +76,8 @@ Architecture Specific Code:
 
 ARM
 M: Andrew Jones <andrew.jones@linux.dev>
+R: Alexandru Elisei <alexandru.elisei@arm.com>
+R: Eric Auger <eric.auger@redhat.com>
 S: Supported
 L: kvmarm@lists.linux.dev
 F: arm/
-- 
2.41.0

