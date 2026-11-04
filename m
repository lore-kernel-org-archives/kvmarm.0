Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785317;
	b=Mx7CK0ZlmVjn8RgM0AfJohIHxbK4VvRPhFQEpxow1fSRxMz+KpH59sGqTI9gecAvDLqV
	 4AmXM8gMeUGEly1NsA6N05LpiHPFSC1s6ckz1mn9LjAzCPIZW3HuCwZZhphYQ484dK4Mk
	 d3xP+w556d47GKfCuW4pR9M1Yg4loiG3ldUAe0WbPiIo52N9D/Gqmsdw6x1Yasq/vSP1z
	 jpQShdUkWDXhC1PZinkFLTtS/wJSHoC0G94IIcDsn4B7yzuOnaVkaNiz7kCc4aujFt9Z4
	 k4JIEJqueqK/G3thnjsppej0vvMGchxFsV07biVzpC2G1pgwlRy3TDzpiEgiCWVjWQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785317;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i9f4/D8qb9HDyCMKjqmdspRjwlPIs06U9VQOHDxE7bQ=;
	b=EgsUx2m99/HJNe4nlquh/ESXhF4GMmHatd+gXKZ6SroGrmHeCEstsMDwmiu5ACHjN6OH
	 SDy0PPgA2/tuh77QHN5rdgKcrieDGeCYVBbxq9gkd9qbnY2AOC/MWNvWv4K7qtm4yaa3S
	 Xt0YrwJ+PNdlStwEsCOkOYmKpJpEvSH3q/eeWyOvN5kQlz6yRDNSrkUbCK4e7OkZoajsf
	 XzHUk6AfW3ZsZFuuYqHDxT8yjwPRYcgpdKTkELzWewPLI/42FzJYr4u79J7f+8oFYrzDY
	 KGk8TJjdUvYbY5XsKgAnfvsF5Tk/dM/5OGpxtSFQ8MVv+iaw0i2+7bhm6438BdYRpjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=zEAqlhug;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65598606A326
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 09:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65598606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=zEAqlhug
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=zEAqlhugg/Erujm437DOximgHfbI6Uyp8Z8rNTW5DVEICar6aZpPbAqDOU8wXtYAdut9lOXnCdmFJ
	 XRE9YNNTph8/AQhoi4A1PUglPuSsAHu/+3pY77WMcSLfO6a/DY4bFQO7NbF1upt7CwYyIBulbNs01L
	 K/X1wEYDxKdCU0FA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46aeafde2c8e-3c6ec;
	Wed, 04 Nov 2026 17:41:54 +0800 (CST)
X-RM-TRANSID:2ee46aeafde2c8e-3c6ec
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56aeafde040e-1d94a;
	Wed, 04 Nov 2026 17:41:54 +0800 (CST)
X-RM-TRANSID:2ee56aeafde040e-1d94a
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: oupton@kernel.org,
	maz@kernel.org
Cc: fuad.tabba@linux.dev,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftests/kvm: arm64: get-reg-list: fix format specifiers
Date: Wed,  4 Nov 2026 17:41:46 +0800
Message-ID: <20261104094147.2252-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The core_id_to_str(), sve_id_to_str() and print_reg() functions
print __u64 values (idx, n and masked id) with the %lld
conversion, which expects a signed long long. Use %llu
instead, matching the unsigned type of the arguments and
silencing the -Wformat warnings.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 912590f9b0c2..2b85189862e5 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -145,8 +145,8 @@ static const char *core_id_to_str(const char *prefix, __u64 id)
 	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(regs.regs[0])) / CORE_REGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 31, "%s: Unexpected regs.regs index: %lld", prefix, idx);
-		return strdup_printf("KVM_REG_ARM_CORE_REG(regs.regs[%lld])", idx);
+		TEST_ASSERT(idx < 31, "%s: Unexpected regs.regs index: %llu", prefix, idx);
+		return strdup_printf("KVM_REG_ARM_CORE_REG(regs.regs[%llu])", idx);
 	case KVM_REG_ARM_CORE_REG(regs.sp):
 		return "KVM_REG_ARM_CORE_REG(regs.sp)";
 	case KVM_REG_ARM_CORE_REG(regs.pc):
