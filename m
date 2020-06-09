Return-Path: <SRS0=btD/=7W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B73C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 10:08:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38F0B2078D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 10:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F0B2078D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 757C94B3B2;
	Tue,  9 Jun 2020 06:08:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o87IE0AiQ2+H; Tue,  9 Jun 2020 06:08:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B39A4B3DB;
	Tue,  9 Jun 2020 06:08:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDE34B3B6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 06:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DwsZqF+i+Cns for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 06:08:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0025C4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 06:08:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEBAD1FB;
 Tue,  9 Jun 2020 03:08:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F08C93F73D;
 Tue,  9 Jun 2020 03:08:02 -0700 (PDT)
Subject: Re: [kvmtool][PATCH v2] arm64: Obtain text offset from kernel image
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20200608152801.1415902-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4aa35134-d2b6-9db7-9299-d866d4693a95@arm.com>
Date: Tue, 9 Jun 2020 11:08:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200608152801.1415902-1-maz@kernel.org>
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

SGksCgpPbiA2LzgvMjAgNDoyOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IFJlY2VudCBjaGFu
Z2VzIG1hZGUgdG8gTGludXggNS44IGhhdmUgb3V0bGluZWQgdGhhdCBrdm10b29sCj4gaGFyZGNv
ZGVzIHRoZSB0ZXh0IG9mZnNldCBpbnN0ZWFkIG9mIHJlYWRpbmcgaXQgZnJvbSB0aGUgYXJtNjQK
PiBpbWFnZSBpdHNlbGYuCj4KPiBUbyBhZGRyZXNzIHRoaXMsIGltcG9ydCB0aGUgaW1hZ2UgaGVh
ZGVyIHN0cnVjdHVyZSBpbnRvIGt2bXRvb2wKPiBhbmQgZG8gdGhlIHJpZ2h0IHRoaW5nLiAzMmJp
dCBndWVzdHMgYXJlIHN0aWxsIGxvYWRlZCB0byB0aGVpcgo+IHVzdWFsIGxvY2F0aW9ucy4KPgo+
IFdoaWxlIHdlJ3JlIGF0IGl0LCBjaGVjayB0aGUgaW1hZ2UgbWFnaWMgYW5kIGRlZmF1bHQgdG8g
dGhlIHRleHQKPiBvZmZzZXQgdG8gYmUgMHg4MDAwMCB3aGVuIGltYWdlX3NpemUgaXMgMCwgYXMg
ZGVzY3JpYmVkIGluIHRoZQo+IGtlcm5lbCdzIGJvb3RpbmcucnN0IGRvY3VtZW50Lgo+Cj4gQ2M6
IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4KPiBSZXBvcnRlZC1i
eTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4KPiBTaWduZWQtb2ZmLWJ5OiBNYXJj
IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+IC0tLQo+Cj4gTm90ZXM6Cj4gICAgIHYyOiBDaGVj
ayBtYWdpYywgYXNzdW1lIG9mZnNldCB0byBiZSAweDgwMDAgaWYgaW1hZ2Vfc2l6ZSBpcyAwLgo+
Cj4gWy4uXQoKSSB3YW50ZWQgdG8gcmV2aWV3IHRoZSBwYXRjaCwgYnV0IHRoZW4gSSBub3RpY2Vk
IHRoYXQgV2lsbCBtZXJnZWQgaXQuIFNvIEkgc2V0dGxlZApmb3IgdGVzdGluZyBpdCwgdG8gbWFr
ZSBzdXJlIG5vdGhpbmcgYnJlYWtzLiBJIHdhcyBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUK
cmVwb3J0ZWQgb24gdGhlIG1haWxpbmcgbGlzdCAtIHdpdGhvdXQgdGhpcyBwYXRjaCwgd2hlbiB0
aGUga2VybmVsIGlzIGNvbXBpbGVkCndpdGggQ09ORklHX1JBTkRPTUlaRV9CQVNFIG5vdCBzZXQs
IHRoZSBrZXJuZWwgZG9lc24ndCBib290OyB3aXRoIHRoaXMgcGF0Y2gKYXBwbGllZCwgdGhlIHNh
bWUga2VybmVsIGJvb3RzIHN1Y2Nlc3NmdWxseS4KCkkgYWxzbyB0ZXN0ZWQgaXQgd2l0aCBhbiBh
YXJjaDMyIGtlcm5lbCwgdGhpcyBpcyB3aGF0IEkgZ290OgoKJCB0YXNrc2V0IC1jIDQsNSAuL2xr
dm0gcnVuIC1jMiAtbTEwMjQgLWsgLi4va3ZtdG9vbC12bXMvekltYWdlIC1kCi4uL2t2bXRvb2wt
dm1zL2RlYmlhbi0xMC4zLjAuaW1nwqAgLXAgJ2Vhcmx5Y29uIHJvb3Q9L2Rldi92ZGEyJwrCoCAj
IGxrdm0gcnVuIC1rIC4uL2t2bXRvb2wtdm1zL3pJbWFnZSAtbSAxMDI0IC1jIDIgLS1uYW1lIGd1
ZXN0LTE4MzQKwqAgV2FybmluZzogS2VybmVsIGltYWdlIG1hZ2ljIG5vdCBtYXRjaGluZwrCoCBX
YXJuaW5nOiB1bmFibGUgdG8gdHJhbnNsYXRlIGhvc3QgYWRkcmVzcyAweDEzMTE1YTRjODJkMDVh
NGQgdG8gZ3Vlc3QKwqAgRmF0YWw6IGtlcm5lbCBpbWFnZSB0b28gYmlnIHRvIGNvbnRhaW4gaW4g
Z3Vlc3QgbWVtb3J5LgoKSU1PLCB3b3JrcyBhcyBleHBlY3RlZC4KClRoYW5rcywKQWxleApfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
