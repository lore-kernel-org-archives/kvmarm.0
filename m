Return-Path: <SRS0=frvT=AT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9373FC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 16:22:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A27D2067D
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 16:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A27D2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 555804B189;
	Wed,  8 Jul 2020 12:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id czO0czAEWh0c; Wed,  8 Jul 2020 12:22:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 379A34B18A;
	Wed,  8 Jul 2020 12:22:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B73F4B127
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 12:22:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a9tU7yR+4+7c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2020 12:22:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9280E4B186
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 12:22:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AD0D31B;
 Wed,  8 Jul 2020 09:22:38 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 465573F68F;
 Wed,  8 Jul 2020 09:22:37 -0700 (PDT)
Subject: Re: [PATCH] arm64: kvm: Stop clobbering x0 for HVC_SOFT_RESTART
To: Marc Zyngier <maz@kernel.org>, Andrew Scull <ascull@google.com>
References: <20200706095259.1338221-1-ascull@google.com>
 <a765085746f61ed8deff396fae1d89a1@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <83615788-3efd-3b97-d95a-a71fb748766c@arm.com>
Date: Wed, 8 Jul 2020 17:22:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a765085746f61ed8deff396fae1d89a1@kernel.org>
Content-Language: en-GB
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywgQW5kcmV3LAoKT24gMDYvMDcvMjAyMCAxMToxMSwgTWFyYyBaeW5naWVyIHdyb3Rl
Ogo+IE9uIDIwMjAtMDctMDYgMTA6NTIsIEFuZHJldyBTY3VsbCB3cm90ZToKPj4gSFZDX1NPRlRf
UkVTVEFSVCBpcyBnaXZlbiB2YWx1ZXMgZm9yIHgwLTIgdGhhdCBpdCBzaG91bGQgaW5zdGFsbGVk
Cj4+IGJlZm9yZSBleGl0aW5nIHRvIHRoZSBuZXcgYWRkcmVzcyBzbyBzaG91bGQgbm90IHNldCB4
MCB0byBzdHViIEhWQwo+PiBzdWNjZXNzIG9yIGZhaWx1cmUgY29kZS4KCj4+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS9oeXAtaW5pdC5TIGIvYXJjaC9hcm02NC9rdm0vaHlwLWluaXQuUwo+
PiBpbmRleCA2ZTZlZDU1ODFlZWQuLmU3NmMwZTg5ZDQ4ZSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9h
cm02NC9rdm0vaHlwLWluaXQuUwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9oeXAtaW5pdC5TCj4+
IEBAIC0xMzYsMTEgKzEzNiwxNSBAQCBTWU1fQ09ERV9TVEFSVChfX2t2bV9oYW5kbGVfc3R1Yl9o
dmMpCj4+Cj4+IMKgMTrCoMKgwqAgY21wwqDCoMKgIHgwLCAjSFZDX1JFU0VUX1ZFQ1RPUlMKPj4g
wqDCoMKgwqAgYi5uZcKgwqDCoCAxZgo+PiAtcmVzZXQ6Cj4+ICsKPj4gwqDCoMKgwqAgLyoKPj4g
LcKgwqDCoMKgICogUmVzZXQga3ZtIGJhY2sgdG8gdGhlIGh5cCBzdHViLiBEbyBub3QgY2xvYmJl
ciB4MC14NCBpbgo+PiAtwqDCoMKgwqAgKiBjYXNlIHdlIGNvbWluZyB2aWEgSFZDX1NPRlRfUkVT
VEFSVC4KPj4gK8KgwqDCoMKgICogU2V0IHRoZSBIVkNfUkVTRVRfVkVDVE9SUyByZXR1cm4gY29k
ZSBiZWZvcmUgZW50ZXJpbmcgdGhlIGNvbW1vbgo+PiArwqDCoMKgwqAgKiBwYXRoIHNvIHRoYXQg
d2UgZG8gbm90IGNsb2JiZXIgeDAteDIgaW4gY2FzZSB3ZSBhcmUgY29taW5nIHZpYQo+PiArwqDC
oMKgwqAgKiBIVkNfU09GVF9SRVNUQVJULgo+PiDCoMKgwqDCoMKgICovCj4+ICvCoMKgwqAgbW92
wqDCoMKgIHgwLCB4enIKPj4gK3Jlc2V0Ogo+PiArwqDCoMKgIC8qIFJlc2V0IGt2bSBiYWNrIHRv
IHRoZSBoeXAgc3R1Yi4gKi8KPj4gwqDCoMKgwqAgbXJzwqDCoMKgIHg1LCBzY3Rscl9lbDIKPj4g
wqDCoMKgwqAgbW92X3HCoMKgwqAgeDYsIFNDVExSX0VMeF9GTEFHUwo+PiDCoMKgwqDCoCBiaWPC
oMKgwqAgeDUsIHg1LCB4NsKgwqDCoMKgwqDCoMKgIC8vIENsZWFyIFNDVExfTSBhbmQgZXRjCj4+
IEBAIC0xNTEsNyArMTU1LDYgQEAgcmVzZXQ6Cj4+IMKgwqDCoMKgIC8qIEluc3RhbGwgc3R1YiB2
ZWN0b3JzICovCj4+IMKgwqDCoMKgIGFkcl9swqDCoMKgIHg1LCBfX2h5cF9zdHViX3ZlY3RvcnMK
Pj4gwqDCoMKgwqAgbXNywqDCoMKgIHZiYXJfZWwyLCB4NQo+PiAtwqDCoMKgIG1vdsKgwqDCoCB4
MCwgeHpyCj4+IMKgwqDCoMKgIGVyZXQKPj4KPj4gwqAxOsKgwqDCoCAvKiBCYWQgc3R1YiBjYWxs
ICovCgo+IEh1aCwgbmljZSBjYXRjaC4gSSB3b25kZXIgd2hhdCB0aGUgZnVzcyBpcyBhYm91dCBr
ZXhlYywgcmVhbGx5LAo+IGdpdmVuIHRoYXQgaXQgaXMgKnRoYXQqIGJyb2tlbi4KClRoaXMgd291
bGQgb25seSBiaXRlIGtkdW1wIG9uIGEgdjguMCBtYWNoaW5lIHdhcyBhbHNvIHJ1bm5pbmcgYSBL
Vk0gZ3Vlc3QuCgpSZWd1bGFyIGtleGVjIHdvdWxkIGhhcHBlbiBhZnRlciBLVk0ncyBrdm1fcmVi
b290X25vdGlmaWVyKCkgaGFzIGNhbGxlZApoYXJkd2FyZV9kaXNhYmxlX25vbG9jaygpIHdoaWNo
IHVubG9hZHMgS1ZNIGFuZCByZXN0b3JlcyB0aGUgaHlwLXN0dWIuCgpJJ20gZ2xhZCBpdHMgYmVl
biBjYXVnaHQgYW5kIGZpeGVkIQoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
