Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CFF4E1DC
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060991; cv=none; b=XHdeJH4CwzGa1ZLut/wwvjz05dKUPaNKa7ojrXcZ1w0yHV+hVNvbaEiLsPITR4L0qcuyOXJjdwv5qG5McdQWxsfE5sP7ia5FO9vi9yYV5NACWJi6hDViELwLGIWWC3U2wR1qux9F7Dhg4GuoA9vjcpB15t2BSiRoZffF39y0oI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060991; c=relaxed/simple;
	bh=V2LfPPDIN8jhFO9fYE4GxCvODU1jzhUhZnlTIR4lEl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=ZJek4CTCBofx6TNSRUXBXI6rBKSlYbJRAvEwKh2KxBSRhw4MtC4XIiiDyCUoC1yD+CRYPSItJmoao+4JXIy5RNfpL8ZEUyZDt8JCSp4Cv3lXmOjsBVGUyrK06UlfbL8rnw6HvpjNUgOe9mKTD+c4AC2gQNr6hC0Lz+qVnrswzro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UW+2nQ/B; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UW+2nQ/B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709060985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O6PxlOSkjfmUE3MlUaRdlCKQgaiQQVwcoA25G6phrfg=;
	b=UW+2nQ/BKWmWN1KAwy/cjjcKerysEXgcM9w5MePjnUgzZsKHr0qIprjnTgE+8V2IfRydoG
	q9QVnLRM3u/3HMcjRc1F6FkQqWRFcVCarNO9EqXx1m4QSC686Omf1BgfqFhWhyX0UQqxKV
	N2RbjPz/v3BK46Da/saf0fhUBRNxKOs=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH] arm64: Improve unhandled exception traces
Date: Tue, 27 Feb 2024 20:09:36 +0100
Message-ID: <20240227190935.486566-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Put the stack trace at the bottom, rather than mixing it with
register dumps, and also start the trace from the current PC.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 5bcad679605e..06fd7cfcc548 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -130,9 +130,9 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 	printf("Vector: %d (%s)\n", v, vector_names[v]);
 	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
 	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
-	dump_stack();
 	printf("Exception frame registers:\n");
 	show_regs(regs);
+	dump_frame_stack((void *)regs->pc, (void *)regs->regs[29]);
 	abort();
 }
 
-- 
2.43.0

