Return-Path: <SRS0=Pedm=WJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611BAC32750
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 12:58:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBBF0206C2
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 12:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBBF0206C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9904A4E1;
	Tue, 13 Aug 2019 08:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9PlT7c0STXDB; Tue, 13 Aug 2019 08:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0581A4A532;
	Tue, 13 Aug 2019 08:58:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F9E54A52D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 08:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Z3wvz7lBVtV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Aug 2019 08:58:39 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92D104A4E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 08:58:39 -0400 (EDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
 (envelope-from <bigeasy@linutronix.de>)
 id 1hxWNn-0006HO-Au; Tue, 13 Aug 2019 14:58:35 +0200
Date: Tue, 13 Aug 2019 14:58:35 +0200
From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
To: Julien Grall <julien.grall@arm.com>
Subject: Re: KVM Arm64 and Linux-RT issues
Message-ID: <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
 <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org>
 <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
User-Agent: NeoMutt/20180716
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAxOS0wNy0yNyAxNDozNzoxMSBbKzAxMDBdLCBKdWxpZW4gR3JhbGwgd3JvdGU6Cj4gPiA+
IDg8LS0tLS0tLS0tLS0tCj4gPiA+IC0tLSBhL3ZpcnQva3ZtL2FybS9hcmNoX3RpbWVyLmMKPiA+
ID4gKysrIGIvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYwo+ID4gPiBAQCAtODAsNyArODAsNyBA
QCBzdGF0aWMgaW5saW5lIGJvb2wgdXNlcnNwYWNlX2lycWNoaXAoc3RyCj4gPiA+ICAgc3RhdGlj
IHZvaWQgc29mdF90aW1lcl9zdGFydChzdHJ1Y3QgaHJ0aW1lciAqaHJ0LCB1NjQgbnMpCj4gPiA+
ICAgewo+ID4gPiAgIAlocnRpbWVyX3N0YXJ0KGhydCwga3RpbWVfYWRkX25zKGt0aW1lX2dldCgp
LCBucyksCj4gPiA+IC0JCSAgICAgIEhSVElNRVJfTU9ERV9BQlMpOwo+ID4gPiArCQkgICAgICBI
UlRJTUVSX01PREVfQUJTX0hBUkQpOwo+ID4gPiAgIH0KPiA+IAo+ID4gVGhhdCdzIHByZXR0eSBu
ZWF0LCBhbmQgbWF0Y2hlcyB0aGUgcGF0Y2ggeW91IGFscmVhZHkgaGF2ZSBmb3IKPiA+IHg4Ni4g
RmVlbCBmcmVlIHRvIGFkZCBteQo+ID4gCj4gPiBBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4KPiAKPiBJIGNhbiBjb25maXJtIHRoZSB3YXJuaW5nIG5vdyBkaXNhcHBlYXJl
ZC4gRmVlbCBmcmVlIHRvIGFkZGVkIG15IHRlc3RlZC1ieToKPiAKPiBUZXN0ZWQtYnk6IEp1bGll
biBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+Cj4gCgp8a3ZtX2hydGltZXJfZXhwaXJlKCkK
fCBrdm1fdGltZXJfdXBkYXRlX2lycSgpCnwgICBrdm1fdmdpY19pbmplY3RfaXJxKCkKfCAgICAg
dmdpY19sYXp5X2luaXQoKQp8ICAgICAgICAgICAgICAgIGlmICh1bmxpa2VseSghdmdpY19pbml0
aWFsaXplZChrdm0pKSkgewp8ICAgICAgICAgICAgICAgICBpZiAoa3ZtLT5hcmNoLnZnaWMudmdp
Y19tb2RlbCAhPSBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjIpCnwgICAgICAgICAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FQlVTWTsKfCAKfCAgICAgICAgICAgICAgICAgbXV0ZXhfbG9jaygma3Zt
LT5sb2NrKTsKCklzIHRoaXMgcG9zc2libGUgcGF0aCBvZiBhbnkgY29uY2Vybj8gVGhpcyBzaG91
bGQgdGhyb3cgYSB3YXJuaW5nIGFsc28KZm9yICFSVCBzbyBwcm9iYWJseSBub3TigKYKCkkgcHJl
cGFyZWQgdGhlIHBhdGNoIGJlbG93LiBUaGlzIG9uZSBjb3VsZCBnbyBzdHJhaWdodCB0byB0Z2x4
J3MgdGltZXIgdHJlZQpzaW5jZSBoZSBoYXMgdGhlIF9IQVJEIGJpdHMgdGhlcmUuIEkgKnRoaW5r
KiBpdCByZXF1aXJlcyB0byBzZXQgdGhlIGJpdHMKX0hBUkQgZHVyaW5nIF9pbml0KCkgYW5kIF9z
dGFydCgpIG90aGVyd2lzZSB0aGVyZSBpcyAob3Igd2FzKSBhIHdhcm5pbmfigKYKClNlYmFzdGlh
bgo4PC0tLS0tLS0tLS0tLQoKRnJvbTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXgu
ZGU+CkRhdGU6IFR1ZSwgMTMgQXVnIDIwMTkgMTQ6Mjk6NDEgKzAyMDAKU3ViamVjdDogW1BBVENI
XSBLVk06IGFybS9hcm02NDogTGV0IHRoZSB0aW1lciBleHBpcmUgaW4gaGFyZGlycSBjb250ZXh0
IG9uIFJUCgpUaGUgdGltZXJzIGFyZSBjYW5jZWxlZCBmcm9tIGFuIHByZWVtcHQtbm90aWZpZXIg
d2hpY2ggaXMgaW52b2tlZCB3aXRoCmRpc2FibGVkIHByZWVtcHRpb24gd2hpY2ggaXMgbm90IGFs
bG93ZWQgb24gUFJFRU1QVF9SVC4KVGhlIHRpbWVyIGNhbGxiYWNrIGlzIHNob3J0IHNvIGluIGNv
dWxkIGJlIGludm9rZWQgaW4gaGFyZC1JUlEgY29udGV4dApvbiAtUlQuCgpMZXQgdGhlIHRpbWVy
IGV4cGlyZSBvbiBoYXJkLUlSUSBjb250ZXh0IGV2ZW4gb24gLVJULgoKU2lnbmVkLW9mZi1ieTog
VGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+CkFja2VkLWJ5OiBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPgpUZXN0ZWQtYnk6IEp1bGllbiBHcmFsbCA8anVsaWVuLmdyYWxs
QGFybS5jb20+ClNpZ25lZC1vZmYtYnk6IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vh
c3lAbGludXRyb25peC5kZT4KLS0tCiB2aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5jIHwgOCArKysr
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5jIGIvdmlydC9rdm0vYXJtL2FyY2hf
dGltZXIuYwppbmRleCAxYmU0ODZkNWQ3Y2I0Li4wYmZhN2M1YjVjODkwIDEwMDY0NAotLS0gYS92
aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5jCisrKyBiL3ZpcnQva3ZtL2FybS9hcmNoX3RpbWVyLmMK
QEAgLTgwLDcgKzgwLDcgQEAgc3RhdGljIGlubGluZSBib29sIHVzZXJzcGFjZV9pcnFjaGlwKHN0
cnVjdCBrdm0gKmt2bSkKIHN0YXRpYyB2b2lkIHNvZnRfdGltZXJfc3RhcnQoc3RydWN0IGhydGlt
ZXIgKmhydCwgdTY0IG5zKQogewogCWhydGltZXJfc3RhcnQoaHJ0LCBrdGltZV9hZGRfbnMoa3Rp
bWVfZ2V0KCksIG5zKSwKLQkJICAgICAgSFJUSU1FUl9NT0RFX0FCUyk7CisJCSAgICAgIEhSVElN
RVJfTU9ERV9BQlNfSEFSRCk7CiB9CiAKIHN0YXRpYyB2b2lkIHNvZnRfdGltZXJfY2FuY2VsKHN0
cnVjdCBocnRpbWVyICpocnQpCkBAIC02OTcsMTEgKzY5NywxMSBAQCB2b2lkIGt2bV90aW1lcl92
Y3B1X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCXVwZGF0ZV92dGltZXJfY250dm9mZih2
Y3B1LCBrdm1fcGh5c190aW1lcl9yZWFkKCkpOwogCXB0aW1lci0+Y250dm9mZiA9IDA7CiAKLQlo
cnRpbWVyX2luaXQoJnRpbWVyLT5iZ190aW1lciwgQ0xPQ0tfTU9OT1RPTklDLCBIUlRJTUVSX01P
REVfQUJTKTsKKwlocnRpbWVyX2luaXQoJnRpbWVyLT5iZ190aW1lciwgQ0xPQ0tfTU9OT1RPTklD
LCBIUlRJTUVSX01PREVfQUJTX0hBUkQpOwogCXRpbWVyLT5iZ190aW1lci5mdW5jdGlvbiA9IGt2
bV9iZ190aW1lcl9leHBpcmU7CiAKLQlocnRpbWVyX2luaXQoJnZ0aW1lci0+aHJ0aW1lciwgQ0xP
Q0tfTU9OT1RPTklDLCBIUlRJTUVSX01PREVfQUJTKTsKLQlocnRpbWVyX2luaXQoJnB0aW1lci0+
aHJ0aW1lciwgQ0xPQ0tfTU9OT1RPTklDLCBIUlRJTUVSX01PREVfQUJTKTsKKwlocnRpbWVyX2lu
aXQoJnZ0aW1lci0+aHJ0aW1lciwgQ0xPQ0tfTU9OT1RPTklDLCBIUlRJTUVSX01PREVfQUJTX0hB
UkQpOworCWhydGltZXJfaW5pdCgmcHRpbWVyLT5ocnRpbWVyLCBDTE9DS19NT05PVE9OSUMsIEhS
VElNRVJfTU9ERV9BQlNfSEFSRCk7CiAJdnRpbWVyLT5ocnRpbWVyLmZ1bmN0aW9uID0ga3ZtX2hy
dGltZXJfZXhwaXJlOwogCXB0aW1lci0+aHJ0aW1lci5mdW5jdGlvbiA9IGt2bV9ocnRpbWVyX2V4
cGlyZTsKIAotLSAKMi4yMy4wLnJjMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
