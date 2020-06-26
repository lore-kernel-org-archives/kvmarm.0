Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BE4C433E3
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 16:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AF3B207FC
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 16:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF3B207FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D154F4B117;
	Fri, 26 Jun 2020 12:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eNjUe-eMjbad; Fri, 26 Jun 2020 12:41:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DB84B109;
	Fri, 26 Jun 2020 12:41:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AD314B106
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 12:41:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wsnCw+brI6zk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2020 12:40:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E3E4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 12:40:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F2801FB;
 Fri, 26 Jun 2020 09:40:58 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1AFF3F6CF;
 Fri, 26 Jun 2020 09:40:56 -0700 (PDT)
Subject: Re: [RFC PATCH 2/2] arm64: kvm: Introduce MTE VCPU feature
To: Steven Price <steven.price@arm.com>
References: <20200617123844.29960-1-steven.price@arm.com>
 <20200617123844.29960-3-steven.price@arm.com> <20200617143809.GF5388@gaia>
 <9d4ef6cf-2333-83b8-c555-e70b99b95b28@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <c2883b2b-6c71-f5ee-74b7-4e4d08d2183c@arm.com>
Date: Fri, 26 Jun 2020 17:40:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9d4ef6cf-2333-83b8-c555-e70b99b95b28@arm.com>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dave P Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>,
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

