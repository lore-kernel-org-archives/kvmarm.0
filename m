Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1E378B4E
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 12:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712060523; cv=none; b=rP9zwKSGF7zu1gvdjpOsZ2NOqwWnOsnoctzeG+dsIm4d/pPeCkYzFnsqhv7IBiDt6cEjRckT/x0lwN2VsYF/Kfe+Ebk7y0jUzhorAmDU62y8ZT7U4w38K+KFW9Jl7+LBwHsT2HVVFVK3fK8TNLszH+VQLAOEO3qEIKiKImfSOCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712060523; c=relaxed/simple;
	bh=VrR5PyMv6A70c85py5RVb9ZDuggYQPq5XLbtELzNxTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=rvetonQbvETsUU8xC28qs/iTe/DinrFuNIUpsF7+xvMxJY4/H1dIGL4D8FBKHOCWK2jycb80/hfygmgKDfPDqmzpyA746J5fwrn7jyKnKw9WKQYC2tY/afpJI5JlxxmswKXdVzdmn3YWVIY6cDp4A8h3hRZoijuVh//tNQbfk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CpFHFltr; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpFHFltr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712060518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5zAghspcnzxcTediHPEbtSmYkBJwEf7JdkrAXMAXL0=;
	b=CpFHFltrHCWJsaw0hr66r+30M+u9m1zDKH+hrXjOPFSOpEeOV6Xw+vt9ErMSxcN4aJ+X5U
	QafZZYD1jGIk+XYtaFzvr12p7SSRC1A/ZAzidzlOSk3PSsQEaza3IXqpYQ6cephq7KuAUe
	e1QkjtEd3M9zD5tx6hWwx3CCd0Ayv1k=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] arm/arm64: Use 'max' gic type
Date: Tue,  2 Apr 2024 14:21:54 +0200
Message-ID: <20240402122153.101931-5-andrew.jones@linux.dev>
In-Reply-To: <20240402122153.101931-4-andrew.jones@linux.dev>
References: <20240402122153.101931-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'max' GIC type has been supported for six years (Mar. 2018).
Ever since its introduction we've considered switching to it for the
default in the run scripts. Now, with commit 5dd20ec76ea6 ("runtime:
Update MAX_SMP probe"), we no longer always check and restrict
MAX_SMP, so we'd have better luck with configurations working by
default by finally doing the switch. Of course we also get the
benefits of testing more modern models by default and requiring less
command line modifications when converting TCG to KVM/HVF.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/run | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arm/run b/arm/run
index efdd44ce86a7..120e406fc703 100755
--- a/arm/run
+++ b/arm/run
@@ -29,13 +29,7 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
 	exit 2
 fi
 
-M='-machine virt'
-
-if [ "$ACCEL" = "kvm" ]; then
-	if $qemu $M,\? | grep -q gic-version; then
-		M+=',gic-version=host'
-	fi
-fi
+M='-machine virt,gic-version=max'
 
 if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
 	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
-- 
2.44.0

