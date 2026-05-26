Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAE73911B2
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 07:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779781705; cv=none; b=ZfiovzIKYa8QtnqGjoU94Atsl9o67KYtm0Vtp2BuK/LFB30D57hEvrIWB2g5J5EPHDLlxALF7QcA9OLGRqA1GA8I9F1xkQSXvLEk5q1E7rkNvVwTuMVeNQC2rXS5xCbbf4tkK+8WO8BF2ysNo2h4whnDw1btbWwpf7LA8sERZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779781705; c=relaxed/simple;
	bh=4hhsTpbifSlpLTG62i/kb82M4toja8mQ/4oK/Y4KkAw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dd6bB7adSOUQyb2oV5YUMCVH/xuxHYDnVHdJ1YQNeMo7BSNdF53W7Vw20R/fyXv92g2z4io8G608+0o+FyE5X12z4+WZ16DtAuw568J6XDNMrtHYYQrK02/4dtenhugOijTYoC9nxMWYUv0ZDWkbUwLZt5vja0N2KogwbO7lrLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=juvoB+Sg; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="juvoB+Sg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779781638;
	bh=Wy4Eu7O9j5XBvcQTir7gfOahUHq3NYBZ0Gi/24hA7Ew=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=juvoB+SgZb8pGnGblCDwjgcK+cTp/ehVN38AgQFtoKjmV+2TINf44cgamvqCvdcHt
	 UBE/miVC36uEzcl+XqkciqwJyBlDVmsmnhjL/B44OyQpNv6BcvTXdzb3raVRliZdi7
	 ecLrK1kZlCJQ1gayt7WNt2Cxytf8EPfabTNE1doM=
X-QQ-mid: esmtpsz11t1779781613t98d4711c
X-QQ-Originating-IP: rkFwe4EmsfAYDIX/GpaJpeEnMzqmGhoXMpZ5mKtkV4c=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 26 May 2026 15:46:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10288803396514652520
EX-QQ-RecipientCnt: 11
From: Qiang Ma <maqianga@uniontech.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH] KVM: arm64: PMU: Preserve AArch32 counter low bits
Date: Tue, 26 May 2026 15:46:40 +0800
Message-Id: <20260526074640.791991-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: Nlna3a5R+peuQBRtI9/Q0FpmNInSMKurmczkvV6zxqo8aN9eMNO0PE+q
	uLI99m2diB1jRoD/0zTb0MlIRTuLzeaNxNMNoW/bPeE4tozsl6WkIyPAhl0tmfPpnM7h4Tw
	+ugF0lunSS3oAMYLn4yVeLwfk5VXPIRcdFOVmj3KQxjOFN3M5tTSThnbwrrk3M4rZ6eGul8
	uU7z06NA6ggbOkfN7ZBguhFOp70I645eRqk/qT0Evkh3o/NnroUW3U5SVr4KnC9Ln2rU4ix
	6r2/zEof3zdM9SGYVbhLa/JG1PVRlb0Q4mFWepp/McJPmlKOpn675l1F8J09WVmUi5ESRHe
	GsqnApHyYkft2//TmtjsvIpB4GgNIrDqvJoe1KAcdCrOpOUWYRqcY9VdTmre9llVuhs21ud
	u2GZOvt/ujcVHNc59QLg0fDH9BwToBI6WAE8k2vEU7wuz+O0/LHBC2SSh758gX2DOPnmggH
	IDnHNC8cgLusB8KIswVeoHRDO+sim/yaXf3Kl38N5LlkDLRgtqpxcNbmP/oEniScwwZy6xq
	9Rl1LMn8pY7Q34PbzhtFi/DP5NsuiGPT91ynsq/TMQ0NJ+ZAcAeNm2f32EuegszsL+ofo3w
	YVcloZ9QJ8zJ038fseRib+zmeFULISymukystQ/qdPQzQGDCaRF7PpJHJBRt7nOU5JYfCMi
	12b10MK8zNG6MEW5JngNsN6biQmIJuAeTpoyB52OSi1Gsa/U+idvCZ+I3J3M5kqdlxL6m4B
	OoD6ymPCmtqpQoWEPtpyK8/81SHzxXCVAQaJStIdbSWIN+F7J+GHU1LbNAmeum8aGmad49L
	UN13X+HiQVG/q9TY9QhYqD8hKEJIqZ4ZJgkEjkYqkzuKSr8vVspiC77I86bqKKeUkXraTOe
	McDwcqZxETg4WD199vm7ry1IhWUTbTQZx1XV/NjgklujkRqQUxRhjZqTXJ+r47a5/H786CS
	yBhHyeZ9uRyX2qrAp4vNiVovZXLJLNxOmtXaxbkzshPaQrvtkfLUiNRyhCPoyRoiuGIYk44
	6nEyyyvDf73xKGinB6X7dl+nPZdRgGMTZQzodqXtU61xc7zRoJ3uVZG6Wk4IP4XHzO9fQYp
	w==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

AArch32 writes to PMU event counters cannot update the top 32 bits,
even when PMUv3p5 makes the counters 64-bit. KVM therefore needs to
preserve the existing high half and only update the low half written by
the guest, unless the caller explicitly forces a full reset through
PMCR.P.

The current code masks @val down to the old high half before taking
lower_32_bits(val), which means the low half is always zero. As a
result, AArch32 writes to event counters discard the guest-provided low
32 bits instead of storing them.

Build the new value from the old high 32 bits and the low 32 bits of
the value supplied by the guest.

Fixes: 26d2d0594d70 ("KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e1860acae641..c816db5d6761 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -174,8 +174,8 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
 		 * action is to use PMCR.P, which will reset them to
 		 * 0 (the only use of the 'force' parameter).
 		 */
-		val  = __vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32);
-		val |= lower_32_bits(val);
+		val = (__vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32)) |
+		      lower_32_bits(val);
 	}
 
 	__vcpu_assign_sys_reg(vcpu, reg, val);
-- 
2.20.1

