Received: from outbound.pv.icloud.com (p-west1-cluster4-host7-snip4-10.eps.apple.com [57.103.65.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D5F2E8B70
	for <kvmarm@lists.linux.dev>; Wed,  3 Sep 2025 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.65.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756903233; cv=none; b=b/4/5cvNBmPOfEqbgKRiMwum/fFuU5DBOPWNqv0V/sUEX0Jcs3Y267uPz2HneI9ck/5uS4aVJgPwMz0HbmexqW4bx2lgVWDbK5NYqKPPDNuGxM5j/TkKlym7CmvV+R2BTvtGOqgN+RF27m0yN9cdLF7zdXPo74hruDXVgaIZW+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756903233; c=relaxed/simple;
	bh=WpZZpgymLZ7IZGm4uDUA2RgytgvwPKaiaPfsuMZFsHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uf4XNZRMItmpVf+4klHuWg83kC382J97ZJBs/5XpiyfOtL7F47tIlz6d07IfSfBfdDsLN2A1fA3HtkVUaYHn5ymNsbVItdG7h25khhXehdPioUJNuqZG3iyVNGRiT2qnlmIgnxrSAJ+mzmzpHyn0k1CUJbMXhocvfUU3laiM+No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sswd.pw; spf=pass smtp.mailfrom=sswd.pw; dkim=pass (2048-bit key) header.d=sswd.pw header.i=@sswd.pw header.b=hcZ7S69p; arc=none smtp.client-ip=57.103.65.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sswd.pw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sswd.pw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sswd.pw header.i=@sswd.pw header.b="hcZ7S69p"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 7A5251800858;
	Wed,  3 Sep 2025 12:40:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sswd.pw; s=sig1; bh=zkbWduFk8ozX1oSl6OLe8t0wpi3qXVuq+LzyBUgCb+M=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=hcZ7S69pM88GpDkrUueb4EjUWG2tS5fu9VVySXomdVU9A3aTlATcEqPOmESn8ka+pbfk3cmVL0qSOOMjy+58IOAtylQ280ZLfQegkoRKsDHcLTreCMPiM4t+EvfL60TFNd/4KDeSoi4OYEidW3I07BIVrvMyyLVMCq60ePslX1hvPPJE8WU4Mb+ZUYP4ZGKxZd7pvqUkZ2RZ512y943c27Mlg6i338FCRr25/cBJnjclVkeebS/c90tA96SKdKTYx8UWigIAht10HXT8xQCG12jhCx5ZDeSId4aQfCK7xVu8wPj77L0kaDt+dF0FPPEUwoY6VnJrblnUhlekHm27HQ==
mail-alias-created-date: 1750314795890
Received: from localhost.localdomain (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id 2854E180016F;
	Wed,  3 Sep 2025 12:40:20 +0000 (UTC)
From: p@sswd.pw
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	leedongha <gapdev2004@gmail.com>
Subject: [PATCH] arm64: kvm: Fix incorrect VNCR invalidation range calculation
Date: Wed,  3 Sep 2025 21:39:49 +0900
Message-ID: <20250903123949.24858-1-p@sswd.pw>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: CsZx7LOoZ-aqYzrD7XXVTM3fT-9sCVi2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDEyNyBTYWx0ZWRfXzCI9zaT0AJ/I
 sWLbJg8s9vK+GTv/4HxVPukUvphLoRmoFeI+kfZn2/6T7ee1ch2ie618ghhiZv0RQZL3HJk+JoT
 SbLtxnRI/euUyL8UlwXX/uN21I3gotcU99k9TqDjACERoA4/njX4whFL4yEbtVkVaf9SQ0lgTpA
 DiG9FGyE8NrZPwvsLbfxz/Toj8yxjm8wk61YKVzXK1084xzQr6gH2xQ/YmDK1dZaABn3VzezigA
 0TJ/xJoEApddQbNHRWulAzZEtixtUNnsIY/xSijKaq2ScMKtDSelu2bkjVyAMhkg/GCRT/OeE=
X-Proofpoint-GUID: CsZx7LOoZ-aqYzrD7XXVTM3fT-9sCVi2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 clxscore=1030 mlxlogscore=955 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509030127
X-JNJ: AAAAAAABRuhrF1q2p1yBnvoa7/bmADHgJtUTVO9igOrLr4Pd5YRLRDm0Prs5q5ESz7qqchzNl1o+pcsImxY+l47ydiKWMCeotRdwZI3C8IRdQAGIMOMTVPV3lvjLPW3miwKpp/me9o5+BOzf+uGfX1mlQclc0t5/VvtxR4tYnWiaH5o6XTvflxSmt86v3tdDw74fG8zsJKoFOhmwvOuB2ZWW/0cPEPULE+54qyyQ1I28dydHJjxexnUlIjxROVPzQARlobCwX8zyzS0j06fy5eZ2afR0e9+CZoRLGGM3gyfCKHui77UuVKvKYOI/uAWqnib2TF/b0SkQnG2f5Y9Qg1O8hJC6OBsKVbQburFJSNDKuK9Riz8IkG8C696PVRS2e2yhXkJ+gI/ANNQ+EX4ONzfB2dUEa7zdrVb+01YZByesw/sGcSUViHiUvnko/O/qGn1BwnnHhaf9txXdMz6Q9UbXk4dbNXhsU/10MvhwRVWS9BvPQ98mx09KMzNQZM8oKBnN/Z+aFL923XloD5TmoZFgUdUDHYrJIHK0zfHVhvRRWVmjG9jWLSLlX1bIOrD0vq+EOU2+hi8zHiYY9HxFf2xiDNRM0t+KpULR41j5huyaQHiitd5KwW+uG+iSzGxG96PRr0tkqXI6CIJYzDis4m1zWkpc/Hijt7se4ERCcmTx5sawAEUmI39O8fkNbbAXrOC+FdCXfj2V4VbX/bIYSxft1gLHFm6a2Zn/

From: leedongha <gapdev2004@gmail.com>

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
Gyujeong Jin (@G1uN4sh)
Daehyeon Ko (@4ncienth)
Geonha Lee (@leegn4a)
Hyungyu Oh (@DQPC_lover)
Jaewon Yang (@R4mbb1)

Signed-off-by: leedongha <gapdev2004@gmail.com>
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

