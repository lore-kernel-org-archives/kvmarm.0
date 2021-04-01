Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DD2C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 13:20:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F7BD61210
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 13:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F7BD61210
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A59E4B584;
	Thu,  1 Apr 2021 09:20:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3X9BU+gntg6; Thu,  1 Apr 2021 09:20:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0294B52E;
	Thu,  1 Apr 2021 09:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E7F4B52E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:20:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iKIJ4dudkjFA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 09:20:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 182974B4DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:20:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617283242;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZiqbkW+fsGYOXlnxQRppzJEJzKV895R44yHk0nQoUrI=;
 b=PBw1Xom4PHQ8853w1hPioEpu8o2lLZSRCBgqzNxUkVH2YSlY1ayn/YgVVR3JxpkYNswJde
 0mmaOen4K3tgoI48TKt5H8l9SPfBnSLGWKVHb8Wxu8oEaHgNg6J1MB8QwFOCSqT9v6XM3X
 +xESuSyFpiXjGmOvyJ8hzXp/pRnMCTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-beXxze8UPcWqRglpKTpo3A-1; Thu, 01 Apr 2021 09:20:38 -0400
X-MC-Unique: beXxze8UPcWqRglpKTpo3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CA0483DD26;
 Thu,  1 Apr 2021 13:20:35 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BD9C5C1A1;
 Thu,  1 Apr 2021 13:20:25 +0000 (UTC)
Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 yuzenghui <yuzenghui@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
 <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
 <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
 <27a474c325fc46a092c2e11854baaccc@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ceaa8c69-abc8-50fa-6ae9-95217b1b7c4e@redhat.com>
Date: Thu, 1 Apr 2021 15:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <27a474c325fc46a092c2e11854baaccc@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 wangxingang <wangxingang5@huawei.com>, "maz@kernel.org" <maz@kernel.org>,
 "joro@8bytes.org" <joro@8bytes.org>, "vsethi@nvidia.com" <vsethi@nvidia.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "will@kernel.org" <will@kernel.org>,
 "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 lushenming <lushenming@huawei.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
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

