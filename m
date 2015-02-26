From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] target-arm: kvm: save/restore mp state
Date: Thu, 26 Feb 2015 13:57:52 +0100
Message-ID: <54EF1850.5050002@redhat.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3192C46AAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 07:52:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gZrAOUNTIHZ2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 07:52:18 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D02C46AA9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 07:52:17 -0500 (EST)
In-Reply-To: <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAyNS8wMi8yMDE1IDE3OjAyLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4gKyNpZiBkZWZpbmVk
IENPTkZJR19LVk0KPiArICAgICAgICB7Cj4gKyAgICAgICAgICAgIC5uYW1lID0gIm1wX3N0YXRl
IiwKPiArICAgICAgICAgICAgLnZlcnNpb25faWQgPSAwLAo+ICsgICAgICAgICAgICAuc2l6ZSA9
IHNpemVvZih1aW50MzJfdCksCj4gKyAgICAgICAgICAgIC5pbmZvID0gJnZtc3RhdGVfbXBzdGF0
ZSwKPiArICAgICAgICAgICAgLmZsYWdzID0gVk1TX1NJTkdMRSwKPiArICAgICAgICAgICAgLm9m
ZnNldCA9IDAsCj4gKyAgICAgICAgfSwKPiArI2VuZGlmCgpUaGlzIG1ha2VzIFRDRyBtaWdyYXRp
b24gc3RhdGUgaW5jb21wYXRpYmxlIGRlcGVuZGluZyBvbiB3aGV0aGVyIFFFTVUKd2FzIGJ1aWx0
IG9uIEFSTSBvciB4ODYuCgpZb3UgY2FuIGluc3RlYWQgYWRkIGEgc3Vic2VjdGlvbiwgYW5kIG1h
cmsgaXQgYXMgbmVlZGVkIG9ubHkgaWZmCmt2bV9lbmFibGVkKCkuCgpQYW9sbwoKPiAgICAgICAg
ICB7Cj4gICAgICAgICAgICAgIC5uYW1lID0gImNwc3IiLApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
