Received: from outbound.pv.icloud.com (p-west1-cluster6-host3-snip4-10.eps.apple.com [57.103.67.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2777429A2
	for <kvmarm@lists.linux.dev>; Sat,  6 Sep 2025 04:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.67.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757131709; cv=none; b=hN7VT7CiTJi37TPCkptRvJUk7tt2IrnEnt8kAS3TINLtFN7BD6pCVvp548+jel+rlNuTvtUEWg+URJgTq3BmEsItvVj0/uuRe7nA1zsT5A8C9CL/WzMrRdwHLpsWZYgx+JqBFQwFDI60bEYTIxjZ/op2haUIzUjPI7wmN86fDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757131709; c=relaxed/simple;
	bh=W0ZMlZxfmxu4/88SlRs9V8COyNV6kyVciBn9lA69rFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GObaruAXAuefoKvY++xdKB2jRm2WItorkQliQI/PmikhllkRfp1kMo8VR2Z3kbd4AAtoIhDqz6u3ztCDAI7Pl3CuUiaFpeTwhzZA/1H0URCVXsNaUKwEa9qvwF7xgN/R/qAgHTJO/g0Dm9QnjhRfzGh+UiKdgCxkLqgnN+TyDKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sswd.pw; spf=pass smtp.mailfrom=sswd.pw; dkim=pass (2048-bit key) header.d=sswd.pw header.i=@sswd.pw header.b=qMKSDCw1; arc=none smtp.client-ip=57.103.67.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sswd.pw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sswd.pw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sswd.pw header.i=@sswd.pw header.b="qMKSDCw1"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-10-percent-0 (Postfix) with ESMTPS id 59B9E180011B;
	Sat,  6 Sep 2025 04:08:23 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sswd.pw; s=sig1; bh=Rgj00ZQJ6YXpmj/Fkl8OSXbBHLLgoWXgDDmBKRr58+k=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=qMKSDCw1cdIj3DK2yvZ++TbDoBlx8E+r7bG3YQzzyzKEMXHV0lqNhfDmgasQIh2b5q814XJWqVgNnlADr7tlTho3V3ihCmkLNpl63m0TP9SeePSEu6HgG3BI9eJWvzDjhv5GAPnFMbR7Zqy8iBObZynQ57h9Z2yAFtlBiCPylfCWNpGBShN/yyYIPy8YdrjDXLld9AtzjyORftHYnTVJX5C1sZDWPkqicvfpxjVhB1oiCfA5TeMBzkuF+u+K/WIQTXbmvP9RyK6+n4LijaWMM7PWIXJ8aC468RyDUs4FSKlxYpP0BWaGmzfdq6OPNN85J9oAyAEhI8y5qABQeGYUTw==
mail-alias-created-date: 1750314795890
Received: from localhost.localdomain (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-10-percent-0 (Postfix) with ESMTPSA id A7B551800102;
	Sat,  6 Sep 2025 04:08:20 +0000 (UTC)
From: p@sswd.pw
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Dongha Lee <p@sswd.pw>
Subject: [PATCH v3] KVM: arm64: nv: Fix incorrect VNCR invalidation range calculation
Date: Sat,  6 Sep 2025 13:07:24 +0900
Message-ID: <20250906040724.72960-1-p@sswd.pw>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: CqaMxTFjajy8dA-UyRm0ZEXba6kx_oHN
X-Proofpoint-GUID: CqaMxTFjajy8dA-UyRm0ZEXba6kx_oHN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAzNCBTYWx0ZWRfX9PZK9Wz6rt0n
 CE09kUIpMHLBa7OozCr9w46ADwN5eDD3MC05FwNijOOzeqch9TcEd1ryPhDeZ3STgZwdArsVIE+
 i7V9VaZ+1xet7G3gfR4t4J6RKM+GZTrv7BjkynuvbG6waWsaN5Kxrh2xHXo13cwjAfeBm2+HX1Q
 OUhb4J+WUlcTpObtt+c1cp8GhING1FpbvIkR78VChyeQrqsrKPDn6kGgPl+dvPGShIGAy56yD/L
 lDPrlHrRlQw1QCMGAUYaE0+4mMoiTRl6pJsFsm/X9EDiu3sTbZ5YgUMhPvh4+VcMMJc8KYSD8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_09,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 clxscore=1030 spamscore=0 adultscore=0 mlxlogscore=950
 suspectscore=0 phishscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2509060034
X-JNJ: AAAAAAAByC4YvtSmVYqoO4If7rP+IrxCnQ7wtVXyGE65JkouCZYcHsuqwvg2gFZBkntax+8sgc45lKq7V+tQv7+SMx02IVytv3h4/O7jm0b3oM0SX0hhiC4/M5BO2rCX2VIv89Z6CPeINH5V+iub+mnauRU1Y5p96dWh5vdKW1Jhqx98lEJinxs7j6jqosgNFonmAQQMfq0s/EfpGa29I9xEtXw+d2b2QMIW602T8y8sijbvRwlrI+eL9sZiHDIGEt7iLrr6obY2dpNMvYl5Oy/jfeKRJYR1B5tCMZw2T55sKSzJLHU5lmCkiNX/LB32/8a35gP1L+A1vg5qlIE4ZalqILtSR9YAJ2CoX7yFv4bva5BbdwLlIovFiq82rJCt6Ig68wdDa0nxROeq2PCSJ4l+c9b208YkOrKXb78Aog3UdcjJn9fyEnDyzL9I+V0G4EWsGGTpYFGgdKyRBlbyNj4bx5XB3ZqhjtnAIkhzOH0H4zXB5qvzkzDeTA0zcB876crugnlEtZ9VlOliULiWT9N+wbADtmk/n8JLVzEZN7kqKN2BE+a8+TDX5+vRx569oW9DIwFvIbzOsQpeVvyfWpnt8HAwMMzsj7oBJirrVzBOet7Ux0hI8VS8KQiA7JSwxC9Tt9wrcuuTqTTbVmm64S879DZ93NEN2WSRUvDvgs+VBvyY6b8KoE2Um3wLkWI1rQtRrMcTJ3M71Iky/tatX4s1AcKrjsM7HonhQE4Lwg==

From: Dongha Lee <p@sswd.pw>

The code for invalidating VNCR entries in both kvm_invalidate_vncr_ipa()
and invalidate_vncr_va() incorrectly uses a bitwise AND with `(size - 1)`
instead of `~(size - 1)` to align the start address. This results
in masking the address bits instead of aligning them down to the start
of the block.

This bug may cause stale VNCR TLB entries to remain valid even after a
TLBI or MMU notifier, leading to incorrect memory translation and
unexpected guest behavior.

Credit
Team 0xB6 in bob14:
DongHa Lee (@GAP-dev)
Gyujeong Jin (@gyutrange)
Daehyeon Ko (@4ncienth)
Geonha Lee (@leegn4a)
Hyungyu Oh (@ohhyungyu)
Jaewon Yang (@R4mbb)

Link: https://lore.kernel.org/r/20250903123949.24858-1-p@sswd.pw
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Dongha Lee <p@sswd.pw>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..d0ddce877b5d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -847,7 +847,7 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
 
 		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
 							    vt->wr.level));
-		ipa_start = vt->wr.pa & (ipa_size - 1);
+		ipa_start = vt->wr.pa & ~(ipa_size - 1);
 		ipa_end = ipa_start + ipa_size;
 
 		if (ipa_end <= start || ipa_start >= end)
@@ -887,7 +887,7 @@ static void invalidate_vncr_va(struct kvm *kvm,
 
 		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
 							   vt->wr.level));
-		va_start = vt->gva & (va_size - 1);
+		va_start = vt->gva & ~(va_size - 1);
 		va_end = va_start + va_size;
 
 		switch (scope->type) {
-- 
2.43.0

