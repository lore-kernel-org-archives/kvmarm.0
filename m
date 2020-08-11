Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B33C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 07:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D863020658
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 07:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6JHJtSk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D863020658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 652FF4B47A;
	Tue, 11 Aug 2020 03:49:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NgezjAqk8sdu; Tue, 11 Aug 2020 03:49:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0B84B47C;
	Tue, 11 Aug 2020 03:49:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ACBF4B47A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 03:49:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F+bjGnF1SsLK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2020 03:49:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56E384B477
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 03:49:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 07A87205CB;
 Tue, 11 Aug 2020 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597132150;
 bh=IUPcw48csQBeWPj+tDEVEv+3O8+8xdOT0GWWmV3xhXw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=p6JHJtSkOAuL9lUt8UMmNp2FiD+cO71u9hYD09Cqu9Klj1htM/inD+5+Tfs7CkEUY
 M8QhF+hGH0Y7EnehjjPZMoXWrkLP/77UNyPf1BI75ackInMB3a8SV+XFnriOHZ2aUL
 j5ygXxbHlSJ5/n4+yROoGpqyrrPymoy5wPBXhl8Y=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k5P1w-001EIN-8x; Tue, 11 Aug 2020 08:49:08 +0100
MIME-Version: 1.0
Date: Tue, 11 Aug 2020 08:49:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
In-Reply-To: <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
 wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC0wOC0xMSAwMjo0OCwgSmluZ3lpIFdhbmcgd3JvdGU6Cj4gSGkgTWFyYywKPiAKPiBP
biA4LzUvMjAyMCA4OjEzIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjAtMDgtMDUg
MTI6NTQsIEppbmd5aSBXYW5nIHdyb3RlOgo+Pj4gSGkgYWxsLAo+Pj4gCj4+PiBDdXJyZW50bHks
IGt2bS11bml0LXRlc3RzIG9ubHkgc3VwcG9ydCBHSUN2MyB2TFBJIGluamVjdGlvbi4gTWF5IEkg
Cj4+PiBhc2sKPj4+IGlzIHRoZXJlIGFueSBwbGFuIG9yIHN1Z2dlc3Rpb24gb24gY29uc3RydWN0
aW5nIGlycSBieXBhc3MgbWVjaGFuaXNtCj4+PiB0byB0ZXN0IHZMUEkgZGlyZWN0IGluamVjdGlv
biBpbiBrdm0tdW5pdC10ZXN0cz8KPj4gCj4+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBhcmUgYXNr
aW5nIGZvciBoZXJlLiBWTFBJcyBhcmUgb25seSBkZWxpdmVyZWQKPj4gZnJvbSBhIEhXIGRldmlj
ZSwgYW5kIHRoZSBvZmZsb2FkaW5nIG1lY2hhbmlzbSBpc24ndCB2aXNpYmxlIGZyb20KPj4gdXNl
cnNwYWNlICh5b3UgZWl0aGVyIGhhdmUgYW4gZW5hYmxlZCBHSUN2NCBpbXBsZW1lbnRhdGlvbiwg
b3IKPj4geW91IGRvbid0KS4KPj4gCj4+IFRoZXJlIGFyZSB3YXlzIHRvICp0cmlnZ2VyKiBkZXZp
Y2UgTVNJcyBmcm9tIHVzZXJzcGFjZSBhbmQgaW5qZWN0Cj4+IHRoZW0gaW4gYSBndWVzdCwgYnV0
IHRoYXQncyBvbmx5IGEgZGVidWcgZmVhdHVyZSwgd2hpY2ggc2hvdWxkbid0Cj4+IGJlIGVuYWJs
ZWQgb24gYSBwcm9kdWN0aW9uIHN5c3RlbS4KPj4gCj4+ICDCoMKgwqDCoMKgwqDCoCBNLgo+IAo+
IFNvcnJ5IGZvciB0aGUgbGF0ZSByZXBseS4KPiAKPiBBcyBJIG1lbnRpb25lZCBiZWZvcmUsIHdl
IHdhbnQgdG8gYWRkIHZMUEkgZGlyZWN0IGluamVjdGlvbiB0ZXN0Cj4gaW4gS1VULCBtZWFud2hp
bGUgbWVhc3VyZSB0aGUgbGF0ZW5jeSBvZiBoYXJkd2FyZSB2TFBJIGluamVjdGlvbi4KPiAKPiBT
dXJlLCB2TFBJIGlzIHRyaWdnZXJlZCBieSBoYXJkd2FyZS4gU2luY2Uga2VybmVsIHN1cHBvcnRz
IHNlbmRpbmcKPiBJVFMgSU5UIGNvbW1hbmQgaW4gZ3Vlc3QgdG8gdHJpZ2dlciB2TFBJLCBJIHdv
bmRlciBpZiBpdCBpcyBwb3NzaWJsZQoKU28gY2FuIHRoZSBob3N0LgoKPiB0byBhZGQgYW4gZXh0
cmEgaW50ZXJmYWNlIHRvIG1ha2UgYSB2TFBJIGhhcmR3YXJlLW9mZmxvYWQoanVzdCBhcwo+IGt2
bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKCkgZG9lcykuIElmIHNvLCB2Z2ljX2l0c190cmlnZ2Vy
X21zaSgpCj4gY2FuIGluamVjdCB2TFBJIGRpcmVjdGx5IGluc3RlYWQgb2YgdXNpbmcgTFIuCgpU
aGUgaW50ZXJmYWNlIGV4aXN0cywgaXQgaXMgaW4gZGVidWdmcy4gQnV0IGl0IG1hbmRhdGVzIHRo
YXQgdGhlCmRldmljZSBleGlzdHMuIEFuZCBubywgSSBhbSBub3Qgd2lsbGluZyB0byBhZGQgYW4g
ZXh0cmEgS1ZNIHVzZXJzcGFjZQpBUEkgZm9yIHRoaXMuCgpUaGUgd2hvbGUgY29uY2VwdCBvZiBp
bmplY3RpbmcgYW4gSU5UIHRvIG1lYXN1cmUgdGhlIHBlcmZvcm1hbmNlCm9mIEdJQ3Y0IGlzIHNs
aWdodGx5IGJvbmtlcnMsIGFjdHVhbGx5LiBNb3N0IG9mIHRoZSBjb3N0IGlzIHBhaWQKb24gdGhl
IGluamVjdGlvbiBwYXRoIChxdWV1aW5nIGEgcGFpciBvZiBjb21tYW5kLCB3YWl0aW5nIHVudGls
CnRoZSBJVFMgd2FrZXMgdXAgYW5kIGdlbmVyYXRlIHRoZSBzaWduYWwuLi4pLgoKV2hhdCB5b3Ug
cmVhbGx5IHdhbnQgdG8gbWVhc3VyZSBpcyB0aGUgdGltZSBmcm9tIGdlbmVyYXRpb24gb2YKdGhl
IExQSSBieSBhIGRldmljZSB1bnRpbCB0aGUgZ3Vlc3QgYWNrbm93bGVkZ2VzIHRoZSBpbnRlcnJ1
cHQKdG8gdGhlIGRldmljZSBpdHNlbGYuIGFuZCB0aGlzIGNhbiBvbmx5IGJlIGltcGxlbWVudGVk
IGluIHRoZQpkZXZpY2UuCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVz
dCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
