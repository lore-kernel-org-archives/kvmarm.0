Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452B63C27
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 11:28:49 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so10162692wmb.5
        for <kvmarm@lists.linux.dev>; Tue, 07 Mar 2023 03:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOd0jSLOO+UI3WE+UlLsCxj1ZQ7pCFwHne+Nhyu5xhk=;
        b=gHjEcNbXhe7uK9JJYN0EsYFE+2awhLb8puf4HcnQmFza7dkHF8jQB7e9HUJXkc0beJ
         U95xvBBamLT6Jm9loFzt1AUuoTrwgnlQ5dx/vxtlKlwdiZqhLPOyXkVp3mE6tx3Atz/g
         0dudl4MPffYYSPYBlaJym3awigKAf1lJsRvE2alkShpNuyNJoxvN2nWlSnmV74IVnwZX
         KHMht2lEggMBbX72i0YP2UMKch2EnEtFOXQ8KRuWqJ77oAQOi0hhzy6HjJPle7RVkq/1
         7qlOMlUoxN0RXCoRqQ4fLQHI9/WFdGvhdgVXYjSYa3ezf9ODjzSepJG8Lpq9NBr8w48L
         SoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOd0jSLOO+UI3WE+UlLsCxj1ZQ7pCFwHne+Nhyu5xhk=;
        b=DFNfFccx9AzPbNFWRJUQbXtpahzLJRFph2rJOTaF3afBrFmE6JJ3ae9363AYCuj63u
         7+h9LjZNGDCf9lS2jNnZn/3giJl3GXMufZ1cpWV91yzjFP4topv9FDLdmL+K5uu/BI15
         NhHPsyslQFOc3Kyaei1nq1VDVzdq2eb5wdQ2zRk6KN+jAN1Kua4ufARoZekxY5iF4akz
         8SIUaeBHB5iKr+remefmAGKAXjYqv3x0wIF8IxDr5WbW5mm6T3wgdSDlqmBb9V2ST4Vp
         m0AQhzVmQl33Mp8tx9oLM13yEZeHkcYyHCOiYDd11kJLeyKlg2V0dYCIUWOtWAjdCfnh
         Qs1g==
X-Gm-Message-State: AO0yUKUwKOsTazvQk7QrZ3amPxFKak3MADif3YpE06A7j+Z/WM7l4yd0
	IKMrtU7l9R3PIS6cFnENlVl21w==
X-Google-Smtp-Source: AK7set9oD8oTyfhc4oCf+btx9y6ZG663jP1jWFv26I6QapHY94FDAtPD8hn1BNRzT0T4Uh5CU5zwdQ==
X-Received: by 2002:a1c:7c16:0:b0:3df:9858:c02e with SMTP id x22-20020a1c7c16000000b003df9858c02emr12403339wmc.3.1678188527458;
        Tue, 07 Mar 2023 03:28:47 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e4-20020a5d5304000000b002ce3cccda0bsm11786573wrv.81.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
	by zen.linaroharston (Postfix) with ESMTP id C91601FFBB;
	Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvmarm@lists.linux.dev,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"Timothy B . Terriberry" <tterribe@xiph.org>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v10 3/7] lib: add isaac prng library from CCAN
Date: Tue,  7 Mar 2023 11:28:41 +0000
Message-Id: <20230307112845.452053-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It's often useful to introduce some sort of random variation when
testing several racing CPU conditions. Instead of each test implementing
some half-arsed PRNG bring in a a decent one which has good statistical
randomness. Obviously it is deterministic for a given seed value which
is likely the behaviour you want.

I've pulled in the ISAAC library from CCAN:

    http://ccodearchive.net/info/isaac.html

I shaved off the float related stuff which is less useful for unit
testing and re-indented to fit the style. The original license was
CC0 (Public Domain) which is compatible with the LGPL v2 of
kvm-unit-tests.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Timothy B. Terriberry <tterribe@xiph.org>
Acked-by: Andrew Jones <drjones@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20211118184650.661575-6-alex.bennee@linaro.org>

---
v9
  - add SPDX CC0 tags
---
 arm/Makefile.common |   1 +
 lib/prng.h          |  83 ++++++++++++++++++++++
 lib/prng.c          | 163 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+)
 create mode 100644 lib/prng.h
 create mode 100644 lib/prng.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 1bbec64f..16f8c6df 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -45,6 +45,7 @@ cflatobjs += lib/pci-testdev.o
 cflatobjs += lib/virtio.o
 cflatobjs += lib/virtio-mmio.o
 cflatobjs += lib/chr-testdev.o
+cflatobjs += lib/prng.o
 cflatobjs += lib/arm/io.o
 cflatobjs += lib/arm/setup.o
 cflatobjs += lib/arm/mmu.o
