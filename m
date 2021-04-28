Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68790C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 05:59:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD1766141F
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 05:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD1766141F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2E74B205;
	Wed, 28 Apr 2021 01:59:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BviRtnxrcsyb; Wed, 28 Apr 2021 01:59:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B13E4B208;
	Wed, 28 Apr 2021 01:59:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968DC4B206
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 01:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aCHVwYB0k8ch for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 01:59:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A75E94B205
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 01:59:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6570261418;
 Wed, 28 Apr 2021 05:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619589590;
 bh=FgrS4XUHz0O6Fa4p86bx504/a38cD5C/C9ebOq8CMgE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kxQO8XXtHgJ92g69cQtUE/ztppXG10NjcTg3AAVJeNGHFfHBIwaxtHqYm4HKtsOM8
 4pSH5hGTD/9dj+8+vp8XTh4poyGEKzDLbHfyz/p+fkTYk5UbI7PvZTP0EBlYgRcDBt
 /UDubaGboihUuxJZ1iP9B6sJRYsCqp62pwxj1WOiQZr6AQIXrzuCoeW+b3lhv2xDNN
 SwA6SCvteDVDkn4bMSCBOJLV9ILEVFDAzMKmVvjSB+LjAS1Zh6xwmAuOxr+nuYUIDO
 hivwDhPoKspBevnIwMGctMyL5ixCSC4HKCbNvK1zsCWv9dkrAhxTjUQvkAJ6nuZtK0
 Yj87vphXjtkmg==
Date: Wed, 28 Apr 2021 08:59:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YIj5zcbHBHt7CC8B@kernel.org>
References: <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
 <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVHVlLCBBcHIgMjcsIDIwMjEgYXQgMDc6MDg6NTlQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS80LzI3IDE0OjIzLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+ID4gT24g
TW9uLCBBcHIgMjYsIDIwMjEgYXQgMTE6MjY6MzhQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6
Cj4gPiA+IE9uIDIwMjEvNC8yNiAxMzoyMCwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiA+ID4gPiBP
biBTdW4sIEFwciAyNSwgMjAyMSBhdCAwMzo1MTo1NlBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90
ZToKPiA+ID4gPiA+IE9uIDIwMjEvNC8yNSAxNToxOSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiA+
ID4gPiA+IAo+ID4gPiA+ID4gICAgICAgT24gRnJpLCBBcHIgMjMsIDIwMjEgYXQgMDQ6MTE6MTZQ
TSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6Cj4gPiA+ID4gPiAKPiA+ID4gPiA+ICAgICAgICAg
ICBJIHRlc3RlZCB0aGlzIHBhdGNoc2V0KHBsdXMgYXJtMzIgY2hhbmdlLCBsaWtlIGFybTY0IGRv
ZXMpCj4gPiA+ID4gPiAgICAgICAgICAgYmFzZWQgb24gbHRzIDUuMTDvvIxhZGQgc29tZSBkZWJ1
ZyBsb2csIHRoZSB1c2VmdWwgaW5mbyBzaG93cwo+ID4gPiA+ID4gICAgICAgICAgIGJlbG93LCBp
ZiB3ZSBlbmFibGUgSE9MRVNfSU5fWk9ORSwgbm8gcGFuaWMsIGFueSBpZGVhLAo+ID4gPiA+ID4g
ICAgICAgICAgIHRoYW5rcy4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gICAgICAgQXJlIHRoZXJlIGFu
eSBjaGFuZ2VzIG9uIHRvcCBvZiA1LjEwIGV4Y2VwdCBmb3IgcGZuX3ZhbGlkKCkgcGF0Y2g/Cj4g
PiA+ID4gPiAgICAgICBEbyB5b3Ugc2VlIHRoaXMgcGFuaWMgb24gNS4xMCB3aXRob3V0IHRoZSBj
aGFuZ2VzPwo+ID4gPiA+ID4gCj4gPiA+ID4gPiBZZXMsIHRoZXJlIGFyZSBzb21lIEJTUCBzdXBw
b3J0IGZvciBhcm0gYm9hcmQgYmFzZWQgb24gNS4xMCwKPiA+IElzIGl0IHBvc3NpYmxlIHRvIHRl
c3QgNS4xMj8KCkRvIHlvdSB1c2UgU1BBUlNNRU0/IElmIHllcywgd2hhdCBpcyB5b3VyIHNlY3Rp
b24gc2l6ZT8KV2hhdCBpcyB0aGUgdmFsdWUgaWYgQ09ORklHX0ZPUkNFX01BWF9aT05FT1JERVIg
aW4geW91ciBjb25maWd1cmF0aW9uPwoKLS0gClNpbmNlcmVseSB5b3VycywKTWlrZS4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
