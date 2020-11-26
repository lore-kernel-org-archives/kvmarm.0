Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E560C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 02:31:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AEBF20770
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 02:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AEBF20770
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CFE4B758;
	Wed, 25 Nov 2020 21:31:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MOC+rF63M1DX; Wed, 25 Nov 2020 21:31:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE8134B748;
	Wed, 25 Nov 2020 21:31:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 421E04B72A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 21:31:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vkKzJVwXnrvF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 21:31:17 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 084714B727
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 21:31:16 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ChMF76C50z15R84;
 Thu, 26 Nov 2020 10:30:51 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 10:31:04 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
To: Marc Zyngier <maz@kernel.org>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
 <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
 <10463cb9a0ae167a89300185c1de348c@kernel.org>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <b084262b-5563-2d80-3065-cf563d978ea3@huawei.com>
Date: Thu, 26 Nov 2020 10:31:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <10463cb9a0ae167a89300185c1de348c@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, fanhenglong@huawei.com,
 prime.zeng@hisilicon.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyY++8jAoKSSB3aWxsIGNvbnNpZGVyIG1vcmUgY2lyY3Vtc3RhbmNlcyBpbiB0aGUgbGF0
ZXIgdGVzdC4gVGhhbmtzIGZvciB0aGUKYWR2aWNlLgoKVGhhbmtzLApKaW5neWkKCgpPbiAxMS8y
NC8yMDIwIDc6MDIgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIwLTExLTEzIDA3OjU0
LCBKaW5neWkgV2FuZyB3cm90ZToKPj4gSGkgYWxs77yMCj4+Cj4+IFNvcnJ5IGZvciB0aGUgZGVs
YXkuIEkgaGF2ZSBiZWVuIHRlc3RpbmcgdGhlIFRXRUQgZmVhdHVyZSBwZXJmb3JtYW5jZQo+PiBs
YXRlbHkuIFdlIHNlbGVjdCB1bml4YmVuY2ggYXMgdGhlIGJlbmNobWFyayBmb3Igc29tZSBpdGVt
cyBvZiBpdCBpcwo+PiBsb2NrLWludGVuc2l2ZShmc3RpbWUvZnNidWZmZXIvZnNkaXNrKS4gV2Ug
cnVuIHVuaXhiZW5jaCBvbiBhIDQtVkNQVQo+PiBWTSwgYW5kIGJpbmQgZXZlcnkgdHdvIFZDUFVz
IG9uIG9uZSBQQ1BVLiBGaXhlZCBUV0VEIHZhbHVlIGlzIHVzZWQgYW5kCj4+IGhlcmUgaXMgdGhl
IHJlc3VsdC4KPiAKPiBIb3cgcmVwcmVzZW50YXRpdmUgaXMgdGhpcz8KPiAKPiBUQkgsIEkgb25s
eSBrbm93IG9mIHR3byByZWFsIHdvcmxkIGNvbmZpZ3VyYXRpb25zOiBvbmUgd2hlcmUKPiB0aGUg
dkNQVXMgYXJlIHBpbm5lZCB0byBkaWZmZXJlbnQgcGh5c2ljYWwgQ1BVcyAoYW5kIGluIHRoaXMK
PiBjYXNlIHlvdXIgcGF0Y2ggaGFzIGFic29sdXRlbHkgbm8gZWZmZWN0IGFzIGxvbmcgYXMgdGhl
cmUgaXMKPiBubyBjb25jdXJyZW50IHRhc2tzKSwgYW5kIG9uZSB3aGVyZSB0aGVyZSBpcyBvdmVy
c3Vic2NyaXB0aW9uLAo+IGFuZCB0aGUgc2NoZWR1bGVyIG1vdmVzIHRoaW5ncyBhcm91bmQgYXMg
aXQgc2VlcyBmaXQsIGRlcGVuZGluZwo+IG9uIHRoZSBsb2FkLgo+IAo+IEhhdmluZyB0d28gdkNQ
VXMgcGlubmVkIHBlciBDUFUgZmVlbHMgbGlrZSBhIHRlc3QgdGhhdCBoYXMgYmVlbgo+IHBpY2tl
ZCB0byBnaXZlIHRoZSByZXN1bHQgeW91IHdhbnRlZC4gSSdkIGxpa2UgdG8gc2VlIHRoZSBmdWxs
Cj4gcGljdHVyZSwgaW5jbHVkaW5nIHRoZSBjYXNlIHRoYXQgbWF0dGVycyBmb3IgY3VycmVudCB1
c2UgY2FzZXMuCj4gSSdtIHNwZWNpYWxseSBpbnRlcmVzdGVkIGluIHRoZSBjYXNlcyB3aGVyZSB0
aGUgc3lzdGVtIGlzCj4gb3ZlcnN1YnNjcmliZWQsIGJlY2F1c2UgVFdFRCBpcyBkZWZpbml0ZWx5
IGdvaW5nIHRvIHNjcmV3IHdpdGgKPiB0aGUgc2NoZWR1bGVyIGxhdGVuY3kuCj4gCj4gVGhhbmtz
LAo+IAo+ICDCoMKgwqDCoMKgwqDCoCBNLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
