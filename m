Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E50C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 04:11:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3777121D46
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 04:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYKconbZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3777121D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 865BE4B391;
	Thu, 10 Sep 2020 00:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MkIpxMmPJUSd; Thu, 10 Sep 2020 00:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60EC64B36A;
	Thu, 10 Sep 2020 00:11:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CDA94B359
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 00:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xj44m2qzHjt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 00:11:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31EAF4B358
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 00:11:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599711106;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xP+86LHZVAdpGq9GC2Yic5y2+EfMHgm2K0NyZBqsLbQ=;
 b=JYKconbZFCY+V/TrPkxzO2VqNf7MfRuguGOatUOXDw8YGI13rv9sgoKJJaSwjtVntsB/s0
 6uNh8bmEeMKiA0IGHADe52H9ICSS3KGJPk7YRguP1V2IewfG/F1JXPjl4O+Ig3RHbkC1Xm
 jhu1rAI2GAXiKX2lBE2C5k7b5ddXG6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-yqUNa3miOnS5ab_OO-TdJg-1; Thu, 10 Sep 2020 00:11:42 -0400
X-MC-Unique: yqUNa3miOnS5ab_OO-TdJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B5C78030A6;
 Thu, 10 Sep 2020 04:11:40 +0000 (UTC)
Received: from [10.64.54.123] (vpn2-54-123.bne.redhat.com [10.64.54.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EEA95D9E8;
 Thu, 10 Sep 2020 04:11:28 +0000 (UTC)
Subject: Re: [PATCH v4 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
From: Gavin Shan <gshan@redhat.com>
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <4e41d4c5-1d36-fb28-880d-94235def35ed@redhat.com>
Message-ID: <598f5291-d75f-68ba-d575-c1a400194eef@redhat.com>
Date: Thu, 10 Sep 2020 14:11:01 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4e41d4c5-1d36-fb28-880d-94235def35ed@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

T24gOS8xMC8yMCAyOjA2IFBNLCBHYXZpbiBTaGFuIHdyb3RlOgo+IEhpIFdpbGwgYW5kIE1hcmMs
Cj4gCj4gT24gOS84LzIwIDE6MjMgQU0sIFdpbGwgRGVhY29uIHdyb3RlOgo+PiBIaSBhbGwsCj4+
Cj4+IEhlcmUncyB2ZXJzaW9uIGZvdXIgb2YgdGhlIEtWTSBwYWdlLXRhYmxlIHJld29yayBJIHBy
ZXZpb3VzbHkgcG9zdGVkIGhlcmU6Cj4+Cj4+IMKgwqAgdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMDA3MzAxNTM0MDYuMjUxMzYtMS13aWxsQGtlcm5lbC5vcmcKPj4gwqDCoCB2Mjog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMDgxODEzMjgxOC4xNjA2NS0xLXdpbGxAa2Vy
bmVsLm9yZwo+PiDCoMKgIHYzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjAwODI1MDkz
OTUzLjI2NDkzLTEtd2lsbEBrZXJuZWwub3JnCj4+Cj4+IENoYW5nZXMgc2luY2UgdjMgaW5jbHVk
ZToKPj4KPj4gwqDCoCAqIFJlbW92ZWQgc29tZSBtb3JlIHVudXNlZCBjb2RlIGZyb20gdGhlIG9s
ZCBpbXBsZW1lbnRhdGlvbgo+PiDCoMKgICogUmVudW1iZXJlZCBLVk1fUEdUQUJMRV9QUk9UXyog
dG8gbWF0Y2ggZmlsZSBwZXJtaXNzaW9ucyBpbiBoZXggZHVtcHMKPj4gwqDCoCAqIFNpbXBsaWZp
ZWQga3ZtX2dyYW51bGVfc2hpZnQoKSBhbmQgcmVtb3ZlZCBrdm1fc3RhcnRfbGV2ZWwoKQo+PiDC
oMKgICogT25seSBjbGVhciB2YWxpZCBiaXQgd2hlbiBpbnZhbGlkYXRpbmcgYSBQVEUsIGxlYXZp
bmcgcGh5cyBhZGRyIGludGFjdAo+PiDCoMKgICogRmFpbCBncmFjZWZ1bGx5IHdoZW4gYXR0ZW1w
dGluZyB0byBhbGxvY2F0ZSB3aXRob3V0IGEgbWVtb3J5IGNhY2hlCj4+IMKgwqAgKiBSZXdyb3Rl
IHN0YWdlMl9hcHBseV9yYW5nZSgpIGFzIGEgZnVuY3Rpb24gaW5zdGVhZCBvZiBhIG1hY3JvCj4+
IMKgwqAgKiBGaXhlZCBmYXVsdCBhZGRyZXNzIHJvdW5kaW5nIHdpdGggaHVnZXRsYmZzCj4+IMKg
wqAgKiBGaXhlZCBwZXJtaXNzaW9uIGZhdWx0IGhhbmRsaW5nIHdoZW4gZGlydHkgbG9nZ2luZyBp
cyBlbmFibGVkCj4+IMKgwqAgKiBBZGRlZCBjb21tZW50cwo+PiDCoMKgICogQWRkZWQgcmV2aWV3
ZXIgdGFncwo+Pgo+PiBNYW55IHRoYW5rcyB0byBBbGV4IGFuZCBHYXZpbiBmb3IgdGhlaXIgY29t
bWVudHMuCj4+Cj4+IFdpbGwKPj4KPiAKPiBbLi4uXQo+IAo+IEV2ZW50dWFsbHksIEknbSBsdWNr
eSBmaW5kaW5nIGEgbWFjaGluZSBmcm9tIG91ciBwb29sIHdoZXJlIDE2S0IgcGFnZQo+IHNpemUg
aXMgc3VwcG9ydGVkLiBJIHRyaWVkIHRoaXMgc2VyaWVzICh2NCkgb24gdGhpcyBtYWNoaW5lLCBl
dmVyeXRoaW5nCj4gbG9va3MgZ29vZCBhcyB3ZSBleHBlY3RlZDoKPiAKPiAgwqDCoCBIb3N0OsKg
wqAgNS45LjAtcmMzICsgcGF0Y2hzZXQgKHY0KQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBDT05G
SUdfQVJNNjRfVkFfQklUUz00Nwo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBDT05GSUdfQVJNNjRf
UEFHRV9TSElGVD0xNAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIdWdlcGFnZXNpemU6IDMyNzY4
IGtCwqDCoMKgwqDCoCAoZnJvbSAvcHJvYy9tZW1pbmZvKQo+ICDCoMKgIENvbmZpZzogLUh1Z2VU
TEJmcy8tVEhQCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgICtIdWdlVExCZnMvLVRIUAo+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAtSHVnZVRMQmZzL1RIUAo+ICDCoMKgIEd1ZXN0OsKgIENPTkZJR19B
Uk02NF9QQUdFX1NISUZUPTEyLzE0LzE2Cj4gCj4gTGV0IG1lIGtub3cgaW4gY2FzZSB0aGVyZSBh
cmUgbW9yZSB0ZXN0cyBuZWVkZWQgZnJvbSBteSBzaWRlLgo+IAoKSGVyZSBpcyB0aGUgQ1BVIGlu
Zm8gcmV0cmlldmVkIGZyb20gZG1pZGVjb2RlOgoKSGFuZGxlIDB4MDAwNCwgRE1JIHR5cGUgNCwg
NDggYnl0ZXMKUHJvY2Vzc29yIEluZm9ybWF0aW9uCglTb2NrZXQgRGVzaWduYXRpb246IENQVSAx
CglUeXBlOiBDZW50cmFsIFByb2Nlc3NvcgoJRmFtaWx5OiBBUk12OAoJTWFudWZhY3R1cmVyOiBB
bXBlcmUoVE0pCglJRDogMDIgMDAgM0YgNTAgMDAgMDAgMDAgMDAKCVNpZ25hdHVyZTogSW1wbGVt
ZW50b3IgMHg1MCwgVmFyaWFudCAweDMsIEFyY2hpdGVjdHVyZSAxNSwgUGFydCAweDAwMCwgUmV2
aXNpb24gMgoJVmVyc2lvbjogZU1BRwoJVm9sdGFnZTogMC45IFYKCUV4dGVybmFsIENsb2NrOiAz
MDAwIE1IegoJTWF4IFNwZWVkOiAzMzAwIE1IegoJQ3VycmVudCBTcGVlZDogMzAwMCBNSHoKCVN0
YXR1czogUG9wdWxhdGVkLCBFbmFibGVkCglVcGdyYWRlOiBOb25lCglMMSBDYWNoZSBIYW5kbGU6
IDB4MDAwNQoJTDIgQ2FjaGUgSGFuZGxlOiAweDAwMDYKCUwzIENhY2hlIEhhbmRsZTogMHgwMDA3
CglTZXJpYWwgTnVtYmVyOiAwMDAwMDAwMDAwMDAwMDAwMDBENzA4MDUwMkYxODBEQwoJQXNzZXQg
VGFnOiBOb3QgU3BlY2lmaWVkCglQYXJ0IE51bWJlcjogTm90IFNwZWNpZmllZAoJQ29yZSBDb3Vu
dDogMzIKCUNvcmUgRW5hYmxlZDogMzIKCVRocmVhZCBDb3VudDogMzIKCUNoYXJhY3RlcmlzdGlj
czoKCQk2NC1iaXQgY2FwYWJsZQoJCU11bHRpLUNvcmUKCQlIYXJkd2FyZSBUaHJlYWQKCQlFeGVj
dXRlIFByb3RlY3Rpb24KCQlFbmhhbmNlZCBWaXJ0dWFsaXphdGlvbgoKVGhhbmtzLApHYXZpbgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
