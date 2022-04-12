Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A93C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:32:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 044944B28D;
	Tue, 12 Apr 2022 09:32:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EwT0WFAg5J+u; Tue, 12 Apr 2022 09:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDA34B2A4;
	Tue, 12 Apr 2022 09:32:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B940D4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8nevKgli1G2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9838F4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A1BD153B;
 Tue, 12 Apr 2022 06:32:40 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CDEC53F70D;
 Tue, 12 Apr 2022 06:32:38 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 02/11] linux/bitops.h: Include wordsize.h to
 provide the __WORDSIZE define
Date: Tue, 12 Apr 2022 14:32:22 +0100
Message-Id: <20220412133231.35355-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

VHJ5aW5nIHRvIGJ1aWxkIGEgc291cmNlIGZpbGUgd2hpY2ggaW5jbHVkZWQgYml0b3BzLmgsIGJ1
dCBkaWRuJ3QgYWxzbwpicmluZyBpbiB0aGUgZGVmaW5pdGlvbiBmb3IgX19XT1JEU0laRSAoYnkg
aW5jbHVkaW5nIGxpbWl0cy5oLCBmb3IgZXhhbXBsZSkKd291bGQgcmVzdWx0IGluIHRoZSBmb2xs
b3dpbmcgZXJyb3I6CgppbmNsdWRlL2xpbnV4L2JpdG9wcy5oOjg6MjM6IGVycm9yOiDigJhfX1dP
UkRTSVpF4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKQogICAgOCB8
ICNkZWZpbmUgQklUU19QRVJfTE9ORyBfX1dPUkRTSVpFCiAgICAgIHwgICAgICAgICAgICAgICAg
ICAgICAgIF5+fn5+fn5+fn4KClRoZSBzeW1ib2wgaXMgZGVmaW5lZCBpbiB0aGUgYml0cy93b3Jk
c2l6ZS5oIGhlYWRlciBmaWxlLCBpbmNsdWRlIGl0LgoKU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1
IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgotLS0KIGluY2x1ZGUvbGludXgvYml0
b3BzLmggfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9iaXRvcHMuaCBiL2luY2x1ZGUvbGludXgvYml0b3BzLmgKaW5kZXgg
NTY0NDhiNzFlYmJmLi4zZDMxZjBhY2Y0OGUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvYml0
b3BzLmgKKysrIGIvaW5jbHVkZS9saW51eC9iaXRvcHMuaApAQCAtMSw2ICsxLDggQEAKICNpZm5k
ZWYgX0tWTV9MSU5VWF9CSVRPUFNfSF8KICNkZWZpbmUgX0tWTV9MSU5VWF9CSVRPUFNfSF8KIAor
I2luY2x1ZGUgPGJpdHMvd29yZHNpemUuaD4KKwogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgog
I2luY2x1ZGUgPGxpbnV4L2NvbXBpbGVyLmg+CiAjaW5jbHVkZSA8YXNtL2h3ZWlnaHQuaD4KLS0g
CjIuMjUuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