SGkgU3RldmUsCgpPbiAxNy8wNi8yMDIwIDE2OjM0LCBTdGV2ZW4gUHJpY2Ugd3JvdGU6Cj4gT24g
MTcvMDYvMjAyMCAxNTozOCwgQ2F0YWxpbiBNYXJpbmFzIHdyb3RlOgo+PiBPbiBXZWQsIEp1biAx
NywgMjAyMCBhdCAwMTozODo0NFBNICswMTAwLCBTdGV2ZW4gUHJpY2Ugd3JvdGU6Cj4+PiBkaWZm
IC0tZ2l0IGEvdmlydC9rdm0vYXJtL21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+PiBpbmRl
eCBlM2I5ZWUyNjg4MjMuLjA0MGE3ZmZmYWE5MyAxMDA2NDQKPj4+IC0tLSBhL3ZpcnQva3ZtL2Fy
bS9tbXUuYwo+Pj4gKysrIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+PiBAQCAtMTc4Myw2ICsxNzgz
LDE3IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBw
aHlzX2FkZHJfdAo+Pj4gZmF1bHRfaXBhLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dm1hX3BhZ2VzaXplID0gUE1EX1NJWkU7Cj4+PiDCoMKgwqDCoMKgIH0KPj4+IMKgICvCoMKgwqAg
aWYgKHN5c3RlbV9zdXBwb3J0c19tdGUoKSAmJiBrdm0tPmFyY2gudmNwdV9oYXNfbXRlKSB7Cj4+
PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4+ICvCoMKgwqDCoMKgwqDCoMKgICogVk0gd2lsbCBiZSBh
YmxlIHRvIHNlZSB0aGUgcGFnZSdzIHRhZ3MsIHNvIHdlIG11c3QgZW5zdXJlCj4+PiArwqDCoMKg
wqDCoMKgwqDCoCAqIHRoZXkgaGF2ZSBiZWVuIGluaXRpYWxpc2VkLgo+Pj4gK8KgwqDCoMKgwqDC
oMKgwqAgKi8KPj4+ICvCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgcGFnZSAqcGFnZSA9IHBmbl90b19w
YWdlKHBmbik7Cj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKCF0ZXN0X2FuZF9zZXRfYml0
KFBHX210ZV90YWdnZWQsICZwYWdlLT5mbGFncykpCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtdGVfY2xlYXJfcGFnZV90YWdzKHBhZ2VfYWRkcmVzcyhwYWdlKSwgcGFnZV9zaXplKHBhZ2Up
KTsKPj4+ICvCoMKgwqAgfQo+Pgo+PiBBcmUgYWxsIHRoZSBndWVzdCBwYWdlcyBhbHdheXMgbWFw
cGVkIHZpYSBhIFN0YWdlIDIgZmF1bHQ/IEl0IG1heSBiZQo+PiBiZXR0ZXIgaWYgd2UgZGlkIHRo
YXQgdmlhIGt2bV9zZXRfc3B0ZV9odmEoKS4KCj4gSSB3YXMgdW5kZXIgdGhlIGltcHJlc3Npb24g
dGhhdCBwYWdlcyBhcmUgYWx3YXlzIGZhdWx0ZWQgaW50byB0aGUgc3RhZ2UgMiwgYnV0IEkgaGF2
ZSB0bwo+IGFkbWl0IEknbSBub3QgMTAwJSBzdXJlIGFib3V0IHRoYXQuCgpJIHRoaW5rIHRoZXJl
IGlzIG9ubHkgb25lIGNhc2U6IFZNQSB3aXRoIFZNX1BGTk1BUCBzZXQgd2lsbCBnZXQgcHJlLXBv
cHVsYXRlZCBkdXJpbmcKa3ZtX2FyY2hfcHJlcGFyZV9tZW1vcnlfcmVnaW9uKCksIGJ1dCB0aGV5
IGFyZSBhbHdheXMgbWFkZSBkZXZpY2UgYXQgc3RhZ2UyLCBzbyBNVEUgaXNuJ3QKYSBjb25jZXJu
IHRoZXJlLgoKCj4ga3ZtX3NldF9zcHRlX2h2YSgpIG1heSBiZSBtb3JlIGFwcHJvcHJpYXRlLCBh
bHRob3VnaCBvbiBmaXJzdCBsb29rIEkgZG9uJ3QgdW5kZXJzdGFuZCBob3cKPiB0aGF0IGZ1bmN0
aW9uIGRlYWxzIHdpdGggaHVnZSBwYWdlcy4gSXMgaXQgYWN0dWFsbHkgY2FsbGVkIGZvciBub3Jt
YWwgbWFwcGluZ3Mgb3Igb25seSBmb3IKPiBjaGFuZ2VzIGR1ZSB0byB0aGUgbGlrZXMgb2YgS1NN
PwoKSXQgbG9va3MgbGlrZSBpdHMgb25seSBjYWxsZWQgdGhyb3VnaCBzZXRfcHRlX2F0X25vdGlm
eSgpLCB3aGljaCBpcyB1c2VkIGJ5IHRoaW5ncyBsaWtlCktTTS9DT1cgdGhhdCBjaGFuZ2UgYSBt
YXBwaW5nLCBhbmQgcmVhbGx5IGRvbid0IHdhbnQgdG8gZmF1bHQgaXQgYSBzZWNvbmQgdGltZS4g
SSBndWVzcwp0aGV5IGFyZSBvbmx5IGZvciBQQUdFX1NJWkUgbWFwcGluZ3MuCgpPdGhlciBtYXBw
aW5nIHNpemVzIHdvdWxkIGdldCBmYXVsdGVkIGluIGJ5IHVzZXJfbWVtX2Fib3J0KCkuCgoKSSB0
aGluayB0aGlzIHNob3VsZCBoYXBwZW4gaW4gdGhlIHNhbWUgcGxhY2VzIGFzIHdlIGNsZWFuIG5l
dyBwYWdlcyB0byBQb0MsIGFzIHRoYXQgaXMKYWxzbyBhbiBhZGRpdGlvbmFsIHBpZWNlIG9mIG1h
aW50ZW5hbmNlIEtWTSBoYXMgdG8gZG8gdGhhdCB0aGUgaG9zdCdzIHN0YWdlIDEgZG9lc24ndC4K
CllvdSBtYXkgYmUgYWJsZSB0byByZW5hbWUgY2xlYW5fZGNhY2hlX2d1ZXN0X3BhZ2UoKSB0byBl
bmNvbXBhc3MgbWFpbnRlbmFuY2UgdGhhdCB3ZSBuZWVkCndoZW4gYSBwYWdlIGlzIGFjY2Vzc2li
bGUgdG8gYSBkaWZmZXJlbnQgRUwxLgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
