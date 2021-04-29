Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A6FC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 06:58:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FAA46144E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 06:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FAA46144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB344B31B;
	Thu, 29 Apr 2021 02:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zqf3U0or4aIh; Thu, 29 Apr 2021 02:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE564B316;
	Thu, 29 Apr 2021 02:58:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3DA4B316
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 02:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZDFrQSVqD057 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 02:58:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30BC24B315
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 02:58:05 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD7A6144B;
 Thu, 29 Apr 2021 06:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619679483;
 bh=l1YNoSMCv4WqRE2vuNJAwrTs3h6UQBEivHBC6/hQdn4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=aO7gxyhOVkLEx+raw89h1VPcYXGHTfGyqvHsdHo+ICI31y241io5QGGPJR12RCD/p
 8AV8o5ax3nhSce+p3MiYHZSHqQ3/x1PJX8BN+6vIYtKheOallgAVi/YfSh3X7TEeB6
 hjyaQyhwr1wfIx38apMX8lqS4GMc67eRdUkGB7x35fhWcDz6Fqm+yi56m8gChW4baP
 JKP9TA+UXsJKV0urjwKkeiV01FoQLOC2yqnzM0MqCY6C8bKYb1LBHxDpS0R9BsOMdw
 QP6NufksB+r1kxa/ucqzUL74NkyIi/gXA3Je3MbkdY2i2jyKJ9umoNjuWeNLy8ChHy
 yO1oOEtaPufSA==
Date: Thu, 29 Apr 2021 09:57:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YIpY8TXCSc7Lfa2Z@kernel.org>
References: <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
 <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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

