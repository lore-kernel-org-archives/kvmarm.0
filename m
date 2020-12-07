Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C04C4167B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:44:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66A5E23731
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66A5E23731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 043B64B23C;
	Mon,  7 Dec 2020 10:44:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TKPg2efNg9bw; Mon,  7 Dec 2020 10:43:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77924B274;
	Mon,  7 Dec 2020 10:43:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8FE4B23E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:43:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kjNyQeZgrpeH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 10:43:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A5A64B23C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:43:56 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0AE3623731;
 Mon,  7 Dec 2020 15:43:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kmIg4-00GnaT-LN; Mon, 07 Dec 2020 15:43:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] arm64: Work around broken GCC handling of "S" constraint
Date: Mon,  7 Dec 2020 15:43:41 +0000
Message-Id: <20201207154341.1004276-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, catalin.marinas@arm.com,
 ardb@kernel.org, dbradzil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, dbradzil@google.com,
 Will Deacon <will@kernel.org>, ardb@kernel.org, kernel-team@android.com
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
ZSBjYW4gZmFsbGJhY2sgdG8gdGhlICJpIiBjb25zdHJhaW50IGluIHRoYXQgY2FzZSwgd2hpY2gK
KnNlZW1zKiB0byBkbyB0aGUgcmlnaHQgdGhpbmcuIEhvcGVmdWxseSB3ZSB3aWxsIGJlIGFibGUg
dG8KcmVtb3ZlIHRoaXMgYXQgc29tZSBwb2ludCwgYnV0IGluIHRoZSBtZWFudGltZSB0aGlzIGdl
dHMgdXMgZ29pbmcuCgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
PgotLS0KIGFyY2gvYXJtNjQvTWFrZWZpbGUgICAgICAgICAgICAgIHwgOSArKysrKysrKysKIGFy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oIHwgOCArKysrKysrLQogMiBmaWxlcyBjaGFu
Z2VkLCAxNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9NYWtlZmlsZSBiL2FyY2gvYXJtNjQvTWFrZWZpbGUKaW5kZXggNTc4OWMyZDE4ZDQzLi5j
NGVlOGU2NGFkMWEgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvTWFrZWZpbGUKKysrIGIvYXJjaC9h
cm02NC9NYWtlZmlsZQpAQCAtNDQsMTIgKzQ0LDIxIEBAIGNjX2hhc19rX2NvbnN0cmFpbnQgOj0g
JChjYWxsIHRyeS1ydW4sZWNobwkJCQlcCiAJCXJldHVybiAwOwkJCQkJCVwKIAl9JyB8ICQoQ0Mp
IC1TIC14IGMgLW8gIiQkVE1QIiAtLCwtRENPTkZJR19DQ19IQVNfS19DT05TVFJBSU5UPTEpCiAK
K2NjX2hhc19icm9rZW5fc19jb25zdHJhaW50IDo9ICQoY2FsbCB0cnktcnVuLGVjaG8JCQlcCisJ
J3ZvaWQgKmZvbyh2b2lkKSB7CQkJCQkJXAorCQlzdGF0aWMgaW50IHg7CQkJCQkJXAorCQlpbnQg
KmFkZHI7CQkJCQkJXAorCQlhc20oImFkcnAgJTAsICUxIiA6ICI9ciIgKGFkZHIpIDogIlMiICgm
eCkpOwkJXAorCQlyZXR1cm4gYWRkcjsJCQkJCQlcCisJfScgfCAkKENDKSAtUyAteCBjIC1jIC1P
MiAtbyAiJCRUTVAiIC0sLC1EQ09ORklHX0NDX0hBU19CUk9LRU5fU19DT05TVFJBSU5UPTEpCisK
IGlmZXEgKCQoQ09ORklHX0JST0tFTl9HQVNfSU5TVCkseSkKICQod2FybmluZyBEZXRlY3RlZCBh
c3NlbWJsZXIgd2l0aCBicm9rZW4gLmluc3Q7IGRpc2Fzc2VtYmx5IHdpbGwgYmUgdW5yZWxpYWJs
ZSkKIGVuZGlmCiAKIEtCVUlMRF9DRkxBR1MJKz0gLW1nZW5lcmFsLXJlZ3Mtb25seQlcCiAJCSAg
ICQoY29tcGF0X3Zkc28pICQoY2NfaGFzX2tfY29uc3RyYWludCkKK0tCVUlMRF9DRkxBR1MJKz0g
JChjY19oYXNfYnJva2VuX3NfY29uc3RyYWludCkKIEtCVUlMRF9DRkxBR1MJKz0gJChjYWxsIGNj
LWRpc2FibGUtd2FybmluZywgcHNhYmkpCiBLQlVJTERfQUZMQUdTCSs9ICQoY29tcGF0X3Zkc28p
CiAKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oIGIvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1fYXNtLmgKaW5kZXggN2NjZjc3MGM1M2Q5Li5mYThlODg2OTk4
YTMgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCisrKyBiL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCkBAIC0xOTksNiArMTk5LDEyIEBAIGV4dGVy
biB2b2lkIF9fdmdpY192M19pbml0X2xycyh2b2lkKTsKIAogZXh0ZXJuIHUzMiBfX2t2bV9nZXRf
bWRjcl9lbDIodm9pZCk7CiAKKyNpZmRlZiBDT05GSUdfQ0NfSEFTX0JST0tFTl9TX0NPTlNUUkFJ
TlQKKyNkZWZpbmUgU1lNX0NPTlNUUkFJTlQJImkiCisjZWxzZQorI2RlZmluZSBTWU1fQ09OU1RS
QUlOVAkiUyIKKyNlbmRpZgorCiAvKgogICogT2J0YWluIHRoZSBQQy1yZWxhdGl2ZSBhZGRyZXNz
IG9mIGEga2VybmVsIHN5bWJvbAogICogczogc3ltYm9sCkBAIC0yMTUsNyArMjIxLDcgQEAgZXh0
ZXJuIHUzMiBfX2t2bV9nZXRfbWRjcl9lbDIodm9pZCk7CiAJCXR5cGVvZihzKSAqYWRkcjsJCQkJ
CVwKIAkJYXNtKCJhZHJwCSUwLCAlMVxuIgkJCQlcCiAJCSAgICAiYWRkCSUwLCAlMCwgOmxvMTI6
JTFcbiIJCQlcCi0JCSAgICA6ICI9ciIgKGFkZHIpIDogIlMiICgmcykpOwkJCQlcCisJCSAgICA6
ICI9ciIgKGFkZHIpIDogU1lNX0NPTlNUUkFJTlQgKCZzKSk7CQlcCiAJCWFkZHI7CQkJCQkJCVwK
IAl9KQogCi0tIAoyLjI5LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
