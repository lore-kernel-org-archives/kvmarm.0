Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065AEC38A2E
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC856208FE
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qqWsPrEf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC856208FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amsat.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A75B4B211;
	Wed, 15 Apr 2020 05:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mcPD+tGzLzjN; Wed, 15 Apr 2020 05:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405184B225;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CBF64B1D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 02:36:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iH+mSSJfCLzP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 02:36:20 -0400 (EDT)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
 [209.85.208.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DECA4B126
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 02:36:20 -0400 (EDT)
Received: by mail-ed1-f66.google.com with SMTP id w4so3147316edv.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 23:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:subject:to:cc:references:from:autocrypt:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ziy3CvjiTZBb7re9okjvNzQcGH3k+TOTS0/15gywnMU=;
 b=qqWsPrEf0Ts6quEdGNgBCMsV+kOpY8DsnLT8o+GDgNvhTV7DBX8PBknwe8j0CFEmZX
 jpltKjKxsibH1qtE9Pf+Yz7+KL62s7h7jGgyQlIBJ/TlhWE5yR2c4gr+7Tj1c78y1fr6
 +Zrz2j6Hmf3jl/P4hZRQjAS6AYMTJfyK4LyMEMf53j3sfn38rtV0w5wPuRetHtwAIhxz
 pWb4hDPYcN9P2BvtRDpRaqKHmXbtsK7GhxWOnwkikmDYVI0XvWIhVDDk0RLbEDIYG847
 +cFNtefbyrNvpUo935pS2ws6qM5Vz4D5kiUbknZ6Gro0unFWFR9g7XFcFYGMgY7GmiKA
 lYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=ziy3CvjiTZBb7re9okjvNzQcGH3k+TOTS0/15gywnMU=;
 b=JpZgPoM2qzywD10/2HynzFpcQZxB0YhqbgW26WiE3kpgCWlEY831L5+00TH7pTBk8T
 xHiqMZNV4IQr3pUQeRSTkqhLSOPp8u5/UwHxpmW/igHoas0qEVf9kx6WsVIuDZYGOeyk
 Tl8jTUL9YvIx537yfPRQmFg1QSx00bm7brLNo8UA+s9o+h+wl9nLGWsetXNfHjH++Dcp
 RobG09b5CtNvptxVwzv9W7bkwBLQWStuNl2hlTDhG3+CjUx52MdOP3nzK2qbgIqXwJej
 yvgKdJqWpazu5134Wqzj8ymmtHgHl+djB+VAyz9O8/o0bJTgq4xK8LMC0ib73DSpDB0F
 M1LA==
X-Gm-Message-State: AGi0PuZFl7Pqw9Opl/wcMS8aY0QWjs/FE+sbu2V5U9F1U6fo00TYEdGQ
 2FBGEbSzYexbEu0maHbXSeo=
X-Google-Smtp-Source: APiQypLBhzQGFSJJza9fhbUNOdf67Ws8AWLLrc2T019xWRRZvN78jvwPXZ4Cq/fMHCh3e7IoI3AkbQ==
X-Received: by 2002:aa7:cf15:: with SMTP id a21mr15771536edy.349.1586932578974; 
 Tue, 14 Apr 2020 23:36:18 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net.
 [83.42.57.116])
 by smtp.gmail.com with ESMTPSA id y10sm2423364ejm.3.2020.04.14.23.36.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Apr 2020 23:36:18 -0700 (PDT)
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>, kvm@vger.kernel.org
References: <20200414155625.20559-1-eesposit@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
Date: Wed, 15 Apr 2020 08:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414155625.20559-1-eesposit@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