SGkgU2hhbWVlciwKT24gNC8xLzIxIDI6MzggUE0sIFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkg
d3JvdGU6Cj4gCj4gCj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tCj4+IEZyb206IEF1Z2Vy
IEVyaWMgW21haWx0bzplcmljLmF1Z2VyQHJlZGhhdC5jb21dCj4+IFNlbnQ6IDAxIEFwcmlsIDIw
MjEgMTI6NDkKPj4gVG86IHl1emVuZ2h1aSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+IENjOiBl
cmljLmF1Z2VyLnByb0BnbWFpbC5jb207IGlvbW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3Jn
Owo+PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOwo+
PiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1OyB3aWxsQGtlcm5lbC5vcmc7IG1hekBrZXJu
ZWwub3JnOwo+PiByb2Jpbi5tdXJwaHlAYXJtLmNvbTsgam9yb0A4Ynl0ZXMub3JnOyBhbGV4Lndp
bGxpYW1zb25AcmVkaGF0LmNvbTsKPj4gdG5Ac2VtaWhhbGYuY29tOyB6aHVrZXFpYW4gPHpodWtl
cWlhbjFAaHVhd2VpLmNvbT47Cj4+IGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tOyB5aS5s
LmxpdUBpbnRlbC5jb207IHdhbmd4aW5nYW5nCj4+IDx3YW5neGluZ2FuZzVAaHVhd2VpLmNvbT47
IGppYW5na3Vua3VuIDxqaWFuZ2t1bmt1bkBodWF3ZWkuY29tPjsKPj4gamVhbi1waGlsaXBwZUBs
aW5hcm8ub3JnOyB6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZzsgemhhbmdmZWkuZ2FvQGdtYWlsLmNv
bTsKPj4gdml2ZWsuZ2F1dGFtQGFybS5jb207IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkKPj4g
PHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47IG5pY29sZW90c3VrYUBnbWFp
bC5jb207Cj4+IGx1c2hlbm1pbmcgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT47IHZzZXRoaUBudmlk
aWEuY29tOyBXYW5naGFpYmluIChEKQo+PiA8d2FuZ2hhaWJpbi53YW5nQGh1YXdlaS5jb20+Cj4+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjE0IDEzLzEzXSBpb21tdS9zbW11djM6IEFjY2VwdCBjb25m
aWdzIHdpdGggbW9yZSB0aGFuCj4+IG9uZSBjb250ZXh0IGRlc2NyaXB0b3IKPj4KPj4gSGkgWmVu
Z2h1aSwKPj4KPj4gT24gMy8zMC8yMSAxMToyMyBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4+IEhp
IEVyaWMsCj4+Pgo+Pj4gT24gMjAyMS8yLzI0IDQ6NTYsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+Pj4g
SW4gcHJlcGFyYXRpb24gZm9yIHZTVkEsIGxldCdzIGFjY2VwdCB1c2Vyc3BhY2UgcHJvdmlkZWQg
Y29uZmlncwo+Pj4+IHdpdGggbW9yZSB0aGFuIG9uZSBDRC4gV2UgY2hlY2sgdGhlIG1heCBDRCBh
Z2FpbnN0IHRoZSBob3N0IGlvbW11Cj4+Pj4gY2FwYWJpbGl0eSBhbmQgYWxzbyB0aGUgZm9ybWF0
IChsaW5lYXIgdmVyc3VzIDIgbGV2ZWwpLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFNoYW1lZXIg
S29sb3RodW0KPj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4KPj4+PiAt
LS0KPj4+PiDCoCBkcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jIHwg
MTMgKysrKysrKystLS0tLQo+Pj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyks
IDUgZGVsZXRpb25zKC0pCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0v
YXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYwo+Pj4+IGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNt
bXUtdjMvYXJtLXNtbXUtdjMuYwo+Pj4+IGluZGV4IDMzMmQzMWMwNjgwZi4uYWI3NGEwMjg5ODkz
IDEwMDY0NAo+Pj4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11
LXYzLmMKPj4+PiArKysgYi9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12
My5jCj4+Pj4gQEAgLTMwMzgsMTQgKzMwMzgsMTcgQEAgc3RhdGljIGludAo+PiBhcm1fc21tdV9h
dHRhY2hfcGFzaWRfdGFibGUoc3RydWN0Cj4+Pj4gaW9tbXVfZG9tYWluICpkb21haW4sCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChzbW11X2RvbWFpbi0+czFfY2ZnLnNldCkKPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+PiDCoCAtwqDCoMKgwqDCoMKgwqAg
LyoKPj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqIHdlIGN1cnJlbnRseSBzdXBwb3J0IGEgc2luZ2xl
IENEIHNvIHMxZm10IGFuZCBzMWRzcwo+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgICogZmllbGRzIGFy
ZSBhbHNvIGlnbm9yZWQKPj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqLwo+Pj4+IC3CoMKgwqDCoMKg
wqDCoCBpZiAoY2ZnLT5wYXNpZF9iaXRzKQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBsaXN0X2Zvcl9l
YWNoX2VudHJ5KG1hc3RlciwgJnNtbXVfZG9tYWluLT5kZXZpY2VzLAo+Pj4+IGRvbWFpbl9oZWFk
KSB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGNmZy0+cGFzaWRfYml0cyA+IG1h
c3Rlci0+c3NpZF9iaXRzKQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290
byBvdXQ7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGNm
Zy0+dmVuZG9yX2RhdGEuc21tdXYzLnMxZm10ID09Cj4+Pj4gU1RSVEFCX1NURV8wX1MxRk1UXzY0
S19MMiAmJgo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIShzbW11LT5mZWF0
dXJlcyAmCj4+IEFSTV9TTU1VX0ZFQVRfMl9MVkxfQ0RUQUIpKQo+Pj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGdvdG8gb3V0Owo+Pj4+IMKgIMKgwqDCoMKgwqDCoMKgwqDCoCBzbW11X2Rv
bWFpbi0+czFfY2ZnLmNkY2ZnLmNkdGFiX2RtYSA9IGNmZy0+YmFzZV9wdHI7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgIHNtbXVfZG9tYWluLT5zMV9jZmcuczFjZG1heCA9IGNmZy0+cGFzaWRfYml0czsK
Pj4+PiArwqDCoMKgwqDCoMKgwqAgc21tdV9kb21haW4tPnMxX2NmZy5zMWZtdCA9Cj4+IGNmZy0+
dmVuZG9yX2RhdGEuc21tdXYzLnMxZm10Owo+Pj4KPj4+IEFuZCB3aGF0IGFib3V0IHRoZSBTSURT
UyBmaWVsZD8KPj4+Cj4+IEkgYWRkZWQgdGhpcyBwYXRjaCB1cG9uIFNoYW1lZXIncyByZXF1ZXN0
LCB0byBiZSBtb3JlIHZTVkEgZnJpZW5kbHkuCj4+IEhvd2VyIHRoaXMgc2VyaWVzIGRvZXMgbm90
IHJlYWxseSB0YXJnZXQgbXVsdGlwbGUgQ0Qgc3VwcG9ydC4gQXQgdGhlCj4+IG1vbWVudCB0aGUg
ZHJpdmVyIG9ubHkgc3VwcG9ydHMgU1RSVEFCX1NURV8xX1MxRFNTX1NTSUQwICgweDIpIEkgdGhp
bmsuCj4+IEF0IHRoaXMgbW9tZW50IG1heWJlIEkgY2FuIG9ubHkgY2hlY2sgdGhlIHMxZHNzIGZp
ZWxkIGlzIDB4Mi4gT3Igc2ltcGx5Cj4+IHJlbW92ZXMgdGhpcyBwYXRjaD8KPj4KPj4gVGhvdWdo
dHM/Cj4gCj4gUmlnaHQuIFRoaXMgd2FzIHVzZWZ1bCBmb3IgdlNWQSB0ZXN0cy4gQnV0IHllcywg
dG8gcHJvcGVybHkgc3VwcG9ydCBtdWx0aXBsZSBDRHMKPiB3ZSBuZWVkIHRvIHBhc3MgdGhlIFMx
RFNTIGZyb20gUWVtdS4gQW5kIHRoYXQgcmVxdWlyZXMgZnVydGhlciBjaGFuZ2VzLgo+IFNvIEkg
dGhpbmsgaXQncyBiZXR0ZXIgdG8gcmVtb3ZlIHRoaXMgcGF0Y2ggYW5kIHJlamVjdCBTMUNETUFY
ICE9IDAgY2FzZXMuCk9LIEkgd2lsbCByZW1vdmUgaXQKClRoYW5rcwoKRXJpYwo+IAo+IFRoYW5r
cywKPiBTaGFtZWVyCj4gICAgCj4+Cj4+IEVyaWMKPiAKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
