From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Date: Wed, 24 Apr 2019 10:38:25 +0100
Message-ID: <05f53a12-f27a-5c46-4bf8-0a70d7f3b97c@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <87k1fjwyfe.fsf@zen.linaroharston>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 780A54A476
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:38:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mLV810wmHBbU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 05:38:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B844A470
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:38:39 -0400 (EDT)
In-Reply-To: <87k1fjwyfe.fsf@zen.linaroharston>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjQvMDQvMjAxOSAxMDoyMSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IAo+IERhdmUgTWFydGlu
IDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cj4gCj4+IFRoaXMgc2VyaWVzIGNvbnRhaW5z
IHNvbWUgY2xlYW51cHMgYXBwbGljYWJsZSB0byB0aGUgU1ZFIEtWTSBzdXBwb3J0Cj4+IHBhdGNo
ZXMgbWVyZ2VkIGludG8ga3ZtYXJtL25leHQuICBUaGVzZSBhcm9zZSBmcm9tIEFuZHJldyBKb25l
cycKPj4gcmV2aWV3Lgo+IAo+IERvZXMgdGhpcyBtZWFuIHRoZXNlIHdvbid0IGdldCBtZXJnZWQg
aW50byB0aGUgb3JpZ2luYWwgc2VyaWVzIGJlZm9yZQo+IHRoZSBmaW5hbCBtZXJnaW5nIHVwc3Ry
ZWFtPwoKSSd2ZSBxdWV1ZWQgdGhlc2Ugb24gdG9wIG9mIHRoZSBleGlzdGluZyBTVkUgcGF0Y2hl
cy4gSSdtIHF1aXRlIGtlZW4gb24Kbm90IHJlYmFzaW5nIC1uZXh0IGF0IHRoaXMgc3RhZ2UuCgpU
aGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4u
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
