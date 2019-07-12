Return-Path: <SRS0=lVnl=VJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FORGED_MUA_MOZILLA,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INVALID_MSGID,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3146C742BB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jul 2019 12:55:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6EC5208E4
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jul 2019 12:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="vYHFqWQ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6EC5208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=foxmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 491B44A52D;
	Fri, 12 Jul 2019 08:55:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@foxmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gvM86kgtOvgV; Fri, 12 Jul 2019 08:55:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4676A4A53D;
	Fri, 12 Jul 2019 08:55:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B9F4A4FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jul 2019 03:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hnCUvNIrQF6v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jul 2019 03:41:03 -0400 (EDT)
Received: from smtpbg.qq.com (smtpbg516.qq.com [203.205.250.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4595C4A445
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jul 2019 03:41:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
 s=s201512; t=1562917165;
 bh=deLbQKEQzcrxRwXDiaIUoV2Xxs5QwL0vHNoCfE2uPHk=;
 h=Subject:To:From:Message-ID:Date:MIME-Version;
 b=vYHFqWQ5FkAcBVr8dxNp/Artn906lRYMFbyX3CvL8iAFsV6Muty+3QdO/F8QJ2mkJ
 twAbOwI5HKbhmv8/MxISQ9Un+lCSqLadlhOPKYY9CTB9HUhx6WE6/DYFB3iLSf2fx9
 Yw/S17BG8LHkxh31qZYiKJaZEKpLO1EWnm/xbzIM=
X-QQ-mid: esmtp3t1562917164tsr3r7aw3
Received: from [192.168.11.133] (unknown [139.162.86.229])
 by esmtp4.qq.com (ESMTP) with 
 id ; Fri, 12 Jul 2019 15:39:06 +0800 (CST)
X-QQ-SSF: 00000000000000F0FH110000000000K
X-QQ-FEAT: EUGmOqWjSYLczc6JuKN3zbS382XopRt18cXQdtODTZn0mrgWpAHN1tXi7GKb/
 6RagdYc97doGB/fje1qoXSaNioUnNAaV2U774D+O3GpqR6vTchaqEJNre5bYg/ktJ0cspxa
 eF4I6x9LDiH3JUUPjLVAw6uQjtpxABPq7GFOCayIiiVoLIE1vFUj1WaobK1rn4tFHlnIV4e
 bE/BRtxj5PrfE6Jb9xsEGINVe4nFaWypPfgnPgcjwiaritNvtLTaRv7rCuFbSD8uKWQmKvc
 zJL4DHBupm+XvNjjhLBfyhlKdoDwUluSh/XViDLYl6CDWA
X-QQ-GoodBg: 0
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
References: <20190711135625.20684-1-eric.auger@redhat.com>
From: "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Message-ID: <e555a639-9f49-e067-5da2-7d4f2be710d0@foxmail.com>+78E9F80FDD33BA49
Date: Fri, 12 Jul 2019 15:38:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711135625.20684-1-eric.auger@redhat.com>
Content-Language: en-US
X-QQ-SENDSIZE: 520
Feedback-ID: esmtp:foxmail.com:bgweb:bgweb5
X-Mailman-Approved-At: Fri, 12 Jul 2019 08:55:26 -0400
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com, tina.zhang@intel.com
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

CgpPbiAyMDE5LzcvMTEg5LiL5Y2IOTo1NiwgRXJpYyBBdWdlciB3cm90ZToKPiBUaGlzIHNlcmll
cyBicmluZ3MgdGhlIFZGSU8gcGFydCBvZiBIVyBuZXN0ZWQgcGFnaW5nIHN1cHBvcnQKPiBpbiB0
aGUgU01NVXYzLgo+Cj4gVGhlIHNlcmllcyBkZXBlbmRzIG9uOgo+IFtQQVRDSCB2OSAwMC8xNF0g
U01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9NTVUgcGFydCkKPiAoaHR0cHM6Ly93d3cuc3Bp
bmljcy5uZXQvbGlzdHMva2VybmVsL21zZzMxODc3MTQuaHRtbCkKPgo+IDMgbmV3IElPQ1RMcyBh
cmUgaW50cm9kdWNlZCB0aGF0IGFsbG93IHRoZSB1c2Vyc3BhY2UgdG8KPiAxKSBwYXNzIHRoZSBn
dWVzdCBzdGFnZSAxIGNvbmZpZ3VyYXRpb24KPiAyKSBwYXNzIHN0YWdlIDEgTVNJIGJpbmRpbmdz
Cj4gMykgaW52YWxpZGF0ZSBzdGFnZSAxIHJlbGF0ZWQgY2FjaGVzCj4KPiBUaGV5IG1hcCBvbnRv
IHRoZSByZWxhdGVkIG5ldyBJT01NVSBBUEkgZnVuY3Rpb25zLgo+Cj4gV2UgaW50cm9kdWNlIHRo
ZSBjYXBhYmlsaXR5IHRvIHJlZ2lzdGVyIHNwZWNpZmljIGludGVycnVwdAo+IGluZGV4ZXMgKHNl
ZSBbMV0pLiBBIG5ldyBETUFfRkFVTFQgaW50ZXJydXB0IGluZGV4IGFsbG93cyB0byByZWdpc3Rl
cgo+IGFuIGV2ZW50ZmQgdG8gYmUgc2lnbmFsZWQgd2hlbmV2ZXIgYSBzdGFnZSAxIHJlbGF0ZWQg
ZmF1bHQKPiBpcyBkZXRlY3RlZCBhdCBwaHlzaWNhbCBsZXZlbC4gQWxzbyBhIHNwZWNpZmljIHJl
Z2lvbiBhbGxvd3MKPiB0byBleHBvc2UgdGhlIGZhdWx0IHJlY29yZHMgdG8gdGhlIHVzZXIgc3Bh
Y2UuCj4KPiBCZXN0IFJlZ2FyZHMKPgo+IEVyaWMKPgo+IFRoaXMgc2VyaWVzIGNhbiBiZSBmb3Vu
ZCBhdDoKPiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL2xpbnV4L3RyZWUvdjUuMy4wLXJjMC0y
c3RhZ2UtdjkKPgo+IEl0IHNlcmllcyBpbmNsdWRlcyBUaW5hJ3MgcGF0Y2ggc3RlbWluZyBmcm9t
Cj4gWzFdICJbUkZDIFBBVENIIHYyIDEvM10gdmZpbzogVXNlIGNhcGFiaWxpdHkgY2hhaW5zIHRv
IGhhbmRsZSBkZXZpY2UKPiBzcGVjaWZpYyBpcnEiIHBsdXMgcGF0Y2hlcyBvcmlnaW5hbGx5IGNv
bnRyaWJ1dGVkIGJ5IFlpLgo+Cj4KVGhhbmtzIEVyaWMuCgpIYXZlIHRlc3RlZCB2ZmlvIG1vZGUg
aW4gcWVtdSBvbiBIaXNpbGljb24gYXJtNjQgcGxhdGZvcm0sIHVzaW5nIGdJT1ZBCnFlbXUgY29t
bWFuZDogLW1hY2hpbmUgdmlydCxnaWNfdmVyc2lvbj0zLGlvbW11PXNtbXV2MyAtZGV2aWNlIAp2
ZmlvLXBjaSxob3N0PTAwMDA6NzU6MDAuMQoKVGVzdGVkLWJ5OiBaaGFuZ2ZlaSBHYW8gPHpoYW5n
ZmVpLmdhb0BsaW5hcm8ub3JnPgpxZW11OiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3FlbXUv
dHJlZS92NC4xLjAtcmMwLTJzdGFnZS1yZmN2NQprZXJuZWw6IGh0dHBzOi8vZ2l0aHViLmNvbS9l
YXVnZXIvbGludXgvdHJlZS92NS4zLjAtcmMwLTJzdGFnZS12OQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
