Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945D86FE24
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712060524; cv=none; b=n6+9USRm6ymtwwk9xvg0VWRzJ3XwrA2HXsBDwcP7+VAYEjFFtUvQHg5UlQ638/0HqN8Y+y093tpTpvslHmwOQIdKSzp4NWSNld+rbZ/M+PUVc4rR11MTMpcx5tuyP+EcyAqHbhIcgMkkC/nxDUI7hTUsJ/IAH8epgq6+qKarZZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712060524; c=relaxed/simple;
	bh=qO+1kZ9z+wiqLzzL6/wv/zlJxuZvbU2fKRhakiTfi+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ewua/qkuXxyVZm7QSBLyxVHlu4syRuKCBWeMqwskEHM9cI05F0uLjRsw6MCiZelt8nYHXeHiY7tDt00thalLBYzN7BFWZEITZiTBDdFcqUZrRk9CxMVwoWKG0yfV90CBPtLRXB+tAlJ89/YNL4KGQFooCdZrILiSXCzDhbRpAok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CJvWgEZW; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CJvWgEZW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712060520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hAI/rR5u7QPYMiby7bfEdez/iaHCDgvC0CWKgnQup0M=;
	b=CJvWgEZWgFF6UEwAxOj18AxnAp366dTiiu3I555I/kLcCrKSlnQ+A6Xl2VfEpe0LTXVpPs
	OfMeJyKpwF2yYtrH8be6x2XEB1VtRdwoEkxO5lJDBy4NHUSO76oADLIHvNrPFTSALZfmuf
	aA9UbTq4ac5EDbxIRTNpqd48BIuojmA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] arm64: Use 'max' cpu type
Date: Tue,  2 Apr 2024 14:21:55 +0200
Message-ID: <20240402122153.101931-6-andrew.jones@linux.dev>
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

