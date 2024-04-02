Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB2B84FD5
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064475; cv=none; b=YatAlfErGmm61PlfZAUONE1EayfW560L2jJVoijGLIPhIMDjDNLglKv7gioot9cBlXZ3NiolpfZastQjJYzeAMZqP7eQNAOQWjljyXVOQcNIcQg41Km0HHUChpGf7yYbkORfoaOqykZBiOx7K4RJI8ou7FA5A5Vw5rFLJ6qilRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064475; c=relaxed/simple;
	bh=qO+1kZ9z+wiqLzzL6/wv/zlJxuZvbU2fKRhakiTfi+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jhlWFZh35dm8CHTjgUecNzedRoYqWCNNuQA3mJBV9ljxr+RwS2kg9SBtCATFxk3bPnm6pGzRbWxVUW5nXUyoEwVn1HSFD7bSED6Qb5HomsJzaDvwKBGa75XFiPMv92bFnmVKWDRFytXVgS3MWstViIXzi56z4NeEDtlnLMXIaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q3tp+RPN; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q3tp+RPN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712064472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hAI/rR5u7QPYMiby7bfEdez/iaHCDgvC0CWKgnQup0M=;
	b=Q3tp+RPNb/eVx8zNShHx0YBFk3ydGS9fvfiKVJaLjerVbB4YuVUSk1b5FdLw3i4mIW6WUY
	6UosgmaGxPuLWfmU62flsBGOwXW1vhnhfESQ6UAwhfDWHb5yVh1JIIrEfswgYYy1g/sZWC
	AKFMdROPG7eJb6WOySQupwGpKgW2Lv0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/3] arm64: Use 'max' cpu type
Date: Tue,  2 Apr 2024 15:27:43 +0200
Message-ID: <20240402132739.201939-8-andrew.jones@linux.dev>
In-Reply-To: <20240402132739.201939-5-andrew.jones@linux.dev>
References: <20240402132739.201939-5-andrew.jones@linux.dev>
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
default in the run scripts in order to test more modern models by
default. Let's finally do it!

(HVF's support for '-cpu max' is younger (only 2 years), but that
should also be old enough.)

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 49f047cb2d7d..078271822b10 100755
--- a/configure
+++ b/configure
@@ -273,7 +273,7 @@ fi
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
-    processor="cortex-a57"
+    processor="max"
 elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi
-- 
2.44.0

