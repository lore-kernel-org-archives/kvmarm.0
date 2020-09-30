Return-Path: <SRS0=CuDs=DH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25D6C47420
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 11:45:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02CC320709
	for <kvmarm@archiver.kernel.org>; Wed, 30 Sep 2020 11:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CC320709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58CB84B270;
	Wed, 30 Sep 2020 07:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dnyKcdN57RDM; Wed, 30 Sep 2020 07:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1244D4B2FE;
	Wed, 30 Sep 2020 07:45:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D612C4B241
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 07:45:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2lx00wU8hOax for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 07:45:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3AB4B22E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 07:45:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A8E730E;
 Wed, 30 Sep 2020 04:45:51 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 170DA3F6CF;
 Wed, 30 Sep 2020 04:45:48 -0700 (PDT)
Subject: Re: [PATCH v7 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
To: Marc Zyngier <maz@kernel.org>
References: <20200924110706.254996-1-alexandru.elisei@arm.com>
 <20200924110706.254996-6-alexandru.elisei@arm.com>
 <14a0562fee95d5c7aa5bc6b67d213858@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3379a8af-67ae-f71f-316d-3baa5fadc6dd@arm.com>
Date: Wed, 30 Sep 2020 12:46:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <14a0562fee95d5c7aa5bc6b67d213858@kernel.org>
Content-Language: en-US
Cc: sumit.garg@linaro.org, kvm@vger.kernel.org,
 Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 swboyd@chromium.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGVsbG8sCgpPbiA5LzI5LzIwIDk6MTEgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIw
LTA5LTI0IDEyOjA3LCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+PiBGcm9tOiBKdWxpZW4gVGhp
ZXJyeSA8anVsaWVuLnRoaWVycnlAYXJtLmNvbT4KPj4KPj4ga3ZtX3ZjcHVfa2ljaygpIGlzIG5v
dCBOTUkgc2FmZS4gV2hlbiB0aGUgb3ZlcmZsb3cgaGFuZGxlciBpcyBjYWxsZWQgZnJvbQo+PiBO
TUkgY29udGV4dCwgZGVmZXIgd2FraW5nIHRoZSB2Y3B1IHRvIGFuIGlycV93b3JrIHF1ZXVlLgo+
Pgo+PiBBIHZjcHUgY2FuIGJlIGZyZWVkIHdoaWxlIGl0J3Mgbm90IHJ1bm5pbmcgYnkga3ZtX2Rl
c3Ryb3lfdm0oKS4gUHJldmVudAo+PiBydW5uaW5nIHRoZSBpcnFfd29yayBmb3IgYSBub24tZXhp
c3RlbnQgdmNwdSBieSBjYWxsaW5nIGlycV93b3JrX3N5bmMoKSBvbgo+PiB0aGUgUE1VIGRlc3Ry
b3kgcGF0aC4KPj4KPj4gQ2M6IEp1bGllbiBUaGllcnJ5IDxqdWxpZW4udGhpZXJyeS5rZGV2QGdt
YWlsLmNvbT4KPj4gQ2M6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Cj4+IENj
OiBXaWxsIERlYWNvbiA8d2lsbC5kZWFjb25AYXJtLmNvbT4KPj4gQ2M6IE1hcmsgUnV0bGFuZCA8
bWFyay5ydXRsYW5kQGFybS5jb20+Cj4+IENjOiBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFy
aW5hc0Bhcm0uY29tPgo+PiBDYzogSmFtZXMgTW9yc2UgPGphbWVzLm1vcnNlQGFybS5jb20+Cj4+
IENjOiBTdXp1a2kgSyBQb3Vsb3plIDxzdXp1a2kucG91bG9zZUBhcm0uY29tPgo+PiBDYzoga3Zt
QHZnZXIua2VybmVsLm9yZwo+PiBDYzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+PiBT
aWduZWQtb2ZmLWJ5OiBKdWxpZW4gVGhpZXJyeSA8anVsaWVuLnRoaWVycnlAYXJtLmNvbT4KPj4g
VGVzdGVkLWJ5OiBTdW1pdCBHYXJnIDxzdW1pdC5nYXJnQGxpbmFyby5vcmc+IChEZXZlbG9wZXJi
b3gpCj4+IFtBbGV4YW5kcnUgRS46IEFkZGVkIGlycV93b3JrX3N5bmMoKV0KPj4gU2lnbmVkLW9m
Zi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+PiAtLS0K
Pj4gSSBzdWdnZXN0ZWQgaW4gdjYgdGhhdCBJIHdpbGwgYWRkIGFuIGlycV93b3JrX3N5bmMoKSB0
bwo+PiBrdm1fcG11X3ZjcHVfcmVzZXQoKS4gSXQgdHVybnMgb3V0IGl0J3Mgbm90IG5lY2Vzc2Fy
eTogYSB2Y3B1IHJlc2V0IGlzIGRvbmUKPj4gYnkgdGhlIHZjcHUgYmVpbmcgcmVzZXQgd2l0aCBp
bnRlcnJ1cHRzIGVuYWJsZWQsIHdoaWNoIG1lYW5zIGFsbCB0aGUgd29yawo+PiBoYXMgaGFkIGEg
Y2hhbmNlIHRvIHJ1biBiZWZvcmUgdGhlIHJlc2V0IHRha2VzIHBsYWNlLgo+Cj4gSSBkb24ndCB1
bmRlcnN0YW5kIHlvdXIgYXJndW1lbnQgYWJvdXQgaW50ZXJydXB0cyBiZWluZyBlbmFibGVkLiBU
aGUgcmVhbAo+IHJlYXNvbiBmb3Igbm90IG5lZWRpbmcgYW55IHN5bmNocm9uaXphdGlvbiBpcyB0
aGF0IGFsbCB0aGF0IHRoZSBxdWV1ZWQgd29yawo+IGRvZXMgaXMgdG8ga2ljayB0aGUgdmNwdS4g
R2l2ZW4gdGhhdCB0aGUgdmNwdSBpcyByZXNldHRpbmcsIG5vIGFtb3VudCBvZgo+IGtpY2tpbmcg
aXMgZ29pbmcgdG8gY2hhbmdlIGFueXRoaW5nIChpdCBpcyBhbHJlYWR5IG91dHNpZGUgb2YgdGhl
IGd1ZXN0KS4KPgo+IFRoaW5ncyBhcmUgb2J2aW91c2x5IGRpZmZlcmVudCBvbiBkZXN0cm95LCB3
aGVyZSB0aGUgdmNwdSBpcyBhY3RpdmVseSBnb2luZwo+IGF3YXkgYW5kIHdlIG5lZWQgdG8gbWFr
ZSBzdXJlIHdlIGRvbid0IHVzZSBzdGFsZSBkYXRhLgoKTGlrZSB5b3UgYW5kIFdpbGwgbm90aWNl
ZCwgdGhlIGFib3ZlIHJlYWxseSBkb2Vzbid0IG1ha2UgbXVjaCBzZW5zZS4gVGhlIHJlYXNvbiB3
ZQpkb24ndCBuZWVkIHRvIHdhaXQgZm9yIHRoZSBpcnFfd29yayB0byBiZSBmaW5pc2hlZCBvbiBy
ZXNldCBpcyBpbmRlZWQgdGhhdCB0aGUKdmNwdSBpc24ndCBmcmVlZCwgc28gd2Ugd2lsbCBuZXZl
ciB0cmlnZ2VyIGEgdXNlLWFmdGVyLWZyZWUgYnVnLgoKPgo+Pgo+PiDCoGFyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrLQo+PiDCoGluY2x1ZGUv
a3ZtL2FybV9wbXUuaMKgwqDCoMKgIHzCoCAxICsKPj4gwqAyIGZpbGVzIGNoYW5nZWQsIDI2IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL3BtdS1lbXVsLmMgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+IGluZGV4IGYwZDAz
MTJjMGE1NS4uODE5MTZlMzYwYjFlIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wbXUt
ZW11bC5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4gQEAgLTI2OSw2ICsy
NjksNyBAQCB2b2lkIGt2bV9wbXVfdmNwdV9kZXN0cm95KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkK
Pj4KPj4gwqDCoMKgwqAgZm9yIChpID0gMDsgaSA8IEFSTVY4X1BNVV9NQVhfQ09VTlRFUlM7IGkr
KykKPj4gwqDCoMKgwqDCoMKgwqDCoCBrdm1fcG11X3JlbGVhc2VfcGVyZl9ldmVudCgmcG11LT5w
bWNbaV0pOwo+PiArwqDCoMKgIGlycV93b3JrX3N5bmMoJnZjcHUtPmFyY2gucG11Lm92ZXJmbG93
X3dvcmspOwo+PiDCoH0KPj4KPj4gwqB1NjQga3ZtX3BtdV92YWxpZF9jb3VudGVyX21hc2soc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiBAQCAtNDMzLDYgKzQzNCwyMiBAQCB2b2lkIGt2bV9wbXVf
c3luY19od3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4gwqDCoMKgwqAga3ZtX3BtdV91
cGRhdGVfc3RhdGUodmNwdSk7Cj4+IMKgfQo+Pgo+PiArLyoqCj4+ICsgKiBXaGVuIHBlcmYgaW50
ZXJydXB0IGlzIGFuIE5NSSwgd2UgY2Fubm90IHNhZmVseSBub3RpZnkgdGhlIHZjcHUKPj4gY29y
cmVzcG9uZGluZwo+PiArICogdG8gdGhlIGV2ZW50Lgo+PiArICogVGhpcyBpcyB3aHkgd2UgbmVl
ZCBhIGNhbGxiYWNrIHRvIGRvIGl0IG9uY2Ugb3V0c2lkZSBvZiB0aGUgTk1JIGNvbnRleHQuCj4+
ICsgKi8KPj4gK3N0YXRpYyB2b2lkIGt2bV9wbXVfcGVyZl9vdmVyZmxvd19ub3RpZnlfdmNwdShz
dHJ1Y3QgaXJxX3dvcmsgKndvcmspCj4+ICt7Cj4+ICvCoMKgwqAgc3RydWN0IGt2bV92Y3B1ICp2
Y3B1Owo+PiArwqDCoMKgIHN0cnVjdCBrdm1fcG11ICpwbXU7Cj4+ICsKPj4gK8KgwqDCoCBwbXUg
PSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IGt2bV9wbXUsIG92ZXJmbG93X3dvcmspOwo+PiAr
wqDCoMKgIHZjcHUgPSBrdm1fcG1jX3RvX3ZjcHUocG11LT5wbWMpOwo+PiArCj4+ICvCoMKgwqAg
a3ZtX3ZjcHVfa2ljayh2Y3B1KTsKPj4gK30KPj4gKwo+PiDCoC8qKgo+PiDCoCAqIFdoZW4gdGhl
IHBlcmYgZXZlbnQgb3ZlcmZsb3dzLCBzZXQgdGhlIG92ZXJmbG93IHN0YXR1cyBhbmQgaW5mb3Jt
IHRoZSB2Y3B1Lgo+PiDCoCAqLwo+PiBAQCAtNDY1LDcgKzQ4MiwxMSBAQCBzdGF0aWMgdm9pZCBr
dm1fcG11X3BlcmZfb3ZlcmZsb3coc3RydWN0Cj4+IHBlcmZfZXZlbnQgKnBlcmZfZXZlbnQsCj4+
Cj4+IMKgwqDCoMKgIGlmIChrdm1fcG11X292ZXJmbG93X3N0YXR1cyh2Y3B1KSkgewo+PiDCoMKg
wqDCoMKgwqDCoMKgIGt2bV9tYWtlX3JlcXVlc3QoS1ZNX1JFUV9JUlFfUEVORElORywgdmNwdSk7
Cj4+IC3CoMKgwqDCoMKgwqDCoCBrdm1fdmNwdV9raWNrKHZjcHUpOwo+PiArCj4+ICvCoMKgwqDC
oMKgwqDCoCBpZiAoIWluX25taSgpKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fdmNw
dV9raWNrKHZjcHUpOwo+PiArwqDCoMKgwqDCoMKgwqAgZWxzZQo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpcnFfd29ya19xdWV1ZSgmdmNwdS0+YXJjaC5wbXUub3ZlcmZsb3dfd29yayk7Cj4+
IMKgwqDCoMKgIH0KPj4KPj4gwqDCoMKgwqAgY3B1X3BtdS0+cG11LnN0YXJ0KHBlcmZfZXZlbnQs
IFBFUkZfRUZfUkVMT0FEKTsKPj4gQEAgLTc2NCw2ICs3ODUsOSBAQCBzdGF0aWMgaW50IGt2bV9h
cm1fcG11X3YzX2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIHJldDsKPj4gwqDCoMKgwqAgfQo+Pgo+PiArwqDCoMKgIGluaXRfaXJx
X3dvcmsoJnZjcHUtPmFyY2gucG11Lm92ZXJmbG93X3dvcmssCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBrdm1fcG11X3BlcmZfb3ZlcmZsb3dfbm90aWZ5X3ZjcHUpOwo+PiArCj4+IMKg
wqDCoMKgIHZjcHUtPmFyY2gucG11LmNyZWF0ZWQgPSB0cnVlOwo+PiDCoMKgwqDCoCByZXR1cm4g
MDsKPj4gwqB9Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fcG11LmggYi9pbmNsdWRl
L2t2bS9hcm1fcG11LmgKPj4gaW5kZXggNmRiMDMwNDM5ZTI5Li5kYmY0ZjA4ZDQyZTUgMTAwNjQ0
Cj4+IC0tLSBhL2luY2x1ZGUva3ZtL2FybV9wbXUuaAo+PiArKysgYi9pbmNsdWRlL2t2bS9hcm1f
cG11LmgKPj4gQEAgLTI3LDYgKzI3LDcgQEAgc3RydWN0IGt2bV9wbXUgewo+PiDCoMKgwqDCoCBi
b29sIHJlYWR5Owo+PiDCoMKgwqDCoCBib29sIGNyZWF0ZWQ7Cj4+IMKgwqDCoMKgIGJvb2wgaXJx
X2xldmVsOwo+PiArwqDCoMKgIHN0cnVjdCBpcnFfd29yayBvdmVyZmxvd193b3JrOwo+Cj4gTml0
OiBwbGFjaW5nIHRoaXMgbmV3IGZpZWxkIHJpZ2h0IGFmdGVyIHRoZSBwbWMgYXJyYXkgd291bGQg
YXZvaWQgY3JlYXRpbmcKPiBhbiB1bm5lY2Vzc2FyeSBwYWRkaW5nIGluIHRoZSBzdHJ1Y3R1cmUu
IE5vdCBhIGJpZyBkZWFsLCBhbmQgZGVmaW5pdGVseQo+IHNvbWV0aGluZyB3ZSBjYW4gc29ydCBv
dXQgd2hlbiBhcHBseWluZyB0aGUgcGF0Y2guCgpUaGF0IG1ha2VzIHNlbnNlLCBvdmVyZmxvd193
b3JrIG11c3QgYmUgYWxpZ25lZCB0byA4IGJ5dGVzLCBhbmQgdGhlcmUgYXJlIDE2CmVsZW1lbnRz
IGluIHRoZSBwbWMgYXJyYXksIHdoaWNoIG1lYW5zIG5vIHBhZGRpbmcgaXMgcmVxdWlyZWQgZm9y
IHRoZQpvdmVyZmxvd193b3JrIGZpZWxkLgoKVGhhbmtzLApBbGV4Cl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
