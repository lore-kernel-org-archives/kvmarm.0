Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A912364036;
	Mon, 12 Jan 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.40.203.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768233868; cv=none; b=kiqxXitoXrpKpV+TxfcZLbXCsem8gxSk0xtWabS123mP8Ped48f6LKdom6eLFPkxbY5bY7Cinc6ifl0G/FeCJ27auG35KihKIvP+Ap1N4WAm6VEZgm6RnViB0eXtCyHXLjfH13X8Opn+CmE9GqS3Jmy1EmaJGZbR/zC82ZPW7xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768233868; c=relaxed/simple;
	bh=L3oSihylbwOWrL0ae+O/tBvWeHbgJoxxCKYgMwxI5Kc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=drKNQOo3eaoraA9gXr8f3vRvN2BH8DS3KDdCE9VSkrN0AWgCQAeYSP/UY9pzohIJyq0Phv6V/MFsErwBEIPaNGHuJoGBtwGYkDneUjeB9Ms5rfweVWGyvTRSBt8JkZSbSncZuWSxeMz+/0G8X672aAg5ewVQdwWaeCGwTPH1i+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=t/3ERgCS; arc=none smtp.client-ip=188.40.203.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="t/3ERgCS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=SEhgUjECnk9waqiLf4vh2SAG8fSbncDeiW5IMVeFkBs=; b=t/3ERgCSv452Zu
	si/rfCFRMbdtABlf7EVwIMo8LEK6JoNmfPCNJC09dkQSV28EKnzb6ZqbcilAMhC0b50p71+ltdS2V
	ncQBxPgRsWoEbCqMe8bqMLKcLTMt1hcIUJrpkDgU+2XxU6P/cFx0uTpfpPbd0nLPx7E4rF/DSIKNs
	UVXIcbt8kbRJMAFBNJnBekOwXXiO7WvNDuVn50dtDoXljPCIx8Ye+h0LrcTkUqsK0L/Sn1iHPYUKS
	JD6CaTDxKFO9r9kP0QI4ZFB+czrB1yNE3tEkPYwtOI8pf2ENVlMsyWaAzSVuTu0QUcAhh4yjHKZjb
	OvLu9mvCKLJqWXMzJUFA==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfKOs-00FRCK-HQ; Mon, 12 Jan 2026 16:04:14 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vfKOs-00000002Wzy-0tK8;
	Mon, 12 Jan 2026 16:04:14 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	linux-kernel@vger.kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] KVM: arm64: fix missing <asm/stackpage/nvhe.h> include
Date: Mon, 12 Jan 2026 16:04:13 +0000
Message-Id: <20260112160413.603493-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

Include <asm/stackpage/nvhe.h> for kvm_arm_hyp_stack_base
declaration which fixes the following sparse warning:

arch/arm64/kvm/arm.c:63:1: warning: symbol 'kvm_arm_hyp_stack_base' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm64/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1d..b3543ad2eb44 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -40,6 +40,7 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
+#include <asm/stacktrace/nvhe.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
-- 
2.37.2.352.g3c44437643

