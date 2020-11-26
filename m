Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB75C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:48:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4655C21D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4655C21D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F42F4B8EE;
	Thu, 26 Nov 2020 10:48:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJ8IFWfLrz8d; Thu, 26 Nov 2020 10:48:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F504BAFE;
	Thu, 26 Nov 2020 10:48:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6514BAF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:48:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQNTAKPFjxpM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:48:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12A44B8EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:48:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58E0A31B;
 Thu, 26 Nov 2020 07:48:22 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F79F3F23F;
 Thu, 26 Nov 2020 07:48:21 -0800 (PST)
Subject: Re: [PATCH 3/8] KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at
 reset time
To: Marc Zyngier <maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-4-maz@kernel.org>
 <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
 <7abf75c1d1248a9c0e3fcb7737a101c0@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <255bcc41-6e1c-d5ac-5643-7fbc5831a938@arm.com>
Date: Thu, 26 Nov 2020 15:49:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <7abf75c1d1248a9c0e3fcb7737a101c0@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDExLzI2LzIwIDM6MjUgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBB
bGV4LAo+Cj4gT24gMjAyMC0xMS0yNiAxNDo1OSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4g
SGkgTWFyYywKPj4KPj4gT24gMTEvMTMvMjAgNjoyNSBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+
Pj4gV2UgYWNjZXB0IHRvIGNvbmZpZ3VyZSBhIFBNVSB3aGVuIGEgdmNwdSBpcyBjcmVhdGVkLCBl
dmVuIGlmIHRoZQo+Pj4gSFcgKG9yIHRoZSBob3N0KSBkb2Vzbid0IHN1cHBvcnQgaXQuIFRoaXMg
cmVzdWx0cyBpbiBmYWlsdXJlcwo+Pj4gd2hlbiBhdHRyaWJ1dGVzIGdldCBzZXQsIHdoaWNoIGlz
IGEgYml0IG9kZCBhcyB3ZSBzaG91bGQgaGF2ZQo+Pj4gZmFpbGVkIHRoZSB2Y3B1IGNyZWF0aW9u
IHRoZSBmaXJzdCBwbGFjZS4KPj4+Cj4+PiBNb3ZlIHRoZSBjaGVjayB0byB0aGUgcG9pbnQgd2hl
cmUgd2UgY2hlY2sgdGhlIHZjcHUgZmVhdHVyZSBzZXQsCj4+PiBhbmQgZmFpbCBlYXJseSBpZiB3
ZSBjYW5ub3Qgc3VwcG9ydCBhIFBNVS4gVGhpcyBmdXJ0aGVyIHNpbXBsaWZpZXMKPj4+IHRoZSBh
dHRyaWJ1dGUgaGFuZGxpbmcuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxt
YXpAa2VybmVsLm9yZz4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jIHwg
NCArKy0tCj4+PiDCoGFyY2gvYXJtNjQva3ZtL3Jlc2V0LmPCoMKgwqAgfCA0ICsrKysKPj4+IMKg
MiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Pgo+Pj4g
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMgYi9hcmNoL2FybTY0L2t2bS9w
bXUtZW11bC5jCj4+PiBpbmRleCBlN2UzYjQ2Mjk4NjQuLjIwMGYyYTBkOGQxNyAxMDA2NDQKPj4+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMKPj4+IEBAIC05MTMsNyArOTEzLDcgQEAgc3RhdGljIGJvb2wgcG11X2lycV9p
c192YWxpZChzdHJ1Y3Qga3ZtICprdm0sIGludCBpcnEpCj4+Pgo+Pj4gwqBpbnQga3ZtX2FybV9w
bXVfdjNfc2V0X2F0dHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX2RldmljZV9h
dHRyICphdHRyKQo+Pj4gwqB7Cj4+PiAtwqDCoMKgIGlmICgha3ZtX2FybV9zdXBwb3J0X3BtdV92
MygpIHx8ICFrdm1fdmNwdV9oYXNfcG11KHZjcHUpKQo+Pj4gK8KgwqDCoCBpZiAoIWt2bV92Y3B1
X2hhc19wbXUodmNwdSkpCj4+PiDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PREVWOwo+Pj4K
Pj4+IMKgwqDCoMKgIGlmICh2Y3B1LT5hcmNoLnBtdS5jcmVhdGVkKQo+Pj4gQEAgLTEwMzQsNyAr
MTAzNCw3IEBAIGludCBrdm1fYXJtX3BtdV92M19oYXNfYXR0cihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsCj4+PiBzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyICphdHRyKQo+Pj4gwqDCoMKgwqAgY2FzZSBL
Vk1fQVJNX1ZDUFVfUE1VX1YzX0lSUToKPj4+IMKgwqDCoMKgIGNhc2UgS1ZNX0FSTV9WQ1BVX1BN
VV9WM19JTklUOgo+Pj4gwqDCoMKgwqAgY2FzZSBLVk1fQVJNX1ZDUFVfUE1VX1YzX0ZJTFRFUjoK
Pj4+IC3CoMKgwqDCoMKgwqDCoCBpZiAoa3ZtX2FybV9zdXBwb3J0X3BtdV92MygpICYmIGt2bV92
Y3B1X2hhc19wbXUodmNwdSkpCj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGt2bV92Y3B1X2hhc19w
bXUodmNwdSkpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+PiDCoMKg
wqDCoCB9Cj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMgYi9hcmNo
L2FybTY0L2t2bS9yZXNldC5jCj4+PiBpbmRleCA3NGNlOTJhNDk4OGMuLjNlNzcyZWE0ZTA2NiAx
MDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKPj4+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3Jlc2V0LmMKPj4+IEBAIC0yODUsNiArMjg1LDEwIEBAIGludCBrdm1fcmVzZXRfdmNw
dShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHN0
YXRlID0gVkNQVV9SRVNFVF9QU1RBVEVfRUwxOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4+Pgo+
Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChrdm1fdmNwdV9oYXNfcG11KHZjcHUpICYmICFrdm1fYXJt
X3N1cHBvcnRfcG11X3YzKCkpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1F
SU5WQUw7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+ICvCoMKgwqDC
oMKgwqDCoCB9Cj4+Cj4+IFRoaXMgbG9va3MgY29ycmVjdCwgYnV0IHJpZ2h0IGF0IHRoZSBiZWdp
bm5pbmcgb2YgdGhlIGZ1bmN0aW9uLCBiZWZvcmUgdGhpcwo+PiBub24tcHJlZW1wdGlibGUgc2Vj
dGlvbiwgd2UgZG8ga3ZtX3BtdV92Y3B1X3Jlc2V0KCksIHdoaWNoIGlzIHdyb25nIGZvciBzZXZl
cmFsCj4+IHJlYXNvbnM6Cj4+Cj4+IC0gd2UgZG9uJ3QgY2hlY2sgaWYgdGhlIGZlYXR1cmUgZmxh
ZyBpcyBzZXQKPj4gLSB3ZSBkb24ndCBjaGVjayBpZiB0aGUgaGFyZHdhcmUgc3VwcG9ydHMgYSBQ
TVUKPj4gLSBrdm1fcG11X3ZjcHVfcmVzZXQoKSByZWxpZXMgb24gX192Y3B1X3N5c19yZWcodmNw
dSwgUE1DUl9FTDApLCB3aGljaCBpcyBzZXQgaW4KPj4ga3ZtX3Jlc2V0X3N5c19yZWdzKCkgYmVs
b3cgd2hlbiB0aGUgVkNQVSBpcyBpbml0aWFsaXplZC4KPgo+IEknbSBub3Qgc3VyZSBpdCBhY3R1
YWxseSBtYXR0ZXJzLiBIZXJlJ3MgbXkgcmF0aW9uYWw6Cj4KPiAtIFBNVSBzdXBwb3J0IG5vdCBj
b21waWxlZCBpbjogbm8gcHJvYmxlbSEKPiAtIFBNVSBzdXBwb3J0IGNvbXBpbGVkIGluLCBidXQg
bm8gSFcgUE1VOiB3ZSBqdXN0IHJlc2V0IHNvbWUgc3RhdGUgdG8gMCwgbm8gaGFybQo+IGRvbmUK
PiAtIEhXIFBNVSwgYnV0IG5vIEtWTSBQTVUgZm9yIHRoaXMgdmNwdTogc2FtZSB0aGluZwo+IC0g
SFcgUE1VLCBhbmQgS1ZNIFBNVTogd2UgZG8gdGhlIHJpZ2h0IHRoaW5nIQo+Cj4gQW0gSSBtaXNz
aW5nIGFueXRoaW5nPwoKSSBkb24ndCB0aGluayBzbywgaXQgYWxzbyBsb29rcyBoYXJtbGVzcyB0
byBtZS4gV2hlbiBpdCdzIGNhbGxlZCBvbiB0aGUgVkNQVSBpbml0CnBhdGgsIHRoZXJlIHdpbGwg
YmUgbm8gcGVyZl9ldmVudHMsIHNvIHRoYXQgcGFydCB3aWxsIGJlIHNraXBwZWQuIE9uIHRoZSBy
ZXNldApwYXRoLCBQTUNSX0VMMC5OIHdpbGwgaGF2ZSBiZWVuIGluaXRpYWxpemVkIHNvIHdlIGVu
ZCB1cCB3aXRoIHRoZSBjb3JyZWN0IG51bWJlcgpvZiBjb3VudGVycy4gSW4gYm90aCBjYXNlcyB2
Y3B1LT5hcmNoLnBtdS5jaGFpbmVkIHdpbGwgYmUgemVybydlZAoKQnV0IEkgZmluZCBpdCBzdHJh
bmdlIHRvIHJlc2V0IHRoZSBQTVUgYmVmb3JlIGRvaW5nIGFueSBjaGVja3MgYW5kIGJlZm9yZSBz
ZXR0aW5nCnRoZSBWQ1BVIHJlZ2lzdGVyIHZhbHVlIGl0IHJlYWRzLgoKSSBhbSB0aGlua2luZyB0
aGF0IGV2ZW4gdGhvdWdoIGF0IHRoZSBtb21lbnQgaXQncyBoYXJtbGVzcywgaW4gdGhlIGZ1dHVy
ZSB0aGUKZnVuY3Rpb24gbWlnaHQgY2hhbmdlIGFuZCBJIGRvbid0IHRoaW5rIHdob2V2ZXIgbW9k
aWZpZXMgaXQgd2lsbCBleHBlY3QgdGhlCmZ1bmN0aW9uIHRvIGJlIGNhbGxlZCBsaWtlIHRoaXMu
IEJ1dCBJIGd1ZXNzIGlmIHdlJ3JlIHZpZ2lsYW50IGVub3VnaCB3ZSBjYW4KcHJldmVudCB0aGF0
IGh5cG90aGV0aWNhbCBzaXR1YXRpb24gZnJvbSBoYXBwZW5pbmcuCgpUaGFua3MsCkFsZXgKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
