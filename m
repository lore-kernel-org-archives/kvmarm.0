Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B1235A3AC
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211585; cv=none; b=uA6WkCeeUWSFNmeAc428cwkgA6lpYL21jx9BuFJfzvoXmEZNlY8sByYKWFdy/3an/wM/ThOJROY62makOSixVyZ60M08tDL8Gcgo6JW4Xt/LavKaytwfhUd8SrxHlQj0BzMF31H5QRonu2A8F1zWeKdBd0DY51viJ2sIUhdGj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211585; c=relaxed/simple;
	bh=jjjbN8LqRXOhvuJhrXpzfZtaLgQA6CnzwB7pc+NYBn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBmf9xbVdynby5Rph/s7ljpsZjH29oLB734vrjJFGoBIUFakQz9EHG7G6iV5MBlWAOvZQsZhjqQlf9jJ3Nk3+OrvFEFC7V9FpAF3mkUQYcEOHaumo1yuIsuCdtkuXvEW91dHEwtZPASqFpFkjLi2EAIJhkGR1XSiZRUsU8leLBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B65714BF;
	Fri, 27 Feb 2026 08:59:36 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 756063F73B;
	Fri, 27 Feb 2026 08:59:41 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 03/17] util/update_headers: Warn about missing header files
Date: Fri, 27 Feb 2026 16:56:10 +0000
Message-ID: <20260227165624.1519865-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Warn about missing header files, rather than silently ignoring.

Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/all/aYoCiXg8pSC_bwIv@willie-the-truck/
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 8a5d3d2d..f270a574 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -40,11 +40,14 @@ done
 unset KVMTOOL_PATH
 
 copy_uapi_asm_header () {
-	local src="$LINUX_ROOT/arch/$arch/include/uapi/asm/$1"
+	local file="arch/$arch/include/uapi/asm/$1"
+	local src="$LINUX_ROOT/$file"
 
 	if [ -r "$src" ]
 	then
 		cp -- "$src" "$KVMTOOL_PATH/include/asm/"
+	else
+		echo "Warning: Unable to find $file, skipping..."
 	fi
 }
 
-- 
2.43.0

