From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 04/16] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Fri, 06 Jul 2018 10:21:25 +0100
Message-ID: <87a7r490tm.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-5-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F7F49F86
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0ZHrHf9MEoP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 05:08:55 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EB9449F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:08:55 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id k7-v6so3472526wrq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 02:21:27 -0700 (PDT)
In-reply-to: <1529593060-542-5-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IGt2bV9ob3N0Lmgg
dXNlcyBERUNMQVJFX0JJVE1BUCgpIHRvIGRlY2xhcmUgdGhlIGZlYXR1cmVzIG1lbWJlciBvZgo+
IHN0cnVjdCB2Y3B1X2FyY2gsIGJ1dCB0aGUgY29ycmVzcG9uZGluZyAjaW5jbHVkZSBmb3IgdGhp
cyBpcwo+IG1pc3NpbmcuCj4KPiBUaGlzIHBhdGNoIGFkZHMgYSBzdWl0YWJsZSAjaW5jbHVkZSBm
b3IgPGxpbnV4L2JpdG1hcC5oPi4gIEFsdGhvdWdoCj4gdGhlIGhlYWRlciBidWlsZHMgd2l0aG91
dCBpdCB0b2RheSwgdGhpcyBzaG91bGQgaGVscCB0byBhdm9pZAo+IGZ1dHVyZSBzdXJwcmlzZXMu
Cj4KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KClJl
dmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cgo+IC0tLQo+
ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAxICsKPiAgMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspCj4KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4gaW5kZXgg
ZmU4Nzc3Yi4uOTJkNmU4OCAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgKPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiBAQCAt
MjIsNiArMjIsNyBAQAo+ICAjaWZuZGVmIF9fQVJNNjRfS1ZNX0hPU1RfSF9fCj4gICNkZWZpbmUg
X19BUk02NF9LVk1fSE9TVF9IX18KPgo+ICsjaW5jbHVkZSA8bGludXgvYml0bWFwLmg+Cj4gICNp
bmNsdWRlIDxsaW51eC90eXBlcy5oPgo+ICAjaW5jbHVkZSA8bGludXgva3ZtX3R5cGVzLmg+Cj4g
ICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5oPgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
