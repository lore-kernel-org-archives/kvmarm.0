From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 06/27] arm64/sve: System register and exception syndrome
 definitions
Date: Mon, 21 Aug 2017 15:50:32 +0100
Message-ID: <871so55613.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-7-git-send-email-Dave.Martin@arm.com>
 <87a82t5kos.fsf@linaro.org> <8760dh5cbl.fsf@linaro.org>
 <20170821142627.GQ6321@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B23849C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 10:48:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id txjUAeo-lbFj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Aug 2017 10:48:40 -0400 (EDT)
Received: from mail-wr0-f169.google.com (mail-wr0-f169.google.com
 [209.85.128.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F166949C0F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 10:48:39 -0400 (EDT)
Received: by mail-wr0-f169.google.com with SMTP id f8so65191713wrf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 07:50:34 -0700 (PDT)
In-reply-to: <20170821142627.GQ6321@e103592.cambridge.arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIE1vbiwgQXVn
IDIxLCAyMDE3IGF0IDAxOjM0OjM4UE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPiB3cml0ZXM6Cj4+Cj4+ID4gRGF2
ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPgo+IFsuLi5dCj4KPj4gT0sg
bm8gSSdtIHdvcmtpbmcgZGlyZWN0bHkgZnJvbSB0aGUgdW5wYWNrZWQgWklQIGZpbGUgd2l0aCB0
aGUgcmVzdCBvZgo+PiB0aGUgZGV0YWlscyBJIHRoaW5rIHRoaXMgc2hvdWxkIGJlOgo+Pgo+PiAg
ICNkZWZpbmUgU1lTX1pDUl9FTDIJCQlzeXNfcmVnKDMsIDUsIDEsIDIsIDApCj4+Cj4+IGUuZy4g
b3AxID0gMTAxIC8gNQo+Cj4gTm8sIHRoYXQncyB0aGUgZW5jb2RpbmcgZm9yIFpDUl9FTDEyLiAg
V2hlcmUgZGlkIHlvdSBnZXQgdGhpcyBmcm9tPwoKU29ycnkgbXkgbWlzdGFrZSwgLUVUT09NQU5Z
QklUVEFCTEVTLi4uLgoKPgo+IChUaGlzIGVuY29kaW5nIGZvbGxvd3MgdGhlIGdlbmVyYWwgcGF0
dGVybiBvZiB0aGUgdjguMSBWaXJ0dWFsaXphdGlvbgo+IEhvc3QgRXh0ZW5zaW9ucy4pCj4KPiBb
Li4uXQo+Cj4+ID4+ICsjZGVmaW5lIFpDUl9FTHhfTEVOX1NISUZUCTAKPj4gPj4gKyNkZWZpbmUg
WkNSX0VMeF9MRU5fU0laRQk5Cj4+ID4+ICsjZGVmaW5lIFpDUl9FTHhfTEVOX01BU0sJMHgxZmYK
Pj4gPj4gKwo+Pgo+PiBMRU4gc2hvdWxkIGJlIDAvNC8weGYKPj4KPj4gTEVOLCBiaXRzIFszOjBd
Cj4+Cj4+IENvbnN0cmFpbnMgdGhlIHNjYWxhYmxlIHZlY3RvciByZWdpc3RlciBsZW5ndGggZm9y
IEVMMSBhbmQgRUwwIHRvCj4+IChMRU4rMSl4MTI4IGJpdHMuCj4KPiBUaGUgU1ZFIHN1cHBsZW1l
bnQgaXMgbm90IHZlcnkgZXhwbGljaXQgYWJvdXQgdGhlIG1lYW5pbmcgb2YgYml0cyBbODo0XSwK
PiBidXQgdGhleSBhcmUgcmVzZXJ2ZWQgdG8gZXh0ZW5kIHRoZSBMRU4gZmllbGQgaW4gdGhlIGZ1
dHVyZSwgaW4gY2FzZQo+IHRoYXQncyBldmVyIG5lZWRlZCBmb3IgZnV0dXJlIGFyY2hpdGVjdHVy
ZSByZXZpc2lvbnMuICBJJ3ZlIGFpbWVkIGZvcgo+IExpbnV4IHRvIGNvcGUgd2l0aCB0aGlzLgo+
Cj4gQmFzaWNhbGx5IGJpdHMgWzg6NF0gYXJlIHJlYWQtYXMtemVybywgd3JpdGUtaWdub3JlIHRv
ZGF5LCBidXQgaW4KPiB0aGUgZnV0dXJlIHNvbWUgb3IgYWxsIG9mIHRoZW0gbWF5IGJlIExFTiBm
aWVsZCBiaXRzLgo+Cj4gSW4gcGFydGljdWxhciwgdGhpcyBtZWFucyB0aGF0IHdyaXRpbmcgYWxs
IGJpdHMgWzg6MF0gd2l0aCAxIHdpbGwKPiBjb25maWd1cmUgdGhlIGxhcmdlc3Qgc3VwcG9ydGVk
IHZlY3RvciBsZW5ndGgsIGV2ZW4gb24gZnV0dXJlCj4gYXJjaGl0ZWN0dXJlIHZlcnNpb25zIHRo
YXQgbWF5IGhhdmUgYSBsYXJnZXIgTEVOIGZpZWxkLgoKQWhoIG9rLiBJdCdzIG5vdCBjbGVhciBm
cm9tIHRoZSBodG1sIGFuZCBpdCBpcyBjZXJ0YWlubHkgaW1wbGllZCBpbiB0aGUKc3VwcGxlbWVu
dCAoMi4xLjEpIHRoYXQgdGhlIGFyY2hpdGVjdHVyYWwgbWF4IGlzOgoKICBUaGUgc2l6ZSBvZiBl
dmVyeSB2ZWN0b3IgcmVnaXN0ZXIgaXMgYW4gSU1QTEVNRU5UQVRJT04gREVGSU5FRAogIG11bHRp
cGxlIG9mIDEyOCBiaXRzLCB1cCB0byBhbiBhcmNoaXRlY3R1cmFsIG1heGltdW0gb2YgMjA0OCBi
aXRzLgoKPgo+IEl0IGRpZG4ndCBzZWVtIHVzZWZ1bCB0byBkaXN0aW5ndWlzaCB0aGUgdHdvIGNs
YXNzZXMgb2YgYml0cyBoZXJlLgoKTWF5YmUgYSBjb21tZW50IGNsYXJpZnlpbmcgd291bGQgYmUg
dXNlZnVsIHRoZW4/Cgo+Cj4gQ2hlZXJzCj4gLS0tRGF2ZQoKCi0tCkFsZXggQmVubsOpZQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
