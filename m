Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BD4C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 06:39:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B9CC20829
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 06:39:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B9CC20829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A23044B432;
	Fri, 31 Jul 2020 02:39:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EIzPcJnQLDzr; Fri, 31 Jul 2020 02:39:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811194B3B6;
	Fri, 31 Jul 2020 02:39:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 146E14B3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 02:39:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lImoThoINf4z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 02:39:43 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 402984B3AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 02:39:42 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id DD9B19CED4C9D6C8A047;
 Fri, 31 Jul 2020 14:39:37 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0;
 Fri, 31 Jul 2020 14:39:30 +0800
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To: Paolo Bonzini <pbonzini@redhat.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
From: Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
Date: Fri, 31 Jul 2020 14:39:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Cc: gleb@redhat.com, kvm@vger.kernel.org, "S. Tsirkin,
 Michael" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC83LzMxIDI6MDMsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gWWVzLCBJIHRoaW5rIGl0
J3Mgbm90IG5lZWRlZC4gUHJvYmFibHkgdGhlIGRlYXNzaWduIGNoZWNrIGNhbiBiZSB0dXJuZWQg
aW50byBhbiBhc3NlcnRpb24/Cj4gCj4gUGFvbG8KPiAKCkkgdGhpbmsgd2UgY2FuIGRvIHRoaXMg
aW4gdGhlIHNhbWUgZnVuY3Rpb24sIGFuZCB0dXJudCBoZSBjaGVjayBvZgpwLT5ldmVudGZkIGlu
dG8gYXNzZXJ0aW9uIGluIGt2bV9kZWFzc2lnbl9pb2V2ZW50ZmRfaWR4KCkuIEp1c3QgbGlrZToK
Ci0tLTg8LS0tCnN0YXRpYyBpbmxpbmUgc3RydWN0IF9pb2V2ZW50ZmQgKgpnZXRfaW9ldmVudGZk
KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsCiAgICAgICAgICAgICAgc3Ry
dWN0IGt2bV9pb2V2ZW50ZmQgKmFyZ3MpCnsKICAgICAgICBzdGF0aWMgc3RydWN0IF9pb2V2ZW50
ZmQgKl9wOwogICAgICAgIGJvb2wgd2lsZGNhcmQgPSAhKGFyZ3MtPmZsYWdzICYgS1ZNX0lPRVZF
TlRGRF9GTEFHX0RBVEFNQVRDSCk7CgogICAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkoX3AsICZr
dm0tPmlvZXZlbnRmZHMsIGxpc3QpCiAgICAgICAgICAgICAgICBpZiAoX3AtPmJ1c19pZHggPT0g
YnVzX2lkeCAmJgogICAgICAgICAgICAgICAgICAgIF9wLT5hZGRyID09IGFyZ3MtPmFkZHIgJiYK
ICAgICAgICAgICAgICAgICAgICAoIV9wLT5sZW5ndGggfHwgIWFyZ3MtPmxlbiB8fAogICAgICAg
ICAgICAgICAgICAgICAoX3AtPmxlbmd0aCA9PSBhcmdzLT5sZW4gJiYKICAgICAgICAgICAgICAg
ICAgICAgIChfcC0+d2lsZGNhcmQgfHwgd2lsZGNhcmQgfHwKICAgICAgICAgICAgICAgICAgICAg
ICBfcC0+ZGF0YW1hdGNoID09IGFyZ3MtPmRhdGFtYXRjaCkpKSkKICAgICAgICAgICAgICAgICAg
ICAgICAgcmV0dXJuIF9wOwoKICAgICAgICByZXR1cm4gTlVMTDsKfQoKa3ZtX2RlYXNzaWduX2lv
ZXZlbnRmZF9pZHgoKSB7CgkuLi4KCXAgPSBnZXRfaW9ldmVudGZkKGt2bSwgYnVzX2lkeCwgYXJn
cyk7CglpZiAocCkgewoJCWFzc2VydChwLT5ldmVudGZkID09IGV2ZW50ZmQpOwoJCS4uLgoJfQoK
LS0tODwtLS0tCgpUaGlzIG1heSBiZSBlYXNpZXIgdG8gdW5kZXJzdGFuZCAoa2VlcCB0aGUgc2Ft
ZSBsb2dpYyBpbiBhc3NpZ24vZGVhc3NpZ24pLgoKSSB3aWxsIHNlbmQgYSBmb3JtYWwgcGF0Y2gg
c29vbi4KClRoYW5rcywKWmhlbnl1CgoKPiBJbCBnaW8gMzAgbHVnIDIwMjAsIDE2OjM2IFpoZW55
dSBZZSA8eWV6aGVueXUyQGh1YXdlaS5jb20gPG1haWx0bzp5ZXpoZW55dTJAaHVhd2VpLmNvbT4+
IGhhIHNjcml0dG86Cj4gCj4gICAgIEhpIGFsbCwKPiAKPiAgICAgVGhlcmUgYXJlIGNoZWNrcyBv
ZiBpb2V2ZW50ZmQgY29sbGlzaW9uIGluIGJvdGgga3ZtX2Fzc2lnbl9pb2V2ZW50ZmRfaWR4KCkK
PiAgICAgYW5kIGt2bV9kZWFzc2lnbl9pb2V2ZW50ZmRfaWR4KCksIGhvd2V2ZXIsIHdpdGggZGlm
ZmVyZW50IGxvZ2ljLgo+IAo+ICAgICBJbiBrdm1fYXNzaWduX2lvZXZlbnRmZF9pZHgoKSwgdGhp
cyBpcyBkb25lIGJ5IGlvZXZlbnRmZF9jaGVja19jb2xsaXNpb24oKToKPiAgICAgLS0tODwtLS0K
PiAgICAgwqAgwqAgwqAgwqAgaWYgKF9wLT5idXNfaWR4ID09IHAtPmJ1c19pZHggJiYKPiAgICAg
wqAgwqAgwqAgwqAgwqAgwqAgX3AtPmFkZHIgPT0gcC0+YWRkciAmJgo+ICAgICDCoCDCoCDCoCDC
oCDCoCDCoCAoIV9wLT5sZW5ndGggfHwgIXAtPmxlbmd0aCB8fAo+ICAgICDCoCDCoCDCoCDCoCDC
oCDCoCDCoChfcC0+bGVuZ3RoID09IHAtPmxlbmd0aCAmJgo+ICAgICDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAoX3AtPndpbGRjYXJkIHx8IHAtPndpbGRjYXJkIHx8Cj4gICAgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgX3AtPmRhdGFtYXRjaCA9PSBwLT5kYXRhbWF0Y2gpKSkpCj4gICAgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC8vIHRoZW4gd2UgY29uc2lkZXIgdGhlIHR3byBhcmUgdGhlIHNhbWUK
PiAgICAgLS0tODwtLS0KPiAKPiAgICAgVGhlIGxvZ2ljIGluIGt2bV9kZWFzc2lnbl9pb2V2ZW50
ZmRfaWR4KCkgaXMgYXMgZm9sbG93czoKPiAgICAgLS0tODwtLS0KPiAgICAgwqAgwqAgwqAgwqAg
aWYgKHAtPmJ1c19pZHggIT0gYnVzX2lkeCB8fAo+ICAgICDCoCDCoCDCoCDCoCDCoCDCoCBwLT5l
dmVudGZkICE9IGV2ZW50ZmTCoCB8fAo+ICAgICDCoCDCoCDCoCDCoCDCoCDCoCBwLT5hZGRyICE9
IGFyZ3MtPmFkZHLCoCB8fAo+ICAgICDCoCDCoCDCoCDCoCDCoCDCoCBwLT5sZW5ndGggIT0gYXJn
cy0+bGVuIHx8Cj4gICAgIMKgIMKgIMKgIMKgIMKgIMKgIHAtPndpbGRjYXJkICE9IHdpbGRjYXJk
KQo+ICAgICDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb250aW51ZTsKPiAKPiAgICAgwqAgwqAg
wqAgwqAgaWYgKCFwLT53aWxkY2FyZCAmJiBwLT5kYXRhbWF0Y2ggIT0gYXJncy0+ZGF0YW1hdGNo
KQo+ICAgICDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb250aW51ZTsKPiAKPiAgICAgwqAgwqAg
wqAgwqAgLy8gdGhlbiB3ZSBjb25zaWRlciB0aGUgdHdvIGFyZSB0aGUgc2FtZQo+ICAgICAtLS04
PC0tLQo+IAo+ICAgICBBcyB3ZSBjYW4gc2VlLCB0aGVyZSBpcyBleHRyYSBjaGVjayBvZiBwLT5l
dmVudGZkIGluCj4gCj4gICAgICgpLsKgIFdoeSB3ZSBkb24ndCBjaGVjayBwLT5ldmVudGZkCj4g
ICAgIGluIGt2bV9hc3NpZ25faW9ldmVudGZkX2lkeCgpPyBPciBzaG91bGQgd2UgZGVsZXRlIHRo
aXMgaW4KPiAgICAga3ZtX2RlYXNzaWduX2lvZXZlbnRmZF9pZHgoKT8KPiAKPiAKPiAgICAgVGhh
bmtzLAo+ICAgICBaaGVueXUKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
