Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD50EC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 14:14:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 297FD60FEA
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 14:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 297FD60FEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9A14B44D;
	Wed, 31 Mar 2021 10:14:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bxvt1y3EcWbF; Wed, 31 Mar 2021 10:14:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4833B4B434;
	Wed, 31 Mar 2021 10:14:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C71734B3E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 10:14:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nK7yG+hN6yD1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 10:14:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F81B4B38B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 10:14:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617200064;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UWfseHyMDmnbmy78Fa+ZyCroksy1qHofcVaPy2EiTbQ=;
 b=TeH0q4vqbn9IPM0PSt9bgVr8Y24duNdkYEjqufN0INPgunGEV6m9UyU5Qw8IUNSLJ2R7b7
 2beHoMgteEat+vEhrQIjAEx3e8CEnXnsF34coj+3Ix9K5K9Dy2IYO5Rhz6ILK+zIsaw3Ma
 6aJtT14NnU/0LSuTy1p+zj1+ipMSWW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-xamaPO5pMw25ouUJ_K9Tqw-1; Wed, 31 Mar 2021 10:14:22 -0400
X-MC-Unique: xamaPO5pMw25ouUJ_K9Tqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E7341018F64;
 Wed, 31 Mar 2021 14:14:19 +0000 (UTC)
Received: from [10.36.113.60] (ovpn-113-60.ams2.redhat.com [10.36.113.60])
 by smtp.corp.redhat.com (Postfix) with ESMTP id EB5B619727;
 Wed, 31 Mar 2021 14:14:13 +0000 (UTC)
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
 <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
 <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <eebe69ad-1a2f-91ee-75b1-f295d7a3389c@redhat.com>
Date: Wed, 31 Mar 2021 16:14:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

