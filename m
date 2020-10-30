Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7B5C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:43:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE3162075E
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE3162075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3E54B3A1;
	Fri, 30 Oct 2020 04:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oHcgcy7o9JzY; Fri, 30 Oct 2020 04:43:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 321844B3A3;
	Fri, 30 Oct 2020 04:43:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 977E54B216
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:16:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8blyKMp6+WEe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 04:16:46 -0400 (EDT)
Received: from r3-21.sinamail.sina.com.cn (r3-21.sinamail.sina.com.cn
 [202.108.3.21])
 by mm01.cs.columbia.edu (Postfix) with SMTP id EC29B4B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:16:45 -0400 (EDT)
Received: from unknown (HELO [192.168.0.213])([103.10.86.235])
 by sina.com with ESMTP
 id 5F9BCBBB00019AB2; Fri, 30 Oct 2020 16:16:03 +0800 (CST)
X-Sender: xu910121@sina.com
X-Auth-ID: xu910121@sina.com
X-SMAIL-MID: 267311629001
Subject: Re: [PATCH 0/3] KVM: arm64: Fix get-reg-list regression
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20201029201105.101910-1-drjones@redhat.com>
From: =?UTF-8?B?5byg5Lic5pet?= <xu910121@sina.com>
Message-ID: <8ad6dc36-0bd4-4f50-1bd8-2194d34b2cba@sina.com>
Date: Fri, 30 Oct 2020 16:15:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029201105.101910-1-drjones@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 30 Oct 2020 04:43:02 -0400
Cc: maz@kernel.org, Dave.Martin@arm.com
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

5ZyoIDIwMjAvMTAvMzAg5LiK5Y2INDoxMSwgQW5kcmV3IEpvbmVzIOWGmemBkzoKPiDlvKDkuJzm
l60gPHh1OTEwMTIxQHNpbmEuY29tPiByZXBvcnRlZCBhIHJlZ3Jlc3Npb24gc2VlbiB3aXRoIENl
bnRPUwo+IHdoZW4gbWlncmF0aW5nIGZyb20gYW4gb2xkIGtlcm5lbCB0byBhIG5ldyBvbmUuIFRo
ZSBwcm9ibGVtIHdhcwo+IHRoYXQgUUVNVSByZWplY3RlZCB0aGUgbWlncmF0aW9uIHNpbmNlIEtW
TV9HRVRfUkVHX0xJU1QgcmVwb3J0ZWQKPiBhIHJlZ2lzdGVyIHdhcyBtaXNzaW5nIG9uIHRoZSBk
ZXN0aW5hdGlvbi4gRXh0cmEgcmVnaXN0ZXJzIGFyZSBPSwo+IG9uIHRoZSBkZXN0aW5hdGlvbiwg
YnV0IG5vdCBtaXNzaW5nIG9uZXMuIFRoZSByZWdyZXNzaW9uIHJlcHJvZHVjZXMKPiB3aXRoIHVw
c3RyZWFtIGtlcm5lbHMgd2hlbiBtaWdyYXRpbmcgZnJvbSBhIDQuMTUgb3IgbGF0ZXIga2VybmVs
LAo+IHVwIHRvIG9uZSB3aXRoIGNvbW1pdCA3MzQzMzc2MmZjYWUgKCJLVk06IGFybTY0L3N2ZTog
U3lzdGVtIHJlZ2lzdGVyCj4gY29udGV4dCBzd2l0Y2ggYW5kIGFjY2VzcyBzdXBwb3J0IiksIHRv
IGEga2VybmVsIHRoYXQgaW5jbHVkZXMgdGhhdAo+IGNvbW1pdCwgZS5nLiB0aGUgbGF0ZXN0IG1h
aW5saW5lICg1LjEwLXJjMSkuCj4KPiBUaGUgZmlyc3QgcGF0Y2ggb2YgdGhpcyBzZXJpZXMgaXMg
dGhlIGZpeC4gVGhlIG5leHQgdHdvIHBhdGNoZXMsCj4gd2hpY2ggZG9uJ3QgaGF2ZSBhbnkgaW50
ZW5kZWQgZnVuY3Rpb25hbCBjaGFuZ2VzLCBhbGxvdyBJRF9TQU5JVElTRUQKPiB0byBiZSB1c2Vk
IGZvciByZWdpc3RlcnMgdGhhdCBmbGlwIGJldHdlZW4gZXhwb3NpbmcgZmVhdHVyZXMgYW5kCj4g
YmVpbmcgUkFaLCB3aGljaCBhbGxvd3Mgc29tZSBjb2RlIHRvIGJlIHJlbW92ZWQuCj4KPiBBbmRy
ZXcgSm9uZXMgKDMpOgo+ICAgIEtWTTogYXJtNjQ6IERvbid0IGhpZGUgSUQgcmVnaXN0ZXJzIGZy
b20gdXNlcnNwYWNlCj4gICAgS1ZNOiBhcm02NDogQ2hlY2sgUkFaIHZpc2liaWxpdHkgaW4gSUQg
cmVnaXN0ZXIgYWNjZXNzb3JzCj4gICAgS1ZNOiBhcm02NDogUmVtb3ZlIEFBNjRaRlIwX0VMMSBh
Y2Nlc3NvcnMKPgo+ICAgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8IDk2ICsrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
aCB8IDIwICsrKysrKysrCj4gICAyIGZpbGVzIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKyksIDY5
IGRlbGV0aW9ucygtKQo+CmdyZWF0ISBJIHdpbGwgYXBwbHkgdGhlc2UgcGF0Y2hlcyBhbmQgaGF2
ZSBhIHRyeS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
