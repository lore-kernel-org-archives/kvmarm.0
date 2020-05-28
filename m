Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D350C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 09:01:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B3BF20776
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 09:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KbvJi97G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B3BF20776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7ED44B223;
	Fri, 29 May 2020 05:01:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Ss5zptPwaoa; Fri, 29 May 2020 05:01:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE044B224;
	Fri, 29 May 2020 05:01:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 553124B18A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 19:03:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id atQFUswSdLqj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 19:03:10 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3104B143
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 19:03:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590706990;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qUIox5FhQJ2z08jhZB7sfNniyrJZwWCLCZ4Ajtdwh7I=;
 b=KbvJi97G0mAEKEK9mXcnqTYPiXH/5BFY7FE8720lC3/HlqMkiKeWaH/yDT1jO4mC0FcxUv
 15B5jDxDVW39ZJOrAquu4DA1bVydrnwhZxjkS7j23/fRVfwY2Ij4OxExESHLK414wnBlqO
 ViXuznoBGuOEnwEeo7lsbuV07g3B4gU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-9_wHkkfkNRKqvFNP88Dgeg-1; Thu, 28 May 2020 19:03:06 -0400
X-MC-Unique: 9_wHkkfkNRKqvFNP88Dgeg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCE351005510;
 Thu, 28 May 2020 23:03:04 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-130.bne.redhat.com
 [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 421C860C80;
 Thu, 28 May 2020 23:03:01 +0000 (UTC)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <6a4a82a4-af01-98c2-c854-9199f55f7bd3@redhat.com>
Date: Fri, 29 May 2020 09:02:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mailman-Approved-At: Fri, 29 May 2020 05:01:02 -0400
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

SGkgUGFvbG8sCgpPbiA1LzI4LzIwIDg6NDggUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24g
MjgvMDUvMjAgMDg6MTQsIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiAtIGZvciB4ODYgd2UncmUgYWxz
byB0aGlua2luZyBvZiBpbml0aWF0aW5nIHRoZSBwYWdlIGZhdWx0IGZyb20gdGhlCj4+PiBleGNl
cHRpb24gaGFuZGxlciwgcmF0aGVyIHRoYW4gZG9pbmcgc28gZnJvbSB0aGUgaHlwZXJ2aXNvciBi
ZWZvcmUKPj4+IGluamVjdGluZyB0aGUgZXhjZXB0aW9uLsKgIElmIEFSTSBsZWFkcyB0aGUgd2F5
IGhlcmUsIHdlIHdvdWxkIGRvIG91cgo+Pj4gYmVzdCB0byBzaGFyZSBjb2RlIHdoZW4geDg2IGRv
ZXMgdGhlIHNhbWUuCj4+Cj4+IFNvcnJ5LCBQYW9sbywgSSBkb24ndCBmb2xsb3cgeW91ciBpZGVh
IGhlcmUuIENvdWxkIHlvdSBwbGVhc2UgcHJvdmlkZQo+PiBtb3JlIGRldGFpbHM/Cj4gCj4gVGhl
IGlkZWEgaXMgdG8gaW5qZWN0IHN0YWdlMiBwYWdlIGZhdWx0cyBpbnRvIHRoZSBndWVzdCBldmVu
IGJlZm9yZSB0aGUKPiBob3N0IHN0YXJ0cyBwb3B1bGF0ZXMgdGhlIHBhZ2UuICBUaGUgZ3Vlc3Qg
dGhlbiBpbnZva2VzIGEgaHlwZXJjYWxsLAo+IHRlbGxpbmcgdGhlIGhvc3QgdG8gcG9wdWxhdGUg
dGhlIHBhZ2UgdGFibGUgYW5kIGluamVjdCB0aGUgJ3BhZ2UgcmVhZHknCj4gZXZlbnQgKGludGVy
cnVwdCkgd2hlbiBpdCdzIGRvbmUuCj4gCj4gRm9yIHg4NiB0aGUgYWR2YW50YWdlIGlzIHRoYXQg
dGhlIHByb2Nlc3NvciBjYW4gdGFrZSBjYXJlIG9mIHJhaXNpbmcgdGhlCj4gc3RhZ2UyIHBhZ2Ug
ZmF1bHQgaW4gdGhlIGd1ZXN0LCBzbyBpdCdzIGZhc3Rlci4KPiAKSSB0aGluayB0aGVyZSBtaWdo
dCBiZSB0b28gbXVjaCBvdmVyaGVhZCBpZiB0aGUgcGFnZSBjYW4gYmUgcG9wdWxhdGVkCnF1aWNr
bHkgYnkgaG9zdC4gRm9yIGV4YW1wbGUsIGl0J3MgZmFzdCB0byBwb3B1bGF0ZSB0aGUgcGFnZXMg
aWYgc3dhcGluCmlzbid0IGludm9sdmVkLgoKSWYgSSdtIGNvcnJlY3QgZW5vdWdoLCBpdCBzZWVt
cyBhcm02NCBkb2Vzbid0IGhhdmUgc2ltaWxhciBtZWNoYW5pc20sCnJvdXRpbmcgc3RhZ2UyIHBh
Z2UgZmF1bHQgdG8gZ3Vlc3QuCgpUaGFua3MsCkdhdmluCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
