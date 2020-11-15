Return-Path: <SRS0=kREJ=EV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D47C2D0E4
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 15:03:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72A3722409
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 15:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SaLCLg6h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72A3722409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE324BD3A;
	Sun, 15 Nov 2020 10:03:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m-Z-RT0+HQQL; Sun, 15 Nov 2020 10:03:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCC94BD1B;
	Sun, 15 Nov 2020 10:03:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 069694BD1B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 10:03:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mg2mF2+fjDTb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Nov 2020 10:03:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 327964BD17
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 10:03:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605452588;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9ZNerx0NuasBF/VoD3sPh+wO1jzxvpgrEpggJesm+1A=;
 b=SaLCLg6hU7eCbZypOwhRX+pa3kTQXNSHkREIPzscNNigSMWAYFN4rId1dk161hYGlcVY/K
 XNwlIBp4sx4RLJf7jeVPGCNjJ5oaKDP2+9LWWGiAGsoJhJjyeQ4C5nMv32JEuCxjKIa2YP
 XJasbnqe8CbfUz/aZnyQFVNdo3erHQQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Sk54xxbLNHWmJpSFjnZZFQ-1; Sun, 15 Nov 2020 10:03:06 -0500
X-MC-Unique: Sk54xxbLNHWmJpSFjnZZFQ-1
Received: by mail-wr1-f70.google.com with SMTP id h13so3872354wrr.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 07:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9ZNerx0NuasBF/VoD3sPh+wO1jzxvpgrEpggJesm+1A=;
 b=mwbo8vzLYtzqE44si1uhysqsf26R9lF2QcKg3lYPzYjacaibyV2NYMwLY9YJ4T6+98
 g7e/t69kTePi5CijXTn90Px2l2YjBCYrVPT2o5ChSRNrj0YbPHARbjKTHlPk521l3mqT
 5HCPRDJUSxHdtdJBgEH+Rcxprb02V/4X5NAFmNwKKTsruG4jJCC8Gg8+qliE/nvSdrTM
 Q4t8V+A3QNXgZZRoTrQWTX8OKisaprtog3/Aj6lwO+SrMCIWUxhd/x/9YyTAv3HfmJuT
 S518N/BMC73MFQptP7DkiUFY6S5MFutuNY9FtYLTK6dOtPrggbGufip+x2eZCwYyGY+L
 utHQ==
X-Gm-Message-State: AOAM530UN3VJ8qx/iOrOIbQtgJUumT3AHoGcQ6+YqKutYBlR9YjdPTqz
 TRJAB6adxTbHmA/na+DGYYT/VVrw5z9YWufqji2+oaes9bkH9uDWvg0IMc/JMD7e7h5KDfFZcve
 zdYpOBsIMlQk63a4mNmJl4yJ/
X-Received: by 2002:a1c:23cf:: with SMTP id j198mr11103041wmj.6.1605452584948; 
 Sun, 15 Nov 2020 07:03:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKaU+OOSUTFi1TX0E4onGfSoazqyVlZ4WyTDQncgt3CQLJ7gesHe1pcj3/63/eT9hmRNwncA==
X-Received: by 2002:a1c:23cf:: with SMTP id j198mr11103026wmj.6.1605452584773; 
 Sun, 15 Nov 2020 07:03:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id f23sm15924999wmb.43.2020.11.15.07.03.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 15 Nov 2020 07:03:03 -0800 (PST)
Subject: Re: [RFC] vfio-pci/migration: Dirty logging of the Memory BAR region?
To: Zenghui Yu <yuzenghui@huawei.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
References: <fd18627a-e012-1af8-9d9f-9ae8a1415258@huawei.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2825e816-9ade-07f9-19e3-ccfd57ffb568@redhat.com>
Date: Sun, 15 Nov 2020 16:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <fd18627a-e012-1af8-9d9f-9ae8a1415258@huawei.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>,
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
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTUvMTEvMjAgMTU6MzEsIFplbmdodWkgWXUgd3JvdGU6Cj4gZGlmZiAtLWdpdCBhL3NvZnRt
bXUvbWVtb3J5LmMgYi9zb2Z0bW11L21lbW9yeS5jCj4gaW5kZXggNzE5NTFmZTRkYy4uMDk1OGRi
MWEwOCAxMDA2NDQKPiAtLS0gYS9zb2Z0bW11L21lbW9yeS5jCj4gKysrIGIvc29mdG1tdS9tZW1v
cnkuYwo+IEBAIC0xODA2LDcgKzE4MDYsMTAgQEAgYm9vbCBtZW1vcnlfcmVnaW9uX2lzX3JhbV9k
ZXZpY2UoTWVtb3J5UmVnaW9uICptcikKPiAgwqB1aW50OF90IG1lbW9yeV9yZWdpb25fZ2V0X2Rp
cnR5X2xvZ19tYXNrKE1lbW9yeVJlZ2lvbiAqbXIpCj4gIMKgewo+ICDCoMKgwqDCoCB1aW50OF90
IG1hc2sgPSBtci0+ZGlydHlfbG9nX21hc2s7Cj4gLcKgwqDCoCBpZiAoZ2xvYmFsX2RpcnR5X2xv
ZyAmJiAobXItPnJhbV9ibG9jayB8fCAKPiBtZW1vcnlfcmVnaW9uX2lzX2lvbW11KG1yKSkpIHsK
PiArwqDCoMKgIFJBTUJsb2NrICpyYiA9IG1yLT5yYW1fYmxvY2s7Cj4gKwo+ICvCoMKgwqAgaWYg
KGdsb2JhbF9kaXJ0eV9sb2cgJiYgKChyYiAmJiBxZW11X3JhbV9pc19taWdyYXRhYmxlKHJiKSkg
fHwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbWVtb3J5X3JlZ2lvbl9pc19pb21tdShtcikpKSB7Cj4gIMKgwqDCoMKgwqDCoMKgwqAg
bWFzayB8PSAoMSA8PCBESVJUWV9NRU1PUllfTUlHUkFUSU9OKTsKPiAgwqDCoMKgwqAgfQo+ICDC
oMKgwqDCoCByZXR1cm4gbWFzazsKClllcywgdGhpcyBtYWtlcyBzZW5zZS4gIFBsZWFzZSBzZW5k
IGl0IGFzIGEgcGF0Y2gsIHRoYW5rcyEKClBhb2xvCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
