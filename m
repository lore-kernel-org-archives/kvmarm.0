Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD195731A;
	Fri, 12 Apr 2024 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918108; cv=none; b=hMyQXalrf79wpr4lg3QfdIsKdv9d6sT1Ujv4qClxxPLwDKlB0JqjgY+vYMMlw6U/73DhU94maPC+UNb9F9ZtYWvsiKJYIBF7x9miU8+hpXXMpMIiwG8yLr5GrQIFj93zCOA3rk2rnWFD6bpcvv6DBNAYJY3svVFQGo2w0Gw/nqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918108; c=relaxed/simple;
	bh=ZheC5MOSBPb4CaH/kNwmJlPy2a+2jizBfnsVzBfyc7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdUJuUl00avPwVSnVnAaRqpXKps8KCM2OyIMA1vmFzTy3M2QV4+3oEmIZzol+laY3DUUc3Fs3D8owidAkfwKe2LOlxzSP1urn9whyI+uZs8+bHAzc7G89/NDB9RYgVEWKA8qSJbHYiiJSlCiyKt6HmPHp09IUYzddiIvLyiNICc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B25C113E;
	Fri, 12 Apr 2024 03:35:36 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7BDB53F64C;
	Fri, 12 Apr 2024 03:35:05 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 24/33] qcbor: Add QCBOR as a submodule
Date: Fri, 12 Apr 2024 11:33:59 +0100
Message-Id: <20240412103408.2706058-25-suzuki.poulose@arm.com>
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

Adds the library QCBOR as submodule. This will be later used
for arm64 realm attestation token parsing. The repository is
available at:

	https://github.com/laurencelundblade/QCBOR tag v1.0

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 .gitmodules | 3 +++
 lib/qcbor   | 1 +
 2 files changed, 4 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 lib/qcbor

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 00000000..29fdbc5d
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,3 @@
+[submodule "lib/qcbor"]
+	path = lib/qcbor
+	url = https://github.com/laurencelundblade/QCBOR.git
diff --git a/lib/qcbor b/lib/qcbor
new file mode 160000
index 00000000..56b17bf9
--- /dev/null
+++ b/lib/qcbor
@@ -0,0 +1 @@
+Subproject commit 56b17bf9f74096774944bcac0829adcd887d391e
-- 
2.34.1

