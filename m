From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Fri, 6 Jul 2018 10:23:13 +0100
Message-ID: <CAFEAcA8NQFvHzgCvCQBmq7us4PvqSFK2Le=pMiz5dE4D3WGXdQ@mail.gmail.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <87h8lc93jc.fsf@linaro.org> <20180706090534.GD26019@e103592.cambridge.arm.com>
 <87d0w090vv.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 951DD49F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:11:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aqezM7xTR7HA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 05:11:01 -0400 (EDT)
Received: from mail-oi0-f65.google.com (mail-oi0-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB8DE49F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:11:01 -0400 (EDT)
Received: by mail-oi0-f65.google.com with SMTP id n84-v6so22231456oib.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 02:23:34 -0700 (PDT)
In-Reply-To: <87d0w090vv.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gNiBKdWx5IDIwMTggYXQgMTA6MjAsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4gRm9yIHRoZSBtb3N0IHBhcnQgaW4gUUVNVSB3aXRoIEtWTSB3ZSBqdXN0
IHRyZWF0IHRoZSBsaXN0IG9mIHJlZ2lzdGVycwo+IHdlIGdldCBmcm9tIHRoZSBPUyBhcyBhbiBv
cGFxdWUgYmxvYiBvZiB0aGluZ3Mgd2Ugc2F2ZSB0byBtZW1vcnkgYW5kCj4gcGFzcyBiYWNrLgoK
VGhpcyBpcyBzcGVjaWZpY2FsbHkgbm90IHRoZSBjYXNlIGZvciB0aGUgU1ZFIHJlZ2lzdGVycyAt
LSB3ZQp3aWxsIG5lZWQgZXh0cmEgY29kZSB0byBoYW5kbGUgdGhlbS4gKFRoZSBjdXJyZW50IGNv
ZGUgb25seQphbGxvd3MgZm9yIHRoZSBwb3NzaWJpbGl0eSBvZiA2NC1iaXQgcmVnaXN0ZXJzLCBz
byBpZiB3ZSdkCmFsbG93ZWQgdGhlIGtlcm5lbCB0byBoYW5kIGl0IHRoZSBsYXJnZXIgU1ZFIHJl
Z2lzdGVycyBpdCB3b3VsZApqdXN0IGhhdmUgZmFsbGVuIG92ZXIuIFRoaXMgaXMgd2h5IFFFTVUg
bmVlZHMgdG8gc3BlY2lmaWNhbGx5CmVuYWJsZSBTVkUgdmlhIHRoZSBWQ1BVX0lOSVQgY2FsbC4p
Cgp0aGFua3MKLS0gUE1NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
