Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E0BC388F7
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 07:55:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43CFE20936
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 07:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43CFE20936
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 655D24BD66;
	Fri, 13 Nov 2020 02:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SxnO5czpBiSh; Fri, 13 Nov 2020 02:55:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D9594BD21;
	Fri, 13 Nov 2020 02:55:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A9234BD0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 02:55:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 54b-8aKptrWx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 02:54:58 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4122D4BBEC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 02:54:58 -0500 (EST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CXW2m6vhYz76kc;
 Fri, 13 Nov 2020 15:54:40 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Nov 2020 15:54:44 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
Date: Fri, 13 Nov 2020 15:54:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, fanhenglong@huawei.com, prime.zeng@hisilicon.com,
 maz@kernel.org, will@kernel.org
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

SGkgYWxs77yMCgpTb3JyeSBmb3IgdGhlIGRlbGF5LiBJIGhhdmUgYmVlbiB0ZXN0aW5nIHRoZSBU
V0VEIGZlYXR1cmUgcGVyZm9ybWFuY2UKbGF0ZWx5LiBXZSBzZWxlY3QgdW5peGJlbmNoIGFzIHRo
ZSBiZW5jaG1hcmsgZm9yIHNvbWUgaXRlbXMgb2YgaXQgaXMgCmxvY2staW50ZW5zaXZlKGZzdGlt
ZS9mc2J1ZmZlci9mc2Rpc2spLiBXZSBydW4gdW5peGJlbmNoIG9uIGEgNC1WQ1BVClZNLCBhbmQg
YmluZCBldmVyeSB0d28gVkNQVXMgb24gb25lIFBDUFUuIEZpeGVkIFRXRUQgdmFsdWUgaXMgdXNl
ZCBhbmQgCmhlcmUgaXMgdGhlIHJlc3VsdC4KCiAgICAgIHR3ZWRfdmFsdWUgICB8IGZzdGltZSAg
ICAgICAgfCBmc2J1ZmZlciAgIHwgZnNkaXNrCiAgICAgLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0KICAgICAgZGlzYWJsZSAgICAgIHwgMTYu
MCAgICAgICAgICB8IDE0LjEgICAgICAgfCAxOC4wCiAgICAgIDAgICAgICAgICAgICB8IDE2LjMg
ICAgICAgICAgfCAxMy41ICAgICAgIHwgMTcuMgogICAgICAxICAgICAgICAgICAgfCAxNy41ICAg
ICAgICAgIHwgMTQuNyAgICAgICB8IDE3LjQKICAgICAgMiAgICAgICAgICAgIHwgMTcuMyAgICAg
ICAgICB8IDE1LjMgICAgICAgfCAxOC4wCiAgICAgIDMgICAgICAgICAgICB8IDE3LjcgICAgICAg
ICAgfCAxNS4yICAgICAgIHwgMTguOQogICAgICA0ICAgICAgICAgICAgfCAxNy45ICAgICAgICAg
IHwgMTQuMyAgICAgICB8IDE4LjIKICAgICAgNSAgICAgICAgICAgIHwgMTcuMiAgICAgICAgICB8
IDE0LjEgICAgICAgfCAxOS4wCiAgICAgIDYgICAgICAgICAgICB8IDUuOCAgICAgICAgICAgfCA0
LjIgICAgICAgIHwgNS43CiAgICAgIDcgICAgICAgICAgICB8IDYuMiAgICAgICAgICAgfCA1LjYg
ICAgICAgIHwgMTIuOAoKTm90ZToKZnN0aW1lOiBGaWxlIENvcHkgMTAyNCBidWZzaXplIDIwMDAg
bWF4YmxvY2tzCmZzYnVmZmVyOiBGaWxlIENvcHkgMjU2IGJ1ZnNpemUgNTAwIG1heGJsb2Nrcwpm
c2Rpc2s6IEZpbGUgQ29weSA0MDk2IGJ1ZnNpemUgODAwMCBtYXhibG9ja3MKVGhlIGluZGV4IG9m
IHVuaXhiZW5jaCwgaGlnaGVyIGlzIGJldHRlci4KCkl0IGlzIHNob3duIHRoYXQsIGNvbXBhcmVk
IHRvIHRoZSBjaXJjdW1zdGFuY2UgdGhhdCBUV0VEIGlzIGRpc2FibGVkLApsb2NrLWludGVuc2l2
ZSB0ZXN0aW5nIGl0ZW1zIGhhdmUgYmV0dGVyIHBlcmZvcm1hbmNlIGlmIGFuIGFwcHJvcHJpYXRl
ClRXRUQgdmFsdWUgaXMgc2V0KHVwIHRvIDUuNiV+MTEuOSUpLiBNZWFud2hpbGUsIHRoZSBjb21w
bGV0ZSB1bml4YmVuY2gKdGVzdCBpcyBydW4gdG8gcHJvdmUgdGhhdCBvdGhlciB0ZXN0aW5nIGl0
ZW1zIGFyZSBub3Qgc2Vuc2l0aXZlIHRvIHRoaXMKcGFyYW1ldGVyLgoKVGhhbmtzCkppbmd5aQoK
T24gOS8yOS8yMDIwIDU6MTcgUE0sIEppbmd5aSBXYW5nIHdyb3RlOgo+IFRXRSBEZWxheSBpcyBh
biBvcHRpb25hbCBmZWF0dXJlIGluIEFSTXY4LjYgRXh0ZW50aW9ucy4gVGhlcmUgaXMgYQo+IHBl
cmZvcm1hbmNlIGJlbmVmaXQgaW4gd2FpdGluZyBmb3IgYSBwZXJpb2Qgb2YgdGltZSBmb3IgYW4g
ZXZlbnQgdG8KPiBhcnJpdmUgYmVmb3JlIHRha2luZyB0aGUgdHJhcCBhcyBpdCBpcyBjb21tb24g
dGhhdCBldmVudCB3aWxsIGFycml2ZQo+IOKAnHF1aXRlIHNvb27igJ0gYWZ0ZXIgZXhlY3V0aW5n
IHRoZSBXRkUgaW5zdHJ1Y3Rpb24uCj4gCj4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBU
V0VEIGZlYXR1cmUgYW5kIGltcGxlbWVudHMgVFdFIGRlbGF5Cj4gdmFsdWUgZHluYW1pYyBhZGp1
c3RtZW50Lgo+IAo+IFRoYW5rcyBmb3IgU2hhbWVlcidzIGFkdmljZSBvbiB0aGlzIHNlcmllcy4g
VGhlIGZ1bmN0aW9uIG9mIHRoaXMgcGF0Y2gKPiBoYXMgYmVlbiB0ZXN0ZWQgb24gVFdFRCBzdXBw
b3J0ZWQgaGFyZHdhcmUgYW5kIHRoZSBwZXJmb3JtYW5jZSBvZiBpdCBpcwo+IHN0aWxsIG9uIHRl
c3QsIGFueSBhZHZpY2Ugd2lsbCBiZSB3ZWxjb21lZC4KPiAKPiBKaW5neWkgV2FuZyAoMik6Cj4g
ICAgS1ZNOiBhcm02NDogTWFrZSB1c2Ugb2YgVFdFRCBmZWF0dXJlCj4gICAgS1ZNOiBhcm02NDog
VXNlIGR5bmFtaWMgVFdFIERlbGF5IHZhbHVlCj4gCj4gWmVuZ3J1YW4gWWUgKDIpOgo+ICAgIGFy
bTY0OiBjcHVmZWF0dXJlOiBUV0VEIHN1cHBvcnQgZGV0ZWN0aW9uCj4gICAgS1ZNOiBhcm02NDog
QWRkIHRyYWNlIGZvciBUV0VEIHVwZGF0ZQo+IAo+ICAgYXJjaC9hcm02NC9LY29uZmlnICAgICAg
ICAgICAgICAgICAgIHwgMTAgKysrKysKPiAgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1Y2Fw
cy5oICAgICB8ICAzICstCj4gICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hcm0uaCAgICAg
fCAgNSArKysKPiAgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2VtdWxhdGUuaCB8IDM4ICsr
KysrKysrKysrKysrKysrKwo+ICAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAg
IHwgMTkgKysrKysrKystCj4gICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL3ZpcnQuaCAgICAgICAg
fCAgOCArKysrCj4gICBhcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMgICAgICAgfCAxMiAr
KysrKysKPiAgIGFyY2gvYXJtNjQva3ZtL2FybS5jICAgICAgICAgICAgICAgICB8IDU4ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysKPiAgIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMg
ICAgICAgICB8ICAyICsKPiAgIGFyY2gvYXJtNjQva3ZtL3RyYWNlX2FybS5oICAgICAgICAgICB8
IDIxICsrKysrKysrKysKPiAgIDEwIGZpbGVzIGNoYW5nZWQsIDE3NCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
