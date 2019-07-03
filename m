Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F73CC0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 09:11:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D14392189E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 09:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D14392189E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD714A4F8;
	Wed,  3 Jul 2019 05:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ho8yb6fvfKAZ; Wed,  3 Jul 2019 05:11:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E4D74A4E5;
	Wed,  3 Jul 2019 05:11:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 228F440A52
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 05:11:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xNzSoWpwZMB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 05:11:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A33A54A417
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 05:11:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DE15344;
 Wed,  3 Jul 2019 02:11:02 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D43CF3F246;
 Wed,  3 Jul 2019 02:11:00 -0700 (PDT)
Subject: Re: [PATCH 28/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit
 setting
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-29-marc.zyngier@arm.com>
 <f19e36aa-2468-899c-6f7c-bc215e4128eb@arm.com>
Message-ID: <4e0f2630-2405-e0f2-c745-131e1027b3bc@arm.com>
Date: Wed, 3 Jul 2019 10:10:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <f19e36aa-2468-899c-6f7c-bc215e4128eb@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

Ck9uIDcvMi8xOSA1OjMyIFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+IE9uIDYvMjEvMTkg
MTA6MzggQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gRnJvbTogSmludGFjayBMaW0gPGppbnRh
Y2tAY3MuY29sdW1iaWEuZWR1Pgo+Pgo+PiBGb3J3YXJkIEVMUl9FTDEsIFNQU1JfRUwxIGFuZCBW
QkFSX0VMMSB0cmFwcyB0byB0aGUgdmlydHVhbCBFTDIgaWYgdGhlCj4+IHZpcnR1YWwgSENSX0VM
Mi5OViBiaXQgaXMgc2V0Lgo+IEhDUl9FTDIuTlYxPwo+PiBUaGlzIGlzIGZvciByZWN1cnNpdmUg
bmVzdGVkIHZpcnR1YWxpemF0aW9uLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKaW50YWNrIExpbSA8
amludGFja0Bjcy5jb2x1bWJpYS5lZHU+Cj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8
bWFyYy56eW5naWVyQGFybS5jb20+Cj4+IC0tLQo+PiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9r
dm1fYXJtLmggfCAgMSArCj4+ICBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jICAgICAgICB8IDE5
ICsrKysrKysrKysrKysrKysrLS0KPj4gIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2FybS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXJtLmgKPj4gaW5kZXgg
ZDIxNDg2Mjc0ZWViLi41NWY0NTI1YzExMmMgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX2FybS5oCj4+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2Fy
bS5oCj4+IEBAIC0yNCw2ICsyNCw3IEBACj4+ICAKPj4gIC8qIEh5cCBDb25maWd1cmF0aW9uIFJl
Z2lzdGVyIChIQ1IpIGJpdHMgKi8KPj4gICNkZWZpbmUgSENSX0ZXQgkJKFVMKDEpIDw8IDQ2KQo+
PiArI2RlZmluZSBIQ1JfTlYxCQkoVUwoMSkgPDwgNDMpCj4+ICAjZGVmaW5lIEhDUl9OVgkJKFVM
KDEpIDw8IDQyKQo+PiAgI2RlZmluZSBIQ1JfQVBJCQkoVUwoMSkgPDwgNDEpCj4+ICAjZGVmaW5l
IEhDUl9BUEsJCShVTCgxKSA8PCA0MCkKPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4+IGluZGV4IDBmNzRiOTI3N2E4
Ni4uYmVhZGViY2ZjODg4IDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
Cj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4gQEAgLTQ3Myw4ICs0NzMsMTAg
QEAgc3RhdGljIGJvb2wgYWNjZXNzX3ZtX3JlZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+ICAJ
aWYgKGVsMTJfcmVnKHApICYmIGZvcndhcmRfbnZfdHJhcHModmNwdSkpCj4+ICAJCXJldHVybiBm
YWxzZTsKPj4gIAo+PiAtCWlmICghZWwxMl9yZWcocCkgJiYgZm9yd2FyZF92bV90cmFwcyh2Y3B1
LCBwKSkKPj4gLQkJcmV0dXJuIGt2bV9pbmplY3RfbmVzdGVkX3N5bmModmNwdSwga3ZtX3ZjcHVf
Z2V0X2hzcih2Y3B1KSk7Cj4+ICsJaWYgKCFlbDEyX3JlZyhwKSAmJiBmb3J3YXJkX3ZtX3RyYXBz
KHZjcHUsIHApKSB7Cj4+ICsJCWt2bV9pbmplY3RfbmVzdGVkX3N5bmModmNwdSwga3ZtX3ZjcHVf
Z2V0X2hzcih2Y3B1KSk7Cj4+ICsJCXJldHVybiBmYWxzZTsKPj4gKwl9Cj4+ICAKPj4gIAlCVUdf
T04oIXZjcHVfbW9kZV9lbDIodmNwdSkgJiYgIXAtPmlzX3dyaXRlKTsKPj4gIAo+PiBAQCAtMTY0
Myw2ICsxNjQ1LDEzIEBAIHN0YXRpYyBib29sIGFjY2Vzc19zcF9lbDEoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LAo+PiAgCXJldHVybiB0cnVlOwo+PiAgfQo+PiAgCj4+ICsKPj4gKy8qIFRoaXMgZnVu
Y3Rpb24gaXMgdG8gc3VwcG9ydCB0aGUgcmVjdXJzaXZlIG5lc3RlZCB2aXJ0dWFsaXphdGlvbiAq
Lwo+PiArc3RhdGljIGJvb2wgZm9yd2FyZF9udjFfdHJhcHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBzdHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnApCj4gV2h5IHRoZSBzdHJ1Y3Qgc3lzX3JlZ19wYXJh
bXMgKnAgYXJndW1lbnQ/IEl0IGlzbid0IHVzZWQgYnkgdGhlIGZ1bmN0aW9uLgo+PiArewo+PiAr
CXJldHVybiBmb3J3YXJkX3RyYXBzKHZjcHUsIEhDUl9OVjEpOwo+PiArfQo+PiArCj4+ICBzdGF0
aWMgYm9vbCBhY2Nlc3NfZWxyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gIAkJICAgICAgIHN0
cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCwKPj4gIAkJICAgICAgIGNvbnN0IHN0cnVjdCBzeXNfcmVn
X2Rlc2MgKnIpCj4+IEBAIC0xNjUwLDYgKzE2NTksOSBAQCBzdGF0aWMgYm9vbCBhY2Nlc3NfZWxy
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gIAlpZiAoZWwxMl9yZWcocCkgJiYgZm9yd2FyZF9u
dl90cmFwcyh2Y3B1KSkKPj4gIAkJcmV0dXJuIGZhbHNlOwo+PiAgCj4+ICsJaWYgKCFlbDEyX3Jl
ZyhwKSAmJiBmb3J3YXJkX252MV90cmFwcyh2Y3B1LCBwKSkKPj4gKwkJcmV0dXJuIGZhbHNlOwo+
PiArCj4+ICAJaWYgKHAtPmlzX3dyaXRlKQo+PiAgCQl2Y3B1LT5hcmNoLmN0eHQuZ3BfcmVncy5l
bHJfZWwxID0gcC0+cmVndmFsOwo+PiAgCWVsc2UKPj4gQEAgLTE2NjUsNiArMTY3Nyw5IEBAIHN0
YXRpYyBib29sIGFjY2Vzc19zcHNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gIAlpZiAoZWwx
Ml9yZWcocCkgJiYgZm9yd2FyZF9udl90cmFwcyh2Y3B1KSkKPj4gIAkJcmV0dXJuIGZhbHNlOwo+
PiAgCj4+ICsJaWYgKCFlbDEyX3JlZyhwKSAmJiBmb3J3YXJkX252MV90cmFwcyh2Y3B1LCBwKSkK
Pj4gKwkJcmV0dXJuIGZhbHNlOwo+PiArCj4+ICAJaWYgKHAtPmlzX3dyaXRlKQo+PiAgCQl2Y3B1
LT5hcmNoLmN0eHQuZ3BfcmVncy5zcHNyW0tWTV9TUFNSX0VMMV0gPSBwLT5yZWd2YWw7Cj4+ICAJ
ZWxzZQo+IFRoZSBjb21taXQgbWVzc2FnZSBtZW50aW9ucyBWQkFSX0VMMSwgYnV0IHRoZXJlJ3Mg
bm8gY2hhbmdlIHJlbGF0ZWQgdG8gaXQuCj4gUGFyaGFwcyB5b3UncmUgbWlzc2luZyB0aGlzIChi
dWlsZCB0ZXN0ZWQgb25seSk6Cj4KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3Jl
Z3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiBpbmRleCBiZDIxZjBmNDVhODYuLjA4
MmRjMzFmZjUzMyAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4gKysr
IGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+IEBAIC00MDEsNiArNDAxLDEyIEBAIHN0YXRp
YyBib29sIGVsMTJfcmVnKHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCkKPiDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gKHAtPk9wMSA9PSA1KTsKPiDCoH0KPiDCoAo+ICsvKiBUaGlzIGZ1bmN0aW9uIGlz
IHRvIHN1cHBvcnQgdGhlIHJlY3Vyc2l2ZSBuZXN0ZWQgdmlydHVhbGl6YXRpb24gKi8KPiArc3Rh
dGljIGJvb2wgZm9yd2FyZF9udjFfdHJhcHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qg
c3lzX3JlZ19wYXJhbXMgKnApCj4gK3sKPiArwqDCoMKgwqDCoMKgIHJldHVybiBmb3J3YXJkX3Ry
YXBzKHZjcHUsIEhDUl9OVjEpOwo+ICt9Cj4gKwo+IMKgc3RhdGljIGJvb2wgYWNjZXNzX3J3KHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgc3RydWN0IHN5c19yZWdfcGFyYW1zICpwLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyKQo+IEBA
IC00MDgsNiArNDE0LDEwIEBAIHN0YXRpYyBib29sIGFjY2Vzc19ydyhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsCj4gwqDCoMKgwqDCoMKgwqAgaWYgKGVsMTJfcmVnKHApICYmIGZvcndhcmRfbnZfdHJh
cHModmNwdSkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsK
PiDCoAo+ICvCoMKgwqDCoMKgwqAgaWYgKHN5c19yZWcocC0+T3AwLCBwLT5PcDEsIHAtPkNSbiwg
cC0+Q1JtLCBwLT5PcDIpID09IFNZU19WQkFSX0VMMSAmJgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oCBmb3J3YXJkX252MV90cmFwcyh2Y3B1LCBwKSkKCkFoZW0uLi4gdGhpcyBpcyBwcm9iYWJseSBi
ZXR0ZXI6CgorwqDCoMKgwqDCoMKgIGlmIChyLT5yZWcgPT0gVkJBUl9FTDEgJiYgZm9yd2FyZF9u
djFfdHJhcHModmNwdSwgcCkpCgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biBmYWxzZTsKPiArCj4gwqDCoMKgwqDCoMKgwqAgaWYgKHAtPmlzX3dyaXRlKQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1X3dyaXRlX3N5c19yZWcodmNwdSwgcC0+cmVndmFs
LCByLT5yZWcpOwo+IMKgwqDCoMKgwqDCoMKgIGVsc2UKPiBAQCAtMTc5NCwxMiArMTgwNCw2IEBA
IHN0YXRpYyBib29sIGZvcndhcmRfdHRsYl90cmFwcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4g
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZvcndhcmRfdHJhcHModmNwdSwgSENSX1RUTEIpOwo+IMKg
fQo+IMKgCj4gLS8qIFRoaXMgZnVuY3Rpb24gaXMgdG8gc3VwcG9ydCB0aGUgcmVjdXJzaXZlIG5l
c3RlZCB2aXJ0dWFsaXphdGlvbiAqLwo+IC1zdGF0aWMgYm9vbCBmb3J3YXJkX252MV90cmFwcyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCkKPiAtewo+IC3C
oMKgwqDCoMKgwqAgcmV0dXJuIGZvcndhcmRfdHJhcHModmNwdSwgSENSX05WMSk7Cj4gLX0KPiAt
Cj4gwqBzdGF0aWMgYm9vbCBhY2Nlc3NfZWxyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc3lzX3JlZ19w
YXJhbXMgKnAsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Y29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAqcikKPgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