diff --git a/lib/prng.h b/lib/prng.h
new file mode 100644
index 00000000..4f9512f5
--- /dev/null
+++ b/lib/prng.h
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: CC0-1.0
+/*
+ * PRNG Header
+ */
+#ifndef __PRNG_H__
+#define __PRNG_H__
+
+# include <stdint.h>
+
+
+
+typedef struct isaac_ctx isaac_ctx;
+
+
+
+/*This value may be lowered to reduce memory usage on embedded platforms, at
+  the cost of reducing security and increasing bias.
+  Quoting Bob Jenkins: "The current best guess is that bias is detectable after
+  2**37 values for [ISAAC_SZ_LOG]=3, 2**45 for 4, 2**53 for 5, 2**61 for 6,
+  2**69 for 7, and 2**77 values for [ISAAC_SZ_LOG]=8."*/
+#define ISAAC_SZ_LOG      (8)
+#define ISAAC_SZ          (1<<ISAAC_SZ_LOG)
+#define ISAAC_SEED_SZ_MAX (ISAAC_SZ<<2)
+
+
+
+/*ISAAC is the most advanced of a series of pseudo-random number generators
+  designed by Robert J. Jenkins Jr. in 1996.
+  http://www.burtleburtle.net/bob/rand/isaac.html
+  To quote:
+  No efficient method is known for deducing their internal states.
+  ISAAC requires an amortized 18.75 instructions to produce a 32-bit value.
+  There are no cycles in ISAAC shorter than 2**40 values.
+  The expected cycle length is 2**8295 values.*/
+struct isaac_ctx{
+	unsigned n;
+	uint32_t r[ISAAC_SZ];
+	uint32_t m[ISAAC_SZ];
+	uint32_t a;
+	uint32_t b;
+	uint32_t c;
+};
+
+
+/**
+ * isaac_init - Initialize an instance of the ISAAC random number generator.
+ * @_ctx:   The instance to initialize.
+ * @_seed:  The specified seed bytes.
+ *          This may be NULL if _nseed is less than or equal to zero.
+ * @_nseed: The number of bytes to use for the seed.
+ *          If this is greater than ISAAC_SEED_SZ_MAX, the extra bytes are
+ *           ignored.
+ */
+void isaac_init(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed);
+
+/**
+ * isaac_reseed - Mix a new batch of entropy into the current state.
+ * To reset ISAAC to a known state, call isaac_init() again instead.
+ * @_ctx:   The instance to reseed.
+ * @_seed:  The specified seed bytes.
+ *          This may be NULL if _nseed is zero.
+ * @_nseed: The number of bytes to use for the seed.
+ *          If this is greater than ISAAC_SEED_SZ_MAX, the extra bytes are
+ *           ignored.
+ */
+void isaac_reseed(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed);
+/**
+ * isaac_next_uint32 - Return the next random 32-bit value.
+ * @_ctx: The ISAAC instance to generate the value with.
+ */
+uint32_t isaac_next_uint32(isaac_ctx *_ctx);
+/**
+ * isaac_next_uint - Uniform random integer less than the given value.
+ * @_ctx: The ISAAC instance to generate the value with.
+ * @_n:   The upper bound on the range of numbers returned (not inclusive).
+ *        This must be greater than zero and less than 2**32.
+ *        To return integers in the full range 0...2**32-1, use
+ *         isaac_next_uint32() instead.
+ * Return: An integer uniformly distributed between 0 and _n-1 (inclusive).
+ */
+uint32_t isaac_next_uint(isaac_ctx *_ctx,uint32_t _n);
+
+#endif
diff --git a/lib/prng.c b/lib/prng.c
new file mode 100644
index 00000000..cfad8c54
--- /dev/null
+++ b/lib/prng.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: CC0-1.0
+/*
+ * Pseudo Random Number Generator
+ *
+ * Lifted from ccan modules ilog/isaac under CC0
+ *   - http://ccodearchive.net/info/isaac.html
+ *   - http://ccodearchive.net/info/ilog.html
+ *
+ * And lightly hacked to compile under the KVM unit test environment.
+ * This provides a handy RNG for torture tests that want to vary
+ * delays and the like.
+ *
+ */
+
+/*Written by Timothy B. Terriberry (tterribe@xiph.org) 1999-2009.
+  CC0 (Public domain) - see LICENSE file for details
+  Based on the public domain implementation by Robert J. Jenkins Jr.*/
+
+#include "libcflat.h"
+
+#include <string.h>
+#include "prng.h"
+
+#define ISAAC_MASK        (0xFFFFFFFFU)
+
+/* Extract ISAAC_SZ_LOG bits (starting at bit 2). */
+static inline uint32_t lower_bits(uint32_t x)
+{
+	return (x & ((ISAAC_SZ-1) << 2)) >> 2;
+}
+
+/* Extract next ISAAC_SZ_LOG bits (starting at bit ISAAC_SZ_LOG+2). */
+static inline uint32_t upper_bits(uint32_t y)
+{
+	return (y >> (ISAAC_SZ_LOG+2)) & (ISAAC_SZ-1);
+}
+
+static void isaac_update(isaac_ctx *_ctx){
+	uint32_t *m;
+	uint32_t *r;
+	uint32_t  a;
+	uint32_t  b;
+	uint32_t  x;
+	uint32_t  y;
+	int       i;
+	m=_ctx->m;
+	r=_ctx->r;
+	a=_ctx->a;
+	b=_ctx->b+(++_ctx->c);
+	for(i=0;i<ISAAC_SZ/2;i++){
+		x=m[i];
+		a=(a^a<<13)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>6)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a<<2)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>16)+m[i+ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+	}
+	for(i=ISAAC_SZ/2;i<ISAAC_SZ;i++){
+		x=m[i];
+		a=(a^a<<13)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>6)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a<<2)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+		x=m[++i];
+		a=(a^a>>16)+m[i-ISAAC_SZ/2];
+		m[i]=y=m[lower_bits(x)]+a+b;
+		r[i]=b=m[upper_bits(y)]+x;
+	}
+	_ctx->b=b;
+	_ctx->a=a;
+	_ctx->n=ISAAC_SZ;
+}
+
+static void isaac_mix(uint32_t _x[8]){
+	static const unsigned char SHIFT[8]={11,2,8,16,10,4,8,9};
+	int i;
+	for(i=0;i<8;i++){
+		_x[i]^=_x[(i+1)&7]<<SHIFT[i];
+		_x[(i+3)&7]+=_x[i];
+		_x[(i+1)&7]+=_x[(i+2)&7];
+		i++;
+		_x[i]^=_x[(i+1)&7]>>SHIFT[i];
+		_x[(i+3)&7]+=_x[i];
+		_x[(i+1)&7]+=_x[(i+2)&7];
+	}
+}
+
+
+void isaac_init(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed){
+	_ctx->a=_ctx->b=_ctx->c=0;
+	memset(_ctx->r,0,sizeof(_ctx->r));
+	isaac_reseed(_ctx,_seed,_nseed);
+}
+
+void isaac_reseed(isaac_ctx *_ctx,const unsigned char *_seed,int _nseed){
+	uint32_t *m;
+	uint32_t *r;
+	uint32_t  x[8];
+	int       i;
+	int       j;
+	m=_ctx->m;
+	r=_ctx->r;
+	if(_nseed>ISAAC_SEED_SZ_MAX)_nseed=ISAAC_SEED_SZ_MAX;
+	for(i=0;i<_nseed>>2;i++){
+		r[i]^=(uint32_t)_seed[i<<2|3]<<24|(uint32_t)_seed[i<<2|2]<<16|
+			(uint32_t)_seed[i<<2|1]<<8|_seed[i<<2];
+	}
+	_nseed-=i<<2;
+	if(_nseed>0){
+		uint32_t ri;
+		ri=_seed[i<<2];
+		for(j=1;j<_nseed;j++)ri|=(uint32_t)_seed[i<<2|j]<<(j<<3);
+		r[i++]^=ri;
+	}
+	x[0]=x[1]=x[2]=x[3]=x[4]=x[5]=x[6]=x[7]=0x9E3779B9U;
+	for(i=0;i<4;i++)isaac_mix(x);
+	for(i=0;i<ISAAC_SZ;i+=8){
+		for(j=0;j<8;j++)x[j]+=r[i+j];
+		isaac_mix(x);
+		memcpy(m+i,x,sizeof(x));
+	}
+	for(i=0;i<ISAAC_SZ;i+=8){
+		for(j=0;j<8;j++)x[j]+=m[i+j];
+		isaac_mix(x);
+		memcpy(m+i,x,sizeof(x));
+	}
+	isaac_update(_ctx);
+}
+
+uint32_t isaac_next_uint32(isaac_ctx *_ctx){
+	if(!_ctx->n)isaac_update(_ctx);
+	return _ctx->r[--_ctx->n];
+}
+
+uint32_t isaac_next_uint(isaac_ctx *_ctx,uint32_t _n){
+	uint32_t r;
+	uint32_t v;
+	uint32_t d;
+	do{
+		r=isaac_next_uint32(_ctx);
+		v=r%_n;
+		d=r-v;
+	}
+	while(((d+_n-1)&ISAAC_MASK)<d);
+	return v;
+}
-- 
2.39.2

