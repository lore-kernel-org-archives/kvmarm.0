Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAC6C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:29:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DEAE20702
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:29:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DEAE20702
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF2B4B133;
	Thu,  2 Jul 2020 05:29:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KNsqhemEEici; Thu,  2 Jul 2020 05:29:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA0D4B5B5;
	Thu,  2 Jul 2020 05:29:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E68134B133
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:29:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y+gH9L48pHGR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 05:29:45 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 930464B0E4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:29:45 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id D307FD1A9224D1FEB8AD;
 Thu,  2 Jul 2020 17:29:40 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 17:29:38 +0800
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Marc Zyngier <maz@kernel.org>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
 <10c3562dc019a3440d82dd507918faef@kernel.org>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <3a1533a5-bf93-4ce9-2e5c-a5c0da4cc0cc@huawei.com>
Date: Thu, 2 Jul 2020 17:29:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <10c3562dc019a3440d82dd507918faef@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

T24gNy8yLzIwMjAgNToxNyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMDctMDIg
MTA6MDIsIEppbmd5aSBXYW5nIHdyb3RlOgo+PiBIaSBNYXJjLAo+Pgo+PiBPbiA3LzIvMjAyMCA0
OjIyIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBPbiAyMDIwLTA3LTAyIDA0OjAxLCBKaW5n
eWkgV2FuZyB3cm90ZToKPj4+PiBJZiBnaWN2NC4xKHNnaSBoYXJkd2FyZSBpbmplY3Rpb24pIHN1
cHBvcnRlZCwgd2UgdGVzdCBpcGkgaW5qZWN0aW9uCj4+Pj4gdmlhIGh3L3N3IHdheSBzZXBhcmF0
ZWx5Lgo+Pj4KPj4+IG5pdDogYWN0aXZlLWxlc3MgU0dJcyBhcmUgbm90IHN0cmljdGx5IGEgZmVh
dHVyZSBvZiBHSUN2NC4xICh5b3UgY291bGQKPj4+IGltYWdpbmUgYSBHSUMgZW11bGF0aW9uIG9m
ZmVyaW5nIHRoZSBzYW1lIHRoaW5nKS4gRnVydGhlcm1vcmUsIEdJQ3Y0LjEKPj4+IGlzbid0IGFz
IHN1Y2ggdmlzaWJsZSB0byB0aGUgZ3Vlc3QgaXRzZWxmIChpdCBvbmx5IHNlZXMgYSBHSUN2Myku
Cj4+Pgo+Pj4gVGhhbmtzLAo+Pj4KPj4+IMKgwqDCoMKgwqDCoMKgwqAgTS4KPj4KPj4gWWVzLCBi
dXQgdG8gbWVhc3VyZSB0aGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBvZiBody9zdyBTR0kgaW5q
ZWN0aW9uLAo+PiBkbyB5b3UgdGhpbmsgaXQgaXMgYWNjZXB0YWJsZSB0byBtYWtlIGl0IHZpc2li
bGUgdG8gZ3Vlc3QgYW5kIGxldCBpdAo+PiBzd2l0Y2ggU0dJIGluamVjdGlvbiBtb2RlPwo+IAo+
IEl0IGlzIG9mIGNvdXJzZSBhY2NlcHRhYmxlLiBJIHNpbXBseSBvYmplY3QgdG8gdGhlICJHSUN2
NC4xIiBkZXNjcmlwdGlvbi4KPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KCk9rYXksIG1heWJlIGRl
c2NyaXB0aW9uIGxpa2UgIkdJQ3Y0LjEgc3VwcG9ydGVkIGt2bSIgaXMgYmV0dGVyLgoKVGhhbmtz
LApKaW5neWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