T24gNC8xNC8yMCA1OjU2IFBNLCBFbWFudWVsZSBHaXVzZXBwZSBFc3Bvc2l0byB3cm90ZToKPiBU
aGUgbWFjcm9zIFZNX1NUQVQgYW5kIFZDUFVfU1RBVCBhcmUgcmVkdW5kYW50bHkgaW1wbGVtZW50
ZWQgaW4gbXVsdGlwbGUKPiBmaWxlcywgZWFjaCB1c2VkIGJ5IGEgZGlmZmVyZW50IGFyY2hpdGVj
dXJlIHRvIGluaXRpYWxpemUgdGhlIGRlYnVnZnMKPiBlbnRyaWVzIGZvciBzdGF0aXN0aWNzLiBT
aW5jZSB0aGV5IGFsbCBoYXZlIHRoZSBzYW1lIHB1cnBvc2UsIHRoZXkgY2FuIGJlCj4gdW5pZmll
ZCBpbiBhIHNpbmdsZSBjb21tb24gZGVmaW5pdGlvbiBpbiBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0
LmgKPiAKPiBTaWduZWQtb2ZmLWJ5OiBFbWFudWVsZSBHaXVzZXBwZSBFc3Bvc2l0byA8ZWVzcG9z
aXRAcmVkaGF0LmNvbT4KPiAtLS0KPiAgYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyAgICB8ICAyMyAr
Ky0tLQo+ICBhcmNoL21pcHMva3ZtL21pcHMuYyAgICAgIHwgIDYxICsrKysrKy0tLS0tLQo+ICBh
cmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5jIHwgIDYxICsrKysrKy0tLS0tLQo+ICBhcmNoL3Bvd2Vy
cGMva3ZtL2Jvb2tlLmMgIHwgIDQxICsrKystLS0tCj4gIGFyY2gvczM5MC9rdm0va3ZtLXMzOTAu
YyAgfCAyMDMgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgYXJjaC94
ODYva3ZtL3g4Ni5jICAgICAgICB8ICA4MCArKysrKysrLS0tLS0tLS0KPiAgaW5jbHVkZS9saW51
eC9rdm1faG9zdC5oICB8ICAgNSArCj4gIDcgZmlsZXMgY2hhbmdlZCwgMjMxIGluc2VydGlvbnMo
KyksIDI0MyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vZ3Vl
c3QuYyBiL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKPiBpbmRleCAyM2ViZTUxNDEwZjAuLjg0MTdi
MjAwYmVjOSAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9ndWVzdC5jCj4gKysrIGIvYXJj
aC9hcm02NC9rdm0vZ3Vlc3QuYwo+IEBAIC0yOSwyMCArMjksMTcgQEAKPiAgCj4gICNpbmNsdWRl
ICJ0cmFjZS5oIgo+ICAKPiAtI2RlZmluZSBWTV9TVEFUKHgpIHsgI3gsIG9mZnNldG9mKHN0cnVj
dCBrdm0sIHN0YXQueCksIEtWTV9TVEFUX1ZNIH0KPiAtI2RlZmluZSBWQ1BVX1NUQVQoeCkgeyAj
eCwgb2Zmc2V0b2Yoc3RydWN0IGt2bV92Y3B1LCBzdGF0LngpLCBLVk1fU1RBVF9WQ1BVIH0KPiAt
Cj4gIHN0cnVjdCBrdm1fc3RhdHNfZGVidWdmc19pdGVtIGRlYnVnZnNfZW50cmllc1tdID0gewo+
IC0JVkNQVV9TVEFUKGhhbHRfc3VjY2Vzc2Z1bF9wb2xsKSwKPiAtCVZDUFVfU1RBVChoYWx0X2F0
dGVtcHRlZF9wb2xsKSwKPiAtCVZDUFVfU1RBVChoYWx0X3BvbGxfaW52YWxpZCksCj4gLQlWQ1BV
X1NUQVQoaGFsdF93YWtldXApLAo+IC0JVkNQVV9TVEFUKGh2Y19leGl0X3N0YXQpLAo+IC0JVkNQ
VV9TVEFUKHdmZV9leGl0X3N0YXQpLAo+IC0JVkNQVV9TVEFUKHdmaV9leGl0X3N0YXQpLAo+IC0J
VkNQVV9TVEFUKG1taW9fZXhpdF91c2VyKSwKPiAtCVZDUFVfU1RBVChtbWlvX2V4aXRfa2VybmVs
KSwKPiAtCVZDUFVfU1RBVChleGl0cyksCj4gKwlWQ1BVX1NUQVQoImhhbHRfc3VjY2Vzc2Z1bF9w
b2xsIiwgaGFsdF9zdWNjZXNzZnVsX3BvbGwpLAo+ICsJVkNQVV9TVEFUKCJoYWx0X2F0dGVtcHRl
ZF9wb2xsIiwgaGFsdF9hdHRlbXB0ZWRfcG9sbCksCj4gKwlWQ1BVX1NUQVQoImhhbHRfcG9sbF9p
bnZhbGlkIiwgaGFsdF9wb2xsX2ludmFsaWQpLAo+ICsJVkNQVV9TVEFUKCJoYWx0X3dha2V1cCIs
IGhhbHRfd2FrZXVwKSwKPiArCVZDUFVfU1RBVCgiaHZjX2V4aXRfc3RhdCIsIGh2Y19leGl0X3N0
YXQpLAo+ICsJVkNQVV9TVEFUKCJ3ZmVfZXhpdF9zdGF0Iiwgd2ZlX2V4aXRfc3RhdCksCj4gKwlW
Q1BVX1NUQVQoIndmaV9leGl0X3N0YXQiLCB3ZmlfZXhpdF9zdGF0KSwKPiArCVZDUFVfU1RBVCgi
bW1pb19leGl0X3VzZXIiLCBtbWlvX2V4aXRfdXNlciksCj4gKwlWQ1BVX1NUQVQoIm1taW9fZXhp
dF9rZXJuZWwiLCBtbWlvX2V4aXRfa2VybmVsKSwKPiArCVZDUFVfU1RBVCgiZXhpdHMiLCBleGl0
cyksCj4gIAl7IE5VTEwgfQo+ICB9OwoKUGF0Y2ggZWFzaWx5IHJldmlld2VkIHdpdGggLS13b3Jk
LWRpZmYuCgpbLi4uXQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9p
bmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPiBpbmRleCA2ZDU4YmViNjU0NTQuLjJlNmVhZDg3Mjk1
NyAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPiArKysgYi9pbmNsdWRl
L2xpbnV4L2t2bV9ob3N0LmgKPiBAQCAtMTEzMCw2ICsxMTMwLDExIEBAIHN0cnVjdCBrdm1fc3Rh
dHNfZGVidWdmc19pdGVtIHsKPiAgI2RlZmluZSBLVk1fREJHRlNfR0VUX01PREUoZGJnZnNfaXRl
bSkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKPiAgCSgoZGJnZnNf
aXRlbSktPm1vZGUgPyAoZGJnZnNfaXRlbSktPm1vZGUgOiAwNjQ0KQo+ICAKPiArI2RlZmluZSBW
TV9TVEFUKG4sIHgsIC4uLikgCQkJCQkJCQkJCQkJCSAgIFwKPiArCXsgbiwgb2Zmc2V0b2Yoc3Ry
dWN0IGt2bSwgc3RhdC54KSwgS1ZNX1NUQVRfVk0sICMjIF9fVkFfQVJHU19fIH0KPiArI2RlZmlu
ZSBWQ1BVX1NUQVQobiwgeCwgLi4uKQkJCQkJCQkJCQkJCSAgIFwKCk5vdCBzdXJlIHdoaWxlIHlv
dSB1c2Ugc28gbWFueSB3aGl0ZXNwYWNlcyBoZXJlLi4uIChtYXliZSBQYW9sbyBjYW4Kc3RyaXAg
c29tZSB3aGVuIGFwcGx5aW5nPykuCgpPdGhlcndpc2UgaXQgbG9va3MgbmljZXIgdGhhdCB2MSwg
dGhhbmtzLgoKUmV2aWV3ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxmNGJ1Z0BhbXNh
dC5vcmc+Cgo+ICsJeyBuLCBvZmZzZXRvZihzdHJ1Y3Qga3ZtX3ZjcHUsIHN0YXQueCksIEtWTV9T
VEFUX1ZDUFUsICMjIF9fVkFfQVJHU19fIH0KPiArCj4gIGV4dGVybiBzdHJ1Y3Qga3ZtX3N0YXRz
X2RlYnVnZnNfaXRlbSBkZWJ1Z2ZzX2VudHJpZXNbXTsKPiAgZXh0ZXJuIHN0cnVjdCBkZW50cnkg
Kmt2bV9kZWJ1Z2ZzX2RpcjsKPiAgCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
