Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8C91EB9F7
	for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391418; cv=none; b=FjZgZn6w71eWZ8ZzX3NnNEibqozFOhxYdiEx8z1s+OARVBqhn8R2E9z6tVZnjI1fqWoxM9WfRe4KFFUstxq+Dj7sv5abjXaK+xLzj5fWZyHBSVNXbGNjHACdIza0DxhtSEqBBPt4bygyxD29Vh0e9oJ0nAhKeEf1m7wxfP54KPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391418; c=relaxed/simple;
	bh=+4IglO/GI3XVPZc5VCSog3ieaKkrOLPa+81+1UtZvkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv/vQtJqhL1ij59H1kiAE0sE5gAfWhQhizU7fZ13uVUJebugClmpuP3UdX/DV3JBz0N7gv4kG9RQEQjZ83WmLk4QPCKVRW5SKruhLoGGVzA1EPSB/XuNEWRmmKb2KF6fB7otC1+leSZnk/q4O5i8e8ZKajMV/ZahQhbj7W/moZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22C0E1063;
	Mon, 20 Jan 2025 08:44:04 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D2A93F5A1;
	Mon, 20 Jan 2025 08:43:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 01/18] run_tests: Document --probe-maxsmp argument
Date: Mon, 20 Jan 2025 16:42:59 +0000
Message-ID: <20250120164316.31473-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5dd20ec76ea63 ("runtime: Update MAX_SMP probe") added the
--probe-maxmp argument, but the help message for run_tests.sh wasn't
updated. Document --probe-maxsmp.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 run_tests.sh | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 152323ffc8a2..f30b6dbd131c 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -17,14 +17,15 @@ cat <<EOF
 
 Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
 
-    -h, --help      Output this help text
-    -v, --verbose   Enables verbose mode
-    -a, --all       Run all tests, including those flagged as 'nodefault'
-                    and those guarded by errata.
-    -g, --group     Only execute tests in the given group
-    -j, --parallel  Execute tests in parallel
-    -t, --tap13     Output test results in TAP format
-    -l, --list      Only output all tests list
+    -h, --help          Output this help text
+    -v, --verbose       Enables verbose mode
+    -a, --all           Run all tests, including those flagged as 'nodefault'
+                        and those guarded by errata.
+    -g, --group         Only execute tests in the given group
+    -j, --parallel      Execute tests in parallel
+    -t, --tap13         Output test results in TAP format
+    -l, --list          Only output all tests list
+        --probe-maxsmp  Update the maximum number of VCPUs supported by host
 
 Set the environment variable QEMU=/path/to/qemu-system-ARCH to
 specify the appropriate qemu binary for ARCH-run.
-- 
2.47.1