T24gMzEuMDMuMjEgMTI6NDEsIFN0ZXZlbiBQcmljZSB3cm90ZToKPiBPbiAzMS8wMy8yMDIxIDEw
OjMyLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToKPj4gT24gMzEuMDMuMjEgMTE6MjEsIENhdGFs
aW4gTWFyaW5hcyB3cm90ZToKPj4+IE9uIFdlZCwgTWFyIDMxLCAyMDIxIGF0IDA5OjM0OjQ0QU0g
KzAyMDAsIERhdmlkIEhpbGRlbmJyYW5kIHdyb3RlOgo+Pj4+IE9uIDMwLjAzLjIxIDEyOjMwLCBD
YXRhbGluIE1hcmluYXMgd3JvdGU6Cj4+Pj4+IE9uIE1vbiwgTWFyIDI5LCAyMDIxIGF0IDA1OjA2
OjUxUE0gKzAxMDAsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4+Pj4+IE9uIDI4LzAzLzIwMjEgMTM6
MjEsIENhdGFsaW4gTWFyaW5hcyB3cm90ZToKPj4+Pj4+PiBPbiBTYXQsIE1hciAyNywgMjAyMSBh
dCAwMzoyMzoyNFBNICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6Cj4+Pj4+Pj4+IE9uIEZy
aSwgTWFyIDEyLCAyMDIxIGF0IDAzOjE4OjU4UE0gKzAwMDAsIFN0ZXZlbiBQcmljZSB3cm90ZToK
Pj4+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9tbXUuYyBiL2FyY2gvYXJtNjQv
a3ZtL21tdS5jCj4+Pj4+Pj4+PiBpbmRleCA3N2NiMmQyOGYyYTQuLmIzMWI3YTgyMWY5MCAxMDA2
NDQKPj4+Pj4+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4+Pj4+Pj4+PiArKysgYi9h
cmNoL2FybTY0L2t2bS9tbXUuYwo+Pj4+Pj4+Pj4gQEAgLTg3OSw2ICs4NzksMjIgQEAgc3RhdGlj
IGludCB1c2VyX21lbV9hYm9ydChzdHJ1Y3Qga3ZtX3ZjcHUKPj4+Pj4+Pj4+ICp2Y3B1LCBwaHlz
X2FkZHJfdCBmYXVsdF9pcGEsCj4+Pj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdl
c2l6ZSA9PSBQQUdFX1NJWkUgJiYgIWZvcmNlX3B0ZSkKPj4+Pj4+Pj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHZtYV9wYWdlc2l6ZSA9IHRyYW5zcGFyZW50X2h1Z2VwYWdlX2FkanVzdChtZW1z
bG90LAo+Pj4+Pj4+Pj4gaHZhLAo+Pj4+Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICZwZm4sICZmYXVsdF9p
cGEpOwo+Pj4+Pj4+Pj4gKwo+Pj4+Pj4+Pj4gK8KgwqDCoCBpZiAoZmF1bHRfc3RhdHVzICE9IEZT
Q19QRVJNICYmIGt2bV9oYXNfbXRlKGt2bSkgJiYKPj4+Pj4+Pj4+IHBmbl92YWxpZChwZm4pKSB7
Cj4+Pj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4+Pj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
ICogVk0gd2lsbCBiZSBhYmxlIHRvIHNlZSB0aGUgcGFnZSdzIHRhZ3MsIHNvIHdlIG11c3QKPj4+
Pj4+Pj4+IGVuc3VyZQo+Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiB0aGV5IGhhdmUgYmVl
biBpbml0aWFsaXNlZC4gaWYgUEdfbXRlX3RhZ2dlZCBpcyBzZXQsCj4+Pj4+Pj4+PiB0YWdzCj4+
Pj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIGhhdmUgYWxyZWFkeSBiZWVuIGluaXRpYWxpc2Vk
Lgo+Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4+Pj4+Pj4+ICvCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3QgcGFnZSAqcGFnZSA9IHBmbl90b19wYWdlKHBmbik7Cj4+Pj4+Pj4+PiArwqDCoMKg
wqDCoMKgwqAgdW5zaWduZWQgbG9uZyBpLCBucl9wYWdlcyA9IHZtYV9wYWdlc2l6ZSA+PiBQQUdF
X1NISUZUOwo+Pj4+Pj4+Pj4gKwo+Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGZvciAoaSA9IDA7
IGkgPCBucl9wYWdlczsgaSsrLCBwYWdlKyspIHsKPj4+Pj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGlmICghdGVzdF9hbmRfc2V0X2JpdChQR19tdGVfdGFnZ2VkLCAmcGFnZS0+ZmxhZ3Mp
KQo+Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtdGVfY2xlYXJfcGFn
ZV90YWdzKHBhZ2VfYWRkcmVzcyhwYWdlKSk7Cj4+Pj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgfQo+
Pj4+Pj4+Pj4gK8KgwqDCoCB9Cj4+Pj4+Pj4+Cj4+Pj4+Pj4+IFRoaXMgcGZuX3ZhbGlkKCkgY2hl
Y2sgbWF5IGJlIHByb2JsZW1hdGljLiBGb2xsb3dpbmcgY29tbWl0Cj4+Pj4+Pj4+IGVlYjA3NTNi
YTI3Ygo+Pj4+Pj4+PiAoImFybTY0L21tOiBGaXggcGZuX3ZhbGlkKCkgZm9yIFpPTkVfREVWSUNF
IGJhc2VkIG1lbW9yeSIpLCBpdAo+Pj4+Pj4+PiByZXR1cm5zCj4+Pj4+Pj4+IHRydWUgZm9yIFpP
TkVfREVWSUNFIG1lbW9yeSBidXQgc3VjaCBtZW1vcnkgaXMgYWxsb3dlZCBub3QgdG8KPj4+Pj4+
Pj4gc3VwcG9ydAo+Pj4+Pj4+PiBNVEUuCj4+Pj4+Pj4KPj4+Pj4+PiBTb21lIG1vcmUgdGhpbmtp
bmcsIHRoaXMgc2hvdWxkIGJlIHNhZmUgYXMgYW55IFpPTkVfREVWSUNFIHdvdWxkIGJlCj4+Pj4+
Pj4gbWFwcGVkIGFzIHVudGFnZ2VkIG1lbW9yeSBpbiB0aGUga2VybmVsIGxpbmVhciBtYXAuIEl0
IGNvdWxkIGJlCj4+Pj4+Pj4gc2xpZ2h0bHkKPj4+Pj4+PiBpbmVmZmljaWVudCBpZiBpdCB1bm5l
Y2Vzc2FyaWx5IHRyaWVzIHRvIGNsZWFyIHRhZ3MgaW4gWk9ORV9ERVZJQ0UsCj4+Pj4+Pj4gdW50
YWdnZWQgbWVtb3J5LiBBbm90aGVyIG92ZXJoZWFkIGlzIHBmbl92YWxpZCgpIHdoaWNoIHdpbGwg
bGlrZWx5Cj4+Pj4+Pj4gZW5kCj4+Pj4+Pj4gdXAgY2FsbGluZyBtZW1ibG9ja19pc19tYXBfbWVt
b3J5KCkuCj4+Pj4+Pj4KPj4+Pj4+PiBIb3dldmVyLCB0aGUgYmlnZ2VyIGlzc3VlIGlzIHRoYXQg
U3RhZ2UgMiBjYW5ub3QgZGlzYWJsZSB0YWdnaW5nIGZvcgo+Pj4+Pj4+IFN0YWdlIDEgdW5sZXNz
IHRoZSBtZW1vcnkgaXMgTm9uLWNhY2hlYWJsZSBvciBEZXZpY2UgYXQgUzIuIElzCj4+Pj4+Pj4g
dGhlcmUgYQo+Pj4+Pj4+IHdheSB0byBkZXRlY3Qgd2hhdCBnZXRzIG1hcHBlZCBpbiB0aGUgZ3Vl
c3QgYXMgTm9ybWFsIENhY2hlYWJsZQo+Pj4+Pj4+IG1lbW9yeQo+Pj4+Pj4+IGFuZCBtYWtlIHN1
cmUgaXQncyBvbmx5IGVhcmx5IG1lbW9yeSBvciBob3RwbHVnIGJ1dCBubyBaT05FX0RFVklDRQo+
Pj4+Pj4+IChvcgo+Pj4+Pj4+IHNvbWV0aGluZyBlbHNlIGxpa2Ugb24tY2hpcCBtZW1vcnkpP8Kg
IElmIHdlIGNhbid0IGd1YXJhbnRlZSB0aGF0IGFsbAo+Pj4+Pj4+IENhY2hlYWJsZSBtZW1vcnkg
Z2l2ZW4gdG8gYSBndWVzdCBzdXBwb3J0cyB0YWdzLCB3ZSBzaG91bGQgZGlzYWJsZQo+Pj4+Pj4+
IHRoZQo+Pj4+Pj4+IGZlYXR1cmUgYWx0b2dldGhlci4KPj4+Pj4+Cj4+Pj4+PiBJbiBzdGFnZSAy
IEkgYmVsaWV2ZSB3ZSBvbmx5IGhhdmUgdHdvIHR5cGVzIG9mIG1hcHBpbmcgLSAnbm9ybWFsJyBv
cgo+Pj4+Pj4gREVWSUNFX25HblJFIChzZWUgc3RhZ2UyX21hcF9zZXRfcHJvdF9hdHRyKCkpLiBG
aWx0ZXJpbmcgb3V0IHRoZQo+Pj4+Pj4gbGF0dGVyIGlzIGEKPj4+Pj4+IGNhc2Ugb2YgY2hlY2tp
bmcgdGhlICdkZXZpY2UnIHZhcmlhYmxlLCBhbmQgbWFrZXMgc2Vuc2UgdG8gYXZvaWQgdGhlCj4+
Pj4+PiBvdmVyaGVhZCB5b3UgZGVzY3JpYmUuCj4+Pj4+Pgo+Pj4+Pj4gVGhpcyBzaG91bGQgYWxz
byBndWFyYW50ZWUgdGhhdCBhbGwgc3RhZ2UtMiBjYWNoZWFibGUgbWVtb3J5Cj4+Pj4+PiBzdXBw
b3J0cyB0YWdzLAo+Pj4+Pj4gYXMga3ZtX2lzX2RldmljZV9wZm4oKSBpcyBzaW1wbHkgIXBmbl92
YWxpZCgpLCBhbmQgcGZuX3ZhbGlkKCkKPj4+Pj4+IHNob3VsZCBvbmx5Cj4+Pj4+PiBiZSB0cnVl
IGZvciBtZW1vcnkgdGhhdCBMaW51eCBjb25zaWRlcnMgIm5vcm1hbCIuCj4+Pj4KPj4+PiBJZiB5
b3UgdGhpbmsgIm5vcm1hbCIgPT0gIm5vcm1hbCBTeXN0ZW0gUkFNIiwgdGhhdCdzIHdyb25nOyBz
ZWUgYmVsb3cuCj4+Pgo+Pj4gQnkgIm5vcm1hbCIgSSB0aGluayBib3RoIFN0ZXZlbiBhbmQgSSBt
ZWFudCB0aGUgTm9ybWFsIENhY2hlYWJsZSBtZW1vcnkKPj4+IGF0dHJpYnV0ZSAoYW5vdGhlciBi
ZWluZyB0aGUgRGV2aWNlIG1lbW9yeSBhdHRyaWJ1dGUpLgo+IAo+IFNhZGx5IHRoZXJlJ3Mgbm8g
Z29vZCBzdGFuZGFyZGlzZWQgdGVybWlub2xvZ3kgaGVyZS4gQWFyY2g2NCBwcm92aWRlcwo+IHRo
ZSAibm9ybWFsIChjYWNoZWFibGUpIiBkZWZpbml0aW9uLiBNZW1vcnkgd2hpY2ggaXMgbWFwcGVk
IGFzICJOb3JtYWwKPiBDYWNoZWFibGUiIGlzIGltcGxpY2l0bHkgTVRFIGNhcGFibGUgd2hlbiBz
aGFyZWQgd2l0aCBhIGd1ZXN0IChiZWNhdXNlCj4gdGhlIHN0YWdlIDIgbWFwcGluZ3MgZG9uJ3Qg
YWxsb3cgcmVzdHJpY3RpbmcgTVRFIG90aGVyIHRoYW4gbWFwcGluZyBpdAo+IGFzIERldmljZSBt
ZW1vcnkpLgo+IAo+IFNvIE1URSBhbHNvIGZvcmNlcyB1cyB0byBoYXZlIGEgZGVmaW5pdGlvbiBv
ZiBtZW1vcnkgd2hpY2ggaXMgImJvZwo+IHN0YW5kYXJkIG1lbW9yeSJbMV0gc2VwYXJhdGUgZnJv
bSB0aGUgbWFwcGluZyBhdHRyaWJ1dGVzLiBUaGlzIGlzIHRoZQo+IG1haW4gbWVtb3J5IHdoaWNo
IGZ1bGx5IHN1cHBvcnRzIE1URS4KPiAKPiBTZXBhcmF0ZSBmcm9tIHRoZSAiYm9nIHN0YW5kYXJk
IiB3ZSBoYXZlIHRoZSAic3BlY2lhbCJbMV0gbWVtb3J5LCBlLmcuCj4gWk9ORV9ERVZJQ0UgbWVt
b3J5IG1heSBiZSBtYXBwZWQgYXMgIk5vcm1hbCBDYWNoZWFibGUiIGF0IHN0YWdlIDEgYnV0Cj4g
dGhhdCBtZW1vcnkgbWF5IG5vdCBzdXBwb3J0IE1URSB0YWdzLiBUaGlzIG1lbW9yeSBjYW4gb25s
eSBiZSBzYWZlbHkKPiBzaGFyZWQgd2l0aCBhIGd1ZXN0IGluIHRoZSBmb2xsb3dpbmcgc2l0dWF0
aW9uczoKPiAKPiAgICAxLiBNVEUgaXMgY29tcGxldGVseSBkaXNhYmxlZCBmb3IgdGhlIGd1ZXN0
Cj4gCj4gICAgMi4gVGhlIHN0YWdlIDIgbWFwcGluZ3MgYXJlICdkZXZpY2UnIChlLmcuIERFVklD
RV9uR25SRSkKPiAKPiAgICAzLiBXZSBoYXZlIHNvbWUgZ3VhcmFudGVlIHRoYXQgZ3Vlc3QgTVRF
IGFjY2VzcyBhcmUgaW4gc29tZSB3YXkgc2FmZS4KPiAKPiAoMSkgaXMgdGhlIHNpdHVhdGlvbiB0
b2RheSAod2l0aG91dCB0aGlzIHBhdGNoIHNlcmllcykuIEJ1dCBpdCBwcmV2ZW50cwo+IHRoZSBn
dWVzdCBmcm9tIHVzaW5nIE1URSBpbiBhbnkgZm9ybS4KPiAKPiAoMikgaXMgcHJldHR5IHRlcnJp
YmxlIGZvciBnZW5lcmFsIG1lbW9yeSwgYnV0IGlzIHRoZSBnZXQtb3V0IGNsYXVzZSBmb3IKPiBt
YXBwaW5nIGRldmljZXMgaW50byB0aGUgZ3Vlc3QuCj4gCj4gKDMpIGlzbid0IHNvbWV0aGluZyB3
ZSBoYXZlIGFueSBhcmNoaXRlY3R1cmFsIHdheSBvZiBkaXNjb3ZlcmluZy4gV2UnZAo+IG5lZWQg
dG8ga25vdyB3aGF0IHRoZSBkZXZpY2UgZGlkIHdpdGggdGhlIE1URSBhY2Nlc3NlcyAoYW5kIGFu
eSBjYWNoZXMKPiBiZXR3ZWVuIHRoZSBDUFUgYW5kIHRoZSBkZXZpY2UpIHRvIGVuc3VyZSB0aGVy
ZSBhcmVuJ3QgYW55IHNpZGUtY2hhbm5lbHMKPiBvciBoL3cgbG9ja3VwIGlzc3Vlcy4gV2UnZCBh
bHNvIG5lZWQgc29tZSB3YXkgb2YgZGVzY3JpYmluZyB0aGlzIG1lbW9yeQo+IHRvIHRoZSBndWVz
dC4KPiAKPiBTbyBhdCBsZWFzdCBmb3IgdGhlIHRpbWUgYmVpbmcgdGhlIGFwcHJvYWNoIGlzIHRv
IGF2b2lkIGxldHRpbmcgYSBndWVzdAo+IHdpdGggTVRFIGVuYWJsZWQgaGF2ZSBhY2Nlc3MgdG8g
dGhpcyBzb3J0IG9mIG1lbW9yeS4KPiAKPiBbMV0gTmVpdGhlciAiYm9nIHN0YW5kYXJkIiBub3Ig
InNwZWNpYWwiIGFyZSByZWFsIHRlcm1zIC0gbGlrZSBJIHNhaWQKPiB0aGVyZSdzIGEgbGFjayBv
ZiBzdGFuZGFyZGlzZWQgdGVybWlub2xvZ3kuCj4gCj4+Pj4+IFRoYXQncyB0aGUgcHJvYmxlbS4g
V2l0aCBBbnNodW1hbidzIGNvbW1pdCBJIG1lbnRpb25lZCBhYm92ZSwKPj4+Pj4gcGZuX3ZhbGlk
KCkgcmV0dXJucyB0cnVlIGZvciBaT05FX0RFVklDRSBtYXBwaW5ncyAoZS5nLiBwZXJzaXN0ZW50
Cj4+Pj4+IG1lbW9yeSwgbm90IHRhbGtpbmcgYWJvdXQgc29tZSBJL08gbWFwcGluZyB0aGF0IHJl
cXVpcmVzIERldmljZV9uR25SRSkuCj4+Pj4+IFNvIGt2bV9pc19kZXZpY2VfcGZuKCkgaXMgZmFs
c2UgZm9yIHN1Y2ggbWVtb3J5IGFuZCBpdCBtYXkgYmUgbWFwcGVkIGFzCj4+Pj4+IE5vcm1hbCBi
dXQgaXQgaXMgbm90IGd1YXJhbnRlZWQgdG8gc3VwcG9ydCB0YWdnaW5nLgo+Pj4+Cj4+Pj4gcGZu
X3ZhbGlkKCkgbWVhbnMgInRoZXJlIGlzIGEgc3RydWN0IHBhZ2UiOyBpZiB5b3UgZG8gcGZuX3Rv
X3BhZ2UoKSBhbmQKPj4+PiB0b3VjaCB0aGUgcGFnZSwgeW91IHdvbid0IGZhdWx0LiBTbyBBbnNo
dW1hbidzIGNvbW1pdCBpcyBjb3JyZWN0Lgo+Pj4KPj4+IEkgYWdyZWUuCj4+Pgo+Pj4+IHBmbl90
b19vbmxpbmVfcGFnZSgpIG1lYW5zLCAidGhlcmUgaXMgYSBzdHJ1Y3QgcGFnZSBhbmQgaXQncyBz
eXN0ZW0gUkFNCj4+Pj4gdGhhdCdzIGluIHVzZTsgdGhlIG1lbW1hcCBoYXMgYSBzYW5lIGNvbnRl
bnQiCj4+Pgo+Pj4gRG9lcyBwZm5fdG9fb25saW5lX3BhZ2UoKSByZXR1cm5zIGEgdmFsaWQgc3Ry
dWN0IHBhZ2UgcG9pbnRlciBmb3IKPj4+IFpPTkVfREVWSUNFIHBhZ2VzPyBJSVVDLCB0aGVzZSBh
cmUgbm90IGd1YXJhbnRlZWQgdG8gYmUgc3lzdGVtIFJBTSwgZm9yCj4+PiBzb21lIGRlZmluaXRp
b24gb2Ygc3lzdGVtIFJBTSAoSSBhc3N1bWUgTlZESU1NICE9IHN5c3RlbSBSQU0pLiBGb3IKPj4+
IGV4YW1wbGUsIHBtZW1fYXR0YWNoX2Rpc2soKSBjYWxscyBkZXZtX21lbXJlbWFwX3BhZ2VzKCkg
YW5kIHRoaXMgd291bGQKPj4+IHVzZSB0aGUgTm9ybWFsIENhY2hlYWJsZSBtZW1vcnkgYXR0cmli
dXRlIHdpdGhvdXQgbmVjZXNzYXJpbHkgYmVpbmcKPj4+IHN5c3RlbSBSQU0uCj4+Cj4+IE5vLCBu
b3QgZm9yIFpPTkVfREVWSUNFLgo+Pgo+PiBIb3dldmVyLCBpZiB5b3UgZXhwb3NlIFBNRU0gdmlh
IGRheC9rbWVtIGFzIFN5c3RlbSBSQU0gdG8gdGhlIHN5c3RlbSAoLT4KPj4gYWRkX21lbW9yeV9k
cml2ZXJfbWFuYWdlZCgpKSwgdGhlbiBQTUVNIChtYW5hZ2VkIHZpYSBaT05FX05PTVJBTCBvcgo+
PiBaT05FX01PVkFCTEUpIHdvdWxkIHdvcmsgd2l0aCBwZm5fdG9fb25saW5lX3BhZ2UoKSAtLSBh
cyB0aGUgc3lzdGVtCj4+IHRoaW5rcyBpdCdzICJvcmRpbmFyeSBzeXN0ZW0gUkFNIiBhbmQgdGhl
IG1lbW9yeSBpcyBtYW5hZ2VkIGJ5IHRoZSBidWRkeS4KPiAKPiBTbyBpZiBJJ20gdW5kZXJzdGFu
ZGluZyB0aGlzIGNvcnJlY3RseSBmb3IgS1ZNIHdlIG5lZWQgdG8gdXNlCj4gcGZuX3RvX29ubGlu
ZV9wYWdlcygpIGFuZCByZWplY3QgaWYgTlVMTCBpcyByZXR1cm5lZD8gSW4gdGhlIGNhc2Ugb2YK
PiBkYXgva21lbSB0aGVyZSBhbHJlYWR5IG5lZWRzIHRvIGJlIHZhbGlkYXRpb24gdGhhdCB0aGUg
bWVtb3J5IHN1cHBvcnRzCj4gTVRFIChvdGhlcndpc2Ugd2UgYnJlYWsgdXNlciBzcGFjZSkgYmVm
b3JlIGl0J3MgYWxsb3dlZCBpbnRvIHRoZQo+ICJvcmRpbmFyeSBzeXN0ZW0gUkFNIiBidWNrZXQu
CgpUaGF0IHNob3VsZCB3b3JrLgoKMS4gT25lIGFsdGVybmF0aXZlIGlzCgppZiAoIXBmbl92YWxp
ZChwZm4pKQoJcmV0dXJuIGZhbHNlOwojaWZkZWYgQ09ORklHX1pPTkVfREVWSUNFCnBhZ2UgPSBw
Zm5fdG9fcGFnZShwZm4pOwppZiAocGFnZV96b25lbnVtKHBhZ2UpID09IFpPTkVfREVWSUNFKQoJ
cmV0dXJuIGZhbHNlOwojZW5kaWYKcmV0dXJuIHRydWU7CgoKTm90ZSB0aGF0IHdoZW4geW91IGFy
ZSBkZWFsaW5nIHdpdGggcmFuZG9tIFBGTnMsIHRoaXMgYXBwcm9hY2ggaXMgaW4gCmdlbmVyYWwg
bm90IHNhZmU7IHRoZSBtZW1tYXAgY291bGQgYmUgdW5pbml0aWFsaXplZCBhbmQgY29udGFpbiBn
YXJiYWdlLiAKWW91IGNhbiBoYXZlIGZhbHNlIHBvc2l0aXZlcyBmb3IgWk9ORV9ERVZJQ0UuCgoK
Mi4gWWV0IGFub3RoZXIgKHNsb3dlcj8pIHZhcmlhbnQgdG8gZGV0ZWN0IChzb21lPykgWk9ORV9E
RVZJQ0UgaXMKCnBnbWFwID0gZ2V0X2Rldl9wYWdlbWFwKHBmbiwgTlVMTCk7CnB1dF9kZXZfcGFn
ZW1hcChwZ21hcCk7CgppZiAocGdtYXApCglyZXR1cm4gZmFsc2U7CnJldHVybiB0cnVlOwoKCgpJ
IGtub3cgdGhhdCAvZGV2L21lbSBtYXBwaW5ncyBjYW4gYmUgcHJvYmxlbWF0aWMgLi4uIGJlY2F1
c2UgdGhlIG1lbW1hcCAKY291bGQgYmUgaW4gYW55IHN0YXRlIGFuZCBhY3R1YWxseSB3ZSBzaG91
bGRuJ3QgZXZlbiB0b3VjaC9yZWx5IG9uIGFueSAKInN0cnVjdCBwYWdlcyIgYXQgYWxsLCBhcyB3
ZSBoYXZlIGEgcHVyZSBQRk4gbWFwcGluZyAuLi4KCi0tIApUaGFua3MsCgpEYXZpZCAvIGRoaWxk
ZW5iCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
