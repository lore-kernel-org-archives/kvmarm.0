Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78547C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 11:11:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C64332389B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 11:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C64332389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27CB24B1A2;
	Thu, 17 Dec 2020 06:11:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JgtR+0p4ktI2; Thu, 17 Dec 2020 06:11:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1799C4B190;
	Thu, 17 Dec 2020 06:11:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA8E4B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 06:11:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6bWuVWr0oEo2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 06:11:53 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A76B14B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 06:11:53 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 621AA2389B;
 Thu, 17 Dec 2020 11:11:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kprCI-0020Cn-7V; Thu, 17 Dec 2020 11:11:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] arm64: Work around broken GCC 4.9 handling of "S" constraint
Date: Thu, 17 Dec 2020 11:11:35 +0000
Message-Id: <20201217111135.1536658-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org,
 ardb@kernel.org, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, kernel-team@android.com
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

R0NDIDQuOSBzZWVtcyB0byBoYXZlIGEgcHJvYmxlbSB3aXRoIHRoZSAiUyIgYXNtIGNvbnN0cmFp
bnQKd2hlbiB0aGUgc3ltYm9sIGxpdmVzIGluIHRoZSBzYW1lIGNvbXBpbGF0aW9uIHVuaXQsIGFu
ZCBwcmV0ZW5kcwp0aGUgY29uc3RyYWludCBpcyBpbXBvc3NpYmxlOgoKJCBjYXQgeC5jCnZvaWQg
KmZvbyh2b2lkKQp7CglzdGF0aWMgaW50IHg7CglpbnQgKmFkZHI7Cglhc20oImFkcnAgJTAsICUx
IiA6ICI9ciIgKGFkZHIpIDogIlMiICgmeCkpOwoJcmV0dXJuIGFkZHI7Cn0KCiQgfi9Xb3JrL2dj
Yy1saW5hcm8tYWFyY2g2NC1saW51eC1nbnUtNC45LTIwMTQuMDlfbGludXgvYmluL2FhcmNoNjQt
bGludXgtZ251LWdjYyAtUyAteCBjIC1PMiB4LmMKeC5jOiBJbiBmdW5jdGlvbiDigJhmb2/igJk6
CnguYzo1OjI6IGVycm9yOiBpbXBvc3NpYmxlIGNvbnN0cmFpbnQgaW4g4oCYYXNt4oCZCiAgYXNt
KCJhZHJwICUwLCAlMSIgOiAiPXIiIChhZGRyKSA6ICJTIiAoJngpKTsKICBeCgpCb28uIEZvbGxv
d2luZyByZXZpc2lvbnMgb2YgdGhlIGNvbXBpbGVyIHdvcmsganVzdCBmaW5lLCB0aG91Z2guCgpX
ZSBjYW4gZmFsbGJhY2sgdG8gdGhlICJpIiBjb25zdHJhaW50IGZvciBHQ0MgdmVyc2lvbiBwcmlv
ciB0byA1LjAsCndoaWNoICpzZWVtcyogdG8gZG8gdGhlIHJpZ2h0IHRoaW5nLiBIb3BlZnVsbHkg
d2Ugd2lsbCBiZSBhYmxlIHRvCnJlbW92ZSB0aGlzIGF0IHNvbWUgcG9pbnQsIGJ1dCBpbiB0aGUg
bWVhbnRpbWUgdGhpcyBnZXRzIHVzIGdvaW5nLgoKU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVy
IDxtYXpAa2VybmVsLm9yZz4KLS0tCiogRnJvbSB2MTogRHJvcHBlZCB0aGUgZGV0ZWN0aW9uIGhh
Y2sgYW5kIHJlbHkgb24gR0NDX1ZFUlNJT04KCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9h
c20uaCB8IDggKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaCBi
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCmluZGV4IDdjY2Y3NzBjNTNkOS4uOGEz
M2Q4M2VhODQzIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaAor
KysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaApAQCAtMTk5LDYgKzE5OSwxMiBA
QCBleHRlcm4gdm9pZCBfX3ZnaWNfdjNfaW5pdF9scnModm9pZCk7CiAKIGV4dGVybiB1MzIgX19r
dm1fZ2V0X21kY3JfZWwyKHZvaWQpOwogCisjaWYgZGVmaW5lZChHQ0NfVkVSU0lPTikgJiYgR0ND
X1ZFUlNJT04gPCA1MDAwMAorI2RlZmluZSBTWU1fQ09OU1RSQUlOVAkiaSIKKyNlbHNlCisjZGVm
aW5lIFNZTV9DT05TVFJBSU5UCSJTIgorI2VuZGlmCisKIC8qCiAgKiBPYnRhaW4gdGhlIFBDLXJl
bGF0aXZlIGFkZHJlc3Mgb2YgYSBrZXJuZWwgc3ltYm9sCiAgKiBzOiBzeW1ib2wKQEAgLTIxNSw3
ICsyMjEsNyBAQCBleHRlcm4gdTMyIF9fa3ZtX2dldF9tZGNyX2VsMih2b2lkKTsKIAkJdHlwZW9m
KHMpICphZGRyOwkJCQkJXAogCQlhc20oImFkcnAJJTAsICUxXG4iCQkJCVwKIAkJICAgICJhZGQJ
JTAsICUwLCA6bG8xMjolMVxuIgkJCVwKLQkJICAgIDogIj1yIiAoYWRkcikgOiAiUyIgKCZzKSk7
CQkJCVwKKwkJICAgIDogIj1yIiAoYWRkcikgOiBTWU1fQ09OU1RSQUlOVCAoJnMpKTsJCVwKIAkJ
YWRkcjsJCQkJCQkJXAogCX0pCiAKLS0gCjIuMjkuMgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
