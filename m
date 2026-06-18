Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C879261B8D
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797840; cv=none; b=JA1byfbhWhFchz51EqFEpzE+UfJhIHN2AbnBf3s87m9zP+pwkIl9qEVczmgJi8djMkdEesHR+rZx0v6/LS8tz845C26PG9SecyUCBQvU+QTV7aoz6gVPMX6KZHMjXPwnsLDZfD2JjKnrEc1N6sqCD7T0O3CG1K3sJCTZH9x0a1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797840; c=relaxed/simple;
	bh=9hNsmJq6SLjzU6jtsTuH9b/BZQBolGiCo+qZXnf3dHU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KA1UlSeNgvaRrU+/Yr8xEIdCEBQV+52I8gIhUhvnOUt6oHW8A0MZRryO8hcbuTsrg62XUBXzsvnAIeGgPAFcPnfmsbjo2AhlRS22RtbeDoJOLeG4jI8eqFsNGuDUeAwkVCXljCt49mMrt+Q3fEHeST+XC+deQCW7+uE9JquaCP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tvc9do6p; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tvc9do6p"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 046F8491B;
	Thu, 18 Jun 2026 08:50:34 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 438273F632;
	Thu, 18 Jun 2026 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797838; bh=9hNsmJq6SLjzU6jtsTuH9b/BZQBolGiCo+qZXnf3dHU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tvc9do6pypNzDaQ/d3CWrhaHBerWBrVheTMP9Oh9NNBY9ry8wx80xKIskcH6NS/6v
	 XHHls9scM0j73vDxv5ntApe5R3R7aks1Y+0fP90wtIUdkhfJqrFprMs19fUOm3187/
	 AaZvDFyWNpIfVeZKvh9v3OKo3mOe4ir/uLiMwxts=
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
Subject: [PATCH kvmtool v2 2/7] virtio: Do not modify const strings in virtio_9p_rootdir_parser()
Date: Thu, 18 Jun 2026 16:49:56 +0100
Message-ID: <20260618155001.226266-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Even though @arg is of type const char *, virtio_9p_rootdir_parser()
modifies it it if a tag name is specified, leading to the following
compilation error on an x86_64 machine with gcc 15.2.1:

virtio/9p.c:1503:18: error: assignment discards ‘const’ qualifier from pointer target type [-Werror=discarded-qualifiers]
 1503 |         tag_name = strstr(arg, ",");

Fix it by copying @arg to a local string, which can then be modified
in-place.

Also use die_perror() if realpath() fails, to provide more information to
the user.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/9p.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/virtio/9p.c b/virtio/9p.c
index e6f669c49895..cf3e547d3173 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1491,25 +1491,32 @@ struct virtio_ops p9_dev_virtio_ops = {
 
 int virtio_9p_rootdir_parser(const struct option *opt, const char *arg, int unset)
 {
-	char *tag_name;
-	char tmp[PATH_MAX];
 	struct kvm *kvm = opt->ptr;
+	char *tag_name, *copy;
+	char path[PATH_MAX];
 
+	copy = strdup(arg);
+	if (!copy)
+		die_perror("strdup");
 	/*
 	 * 9p dir can be of the form dirname,tag_name or
 	 * just dirname. In the later case we use the
 	 * default tag name
 	 */
-	tag_name = strstr(arg, ",");
+	tag_name = strstr(copy, ",");
 	if (tag_name) {
 		*tag_name = '\0';
 		tag_name++;
 	}
-	if (realpath(arg, tmp)) {
-		if (virtio_9p__register(kvm, tmp, tag_name) < 0)
+	if (realpath(copy, path)) {
+		if (virtio_9p__register(kvm, path, tag_name) < 0)
 			die("Unable to initialize virtio 9p");
-	} else
-		die("Failed resolving 9p path");
+	} else {
+		die_perror("Failed resolving 9p path");
+	}
+
+	free(copy);
+
 	return 0;
 }
 
-- 
2.54.0

