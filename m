Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79A3C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 16:43:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19B7D610C7
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 16:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19B7D610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D1D4A00B;
	Tue, 20 Jul 2021 12:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y5VuKB6bhZyi; Tue, 20 Jul 2021 12:43:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 386794A193;
	Tue, 20 Jul 2021 12:43:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E45214A00B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 12:43:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E662FnDx9Ofv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 12:43:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8530040FC7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 12:43:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A154C31B;
 Tue, 20 Jul 2021 09:43:34 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2B33F694;
 Tue, 20 Jul 2021 09:43:32 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
To: Marc Zyngier <maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-5-maz@kernel.org>
 <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
 <f2b655d0977cde5483716f58ba2ab739@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9ad0f6a5-fcd0-0179-efa7-7b35ed36e2ff@arm.com>
Date: Tue, 20 Jul 2021 17:44:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f2b655d0977cde5483716f58ba2ab739@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Russell King <linux@arm.linux.org.uk>, Robin Murphy <robin.murphy@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDcvMTkvMjEgNTo1NiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIEFs
ZXgsCj4KPiBPbiAyMDIxLTA3LTE5IDE3OjM1LCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+PiBI
aSBNYXJjLAo+Pgo+PiBPbiA3LzE5LzIxIDE6MzkgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+
IFdlIGtlZXAgYW4gZW50cnkgZm9yIHRoZSBQTVNXSU5DX0VMMCByZWdpc3RlciBpbiB0aGUgdmNw
dSBzdHJ1Y3R1cmUsCj4+PiB3aGlsZSAqbmV2ZXIqIHdyaXRpbmcgYW55dGhpbmcgdGhlcmUgb3V0
c2lkZSBvZiByZXNldC4KPj4+Cj4+PiBHaXZlbiB0aGF0IHRoZSByZWdpc3RlciBpcyBkZWZpbmVk
IGFzIHdyaXRlLW9ubHksIHRoYXQgd2UgYWx3YXlzCj4+PiB0cmFwIHdoZW4gdGhpcyByZWdpc3Rl
ciBpcyBhY2Nlc3NlZCwgdGhlcmUgaXMgbGl0dGxlIHBvaW50IGluIHNhdmluZwo+Pj4gYW55dGhp
bmcgYW55d2F5Lgo+Pj4KPj4+IEdldCByaWQgb2YgdGhlIGVudHJ5LCBhbmQgc2F2ZSBhIG1pZ2h0
eSA4IGJ5dGVzIHBlciB2Y3B1IHN0cnVjdHVyZS4KPj4+Cj4+PiBXZSBzdGlsbCBuZWVkIHRvIGtl
ZXAgaXQgZXhwb3NlZCB0byB1c2Vyc3BhY2UgaW4gb3JkZXIgdG8gcHJlc2VydmUKPj4+IGJhY2t3
YXJkIGNvbXBhdGliaWxpdHkgd2l0aCBwcmV2aW91c2x5IHNhdmVkIFZNcy4gU2luY2UgdXNlcnNw
YWNlCj4+PiBjYW5ub3QgZXhwZWN0IGFueSBlZmZlY3Qgb2Ygd3JpdGluZyB0byBQTVNXSU5DX0VM
MCwgdHJlYXQgdGhlCj4+PiByZWdpc3RlciBhcyBSQVovV0kgZm9yIHRoZSBwdXJwb3NlIG9mIHVz
ZXJzcGFjZSBhY2Nlc3MuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmggfMKgIDEgLQo+Pj4gwqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jwqDCoMKgwqDCoMKgwqDC
oCB8IDIxICsrKysrKysrKysrKysrKysrKysrLQo+Pj4gwqAyIGZpbGVzIGNoYW5nZWQsIDIwIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgKPj4+IGluZGV4IDQxOTExNTg1YWUwYy4uYWZjMTY5NjMwODg0IDEwMDY0NAo+Pj4g
LS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4+PiArKysgYi9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IEBAIC0xODUsNyArMTg1LDYgQEAgZW51bSB2
Y3B1X3N5c3JlZyB7Cj4+PiDCoMKgwqDCoCBQTUNOVEVOU0VUX0VMMCzCoMKgwqAgLyogQ291bnQg
RW5hYmxlIFNldCBSZWdpc3RlciAqLwo+Pj4gwqDCoMKgwqAgUE1JTlRFTlNFVF9FTDEswqDCoMKg
IC8qIEludGVycnVwdCBFbmFibGUgU2V0IFJlZ2lzdGVyICovCj4+PiDCoMKgwqDCoCBQTU9WU1NF
VF9FTDAswqDCoMKgIC8qIE92ZXJmbG93IEZsYWcgU3RhdHVzIFNldCBSZWdpc3RlciAqLwo+Pj4g
LcKgwqDCoCBQTVNXSU5DX0VMMCzCoMKgwqAgLyogU29mdHdhcmUgSW5jcmVtZW50IFJlZ2lzdGVy
ICovCj4+PiDCoMKgwqDCoCBQTVVTRVJFTlJfRUwwLMKgwqDCoCAvKiBVc2VyIEVuYWJsZSBSZWdp
c3RlciAqLwo+Pj4KPj4+IMKgwqDCoMKgIC8qIFBvaW50ZXIgQXV0aGVudGljYXRpb24gUmVnaXN0
ZXJzIGluIGEgc3RyaWN0IGluY3JlYXNpbmcgb3JkZXIuICovCj4+PiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+IGlu
ZGV4IGYyMjEzOTY1OGU0OC4uYTFmNTEwMWY0OWEzIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02
NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4g
QEAgLTEyODYsNiArMTI4NiwyMCBAQCBzdGF0aWMgaW50IHNldF9yYXpfaWRfcmVnKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgY29uc3QKPj4+IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAo+Pj4gwqDC
oMKgwqAgcmV0dXJuIF9fc2V0X2lkX3JlZyh2Y3B1LCByZCwgdWFkZHIsIHRydWUpOwo+Pj4gwqB9
Cj4+Pgo+Pj4gK3N0YXRpYyBpbnQgc2V0X3dpX3JlZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGNv
bnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGNvbnN0IHN0cnVjdCBrdm1fb25lX3JlZyAqcmVnLCB2b2lkIF9fdXNlciAqdWFkZHIpCj4+
PiArewo+Pj4gK8KgwqDCoCBpbnQgZXJyOwo+Pj4gK8KgwqDCoCB1NjQgdmFsOwo+Pj4gKwo+Pj4g
K8KgwqDCoCAvKiBQZXJmb3JtIHRoZSBhY2Nlc3MgZXZlbiBpZiB3ZSBhcmUgZ29pbmcgdG8gaWdu
b3JlIHRoZSB2YWx1ZSAqLwo+Pj4gK8KgwqDCoCBlcnIgPSByZWdfZnJvbV91c2VyKCZ2YWwsIHVh
ZGRyLCBzeXNfcmVnX3RvX2luZGV4KHJkKSk7Cj4+Cj4+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkg
dGhlIHJlYWQgc3RpbGwgaGFwcGVucyBpZiB0aGUgdmFsdWUgaXMgaWdub3JlZC4KPj4gSnVzdCBz
byBLVk0KPj4gcHJlc2VydmVzIHRoZSBwcmV2aW91cyBiZWhhdmlvdXIgYW5kIHRlbGxzIHVzZXJz
cGFjZSB0aGVyZSB3YXMgYW4gZXJyb3I/Cj4KPiBJZiB1c2Vyc3BhY2UgaGFzIGdpdmVuIHVzIGEg
ZHVmZiBwb2ludGVyLCBpdCBuZWVkcyB0byBrbm93IGFib3V0IGl0LgoKTWFrZXMgc2Vuc2UsIHRo
YW5rcy4KCj4KPj4+ICvCoMKgwqAgaWYgKGVycikKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4g
ZXJyOwo+Pj4gKwo+Pj4gK8KgwqDCoCByZXR1cm4gMDsKPj4+ICt9Cj4+PiArCj4+PiDCoHN0YXRp
YyBib29sIGFjY2Vzc19jdHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qgc3lzX3JlZ19w
YXJhbXMgKnAsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0
IHN5c19yZWdfZGVzYyAqcikKPj4+IMKgewo+Pj4gQEAgLTE2MjksOCArMTY0MywxMyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyBzeXNfcmVnX2Rlc2NzW10gPSB7Cj4+PiDCoMKg
wqDCoMKgwqAgLmFjY2VzcyA9IGFjY2Vzc19wbWNudGVuLCAucmVnID0gUE1DTlRFTlNFVF9FTDAg
fSwKPj4+IMKgwqDCoMKgIHsgUE1VX1NZU19SRUcoU1lTX1BNT1ZTQ0xSX0VMMCksCj4+PiDCoMKg
wqDCoMKgwqAgLmFjY2VzcyA9IGFjY2Vzc19wbW92cywgLnJlZyA9IFBNT1ZTU0VUX0VMMCB9LAo+
Pj4gK8KgwqDCoCAvKgo+Pj4gK8KgwqDCoMKgICogUE1fU1dJTkNfRUwwIGlzIGV4cG9zZWQgdG8g
dXNlcnNwYWNlIGFzIFJBWi9XSSwgYXMgaXQgd2FzCj4+PiArwqDCoMKgwqAgKiBwcmV2aW91c2x5
IChhbmQgcG9pbnRsZXNzbHkpIGFkdmVydGlzZWQgaW4gdGhlIHBhc3QuLi4KPj4+ICvCoMKgwqDC
oCAqLwo+Pj4gwqDCoMKgwqAgeyBQTVVfU1lTX1JFRyhTWVNfUE1TV0lOQ19FTDApLAo+Pj4gLcKg
wqDCoMKgwqAgLmFjY2VzcyA9IGFjY2Vzc19wbXN3aW5jLCAucmVnID0gUE1TV0lOQ19FTDAgfSwK
Pj4+ICvCoMKgwqDCoMKgIC5nZXRfdXNlciA9IGdldF9yYXpfaWRfcmVnLCAuc2V0X3VzZXIgPSBz
ZXRfd2lfcmVnLAo+Pgo+PiBJbiBteSBvcGluaW9uLCB0aGUgY2FsbCBjaGFpbiB0byByZXR1cm4g
MCBsb29rcyBwcmV0dHkgY29uZnVzaW5nIHRvIG1lLCBhcyB0aGUKPj4gZnVuY3Rpb25zIHNlZW1l
ZCBtYWRlIGZvciBJRCByZWdpc3RlciBhY2Nlc3NlcywgYW5kIHRoZSBsZWFmIGZ1bmN0aW9uLAo+
PiByZWFkX2lkX3JlZygpLCB0cmllcyB0byBtYXRjaCB0aGlzIHJlZ2lzdGVyIHdpdGggYSBsaXN0
IG9mIElECj4+IHJlZ2lzdGVycy4gU2luY2Ugd2UKPj4gaGF2ZSBhbHJlYWR5IGFkZGVkIGEgbmV3
IGZ1bmN0aW9uIGp1c3QgZm9yIFBNU1dJTkNfRUwwLCBJIHdhcwo+PiB3b25kZXJpbmcgaWYgYWRk
aW5nCj4+IGFub3RoZXIgZnVuY3Rpb24sIHNvbWV0aGluZyBsaWtlIGdldF9yYXpfcmVnKCksIHdv
dWxkIG1ha2UgbW9yZSBzZW5zZS4KPgo+IEluIHRoYXQgY2FzZSwgSSdkIHJhdGhlciBqdXN0IGtp
bGwgZ2V0X3Jhel9pZF9yZWcoKSBhbmQgcmVwbGFjZSBpdCB3aXRoCj4gdGhpcyBnZXRfcmF6X3Jl
ZygpLiBJZiB3ZSB0cmF0IHNvbWV0aGluZyBhcyBSQVosIHdobyBjYXJlcyB3aGV0aGVyIGl0IGlz
Cj4gYW4gaWRyZWcgb3Igbm90PwoKSSBhZ3JlZSwgdGhlIEFybSBBUk0gZG9lc24ndCBtYWtlIHRo
ZSBkaXN0aW5jdGlvbiBiZXR3ZWVuIElEIHJlZ2lzdGVycyBhbmQgb3RoZXIKc3lzdGVtIHJlZ2lz
dGVycyBpbiB0aGUgZGVmaW5pdGlvbiBvZiBSQVosIEkgZG9uJ3QgdGhpbmsgS1ZNIHNob3VsZCBl
aXRoZXIuIEFuZAp0aGUgd2F5IHJlYWRfaWRfcmVnKCkgaXMgd3JpdHRlbiBhbGxvd3MgcmV0dXJu
aW5nIGEgdmFsdWUgZGlmZmVyZW50IHRoYW4gMCBldmVuIGlmCnJheiBpcyB0cnVlLCB3aGljaCBp
biBteSBvcGluaW9uIGNvdWxkIG9ubHkgaGFwcGVuIGJlY2F1c2Ugb2YgYSBidWcgaW4gS1ZNLgoK
SSBjYW4gaGF2ZSBhIGdvIGF0IHdyaXRpbmcgdGhlIHBhdGNoKGVzKSBvbiB0b3Agb2YgdGhpcyBz
ZXJpZXMsIGlmIHlvdSB3YW50LiBBdAp0aGUgbW9tZW50IEknbSByZXdyaXRpbmcgdGhlIEtWTSBT
UEUgc2VyaWVzLCBzbyBpdCB3aWxsIGJlIGEgZmV3IHdlZWtzIHVudGlsIEkgZ2V0CmFyb3VuZCB0
byBkb2luZyBpdCB0aG91Z2guCgpUaGFua3MsCgpBbGV4CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
