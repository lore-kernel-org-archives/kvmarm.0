Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C794BC4332D
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:18:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54A742072C
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQ42IIPF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54A742072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C289B4B096;
	Thu, 19 Mar 2020 12:18:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K3faoJQQ2tX8; Thu, 19 Mar 2020 12:18:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C85524A500;
	Thu, 19 Mar 2020 12:18:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE824A4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:18:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lia5czGcZfNs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 12:18:19 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 580334A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:18:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584634699;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TPMaeSZsclHVIbI6q8ygnn5aaACtoMCOfBf0pAjRkic=;
 b=fQ42IIPFDegHTjgyXfJwrjOYr/KyUWvNYq2bCG6dXSl3SZp3BHcvszoWuGpk2qHyIOqEkn
 zPlHj+UTn62kWIbenMt0clvo8rAKjOEPQGSeKfamNEpnctwbZu6Zxuq+sgnpGKAh8dkmm9
 sj/1QXrnJB/qL2M1f27ys27xQAYpF4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-HTtkVwovMASSWR69wcGIBQ-1; Thu, 19 Mar 2020 12:18:17 -0400
X-MC-Unique: HTtkVwovMASSWR69wcGIBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8238B1050920;
 Thu, 19 Mar 2020 16:17:52 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B01975D9CD;
 Thu, 19 Mar 2020 16:17:49 +0000 (UTC)
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <33576d89-2b12-b98b-e392-3342b9b1265c@redhat.com>
 <17921081f98a589c67b37b1d07a9cfcc@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <791e08fc-417c-e956-1a41-0c605f7617b7@redhat.com>
Date: Thu, 19 Mar 2020 17:17:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <17921081f98a589c67b37b1d07a9cfcc@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

SGksCgpPbiAzLzE5LzIwIDU6MTYgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBFcmljLAo+
IAo+IE9uIDIwMjAtMDMtMTkgMTU6NDMsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+IEhpIE1hcmMsCj4+
Cj4+IE9uIDMvMTkvMjAgNDoyMSBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gSGkgRXJpYywK
PiAKPiBbLi4uXQo+IAo+Pj4+IFRoZSBwYXRjaCBsb29rcyBnb29kIHRvIG1lIGJ1dCBJIGFtIG5v
dyBsb3N0IGFib3V0IGhvdyB3ZSByZXRyaWV2ZSB0aGUKPj4+PiBwZW5kaW5nIHN0YXQgb2Ygb3Ro
ZXIgaHcgbWFwcGVkIGludGVycnVwdHMuIExvb2tzIHdlIHVzZQo+Pj4+IGlycS0+cGVuZGluZ19s
YXRjaCBhbHdheXMuIElzIHRoYXQgY29ycmVjdD8KPj4+Cj4+PiBDb3JyZWN0LiBHSUN2NC4wIGRv
ZXNuJ3QgZ2l2ZSB1cyBhbiBhcmNoaXRlY3R1cmFsIHdheSB0byBsb29rIGF0IHRoZQo+Pj4gdkxQ
SSBwZW5kaW5nIHN0YXRlICh0aGVyZSBpc24ndCBldmVuIGEgZ3VhcmFudGVlIGFib3V0IHdoZW4g
dGhlIEdJQwo+Pj4gd2lsbCBzdG9wIHdyaXRpbmcgdG8gbWVtb3J5LCBpZiBpdCBldmVyIGRvZXMp
Lgo+Pj4KPj4+IFdpdGggR0lDdjQuMSwgeW91IGNhbiBpbnRyb3NwZWN0IHRoZSBIVyBzdGF0ZSBm
b3IgU0dJcy4gWW91IGNhbiBhbHNvCj4+PiBsb29rIGF0IHRoZSB2TFBJIHN0YXRlIGJ5IHBlZWtp
bmcgYXQgdGhlIHZpcnR1YWwgcGVuZGluZyB0YWJsZSwgYnV0Cj4+PiB5b3UnZCBuZWVkIHRvIHVu
bWFwIHRoZSBWUEUgZmlyc3QsIHdoaWNoIEkgb2J2aW91c2x5IGRvbid0IHdhbnQgdG8gZG8KPj4+
IGZvciB0aGlzIGRlYnVnIGludGVyZmFjZSwgc3BlY2lhbGx5IGFzIGl0IGNhbiBiZSB1c2VkIHdo
aWxzdCB0aGUgZ3Vlc3QKPj4+IGlzIHVwIGFuZCBydW5uaW5nLgo+PiBPSyBmb3IgdkxQSXMsIHdo
YXQgYWJvdXQgb3RoZXIgSFcgbWFwcGVkIElSUXMgKGFyY2ggdGltZXI/KQo+IAo+IERpZmZlcmVu
dCBraW5kIG9mIEhXLiBXaXRoIHRob3NlLCB0aGUgaW5qZWN0aW9uIGlzIHN0aWxsIHZpcnR1YWws
IHNvIHRoZQo+IFNXIHBlbmRpbmcgYml0IGlzIHN0aWxsIHZlcnkgbXVjaCB2YWxpZC4gWW91IGNh
biBhY3R1YWxseSB0cnkgYW5kIG1ha2UKPiB0aGUgdGltZXIgaW50ZXJydXB0IHBlbmRpbmcsIGl0
IHNob3VsZCBzaG93IHVwLgo+IAo+IFdoYXQgdGhlIGlycS0+aHcgYml0IG1lYW5zIGlzICJ0aGlz
IHZpcnR1YWwgaW50ZXJydXB0IGlzIHNvbWVob3cgcmVsYXRlZAo+IHRvIHRoZSBob3N0X2lycSIu
IEhvdyB0aGlzIGlzIGludGVycHJldGVkIGlzIGNvbXBsZXRlbHkgY29udGV4dC1kZXBlbmRlbnQu
Ck9LIHRoYW5rIHlvdSBmb3IgcmVmcmVzaGluZyBteSBtZW1vcmllcyA7LSkKCkVyaWMKPiAKPiBU
aGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