@@ -160,13 +160,13 @@ static const char *core_id_to_str(const char *prefix, __u64 id)
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(spsr[0])) / CORE_SPSR_XX_NR_WORDS;
-		TEST_ASSERT(idx < KVM_NR_SPSR, "%s: Unexpected spsr index: %lld", prefix, idx);
-		return strdup_printf("KVM_REG_ARM_CORE_REG(spsr[%lld])", idx);
+		TEST_ASSERT(idx < KVM_NR_SPSR, "%s: Unexpected spsr index: %llu", prefix, idx);
+		return strdup_printf("KVM_REG_ARM_CORE_REG(spsr[%llu])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(fp_regs.vregs[0])) / CORE_FPREGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 32, "%s: Unexpected fp_regs.vregs index: %lld", prefix, idx);
-		return strdup_printf("KVM_REG_ARM_CORE_REG(fp_regs.vregs[%lld])", idx);
+		TEST_ASSERT(idx < 32, "%s: Unexpected fp_regs.vregs index: %llu", prefix, idx);
+		return strdup_printf("KVM_REG_ARM_CORE_REG(fp_regs.vregs[%llu])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
 		return "KVM_REG_ARM_CORE_REG(fp_regs.fpsr)";
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
@@ -195,13 +195,13 @@ static const char *sve_id_to_str(const char *prefix, __u64 id)
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_ZREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_ZREG(n, 0),
 			    "%s: Unexpected bits set in SVE ZREG id: 0x%llx", prefix, id);
-		return strdup_printf("KVM_REG_ARM64_SVE_ZREG(%lld, 0)", n);
+		return strdup_printf("KVM_REG_ARM64_SVE_ZREG(%llu, 0)", n);
 	case KVM_REG_ARM64_SVE_PREG_BASE ...
 	     KVM_REG_ARM64_SVE_PREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_PREGS - 1:
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_PREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_PREG(n, 0),
 			    "%s: Unexpected bits set in SVE PREG id: 0x%llx", prefix, id);
-		return strdup_printf("KVM_REG_ARM64_SVE_PREG(%lld, 0)", n);
+		return strdup_printf("KVM_REG_ARM64_SVE_PREG(%llu, 0)", n);
 	case KVM_REG_ARM64_SVE_FFR_BASE:
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_FFR(0),
 			    "%s: Unexpected bits set in SVE FFR id: 0x%llx", prefix, id);
@@ -259,7 +259,7 @@ void print_reg(const char *prefix, __u64 id)
 	case KVM_REG_ARM_DEMUX:
 		TEST_ASSERT(!(id & ~(REG_MASK | KVM_REG_ARM_DEMUX_ID_MASK | KVM_REG_ARM_DEMUX_VAL_MASK)),
 			    "%s: Unexpected bits set in DEMUX reg id: 0x%llx", prefix, id);
-		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | %lld,\n",
+		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | %llu,\n",
 		       reg_size, id & KVM_REG_ARM_DEMUX_VAL_MASK);
 		break;
 	case KVM_REG_ARM64_SYSREG:
@@ -275,12 +275,12 @@ void print_reg(const char *prefix, __u64 id)
 	case KVM_REG_ARM_FW:
 		TEST_ASSERT(id == KVM_REG_ARM_FW_REG(id & 0xffff),
 			    "%s: Unexpected bits set in FW reg id: 0x%llx", prefix, id);
-		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
+		printf("\tKVM_REG_ARM_FW_REG(%llu),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM_FW_FEAT_BMAP:
 		TEST_ASSERT(id == KVM_REG_ARM_FW_FEAT_BMAP_REG(id & 0xffff),
 			    "%s: Unexpected bits set in the bitmap feature FW reg id: 0x%llx", prefix, id);
-		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%lld),\n", id & 0xffff);
+		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%llu),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM64_SVE:
 		printf("\t%s,\n", sve_id_to_str(prefix, id));
-- 
2.50.1.windows.1



