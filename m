Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3A6C10F27
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 14:00:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97DCF22525
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 14:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hT3EYx6u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97DCF22525
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 355E24A319;
	Wed, 11 Mar 2020 10:00:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7sLvVNQ-2ox9; Wed, 11 Mar 2020 10:00:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6464A483;
	Wed, 11 Mar 2020 10:00:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1FE14A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 10:00:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxO5X0yHYdxv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 10:00:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4F724A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 10:00:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6D44A21D56;
 Wed, 11 Mar 2020 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1583935218;
 bh=0OhcIcZrD2BAj+IbJhSUJLV6Mv2HMcdowWmdsbMbNhY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hT3EYx6uOpjy1EAwyCTjY6+WpJ5Jl4+nlTYOM1Vi2FQKFukSHtjNZeet9m2Em3MkX
 ypwcs2QckRkoy2Vw4PJxXmM1eFw+8XI4FBzqmEwoVmOzFY8DCKKfvQwJttcf4jjYi+
 b1nE90aNOKAZrzYelCvCXhL5i4jKplfAXywUiTgc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jC1uC-00BvZI-Lr; Wed, 11 Mar 2020 14:00:16 +0000
MIME-Version: 1.0
Date: Wed, 11 Mar 2020 14:00:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
In-Reply-To: <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
Message-ID: <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, yuzenghui@huawei.com,
 eric.auger.pro@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
 andre.przywara@arm.com, peter.maydell@linaro.org, alexandru.elisei@arm.com,
 thuth@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, qemu-devel@nongnu.org,
 thuth@redhat.com, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

