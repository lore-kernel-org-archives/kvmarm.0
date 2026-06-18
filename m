Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D752EEE80
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797845; cv=none; b=JfBtepa8RW+RoFjok3tHjcoepoTfhHujCCUCpDJebGONJ6k2FApuMurnF1eIZBEljs0JyEsZfrNuDuRoA7xqTAsTC4/j3IgYQBO54WVqI9kyoyZ36ykQgqYzs9yLTAkx7lNWk41+cxE5GIBS0gGlb0RIQazVrd57YZuiu5umoMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797845; c=relaxed/simple;
	bh=/zyz2Ae5rAcClg+aAQGrZgMkoO3w/Xao/6VaZhVCYVM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl6fuLJvIBB5bRN3wxeD/6pk+HLGQHewDm+xUoorVLfi5fw12s92TtDlpl2tTbty4jo1YNljTtlB2BuidpSPyJOpd23WF+d24jFHlLLXwAzVdbbKIO1Wqr8QORzOM7FQuLroSf+5fEv2Ec9ufl8+t6vzUdskMb0a6Q1CskS4WH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ty96Gmil; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ty96Gmil"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06835491B;
	Thu, 18 Jun 2026 08:50:39 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C9A53F62B;
	Thu, 18 Jun 2026 08:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797843; bh=/zyz2Ae5rAcClg+aAQGrZgMkoO3w/Xao/6VaZhVCYVM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ty96Gmil5oiGGyziC4lQ4mxBklPq7aVRtpNkvnLewIiG1gyvhLM90URKjxhdY20gV
	 eDbKlMfEZMC33YWM5NLTdLw3k70wekBrmIW/5sRbxR+Q8GptMnUHsUKecNZUTI2Suw
	 riZkwcl4IXLMv5MuwP28h8AHL6RTx0D24bYLQ/5s=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 5/7] util: Set exit status to errno in die_perror()
Date: Thu, 18 Jun 2026 16:49:59 +0100
Message-ID: <20260618155001.226266-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exit with a return code equal to errno in die_perror() to make it easier
for the user to get the error code directly.

As per man 3 perror, errno is undefined after a successful library call, so
save it when entering die_perror().

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 util/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/util/util.c b/util/util.c
index bab4bb394111..fc732200f2dc 100644
--- a/util/util.c
+++ b/util/util.c
@@ -100,8 +100,10 @@ void __pr_debug(const char *debug, ...)
 
 void die_perror(const char *s)
 {
+	int e = errno;
+
 	perror(s);
-	exit(1);
+	exit(e);
 }
 
 void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
-- 
2.54.0

