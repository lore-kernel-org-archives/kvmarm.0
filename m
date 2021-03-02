Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39317C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 11:23:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76D8064F0B
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 11:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76D8064F0B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFDAF4B5A7;
	Tue,  2 Mar 2021 06:23:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WON8p9OJAdRr; Tue,  2 Mar 2021 06:23:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E0C4B45F;
	Tue,  2 Mar 2021 06:23:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1E34B22C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 06:23:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWLTA9SyAcY3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 06:23:23 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5EF84B1F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 06:23:22 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DqZSh6TyQzMh72;
 Tue,  2 Mar 2021 19:21:08 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 19:23:05 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <4716a83b-5dad-4dbc-6661-e1f05abbd29c@huawei.com>
Date: Tue, 2 Mar 2021 19:23:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, zhengchuan@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>
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

SGkgZXZlcnlvbmUsCgpBbnkgY29tbWVudHMgYXJlIHdlbGNvbWUgOikuCgpUaGFua3MsCktlcWlh
bgoKT24gMjAyMS8xLzI2IDIwOjQ0LCBLZXFpYW4gWmh1IHdyb3RlOgo+IFRoZSBpbnRlbnRpb246
Cj4gCj4gT24gYXJtNjQgcGxhdGZvcm0sIHdlIHRyYWNraW5nIGRpcnR5IGxvZyBvZiB2Q1BVIHRo
cm91Z2ggZ3Vlc3QgbWVtb3J5IGFib3J0Lgo+IEtWTSBvY2N1cHlzIHNvbWUgdkNQVSB0aW1lIG9m
IGd1ZXN0IHRvIGNoYW5nZSBzdGFnZTIgbWFwcGluZyBhbmQgbWFyayBkaXJ0eS4KPiBUaGlzIGxl
YWRzIHRvIGhlYXZ5IHNpZGUgZWZmZWN0IG9uIFZNLCBlc3BlY2lhbGx5IHdoZW4gbXVsdGkgdkNQ
VSByYWNlIGFuZAo+IHNvbWUgb2YgdGhlbSBibG9jayBvbiBrdm0gbW11X2xvY2suCj4gCj4gREJN
IGlzIGEgSFcgYXV4aWxpYXJ5IGFwcHJvYWNoIHRvIGxvZyBkaXJ0eS4gTU1VIGNoYWdlcyBQVEUg
dG8gYmUgd3JpdGFibGUgaWYKPiBpdHMgREJNIGJpdCBpcyBzZXQuIFRoZW4gS1ZNIGRvZXNuJ3Qg
b2NjdXB5IHZDUFUgdGltZSB0byBsb2cgZGlydHkuCj4gCj4gQWJvdXQgdGhpcyBwYXRjaCBzZXJp
ZXM6Cj4gCj4gVGhlIGJpZ2dlc3QgcHJvYmxlbSBvZiBhcHBseSBEQk0gZm9yIHN0YWdlMiBpcyB0
aGF0IHNvZnR3YXJlIG11c3Qgc2NhbiBQVHMgdG8KPiBjb2xsZWN0IGRpcnR5IHN0YXRlLCB3aGlj
aCBtYXkgY29zdCBtdWNoIHRpbWUgYW5kIGFmZmVjdCBkb3dudGltZSBvZiBtaWdyYXRpb24uCj4g
Cj4gVGhpcyBzZXJpZXMgcmVhbGl6ZSBhIFNXL0hXIGNvbWJpbmVkIGRpcnR5IGxvZyB0aGF0IGNh
biBlZmZlY3RpdmVseSBzb2x2ZSB0aGlzCj4gcHJvYmxlbSAoVGhlIHNtbXUgc2lkZSBjYW4gYWxz
byB1c2UgdGhpcyBhcHByb2FjaCB0byBzb2x2ZSBkbWEgZGlydHkgbG9nIHRyYWNraW5nKS4KPiAK
PiBUaGUgY29yZSBpZGVhIGlzIHRoYXQgd2UgZG8gbm90IGVuYWJsZSBoYXJkd2FyZSBkaXJ0eSBh
dCBzdGFydCAoZG8gbm90IGFkZCBEQk0gYml0KS4KPiBXaGVuIGEgYXJiaXRyYXJ5IFBUIG9jY3Vy
cyBmYXVsdCwgd2UgZXhlY3V0ZSBzb2Z0IHRyYWNraW5nIGZvciB0aGlzIFBUIGFuZCBlbmFibGUK
PiBoYXJkd2FyZSB0cmFja2luZyBmb3IgaXRzICpuZWFyYnkqIFBUcyAoZS5nLiBBZGQgREJNIGJp
dCBmb3IgbmVhcmJ5IDE2UFRzKS4gVGhlbiB3aGVuCj4gc3luYyBkaXJ0eSBsb2csIHdlIGhhdmUg
a25vd24gYWxsIFBUcyB3aXRoIGhhcmR3YXJlIGRpcnR5IGVuYWJsZWQsIHNvIHdlIGRvIG5vdCBu
ZWVkCj4gdG8gc2NhbiBhbGwgUFRzLgo+IAo+ICAgICAgICAgbWVtIGFib3J0IHBvaW50ICAgICAg
ICAgICAgIG1lbSBhYm9ydCBwb2ludAo+ICAgICAgICAgICAgICAg4oaTICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIOKGkwo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgICAgICAgfCoqKioqKioqfCAgICAgICAgfCAg
ICAgICAgfCoqKioqKioqfCAgICAgICAgfCAgICAgICAgfAo+IC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgICAgICAgICAg
ICDihpEgICAgICAgICAgICAgICAgICAgICAgICAgICAg4oaRCj4gICAgICAgICBzZXQgREJNIGJp
dCBvZiAgICAgICAgICAgICAgIHNldCBEQk0gYml0IG9mCj4gICAgICB0aGlzIFBUIHNlY3Rpb24g
KDY0UFRFcykgICAgICB0aGlzIFBUIHNlY3Rpb24gKDY0UFRFcykKPiAKPiBXZSBtYXkgd29ycnkg
dGhhdCB3aGVuIGRpcnR5IHJhdGUgaXMgb3Zlci1oaWdoIHdlIHN0aWxsIG5lZWQgdG8gc2NhbiB0
b28gbXVjaCBQVHMuCj4gV2UgbWFpbmx5IGNvbmNlcm4gdGhlIFZNIHN0b3AgdGltZS4gV2l0aCBR
ZW11IGRpcnR5IHJhdGUgdGhyb3R0bGluZywgdGhlIGRpcnR5IG1lbW9yeQo+IGlzIGNsb3Npbmcg
dG8gdGhlIFZNIHN0b3AgdGhyZXNob2xkLCBzbyB0aGVyZSBpcyBhIGxpdHRsZSBQVHMgdG8gc2Nh
biBhZnRlciBWTSBzdG9wLgo+IAo+IEl0IGhhcyB0aGUgYWR2YW50YWdlcyBvZiBoYXJkd2FyZSB0
cmFja2luZyB0aGF0IG1pbmltaXplcyBzaWRlIGVmZmVjdCBvbiB2Q1BVLAo+IGFuZCBhbHNvIGhh
cyB0aGUgYWR2YW50YWdlcyBvZiBzb2Z0d2FyZSB0cmFja2luZyB0aGF0IGNvbnRyb2xzIHZDUFUg
ZGlydHkgcmF0ZS4KPiBNb3Jlb3Zlciwgc29mdHdhcmUgdHJhY2tpbmcgaGVscHMgdXMgdG8gc2Nh
biBQVHMgYXQgc29tZSBmaXhlZCBwb2ludHMsIHdoaWNoCj4gZ3JlYXRseSByZWR1Y2VzIHNjYW5u
aW5nIHRpbWUuIEFuZCB0aGUgYmlnZ2VzdCBiZW5lZml0IGlzIHRoYXQgd2UgY2FuIGFwcGx5IHRo
aXMKPiBzb2x1dGlvbiBmb3IgZG1hIGRpcnR5IHRyYWNraW5nLgo+IAo+IFRlc3Q6Cj4gCj4gSG9z
dDogS3VucGVuZyA5MjAgd2l0aCAxMjggQ1BVIDUxMkcgUkFNLiBEaXNhYmxlIFRyYW5zcGFyZW50
IEh1Z2VwYWdlIChFbnN1cmUgdGVzdCByZXN1bHQKPiAgICAgICBpcyBub3QgZWZmZWN0ZWQgYnkg
ZGlzc29sdmUgb2YgYmxvY2sgcGFnZSB0YWJsZSBhdCB0aGUgZWFybHkgc3RhZ2Ugb2YgbWlncmF0
aW9uKS4KPiBWTTogICAxNiBDUFUgMTZHQiBSQU0uIFJ1biA0IHBhaXIgb2YgKHJlZGlzX2JlbmNo
bWFyaytyZWRpc19zZXJ2ZXIpLgo+IAo+IEVhY2ggcnVuIDUgdGltZXMgZm9yIHNvZnR3YXJlIGRp
cnR5IGxvZyBhbmQgU1cvSFcgY29uYmluZWQgZGlydHkgbG9nLiAKPiAKPiBUZXN0IHJlc3VsdDoK
PiAKPiBHYWluIDUlfjclIGltcHJvdmVtZW50IG9mIHJlZGlzIFFQUyBkdXJpbmcgVk0gbWlncmF0
aW9uLgo+IFZNIGRvd250aW1lIGlzIG5vdCBhZmZlY3RlZCBmdW5kYW1lbnRhbGx5Lgo+IEFib3V0
IDU2LjclIG9mIERCTSBpcyBlZmZlY3RpdmVseSB1c2VkLgo+IAo+IEtlcWlhbiBaaHUgKDcpOgo+
ICAgYXJtNjQ6IGNwdWZlYXR1cmU6IEFkZCBBUEkgdG8gcmVwb3J0IHN5c3RlbSBzdXBwb3J0IG9m
IEhXREJNCj4gICBrdm06IGFybTY0OiBVc2UgYXRvbWljIG9wZXJhdGlvbiB3aGVuIHVwZGF0ZSBQ
VEUKPiAgIGt2bTogYXJtNjQ6IEFkZCBsZXZlbF9hcHBseSBwYXJhbWV0ZXIgZm9yIHN0YWdlMl9h
dHRyX3dhbGtlcgo+ICAga3ZtOiBhcm02NDogQWRkIHNvbWUgSFdfREJNIHJlbGF0ZWQgcGd0YWJs
ZSBpbnRlcmZhY2VzCj4gICBrdm06IGFybTY0OiBBZGQgc29tZSBIV19EQk0gcmVsYXRlZCBtbXUg
aW50ZXJmYWNlcwo+ICAga3ZtOiBhcm02NDogT25seSB3cml0ZSBwcm90ZWN0IHNlbGVjdGVkIFBU
RQo+ICAga3ZtOiBhcm02NDogU3RhcnQgdXAgU1cvSFcgY29tYmluZWQgZGlydHkgbG9nCj4gCj4g
IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oICB8ICAxMiArKysKPiAgYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgIHwgICA2ICsrCj4gIGFyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX21tdS5oICAgICB8ICAgNyArKwo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9wZ3RhYmxlLmggfCAgNDUgKysrKysrKysrKwo+ICBhcmNoL2FybTY0L2t2bS9hcm0uYyAg
ICAgICAgICAgICAgICAgfCAxMjUgKysrKysrKysrKysrKysrKysrKysrKysrKysKPiAgYXJjaC9h
cm02NC9rdm0vaHlwL3BndGFibGUuYyAgICAgICAgIHwgMTMwICsrKysrKysrKysrKysrKysrKysr
KystLS0tLQo+ICBhcmNoL2FybTY0L2t2bS9tbXUuYyAgICAgICAgICAgICAgICAgfCAgNDcgKysr
KysrKysrLQo+ICBhcmNoL2FybTY0L2t2bS9yZXNldC5jICAgICAgICAgICAgICAgfCAgIDggKy0K
PiAgOCBmaWxlcyBjaGFuZ2VkLCAzNTEgaW5zZXJ0aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pCj4g
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
