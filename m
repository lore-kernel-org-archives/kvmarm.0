Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FB017596
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 07:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080739; cv=none; b=bIpz3aAZq/8Nhhd47NNp7HuQzB1mI3QNIchvTAPVf9eL2VsQ+NIwSUE3GsDmHnTO8DLZaIMakoTbAP+DLuBuWRKvmOCVz1nS+UKzEx3JJPcGq6+t+GR3wUQGZ2Fb+bWWWPRdh6ttv70K5D5n9BoBpSep/xeqrR5CkxwuMqj9QKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080739; c=relaxed/simple;
	bh=NHKe1SxzNfkWiS/m69XcTU6FPqqdH/o2CKwQldopOD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=VHgfO0eaI2UoOsQ1F+Fuh78vUVGstC/sQ7FgZryCvQkK779oeYKmf+EDtUt6CuUBC6fqJLYr4+LZ8Ge5huMrm8sP6vxOQXYcC5wswbGNbZroqHe9c8iujLWCsK1sTjtjg0Iq+qR9S7YFDmwUF5qMFI6tHlw0WRQ6iL3d/6Ov1ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UgCn2jmN; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UgCn2jmN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bXDA4fG69sNEO02gQSahza/Tr2kdXXF8laceVkmfsic=;
	b=UgCn2jmN1SP37cvkSWhZjGHLg4l/q58w3f4nQkJLeRwzlyQgUIlkHpLjCA31awaBEmKwbL
	XcJo0IwCODyy7ANaXfuprcdAnBBKCFnipAC7bkIZv0vJDt8ZJST5nY4HxgiGsFQkV8+Pyj
	hzHJbkmMufymFYW5sErpj7hGWEZt9KI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 14/24] riscv: Compile with march
Date: Wed, 24 Jan 2024 08:18:30 +0100
Message-ID: <20240124071815.6898-40-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tell the compiler to provide mnemonics for instructions we depend on,
such as 'pause'. Specifying march also allows extensions which affect
compilation to be individually [un]selected. For example, building
without compressed (2 byte) instructions may be desirable, so 'c' may
be removed from the march isa string.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/riscv/Makefile b/riscv/Makefile
index 4a83f27f7df2..697a3beb2703 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -55,8 +55,13 @@ define arch_elf_check =
 		$(error $(1) has unsupported reloc types))
 endef
 
+ISA_COMMON = mafdc_zicsr_zifencei_zihintpause
+
 ifeq ($(ARCH),riscv64)
+CFLAGS += -march=rv64i$(ISA_COMMON)
 CFLAGS += -DCONFIG_64BIT
+else ifeq ($(ARCH),riscv32)
+CFLAGS += -march=rv32i$(ISA_COMMON)
 endif
 CFLAGS += -DCONFIG_RELOC
 CFLAGS += -mcmodel=medany
-- 
2.43.0

