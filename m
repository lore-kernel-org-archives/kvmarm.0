Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE85C04AAA
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF7CB2075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF7CB2075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 970C24A4DC;
	Fri,  3 May 2019 08:45:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uzFtJCyHLg4u; Fri,  3 May 2019 08:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E060D4A51A;
	Fri,  3 May 2019 08:45:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B35034A4D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5P3LyicVKg+n for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFE64A4DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CE40165C;
 Fri,  3 May 2019 05:45:32 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA1073F220;
 Fri,  3 May 2019 05:45:28 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 14/56] KVM: Allow 2048-bit register access via ioctl interface
Date: Fri,  3 May 2019 13:43:45 +0100
Message-Id: <20190503124427.190206-15-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpUaGUgQXJtIFNWRSBhcmNo
aXRlY3R1cmUgZGVmaW5lcyByZWdpc3RlcnMgdGhhdCBhcmUgdXAgdG8gMjA0OCBiaXRzCmluIHNp
emUgKHdpdGggc29tZSBwb3NzaWJpbGl0eSBvZiBmdXJ0aGVyIGZ1dHVyZSBleHBhbnNpb24pLgoK
SW4gb3JkZXIgdG8gYXZvaWQgdGhlIG5lZWQgZm9yIGFuIGV4Y2Vzc2l2ZWx5IGxhcmdlIG51bWJl
ciBvZgppb2N0bHMgd2hlbiBzYXZpbmcgYW5kIHJlc3RvcmluZyBhIHZjcHUncyByZWdpc3RlcnMs
IHRoaXMgcGF0Y2gKYWRkcyBhICNkZWZpbmUgdG8gbWFrZSBzdXBwb3J0IGZvciBpbmRpdmlkdWFs
IDIwNDgtYml0IHJlZ2lzdGVycwp0aHJvdWdoIHRoZSBLVk1fe0dFVCxTRVR9X09ORV9SRUcgaW9j
dGwgaW50ZXJmYWNlIG9mZmljaWFsLiAgVGhpcwp3aWxsIGFsbG93IGVhY2ggU1ZFIHJlZ2lzdGVy
IHRvIGJlIGFjY2Vzc2VkIGluIGEgc2luZ2xlIGNhbGwuCgpUaGVyZSBhcmUgc3VmZmljaWVudCBz
cGFyZSBiaXRzIGluIHRoZSByZWdpc3RlciBpZCBzaXplIGZpZWxkIGZvcgp0aGlzIGNoYW5nZSwg
c28gdGhlcmUgaXMgbm8gQUJJIGltcGFjdCwgcHJvdmlkaW5nIHRoYXQKS1ZNX0dFVF9SRUdfTElT
VCBkb2VzIG5vdCBlbnVtZXJhdGUgYW55IDIwNDgtYml0IHJlZ2lzdGVyIHVubGVzcwp1c2Vyc3Bh
Y2UgZXhwbGljaXRseSBvcHRzIGluIHRvIHRoZSByZWxldmFudCBhcmNoaXRlY3R1cmUtc3BlY2lm
aWMKZmVhdHVyZXMuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJt
LmNvbT4KUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
VGVzdGVkLWJ5OiB6aGFuZy5sZWkgPHpoYW5nLmxlaUBqcC5mdWppdHN1LmNvbT4KU2lnbmVkLW9m
Zi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KLS0tCiBpbmNsdWRlL3Vh
cGkvbGludXgva3ZtLmggfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaCBiL2luY2x1ZGUvdWFwaS9saW51eC9r
dm0uaAppbmRleCA2ZDRlYTRiNmM5MjIuLmRjNzdhNWEzNjQ4ZCAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2t2bS5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaApAQCAtMTE0
NSw2ICsxMTQ1LDcgQEAgc3RydWN0IGt2bV9kaXJ0eV90bGIgewogI2RlZmluZSBLVk1fUkVHX1NJ
WkVfVTI1NgkweDAwNTAwMDAwMDAwMDAwMDBVTEwKICNkZWZpbmUgS1ZNX1JFR19TSVpFX1U1MTIJ
MHgwMDYwMDAwMDAwMDAwMDAwVUxMCiAjZGVmaW5lIEtWTV9SRUdfU0laRV9VMTAyNAkweDAwNzAw
MDAwMDAwMDAwMDBVTEwKKyNkZWZpbmUgS1ZNX1JFR19TSVpFX1UyMDQ4CTB4MDA4MDAwMDAwMDAw
MDAwMFVMTAogCiBzdHJ1Y3Qga3ZtX3JlZ19saXN0IHsKIAlfX3U2NCBuOyAvKiBudW1iZXIgb2Yg
cmVncyAqLwotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
