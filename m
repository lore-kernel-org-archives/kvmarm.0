Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C80C3F68F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 09:41:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D09E42465B
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 09:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/9lLUez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D09E42465B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9794ACD6;
	Thu, 12 Dec 2019 04:41:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wIlZHLTyZOzp; Thu, 12 Dec 2019 04:40:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2614AEAB;
	Thu, 12 Dec 2019 04:40:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A584E4AEA4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 04:40:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gr09XC9R6zM4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 04:40:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F7414ACD6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 04:40:56 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0B37B24654;
 Thu, 12 Dec 2019 09:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1576143655;
 bh=Rr7kCvNdPW3e2IBJnliH3eTMWWlqAlnaKNJfjBbxn3s=;
 h=From:To:Cc:Subject:Date:From;
 b=o/9lLUezdKlavsdvjIBXsTOvuw3E3zZTN9Ja5z0/TirEBSPaaZMc7xjY3+/teFHW3
 b0rQZzbv9qi+ZQsTvG7h3kcnTKxxC32C6lWbH5GKWBCQjcCsO/GB0vRo4HIWv22ja6
 CDlloQV5Yk05Dhr03Isp4flcMUL6DpXqTroiKHPM=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Ensure 'params' is initialised when looking up
 sys register
Date: Thu, 12 Dec 2019 09:40:49 +0000
Message-Id: <20191212094049.12437-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, stable@vger.kernel.org,
 Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Q29tbWl0IDRiOTI3Yjk0ZDVkZiAoIktWTTogYXJtL2FybTY0OiB2Z2ljOiBJbnRyb2R1Y2UgZmlu
ZF9yZWdfYnlfaWQoKSIpCmludHJvZHVjZWQgJ2ZpbmRfcmVnX2J5X2lkKCknLCB3aGljaCBsb29r
cyB1cCBhIHN5c3RlbSByZWdpc3RlciBvbmx5IGlmCnRoZSAnaWQnIGluZGV4IHBhcmFtZXRlciBp
ZGVudGlmaWVzIGEgdmFsaWQgc3lzdGVtIHJlZ2lzdGVyLiBBcyBwYXJ0IG9mCnRoZSBwYXRjaCwg
ZXhpc3RpbmcgY2FsbGVycyBvZiAnZmluZF9yZWcoKScgd2VyZSBwb3J0ZWQgb3ZlciB0byB0aGUg
bmV3CmludGVyZmFjZSwgYnV0IHRoaXMgYnJlYWtzICdpbmRleF90b19zeXNfcmVnX2Rlc2MoKScg
aW4gdGhlIGNhc2UgdGhhdCB0aGUKaW5pdGlhbCBsb29rdXAgaW4gdGhlIHZDUFUgdGFyZ2V0IHRh
YmxlIGZhaWxzIGJlY2F1c2Ugd2Ugd2lsbCB0aGVuIGNhbGwKaW50byAnZmluZF9yZWcoKScgZm9y
IHRoZSBzeXN0ZW0gcmVnaXN0ZXIgdGFibGUgd2l0aCBhbiB1bmluaXRpYWxpc2VkCidwYXJhbScg
YXMgdGhlIGtleSB0byB0aGUgbG9va3VwLgoKR0NDIDEwIGlzIGJyaWdodCBlbm91Z2ggdG8gc3Bv
dCB0aGlzIChhbW9uZ3N0IGEgdG9ubmUgb2YgZmFsc2UgcG9zaXRpdmVzLApidXQgaGV5ISk6Cgog
IHwgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYzogSW4gZnVuY3Rpb24g4oCYaW5kZXhfdG9fc3lz
X3JlZ19kZXNjLnBhcnQuMC5pc3Jh4oCZOgogIHwgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYzo5
ODM6MzM6IHdhcm5pbmc6IOKAmHBhcmFtcy5PcDLigJkgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXpl
ZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdCiAgfCAgIDk4MyB8ICAg
KHUzMikoeCktPkNSbiwgKHUzMikoeCktPkNSbSwgKHUzMikoeCktPk9wMik7CiAgfCBbLi4uXQoK
UmV2ZXJ0IHRoZSBodW5rIG9mIDRiOTI3Yjk0ZDVkZiB3aGljaCBicmVha3MgJ2luZGV4X3RvX3N5
c19yZWdfZGVzYygpJyBzbwp0aGF0IHRoZSBvbGQgYmVoYXZpb3VyIG9mIGNoZWNraW5nIHRoZSBp
bmRleCB1cGZyb250IGlzIHJlc3RvcmVkLgoKQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpD
YzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KQ2M6IFZpamF5YSBLdW1hciBLIDxWaWph
eWEuS3VtYXJAY2F2aXVtLmNvbT4KRml4ZXM6IDRiOTI3Yjk0ZDVkZiAoIktWTTogYXJtL2FybTY0
OiB2Z2ljOiBJbnRyb2R1Y2UgZmluZF9yZWdfYnlfaWQoKSIpClNpZ25lZC1vZmYtYnk6IFdpbGwg
RGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+Ci0tLQogYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8
IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0v
c3lzX3JlZ3MuYwppbmRleCA0NjgyMmFmYzU3ZTAuLjAxYTUxNWUwMTcxZSAxMDA2NDQKLS0tIGEv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYworKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
CkBAIC0yMzYwLDggKzIzNjAsMTEgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2Mg
KmluZGV4X3RvX3N5c19yZWdfZGVzYyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJaWYgKChpZCAm
IEtWTV9SRUdfQVJNX0NPUFJPQ19NQVNLKSAhPSBLVk1fUkVHX0FSTTY0X1NZU1JFRykKIAkJcmV0
dXJuIE5VTEw7CiAKKwlpZiAoIWluZGV4X3RvX3BhcmFtcyhpZCwgJnBhcmFtcykpCisJCXJldHVy
biBOVUxMOworCiAJdGFibGUgPSBnZXRfdGFyZ2V0X3RhYmxlKHZjcHUtPmFyY2gudGFyZ2V0LCB0
cnVlLCAmbnVtKTsKLQlyID0gZmluZF9yZWdfYnlfaWQoaWQsICZwYXJhbXMsIHRhYmxlLCBudW0p
OworCXIgPSBmaW5kX3JlZygmcGFyYW1zLCB0YWJsZSwgbnVtKTsKIAlpZiAoIXIpCiAJCXIgPSBm
aW5kX3JlZygmcGFyYW1zLCBzeXNfcmVnX2Rlc2NzLCBBUlJBWV9TSVpFKHN5c19yZWdfZGVzY3Mp
KTsKIAotLSAKMi4yNC4xLjczNS5nMDNmNGU3MjgxNy1nb29nCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
