From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 04/27] arm64: Port deprecated instruction emulation to new
 sysctl interface
Date: Fri, 18 Aug 2017 13:09:21 +0100
Message-ID: <87mv6xhyby.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-5-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 099A749C75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 08:07:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E-KnHODrOxsR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Aug 2017 08:07:35 -0400 (EDT)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98F3A49C55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 08:07:34 -0400 (EDT)
Received: by mail-wr0-f177.google.com with SMTP id 49so59791159wrw.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 05:09:23 -0700 (PDT)
In-reply-to: <1502280338-23002-5-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IEN1cnJlbnRseSwg
YXJtdjhfZGVwcmVjdGVkLmMgdGFrZXMgY2hhcmdlIG9mIHRoZSAiYWJpIiBzeXNjdGwKPiBkaXJl
Y3RvcnksIHdoaWNoIG1ha2VzIGxpZmUgZGlmZmljdWx0IGZvciBvdGhlciBjb2RlIHRoYXQgd2Fu
dHMgdG8KPiByZWdpc3RlciBzeXNjdGxzIGluIHRoZSBzYW1lIGRpcmVjdG9yeS4KPgo+IFRoZXJl
IGlzIGEgIm5ldyIgWzFdIHN5c2N0bCByZWdpc3RyYXRpb24gaW50ZXJmYWNlIHRoYXQgcmVtb3Zl
cyB0aGUKPiBuZWVkIHRvIGRlZmluZSBjdGxfdGFibGVzIGZvciBwYXJlbnQgZGlyZWN0b3JpZXMg
ZXhwbGljaXRseSwgd2hpY2gKPiBpcyBpZGVhbCBoZXJlLgo+Cj4gVGhpcyBwYXRjaCBwb3J0cyBy
ZWdpc3Rlcl9pbnNuX2VtdWxhdGlvbl9zeXNjdGwoKSBvdmVyIHRvIHRoZQo+IHJlZ2lzdGVyX3N5
c2N0bCgpIGludGVyZmFjZSBhbmQgcmVtb3ZlcyB0aGUgcmVkdW5kYW50IGN0bF90YWJsZSBmb3IK
PiAiYWJpIi4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0u
Y29tPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
Cj4KPiBbMV0gZmVhNDc4ZDQxMDFhIChzeXNjdGw6IEFkZCByZWdpc3Rlcl9zeXNjdGwgZm9yIG5v
cm1hbCBzeXNjdGwKPiB1c2VycykKPiBUaGUgY29tbWl0IG1lc3NhZ2Ugbm90ZXMgYW4gaW50ZW50
IHRvIHBvcnQgdXNlcnMgb2YgdGhlCj4gcHJlLWV4aXN0aW5nIGludGVyZmFjZXMgb3ZlciB0byBy
ZWdpc3Rlcl9zeXNjdGwoKSwgdGhvdWdoIHRoZQo+IG51bWJlciBvZiB1c2VycyBvZiB0aGUgbmV3
IGludGVyZmFjZSBjdXJyZW50bHkgYXBwZWFycyBuZWdsaWdpYmxlLgo+IC0tLQo+ICBhcmNoL2Fy
bTY0L2tlcm5lbC9hcm12OF9kZXByZWNhdGVkLmMgfCAxNSArKystLS0tLS0tLS0tLS0KPiAgMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvYXJtdjhfZGVwcmVjYXRlZC5jIGIvYXJjaC9hcm02NC9r
ZXJuZWwvYXJtdjhfZGVwcmVjYXRlZC5jCj4gaW5kZXggZjBlNmQ3MS4uZTE1ZWIyZCAxMDA2NDQK
PiAtLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9hcm12OF9kZXByZWNhdGVkLmMKPiArKysgYi9hcmNo
L2FybTY0L2tlcm5lbC9hcm12OF9kZXByZWNhdGVkLmMKPiBAQCAtMjI4LDE1ICsyMjgsNyBAQCBz
dGF0aWMgaW50IGVtdWxhdGlvbl9wcm9jX2hhbmRsZXIoc3RydWN0IGN0bF90YWJsZSAqdGFibGUs
IGludCB3cml0ZSwKPiAgCXJldHVybiByZXQ7Cj4gIH0KPgo+IC1zdGF0aWMgc3RydWN0IGN0bF90
YWJsZSBjdGxfYWJpW10gPSB7Cj4gLQl7Cj4gLQkJLnByb2NuYW1lID0gImFiaSIsCj4gLQkJLm1v
ZGUgPSAwNTU1LAo+IC0JfSwKPiAtCXsgfQo+IC19Owo+IC0KPiAtc3RhdGljIHZvaWQgX19pbml0
IHJlZ2lzdGVyX2luc25fZW11bGF0aW9uX3N5c2N0bChzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSkK
PiArc3RhdGljIHZvaWQgX19pbml0IHJlZ2lzdGVyX2luc25fZW11bGF0aW9uX3N5c2N0bCh2b2lk
KQo+ICB7Cj4gIAl1bnNpZ25lZCBsb25nIGZsYWdzOwo+ICAJaW50IGkgPSAwOwo+IEBAIC0yNjIs
OCArMjU0LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IHJlZ2lzdGVyX2luc25fZW11bGF0aW9uX3N5
c2N0bChzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSkKPiAgCX0KPiAgCXJhd19zcGluX3VubG9ja19p
cnFyZXN0b3JlKCZpbnNuX2VtdWxhdGlvbl9sb2NrLCBmbGFncyk7Cj4KPiAtCXRhYmxlLT5jaGls
ZCA9IGluc25zX3N5c2N0bDsKPiAtCXJlZ2lzdGVyX3N5c2N0bF90YWJsZSh0YWJsZSk7Cj4gKwly
ZWdpc3Rlcl9zeXNjdGwoImFiaSIsIGluc25zX3N5c2N0bCk7Cj4gIH0KPgo+ICAvKgo+IEBAIC02
NDQsNyArNjM1LDcgQEAgc3RhdGljIGludCBfX2luaXQgYXJtdjhfZGVwcmVjYXRlZF9pbml0KHZv
aWQpCj4gIAljcHVocF9zZXR1cF9zdGF0ZV9ub2NhbGxzKENQVUhQX0FQX0FSTTY0X0lTTkRFUF9T
VEFSVElORywKPiAgCQkJCSAgImFybTY0L2lzbmRlcDpzdGFydGluZyIsCj4gIAkJCQkgIHJ1bl9h
bGxfaW5zbl9zZXRfaHdfbW9kZSwgTlVMTCk7Cj4gLQlyZWdpc3Rlcl9pbnNuX2VtdWxhdGlvbl9z
eXNjdGwoY3RsX2FiaSk7Cj4gKwlyZWdpc3Rlcl9pbnNuX2VtdWxhdGlvbl9zeXNjdGwoKTsKPgo+
ICAJcmV0dXJuIDA7Cj4gIH0KCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