T24gMjAyMC0wMy0xMSAxMzo0OCwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBaZW5naHVpLAo+IAo+
IE9uIDMvMTEvMjAgMTI6NTkgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhpIEVyaWMsCj4+IAo+
PiBPbiAyMDIwLzMvMTAgMjI6NTQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+PiBUcmlnZ2VycyBMUElz
IHRocm91Z2ggdGhlIElOVCBjb21tYW5kLgo+Pj4gCj4+PiB0aGUgdGVzdCBjaGVja3MgdGhlIExQ
SSBoaXRzIHRoZSByaWdodCBDUFUgYW5kIHRyaWdnZXJzCj4+PiB0aGUgcmlnaHQgTFBJIGludGlk
LCBpZS4gdGhlIHRyYW5zbGF0aW9uIGlzIGNvcnJlY3QuCj4+PiAKPj4+IFVwZGF0ZXMgdG8gdGhl
IGNvbmZpZyB0YWJsZSBhbHNvIGFyZSB0ZXN0ZWQsIGFsb25nIHdpdGggaW52Cj4+PiBhbmQgaW52
YWxsIGNvbW1hbmRzLgo+Pj4gCj4+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1
Z2VyQHJlZGhhdC5jb20+Cj4+PiAKPj4+IC0tLQo+PiAKPj4gWy4uLl0KPj4gCj4+PiArc3RhdGlj
IHZvaWQgdGVzdF9pdHNfdHJpZ2dlcih2b2lkKQo+Pj4gK3sKPj4+ICvCoMKgwqAgc3RydWN0IGl0
c19jb2xsZWN0aW9uICpjb2wzLCAqY29sMjsKPj4+ICvCoMKgwqAgc3RydWN0IGl0c19kZXZpY2Ug
KmRldjIsICpkZXY3Owo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoaXRzX3ByZXJlcXVpc2l0ZXMoNCkp
Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+Pj4gKwo+Pj4gK8KgwqDCoCBkZXYyID0gaXRz
X2NyZWF0ZV9kZXZpY2UoMiAvKiBkZXYgaWQgKi8sIDggLyogbmJfaXRlcyAqLyk7Cj4+PiArwqDC
oMKgIGRldjcgPSBpdHNfY3JlYXRlX2RldmljZSg3IC8qIGRldiBpZCAqLywgOCAvKiBuYl9pdGVz
ICovKTsKPj4+ICsKPj4+ICvCoMKgwqAgY29sMyA9IGl0c19jcmVhdGVfY29sbGVjdGlvbigzIC8q
IGNvbCBpZCAqLywgMy8qIHRhcmdldCBQRSAqLyk7Cj4+PiArwqDCoMKgIGNvbDIgPSBpdHNfY3Jl
YXRlX2NvbGxlY3Rpb24oMiAvKiBjb2wgaWQgKi8sIDIvKiB0YXJnZXQgUEUgKi8pOwo+Pj4gKwo+
Pj4gK8KgwqDCoCBnaWN2M19scGlfc2V0X2NvbmZpZyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUKTsK
Pj4+ICvCoMKgwqAgZ2ljdjNfbHBpX3NldF9jb25maWcoODE5NiwgTFBJX1BST1BfREVGQVVMVCk7
Cj4+PiArCj4+PiArwqDCoMKgIGl0c19zZW5kX2ludmFsbChjb2wyKTsKPj4+ICvCoMKgwqAgaXRz
X3NlbmRfaW52YWxsKGNvbDMpOwo+PiAKPj4gVGhlc2UgdHdvIElOVkFMTHMgc2hvdWxkIGJlIGlz
c3VlZCBhZnRlciBjb2wyIGFuZCBjb2wzIGFyZSBtYXBwZWQsCj4+IG90aGVyd2lzZSB0aGlzIHdp
bGwgY2F1c2UgdGhlIElOVkFMTCBjb21tYW5kIGVycm9yIGFzIHBlciB0aGUgc3BlYwo+PiAodGhv
dWdoIEtWTSBkb2Vzbid0IGNvbXBsYWluIGl0IGF0IGFsbCkuCj4gWWVzIHlvdSdyZSByaWdodC4g
cmVhZGluZyB0aGUgc3BlYyBhZ2FpbjoKPiAKPiBBIGNvbW1hbmQgZXJyb3Igb2NjdXJzIGlmIGFu
eSBvZiB0aGUgZm9sbG93aW5nIGFwcGx5Ogo+IC4uLy4uCj4gVGhlIGNvbGxlY3Rpb24gc3BlY2lm
aWVkIGJ5IElDSUQgaGFzIG5vdCBiZWVuIG1hcHBlZCB0byBhbiBSRGJhc2UgdXNpbmcKPiBNQVBD
Lgo+IAo+IEJ1dCBhcyBtZW50aW9ubmVkIGluIHRoZSBjb3ZlciBsZXR0ZXIsIG5vIHJlYWwgbWVh
bnMgdG8gcmV0cmlldmUgdGhlCj4gZXJyb3IgYXQgdGhlIG1vbWVudC4KClRoYXQgaXMgc3RpbGwg
YSBwcm9ibGVtIHdpdGggdGhlIElUUy4gVGhlcmUgaXMgbm8gYXJjaGl0ZWN0dXJhbCB3YXkKdG8g
cmVwb3J0IGFuIGVycm9yLCBldmVuIGlmIHRoZSBlcnJvciBudW1iZXJzIGFyZSBhcmNoaXRlY3Rl
ZC4uLgoKT25lIHRoaW5nIHdlIGNvdWxkIGRvIHRob3VnaCBpcyB0byBpbXBsZW1lbnQgdGhlIHN0
YWxsIG1vZGVsIChhcyAKZGVzY3JpYmVkCmluIDUuMy4yKS4gSXQgc3RpbGwgZG9lc24ndCBnaXZl
IHVzIHRoZSBlcnJvciwgYnV0IGF0IGxlYXN0IHRoZSBjb21tYW5kCnF1ZXVlIHdvdWxkIHN0b3Ag
b24gZGV0ZWN0aW5nIGFuIGVycm9yLgoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQu
IEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
