From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 08/23] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Thu, 15 Nov 2018 15:44:18 +0000
Message-ID: <87h8gicpm5.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC114A32C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 10:44:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PmVjNbFRQqQT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 10:44:21 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64C5C4A311
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 10:44:21 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id f2-v6so18367434wme.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 07:44:21 -0800 (PST)
In-reply-to: <1538141967-15375-9-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFNpbmNlIFNWRSB3
aWxsIGJlIGVuYWJsZWQgb3IgZGlzYWJsZWQgb24gYSBwZXItdmNwdSBiYXNpcywgYSBmbGFnCj4g
aXMgbmVlZGVkIGluIG9yZGVyIHRvIHRyYWNrIHdoaWNoIHZjcHVzIGhhdmUgaXQgZW5hYmxlZC4K
Pgo+IFRoaXMgcGF0Y2ggYWRkcyBhIHN1aXRhYmxlIGZsYWcgYW5kIGEgaGVscGVyIGZvciBjaGVj
a2luZyBpdC4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0u
Y29tPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
Cj4gLS0tCj4KPiBDaGFuZ2VzIHNpbmNlIFJGQ3YxOgo+Cj4gICogQ29udmVydCB2Y3B1X2hhc19z
dmUoKSB0byBhIG1hY3JvIHNvIHRoYXQgaXQgY2FuIG9wZXJhdGUgb24gYSB2Y3B1Cj4gICAgd2l0
aG91dCBjaXJjdWxhciBoZWFkZXIgZGVwZW5kZW5jeSBwcm9ibGVtcy4KPgo+ICAgIFRoaXMgYXZv
aWRzIHRoZSBoZWxwZXIgcmVxdWlyaW5nIGEgdmNwdV9hcmNoIGFyZ3VtZW50LCB3aGljaCB3YXMK
PiAgICBhIGxpdHRsZSB1Z2x5Lgo+IC0tLQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmggfCA0ICsrKysKPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQo+Cj4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+IGluZGV4IGQ0YjY1NDE0Li4yMGJhZjRhIDEwMDY0NAo+
IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+ICsrKyBiL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+IEBAIC0zMDcsNiArMzA3LDEwIEBAIHN0cnVjdCBr
dm1fdmNwdV9hcmNoIHsKPiAgI2RlZmluZSBLVk1fQVJNNjRfRlBfSE9TVAkJKDEgPDwgMikgLyog
aG9zdCBGUCByZWdzIGxvYWRlZCAqLwo+ICAjZGVmaW5lIEtWTV9BUk02NF9IT1NUX1NWRV9JTl9V
U0UJKDEgPDwgMykgLyogYmFja3VwIGZvciBob3N0IFRJRl9TVkUgKi8KPiAgI2RlZmluZSBLVk1f
QVJNNjRfSE9TVF9TVkVfRU5BQkxFRAkoMSA8PCA0KSAvKiBTVkUgZW5hYmxlZCBmb3IgRUwwICov
Cj4gKyNkZWZpbmUgS1ZNX0FSTTY0X0dVRVNUX0hBU19TVkUJCSgxIDw8IDUpIC8qIFNWRSBleHBv
c2VkIHRvIGd1ZXN0ICovCj4gKwo+ICsjZGVmaW5lIHZjcHVfaGFzX3N2ZSh2Y3B1KSAoc3lzdGVt
X3N1cHBvcnRzX3N2ZSgpICYmIFwKPiArCQkJICAgICgodmNwdSktPmFyY2guZmxhZ3MgJiBLVk1f
QVJNNjRfR1VFU1RfSEFTX1NWRSkpCj4KPiAgI2RlZmluZSB2Y3B1X2dwX3JlZ3ModikJCSgmKHYp
LT5hcmNoLmN0eHQuZ3BfcmVncykKCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
