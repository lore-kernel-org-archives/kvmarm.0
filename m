Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C681DC433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 09:01:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37B4820709
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 09:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37B4820709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 563724B23E;
	Wed,  2 Sep 2020 05:01:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iA4MBR0UB5rC; Wed,  2 Sep 2020 05:01:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1844D4B236;
	Wed,  2 Sep 2020 05:01:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BAC74B228
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 05:01:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3l-rc0woK53A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 05:01:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A954B227
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 05:01:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D9DC31B;
 Wed,  2 Sep 2020 02:01:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2B043F68F;
 Wed,  2 Sep 2020 02:01:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Try PMD block mappings if PUD mappings
 are not supported
To: Gavin Shan <gshan@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-3-alexandru.elisei@arm.com>
 <583211e4-b997-8539-6147-d86cc0cbdbb2@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <694973e4-2754-1ef4-914b-d7200472cccb@arm.com>
Date: Wed, 2 Sep 2020 10:01:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <583211e4-b997-8539-6147-d86cc0cbdbb2@redhat.com>
Content-Language: en-US
Cc: maz@kernel.org
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

SGkgR2F2aW4sCgpNYW55IHRoYW5rcyBmb3IgaGF2aW5nIGEgbG9vayBhdCB0aGUgcGF0Y2hlcyEK
Ck9uIDkvMi8yMCAyOjIzIEFNLCBHYXZpbiBTaGFuIHdyb3RlOgo+IEhpIEFsZXhhbmRydSwKPgo+
IE9uIDkvMS8yMCAxMTozMyBQTSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gV2hlbiB1c2Vy
c3BhY2UgdXNlcyBodWdldGxiZnMgZm9yIHRoZSBWTSBtZW1vcnksIHVzZXJfbWVtX2Fib3J0KCkg
dHJpZXMgdG8KPj4gdXNlIHRoZSBzYW1lIGJsb2NrIHNpemUgdG8gbWFwIHRoZSBmYXVsdGluZyBJ
UEEgaW4gc3RhZ2UgMi4gSWYgc3RhZ2UgMgo+PiBjYW5ub3QgdXNlIHRoZSBzYW1lIHNpemUgbWFw
cGluZyBiZWNhdXNlIHRoZSBibG9jayBzaXplIGRvZXNuJ3QgZml0IGluIHRoZQo+PiBtZW1zbG90
IG9yIHRoZSBtZW1zbG90IGlzIG5vdCBwcm9wZXJseSBhbGlnbmVkLCB1c2VyX21lbV9hYm9ydCgp
IHdpbGwgZmFsbAo+PiBiYWNrIHRvIGEgcGFnZSBtYXBwaW5nLCByZWdhcmRsZXNzIG9mIHRoZSBi
bG9jayBzaXplLiBXZSBjYW4gZG8gYmV0dGVyIGZvcgo+PiBQVUQgYmFja2VkIGh1Z2V0bGJmcyBi
eSBjaGVja2luZyBpZiBhIFBNRCBibG9jayBtYXBwaW5nIGlzIHBvc3NpYmxlIGJlZm9yZQo+PiBk
ZWNpZGluZyB0byB1c2UgYSBwYWdlLgo+Pgo+PiB2bWFfcGFnZXNpemUgaXMgYW4gdW5zaWduZWQg
bG9uZywgdXNlIDFVTCBpbnN0ZWFkIG9mIDFVTEwgd2hlbiBhc3NpZ25pbmcKPj4gaXRzIHZhbHVl
Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2Vp
QGFybS5jb20+Cj4+IC0tLQo+PiDCoCBhcmNoL2FybTY0L2t2bS9tbXUuYyB8IDE5ICsrKysrKysr
KysrKysrLS0tLS0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9tbXUuYyBiL2FyY2gv
YXJtNjQva3ZtL21tdS5jCj4+IGluZGV4IDI1ZTdkYzUyYzA4Ni4uZjU5MGY3MzU1Y2RhIDEwMDY0
NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9tbXUuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9t
bXUuYwo+PiBAQCAtMTg3MSwxNSArMTg3MSwyNCBAQCBzdGF0aWMgaW50IHVzZXJfbWVtX2Fib3J0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gcGh5c19hZGRyX3QgZmF1bHRfaXBhLAo+PiDCoMKg
wqDCoMKgIGVsc2UKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHZtYV9zaGlmdCA9IFBBR0VfU0hJRlQ7
Cj4+IMKgIC3CoMKgwqAgdm1hX3BhZ2VzaXplID0gMVVMTCA8PCB2bWFfc2hpZnQ7Cj4+IMKgwqDC
oMKgwqAgaWYgKGxvZ2dpbmdfYWN0aXZlIHx8Cj4+IC3CoMKgwqDCoMKgwqDCoCAodm1hLT52bV9m
bGFncyAmIFZNX1BGTk1BUCkgfHwKPj4gLcKgwqDCoMKgwqDCoMKgICFmYXVsdF9zdXBwb3J0c19z
dGFnZTJfaHVnZV9tYXBwaW5nKG1lbXNsb3QsIGh2YSwgdm1hX3BhZ2VzaXplKSkgewo+PiArwqDC
oMKgwqDCoMKgwqAgKHZtYS0+dm1fZmxhZ3MgJiBWTV9QRk5NQVApKSB7Cj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBmb3JjZV9wdGUgPSB0cnVlOwo+PiAtwqDCoMKgwqDCoMKgwqAgdm1hX3BhZ2VzaXpl
ID0gUEFHRV9TSVpFOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgdm1hX3NoaWZ0ID0gUEFHRV9TSElG
VDsKPj4gwqDCoMKgwqDCoCB9Cj4+IMKgCj4KPiBJdCBsb29rcyBpbmNvcnJlY3QgYmVjYXVzZSBA
dm1hX3BhZ2VzaXplIHdhc24ndCBpbml0aWFsaXplZCB3aGVuCj4gaXQncyBwYXNzZWQgdG8gZmF1
bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygpIGZvciB0aGUgY2hlY2tpbmcuCj4gSXQn
cyBhc3N1bWVkIHlvdSBtaXNzZWQgdGhlIGZvbGxvd2luZyBjaGFuZ2VzIGFjY29yZGluZyB0byB0
aGUgY29tbWl0Cj4gbG9nOgo+Cj4gwqDCoCBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBw
aW5nKG1lbXNsb3QsIGh2YSwgKDFVTCA8PCB2bWFfc2hpZnQpKQoKSSdtIG5vdCBzdXJlIHdoYXQg
eW91IG1lYW4uIE1heWJlIHlvdSd2ZSBtaXNyZWFkIHRoZSBkaWZmPyBCZWNhdXNlIHRoZSBhYm92
ZSBjYWxsCnRvIGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKSB3YXMgcmVtb3Zl
ZCBieSB0aGUgcGF0Y2guCgpUaGFua3MsCgpBbGV4Cgo+IMKgCj4+ICvCoMKgwqAgaWYgKHZtYV9z
aGlmdCA9PSBQVURfU0hJRlQgJiYKPj4gK8KgwqDCoMKgwqDCoMKgICFmYXVsdF9zdXBwb3J0c19z
dGFnZTJfaHVnZV9tYXBwaW5nKG1lbXNsb3QsIGh2YSwgUFVEX1NJWkUpKQo+PiArwqDCoMKgwqDC
oMKgwqAgdm1hX3NoaWZ0ID0gUE1EX1NISUZUOwo+PiArCj4+ICvCoMKgwqAgaWYgKHZtYV9zaGlm
dCA9PSBQTURfU0hJRlQgJiYKPj4gK8KgwqDCoMKgwqDCoMKgICFmYXVsdF9zdXBwb3J0c19zdGFn
ZTJfaHVnZV9tYXBwaW5nKG1lbXNsb3QsIGh2YSwgUE1EX1NJWkUpKSB7Cj4+ICvCoMKgwqDCoMKg
wqDCoCBmb3JjZV9wdGUgPSB0cnVlOwo+PiArwqDCoMKgwqDCoMKgwqAgdm1hX3NoaWZ0ID0gUEFH
RV9TSElGVDsKPj4gK8KgwqDCoCB9Cj4+ICsKPj4gK8KgwqDCoCB2bWFfcGFnZXNpemUgPSAxVUwg
PDwgdm1hX3NoaWZ0Owo+PiArPsKgwqDCoMKgwqDCoCAvKgo+PiDCoMKgwqDCoMKgwqAgKiBUaGUg
c3RhZ2UyIGhhcyBhIG1pbmltdW0gb2YgMiBsZXZlbCB0YWJsZSAoRm9yIGFybTY0IHNlZQo+PiDC
oMKgwqDCoMKgwqAgKiBrdm1fYXJtX3NldHVwX3N0YWdlMigpKS4gSGVuY2UsIHdlIGFyZSBndWFy
YW50ZWVkIHRoYXQgd2UgY2FuCj4+IEBAIC0xODg5LDcgKzE4OTgsNyBAQCBzdGF0aWMgaW50IHVz
ZXJfbWVtX2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gcGh5c19hZGRyX3QgZmF1bHRf
aXBhLAo+PiDCoMKgwqDCoMKgwqAgKi8KPj4gwqDCoMKgwqDCoCBpZiAodm1hX3BhZ2VzaXplID09
IFBNRF9TSVpFIHx8Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCAodm1hX3BhZ2VzaXplID09IFBVRF9T
SVpFICYmIGt2bV9zdGFnZTJfaGFzX3BtZChrdm0pKSkKPj4gLcKgwqDCoMKgwqDCoMKgIGdmbiA9
IChmYXVsdF9pcGEgJiBodWdlX3BhZ2VfbWFzayhoc3RhdGVfdm1hKHZtYSkpKSA+PiBQQUdFX1NI
SUZUOwo+PiArwqDCoMKgwqDCoMKgwqAgZ2ZuID0gKGZhdWx0X2lwYSAmIH4odm1hX3BhZ2VzaXpl
IC0gMSkpID4+IFBBR0VfU0hJRlQ7Cj4+IMKgwqDCoMKgwqAgbW1hcF9yZWFkX3VubG9jayhjdXJy
ZW50LT5tbSk7Cj4+IMKgIMKgwqDCoMKgwqAgLyogV2UgbmVlZCBtaW5pbXVtIHNlY29uZCt0aGly
ZCBsZXZlbCBwYWdlcyAqLwo+Pgo+Cj4gVGhhbmtzLAo+IEdhdmluCj4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
