Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5549CC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:32:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C440060EB9
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C440060EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A564B11C;
	Mon, 25 Oct 2021 12:32:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MSExNH7sDwbJ; Mon, 25 Oct 2021 12:32:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7EF4B126;
	Mon, 25 Oct 2021 12:32:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1A24B11C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LzfKPt0U3sBR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 12:32:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F87F4B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:32:36 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F6960EB9;
 Mon, 25 Oct 2021 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1635179555;
 bh=O8WFMgy0F5qq/mgu6iWds3x/8uxiyUke0g6QaRFhtqY=;
 h=From:To:Cc:Subject:Date:From;
 b=a4CS1HAF2Vf68K/xknC5SziHYuOYeF7ICJR6HPu2zeHoVqZNa2Sd6DfZz+dS06/5p
 Mee47EC0T+sW2SJJkVeISW4SmNTbw6n+3LI7qfmMIMUqvCPrPPXV1xINQmoL9hv6j7
 +9hGpbSKsO1ZfdSEtj5GH7tHhvfnJbxU5TfH5TotqwFz2JhYvckcWw45mWSAmP/SyY
 bTjVmasIXuJpLSIjPK6IDJGW6q+YVpjajnKGZO/yMClY2Nv9SYBoqFKIc2utKpPnz/
 Fk2K+rJHQ5uN2LDfDM4dV4WxZN0L8VQ4EV4y+JdUkDBxM2e3B/E0hnBCYilF6Z2xK7
 p1wdlhmigGa9Q==
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64/kvm: Fix bitrotted comment for SVE handling in
 handle_exit.c
Date: Mon, 25 Oct 2021 17:32:32 +0100
Message-Id: <20211025163232.3502052-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1037; h=from:subject;
 bh=O8WFMgy0F5qq/mgu6iWds3x/8uxiyUke0g6QaRFhtqY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBhdtoajDC0i8/ujpBY4hVzfxYa5YXZZSkd5RlYfCcI
 V6zvs0uJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYXbaGgAKCRAk1otyXVSH0EAnB/
 9QRHR3zmGGyo0cKfRHBiJ5ZiiKfNeLmcF6e7Q57V9FxAm0H2v9FyvccLkH7bEqwuco2MNwH1keZGEu
 Nidxz++FxnKuNAie/EspK1uOYw3hRJ5pUVvTr7mrzslk48ilevlkHbsUFbDWgo+DkQwm074A4j4L40
 gAyQDk9Eixcdlg8PNLpIZ0E+ByVSM3zpItuZhK106DZUhTqidNtEuvzxUm43WOh6OZ6WIdHr4QPU0Q
 zsQy0rTr4pYSgLUVF/3wg/lQoPM+Imh229bOOCY57OaZ8aQt1/BqZ1ZBL5n3pCQU5/prJweUj0W8t7
 VGc6BbHKOU8tmoIuMuQyP7zdutIEDX
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The comment on the SVE trap handler in handle_exit.c says that it is a
placeholder until we support SVE in guests which we now do for both VHE
and nVHE cases so we really shouldn't get here in any sort of standard
case. Update the comment to be less immediately incorrect, the handling
of such a situation is correct.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..5abe0617f2af 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -140,9 +140,12 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * Guest access to SVE registers should be routed to this handler only
+ * when the system doesn't support SVE.
+ */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
-	/* Until SVE is supported for guests: */
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
