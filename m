From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Date: Thu, 25 Apr 2019 13:35:56 +0100
Message-ID: <875zr2w9cj.fsf@zen.linaroharston>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92FDA4A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 08:35:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9vElyI2-fN7m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 08:35:58 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D1724A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 08:35:58 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id h11so3565072wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 05:35:58 -0700 (PDT)
In-reply-to: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoaXMgc2VyaWVz
IGNvbnRhaW5zIHNvbWUgY2xlYW51cHMgYXBwbGljYWJsZSB0byB0aGUgU1ZFIEtWTSBzdXBwb3J0
Cj4gcGF0Y2hlcyBtZXJnZWQgaW50byBrdm1hcm0vbmV4dC4gIFRoZXNlIGFyb3NlIGZyb20gQW5k
cmV3IEpvbmVzJwo+IHJldmlldy4KPgo+IEFwYXJ0IGZyb20gc29tZSBtaW5vciBjaGFuZ2VzIHRv
IGVycm9yIGNvZGVzIGFuZCBjaGVja2luZywgdGhlc2UgYXJlCj4gbW9zdGx5IGNvc21ldGljIC8g
c3l0bGlzdGljIGNoYW5nZXMgb25seS4KPgo+IFRoZSBwYXRjaGVzIGFyZSBiYXNlZCBvbgo+IGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9rdm1hcm0va3ZtYXJt
LmdpdCBuZXh0Cj4gNWQ4ZDRhZjI0NDYwICgiYXJtNjQ6IEtWTTogRml4IHN5c3RlbSByZWdpc3Rl
ciBlbnVtZXJhdGlvbiIpCj4KPiBUaGlzIHNlcmllcyBpbiBnaXQ6Cj4gZ2l0Oi8vbGludXgtYXJt
Lm9yZy9saW51eC1kbS5naXQgc3ZlLWt2bS1maXhlcy92Mi9oZWFkCj4gaHR0cDovL2xpbnV4LWFy
bS5vcmcvZ2l0P3A9bGludXgtZG0uZ2l0O2E9c2hvcnRsb2c7aD1yZWZzL2hlYWRzL3N2ZS1rdm0t
Zml4ZXMvdjIvaGVhZAo+Cj4gVGVzdGVkIHdpdGggcWVtdSBhbmQga3ZtdG9vbCBvbiBUaHVuZGVy
WDIsIGFuZCB3aXRoIGt2bXRvb2wgb24gdGhlIEFybQo+IEZhc3QgbW9kZWwgKHRvIGV4ZXJjaXNl
IFNWRSBzdXBwb3J0KS4KClRoZXNlIGFsbCBsb29rIGdvb2QgdG8gbWU6CgpSZXZpZXdlZC1ieTog
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKLS0KQWxleCBCZW5uw6llCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
