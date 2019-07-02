Return-Path: <SRS0=KAXL=U7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E318C06510
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 16:32:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D319921721
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 16:32:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D319921721
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7374A4CD;
	Tue,  2 Jul 2019 12:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZCMybuzJKjHr; Tue,  2 Jul 2019 12:32:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFADE4A4DF;
	Tue,  2 Jul 2019 12:32:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4774A4CD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 12:32:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y7Jl5o+WvZb3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 12:32:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56F084A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 12:32:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAB4D28;
 Tue,  2 Jul 2019 09:32:15 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42B273F246;
 Tue,  2 Jul 2019 09:32:14 -0700 (PDT)
Subject: Re: [PATCH 28/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit
 setting
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-29-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f19e36aa-2468-899c-6f7c-bc215e4128eb@arm.com>
Date: Tue, 2 Jul 2019 17:32:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-29-marc.zyngier@arm.com>
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

Ck9uIDYvMjEvMTkgMTA6MzggQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBGcm9tOiBKaW50YWNr
IExpbSA8amludGFja0Bjcy5jb2x1bWJpYS5lZHU+Cj4KPiBGb3J3YXJkIEVMUl9FTDEsIFNQU1Jf
RUwxIGFuZCBWQkFSX0VMMSB0cmFwcyB0byB0aGUgdmlydHVhbCBFTDIgaWYgdGhlCj4gdmlydHVh
bCBIQ1JfRUwyLk5WIGJpdCBpcyBzZXQuCkhDUl9FTDIuTlYxPwo+Cj4gVGhpcyBpcyBmb3IgcmVj
dXJzaXZlIG5lc3RlZCB2aXJ0dWFsaXphdGlvbi4KPgo+IFNpZ25lZC1vZmYtYnk6IEppbnRhY2sg
TGltIDxqaW50YWNrQGNzLmNvbHVtYmlhLmVkdT4KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdp
ZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgo+IC0tLQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9hcm0uaCB8ICAxICsKPiAgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyAgICAgICAgfCAx
OSArKysrKysrKysrKysrKysrKy0tCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9hcm0uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oCj4gaW5kZXggZDIx
NDg2Mjc0ZWViLi41NWY0NTI1YzExMmMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fYXJtLmgKPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hcm0uaAo+
IEBAIC0yNCw2ICsyNCw3IEBACj4gIAo+ICAvKiBIeXAgQ29uZmlndXJhdGlvbiBSZWdpc3RlciAo
SENSKSBiaXRzICovCj4gICNkZWZpbmUgSENSX0ZXQgkJKFVMKDEpIDw8IDQ2KQo+ICsjZGVmaW5l
IEhDUl9OVjEJCShVTCgxKSA8PCA0MykKPiAgI2RlZmluZSBIQ1JfTlYJCShVTCgxKSA8PCA0MikK
PiAgI2RlZmluZSBIQ1JfQVBJCQkoVUwoMSkgPDwgNDEpCj4gICNkZWZpbmUgSENSX0FQSwkJKFVM
KDEpIDw8IDQwKQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJj
aC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+IGluZGV4IDBmNzRiOTI3N2E4Ni4uYmVhZGViY2ZjODg4
IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS9zeXNfcmVncy5jCj4gQEAgLTQ3Myw4ICs0NzMsMTAgQEAgc3RhdGljIGJvb2wgYWNj
ZXNzX3ZtX3JlZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gIAlpZiAoZWwxMl9yZWcocCkgJiYg
Zm9yd2FyZF9udl90cmFwcyh2Y3B1KSkKPiAgCQlyZXR1cm4gZmFsc2U7Cj4gIAo+IC0JaWYgKCFl
bDEyX3JlZyhwKSAmJiBmb3J3YXJkX3ZtX3RyYXBzKHZjcHUsIHApKQo+IC0JCXJldHVybiBrdm1f
aW5qZWN0X25lc3RlZF9zeW5jKHZjcHUsIGt2bV92Y3B1X2dldF9oc3IodmNwdSkpOwo+ICsJaWYg
KCFlbDEyX3JlZyhwKSAmJiBmb3J3YXJkX3ZtX3RyYXBzKHZjcHUsIHApKSB7Cj4gKwkJa3ZtX2lu
amVjdF9uZXN0ZWRfc3luYyh2Y3B1LCBrdm1fdmNwdV9nZXRfaHNyKHZjcHUpKTsKPiArCQlyZXR1
cm4gZmFsc2U7Cj4gKwl9Cj4gIAo+ICAJQlVHX09OKCF2Y3B1X21vZGVfZWwyKHZjcHUpICYmICFw
LT5pc193cml0ZSk7Cj4gIAo+IEBAIC0xNjQzLDYgKzE2NDUsMTMgQEAgc3RhdGljIGJvb2wgYWNj
ZXNzX3NwX2VsMShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gIAlyZXR1cm4gdHJ1ZTsKPiAgfQo+
ICAKPiArCj4gKy8qIFRoaXMgZnVuY3Rpb24gaXMgdG8gc3VwcG9ydCB0aGUgcmVjdXJzaXZlIG5l
c3RlZCB2aXJ0dWFsaXphdGlvbiAqLwo+ICtzdGF0aWMgYm9vbCBmb3J3YXJkX252MV90cmFwcyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCkKV2h5IHRoZSBz
dHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnAgYXJndW1lbnQ/IEl0IGlzbid0IHVzZWQgYnkgdGhlIGZ1
bmN0aW9uLgo+ICt7Cj4gKwlyZXR1cm4gZm9yd2FyZF90cmFwcyh2Y3B1LCBIQ1JfTlYxKTsKPiAr
fQo+ICsKPiAgc3RhdGljIGJvb2wgYWNjZXNzX2VscihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4g
IAkJICAgICAgIHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCwKPiAgCQkgICAgICAgY29uc3Qgc3Ry
dWN0IHN5c19yZWdfZGVzYyAqcikKPiBAQCAtMTY1MCw2ICsxNjU5LDkgQEAgc3RhdGljIGJvb2wg
YWNjZXNzX2VscihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gIAlpZiAoZWwxMl9yZWcocCkgJiYg
Zm9yd2FyZF9udl90cmFwcyh2Y3B1KSkKPiAgCQlyZXR1cm4gZmFsc2U7Cj4gIAo+ICsJaWYgKCFl
bDEyX3JlZyhwKSAmJiBmb3J3YXJkX252MV90cmFwcyh2Y3B1LCBwKSkKPiArCQlyZXR1cm4gZmFs
c2U7Cj4gKwo+ICAJaWYgKHAtPmlzX3dyaXRlKQo+ICAJCXZjcHUtPmFyY2guY3R4dC5ncF9yZWdz
LmVscl9lbDEgPSBwLT5yZWd2YWw7Cj4gIAllbHNlCj4gQEAgLTE2NjUsNiArMTY3Nyw5IEBAIHN0
YXRpYyBib29sIGFjY2Vzc19zcHNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiAgCWlmIChlbDEy
X3JlZyhwKSAmJiBmb3J3YXJkX252X3RyYXBzKHZjcHUpKQo+ICAJCXJldHVybiBmYWxzZTsKPiAg
Cj4gKwlpZiAoIWVsMTJfcmVnKHApICYmIGZvcndhcmRfbnYxX3RyYXBzKHZjcHUsIHApKQo+ICsJ
CXJldHVybiBmYWxzZTsKPiArCj4gIAlpZiAocC0+aXNfd3JpdGUpCj4gIAkJdmNwdS0+YXJjaC5j
dHh0LmdwX3JlZ3Muc3BzcltLVk1fU1BTUl9FTDFdID0gcC0+cmVndmFsOwo+ICAJZWxzZQoKVGhl
IGNvbW1pdCBtZXNzYWdlIG1lbnRpb25zIFZCQVJfRUwxLCBidXQgdGhlcmUncyBubyBjaGFuZ2Ug
cmVsYXRlZCB0byBpdC4KUGFyaGFwcyB5b3UncmUgbWlzc2luZyB0aGlzIChidWlsZCB0ZXN0ZWQg
b25seSk6CgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMKaW5kZXggYmQyMWYwZjQ1YTg2Li4wODJkYzMxZmY1MzMgMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKKysrIGIvYXJjaC9hcm02NC9rdm0vc3lz
X3JlZ3MuYwpAQCAtNDAxLDYgKzQwMSwxMiBAQCBzdGF0aWMgYm9vbCBlbDEyX3JlZyhzdHJ1Y3Qg
c3lzX3JlZ19wYXJhbXMgKnApCsKgwqDCoMKgwqDCoMKgIHJldHVybiAocC0+T3AxID09IDUpOwrC
oH0KwqAKKy8qIFRoaXMgZnVuY3Rpb24gaXMgdG8gc3VwcG9ydCB0aGUgcmVjdXJzaXZlIG5lc3Rl
ZCB2aXJ0dWFsaXphdGlvbiAqLworc3RhdGljIGJvb2wgZm9yd2FyZF9udjFfdHJhcHMoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnApCit7CivCoMKgwqDCoMKg
wqAgcmV0dXJuIGZvcndhcmRfdHJhcHModmNwdSwgSENSX05WMSk7Cit9CisKwqBzdGF0aWMgYm9v
bCBhY2Nlc3Nfcncoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LArCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHN5c19yZWdfcGFyYW1zICpwLArCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVz
YyAqcikKQEAgLTQwOCw2ICs0MTQsMTAgQEAgc3RhdGljIGJvb2wgYWNjZXNzX3J3KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwKwqDCoMKgwqDCoMKgwqAgaWYgKGVsMTJfcmVnKHApICYmIGZvcndhcmRf
bnZfdHJhcHModmNwdSkpCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZmFs
c2U7CsKgCivCoMKgwqDCoMKgwqAgaWYgKHN5c19yZWcocC0+T3AwLCBwLT5PcDEsIHAtPkNSbiwg
cC0+Q1JtLCBwLT5PcDIpID09IFNZU19WQkFSX0VMMSAmJgorwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Zm9yd2FyZF9udjFfdHJhcHModmNwdSwgcCkpCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiBmYWxzZTsKKwrCoMKgwqDCoMKgwqDCoCBpZiAocC0+aXNfd3JpdGUpCsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1X3dyaXRlX3N5c19yZWcodmNwdSwgcC0+cmVndmFs
LCByLT5yZWcpOwrCoMKgwqDCoMKgwqDCoCBlbHNlCkBAIC0xNzk0LDEyICsxODA0LDYgQEAgc3Rh
dGljIGJvb2wgZm9yd2FyZF90dGxiX3RyYXBzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIGZvcndhcmRfdHJhcHModmNwdSwgSENSX1RUTEIpOwrCoH0KwqAKLS8q
IFRoaXMgZnVuY3Rpb24gaXMgdG8gc3VwcG9ydCB0aGUgcmVjdXJzaXZlIG5lc3RlZCB2aXJ0dWFs
aXphdGlvbiAqLwotc3RhdGljIGJvb2wgZm9yd2FyZF9udjFfdHJhcHMoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBzdHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnApCi17Ci3CoMKgwqDCoMKgwqAgcmV0dXJu
IGZvcndhcmRfdHJhcHModmNwdSwgSENSX05WMSk7Ci19Ci0KwqBzdGF0aWMgYm9vbCBhY2Nlc3Nf
ZWxyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgc3RydWN0IHN5c19yZWdfcGFyYW1zICpwLArCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpy
KQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
