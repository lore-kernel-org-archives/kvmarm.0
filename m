From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 05/11] lib: add isaac prng library from CCAN
Date: Thu, 24 Nov 2016 16:10:27 +0000
Message-ID: <20161124161033.11456-6-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: qemu-devel@nongnu.org, mttcg@listserver.greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, "Timothy B . Terriberry" <tterribe@xiph.org>
List-Id: kvmarm@lists.cs.columbia.edu

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
---
 arm/Makefile.common |   1 +
 lib/prng.c          | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/prng.h          |  82 ++++++++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 lib/prng.c
 create mode 100644 lib/prng.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 6c0898f..52f7440 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -40,6 +40,7 @@ cflatobjs += lib/pci-testdev.o
 cflatobjs += lib/virtio.o
 cflatobjs += lib/virtio-mmio.o
 cflatobjs += lib/chr-testdev.o
+cflatobjs += lib/prng.o
 cflatobjs += lib/arm/io.o
 cflatobjs += lib/arm/setup.o
 cflatobjs += lib/arm/mmu.o
diff --git a/lib/prng.c b/lib/prng.c
new file mode 100644
index 0000000..ebd6df7
--- /dev/null
+++ b/lib/prng.c
@@ -0,0 +1,162 @@
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
diff --git a/lib/prng.h b/lib/prng.h
new file mode 100644
index 0000000..bf5776d
--- /dev/null
+++ b/lib/prng.h
@@ -0,0 +1,82 @@
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
-- 
2.10.1

