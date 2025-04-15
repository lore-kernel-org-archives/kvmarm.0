Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C222DFA24
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 04:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744691108; cv=none; b=Fm55VTY3JfbzFKM3CS4aTS9vjhva9BjEYtp8gMKQ+uhIENOUYu7FH+qiOmVBI/ZnvEdmW468MXC9vr5fvAO1janw8Gyn56w5WZJwMcj/SAARwcTlV767B8QsA4Z6rLboKvyMb2lhkHOqrWQD8/DRWttzcSIrpjK7CnCjiy+NV8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744691108; c=relaxed/simple;
	bh=JsNXqqSwMw4cbXBnHCpVE3NAfyDEwYeigxTufXIfXRY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=GjJcn60DWdSp4yTXEHvC2egW34qjr0kZFwlMc2ujpnlPNcvFXChcfMYFEteHWqyAbmB55lcItWslU3Z6IOHd5WLpKHhp7b6wmZYviIMh6WBY/QFivlO4h6nPFIUj8GQuvvoPFz2cKn8/HK5HGVLR/3g84mNlJl8vXFno2VOV7ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kS5SD9ZP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kS5SD9ZP"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250415042503epoutp03dc0b550783a9821f6711a44db36b8a03~2Y1Cj7Fd60059200592epoutp038
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 04:25:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250415042503epoutp03dc0b550783a9821f6711a44db36b8a03~2Y1Cj7Fd60059200592epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744691103;
	bh=hB3jACYTzSD2o23SD0z+VuvGY7L3pnS0a/THqiSfDrs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=kS5SD9ZPgh0gkMMQUS2D/oN21G9Voy/pUJycx1omc0UxQI4rXoHO+oxCEjZfPsVJ0
	 O9kwyuGHO3fuo51vRm94nTvthnjjOh4fGd2aOna9EcVLOBmR6dl+KhqehMmdOnZt6Q
	 r2Cs17+VxehqSSCxgpp2sVr7qQlaTp0XkIBy8kow=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250415042502epcas1p4b472cff49569b89957918ec584980af9~2Y1B7QGBE0726507265epcas1p4s;
	Tue, 15 Apr 2025 04:25:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4Zc9zy6Z5vz6B9mG; Tue, 15 Apr
	2025 04:25:02 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c~2WXGUleHJ0256102561epcas1p4Y;
	Tue, 15 Apr 2025 01:24:10 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250415012409epsmtrp2b806165f79420521fce5476f72ab69b6~2WXGTyBVw2483324833epsmtrp2d;
	Tue, 15 Apr 2025 01:24:09 +0000 (GMT)
X-AuditID: b6c32a52-41dfa70000004c16-c7-67fdb5399a4c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.1D.19478.935BDF76; Tue, 15 Apr 2025 10:24:09 +0900 (KST)
Received: from parkseongsu-desktop.. (unknown [10.252.69.73]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250415012409epsmtip17aaa9ff006eec292d6118788f53b2b96~2WXGHOedu2759227592epsmtip18;
	Tue, 15 Apr 2025 01:24:09 +0000 (GMT)
From: Seongsu Park <sgsu.park@samsung.com>
To: will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, joey.gouly@arm.com, oliver.upton@linux.dev,
	maz@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, sgsu.park@samsung.com, cpgs@samsung.com
Subject: [PATCH] arm64: kvm: Replace ternary flags with str_on_off() helper
Date: Tue, 15 Apr 2025 10:24:05 +0900
Message-Id: <1891546521.01744691102904.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnK7l1r/pBv9vWFi8X9bDaPHykKbF
	l+Y2JotXWw6zWGx6fI3V4vKuOWwWO+ecZLWY+vMNm8X7hi5Wi5m3bzNatNwxtbi5dAO7A4/H
	mnlrGD1ajrxl9di0qpPNY2HDVGaPzUvqPV5snsno0bdlFaPH501yARxRXDYpqTmZZalF+nYJ
	XBkbl3WzF9zjqFjV18bYwPiTrYuRk0NCwERi/o03jF2MXBxCAtsZJVa23GOBSEhKtL+7DGRz
	ANnCEocPF4OEhQQ+MErsmRQOYrMJaEms/tfLDtIrIrCIUeLzpPlgDrNAP6PEsqftrCBVwgLe
	Ep1PpzOBDGIRUJW4cCYRJMwrYC2xev87Johd8hL7D55lhogLSpyc+QTsBmagePPW2cwTGPlm
	IUnNQpJawMi0ilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM4zLWCdjAuW/9X7xAjEwfjIUYJ
	DmYlEV4u51/pQrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxS
	DUzmJ2TTlj2dcvlSi41p8oa1yS2f5TcG3HB/5a1wUUj1O1OwwfGzR3on2UiXrrnmV7Du7pbs
	5fdiJgWkcrRrOxob+8mlJbd5vOjrE289arslLq7h8PY1axfF/6vxOK3RtH3elZXH1rSu/jT7
	4emydK2r/RZts2dbcNot2MP3xkHnybMJHfrTnOWSG1YXCm/QblCbI7w3JNAl4qpEw0z5AHfh
	lH+6Z2fr/dl+7MPBGDfzj9+K9j42+KvV16h/yvL/LqX9j8Mevd2ceDXctFKcd0eO/Unu+V+P
	LA0S1Ww8z8e+ZV9Z2e0l4juVzt2r7Lpopsa4+9Hdj+3yHg/qzb8k7km63a+zoa6wZv+3joUP
	FPqUWIozEg21mIuKEwEp9ESC4gIAAA==
X-CMS-MailID: 20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c
References: <CGME20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c@epcas1p4.samsung.com>

Replace repetitive ternary expressions with the str_on_off() helper
function. This change improves code readability and ensures consistency
in tracepoint string formatting

Signed-off-by: Seongsu Park <sgsu.park@samsung.com>
---
 arch/arm64/kvm/trace_arm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index c18c1a95831e..9c60f6465c78 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -176,7 +176,7 @@ TRACE_EVENT(kvm_set_way_flush,
 	    ),
 
 	    TP_printk("S/W flush at 0x%016lx (cache %s)",
-		      __entry->vcpu_pc, __entry->cache ? "on" : "off")
+		      __entry->vcpu_pc, str_on_off(__entry->cache))
 );
 
 TRACE_EVENT(kvm_toggle_cache,
@@ -196,8 +196,8 @@ TRACE_EVENT(kvm_toggle_cache,
 	    ),
 
 	    TP_printk("VM op at 0x%016lx (cache was %s, now %s)",
-		      __entry->vcpu_pc, __entry->was ? "on" : "off",
-		      __entry->now ? "on" : "off")
+		      __entry->vcpu_pc, str_on_off(__entry->was),
+		      str_on_off(__entry->now))
 );
 
 /*
-- 
2.34.1


