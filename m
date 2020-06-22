Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FB8C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:25:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41202206FA
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6v4INaI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41202206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04424B0E3;
	Mon, 22 Jun 2020 06:25:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KSiyi7PEwHeK; Mon, 22 Jun 2020 06:25:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A81174B0D1;
	Mon, 22 Jun 2020 06:25:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F754B0CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:25:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zZ7UyIzKaSvP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:25:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0C7E4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:25:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C8D26206E2;
 Mon, 22 Jun 2020 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592821542;
 bh=HAvNwdYJYUv2sMuSO6XMR6c+0C8F1uKoJ7w1PIP5his=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=E6v4INaIw8GQtwIF/kjfeqXi8sJCi2DwspvfaIEZ/pouuiKtPJknhk/ppmc06Pr60
 BM48QHcqEy+z/uMKfHvEd4Tb3Z+OvWejQzb+kqMh1eSVJWKH5orUO7RRspA9RfSHSb
 TDieOjeUZD1avPyFPYbTGSSZAkxGfCfHN4UcM0D8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jnJe1-005Hbf-7u; Mon, 22 Jun 2020 11:25:41 +0100
MIME-Version: 1.0
Date: Mon, 22 Jun 2020 11:25:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
In-Reply-To: <20200622091508.GB88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyaywKCk9uIDIwMjAtMDYtMjIgMTA6MTUsIE1hcmsgUnV0bGFuZCB3cm90ZToKPiBPbiBN
b24sIEp1biAyMiwgMjAyMCBhdCAwOTowNjo0M0FNICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6
Cj4+IFdlIGN1cnJlbnRseSBkZWNpZGUgdG8gZXhlY3V0ZSB0aGUgUHRyQXV0aCBzYXZlL3Jlc3Rv
cmUgY29kZSBiYXNlZAo+PiBvbiBhIHNldCBvZiBicmFuY2hlcyB0aGF0IGV2YWx1YXRlIGFzIChB
Uk02NF9IQVNfQUREUkVTU19BVVRIX0FSQ0ggfHwKPj4gQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9J
TVBfREVGKS4gVGhpcyBjYW4gYmUgZWFzaWx5IHJlcGxhY2VkIGJ5Cj4+IGEgbXVjaCBzaW1wbGVy
IHRlc3QgYXMgdGhlIEFSTTY0X0hBU19BRERSRVNTX0FVVEggY2FwYWJpbGl0eSBpcwo+PiBleGFj
dGx5IHRoaXMgZXhwcmVzc2lvbi4KPj4gCj4+IFN1Z2dlc3RlZC1ieTogTWFyayBSdXRsYW5kIDxt
YXJrLnJ1dGxhbmRAYXJtLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4KPiAKPiBMb29rcyBnb29kIHRvIG1lLiBPbmUgbWlub3Igc3VnZ2VzdGlvbiBi
ZWxvdywgYnV0IGVpdGhlciB3YXk6Cj4gCj4gQWNrZWQtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5y
dXRsYW5kQGFybS5jb20+Cj4gCj4+IC0tLQo+PiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1f
cHRyYXV0aC5oIHwgMjYgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0KPj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQo+PiAKPj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX3B0cmF1dGguaCAKPj4gYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2t2bV9wdHJhdXRoLmgKPj4gaW5kZXggZjE4MzAxNzNmYTllLi43YTcyNTA4YTg0
MWIgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX3B0cmF1dGguaAo+
PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9wdHJhdXRoLmgKPj4gQEAgLTYxLDQ0
ICs2MSwzNiBAQAo+PiAKPj4gIC8qCj4+ICAgKiBCb3RoIHB0cmF1dGhfc3dpdGNoX3RvX2d1ZXN0
IGFuZCBwdHJhdXRoX3N3aXRjaF90b19ob3N0IG1hY3JvcyAKPj4gd2lsbAo+PiAtICogY2hlY2sg
Zm9yIHRoZSBwcmVzZW5jZSBvZiBvbmUgb2YgdGhlIGNwdWZlYXR1cmUgZmxhZwo+PiAtICogQVJN
NjRfSEFTX0FERFJFU1NfQVVUSF9BUkNIIG9yIEFSTTY0X0hBU19BRERSRVNTX0FVVEhfSU1QX0RF
RiBhbmQKPj4gKyAqIGNoZWNrIGZvciB0aGUgcHJlc2VuY2UgQVJNNjRfSEFTX0FERFJFU1NfQVVU
SCwgd2hpY2ggaXMgZGVmaW5lZCBhcwo+PiArICogKEFSTTY0X0hBU19BRERSRVNTX0FVVEhfQVJD
SCB8fCBBUk02NF9IQVNfQUREUkVTU19BVVRIX0lNUF9ERUYpIAo+PiBhbmQKPj4gICAqIHRoZW4g
cHJvY2VlZCBhaGVhZCB3aXRoIHRoZSBzYXZlL3Jlc3RvcmUgb2YgUG9pbnRlciBBdXRoZW50aWNh
dGlvbgo+PiAtICoga2V5IHJlZ2lzdGVycy4KPj4gKyAqIGtleSByZWdpc3RlcnMgaWYgZW5hYmxl
ZCBmb3IgdGhlIGd1ZXN0Lgo+PiAgICovCj4+ICAubWFjcm8gcHRyYXV0aF9zd2l0Y2hfdG9fZ3Vl
c3QgZ19jdHh0LCByZWcxLCByZWcyLCByZWczCj4+IC1hbHRlcm5hdGl2ZV9pZiBBUk02NF9IQVNf
QUREUkVTU19BVVRIX0FSQ0gKPj4gK2FsdGVybmF0aXZlX2lmX25vdCBBUk02NF9IQVNfQUREUkVT
U19BVVRICj4+ICAJYgkxMDAwZgo+PiAgYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKPj4gLWFs
dGVybmF0aXZlX2lmX25vdCBBUk02NF9IQVNfQUREUkVTU19BVVRIX0lNUF9ERUYKPj4gLQliCTEw
MDFmCj4+IC1hbHRlcm5hdGl2ZV9lbHNlX25vcF9lbmRpZgo+PiAtMTAwMDoKPj4gIAltcnMJXHJl
ZzEsIGhjcl9lbDIKPj4gIAlhbmQJXHJlZzEsIFxyZWcxLCAjKEhDUl9BUEkgfCBIQ1JfQVBLKQo+
PiAtCWNieglccmVnMSwgMTAwMWYKPj4gKwljYnoJXHJlZzEsIDEwMDBmCj4+ICAJYWRkCVxyZWcx
LCBcZ19jdHh0LCAjQ1BVX0FQSUFLRVlMT19FTDEKPj4gIAlwdHJhdXRoX3Jlc3RvcmVfc3RhdGUJ
XHJlZzEsIFxyZWcyLCBccmVnMwo+PiAtMTAwMToKPj4gKzEwMDA6Cj4+ICAuZW5kbQo+IAo+IFNp
bmNlIHRoZXNlIGFyZSBpbiBtYWNyb3MsIHdlIGNvdWxkIHVzZSBcQCB0byBnZW5lcmF0ZSBhIG1h
Y3JvLXNwZWNpZmljCj4gbGF2ZWwgcmF0aGVyIHRoYW4gYSBtYWdpYyBudW1iZXIsIHdoaWNoIHdv
dWxkIGJlIGxlc3MgbGlrZWx5IHRvIAo+IGNvbmZsaWN0Cj4gd2l0aCB0aGUgc3Vycm91bmRpbmcg
ZW52aXJvbm1lbnQgYW5kIHdvdWxkIGJlIG1vcmUgZGVzY3JpcHRpdmUuIFdlIGRvCj4gdGhhdCBp
biBhIGZldyBwbGFjZXMgYWxyZWFkeSwgYW5kIGhlcmUgaXQgY291bGQgbG9vayBzb21ldGhpbmcg
bGlrZToKPiAKPiB8IGFsdGVybmF0aXZlX2lmX25vdCBBUk02NF9IQVNfQUREUkVTU19BVVRICj4g
fCAJYgkuTF9fc2tpcF9wYXV0aF9zd2l0Y2hcQAo+IHwgYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5k
aWYKPiB8Cj4gfCAJLi4uCj4gfAo+IHwgLkxfX3NraXBfcGF1dGhfc3dpdGNoXEA6Cj4gCj4gUGVy
IHRoZSBnYXMgZG9jdW1lbnRhdGlvbgo+IAo+IHwgXEAKPiB8Cj4gfCAgICBhcyBtYWludGFpbnMg
YSBjb3VudGVyIG9mIGhvdyBtYW55IG1hY3JvcyBpdCBoYXMgZXhlY3V0ZWQgaW4gdGhpcwo+IHwg
ICAgcHNldWRvLXZhcmlhYmxlOyB5b3UgY2FuIGNvcHkgdGhhdCBudW1iZXIgdG8geW91ciBvdXRw
dXQgd2l0aCAKPiDigJhcQOKAmSwKPiB8ICAgIGJ1dCBvbmx5IHdpdGhpbiBhIG1hY3JvIGRlZmlu
aXRpb24uCj4gCj4gTm8gd29ycmllcyBpZiB5b3UgZG9uJ3Qgd2FudCB0byBjaGFuZ2UgdGhhdCBu
b3c7IHRoZSBBY2tlZC1ieSBzdGFuZHMKPiBlaXRoZXIgd2F5LgoKSSBoYXZlIGZvbGRlZCBpbiB0
aGUgZm9sbG93aW5nIHBhdGNoOgoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20v
a3ZtX3B0cmF1dGguaCAKYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9wdHJhdXRoLmgKaW5k
ZXggN2E3MjUwOGE4NDFiLi4wZGRmOThjM2JhOWYgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX3B0cmF1dGguaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9w
dHJhdXRoLmgKQEAgLTY4LDI5ICs2OCwyOSBAQAogICAqLwogIC5tYWNybyBwdHJhdXRoX3N3aXRj
aF90b19ndWVzdCBnX2N0eHQsIHJlZzEsIHJlZzIsIHJlZzMKICBhbHRlcm5hdGl2ZV9pZl9ub3Qg
QVJNNjRfSEFTX0FERFJFU1NfQVVUSAotCWIJMTAwMGYKKwliCS5MX19za2lwX3N3aXRjaFxACiAg
YWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKICAJbXJzCVxyZWcxLCBoY3JfZWwyCiAgCWFuZAlc
cmVnMSwgXHJlZzEsICMoSENSX0FQSSB8IEhDUl9BUEspCi0JY2J6CVxyZWcxLCAxMDAwZgorCWNi
eglccmVnMSwgLkxfX3NraXBfc3dpdGNoXEAKICAJYWRkCVxyZWcxLCBcZ19jdHh0LCAjQ1BVX0FQ
SUFLRVlMT19FTDEKICAJcHRyYXV0aF9yZXN0b3JlX3N0YXRlCVxyZWcxLCBccmVnMiwgXHJlZzMK
LTEwMDA6CisuTF9fc2tpcF9zd2l0Y2hcQDoKICAuZW5kbQoKICAubWFjcm8gcHRyYXV0aF9zd2l0
Y2hfdG9faG9zdCBnX2N0eHQsIGhfY3R4dCwgcmVnMSwgcmVnMiwgcmVnMwogIGFsdGVybmF0aXZl
X2lmX25vdCBBUk02NF9IQVNfQUREUkVTU19BVVRICi0JYgkyMDAwZgorCWIJLkxfX3NraXBfc3dp
dGNoXEAKICBhbHRlcm5hdGl2ZV9lbHNlX25vcF9lbmRpZgogIAltcnMJXHJlZzEsIGhjcl9lbDIK
ICAJYW5kCVxyZWcxLCBccmVnMSwgIyhIQ1JfQVBJIHwgSENSX0FQSykKLQljYnoJXHJlZzEsIDIw
MDBmCisJY2J6CVxyZWcxLCAuTF9fc2tpcF9zd2l0Y2hcQAogIAlhZGQJXHJlZzEsIFxnX2N0eHQs
ICNDUFVfQVBJQUtFWUxPX0VMMQogIAlwdHJhdXRoX3NhdmVfc3RhdGUJXHJlZzEsIFxyZWcyLCBc
cmVnMwogIAlhZGQJXHJlZzEsIFxoX2N0eHQsICNDUFVfQVBJQUtFWUxPX0VMMQogIAlwdHJhdXRo
X3Jlc3RvcmVfc3RhdGUJXHJlZzEsIFxyZWcyLCBccmVnMwogIAlpc2IKLTIwMDA6CisuTF9fc2tp
cF9zd2l0Y2hcQDoKICAuZW5kbQoKICAjZWxzZSAvKiAhQ09ORklHX0FSTTY0X1BUUl9BVVRIICov
CgoKVGhhbmtzLAoKICAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNt
ZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
