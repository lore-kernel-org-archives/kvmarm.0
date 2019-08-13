Return-Path: <SRS0=Pedm=WJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8784C32750
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 15:44:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E72D205F4
	for <kvmarm@archiver.kernel.org>; Tue, 13 Aug 2019 15:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E72D205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B413E4A55A;
	Tue, 13 Aug 2019 11:44:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m7urZS4rjLfu; Tue, 13 Aug 2019 11:44:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BDCF4A51E;
	Tue, 13 Aug 2019 11:44:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 741034A4DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 11:44:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mZH594XBOSWf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Aug 2019 11:44:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F974A4D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Aug 2019 11:44:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7814128;
 Tue, 13 Aug 2019 08:44:25 -0700 (PDT)
Received: from [10.37.8.112] (unknown [10.37.8.112])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5297F3F706;
 Tue, 13 Aug 2019 08:44:23 -0700 (PDT)
Subject: Re: KVM Arm64 and Linux-RT issues
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
 <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org> <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
 <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <adc0b2e2-3a2e-5685-8eb5-2ce927d2139e@arm.com>
Date: Tue, 13 Aug 2019 16:44:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
Content-Language: en-US
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, anna-maria@linutronix.de,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgU2ViYXN0aWFuLAoKT24gOC8xMy8xOSAxOjU4IFBNLCBiaWdlYXN5QGxpbnV0cm9uaXguZGUg
d3JvdGU6Cj4gT24gMjAxOS0wNy0yNyAxNDozNzoxMSBbKzAxMDBdLCBKdWxpZW4gR3JhbGwgd3Jv
dGU6Cj4+Pj4gODwtLS0tLS0tLS0tLS0KPj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vYXJjaF90aW1l
ci5jCj4+Pj4gKysrIGIvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYwo+Pj4+IEBAIC04MCw3ICs4
MCw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB1c2Vyc3BhY2VfaXJxY2hpcChzdHIKPj4+PiAgICBz
dGF0aWMgdm9pZCBzb2Z0X3RpbWVyX3N0YXJ0KHN0cnVjdCBocnRpbWVyICpocnQsIHU2NCBucykK
Pj4+PiAgICB7Cj4+Pj4gICAgCWhydGltZXJfc3RhcnQoaHJ0LCBrdGltZV9hZGRfbnMoa3RpbWVf
Z2V0KCksIG5zKSwKPj4+PiAtCQkgICAgICBIUlRJTUVSX01PREVfQUJTKTsKPj4+PiArCQkgICAg
ICBIUlRJTUVSX01PREVfQUJTX0hBUkQpOwo+Pj4+ICAgIH0KPj4+Cj4+PiBUaGF0J3MgcHJldHR5
IG5lYXQsIGFuZCBtYXRjaGVzIHRoZSBwYXRjaCB5b3UgYWxyZWFkeSBoYXZlIGZvcgo+Pj4geDg2
LiBGZWVsIGZyZWUgdG8gYWRkIG15Cj4+Pgo+Pj4gQWNrZWQtYnk6IE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+Cj4+Cj4+IEkgY2FuIGNvbmZpcm0gdGhlIHdhcm5pbmcgbm93IGRpc2FwcGVh
cmVkLiBGZWVsIGZyZWUgdG8gYWRkZWQgbXkgdGVzdGVkLWJ5Ogo+Pgo+PiBUZXN0ZWQtYnk6IEp1
bGllbiBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+Cj4+Cj4gCj4gfGt2bV9ocnRpbWVyX2V4
cGlyZSgpCj4gfCBrdm1fdGltZXJfdXBkYXRlX2lycSgpCj4gfCAgIGt2bV92Z2ljX2luamVjdF9p
cnEoKQo+IHwgICAgIHZnaWNfbGF6eV9pbml0KCkKPiB8ICAgICAgICAgICAgICAgIGlmICh1bmxp
a2VseSghdmdpY19pbml0aWFsaXplZChrdm0pKSkgewo+IHwgICAgICAgICAgICAgICAgIGlmIChr
dm0tPmFyY2gudmdpYy52Z2ljX21vZGVsICE9IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMikKPiB8
ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7Cj4gfAo+IHwgICAgICAgICAg
ICAgICAgIG11dGV4X2xvY2soJmt2bS0+bG9jayk7Cj4gCj4gSXMgdGhpcyBwb3NzaWJsZSBwYXRo
IG9mIGFueSBjb25jZXJuPyBUaGlzIHNob3VsZCB0aHJvdyBhIHdhcm5pbmcgYWxzbwo+IGZvciAh
UlQgc28gcHJvYmFibHkgbm904oCmCgpIbW1tLCB0aGVvcmV0aWNhbGx5IHllcy4gSW4gcHJhY3Rp
Y2UsIGl0IGxvb2tzIGxpa2UgdGhlIGhydGltZXIgd2lsbCBub3QgCmJlIHN0YXJ0ZWQgYmVmb3Jl
IGt2bV92Y3B1X2ZpcnN0X3J1bl9pbml0KCkgaXMgY2FsbGVkIG9uIHRoZSBmaXJzdCBydW4uCgpU
aGUgZnVuY3Rpb24gd2lsbCBjYWxsIGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKSB3aGljaCB3aWxs
IGluaXRpYWxpemUgCnRoZSB2Z2ljIGlmIG5vdCBhbHJlYWR5IGRvbmUuCgpMb29raW5nIGFyb3Vu
ZCwgSSB0aGluayB0aGlzIGlzIGhlcmUgdG8gY2F0ZXIgdGhlIGNhc2Ugd2hlcmUgCktWTV9JUlFf
TElORSBpcyBjYWxsZWQgYmVmb3JlIHJ1bm5pbmcuCgpJIGFtIG5vdCB5ZXQgZmFtaWxpYXIgd2l0
aCB0aGUgdmdpYywgc28gSSBtYXkgaGF2ZSBtaXNzZWQgc29tZXRoaW5nLgoKPiAKPiBJIHByZXBh
cmVkIHRoZSBwYXRjaCBiZWxvdy4gVGhpcyBvbmUgY291bGQgZ28gc3RyYWlnaHQgdG8gdGdseCdz
IHRpbWVyIHRyZWUKPiBzaW5jZSBoZSBoYXMgdGhlIF9IQVJEIGJpdHMgdGhlcmUuIEkgKnRoaW5r
KiBpdCByZXF1aXJlcyB0byBzZXQgdGhlIGJpdHMKPiBfSEFSRCBkdXJpbmcgX2luaXQoKSBhbmQg
X3N0YXJ0KCkgb3RoZXJ3aXNlIHRoZXJlIGlzIChvciB3YXMpIGEgd2FybmluZ+KApgo+IAo+IFNl
YmFzdGlhbgo+IDg8LS0tLS0tLS0tLS0tCj4gCj4gRnJvbTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4
QGxpbnV0cm9uaXguZGU+Cj4gRGF0ZTogVHVlLCAxMyBBdWcgMjAxOSAxNDoyOTo0MSArMDIwMAo+
IFN1YmplY3Q6IFtQQVRDSF0gS1ZNOiBhcm0vYXJtNjQ6IExldCB0aGUgdGltZXIgZXhwaXJlIGlu
IGhhcmRpcnEgY29udGV4dCBvbiBSVAo+IAo+IFRoZSB0aW1lcnMgYXJlIGNhbmNlbGVkIGZyb20g
YW4gcHJlZW1wdC1ub3RpZmllciB3aGljaCBpcyBpbnZva2VkIHdpdGgKPiBkaXNhYmxlZCBwcmVl
bXB0aW9uIHdoaWNoIGlzIG5vdCBhbGxvd2VkIG9uIFBSRUVNUFRfUlQuCj4gVGhlIHRpbWVyIGNh
bGxiYWNrIGlzIHNob3J0IHNvIGluIGNvdWxkIGJlIGludm9rZWQgaW4gaGFyZC1JUlEgY29udGV4
dAo+IG9uIC1SVC4KPiAKPiBMZXQgdGhlIHRpbWVyIGV4cGlyZSBvbiBoYXJkLUlSUSBjb250ZXh0
IGV2ZW4gb24gLVJULgo+IAo+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBs
aW51dHJvbml4LmRlPgo+IEFja2VkLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+
IFRlc3RlZC1ieTogSnVsaWVuIEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNvbT4KPiBTaWduZWQt
b2ZmLWJ5OiBTZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+
Cj4gLS0tCj4gICB2aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5jIHwgOCArKysrLS0tLQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYyBiL3ZpcnQva3ZtL2FybS9hcmNoX3RpbWVy
LmMKPiBpbmRleCAxYmU0ODZkNWQ3Y2I0Li4wYmZhN2M1YjVjODkwIDEwMDY0NAo+IC0tLSBhL3Zp
cnQva3ZtL2FybS9hcmNoX3RpbWVyLmMKPiArKysgYi92aXJ0L2t2bS9hcm0vYXJjaF90aW1lci5j
Cj4gQEAgLTgwLDcgKzgwLDcgQEAgc3RhdGljIGlubGluZSBib29sIHVzZXJzcGFjZV9pcnFjaGlw
KHN0cnVjdCBrdm0gKmt2bSkKPiAgIHN0YXRpYyB2b2lkIHNvZnRfdGltZXJfc3RhcnQoc3RydWN0
IGhydGltZXIgKmhydCwgdTY0IG5zKQo+ICAgewo+ICAgCWhydGltZXJfc3RhcnQoaHJ0LCBrdGlt
ZV9hZGRfbnMoa3RpbWVfZ2V0KCksIG5zKSwKPiAtCQkgICAgICBIUlRJTUVSX01PREVfQUJTKTsK
PiArCQkgICAgICBIUlRJTUVSX01PREVfQUJTX0hBUkQpOwo+ICAgfQo+ICAgCj4gICBzdGF0aWMg
dm9pZCBzb2Z0X3RpbWVyX2NhbmNlbChzdHJ1Y3QgaHJ0aW1lciAqaHJ0KQo+IEBAIC02OTcsMTEg
KzY5NywxMSBAQCB2b2lkIGt2bV90aW1lcl92Y3B1X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQo+ICAgCXVwZGF0ZV92dGltZXJfY250dm9mZih2Y3B1LCBrdm1fcGh5c190aW1lcl9yZWFkKCkp
Owo+ICAgCXB0aW1lci0+Y250dm9mZiA9IDA7Cj4gICAKPiAtCWhydGltZXJfaW5pdCgmdGltZXIt
PmJnX3RpbWVyLCBDTE9DS19NT05PVE9OSUMsIEhSVElNRVJfTU9ERV9BQlMpOwo+ICsJaHJ0aW1l
cl9pbml0KCZ0aW1lci0+YmdfdGltZXIsIENMT0NLX01PTk9UT05JQywgSFJUSU1FUl9NT0RFX0FC
U19IQVJEKTsKPiAgIAl0aW1lci0+YmdfdGltZXIuZnVuY3Rpb24gPSBrdm1fYmdfdGltZXJfZXhw
aXJlOwo+ICAgCj4gLQlocnRpbWVyX2luaXQoJnZ0aW1lci0+aHJ0aW1lciwgQ0xPQ0tfTU9OT1RP
TklDLCBIUlRJTUVSX01PREVfQUJTKTsKPiAtCWhydGltZXJfaW5pdCgmcHRpbWVyLT5ocnRpbWVy
LCBDTE9DS19NT05PVE9OSUMsIEhSVElNRVJfTU9ERV9BQlMpOwo+ICsJaHJ0aW1lcl9pbml0KCZ2
dGltZXItPmhydGltZXIsIENMT0NLX01PTk9UT05JQywgSFJUSU1FUl9NT0RFX0FCU19IQVJEKTsK
PiArCWhydGltZXJfaW5pdCgmcHRpbWVyLT5ocnRpbWVyLCBDTE9DS19NT05PVE9OSUMsIEhSVElN
RVJfTU9ERV9BQlNfSEFSRCk7Cj4gICAJdnRpbWVyLT5ocnRpbWVyLmZ1bmN0aW9uID0ga3ZtX2hy
dGltZXJfZXhwaXJlOwo+ICAgCXB0aW1lci0+aHJ0aW1lci5mdW5jdGlvbiA9IGt2bV9ocnRpbWVy
X2V4cGlyZTsKPiAgIAo+IAoKLS0gCkp1bGllbiBHcmFsbApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
