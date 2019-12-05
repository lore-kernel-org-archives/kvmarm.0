Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FF8C43603
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 10:56:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 782B321823
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 10:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IUFpBprd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 782B321823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amsat.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9C34AEC1;
	Thu,  5 Dec 2019 05:56:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SthMe9f+xGHx; Thu,  5 Dec 2019 05:56:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B02BA4AE8D;
	Thu,  5 Dec 2019 05:56:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 719A04A968
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:49:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7lQhDvdcCQiW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 04:49:54 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35AE24A5C6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:49:54 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id j42so2629130wrj.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Dec 2019 01:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=VDCRarATB8BrPGGFa2oJ0ZXIsVlkqssojKkWxJIt7Sw=;
 b=IUFpBprd5cUy49LefBNJcPOz24gxeLYCdnSeVp1swiaikpzNAnnAlqYiGzP2niYWe1
 UvdkMutU0vvWqvDe5BEGqWYvlx9yhm3cpLv7F5nFIBe47KnZpscevQ5mDt8wa25lMhfe
 OnnNqqFGtiXDZ6ApeG7JZWxVHK7UdgDoHf/HFRbFRwa7A81/W5jojgvuKTj1Auy2wECl
 4MMqj9BXx1Ejr3J6Qjk2ENvFaFaLhp8IbqYv51GqaO3KSvVxPFoGi6+bvxgWyiFHdgmU
 Zrh76yVlrfzDW+Ku65z/PfC4NnPmC69s+TonPU3vk+mwQfNOcN3DGhmpFhEMmaaVHTqP
 KD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=VDCRarATB8BrPGGFa2oJ0ZXIsVlkqssojKkWxJIt7Sw=;
 b=KtXL5Dzf8LwTswZgHNqZIr6jrz+rv1Dsj9ykjVd9h7KGSbtxqW0K4unmmtCef+qO3l
 gWed42KXgP5DYsNpE/a5m07FhTWzkodd28dt+3tKqUDCZTWxY36oHqvF1PPwN4KksPx1
 CbQHgg6SsHKFAuBDOZwFDGqbtZX86o3JVpeFVNd6cRqOtKty8LRUjwgSHyASvUXQ7hzC
 YGPZfJsa3gk0SS0oKyV7/lznl0wrDo11j37KUP03dwTZ2cXfI3JzU3UEP6MpsV9NYbSj
 PVOMEJ4ZYmHZNHaz6g3ND+EC0HjbExULl1j97741fKTPDAQVoFVkqpzOj/qe1abW3HqR
 6GDw==
X-Gm-Message-State: APjAAAV3fGJMxB5bP2Szig7p2dCnn0hamrRSCw/bQmfcefLZLQW6C80w
 1Dg/HxbRiR6mbW6unM5Zz1o=
X-Google-Smtp-Source: APXvYqxBtpkgOdAW7CRYJrvAlE0K8uKX4b6YMw5evwxxJGel49FacekG2njBKu1+ODO53PFLBi35DQ==
X-Received: by 2002:adf:eb46:: with SMTP id u6mr9246213wrn.239.1575539393159; 
 Thu, 05 Dec 2019 01:49:53 -0800 (PST)
Received: from [192.168.1.35] (182.red-88-21-103.staticip.rima-tde.net.
 [88.21.103.182])
 by smtp.gmail.com with ESMTPSA id u18sm11562183wrt.26.2019.12.05.01.49.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 05 Dec 2019 01:49:52 -0800 (PST)
Subject: Re: [PATCH v3 07/15] KVM: Refactor error handling for setting memory
 region
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191024230744.14543-8-sean.j.christopherson@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <3b6cd050-2551-d262-aded-051e25044519@amsat.org>
Date: Thu, 5 Dec 2019 10:49:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191024230744.14543-8-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 05 Dec 2019 05:56:16 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

T24gMTAvMjUvMTkgMTowNyBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBSZXBsYWNl
IGEgYmlnIHBpbGUgbycgZ290b3Mgd2l0aCByZXR1cm5zIHRvIG1ha2UgaXQgbW9yZSBvYnZpb3Vz
IHdoYXQKPiBlcnJvciBjb2RlIGlzIGJlaW5nIHJldHVybmVkLCBhbmQgdG8gcHJlcGFyZSBmb3Ig
cmVmYWN0b3JpbmcgdGhlCj4gZnVuY3Rpb25hbCwgaS5lLiBwb3N0LWNoZWNrcywgcG9ydGlvbiBv
ZiBfX2t2bV9zZXRfbWVtb3J5X3JlZ2lvbigpLgo+IAo+IFJldmlld2VkLWJ5OiBKYW5vc2NoIEZy
YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4KPiAtLS0KPiAgIHZpcnQv
a3ZtL2t2bV9tYWluLmMgfCA0MCArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0p
Cj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFp
bi5jCj4gaW5kZXggYTQzOTAyZDkwMzZkLi5lMmY0N2Q2MGY2OTYgMTAwNjQ0Cj4gLS0tIGEvdmly
dC9rdm0va3ZtX21haW4uYwo+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKPiBAQCAtOTQyLDM0
ICs5NDIsMzMgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0gKmt2bSwK
PiAgIAo+ICAgCXIgPSBjaGVja19tZW1vcnlfcmVnaW9uX2ZsYWdzKG1lbSk7Cj4gICAJaWYgKHIp
Cj4gLQkJZ290byBvdXQ7Cj4gKwkJcmV0dXJuIHI7Cj4gICAKPiAtCXIgPSAtRUlOVkFMOwo+ICAg
CWFzX2lkID0gbWVtLT5zbG90ID4+IDE2Owo+ICAgCWlkID0gKHUxNiltZW0tPnNsb3Q7Cj4gICAK
PiAgIAkvKiBHZW5lcmFsIHNhbml0eSBjaGVja3MgKi8KPiAgIAlpZiAobWVtLT5tZW1vcnlfc2l6
ZSAmIChQQUdFX1NJWkUgLSAxKSkKPiAtCQlnb3RvIG91dDsKPiArCQlyZXR1cm4gLUVJTlZBTDsK
PiAgIAlpZiAobWVtLT5ndWVzdF9waHlzX2FkZHIgJiAoUEFHRV9TSVpFIC0gMSkpCj4gLQkJZ290
byBvdXQ7Cj4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4gICAJLyogV2UgY2FuIHJlYWQgdGhlIGd1ZXN0
IG1lbW9yeSB3aXRoIF9feHh4X3VzZXIoKSBsYXRlciBvbi4gKi8KPiAgIAlpZiAoKGlkIDwgS1ZN
X1VTRVJfTUVNX1NMT1RTKSAmJgo+ICAgCSAgICAoKG1lbS0+dXNlcnNwYWNlX2FkZHIgJiAoUEFH
RV9TSVpFIC0gMSkpIHx8Cj4gICAJICAgICAhYWNjZXNzX29rKCh2b2lkIF9fdXNlciAqKSh1bnNp
Z25lZCBsb25nKW1lbS0+dXNlcnNwYWNlX2FkZHIsCj4gICAJCQltZW0tPm1lbW9yeV9zaXplKSkp
Cj4gLQkJZ290byBvdXQ7Cj4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4gICAJaWYgKGFzX2lkID49IEtW
TV9BRERSRVNTX1NQQUNFX05VTSB8fCBpZCA+PSBLVk1fTUVNX1NMT1RTX05VTSkKPiAtCQlnb3Rv
IG91dDsKPiArCQlyZXR1cm4gLUVJTlZBTDsKPiAgIAlpZiAobWVtLT5ndWVzdF9waHlzX2FkZHIg
KyBtZW0tPm1lbW9yeV9zaXplIDwgbWVtLT5ndWVzdF9waHlzX2FkZHIpCj4gLQkJZ290byBvdXQ7
Cj4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4gICAKPiAgIAlzbG90ID0gaWRfdG9fbWVtc2xvdChfX2t2
bV9tZW1zbG90cyhrdm0sIGFzX2lkKSwgaWQpOwo+ICAgCWJhc2VfZ2ZuID0gbWVtLT5ndWVzdF9w
aHlzX2FkZHIgPj4gUEFHRV9TSElGVDsKPiAgIAlucGFnZXMgPSBtZW0tPm1lbW9yeV9zaXplID4+
IFBBR0VfU0hJRlQ7Cj4gICAKPiAgIAlpZiAobnBhZ2VzID4gS1ZNX01FTV9NQVhfTlJfUEFHRVMp
Cj4gLQkJZ290byBvdXQ7Cj4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4gICAKPiAgIAluZXcgPSBvbGQg
PSAqc2xvdDsKPiAgIAo+IEBAIC05ODYsMjAgKzk4NSwxOCBAQCBpbnQgX19rdm1fc2V0X21lbW9y
eV9yZWdpb24oc3RydWN0IGt2bSAqa3ZtLAo+ICAgCQkJaWYgKChuZXcudXNlcnNwYWNlX2FkZHIg
IT0gb2xkLnVzZXJzcGFjZV9hZGRyKSB8fAo+ICAgCQkJICAgIChucGFnZXMgIT0gb2xkLm5wYWdl
cykgfHwKPiAgIAkJCSAgICAoKG5ldy5mbGFncyBeIG9sZC5mbGFncykgJiBLVk1fTUVNX1JFQURP
TkxZKSkKPiAtCQkJCWdvdG8gb3V0Owo+ICsJCQkJcmV0dXJuIC1FSU5WQUw7Cj4gICAKPiAgIAkJ
CWlmIChiYXNlX2dmbiAhPSBvbGQuYmFzZV9nZm4pCj4gICAJCQkJY2hhbmdlID0gS1ZNX01SX01P
VkU7Cj4gICAJCQllbHNlIGlmIChuZXcuZmxhZ3MgIT0gb2xkLmZsYWdzKQo+ICAgCQkJCWNoYW5n
ZSA9IEtWTV9NUl9GTEFHU19PTkxZOwo+IC0JCQllbHNlIHsgLyogTm90aGluZyB0byBjaGFuZ2Uu
ICovCj4gLQkJCQlyID0gMDsKPiAtCQkJCWdvdG8gb3V0Owo+IC0JCQl9Cj4gKwkJCWVsc2UgLyog
Tm90aGluZyB0byBjaGFuZ2UuICovCj4gKwkJCQlyZXR1cm4gMDsKPiAgIAkJfQo+ICAgCX0gZWxz
ZSB7Cj4gICAJCWlmICghb2xkLm5wYWdlcykKPiAtCQkJZ290byBvdXQ7Cj4gKwkJCXJldHVybiAt
RUlOVkFMOwo+ICAgCj4gICAJCWNoYW5nZSA9IEtWTV9NUl9ERUxFVEU7Cj4gICAJCW5ldy5iYXNl
X2dmbiA9IDA7Cj4gQEAgLTEwMDgsMjkgKzEwMDUsMjkgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlf
cmVnaW9uKHN0cnVjdCBrdm0gKmt2bSwKPiAgIAo+ICAgCWlmICgoY2hhbmdlID09IEtWTV9NUl9D
UkVBVEUpIHx8IChjaGFuZ2UgPT0gS1ZNX01SX01PVkUpKSB7Cj4gICAJCS8qIENoZWNrIGZvciBv
dmVybGFwcyAqLwo+IC0JCXIgPSAtRUVYSVNUOwo+ICAgCQlrdm1fZm9yX2VhY2hfbWVtc2xvdChz
bG90LCBfX2t2bV9tZW1zbG90cyhrdm0sIGFzX2lkKSkgewo+ICAgCQkJaWYgKHNsb3QtPmlkID09
IGlkKQo+ICAgCQkJCWNvbnRpbnVlOwo+ICAgCQkJaWYgKCEoKGJhc2VfZ2ZuICsgbnBhZ2VzIDw9
IHNsb3QtPmJhc2VfZ2ZuKSB8fAo+ICAgCQkJICAgICAgKGJhc2VfZ2ZuID49IHNsb3QtPmJhc2Vf
Z2ZuICsgc2xvdC0+bnBhZ2VzKSkpCj4gLQkJCQlnb3RvIG91dDsKPiArCQkJCXJldHVybiAtRUVY
SVNUOwo+ICAgCQl9Cj4gICAJfQo+ICAgCj4gLQlyID0gLUVOT01FTTsKPiAtCj4gICAJLyogQWxs
b2NhdGUvZnJlZSBwYWdlIGRpcnR5IGJpdG1hcCBhcyBuZWVkZWQgKi8KPiAgIAlpZiAoIShuZXcu
ZmxhZ3MgJiBLVk1fTUVNX0xPR19ESVJUWV9QQUdFUykpCj4gICAJCW5ldy5kaXJ0eV9iaXRtYXAg
PSBOVUxMOwo+ICAgCWVsc2UgaWYgKCFuZXcuZGlydHlfYml0bWFwKSB7Cj4gLQkJaWYgKGt2bV9j
cmVhdGVfZGlydHlfYml0bWFwKCZuZXcpIDwgMCkKPiAtCQkJZ290byBvdXQ7Cj4gKwkJciA9IGt2
bV9jcmVhdGVfZGlydHlfYml0bWFwKCZuZXcpOwo+ICsJCWlmIChyKQo+ICsJCQlyZXR1cm4gcjsK
ClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8ZjRidWdAYW1zYXQub3JnPgoK
PiAgIAl9Cj4gICAKPiAgIAlzbG90cyA9IGt2emFsbG9jKHNpemVvZihzdHJ1Y3Qga3ZtX21lbXNs
b3RzKSwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKPiAtCWlmICghc2xvdHMpCj4gKwlpZiAoIXNsb3Rz
KSB7Cj4gKwkJciA9IC1FTk9NRU07Cj4gICAJCWdvdG8gb3V0X2JpdG1hcDsKPiArCX0KPiAgIAlt
ZW1jcHkoc2xvdHMsIF9fa3ZtX21lbXNsb3RzKGt2bSwgYXNfaWQpLCBzaXplb2Yoc3RydWN0IGt2
bV9tZW1zbG90cykpOwo+ICAgCj4gICAJaWYgKChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVURSkgfHwg
KGNoYW5nZSA9PSBLVk1fTVJfTU9WRSkpIHsKPiBAQCAtMTA4MSw3ICsxMDc4LDYgQEAgaW50IF9f
a3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0gKmt2bSwKPiAgIG91dF9iaXRtYXA6Cj4g
ICAJaWYgKG5ldy5kaXJ0eV9iaXRtYXAgJiYgIW9sZC5kaXJ0eV9iaXRtYXApCj4gICAJCWt2bV9k
ZXN0cm95X2RpcnR5X2JpdG1hcCgmbmV3KTsKPiAtb3V0Ogo+ICAgCXJldHVybiByOwo+ICAgfQo+
ICAgRVhQT1JUX1NZTUJPTF9HUEwoX19rdm1fc2V0X21lbW9yeV9yZWdpb24pOwo+IApfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
