Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41544C433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BEE361432
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BEE361432
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E51B14B277;
	Mon, 10 May 2021 03:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q+NYMuYrLxzX; Mon, 10 May 2021 03:51:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC14F4B315;
	Mon, 10 May 2021 03:51:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A714B36A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 22:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vni7u3EOCvXW for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 May 2021 22:43:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EED524B369
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 22:43:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620614620;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mulqbmYCJzxkz4O6WDiZBqOQpSapir8tgrTEx7eXEf0=;
 b=Axa8yYLqG9hpbZairLIdSziPh7fOqHaoghp9oEcTCEZ3EaoVoVMMDToXDzTFShwA6omjK2
 N9i6+/uMdil5RtrYRqPFMJH7wB+S4y07Uqqv3LNRjefR7yWWRKbMIWQnLLzvAWeDOc911V
 tf7rwGp4CT8CnRvj5anbqfKJmm++dyg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-f_ksaRwxOgeaNCXaTL-WVw-1; Sun, 09 May 2021 22:43:39 -0400
X-MC-Unique: f_ksaRwxOgeaNCXaTL-WVw-1
Received: by mail-pj1-f71.google.com with SMTP id
 u13-20020a17090a3fcdb0290155c6507e67so10002864pjm.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 May 2021 19:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=mulqbmYCJzxkz4O6WDiZBqOQpSapir8tgrTEx7eXEf0=;
 b=OEj9UGWra6dc3N3E1zI07KjNt0aAp5AXUF/1GXur0C873PMjBCsjUA5/X3wopzp9oa
 GS/Ig+vMiT5Eaqdnscgf5rml5GK6CanVTlAwxRk+LTyTZD5+MU2Qew6/ZQHt7IjkacIn
 Y2fcjWRylnGjDKnGXSwFTzaUEfpCPC405RMbaKYP44+Elldxzh87tbcGjt+Xsv1oDJSK
 xV0nFmQB/ka+Yu2FnBhyHJ5bl+Lv5RcYGegm9xcQjQrCD8a3/0mFYkSOf2z7Gc7W77XE
 V1bltpoaB0RUKCu6pEgB6eKTET7Qpdc60T+JWnCk6445mZjYQbVVZ4QnIj+q9TODKBka
 rlhA==
X-Gm-Message-State: AOAM532T/U6B66WBiUJdYB7j0bWcCj5OOPnikhutPvOxCi42MuOMQcxK
 V26rE/5BlXK7vLsB9R5Yzk3rV/HLqW0WFLeTZhJ5KiETVL+fIHIPiH8XsmeSUh4jnBU6YKb4GkX
 0jnfEiCV0mHdWk1fZ4S0Q8dei
X-Received: by 2002:a17:90b:31cc:: with SMTP id
 jv12mr25766747pjb.33.1620614617982; 
 Sun, 09 May 2021 19:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybC1NO/4Q9cZqXH0xZRhpzh1PaT5pm26/xrlPVsxZSmPdWLQ9Q2jknen5avHzgs4cCcc2RFA==
X-Received: by 2002:a17:90b:31cc:: with SMTP id
 jv12mr25766727pjb.33.1620614617731; 
 Sun, 09 May 2021 19:43:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id c13sm11716971pjc.43.2021.05.09.19.43.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 09 May 2021 19:43:34 -0700 (PDT)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com, maz@kernel.org,
 alex.williamson@redhat.com
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
Date: Mon, 10 May 2021 10:43:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Mon, 10 May 2021 03:51:13 -0400
Cc: stable@vger.kernel.org, cohuck@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="gbk"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CtTaIDIwMjEvNS84IM/CzuczOjExLCBaaHUgTGluZ3NoYW4g0LS1wDoKPiBUaGlzIHJldmVydHMg
Y29tbWl0IGE5NzlhNmFhMDA5ZjNjOTk2ODk0MzJlMGNkYjU0MDJhNDQ2M2ZiODguCj4KPiBUaGUg
cmV2ZXJ0ZWQgY29tbWl0IG1heSBjYXVzZSBWTSBmcmVlemUgb24gYXJtNjQgcGxhdGZvcm0uCj4g
QmVjYXVzZSBvbiBhcm02NCBwbGF0Zm9ybSwgc3RvcCBhIGNvbnN1bWVyIHdpbGwgc3VzcGVuZCB0
aGUgVk0sCj4gdGhlIFZNIHdpbGwgZnJlZXplIHdpdGhvdXQgYSBzdGFydCBjb25zdW1lcgo+Cj4g
U2lnbmVkLW9mZi1ieTogWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPgoKCkFj
a2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgoKUGxlYXNlIHJlc3VibWl0
IHdpdGggdGhlIGZvcm1hbCBwcm9jZXNzIG9mIHN0YWJsZSAoc3RhYmxlLWtlcm5lbC1ydWxlcy5y
c3QpLgoKVGhhbmtzCgoKPiAtLS0KPiAgIHZpcnQvbGliL2lycWJ5cGFzcy5jIHwgMTYgKysrKysr
LS0tLS0tLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRp
b25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvdmlydC9saWIvaXJxYnlwYXNzLmMgYi92aXJ0L2xpYi9p
cnFieXBhc3MuYwo+IGluZGV4IGM5YmIzOTU3ZjU4YS4uMjhmZGE0MmU0NzFiIDEwMDY0NAo+IC0t
LSBhL3ZpcnQvbGliL2lycWJ5cGFzcy5jCj4gKysrIGIvdmlydC9saWIvaXJxYnlwYXNzLmMKPiBA
QCAtNDAsMjEgKzQwLDE3IEBAIHN0YXRpYyBpbnQgX19jb25uZWN0KHN0cnVjdCBpcnFfYnlwYXNz
X3Byb2R1Y2VyICpwcm9kLAo+ICAgCWlmIChwcm9kLT5hZGRfY29uc3VtZXIpCj4gICAJCXJldCA9
IHByb2QtPmFkZF9jb25zdW1lcihwcm9kLCBjb25zKTsKPiAgIAo+IC0JaWYgKHJldCkKPiAtCQln
b3RvIGVycl9hZGRfY29uc3VtZXI7Cj4gLQo+IC0JcmV0ID0gY29ucy0+YWRkX3Byb2R1Y2VyKGNv
bnMsIHByb2QpOwo+IC0JaWYgKHJldCkKPiAtCQlnb3RvIGVycl9hZGRfcHJvZHVjZXI7Cj4gKwlp
ZiAoIXJldCkgewo+ICsJCXJldCA9IGNvbnMtPmFkZF9wcm9kdWNlcihjb25zLCBwcm9kKTsKPiAr
CQlpZiAocmV0ICYmIHByb2QtPmRlbF9jb25zdW1lcikKPiArCQkJcHJvZC0+ZGVsX2NvbnN1bWVy
KHByb2QsIGNvbnMpOwo+ICsJfQo+ICAgCj4gICAJaWYgKGNvbnMtPnN0YXJ0KQo+ICAgCQljb25z
LT5zdGFydChjb25zKTsKPiAgIAlpZiAocHJvZC0+c3RhcnQpCj4gICAJCXByb2QtPnN0YXJ0KHBy
b2QpOwo+IC1lcnJfYWRkX3Byb2R1Y2VyOgo+IC0JaWYgKHByb2QtPmRlbF9jb25zdW1lcikKPiAt
CQlwcm9kLT5kZWxfY29uc3VtZXIocHJvZCwgY29ucyk7Cj4gLWVycl9hZGRfY29uc3VtZXI6Cj4g
Kwo+ICAgCXJldHVybiByZXQ7Cj4gICB9Cj4gICAKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
