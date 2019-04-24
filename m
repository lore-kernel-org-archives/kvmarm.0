From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Date: Wed, 24 Apr 2019 09:21:57 +0000
Message-ID: <87k1fjwyfe.fsf@zen.linaroharston>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 540354A44D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:22:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OOL-zSKzY7Q0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 05:21:59 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 612724A41C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:21:59 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id c6so18406573wrm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 02:21:59 -0700 (PDT)
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
cmV3IEpvbmVzJwo+IHJldmlldy4KCkRvZXMgdGhpcyBtZWFuIHRoZXNlIHdvbid0IGdldCBtZXJn
ZWQgaW50byB0aGUgb3JpZ2luYWwgc2VyaWVzIGJlZm9yZQp0aGUgZmluYWwgbWVyZ2luZyB1cHN0
cmVhbT8KCjxzbmlwPgoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
