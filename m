Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9E382D76
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703507; cv=none; b=S9L1jKMPVsb/bgvU5EWoAZ0/YiGZjE9HMa7nSQeyK2d3Ligu4BKJv87rtpi2rORWzmLLgHyYTwYQIpERNoOQNVAuJask4mG1J/K06nrU02X0Mbtax9ZbBVaMiCxgnS9WaS/IM94HzdKiAhBXmi1+XGhtgjwzSGuxgkO8Fe652Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703507; c=relaxed/simple;
	bh=3LDznxWjy7yNqKOljjbACMiXY3NHVbc6pQf9X3Yw9ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=aF7Gcfs7fGExv/iUvuGylzpHFA2+2xgJ/8j9GuwJJgrSx47lBHDFYuBo5ssP4yIFep9H+8dPaTgGEJL7bx4xvqqu4x0NCqqFHzTMPVs6EhRuTK7K9UvChiS2I8zqq2djefBCRE8rpaCaahRP56AejhybyRbhvsue+nctcd98mck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jdTzvQZL; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jdTzvQZL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YaaM1tdWXQy3CMwa8iTfOjIIZAX3H3bey75zFrrIGnE=;
	b=jdTzvQZL2aBcYeJMW+XQ1w6zw9n5fmgJ6tavu/N6OUR8cad1nn+PTkLS+6CHXO2r8/Knz3
	sj7VjSijuMNBWvWFU/5XfmTJIp6/E0UDiiWhJMvKn+JlE/2ccR/ijRh0+aLIDhWzQGhdEZ
	dh98w05A1/GBboR8ppzWSWC1BgDOmGI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 02/14] runtime: Add yet another 'no kernel' error message
Date: Fri, 23 Feb 2024 16:51:28 +0100
Message-ID: <20240223155125.368512-18-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When booting an Arm machine with the -bios command line option we
get yet another error message from QEMU when using _NO_FILE_4Uhere_
to probe command line support. Add it to the check in
premature_failure()

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f2e43bb1ed60..255e756f2cb2 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -18,7 +18,7 @@ premature_failure()
     local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
+        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.43.0

