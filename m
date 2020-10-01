Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E223DC4727F
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 14:38:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E95F20B1F
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 14:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B2cIJnXL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E95F20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4874B363;
	Thu,  1 Oct 2020 10:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y7s9aIc1ebIe; Thu,  1 Oct 2020 10:38:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA6E24B3B1;
	Thu,  1 Oct 2020 10:38:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13DDB4B33F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 09:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vw1FpGd-QRdE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 09:02:01 -0400 (EDT)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1636B4B33D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 09:02:01 -0400 (EDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091CjLvN096738;
 Thu, 1 Oct 2020 13:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HtBX+cZGejtb73NCn1dVm1uzpKYbJ8CJKyJUF+4rZ80=;
 b=B2cIJnXLyJxiJrAcPyMr/AoyaP5Hv6C5rJ5Xs+I1h0A9FNh30C2mkB0A/kccIDcNk8dO
 csP7CY6IOrXx1pEY4Z9xrhPUBhTQvSHMNykg8YawhWBnMVHp1O7apqvYpLAIudPB+vig
 MhNKxqMlnEZkbE5ps+MImCeDQqD6JZ3a0Hg/eUn2AfDj/0ynID7uKh6TXcZ+oNhDIksI
 g2Jh09N5ADlu919+d87dyI+HSlDkLbX632p8EDxpNDerrKVoMYDDRtvv/V62FghCssEN
 BnexpS+rnUedFM13gCUqzvfoH8oXBrUCB+VO4Xe9KGU1EaUBAHBgnGZF5v0uvc20rhjl UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
 by userp2120.oracle.com with ESMTP id 33sx9ndqtv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
 Thu, 01 Oct 2020 13:01:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
 by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091Ck6Zq169708;
 Thu, 1 Oct 2020 12:59:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
 by userp3030.oracle.com with ESMTP id 33tfk1habk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 01 Oct 2020 12:59:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
 by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091Cxqrx009217;
 Thu, 1 Oct 2020 12:59:53 GMT
Received: from [192.168.0.14] (/108.168.44.57)
 by default (Oracle Beehive Gateway v4.0)
 with ESMTP ; Thu, 01 Oct 2020 05:59:52 -0700
Subject: Re: [PATCH] KVM: arm64: Fixes ARM VM hangs at boot
To: Marc Zyngier <maz@kernel.org>
References: <20200930221239.488744-1-thomas.tai@oracle.com>
 <f906ecd23609bbdf4a1db991624943d5@kernel.org>
From: Thomas Tai <thomas.tai@oracle.com>
Message-ID: <b5d6692e-c6cd-4183-9bae-d59b8ec7392d@oracle.com>
Date: Thu, 1 Oct 2020 08:59:54 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f906ecd23609bbdf4a1db991624943d5@kernel.org>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760
 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760
 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010110
X-Mailman-Approved-At: Thu, 01 Oct 2020 10:38:19 -0400
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CgpPbiAyMDIwLTEwLTAxIDQ6MzAgYS5tLiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFRob21h
cywKPiAKPiBPbiAyMDIwLTA5LTMwIDIzOjEyLCBUaG9tYXMgVGFpIHdyb3RlOgo+PiBXaGVuIHVz
aW5nIHRoZSBsYXRlc3Qga2VybmVsIHY1LjktcmM3IG9uIGFuIEFSTSBzZXJ2ZXIsIFZNcyBjb3Vs
ZAo+PiBoYW5nIGF0IGJvb3Qgd2l0aCBubyBvdXRwdXQuIFRoZSBjb21taXQgYTBlNTBhYTNmNGE4
IHJlbW92ZWQKPj4gYXNtKEFMVEVSTkFUSVZFKCJpc2IiLCAibm9wIiwgQVJNNjRfV09SS0FST1VO
RF9TUEVDVUxBVElWRV9BVCkpLAo+PiBpdCBsb29rcyBsaWtlIGlzYiBpcyBzdGlsbCBuZWVkZWQg
Zm9yIG5vbgo+PiBBUk02NF9XT1JLQVJPVU5EX1NQRUNVTEFUSVZFX0FUIGhvc3Qgd2hlbiBzd2l0
Y2hpbmcgdG8gZ3Vlc3QuCj4gCj4gSXMgdGhhdCBvbiBhbiBlTUFHIHN5c3RlbSwgYnkgYW55IGNo
YW5jZT8KCkhpIE1hcmMsClllcywgaXQgaXMgaW5kZWVkIGFuIGVNQUcgc3lzdGVtLgoKPiAKPj4K
Pj4gVGhlIGNvZGUgZnJhZ21lbnQgZm9yIHRoZSBvcmlnaW5hbCBwYXRjaDoKPj4gLcKgwqDCoMKg
wqDCoCAvKiBfX2xvYWRfZ3Vlc3Rfc3RhZ2UyKCkgaW5jbHVkZXMgYW4gSVNCIGZvciB0aGUgd29y
a2Fyb3VuZC4gKi8KPj4gLcKgwqDCoMKgwqDCoCBfX2xvYWRfZ3Vlc3Rfc3RhZ2UyKGt2bSk7Cj4+
IC3CoMKgwqDCoMKgwqAgYXNtKEFMVEVSTkFUSVZFKCJpc2IiLCAibm9wIiwgQVJNNjRfV09SS0FS
T1VORF9TUEVDVUxBVElWRV9BVCkpOwo+PiArwqDCoMKgwqDCoMKgIF9fbG9hZF9ndWVzdF9zdGFn
ZTIobW11KTsKPj4KPj4gVGhlIGNvZGUgc2hvdWxkIGhhdmUgYmVlbjoKPj4gLcKgwqDCoMKgwqDC
oCAvKiBfX2xvYWRfZ3Vlc3Rfc3RhZ2UyKCkgaW5jbHVkZXMgYW4gSVNCIGZvciB0aGUgd29ya2Fy
b3VuZC4gKi8KPj4gLcKgwqDCoMKgwqDCoCBfX2xvYWRfZ3Vlc3Rfc3RhZ2UyKGt2bSk7Cj4+IC3C
oMKgwqDCoMKgwqAgYXNtKEFMVEVSTkFUSVZFKCJpc2IiLCAibm9wIiwgQVJNNjRfV09SS0FST1VO
RF9TUEVDVUxBVElWRV9BVCkpOwo+PiArwqDCoMKgwqDCoMKgIF9fbG9hZF9ndWVzdF9zdGFnZTIo
bW11KTsKPj4gK8KgwqDCoMKgwqDCoCBhc20oQUxURVJOQVRJVkUoImlzYiIsICJub3AiLCBBUk02
NF9XT1JLQVJPVU5EX1NQRUNVTEFUSVZFX0FUKSk7Cj4+IGllLCB0aGUgd29ya2Fyb3VuZCBpcyBz
dGlsbCBuZWVkZWQuCj4+Cj4+IEZpeGVzOiBhMGU1MGFhM2Y0YTggKCJLVk06IGFybTY0OiBGYWN0
b3Igb3V0IHN0YWdlIDIgcGFnZSB0YWJsZSBkYXRhIGZyb20KPj4gc3RydWN0IGt2bSIpCj4+Cj4+
IFNpZ25lZC1vZmYtYnk6IFRob21hcyBUYWkgPHRob21hcy50YWlAb3JhY2xlLmNvbT4KPj4gLS0t
Cj4+IMKgYXJjaC9hcm02NC9rdm0vaHlwL252aGUvdGxiLmMgfCAxICsKPj4gwqAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKykKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5
cC9udmhlL3RsYi5jIAo+PiBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3RsYi5jCj4+IGluZGV4
IDY5ZWFlNjAuLjUzNjQ5NmUgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhl
L3RsYi5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3RsYi5jCj4+IEBAIC0zMiw2
ICszMiw3IEBAIHN0YXRpYyB2b2lkIF9fdGxiX3N3aXRjaF90b19ndWVzdChzdHJ1Y3Qga3ZtX3My
X21tdSAKPj4gKm1tdSwKPj4gwqDCoMKgwqAgfQo+Pgo+PiDCoMKgwqDCoCBfX2xvYWRfZ3Vlc3Rf
c3RhZ2UyKG1tdSk7Cj4+ICvCoMKgwqAgYXNtKEFMVEVSTkFUSVZFKCJpc2IiLCAibm9wIiwgQVJN
NjRfV09SS0FST1VORF9TUEVDVUxBVElWRV9BVCkpOwo+PiDCoH0KPj4KPj4gwqBzdGF0aWMgdm9p
ZCBfX3RsYl9zd2l0Y2hfdG9faG9zdChzdHJ1Y3QgdGxiX2ludl9jb250ZXh0ICpjeHQpCj4gCj4g
T3VjaC4gSSByZW1lbWJlciBmaXhpbmcgdGhpcyBhIHdoaWxlIGFnbywgYnV0IHNvbWVob3cgZHJv
cHBlZCBpdAo+IGFmdGVyIGFwcGx5aW5nIGl0IGFuZCAqbm90KiBtZXJnaW5nIGl0Li4uCj4gCj4g
VGhhbmtzIGEgbG90IGZvciB0aGUgaGVhZHMgdXAhCj4gCj4gIMKgwqDCoMKgwqDCoMKgIE0uCj4g
Cj4gWzFdIAo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L21hei9hcm0tcGxhdGZvcm1zLmdpdC9jb21taXQvP2g9a3ZtLWFybTY0L3ByZS1udi01LjkgCgpH
b29kIHRvIGtub3cgeW91IGhhdmUgdGhlIGZpeC4KClRoYW5rIHlvdSwKVGhvbWFzCgo+IApfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
