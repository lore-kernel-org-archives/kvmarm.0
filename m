Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E76C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:21:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABA5F64E33
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABA5F64E33
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 436F74B48E;
	Mon, 15 Mar 2021 05:21:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JwDhmSPKc8Ut; Mon, 15 Mar 2021 05:21:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CCAA4B431;
	Mon, 15 Mar 2021 05:21:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4CAC4B407
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:21:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwkZ8rg0j+SL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:21:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CE104B307
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:21:03 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ADB7264E12;
 Mon, 15 Mar 2021 09:21:00 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lLjPG-001cIb-KN; Mon, 15 Mar 2021 09:20:58 +0000
MIME-Version: 1.0
Date: Mon, 15 Mar 2021 09:20:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
In-Reply-To: <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
 <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <b03ec1e5447024f9f990377e2c28e84f@kernel.org>
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

T24gMjAyMS0wMy0xNSAwOToxMSwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMS8zLzE1IDE2
OjMwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjEtMDMtMTMgMDg6MzgsIFNoZW5taW5n
IEx1IHdyb3RlOgo+Pj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+
PiAKPj4+IFdoZW4gc2V0dGluZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQSSAoc3dpdGNo
IHRvIHRoZSBIVyBtb2RlKSwKPj4+IHdlIGNhbiBhbHNvIHRyYW5zZmVyIHRoZSBwZW5kaW5nIHN0
YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNoIHRvCj4+PiBWUFQgKGVzcGVjaWFsbHkgaW4gbWln
cmF0aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIAo+Pj4gcmVzdG9yZWQKPj4+
IGludG8ga3Zt4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQrVlNZ
TkMiIHRvIHRyaWdnZXIKPj4+IGEgVkxQSSB0byBwZW5kaW5nLgo+Pj4gCj4+PiBTaWduZWQtb2Zm
LWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+IFNpZ25lZC1vZmYtYnk6
IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+Cj4+PiAtLS0KPj4+IMKgYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgfCAxOCArKysrKysrKysrKysrKysrKysKPj4+IMKgMSBm
aWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKykKPj4+IAo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIAo+Pj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djQuYwo+Pj4gaW5kZXggYWMwMjliYTNkMzM3Li4zYjgyYWI4MGMyZjMgMTAwNjQ0Cj4+PiAtLS0g
YS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLXY0LmMKPj4+IEBAIC00NDksNiArNDQ5LDI0IEBAIGludCBrdm1fdmdpY192NF9z
ZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtICprdm0sIAo+Pj4gaW50IHZpcnEsCj4+PiDCoMKgwqDC
oCBpcnEtPmhvc3RfaXJxwqDCoMKgID0gdmlycTsKPj4+IMKgwqDCoMKgIGF0b21pY19pbmMoJm1h
cC52cGUtPnZscGlfY291bnQpOwo+Pj4gCj4+PiArwqDCoMKgIC8qIFRyYW5zZmVyIHBlbmRpbmcg
c3RhdGUgKi8KPj4+ICvCoMKgwqAgaWYgKGlycS0+cGVuZGluZ19sYXRjaCkgewo+Pj4gK8KgwqDC
oMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqAg
cmV0ID0gaXJxX3NldF9pcnFjaGlwX3N0YXRlKGlycS0+aG9zdF9pcnEsCj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJUlFDSElQX1NUQVRFX1BFTkRJ
TkcsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
cnEtPnBlbmRpbmdfbGF0Y2gpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIFdBUk5fUkFURUxJTUlUKHJl
dCwgIklSUSAlZCIsIGlycS0+aG9zdF9pcnEpOwo+Pj4gKwo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8q
Cj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIENsZWFyIHBlbmRpbmdfbGF0Y2ggYW5kIGNvbW11bmlj
YXRlIHRoaXMgc3RhdGUKPj4+ICvCoMKgwqDCoMKgwqDCoMKgICogY2hhbmdlIHZpYSB2Z2ljX3F1
ZXVlX2lycV91bmxvY2suCj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqLwo+Pj4gK8KgwqDCoMKgwqDC
oMKgIHJhd19zcGluX2xvY2tfaXJxc2F2ZSgmaXJxLT5pcnFfbG9jaywgZmxhZ3MpOwo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGlycS0+cGVuZGluZ19sYXRjaCA9IGZhbHNlOwo+Pj4gK8KgwqDCoMKgwqDC
oMKgIHZnaWNfcXVldWVfaXJxX3VubG9jayhrdm0sIGlycSwgZmxhZ3MpOwo+Pj4gK8KgwqDCoCB9
Cj4+PiArCj4+PiDCoG91dDoKPj4+IMKgwqDCoMKgIG11dGV4X3VubG9jaygmaXRzLT5pdHNfbG9j
ayk7Cj4+PiDCoMKgwqDCoCByZXR1cm4gcmV0Owo+PiAKPj4gVGhlIHJlYWQgc2lkZSBvZiB0aGUg
cGVuZGluZyBzdGF0ZSBpc24ndCBsb2NrZWQsIGJ1dCB0aGUgd3JpdGUgc2lkZSAKPj4gaXMuCj4+
IEknZCByYXRoZXIgeW91IGxvY2sgdGhlIHdob2xlIHNlcXVlbmNlIGZvciBwZWFjZSBvZiBtaW5k
Lgo+IAo+IERpZCB5b3UgbWVhbiB0byBsb2NrIGJlZm9yZSBlbWl0dGluZyB0aGUgbWFwcGluZyBy
ZXF1ZXN0LCBPciBqdXN0IAo+IGJlZm9yZSByZWFkaW5nCj4gdGhlIHBlbmRpbmcgc3RhdGU/CgpK
dXN0IGJlZm9yZSByZWFkaW5nIHRoZSBwZW5kaW5nIHN0YXRlLCBzbyB0aGF0IHdlIGNhbid0IGdl
dCBhIGNvbmN1cnJlbnQKbW9kaWZpY2F0aW9uIG9mIHRoYXQgc3RhdGUgd2hpbGUgd2UgbWFrZSB0
aGUgaW50ZXJydXB0IHBlbmRpbmcgaW4gdGhlIApWUFQKYW5kIGNsZWFyaW5nIGl0IGluIHRoZSBl
bXVsYXRpb24uCgpUaGFua3MsCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQg
anVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
