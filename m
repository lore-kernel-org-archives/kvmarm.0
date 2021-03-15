Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE837C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 08:31:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40DFA64E90
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 08:31:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40DFA64E90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFED4B4BA;
	Mon, 15 Mar 2021 04:30:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B331651qLp8x; Mon, 15 Mar 2021 04:30:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE1D4B4C4;
	Mon, 15 Mar 2021 04:30:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1967C4B4BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 04:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3hhi5iURr9Px for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 04:30:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EEA04B284
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 04:30:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2795A64E89;
 Mon, 15 Mar 2021 08:30:55 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lLicn-001bcl-2Z; Mon, 15 Mar 2021 08:30:53 +0000
MIME-Version: 1.0
Date: Mon, 15 Mar 2021 08:30:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
In-Reply-To: <20210313083900.234-6-lushenming@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d9047922808df340feca2f257cfb8a3d@kernel.org>
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

T24gMjAyMS0wMy0xMyAwODozOCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gRnJvbTogWmVuZ2h1aSBZ
dSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4gCj4gV2hlbiBzZXR0aW5nIHRoZSBmb3J3YXJkaW5n
IHBhdGggb2YgYSBWTFBJIChzd2l0Y2ggdG8gdGhlIEhXIG1vZGUpLAo+IHdlIGNhbiBhbHNvIHRy
YW5zZmVyIHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNoIHRvCj4gVlBU
IChlc3BlY2lhbGx5IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRpbmcgc3RhdGVzIG9mIFZMUElzIGFy
ZSByZXN0b3JlZAo+IGludG8ga3Zt4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBz
ZW5kICJJTlQrVlNZTkMiIHRvIHRyaWdnZXIKPiBhIFZMUEkgdG8gcGVuZGluZy4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPiBTaWduZWQtb2Zm
LWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+IC0tLQo+ICBhcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjQuYyB8IDE4ICsrKysrKysrKysrKysrKysrKwo+ICAxIGZpbGUg
Y2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjQuYyAKPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4gaW5k
ZXggYWMwMjliYTNkMzM3Li4zYjgyYWI4MGMyZjMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY0LmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+
IEBAIC00NDksNiArNDQ5LDI0IEBAIGludCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1
Y3Qga3ZtICprdm0sIAo+IGludCB2aXJxLAo+ICAJaXJxLT5ob3N0X2lycQk9IHZpcnE7Cj4gIAlh
dG9taWNfaW5jKCZtYXAudnBlLT52bHBpX2NvdW50KTsKPiAKPiArCS8qIFRyYW5zZmVyIHBlbmRp
bmcgc3RhdGUgKi8KPiArCWlmIChpcnEtPnBlbmRpbmdfbGF0Y2gpIHsKPiArCQl1bnNpZ25lZCBs
b25nIGZsYWdzOwo+ICsKPiArCQlyZXQgPSBpcnFfc2V0X2lycWNoaXBfc3RhdGUoaXJxLT5ob3N0
X2lycSwKPiArCQkJCQkgICAgSVJRQ0hJUF9TVEFURV9QRU5ESU5HLAo+ICsJCQkJCSAgICBpcnEt
PnBlbmRpbmdfbGF0Y2gpOwo+ICsJCVdBUk5fUkFURUxJTUlUKHJldCwgIklSUSAlZCIsIGlycS0+
aG9zdF9pcnEpOwo+ICsKPiArCQkvKgo+ICsJCSAqIENsZWFyIHBlbmRpbmdfbGF0Y2ggYW5kIGNv
bW11bmljYXRlIHRoaXMgc3RhdGUKPiArCQkgKiBjaGFuZ2UgdmlhIHZnaWNfcXVldWVfaXJxX3Vu
bG9jay4KPiArCQkgKi8KPiArCQlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ss
IGZsYWdzKTsKPiArCQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBmYWxzZTsKPiArCQl2Z2ljX3F1ZXVl
X2lycV91bmxvY2soa3ZtLCBpcnEsIGZsYWdzKTsKPiArCX0KPiArCj4gIG91dDoKPiAgCW11dGV4
X3VubG9jaygmaXRzLT5pdHNfbG9jayk7Cj4gIAlyZXR1cm4gcmV0OwoKVGhlIHJlYWQgc2lkZSBv
ZiB0aGUgcGVuZGluZyBzdGF0ZSBpc24ndCBsb2NrZWQsIGJ1dCB0aGUgd3JpdGUgc2lkZSBpcy4K
SSdkIHJhdGhlciB5b3UgbG9jayB0aGUgd2hvbGUgc2VxdWVuY2UgZm9yIHBlYWNlIG9mIG1pbmQu
CgpUaGFua3MsCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVs
bHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
