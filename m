Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB71459AC9
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842685; cv=none; b=QP0ZrgHHhDpPXpVTts8ogPwhvKR+a/tKRUUXVeX1yyveTqvdnpMDea5Yq1MAXSIXP3untdLWWy6flC+rYwbMP9O+5RMLfGe0SS2dJ8oQy4qt6VS42uvBR8XRTBZmzzSl/E8u1aPhedCO1JS5UIL/fqMSNyM5d23+CvyI5anZi4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842685; c=relaxed/simple;
	bh=8eH8qSzPuak64zpqRzFkW4jtyt9rW2sXsAdwvlZWV9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rwhfmRnBB5yPP73ZQvgyw2IWEd5Q3usawZmwCq1HnxVnEaYho3DYAuUBcZE77OrMZaxU7l0nXAVlyj/iQ/KTAJUT5cZHlcys7dK+xuJfhZl5Ob3B6rQ7roa/eLac4jPyDdZl1yRzooCnDvYzBT3c6JrxQWUYjjXpu9hupnl+UNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IvH9at4j; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IvH9at4j"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjtjOJ8VIAIzCYAs/x+lZGyja9IHYPAp3SWkrVb/Pdo=;
	b=IvH9at4jNKFDDVGrY64mS8X0NM2b7CHGTxAS3Kpe41eas0F5M2QeGajOUfoE+KdKSnDQJm
	GhSre/EaCgJeNzKeb1G1NhTY65YDGMUyvhsx7fawQHw0G1hkoyhx+1pPOIGpj5cjaCSbsE
	KvJFaYKiXqnO4JJURECUyYtGgGD4BWg=
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
Subject: [PATCH v3 06/11] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Tue,  4 Aug 2026 12:23:12 +0100
Message-Id: <20260804112317.1937387-7-fuad.tabba@linux.dev>
In-Reply-To: <20260804112317.1937387-1-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
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

