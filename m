Return-Path: <SRS0=U5fj=VO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA7FC76186
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 08:58:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C6A421743
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 08:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C6A421743
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930834A56C;
	Wed, 17 Jul 2019 04:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2tkcBZ1rYCW; Wed, 17 Jul 2019 04:58:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE094A55D;
	Wed, 17 Jul 2019 04:58:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34EC94A541
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 04:58:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iRfLYTyWlHbI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jul 2019 04:58:25 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFD0B4A52D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 04:58:25 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 3FE53B411F28E99262E4;
 Wed, 17 Jul 2019 16:58:22 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 17 Jul 2019
 16:58:13 +0800
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 kvm_pmu_get_canonical_pmc+0x48/0x78
To: Andrew Murray <andrew.murray@arm.com>
References: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
 <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
 <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3b128267-7879-0205-3571-e219fc7b8d42@huawei.com>
Date: Wed, 17 Jul 2019 16:54:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org
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

SGkgQW5kcmV3LAoKT24gMjAxOS83LzE3IDI6NTAsIEFuZHJldyBNdXJyYXkgd3JvdGU6Cj4gT24g
VHVlLCBKdWwgMTYsIDIwMTkgYXQgMTE6MTQ6MzdQTSArMDgwMCwgWmVuZ2h1aSBZdSB3cm90ZToK
Pj4KPj4gT24gMjAxOS83LzE2IDIzOjA1LCBaZW5naHVpIFl1IHdyb3RlOgo+Pj4gSGkgZm9sa3Ms
Cj4+Pgo+Pj4gUnVubmluZyB0aGUgbGF0ZXN0IGtlcm5lbCB3aXRoIEtBU0FOIGVuYWJsZWQsIHdl
IHdpbGwgaGl0IHRoZSBmb2xsb3dpbmcKPj4+IEtBU0FOIEJVRyBkdXJpbmcgZ3Vlc3QncyBib290
IHByb2Nlc3MuCj4+Pgo+Pj4gSSdtIGluIGNvbW1pdCA5NjM3ZDUxNzM0N2U4MGVlMmZlMWM1ZDhj
ZTQ1YmExYjg4ZDhiNWNkLgo+Pj4KPj4+IEFueSBwcm9ibGVtcyBpbiB0aGUgY2hhaW5lZCBQTVUg
Y29kZT8gT3IganVzdCBhIGZhbHNlIHBvc2l0aXZlPwo+Pj4KPj4+IC0tLTg8LS0tCj4+Pgo+Pj4g
W8KgIDY1NC43MDYyNjhdCj4+PiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPj4+IFvCoCA2NTQuNzA2MjgwXSBCVUc6IEtB
U0FOOiBzbGFiLW91dC1vZi1ib3VuZHMgaW4KPj4+IGt2bV9wbXVfZ2V0X2Nhbm9uaWNhbF9wbWMr
MHg0OC8weDc4Cj4+PiBbwqAgNjU0LjcwNjI4Nl0gUmVhZCBvZiBzaXplIDggYXQgYWRkciBmZmZm
ODAxZDZjOGZlYTM4IGJ5IHRhc2sKPj4+IHFlbXUta3ZtLzIzMjY4Cj4+Pgo+Pj4gW8KgIDY1NC43
MDYyOTZdIENQVTogMiBQSUQ6IDIzMjY4IENvbW06IHFlbXUta3ZtIE5vdCB0YWludGVkIDUuMi4w
KyAjMTc4Cj4+PiBbwqAgNjU0LjcwNjMwMV0gSGFyZHdhcmUgbmFtZTogSHVhd2VpIFRhaVNoYW4g
MjI4MCAvQkMxMVNQQ0QsIEJJT1MgMS41OAo+Pj4gMTAvMjQvMjAxOAo+Pj4gW8KgIDY1NC43MDYz
MDVdIENhbGwgdHJhY2U6Cj4+PiBbwqAgNjU0LjcwNjMxMV3CoCBkdW1wX2JhY2t0cmFjZSsweDAv
MHgyMzgKPj4+IFvCoCA2NTQuNzA2MzE3XcKgIHNob3dfc3RhY2srMHgyNC8weDMwCj4+PiBbwqAg
NjU0LjcwNjMyNV3CoCBkdW1wX3N0YWNrKzB4ZTAvMHgxMzQKPj4+IFvCoCA2NTQuNzA2MzMyXcKg
IHByaW50X2FkZHJlc3NfZGVzY3JpcHRpb24rMHg4MC8weDQwOAo+Pj4gW8KgIDY1NC43MDYzMzhd
wqAgX19rYXNhbl9yZXBvcnQrMHgxNjQvMHgxYTAKPj4+IFvCoCA2NTQuNzA2MzQzXcKgIGthc2Fu
X3JlcG9ydCsweGMvMHgxOAo+Pj4gW8KgIDY1NC43MDYzNDhdwqAgX19hc2FuX2xvYWQ4KzB4ODgv
MHhiMAo+Pj4gW8KgIDY1NC43MDYzNTNdwqAga3ZtX3BtdV9nZXRfY2Fub25pY2FsX3BtYysweDQ4
LzB4NzgKPj4KPj4gSSBub3RpY2VkIHRoYXQgd2Ugd2lsbCB1c2UgInBtYy0+aWR4IiBhbmQgdGhl
ICJjaGFpbmVkIiBiaXRtYXAgdG8KPj4gZGV0ZXJtaW5lIGlmIHRoZSBwbWMgaXMgY2hhaW5lZCwg
aW4ga3ZtX3BtdV9wbWNfaXNfY2hhaW5lZCgpLgo+Pgo+PiBTaG91bGQgd2UgaW5pdGlhbGl6ZSB0
aGUgaWR4IGFuZCB0aGUgYml0bWFwIGFwcHJvcHJpYXRlbHkgYmVmb3JlCj4+IGRvaW5nIGt2bV9w
bXVfc3RvcF9jb3VudGVyKCk/ICBMaWtlOgo+IAo+IEhpIFplbmdodWksCj4gCj4gVGhhbmtzIGZv
ciBzcG90dGluZyB0aGlzIGFuZCBpbnZlc3RpZ2F0aW5nIC0gSSdsbCBtYWtlIHN1cmUgdG8gdXNl
IEtBU0FOCj4gaW4gdGhlIGZ1dHVyZSB3aGVuIHRlc3RpbmcuLi4KPiAKPj4KPj4KPj4gZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9wbXUuYwo+PiBpbmRleCAz
ZGQ4MjM4Li5jZjMxMTlhIDEwMDY0NAo+PiAtLS0gYS92aXJ0L2t2bS9hcm0vcG11LmMKPj4gKysr
IGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+IEBAIC0yMjQsMTIgKzIyNCwxMiBAQCB2b2lkIGt2bV9w
bXVfdmNwdV9yZXNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+ICAgCWludCBpOwo+PiAgIAlz
dHJ1Y3Qga3ZtX3BtdSAqcG11ID0gJnZjcHUtPmFyY2gucG11Owo+Pgo+PiArCWJpdG1hcF96ZXJv
KHZjcHUtPmFyY2gucG11LmNoYWluZWQsIEFSTVY4X1BNVV9NQVhfQ09VTlRFUl9QQUlSUyk7Cj4+
ICsKPj4gICAJZm9yIChpID0gMDsgaSA8IEFSTVY4X1BNVV9NQVhfQ09VTlRFUlM7IGkrKykgewo+
PiAtCQlrdm1fcG11X3N0b3BfY291bnRlcih2Y3B1LCAmcG11LT5wbWNbaV0pOwo+PiAgIAkJcG11
LT5wbWNbaV0uaWR4ID0gaTsKPj4gKwkJa3ZtX3BtdV9zdG9wX2NvdW50ZXIodmNwdSwgJnBtdS0+
cG1jW2ldKTsKPj4gICAJfQo+PiAtCj4+IC0JYml0bWFwX3plcm8odmNwdS0+YXJjaC5wbXUuY2hh
aW5lZCwgQVJNVjhfUE1VX01BWF9DT1VOVEVSX1BBSVJTKTsKPj4gICB9Cj4gCj4gV2UgaGF2ZSB0
byBiZSBhIGxpdHRsZSBjYXJlZnVsIGhlcmUsIGFzIHRoZSB2Y3B1IG1heSBiZSByZXNldCBhZnRl
ciB1c2UuCj4gVXBvbiByZXNldHRpbmcgd2UgbXVzdCBlbnN1cmUgdGhhdCBhbnkgZXhpc3Rpbmcg
cGVyZl9ldmVudHMgYXJlIHJlbGVhc2VkIC0KPiB0aGlzIGlzIHdoeSBrdm1fcG11X3N0b3BfY291
bnRlciBpcyBjYWxsZWQgYmVmb3JlIGJpdG1hcF96ZXJvIChhcwo+IGt2bV9wbXVfc3RvcF9jb3Vu
dGVyIHJlbGllcyBvbiBrdm1fcG11X3BtY19pc19jaGFpbmVkKS4KPiAKPiAoRm9yIGV4YW1wbGUs
IGJ5IGNsZWFyaW5nIHRoZSBiaXRtYXAgYmVmb3JlIHN0b3BwaW5nIHRoZSBjb3VudGVycywgd2Ug
d2lsbAo+IGF0dGVtcHQgdG8gcmVsZWFzZSB0aGUgcGVyZiBldmVudCBmb3IgYm90aCBwbWMncyBp
biBhIGNoYWluZWQgcGFpci4gV2hlcmVhcwo+IHdlIHNob3VsZCBvbmx5IHJlbGVhc2UgdGhlIGNh
bm9uaWNhbCBwbWMuIEl0J3MgYWN0dWFsbHkgT0sgcmlnaHQgbm93IGFzIHdlCj4gc2V0IHRoZSBu
b24tY2Fub25pY2FsIHBtYyBwZXJmX2V2ZW50IHdpbGwgYmUgTlVMTCAtIGJ1dCB3aG8ga25vd3Mg
dGhhdCB0aGlzCj4gd2lsbCBob2xkIHRydWUgaW4gdGhlIGZ1dHVyZS4gVGhlIGNvZGUgbWFrZXMg
dGhlIGFzc3VtcHRpb24gdGhhdCB0aGUKPiBub24tY2Fub25pY2FsIHBlcmYgZXZlbnQgaXNuJ3Qg
dG91Y2hlZCBvbiBhIGNoYWluZWQgcGFpcikuCgpJbmRlZWQhCgo+IFRoZSBLQVNBTiBidWcgZ2V0
cyBmaXhlZCBieSBtb3ZpbmcgdGhlIGFzc2lnbm1lbnQgb2YgaWR4IGJlZm9yZQo+IGt2bV9wbXVf
c3RvcF9jb3VudGVyLiBUaGVyZWZvcmUgSSdkIHN1Z2dlc3QgeW91IGRyb3AgdGhlIGJpdG1hcF96
ZXJvIGh1bmtzLgo+IAo+IENhbiB5b3Ugc2VuZCBhIHBhdGNoIHdpdGgganVzdCB0aGUgaWR4IGFz
c2lnbm1lbnQgaHVuayBwbGVhc2U/CgpTdXJlLiBJIHdpbGwgc2VuZCBhIHBhdGNoIHdpdGggeW91
ciBTdWdnZXN0ZWQtYnksIGFmdGVyIHNvbWUgdGVzdHMuCgoKVGhhbmtzLAp6ZW5naHVpCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
