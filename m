Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0430415F0B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 12:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760990; cv=none; b=sIYdA5cfSCcxx+DgoLRYWS5zBMAF+HX4USkZnX9n/1GZwaDG5D7vJPAzpSxo3uFo4qzP1+0XLryqCBOocCv5HfJyk/UOQ5Sa+WacFloRBg928CMs+mGwvpVK2NlRHt68NNYNb/iC5YPWe9OuI0iDszAK8BebOhBYxgU+l0qUNvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760990; c=relaxed/simple;
	bh=8eH8qSzPuak64zpqRzFkW4jtyt9rW2sXsAdwvlZWV9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b0tUZ4tAFhmlLnMsSAyafbjDIDj8NkTogYYru26hQnLq8fhvI/sS5QmtwxSbAKtWMVbQUPFMvYVJ/VJKFkyJnhj3SYlW+BW4uKBuaZ4fv0PgUpJIeXxxSie0AbVKlKkbbEvtj6RVnqjNhohN6uYBztQyCGMz75Lfo2syUZNKJv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QOJDzn5h; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QOJDzn5h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785760986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjtjOJ8VIAIzCYAs/x+lZGyja9IHYPAp3SWkrVb/Pdo=;
	b=QOJDzn5hPJpNt2zdH6Up7gBtbqVcOniEobzwgopvbrCl0RRWTXIHClvLEo2354rbjLMQwY
	ARYchshgpVDRYG1563FUdXZ4dPVdwP/rKaZexiPPHvfTrgQNPR3P3km6OipFl5UI/Ibrmm
	4ys1v8u2h5YeaPR6ma2nSZM1gwX7OCA=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 06/11] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Mon,  3 Aug 2026 13:42:15 +0100
Message-Id: <20260803124220.332248-7-fuad.tabba@linux.dev>
In-Reply-To: <20260803124220.332248-1-fuad.tabba@linux.dev>
References: <20260803124220.332248-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b21..96243c291e39d 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -34,6 +34,7 @@ $(obj)/lib-%.pi.o: OBJCOPYFLAGS += --prefix-alloc-sections=.init
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y					:= idreg-override.pi.o \
 					   map_kernel.pi.o map_range.pi.o \
-- 
2.39.5