T24gVGh1LCBBcHIgMjksIDIwMjEgYXQgMDg6NDg6MjZBTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS80LzI4IDEzOjU5LCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+ID4gT24g
VHVlLCBBcHIgMjcsIDIwMjEgYXQgMDc6MDg6NTlQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6
Cj4gPiA+IE9uIDIwMjEvNC8yNyAxNDoyMywgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiA+ID4gPiBP
biBNb24sIEFwciAyNiwgMjAyMSBhdCAxMToyNjozOFBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90
ZToKPiA+ID4gPiA+IE9uIDIwMjEvNC8yNiAxMzoyMCwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiA+
ID4gPiA+ID4gT24gU3VuLCBBcHIgMjUsIDIwMjEgYXQgMDM6NTE6NTZQTSArMDgwMCwgS2VmZW5n
IFdhbmcgd3JvdGU6Cj4gPiA+ID4gPiA+ID4gT24gMjAyMS80LzI1IDE1OjE5LCBNaWtlIFJhcG9w
b3J0IHdyb3RlOgo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+ICAgICAgICBPbiBGcmksIEFw
ciAyMywgMjAyMSBhdCAwNDoxMToxNlBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToKPiA+ID4g
PiA+ID4gPiAKPiA+ID4gPiA+ID4gPiAgICAgICAgICAgIEkgdGVzdGVkIHRoaXMgcGF0Y2hzZXQo
cGx1cyBhcm0zMiBjaGFuZ2UsIGxpa2UgYXJtNjQgZG9lcykKPiA+ID4gPiA+ID4gPiAgICAgICAg
ICAgIGJhc2VkIG9uIGx0cyA1LjEw77yMYWRkIHNvbWUgZGVidWcgbG9nLCB0aGUgdXNlZnVsIGlu
Zm8gc2hvd3MKPiA+ID4gPiA+ID4gPiAgICAgICAgICAgIGJlbG93LCBpZiB3ZSBlbmFibGUgSE9M
RVNfSU5fWk9ORSwgbm8gcGFuaWMsIGFueSBpZGVhLAo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAg
dGhhbmtzLgo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+ICAgICAgICBBcmUgdGhlcmUgYW55
IGNoYW5nZXMgb24gdG9wIG9mIDUuMTAgZXhjZXB0IGZvciBwZm5fdmFsaWQoKSBwYXRjaD8KPiA+
ID4gPiA+ID4gPiAgICAgICAgRG8geW91IHNlZSB0aGlzIHBhbmljIG9uIDUuMTAgd2l0aG91dCB0
aGUgY2hhbmdlcz8KPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBZZXMsIHRoZXJlIGFyZSBz
b21lIEJTUCBzdXBwb3J0IGZvciBhcm0gYm9hcmQgYmFzZWQgb24gNS4xMCwKPiA+ID4gPiBJcyBp
dCBwb3NzaWJsZSB0byB0ZXN0IDUuMTI/Cj4gPiBEbyB5b3UgdXNlIFNQQVJTTUVNPyBJZiB5ZXMs
IHdoYXQgaXMgeW91ciBzZWN0aW9uIHNpemU/Cj4gPiBXaGF0IGlzIHRoZSB2YWx1ZSBpZiBDT05G
SUdfRk9SQ0VfTUFYX1pPTkVPUkRFUiBpbiB5b3VyIGNvbmZpZ3VyYXRpb24/Cj4gCj4gWWVzLAo+
IAo+IENPTkZJR19TUEFSU0VNRU09eQo+IAo+IENPTkZJR19TUEFSU0VNRU1fU1RBVElDPXkKPiAK
PiBDT05GSUdfRk9SQ0VfTUFYX1pPTkVPUkRFUiA9IDExCj4gCj4gQ09ORklHX1BBR0VfT0ZGU0VU
PTB4QzAwMDAwMDAKPiBDT05GSUdfSEFWRV9BUkNIX1BGTl9WQUxJRD15Cj4gQ09ORklHX0hJR0hN
RU09eQo+ICNkZWZpbmUgU0VDVElPTl9TSVpFX0JJVFMgICAgMjYKPiAjZGVmaW5lIE1BWF9QSFlT
QUREUl9CSVRTICAgIDMyCj4gI2RlZmluZSBNQVhfUEhZU01FTV9CSVRTICAgICAzMgoKSXQgc2Vl
bXMgdGhhdCB3aXRoIFNQQVJTRU1FTSB3ZSBkb24ndCBhbGlnbiB0aGUgZnJlZWQgcGFydHMgb24g
cGFnZWJsb2NrCmJvdW5kYXJpZXMuCgpDYW4geW91IHRyeSB0aGUgcGF0Y2ggYmVsb3c6CgpkaWZm
IC0tZ2l0IGEvbW0vbWVtYmxvY2suYyBiL21tL21lbWJsb2NrLmMKaW5kZXggYWZhZWZhOGZjNmFi
Li4xOTI2MzY5YjUyZWMgMTAwNjQ0Ci0tLSBhL21tL21lbWJsb2NrLmMKKysrIGIvbW0vbWVtYmxv
Y2suYwpAQCAtMTk0MSwxNCArMTk0MSwxMyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgZnJlZV91bnVz
ZWRfbWVtbWFwKHZvaWQpCiAJCSAqIGR1ZSB0byBTUEFSU0VNRU0gc2VjdGlvbnMgd2hpY2ggYXJl
bid0IHByZXNlbnQuCiAJCSAqLwogCQlzdGFydCA9IG1pbihzdGFydCwgQUxJR04ocHJldl9lbmQs
IFBBR0VTX1BFUl9TRUNUSU9OKSk7Ci0jZWxzZQorI2VuZGlmCiAJCS8qCiAJCSAqIEFsaWduIGRv
d24gaGVyZSBzaW5jZSB0aGUgVk0gc3Vic3lzdGVtIGluc2lzdHMgdGhhdCB0aGUKIAkJICogbWVt
bWFwIGVudHJpZXMgYXJlIHZhbGlkIGZyb20gdGhlIGJhbmsgc3RhcnQgYWxpZ25lZCB0bwogCQkg
KiBNQVhfT1JERVJfTlJfUEFHRVMuCiAJCSAqLwogCQlzdGFydCA9IHJvdW5kX2Rvd24oc3RhcnQs
IE1BWF9PUkRFUl9OUl9QQUdFUyk7Ci0jZW5kaWYKIAogCQkvKgogCQkgKiBJZiB3ZSBoYWQgYSBw
cmV2aW91cyBiYW5rLCBhbmQgdGhlcmUgaXMgYSBzcGFjZQogCgotLSAKU2luY2VyZWx5IHlvdXJz
LApNaWtlLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
