Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7930E2046A9
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641985; cv=none; b=gIwuoqC3YvQ6yO0wxWYCzqEHuGguPcKBi/Pzzz2ekwtIv9E9JHInCdKHIxNjTop7WpQU/OvQOULwMvtlBkm7H+awlgQYvaNDl7lrbRUct9Hhm9WFtqxn7QvJ1tjHKjxk4AIr3Mspt8dRqTw6enewVnumYHHtnsQIZFGhtu7sqeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641985; c=relaxed/simple;
	bh=g599v1Dcqt9/YyHI5c+otr8SMBzkW7z85VopKOyuj3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJAvmDcGtkhFqdBrQfy5th76XAzzZ3kAYKcMh8AV93mvR8+uOYPwinS8k+1r1uHvw1LoZRnM4jCYphNAVVtUfIulxK7Gncfwaufsy+5IpUwZ8SHMYDOrwXvRtaF4SOoZbobFOIkfu0OaccCBIDDr0wYQVPCLG6LB54LeDnlC9no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R+WNHkJS; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R+WNHkJS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751641980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5RM3fpQJZXdHe1/0rYAD9Peic3dkiF/gyGbQFCCa/4=;
	b=R+WNHkJSXCrelO4rIytF8Z1YLvjTGlqMZXSIDvORoUjQXB0dzUARrf/YmM2qvOQ/hXBwIS
	bBIrKFP47oJZaRs/7IEhs8PuNwRTol1vy/LK93zJzFsLPNiPVNa9HcYO6o9s80p1usZQkr
	87KwiLiOSSNn+NsvWk6vckJ8NTsFuEk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	cleger@rivosinc.com,
	jesse@rivosinc.com,
	jamestiotio@gmail.com,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch with kvmtool
Date: Fri,  4 Jul 2025 17:12:56 +0200
Message-ID: <20250704151254.100351-5-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-4-andrew.jones@linux.dev>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running on non-arm (e.g. an x86 machine) if the framework is
configured to use kvmtool then, unlike with QEMU, it can't work.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/run b/arm/run
index 9ee795ae424c..858333fce465 100755
--- a/arm/run
+++ b/arm/run
@@ -97,6 +97,11 @@ function arch_run_kvmtool()
 {
 	local command
 
+	if [ "$HOST" != "arm" ] && [ "$HOST" != "aarch64" ]; then
+		echo "kvmtool requires KVM but the host ('$HOST') is not arm" >&2
+		exit 2
+	fi
+
 	kvmtool=$(search_kvmtool_binary) ||
 		exit $?
 
-- 
2.49.0

