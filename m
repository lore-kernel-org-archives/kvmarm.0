Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DE8CA9EBE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 09:08:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A7AA21929
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 09:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A7AA21929
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6514A5A8;
	Fri, 25 Oct 2019 05:08:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rnY78678rAuz; Fri, 25 Oct 2019 05:08:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D64C04A5BD;
	Fri, 25 Oct 2019 05:08:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 194C44A5A8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 05:08:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dg3EZu5Yhr-h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 05:08:07 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3262B4A51D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 05:08:07 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 718267F90D984722DF34;
 Fri, 25 Oct 2019 17:08:03 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 17:07:55 +0800
Subject: Re: [PATCH v2] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
To: Marc Zyngier <maz@kernel.org>
References: <1571802386-2680-1-git-send-email-yuzenghui@huawei.com>
 <0f99f6a4ea567f53d38fb3bc0e6f59e4@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6bc4a648-4308-3ff8-8e73-d90040e74c99@huawei.com>
Date: Fri, 25 Oct 2019 17:06:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <0f99f6a4ea567f53d38fb3bc0e6f59e4@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: jason@lakedaemon.net, jiayanlei@huawei.com,
 LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAxOS8xMC8yNSAxNjoyNCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMTktMTAtMjMg
MDQ6NDYsIFplbmdodWkgWXUgd3JvdGU6Cj4+IE9uIGEgc3lzdGVtIHdpdGhvdXQgU2luZ2xlIFZN
T1ZQIHN1cHBvcnQgKHNheSBHSVRTX1RZUEVSLlZNT1ZQID09IDApLAo+PiB3ZSB3aWxsIG1hcCB2
UEVzIG9ubHkgb24gSVRTcyB0aGF0IHdpbGwgYWN0dWFsbHkgY29udHJvbCBpbnRlcnJ1cHRzCj4+
IGZvciB0aGUgZ2l2ZW4gVk0uwqAgQW5kIHdoZW4gbW92aW5nIGEgdlBFLCB0aGUgVk1PVlAgY29t
bWFuZCB3aWxsIGJlCj4+IGlzc3VlZCBvbmx5IGZvciB0aG9zZSBJVFNzLgo+Pgo+PiBCdXQgd2hl
biBpc3N1aW5nIFZNT1ZQcyB3ZSBzZWVtZWQgZmFpbCB0byBwcmVzZW50IHRoZSBleGFjdCBJVFNM
aXN0Cj4+IHRvIElUU3Mgd2hvIGFyZSBhY3R1YWxseSBpbmNsdWRlZCBpbiB0aGUgc3luY2hyb25p
emF0aW9uIG9wZXJhdGlvbi4KPj4gVGhlIGl0c19saXN0X21hcCB3ZSdyZSBjdXJyZW50bHkgdXNp
bmcgaW5jbHVkZXMgYWxsIElUU3MgaW4gdGhlIHN5c3RlbSwKPj4gZXZlbiB0aG91Z2ggc29tZSBv
ZiB0aGVtIGRvbid0IGhhdmUgdGhlIGNvcnJlc3BvbmRpbmcgdlBFIG1hcHBpbmcgYXQgYWxsLgo+
Pgo+PiBJbnRyb2R1Y2UgZ2V0X2l0c19saXN0KCkgdG8gZ2V0IHRoZSBwZXItVk0gaXRzX2xpc3Rf
bWFwLCB0byBpbmRpY2F0ZQo+PiB3aGljaCBJVFNzIGhhdmUgdlBFIG1hcHBpbmdzIGZvciB0aGUg
Z2l2ZW4gVk0sIGFuZCB1c2UgdGhpcyBtYXAgYXMKPj4gdGhlIGV4cGVjdGVkIElUU0xpc3Qgd2hl
biBidWlsZGluZyBWTU9WUC4gVGhpcyBpcyBob3BlZnVsbHkgYSBwZXJmb3JtYW5jZQo+PiBnYWlu
IG5vdCB0byBkbyBzb21lIHN5bmNocm9uaXphdGlvbiB3aXRoIHRob3NlIHVuc3VzcGVjdGluZyBJ
VFNzLgo+PiBBbmQgaW5pdGlhbGl6ZSB0aGUgd2hvbGUgY29tbWFuZCBkZXNjcmlwdG9yIHRvIHpl
cm8gYXQgYmVnaW5uaW5nLCBzaW5jZQo+PiB0aGUgc2VxX251bSBhbmQgaXRzX2xpc3Qgc2hvdWxk
IGJlIFJFUzAgd2hlbiBHSVRTX1RZUEVSLlZNT1ZQID09IDEuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6
IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+IAo+IEkndmUgYXBwbGllZCB0aGlz
IGFzIGEgZml4IGZvciA1LjQuIEluIHRoZSBmdXR1cmUsIHBsZWFzZSBjYyBMS01MIG9uIGFsbAo+
IElSUS1yZWxhdGVkIHBhdGNoZXMgKGFzIGRvY3VtZW50ZWQgaW4gTUFJTlRBSU5FUlMpLgoKSSBn
b3QgaXQsIHRoYW5rcy4KCgpaZW5naHVpCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
