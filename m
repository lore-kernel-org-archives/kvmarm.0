Return-Path: <SRS0=4dlz=WB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F1C0650F
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:06:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D127214C6
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:06:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D127214C6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315BE4A4FC;
	Mon,  5 Aug 2019 09:06:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vH1tTj2ZmxF7; Mon,  5 Aug 2019 09:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA494A539;
	Mon,  5 Aug 2019 09:06:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97BAD4A51F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fiauj8+n05sZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Aug 2019 09:06:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 429B04A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:06:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E280D337;
 Mon,  5 Aug 2019 06:06:08 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FEBA3F77D;
 Mon,  5 Aug 2019 06:06:07 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com>
 <3bdd764a-b6f5-d17e-a703-d8eb13838efc@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <fd8b0c8d-79d1-1501-cee0-d3f6bc1c3487@arm.com>
Date: Mon, 5 Aug 2019 14:06:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3bdd764a-b6f5-d17e-a703-d8eb13838efc@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

T24gMDUvMDgvMjAxOSAwNDoyMywgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBTdGV2ZW4sCj4gCj4g
T24gMjAxOS84LzIgMjI6NTAsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4gSW50cm9kdWNlIGEgcGFy
YXZpcnR1YWxpemF0aW9uIGludGVyZmFjZSBmb3IgS1ZNL2FybTY0IGJhc2VkIG9uIHRoZQo+PiAi
QXJtIFBhcmF2aXJ0dWFsaXplZCBUaW1lIGZvciBBcm0tQmFzZSBTeXN0ZW1zIiBzcGVjaWZpY2F0
aW9uIERFTiAwMDU3QS4KPj4KPj4gVGhpcyBvbmx5IGFkZHMgdGhlIGRldGFpbHMgYWJvdXQgIlN0
b2xlbiBUaW1lIiBhcyB0aGUgZGV0YWlscyBvZiAiTGl2ZQo+PiBQaHlzaWNhbCBUaW1lIiBoYXZl
IG5vdCBiZWVuIGZ1bGx5IGFncmVlZC4KPj4KPj4gVXNlciBzcGFjZSBjYW4gc3BlY2lmeSBhIHJl
c2VydmVkIGFyZWEgb2YgbWVtb3J5IGZvciB0aGUgZ3Vlc3QgYW5kCj4+IGluZm9ybSBLVk0gdG8g
cG9wdWxhdGUgdGhlIG1lbW9yeSB3aXRoIGluZm9ybWF0aW9uIG9uIHRpbWUgdGhhdCB0aGUgaG9z
dAo+PiBrZXJuZWwgaGFzIHN0b2xlbiBmcm9tIHRoZSBndWVzdC4KPj4KPj4gQSBoeXBlcmNhbGwg
aW50ZXJmYWNlIGlzIHByb3ZpZGVkIGZvciB0aGUgZ3Vlc3QgdG8gaW50ZXJyb2dhdGUgdGhlCj4+
IGh5cGVydmlzb3IncyBzdXBwb3J0IGZvciB0aGlzIGludGVyZmFjZSBhbmQgdGhlIGxvY2F0aW9u
IG9mIHRoZSBzaGFyZWQKPj4gbWVtb3J5IHN0cnVjdHVyZXMuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6
IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+Cj4+IC0tLQo+PiDCoCBEb2N1bWVu
dGF0aW9uL3ZpcnR1YWwva3ZtL2FybS9wdnRpbWUudHh0IHwgMTA3ICsrKysrKysrKysrKysrKysr
KysrKysrCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAxMDcgaW5zZXJ0aW9ucygrKQo+PiDCoCBjcmVh
dGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcm0vcHZ0aW1lLnR4dAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgXl5eXl5eXgo+IFRoaXMgZGlyZWN0b3J5IGhhcyBiZWVuIHJlbmFtZWQg
cmVjZW50bHksIHNlZToKPiAKPiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzEx
MzYxMDQvCgpUaGFua3MgZm9yIHBvaW50aW5nIHRoYXQgb3V0IC0gSSdsbCBtb3ZlIGl0IGluIHRo
ZSBuZXh0IHZlcnNpb24uCgpTdGV2ZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
