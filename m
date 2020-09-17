Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1345BC43461
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 10:01:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59B862083B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 10:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="00iQ1HYX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59B862083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D0A4B820;
	Thu, 17 Sep 2020 06:01:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ibfqzh3qw2A5; Thu, 17 Sep 2020 06:01:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DAF04B848;
	Thu, 17 Sep 2020 06:01:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB304B820
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 06:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V-M0tloGu6-Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 06:01:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7EB64B774
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 06:01:42 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9FB0920770;
 Thu, 17 Sep 2020 10:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600336901;
 bh=Xh8JuZm4voE70hSUqrNM4+HG+MZSDD3QHPaZ/il5TMU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=00iQ1HYXyByzkyIHcCOwnOd7Y4T4D/gWgeu6tORKXzRsQL8BecLyON1RF02dWjRlW
 XKBwCoFYyOvKpLXHIIy2s3o45cOoZtniBqVp720vyGWPjfux1IZYruxVydUwVmsfFm
 jbp/u3Qb+ht/jQH7T9+42RvAWop6JnjL534R2HMo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kIqjT-00Cb1I-M3; Thu, 17 Sep 2020 11:01:39 +0100
MIME-Version: 1.0
Date: Thu, 17 Sep 2020 11:01:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
In-Reply-To: <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
 <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, drjones@redhat.com,
 fangying1@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, alex.chen@huawei.com,
 Ying Fang <fangying1@huawei.com>, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC0wOS0xNyAxMDo0NywgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSwKPiAKPiBP
biA5LzE3LzIwIDk6NDIgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0wOS0xNyAw
OTowNCwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+Pj4gT24gVGh1LCBTZXAgMTcsIDIwMjAgYXQgMDg6
NDc6NDJBTSArMDEwMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IE9uIDIwMjAtMDktMTcgMDM6
MzAsIFlpbmcgRmFuZyB3cm90ZToKPj4+PiA+IEFsbG93IHVzZXJzcGFjZSB0byBzZXQgTVBJRFIg
dXNpbmcgdmNwdSBpb2N0bCBLVk1fQVJNX1NFVF9NUF9BRkZJTklUWSwKPj4+PiA+IHNvIHRoYXQg
d2UgY2FuIHN1cHBvcnQgY3B1IHRvcG9sb2d5IGZvciBhcm0uCj4+Pj4gCj4+Pj4gTVBJRFIgaGFz
ICpub3RoaW5nKiB0byBkbyB3aXRoIENQVSB0b3BvbG9neSBpbiB0aGUgQVJNIGFyY2hpdGVjdHVy
ZS4KPj4+PiBJIGVuY291cmFnZSB5b3UgdG8gaGF2ZSBhIGxvb2sgYXQgdGhlIEFSTSBBUk0gYW5k
IGZpbmQgb3V0IGhvdyBvZnRlbgo+Pj4+IHRoZSB3b3JkICJ0b3BvbG9neSIgaXMgdXNlZCBpbiBj
b25qdW5jdGlvbiB3aXRoIHRoZSBNUElEUl9FTDEgCj4+Pj4gcmVnaXN0ZXIuCj4+Pj4gCj4+PiAK
Pj4+IEhpIE1hcmMsCj4+PiAKPj4+IEkgbW9zdGx5IGFncmVlLiBIb3dldmVyLCB0aGUgQ1BVIHRv
cG9sb2d5IGRlc2NyaXB0aW9ucyB1c2UgTVBJRFIgdG8KPj4+IGlkZW50aWZ5IFBFcy4gSWYgdXNl
cnNwYWNlIHdhbnRzIHRvIGJ1aWxkIHRvcG9sb2d5IGRlc2NyaXB0aW9ucyB0aGVuCj4+PiBpdCBl
aXRoZXIgbmVlZHMgdG8KPj4+IAo+Pj4gMSkgYnVpbGQgdGhlbSBhZnRlciBpbnN0YW50aWF0aW5n
IGFsbCBLVk0gVkNQVXMgaW4gb3JkZXIgdG8gcXVlcnkgS1ZNCj4+PiDCoMKgIGZvciBlYWNoIE1Q
SURSLCBvcgo+Pj4gMikgaGF2ZSBhIHdheSB0byBhc2sgS1ZNIGZvciBhbiBNUElEUiBvZiBnaXZl
biBWQ1BVIElEIGluIGFkdmFuY2UKPj4+IMKgwqAgKG1heWJlIGp1c3QgYSBzY3JhdGNoIFZDUFUp
LCBvcgo+Pj4gMykgaGF2ZSBjb250cm9sIG92ZXIgdGhlIE1QSURScyBzbyBpdCBjYW4gY2hvb3Nl
IHRoZW0gd2hlbiBpdCBsaWtlcywKPj4+IMKgwqAgdXNlIHRoZW0gZm9yIHRvcG9sb2d5IGRlc2Ny
aXB0aW9ucywgYW5kIHRoZW4gaW5zdGFudGlhdGUgS1ZNIFZDUFVzCj4+PiDCoMKgIHdpdGggdGhl
bS4KPj4+IAo+Pj4gSSB0aGluayAoMykgaXMgdGhlIG1vc3Qgcm9idXN0IGFwcHJvYWNoLCBhbmQg
aXQgaGFzIHRoZSBsZWFzdCAKPj4+IG92ZXJoZWFkLgo+PiAKPj4gSSBkb24ndCBkaXNhZ3JlZSB3
aXRoIHRoZSBnb2FsLCBhbmQgbm90IGV2ZW4gd2l0aCB0aGUgY2hvaWNlIG9mCj4+IGltcGxlbWVu
dGF0aW9uICh0aG91Z2ggSSBoYXZlIGh1Z2UgcmVzZXJ2YXRpb25zIGFib3V0IGl0cyBxdWFsaXR5
KS4KPj4gCj4+IEJ1dCB0aGUga2V5IHdvcmQgaGVyZSBpcyAqdXNlcnNwYWNlKi4gT25seSB1c2Vy
c3BhY2UgaGFzIGEgbm90aW9uIG9mCj4+IGhvdyBNUElEUiB2YWx1ZXMgbWFwIHRvIHRoZSBhc3N1
bWVkIHRvcG9sb2d5LiBUaGF0J3Mgbm90IHNvbWV0aGluZwo+PiB0aGF0IEtWTSBkb2VzIG5vciBz
aG91bGQgaW50ZXJwcmV0IChhc2lkZSBmcm9tIHRoZSBHSUMtaW5kdWNlZCBBZmYwCj4+IGJyYWlu
LWRhbWFnZSkuIFNvIHRhbGtpbmcgb2YgInRvcG9sb2d5IiBpbiBhIEtWTSBrZXJuZWwgcGF0Y2gg
c2VuZHMKPj4gdGhlIHdyb25nIG1lc3NhZ2UsIGFuZCB0aGF0J3MgYWxsIHRoaXMgcmVtYXJrIHdh
cyBhYm91dC4KPiAKPiBUaGVyZSdzIGFsc28gYSBwYXRjaCBxdWV1ZWQgZm9yIG5leHQgd2hpY2gg
cmVtb3ZlcyB1c2luZyBNUElEUiBhcyBhIAo+IHNvdXJjZSBvZgo+IGluZm9ybWF0aW9uIGFib3V0
IENQVSB0b3BvbG9neSBbMV06ICJhcm02NDogdG9wb2xvZ3k6IFN0b3AgdXNpbmcgTVBJRFIgCj4g
Zm9yCj4gdG9wb2xvZ3kgaW5mb3JtYXRpb24iLgo+IAo+IEknbSBub3QgcmVhbGx5IHN1cmUgaG93
IHVzZWZ1bCBLVk0gZmlkZGxpbmcgd2l0aCB0aGUgZ3Vlc3QgTVBJRFIgd2lsbCAKPiBiZSBnb2lu
Zwo+IGZvcndhcmQsIGF0IGxlYXN0IGZvciBhIExpbnV4IGd1ZXN0LgoKSSB0aGluayB0aGVzZSBh
cmUgdHdvIG9ydGhvZ29uYWwgdGhpbmdzLiBUaGVyZSBpcyB2YWx1ZSBpbiBzZXR0aW5nIE1QSURS
CnRvIHNvbWV0aGluZyBkaWZmZXJlbnQgYXMgYSB3YXkgdG8gcmVwbGljYXRlIGFuIGV4aXN0aW5n
IHN5c3RlbSwgZm9yCmV4YW1wbGUuIEJ1dCBkZXJpdmluZyAqYW55KiBzb3J0IG9mIHRvcG9sb2d5
IGluZm9ybWF0aW9uIGZyb20gTVBJRFIgCmlzbid0CnJlbGlhYmxlIGF0IGFsbCwgYW5kIGlzIGJl
dHRlciBleHByZXNzZWQgYnkgZmlybXdhcmUgdGFibGVzIChhbmQgZXZlbgp0aGF0IGlzbid0IGdy
ZWF0KS4KCkFzIGZhciBhcyBJIGFtIGNvbmNlcm5lZCwgdGhpcyBwYXRjaCBmaXRzIGluIHRoZSAi
Y29zbWV0aWMiIGRlcGFydG1lbnQuCkl0J3MgYSAibmljZSB0byBoYXZlIiwgYnV0IGRvZXNuJ3Qg
cmVhbGx5IHNvbHZlIG11Y2guIEZpcm13YXJlIHRhYmxlcwphbmQgdXNlcnNwYWNlIHBsYWNlbWVu
dCBvZiB0aGUgdmNwdXMgYXJlIGtleS4KClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlz
IG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
