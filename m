Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83121421D
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 23:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216124; cv=none; b=LBqVE9VV1F/MfCI9umeN9Z3K8KXVKxJcjyATLyLyHPT4hSulD4/6NyKytpCpS965lhZNh8S2iW17mUMy3U2UW9BGMGJjw9cVa7qf5IcxB8qEUw0iyerngKTw1SCPjKkbMf2esSRmYjBJ+yOFRMD57hWgJyYjwKHfzXiw/FGOz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216124; c=relaxed/simple;
	bh=q7LHAU3pa83Xococ8bg4VSFfz0h6EyFMRcLXtBvPVw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eL1QTBCa8+YnoZ/iQkVCSTFs+zk6nYF0/md5ivPh0k81ahGEFMSk08Fl5mQqlsLy7ivmApT6E2Zc9t0MSXaaFd4cCejQS+3aFBJGiKf7LYCarSv2Q9FEuVnElP1QE0dG/YGUjA0Y5ENbDKmR5TuIRcDs6/dTHST69ejPwhUEWkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pfYgaKYO; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pfYgaKYO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741216119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gheyxzAVXl8XJHo5raVO1/v9jZ3R+fvvizK8Q8N3s14=;
	b=pfYgaKYOZLOIlLneYftIpZrjoWJzWdTOWgeZwj0e0KRud++UkeyBgTcXPvOSX6wnINtwHK
	Rzr6re37K/CxnX/Ek8Khl4K8oRuiZZ+DYlNS5oD5KK4XRsWQhbA5J5bg8RqAgjGofy3OEd
	5jA9jk04O7FE7PcI0Ff9cj+G9ldKrtg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Fix documentation for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
Date: Wed,  5 Mar 2025 15:08:25 -0800
Message-Id: <20250305230825.484091-4-oliver.upton@linux.dev>
In-Reply-To: <20250305230825.484091-1-oliver.upton@linux.dev>
References: <20250305230825.484091-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The capability actually fails with EINVAL if vCPUs have already been
created.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 56f3dcdc4477..3468a2a7de6b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8264,7 +8264,7 @@ take care to differentiate between these cases.
 :Architectures: arm64
 :Target: VM
 :Parameters: None
-:Returns: 0 on success, -EBUSY if vCPUs have been created before enabling this
+:Returns: 0 on success, -EINVAL if vCPUs have been created before enabling this
           capability.
 
 This capability changes the behavior of the registers that identify a PE
-- 
2.39.5

