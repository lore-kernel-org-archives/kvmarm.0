Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D49C2D0ED
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 12:21:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32B0420714
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 12:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32B0420714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7268A4B1D3;
	Mon, 30 Mar 2020 08:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r6zSKd4tvpls; Mon, 30 Mar 2020 08:21:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419354B1D4;
	Mon, 30 Mar 2020 08:21:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB584B1CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 08:21:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1974y26mAQGp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 08:21:09 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4C934B1BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 08:21:08 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 4EDC38D557AA0DF61F53;
 Mon, 30 Mar 2020 20:21:05 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 20:20:58 +0800
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To: Andrew Jones <drjones@redhat.com>, Auger Eric <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
 <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9f3951c9-8ff6-531f-e9a5-abafdab5fef8@huawei.com>
Date: Mon, 30 Mar 2020 20:20:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: thuth@redhat.com, kvm@vger.kernel.org, andre.przywara@arm.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgRHJldywKCk9uIDIwMjAvMy8zMCAxNzoxMSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IE9uIE1v
biwgTWFyIDMwLCAyMDIwIGF0IDEwOjQ2OjU3QU0gKzAyMDAsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+
IEhpIFplbmdodWksCj4+Cj4+IE9uIDMvMzAvMjAgMTA6MzAgQU0sIFplbmdodWkgWXUgd3JvdGU6
CgpbLi4uXQoKPj4+IE90aGVyd2lzZSBJIHRoaW5rIHdlIHdpbGwgZW5kLXVwIHdpdGggbWVtb3J5
IGNvcnJ1cHRpb24gd2hlbiB3cml0aW5nCj4+PiB0aGUgY29tbWFuZCBxdWV1ZS7CoCBCdXQgaXQg
c2VlbXMgdGhhdCBldmVyeXRoaW5nIGp1c3Qgd29ya3MgZmluZSAuLi4KPj4+IFNvIEknbSByZWFs
bHkgY29uZnVzZWQgaGVyZSA6LS8KPj4gSSB3YXMgdG9sZCBieSBQYW9sbyB0aGF0IHRoZSBWQS9Q
QSBtZW1vcnkgbWFwIGlzIGZsYXQgaW4ga3ZtdW5pdCB0ZXN0Lgo+IAo+IFdoYXQgZG9lcyBmbGF0
IG1lYW4/IGt2bS11bml0LXRlc3RzLCBhdCBsZWFzdCBhcm0vYXJtNjQsIGRvZXMgcHJlcGFyZQo+
IGFuIGlkZW50aXR5IG1hcCBvZiBhbGwgcGh5c2ljYWwgbWVtb3J5LCB3aGljaCBleHBsYWlucyB3
aHkgdGhlIGFib3ZlCj4gaXMgd29ya2luZy4gSXQncyBkb2luZyB2aXJ0X3RvX3BoeXMoc29tZS12
aXJ0LWFkZHIpLCB3aGljaCBnZXRzIGEKPiBwaHlzIGFkZHIsIGJ1dCB3aGVuIHRoZSBJVFMgdXNl
cyBpdCBhcyBhIHZpcnQgYWRkciBpdCB3b3JrcyBiZWNhdXNlCj4gd2UgKmFsc28qIGhhdmUgYSB2
aXJ0IGFkZHIgPT0gcGh5cyBhZGRyIG1hcHBpbmcgaW4gdGhlIGRlZmF1bHQgcGFnZQo+IHRhYmxl
LCB3aGljaCBpcyBuYW1lZCAiaWRtYXAiIGZvciBnb29kIHJlYXNvbi4KClRoYW5rcyBmb3IgdGhl
IGV4cGxhbmF0aW9uIDotKS4gSSB3aWxsIGhhdmUgYSBsb29rIGF0IHRoZSBhcm0vYXJtNjQgbW0K
Y29kZSB0byBsZWFybiBpdC4KCgpUaGFua3MsClplbmdodWkKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
