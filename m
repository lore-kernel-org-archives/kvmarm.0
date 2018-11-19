From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 14/23] KVM: Allow 2048-bit register access via
 ioctl interface
Date: Mon, 19 Nov 2018 16:48:36 +0000
Message-ID: <87r2fhhv2z.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD304A30F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 11:48:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 80Pc8glsb3ZZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Nov 2018 11:48:39 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDC204A303
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 11:48:38 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id p4so23657970wrt.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 08:48:38 -0800 (PST)
In-reply-to: <1538141967-15375-15-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoZSBBcm0gU1ZF
IGFyY2hpdGVjdHVyZSBkZWZpbmVzIHJlZ2lzdGVycyB0aGF0IGFyZSB1cCB0byAyMDQ4IGJpdHMK
PiBpbiBzaXplICh3aXRoIHNvbWUgcG9zc2liaWxpdHkgb2YgZnVydGhlciBmdXR1cmUgZXhwYW5z
aW9uKS4KPgo+IEluIG9yZGVyIHRvIGF2b2lkIHRoZSBuZWVkIGZvciBhbiBleGNlc3NpdmVseSBs
YXJnZSBudW1iZXIgb2YKPiBpb2N0bHMgd2hlbiBzYXZpbmcgYW5kIHJlc3RvcmluZyBhIHZjcHUn
cyByZWdpc3RlcnMsIHRoaXMgcGF0Y2gKPiBhZGRzIGEgI2RlZmluZSB0byBtYWtlIHN1cHBvcnQg
Zm9yIGluZGl2aWR1YWwgMjA0OC1iaXQgcmVnaXN0ZXJzCj4gdGhyb3VnaCB0aGUgS1ZNX3tHRVQs
U0VUfV9PTkVfUkVHIGlvY3RsIGludGVyZmFjZSBvZmZpY2lhbC4gIFRoaXMKPiB3aWxsIGFsbG93
IGVhY2ggU1ZFIHJlZ2lzdGVyIHRvIGJlIGFjY2Vzc2VkIGluIGEgc2luZ2xlIGNhbGwuCj4KPiBU
aGVyZSBhcmUgc3VmZmljaWVudCBzcGFyZSBiaXRzIGluIHRoZSByZWdpc3RlciBpZCBzaXplIGZp
ZWxkIGZvcgo+IHRoaXMgY2hhbmdlLCBzbyB0aGVyZSBpcyBubyBBQkkgaW1wYWN0IHByb3ZpZGlu
ZyB0aGF0Cj4gS1ZNX0dFVF9SRUdfTElTVCBkb2VzIG5vdCBlbnVtZXJhdGUgYW55IDIwNDgtYml0
IHJlZ2lzdGVyIHVubGVzcwo+IHVzZXJzcGFjZSBleHBsaWNpdGx5IG9wdHMgaW4gdG8gdGhlIHJl
bGV2YW50IGFyY2hpdGVjdHVyZS1zcGVjaWZpYwo+IGZlYXR1cmVzLgo+Cj4gU2lnbmVkLW9mZi1i
eTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+Cj4gLS0tCj4gIGluY2x1ZGUvdWFw
aS9saW51eC9rdm0uaCB8IDEgKwo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKPgo+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmgKPiBpbmRleCAyNTFiZTM1Li43YzNjNWNjIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9rdm0uaAo+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaAo+IEBAIC0x
MTEwLDYgKzExMTAsNyBAQCBzdHJ1Y3Qga3ZtX2RpcnR5X3RsYiB7Cj4gICNkZWZpbmUgS1ZNX1JF
R19TSVpFX1UyNTYJMHgwMDUwMDAwMDAwMDAwMDAwVUxMCj4gICNkZWZpbmUgS1ZNX1JFR19TSVpF
X1U1MTIJMHgwMDYwMDAwMDAwMDAwMDAwVUxMCj4gICNkZWZpbmUgS1ZNX1JFR19TSVpFX1UxMDI0
CTB4MDA3MDAwMDAwMDAwMDAwMFVMTAo+ICsjZGVmaW5lIEtWTV9SRUdfU0laRV9VMjA0OAkweDAw
ODAwMDAwMDAwMDAwMDBVTEwKClllYWggT0sgSSBndWVzcyAtIGJ1dCBpdCBkb2VzIG1ha2UgbWUg
cXVlc3Rpb24gaWYgS1ZNX1JFR19TSVpFX01BU0sgaXMKcGFydCBvZiB0aGUgQUJJIGJlY2F1c2Ug
YWx0aG91Z2ggd2UgaGF2ZSBzcGFjZSBmb3IgYW5vdGhlciBmZXcgYml0cyB0aGF0CmlzIHRoZSBs
YXN0IG9uZSB3aXRob3V0IGNoYW5naW5nIHRoZSBtYXNrLgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVu
bsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCj4KPiAgc3RydWN0IGt2bV9yZWdfbGlzdCB7
Cj4gIAlfX3U2NCBuOyAvKiBudW1iZXIgb2YgcmVncyAqLwoKCi0tCkFsZXggQmVubsOpZQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
