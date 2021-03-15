Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D8EC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:30:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2EB564EB2
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2EB564EB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 604DF4B3E8;
	Mon, 15 Mar 2021 05:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5k2aUcsZpUCt; Mon, 15 Mar 2021 05:30:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45CF44B3D3;
	Mon, 15 Mar 2021 05:30:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C144B385
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:30:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ExSg0a11CJWi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:30:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C40954B3AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:30:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 98C0D64E74;
 Mon, 15 Mar 2021 09:30:08 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lLjY6-001cQC-Iq; Mon, 15 Mar 2021 09:30:06 +0000
MIME-Version: 1.0
Date: Mon, 15 Mar 2021 09:30:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
In-Reply-To: <cd821431-52a7-d9a6-1468-8ce0c9446d85@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
 <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
 <b03ec1e5447024f9f990377e2c28e84f@kernel.org>
 <cd821431-52a7-d9a6-1468-8ce0c9446d85@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <4f37549dcc5d3dd59a92bc94f2f0b59b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
 lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS0wMy0xNSAwOToyNSwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMS8zLzE1IDE3
OjIwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjEtMDMtMTUgMDk6MTEsIFNoZW5taW5n
IEx1IHdyb3RlOgo+Pj4gT24gMjAyMS8zLzE1IDE2OjMwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+
Pj4gT24gMjAyMS0wMy0xMyAwODozOCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+Pj4+IEZyb206IFpl
bmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4+PiAKPj4+Pj4gV2hlbiBzZXR0aW5n
IHRoZSBmb3J3YXJkaW5nIHBhdGggb2YgYSBWTFBJIChzd2l0Y2ggdG8gdGhlIEhXIG1vZGUpLAo+
Pj4+PiB3ZSBjYW4gYWxzbyB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0ZSBmcm9tIGlycS0+cGVu
ZGluZ19sYXRjaCB0bwo+Pj4+PiBWUFQgKGVzcGVjaWFsbHkgaW4gbWlncmF0aW9uLCB0aGUgcGVu
ZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIAo+Pj4+PiByZXN0b3JlZAo+Pj4+PiBpbnRvIGt2beKA
mXMgdmdpYyBmaXJzdCkuIEFuZCB3ZSBjdXJyZW50bHkgc2VuZCAiSU5UK1ZTWU5DIiB0byAKPj4+
Pj4gdHJpZ2dlcgo+Pj4+PiBhIFZMUEkgdG8gcGVuZGluZy4KPj4+Pj4gCj4+Pj4+IFNpZ25lZC1v
ZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4+PiBTaWduZWQtb2Zm
LWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+Pj4+PiAtLS0KPj4+Pj4g
wqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYyB8IDE4ICsrKysrKysrKysrKysrKysrKwo+
Pj4+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspCj4+Pj4+IAo+Pj4+PiBkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgCj4+Pj4+IGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+Pj4gaW5kZXggYWMwMjliYTNkMzM3Li4zYjgyYWI4MGMy
ZjMgMTAwNjQ0Cj4+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+Pj4+
ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+Pj4+IEBAIC00NDksNiArNDQ5
LDI0IEBAIGludCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtIAo+Pj4+PiAq
a3ZtLCBpbnQgdmlycSwKPj4+Pj4gwqDCoMKgwqAgaXJxLT5ob3N0X2lyccKgwqDCoCA9IHZpcnE7
Cj4+Pj4+IMKgwqDCoMKgIGF0b21pY19pbmMoJm1hcC52cGUtPnZscGlfY291bnQpOwo+Pj4+PiAK
Pj4+Pj4gK8KgwqDCoCAvKiBUcmFuc2ZlciBwZW5kaW5nIHN0YXRlICovCj4+Pj4+ICvCoMKgwqAg
aWYgKGlycS0+cGVuZGluZ19sYXRjaCkgewo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQg
bG9uZyBmbGFnczsKPj4+Pj4gKwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gaXJxX3NldF9p
cnFjaGlwX3N0YXRlKGlycS0+aG9zdF9pcnEsCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElSUUNISVBfU1RBVEVfUEVORElORywKPj4+Pj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXJxLT5wZW5kaW5n
X2xhdGNoKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIFdBUk5fUkFURUxJTUlUKHJldCwgIklSUSAl
ZCIsIGlycS0+aG9zdF9pcnEpOwo+Pj4+PiArCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCAvKgo+Pj4+
PiArwqDCoMKgwqDCoMKgwqDCoCAqIENsZWFyIHBlbmRpbmdfbGF0Y2ggYW5kIGNvbW11bmljYXRl
IHRoaXMgc3RhdGUKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBjaGFuZ2UgdmlhIHZnaWNfcXVl
dWVfaXJxX3VubG9jay4KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4+Pj4gK8KgwqDCoMKg
wqDCoMKgIHJhd19zcGluX2xvY2tfaXJxc2F2ZSgmaXJxLT5pcnFfbG9jaywgZmxhZ3MpOwo+Pj4+
PiArwqDCoMKgwqDCoMKgwqAgaXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7Cj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoCB2Z2ljX3F1ZXVlX2lycV91bmxvY2soa3ZtLCBpcnEsIGZsYWdzKTsKPj4+Pj4g
K8KgwqDCoCB9Cj4+Pj4+ICsKPj4+Pj4gwqBvdXQ6Cj4+Pj4+IMKgwqDCoMKgIG11dGV4X3VubG9j
aygmaXRzLT5pdHNfbG9jayk7Cj4+Pj4+IMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+Pj4gCj4+Pj4g
VGhlIHJlYWQgc2lkZSBvZiB0aGUgcGVuZGluZyBzdGF0ZSBpc24ndCBsb2NrZWQsIGJ1dCB0aGUg
d3JpdGUgc2lkZSAKPj4+PiBpcy4KPj4+PiBJJ2QgcmF0aGVyIHlvdSBsb2NrIHRoZSB3aG9sZSBz
ZXF1ZW5jZSBmb3IgcGVhY2Ugb2YgbWluZC4KPj4+IAo+Pj4gRGlkIHlvdSBtZWFuIHRvIGxvY2sg
YmVmb3JlIGVtaXR0aW5nIHRoZSBtYXBwaW5nIHJlcXVlc3QsIE9yIGp1c3QgCj4+PiBiZWZvcmUg
cmVhZGluZwo+Pj4gdGhlIHBlbmRpbmcgc3RhdGU/Cj4+IAo+PiBKdXN0IGJlZm9yZSByZWFkaW5n
IHRoZSBwZW5kaW5nIHN0YXRlLCBzbyB0aGF0IHdlIGNhbid0IGdldCBhIAo+PiBjb25jdXJyZW50
Cj4+IG1vZGlmaWNhdGlvbiBvZiB0aGF0IHN0YXRlIHdoaWxlIHdlIG1ha2UgdGhlIGludGVycnVw
dCBwZW5kaW5nIGluIHRoZSAKPj4gVlBUCj4+IGFuZCBjbGVhcmluZyBpdCBpbiB0aGUgZW11bGF0
aW9uLgo+IAo+IEdldCBpdC4gSSB3aWxsIGNvcnJlY3QgaXQgcmlnaHQgbm93LgoKUGxlYXNlIGhv
bGQgb2ZmIHNlbmRpbmcgYSBuZXcgdmVyc2lvbiBmb3IgYSBmZXcgZGF5cy4gTXkgaW5ib3ggaXMg
CmV4cGxvZGluZy4uLgoKVGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQu
IEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
