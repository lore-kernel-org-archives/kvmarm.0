Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D131D1EF0B7
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991684; cv=none; b=BfbWJL3XR4zpPcMek3fJnLwHrE0s46hK15hYEfbWKa8edkDPgc/R0+CHmOPOt96EQAvgBWaCdUXLqm9Zjb/CngPxhHauLYsFFiglVWJr7lnbEEs9+CrW8+xTef7rfOxXCeG3zjg427uwsrI0NmoJf3L+Ojq3hBQiI46n97FnRFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991684; c=relaxed/simple;
	bh=PI3qpl/Os+oDiKonnhdp5LSgH4uy+R7Wr6DL0QZM0kg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZpZr39mneq7zemFdVRvHUsME6ZWb4WHHPzF65kJ+enIjyMD+8uXLZmfih0+wuUyRBsUF/qeQlFImJp0sR4moY6EkpbJgCj2QlzzHd9nj00ywuEgshDW/ChDZm+o+fnA/+YAYAd2fvS/FdFsNuNynwHRqa4oxosKleQk/NHS7/ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hyxCfitb; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hyxCfitb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8ht/DCn7aPa+Qq2t7+UlM5jrTFYFcOoFzFNyBPpZzM=;
	b=hyxCfitby4M6F14nzoyGMnbi19xMaH68kRxIMQ4Xn5lSOKekANDqh4dMoiIbAVQOnPQaYP
	C8Te820LUFmwOajdWNTiXnHHdbW5Ofy+ovEfgRXeqT6+LB3/0a1ODCjsDwkxc0Pkfw6XR0
	6ZquAjSk2MhLrp8lu0zgwicQu70vfqQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 6/9] arm64: Move remaining kvm/* headers
Date: Fri, 14 Mar 2025 15:25:13 -0700
Message-Id: <20250314222516.1302429-7-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the remaining kvm/* headers into the top-level ARM include path.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/fdt-arch.h         | 6 ------
 arm/{aarch64 => }/include/kvm/barrier.h    | 0
 arm/include/{arm-common => kvm}/fdt-arch.h | 0
 3 files changed, 6 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 rename arm/{aarch64 => }/include/kvm/barrier.h (100%)
 rename arm/include/{arm-common => kvm}/fdt-arch.h (100%)

diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
diff --git a/arm/aarch64/include/kvm/barrier.h b/arm/include/kvm/barrier.h
similarity index 100%
rename from arm/aarch64/include/kvm/barrier.h
rename to arm/include/kvm/barrier.h
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/arm-common/fdt-arch.h
rename to arm/include/kvm/fdt-arch.h
-- 
2.39.5

