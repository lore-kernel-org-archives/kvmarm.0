Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C94AC433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:13:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5FCE64E2A
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5FCE64E2A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9A24B1F1;
	Mon,  1 Feb 2021 08:13:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TQNuj8GnTo7B; Mon,  1 Feb 2021 08:13:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E874B1FA;
	Mon,  1 Feb 2021 08:13:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 695C84B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:13:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9liMzpIppQk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 08:13:02 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FE554B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:13:01 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DTpHc4F8Sz162jk;
 Mon,  1 Feb 2021 21:11:40 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Feb 2021 21:12:49 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
To: Marc Zyngier <maz@kernel.org>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f68d12f2-fa98-ebdd-3075-bfdcd690ee51@huawei.com>
Date: Mon, 1 Feb 2021 21:12:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
 zhengchuan@huawei.com, Alex Williamson <alex.williamson@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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

SGkgTWFyYywKCkRvIHlvdSBoYXZlIHRpbWUgdG8gaGF2ZSBhIGxvb2sgYXQgdGhpcz8gVGhhbmtz
IDstKQoKS2VxaWFuLgoKT24gMjAyMS8xLzI2IDIwOjQ0LCBLZXFpYW4gWmh1IHdyb3RlOgo+IFRo
ZSBpbnRlbnRpb246Cj4gCj4gT24gYXJtNjQgcGxhdGZvcm0sIHdlIHRyYWNraW5nIGRpcnR5IGxv
ZyBvZiB2Q1BVIHRocm91Z2ggZ3Vlc3QgbWVtb3J5IGFib3J0Lgo+IEtWTSBvY2N1cHlzIHNvbWUg
dkNQVSB0aW1lIG9mIGd1ZXN0IHRvIGNoYW5nZSBzdGFnZTIgbWFwcGluZyBhbmQgbWFyayBkaXJ0
eS4KPiBUaGlzIGxlYWRzIHRvIGhlYXZ5IHNpZGUgZWZmZWN0IG9uIFZNLCBlc3BlY2lhbGx5IHdo
ZW4gbXVsdGkgdkNQVSByYWNlIGFuZAo+IHNvbWUgb2YgdGhlbSBibG9jayBvbiBrdm0gbW11X2xv
Y2suCj4gCj4gREJNIGlzIGEgSFcgYXV4aWxpYXJ5IGFwcHJvYWNoIHRvIGxvZyBkaXJ0eS4gTU1V
IGNoYWdlcyBQVEUgdG8gYmUgd3JpdGFibGUgaWYKPiBpdHMgREJNIGJpdCBpcyBzZXQuIFRoZW4g
S1ZNIGRvZXNuJ3Qgb2NjdXB5IHZDUFUgdGltZSB0byBsb2cgZGlydHkuCj4gCj4gQWJvdXQgdGhp
cyBwYXRjaCBzZXJpZXM6Cj4gCj4gVGhlIGJpZ2dlc3QgcHJvYmxlbSBvZiBhcHBseSBEQk0gZm9y
IHN0YWdlMiBpcyB0aGF0IHNvZnR3YXJlIG11c3Qgc2NhbiBQVHMgdG8KPiBjb2xsZWN0IGRpcnR5
IHN0YXRlLCB3aGljaCBtYXkgY29zdCBtdWNoIHRpbWUgYW5kIGFmZmVjdCBkb3dudGltZSBvZiBt
aWdyYXRpb24uCj4gCj4gVGhpcyBzZXJpZXMgcmVhbGl6ZSBhIFNXL0hXIGNvbWJpbmVkIGRpcnR5
IGxvZyB0aGF0IGNhbiBlZmZlY3RpdmVseSBzb2x2ZSB0aGlzCj4gcHJvYmxlbSAoVGhlIHNtbXUg
c2lkZSBjYW4gYWxzbyB1c2UgdGhpcyBhcHByb2FjaCB0byBzb2x2ZSBkbWEgZGlydHkgbG9nIHRy
YWNraW5nKS4KPiAKPiBUaGUgY29yZSBpZGVhIGlzIHRoYXQgd2UgZG8gbm90IGVuYWJsZSBoYXJk
d2FyZSBkaXJ0eSBhdCBzdGFydCAoZG8gbm90IGFkZCBEQk0gYml0KS4KPiBXaGVuIGEgYXJiaXRy
YXJ5IFBUIG9jY3VycyBmYXVsdCwgd2UgZXhlY3V0ZSBzb2Z0IHRyYWNraW5nIGZvciB0aGlzIFBU
IGFuZCBlbmFibGUKPiBoYXJkd2FyZSB0cmFja2luZyBmb3IgaXRzICpuZWFyYnkqIFBUcyAoZS5n
LiBBZGQgREJNIGJpdCBmb3IgbmVhcmJ5IDE2UFRzKS4gVGhlbiB3aGVuCj4gc3luYyBkaXJ0eSBs
b2csIHdlIGhhdmUga25vd24gYWxsIFBUcyB3aXRoIGhhcmR3YXJlIGRpcnR5IGVuYWJsZWQsIHNv
IHdlIGRvIG5vdCBuZWVkCj4gdG8gc2NhbiBhbGwgUFRzLgo+IAo+ICAgICAgICAgbWVtIGFib3J0
IHBvaW50ICAgICAgICAgICAgIG1lbSBhYm9ydCBwb2ludAo+ICAgICAgICAgICAgICAg4oaTICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIOKGkwo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgICAgICAgfCoqKioqKioq
fCAgICAgICAgfCAgICAgICAgfCoqKioqKioqfCAgICAgICAgfCAgICAgICAgfAo+IC0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+
ICAgICAgICAgICAgICDihpEgICAgICAgICAgICAgICAgICAgICAgICAgICAg4oaRCj4gICAgICAg
ICBzZXQgREJNIGJpdCBvZiAgICAgICAgICAgICAgIHNldCBEQk0gYml0IG9mCj4gICAgICB0aGlz
IFBUIHNlY3Rpb24gKDY0UFRFcykgICAgICB0aGlzIFBUIHNlY3Rpb24gKDY0UFRFcykKPiAKPiBX
ZSBtYXkgd29ycnkgdGhhdCB3aGVuIGRpcnR5IHJhdGUgaXMgb3Zlci1oaWdoIHdlIHN0aWxsIG5l
ZWQgdG8gc2NhbiB0b28gbXVjaCBQVHMuCj4gV2UgbWFpbmx5IGNvbmNlcm4gdGhlIFZNIHN0b3Ag
dGltZS4gV2l0aCBRZW11IGRpcnR5IHJhdGUgdGhyb3R0bGluZywgdGhlIGRpcnR5IG1lbW9yeQo+
IGlzIGNsb3NpbmcgdG8gdGhlIFZNIHN0b3AgdGhyZXNob2xkLCBzbyB0aGVyZSBpcyBhIGxpdHRs
ZSBQVHMgdG8gc2NhbiBhZnRlciBWTSBzdG9wLgo+IAo+IEl0IGhhcyB0aGUgYWR2YW50YWdlcyBv
ZiBoYXJkd2FyZSB0cmFja2luZyB0aGF0IG1pbmltaXplcyBzaWRlIGVmZmVjdCBvbiB2Q1BVLAo+
IGFuZCBhbHNvIGhhcyB0aGUgYWR2YW50YWdlcyBvZiBzb2Z0d2FyZSB0cmFja2luZyB0aGF0IGNv
bnRyb2xzIHZDUFUgZGlydHkgcmF0ZS4KPiBNb3Jlb3Zlciwgc29mdHdhcmUgdHJhY2tpbmcgaGVs
cHMgdXMgdG8gc2NhbiBQVHMgYXQgc29tZSBmaXhlZCBwb2ludHMsIHdoaWNoCj4gZ3JlYXRseSBy
ZWR1Y2VzIHNjYW5uaW5nIHRpbWUuIEFuZCB0aGUgYmlnZ2VzdCBiZW5lZml0IGlzIHRoYXQgd2Ug
Y2FuIGFwcGx5IHRoaXMKPiBzb2x1dGlvbiBmb3IgZG1hIGRpcnR5IHRyYWNraW5nLgo+IAo+IFRl
c3Q6Cj4gCj4gSG9zdDogS3VucGVuZyA5MjAgd2l0aCAxMjggQ1BVIDUxMkcgUkFNLiBEaXNhYmxl
IFRyYW5zcGFyZW50IEh1Z2VwYWdlIChFbnN1cmUgdGVzdCByZXN1bHQKPiAgICAgICBpcyBub3Qg
ZWZmZWN0ZWQgYnkgZGlzc29sdmUgb2YgYmxvY2sgcGFnZSB0YWJsZSBhdCB0aGUgZWFybHkgc3Rh
Z2Ugb2YgbWlncmF0aW9uKS4KPiBWTTogICAxNiBDUFUgMTZHQiBSQU0uIFJ1biA0IHBhaXIgb2Yg
KHJlZGlzX2JlbmNobWFyaytyZWRpc19zZXJ2ZXIpLgo+IAo+IEVhY2ggcnVuIDUgdGltZXMgZm9y
IHNvZnR3YXJlIGRpcnR5IGxvZyBhbmQgU1cvSFcgY29uYmluZWQgZGlydHkgbG9nLiAKPiAKPiBU
ZXN0IHJlc3VsdDoKPiAKPiBHYWluIDUlfjclIGltcHJvdmVtZW50IG9mIHJlZGlzIFFQUyBkdXJp
bmcgVk0gbWlncmF0aW9uLgo+IFZNIGRvd250aW1lIGlzIG5vdCBhZmZlY3RlZCBmdW5kYW1lbnRh
bGx5Lgo+IEFib3V0IDU2LjclIG9mIERCTSBpcyBlZmZlY3RpdmVseSB1c2VkLgo+IAo+IEtlcWlh
biBaaHUgKDcpOgo+ICAgYXJtNjQ6IGNwdWZlYXR1cmU6IEFkZCBBUEkgdG8gcmVwb3J0IHN5c3Rl
bSBzdXBwb3J0IG9mIEhXREJNCj4gICBrdm06IGFybTY0OiBVc2UgYXRvbWljIG9wZXJhdGlvbiB3
aGVuIHVwZGF0ZSBQVEUKPiAgIGt2bTogYXJtNjQ6IEFkZCBsZXZlbF9hcHBseSBwYXJhbWV0ZXIg
Zm9yIHN0YWdlMl9hdHRyX3dhbGtlcgo+ICAga3ZtOiBhcm02NDogQWRkIHNvbWUgSFdfREJNIHJl
bGF0ZWQgcGd0YWJsZSBpbnRlcmZhY2VzCj4gICBrdm06IGFybTY0OiBBZGQgc29tZSBIV19EQk0g
cmVsYXRlZCBtbXUgaW50ZXJmYWNlcwo+ICAga3ZtOiBhcm02NDogT25seSB3cml0ZSBwcm90ZWN0
IHNlbGVjdGVkIFBURQo+ICAga3ZtOiBhcm02NDogU3RhcnQgdXAgU1cvSFcgY29tYmluZWQgZGly
dHkgbG9nCj4gCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oICB8ICAxMiAr
KysKPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgIHwgICA2ICsrCj4gIGFy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX21tdS5oICAgICB8ICAgNyArKwo+ICBhcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2t2bV9wZ3RhYmxlLmggfCAgNDUgKysrKysrKysrKwo+ICBhcmNoL2FybTY0
L2t2bS9hcm0uYyAgICAgICAgICAgICAgICAgfCAxMjUgKysrKysrKysrKysrKysrKysrKysrKysr
KysKPiAgYXJjaC9hcm02NC9rdm0vaHlwL3BndGFibGUuYyAgICAgICAgIHwgMTMwICsrKysrKysr
KysrKysrKysrKysrKystLS0tLQo+ICBhcmNoL2FybTY0L2t2bS9tbXUuYyAgICAgICAgICAgICAg
ICAgfCAgNDcgKysrKysrKysrLQo+ICBhcmNoL2FybTY0L2t2bS9yZXNldC5jICAgICAgICAgICAg
ICAgfCAgIDggKy0KPiAgOCBmaWxlcyBjaGFuZ2VkLCAzNTEgaW5zZXJ0aW9ucygrKSwgMjkgZGVs
ZXRpb25zKC0pCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
