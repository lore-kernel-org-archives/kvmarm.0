Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787C9C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 09:46:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAA1721655
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 09:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAA1721655
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6314B847;
	Thu, 17 Sep 2020 05:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Whf8NtxaTa8h; Thu, 17 Sep 2020 05:46:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C06B24B813;
	Thu, 17 Sep 2020 05:46:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E73C74B80C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 05:46:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 888kcSnCDaL4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 05:46:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB044B773
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 05:46:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43A7711D4;
 Thu, 17 Sep 2020 02:46:24 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E903F68F;
 Thu, 17 Sep 2020 02:46:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
Date: Thu, 17 Sep 2020 10:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <198c63d5e9e17ddb4c3848845891301c@kernel.org>
Content-Language: en-US
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGksCgpPbiA5LzE3LzIwIDk6NDIgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIwLTA5
LTE3IDA5OjA0LCBBbmRyZXcgSm9uZXMgd3JvdGU6Cj4+IE9uIFRodSwgU2VwIDE3LCAyMDIwIGF0
IDA4OjQ3OjQyQU0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIDIwMjAtMDktMTcg
MDM6MzAsIFlpbmcgRmFuZyB3cm90ZToKPj4+ID4gQWxsb3cgdXNlcnNwYWNlIHRvIHNldCBNUElE
UiB1c2luZyB2Y3B1IGlvY3RsIEtWTV9BUk1fU0VUX01QX0FGRklOSVRZLAo+Pj4gPiBzbyB0aGF0
IHdlIGNhbiBzdXBwb3J0IGNwdSB0b3BvbG9neSBmb3IgYXJtLgo+Pj4KPj4+IE1QSURSIGhhcyAq
bm90aGluZyogdG8gZG8gd2l0aCBDUFUgdG9wb2xvZ3kgaW4gdGhlIEFSTSBhcmNoaXRlY3R1cmUu
Cj4+PiBJIGVuY291cmFnZSB5b3UgdG8gaGF2ZSBhIGxvb2sgYXQgdGhlIEFSTSBBUk0gYW5kIGZp
bmQgb3V0IGhvdyBvZnRlbgo+Pj4gdGhlIHdvcmQgInRvcG9sb2d5IiBpcyB1c2VkIGluIGNvbmp1
bmN0aW9uIHdpdGggdGhlIE1QSURSX0VMMSByZWdpc3Rlci4KPj4+Cj4+Cj4+IEhpIE1hcmMsCj4+
Cj4+IEkgbW9zdGx5IGFncmVlLiBIb3dldmVyLCB0aGUgQ1BVIHRvcG9sb2d5IGRlc2NyaXB0aW9u
cyB1c2UgTVBJRFIgdG8KPj4gaWRlbnRpZnkgUEVzLiBJZiB1c2Vyc3BhY2Ugd2FudHMgdG8gYnVp
bGQgdG9wb2xvZ3kgZGVzY3JpcHRpb25zIHRoZW4KPj4gaXQgZWl0aGVyIG5lZWRzIHRvCj4+Cj4+
IDEpIGJ1aWxkIHRoZW0gYWZ0ZXIgaW5zdGFudGlhdGluZyBhbGwgS1ZNIFZDUFVzIGluIG9yZGVy
IHRvIHF1ZXJ5IEtWTQo+PiDCoMKgIGZvciBlYWNoIE1QSURSLCBvcgo+PiAyKSBoYXZlIGEgd2F5
IHRvIGFzayBLVk0gZm9yIGFuIE1QSURSIG9mIGdpdmVuIFZDUFUgSUQgaW4gYWR2YW5jZQo+PiDC
oMKgIChtYXliZSBqdXN0IGEgc2NyYXRjaCBWQ1BVKSwgb3IKPj4gMykgaGF2ZSBjb250cm9sIG92
ZXIgdGhlIE1QSURScyBzbyBpdCBjYW4gY2hvb3NlIHRoZW0gd2hlbiBpdCBsaWtlcywKPj4gwqDC
oCB1c2UgdGhlbSBmb3IgdG9wb2xvZ3kgZGVzY3JpcHRpb25zLCBhbmQgdGhlbiBpbnN0YW50aWF0
ZSBLVk0gVkNQVXMKPj4gwqDCoCB3aXRoIHRoZW0uCj4+Cj4+IEkgdGhpbmsgKDMpIGlzIHRoZSBt
b3N0IHJvYnVzdCBhcHByb2FjaCwgYW5kIGl0IGhhcyB0aGUgbGVhc3Qgb3ZlcmhlYWQuCj4KPiBJ
IGRvbid0IGRpc2FncmVlIHdpdGggdGhlIGdvYWwsIGFuZCBub3QgZXZlbiB3aXRoIHRoZSBjaG9p
Y2Ugb2YKPiBpbXBsZW1lbnRhdGlvbiAodGhvdWdoIEkgaGF2ZSBodWdlIHJlc2VydmF0aW9ucyBh
Ym91dCBpdHMgcXVhbGl0eSkuCj4KPiBCdXQgdGhlIGtleSB3b3JkIGhlcmUgaXMgKnVzZXJzcGFj
ZSouIE9ubHkgdXNlcnNwYWNlIGhhcyBhIG5vdGlvbiBvZgo+IGhvdyBNUElEUiB2YWx1ZXMgbWFw
IHRvIHRoZSBhc3N1bWVkIHRvcG9sb2d5LiBUaGF0J3Mgbm90IHNvbWV0aGluZwo+IHRoYXQgS1ZN
IGRvZXMgbm9yIHNob3VsZCBpbnRlcnByZXQgKGFzaWRlIGZyb20gdGhlIEdJQy1pbmR1Y2VkIEFm
ZjAKPiBicmFpbi1kYW1hZ2UpLiBTbyB0YWxraW5nIG9mICJ0b3BvbG9neSIgaW4gYSBLVk0ga2Vy
bmVsIHBhdGNoIHNlbmRzCj4gdGhlIHdyb25nIG1lc3NhZ2UsIGFuZCB0aGF0J3MgYWxsIHRoaXMg
cmVtYXJrIHdhcyBhYm91dC4KClRoZXJlJ3MgYWxzbyBhIHBhdGNoIHF1ZXVlZCBmb3IgbmV4dCB3
aGljaCByZW1vdmVzIHVzaW5nIE1QSURSIGFzIGEgc291cmNlIG9mCmluZm9ybWF0aW9uIGFib3V0
IENQVSB0b3BvbG9neSBbMV06ICJhcm02NDogdG9wb2xvZ3k6IFN0b3AgdXNpbmcgTVBJRFIgZm9y
CnRvcG9sb2d5IGluZm9ybWF0aW9uIi4KCkknbSBub3QgcmVhbGx5IHN1cmUgaG93IHVzZWZ1bCBL
Vk0gZmlkZGxpbmcgd2l0aCB0aGUgZ3Vlc3QgTVBJRFIgd2lsbCBiZSBnb2luZwpmb3J3YXJkLCBh
dCBsZWFzdCBmb3IgYSBMaW51eCBndWVzdC4KClsxXQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9hcm02NC9saW51eC5naXQvY29tbWl0Lz9pZD0zMTAyYmMw
ZTZhYzcKClRoYW5rcywKQWxleApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
