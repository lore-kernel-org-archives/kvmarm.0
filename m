Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75069C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 12:16:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6E50206A2
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 12:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6E50206A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8F24B2DE;
	Fri,  5 Jun 2020 08:15:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PZ77ZISBkN0V; Fri,  5 Jun 2020 08:15:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BD04B2E2;
	Fri,  5 Jun 2020 08:15:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DCE44B2D9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 08:15:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K5LwapGVwPsV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 08:15:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4133C4B1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 08:15:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92D9E2B;
 Fri,  5 Jun 2020 05:15:54 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C211A3F305;
 Fri,  5 Jun 2020 05:15:53 -0700 (PDT)
Subject: Re: [kvmtool][PATCH] arm64: Obtain text offset from kernel image
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20200605104907.1307967-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e9045c9e-f1c1-a6aa-9a19-37dc7ea02038@arm.com>
Date: Fri, 5 Jun 2020 13:16:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200605104907.1307967-1-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

SGkgTWFyYywKCk9uIDYvNS8yMCAxMTo0OSBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IFJlY2Vu
dCBjaGFuZ2VzIG1hZGUgdG8gTGludXggNS44IGhhdmUgb3V0bGluZWQgdGhhdCBrdm10b29sCj4g
aGFyZGNvZGVzIHRoZSB0ZXh0IG9mZnNldCBpbnN0ZWFkIG9mIHJlYWRpbmcgaXQgZnJvbSB0aGUg
YXJtNjQKPiBpbWFnZSBpdHNlbGYuCj4KPiBUbyBhZGRyZXNzIHRoaXMsIGltcG9ydCB0aGUgaW1h
Z2UgaGVhZGVyIHN0cnVjdHVyZSBpbnRvIGt2bXRvb2wKPiBhbmQgZG8gdGhlIHJpZ2h0IHRoaW5n
LiAzMmJpdCBndWVzdHMgYXJlIHN0aWxsIGxvYWRlZCB0byB0aGVpcgo+IHVzdWFsIGxvY2F0aW9u
cy4KPgo+IFJlcG9ydGVkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPgo+IFNp
Z25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4gLS0tCj4gIE1ha2Vm
aWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSArCj4gIGFybS9hYXJjaDMyL2luY2x1
ZGUva3ZtL2t2bS1hcmNoLmggfCAgMiArLQo+ICBhcm0vYWFyY2g2NC9pbmNsdWRlL2FzbS9pbWFn
ZS5oICAgIHwgNTkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIGFybS9hYXJjaDY0
L2luY2x1ZGUva3ZtL2t2bS1hcmNoLmggfCAgNSArLS0KPiAgYXJtL2FhcmNoNjQva3ZtLmMgICAg
ICAgICAgICAgICAgICB8IDMwICsrKysrKysrKysrKysrKwo+ICBhcm0va3ZtLmMgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgNiBmaWxlcyBjaGFuZ2VkLCA5NCBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJtL2FhcmNoNjQvaW5j
bHVkZS9hc20vaW1hZ2UuaAo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJtL2FhcmNoNjQva3ZtLmMK
Pgo+IFsuLl0KClRoaXMgaXMgYSBncmVhdCBhZGRpdGlvbiB0byBrdm10b29sLCB0aGFuayB5b3Uh
IEJlZm9yZSBJIGRvIGEgbW9yZSBpbi1kZXB0aApyZXZpZXcsIEkgaGF2ZSBzb21lIGdlbmVyYWwg
cXVlc3Rpb25zLgoKUmVnYXJkaW5nIHRoZSBhY3R1YWwgdmFsdWUgb2YgdGV4dF9vZmZzZXQsIHRo
ZSBib290aW5nLnJzdCBkb2N1bWVudCBzYXlzOgoKIlByaW9yIHRvIHYzLjE3LCB0aGUgZW5kaWFu
bmVzcyBvZiB0ZXh0X29mZnNldCB3YXMgbm90IHNwZWNpZmllZC7CoCBJbiB0aGVzZSBjYXNlcwpp
bWFnZV9zaXplIGlzIHplcm8gYW5kIHRleHRfb2Zmc2V0IGlzIDB4ODAwMDAgaW4gdGhlIGVuZGlh
bm5lc3Mgb2YgdGhlIGtlcm5lbC7CoApXaGVyZSBpbWFnZV9zaXplIGlzIG5vbi16ZXJvIGltYWdl
X3NpemUgaXMgbGl0dGxlLWVuZGlhbiBhbmQgbXVzdCBiZSByZXNwZWN0ZWQuwqAKV2hlcmUgaW1h
Z2Vfc2l6ZSBpcyB6ZXJvLCB0ZXh0X29mZnNldCBjYW4gYmUgYXNzdW1lZCB0byBiZSAweDgwMDAw
Ii4KCkFsbCBoZWFkZXIgZmllbGRzIGFyZSBkZWNsYXJlZCBsaXR0bGUtZW5kaWFuLCB3aGljaCBs
b29rcyB0byBtZSBsaWtlIGl0IHdvdWxkCmJyZWFrIGtlcm5lbHMgb2xkZXIgdGhhbiAzLjE3LiBJ
ZiB0aGF0IHdhcyBpbnRlbnRpb25hbCwgSSB0aGluayBpdCdzIHdvcnRoCmRvY3VtZW50aW5nIHNv
bWV3aGVyZSwgb3IgYXQgbGVhc3QgYSBjb21tZW50IGZvciB0aGUga3ZtX19hcmNoX2dldF9rZXJu
X29mZnNldApmdW5jdGlvbi4KCk5vdyB0aGF0IHdlIGFyZSBwYXJzaW5nIHRoZSBrZXJuZWwgaGVh
ZGVyLCBoYXZlIHlvdSBjb25zaWRlcmVkIGNoZWNraW5nIHRoZSBtYWdpYwpudW1iZXIgdG8gbWFr
ZSBzdXJlIHRoZSB1c2VyIHNwZWNpZmllZCBhIHZhbGlkIGtlcm5lbCBpbWFnZT8gSXQgbWlnaHQg
c2F2ZSBzb21lb25lCnNvbWUgdGltZSBkZWJ1Z2dpbmcgd2h5IHRoZSBrZXJuZWwgaXNuJ3QgYm9v
dGluZywgaWYsIGZvciBleGFtcGxlLCB0aGV5IGFyZQpib290aW5nIGFuIGFybXY3IGtlcm5lbCwg
YnV0IHRoZXkgZm9yZ290IHRvIHNwZWNpZnkgLS1hYXJjaDMyLgoKVGhhbmtzLApBbGV4Cl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
