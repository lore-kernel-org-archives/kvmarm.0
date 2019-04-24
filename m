From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 01/27] KVM: Documentation: Document arm64 core
 registers in detail
Date: Wed, 24 Apr 2019 09:25:38 +0000
Message-ID: <87imv3wy99.fsf@zen.linaroharston>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F34104A44D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:25:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cr+CVCA2+R3v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 05:25:40 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B17A44A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 05:25:40 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id f7so1524349wrs.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 02:25:40 -0700 (PDT)
In-reply-to: <1553864452-15080-2-git-send-email-Dave.Martin@arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFNpbmNlIHRoZSB0
aGUgc2l6ZXMgb2YgaW5kaXZpZHVhbCBtZW1iZXJzIG9mIHRoZSBjb3JlIGFybTY0Cj4gcmVnaXN0
ZXJzIHZhcnksIHRoZSBsaXN0IG9mIHJlZ2lzdGVyIGVuY29kaW5ncyB0aGF0IG1ha2Ugc2Vuc2Ug
aXMKPiBub3QgYSBzaW1wbGUgbGluZWFyIHNlcXVlbmNlLgo+Cj4gVG8gY2xhcmlmeSB3aGljaCBl
bmNvZGluZ3MgdG8gdXNlLCB0aGlzIHBhdGNoIGFkZHMgYSBicmllZiBsaXN0Cj4gdG8gdGhlIGRv
Y3VtZW50YXRpb24uCj4KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5A
YXJtLmNvbT4KPiBSZXZpZXdlZC1ieTogSnVsaWVuIEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNv
bT4KPiBSZXZpZXdlZC1ieTogUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3Jn
PgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCj4g
LS0tCj4gIERvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dCB8IDI0ICsrKysrKysrKysr
KysrKysrKysrKysrKwo+ICAxIGZpbGUgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKQo+Cj4gZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vYXBpLnR4dCBiL0RvY3VtZW50YXRp
b24vdmlydHVhbC9rdm0vYXBpLnR4dAo+IGluZGV4IDdkZTllZWUuLjJkNGY3Y2UgMTAwNjQ0Cj4g
LS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0Cj4gKysrIGIvRG9jdW1lbnRh
dGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0Cj4gQEAgLTIxMDcsNiArMjEwNywzMCBAQCBjb250YWlu
cyBlbGVtZW50cyByYW5naW5nIGZyb20gMzIgdG8gMTI4IGJpdHMuIFRoZSBpbmRleCBpcyBhIDMy
Yml0Cj4gIHZhbHVlIGluIHRoZSBrdm1fcmVncyBzdHJ1Y3R1cmUgc2VlbiBhcyBhIDMyYml0IGFy
cmF5Lgo+ICAgIDB4NjB4MCAwMDAwIDAwMTAgPGluZGV4IGludG8gdGhlIGt2bV9yZWdzIHN0cnVj
dDoxNj4KPgo+ICtTcGVjaWZpY2FsbHk6Cj4gKyAgICBFbmNvZGluZyAgICAgICAgICAgIFJlZ2lz
dGVyICBCaXRzICBrdm1fcmVncyBtZW1iZXIKPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICsgIDB4NjAzMCAwMDAwIDAw
MTAgMDAwMCBYMCAgICAgICAgICA2NCAgcmVncy5yZWdzWzBdCj4gKyAgMHg2MDMwIDAwMDAgMDAx
MCAwMDAyIFgxICAgICAgICAgIDY0ICByZWdzLnJlZ3NbMV0KPiArICAgIC4uLgo+ICsgIDB4NjAz
MCAwMDAwIDAwMTAgMDAzYyBYMzAgICAgICAgICA2NCAgcmVncy5yZWdzWzMwXQo+ICsgIDB4NjAz
MCAwMDAwIDAwMTAgMDAzZSBTUCAgICAgICAgICA2NCAgcmVncy5zcAo+ICsgIDB4NjAzMCAwMDAw
IDAwMTAgMDA0MCBQQyAgICAgICAgICA2NCAgcmVncy5wYwo+ICsgIDB4NjAzMCAwMDAwIDAwMTAg
MDA0MiBQU1RBVEUgICAgICA2NCAgcmVncy5wc3RhdGUKPiArICAweDYwMzAgMDAwMCAwMDEwIDAw
NDQgU1BfRUwxICAgICAgNjQgIHNwX2VsMQo+ICsgIDB4NjAzMCAwMDAwIDAwMTAgMDA0NiBFTFJf
RUwxICAgICA2NCAgZWxyX2VsMQo+ICsgIDB4NjAzMCAwMDAwIDAwMTAgMDA0OCBTUFNSX0VMMSAg
ICA2NCAgc3BzcltLVk1fU1BTUl9FTDFdIChhbGlhcyBTUFNSX1NWQykKPiArICAweDYwMzAgMDAw
MCAwMDEwIDAwNGEgU1BTUl9BQlQgICAgNjQgIHNwc3JbS1ZNX1NQU1JfQUJUXQo+ICsgIDB4NjAz
MCAwMDAwIDAwMTAgMDA0YyBTUFNSX1VORCAgICA2NCAgc3BzcltLVk1fU1BTUl9VTkRdCj4gKyAg
MHg2MDMwIDAwMDAgMDAxMCAwMDRlIFNQU1JfSVJRICAgIDY0ICBzcHNyW0tWTV9TUFNSX0lSUV0K
PiArICAweDYwNjAgMDAwMCAwMDEwIDAwNTAgU1BTUl9GSVEgICAgNjQgIHNwc3JbS1ZNX1NQU1Jf
RklRXQo+ICsgIDB4NjA0MCAwMDAwIDAwMTAgMDA1NCBWMCAgICAgICAgIDEyOCAgZnBfcmVncy52
cmVnc1swXQo+ICsgIDB4NjA0MCAwMDAwIDAwMTAgMDA1OCBWMSAgICAgICAgIDEyOCAgZnBfcmVn
cy52cmVnc1sxXQo+ICsgICAgLi4uCj4gKyAgMHg2MDQwIDAwMDAgMDAxMCAwMGQwIFYzMSAgICAg
ICAgMTI4ICBmcF9yZWdzLnZyZWdzWzMxXQo+ICsgIDB4NjAyMCAwMDAwIDAwMTAgMDBkNCBGUFNS
ICAgICAgICAzMiAgZnBfcmVncy5mcHNyCj4gKyAgMHg2MDIwIDAwMDAgMDAxMCAwMGQ1IEZQQ1Ig
ICAgICAgIDMyICBmcF9yZWdzLmZwY3IKPiArCj4gIGFybTY0IENDU0lEUiByZWdpc3RlcnMgYXJl
IGRlbXVsdGlwbGV4ZWQgYnkgQ1NTRUxSIHZhbHVlOgo+ICAgIDB4NjAyMCAwMDAwIDAwMTEgMDAg
PGNzc2Vscjo4PgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
