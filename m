Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8847CC48BD1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 11:02:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 095BC613C8
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 11:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 095BC613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 786494B0BC;
	Fri, 11 Jun 2021 07:02:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rQsqBVO6VktN; Fri, 11 Jun 2021 07:02:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E7C54B0BD;
	Fri, 11 Jun 2021 07:02:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 415324B0BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 07:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jXLqcUtfoxvp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 07:02:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F124B0B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 07:02:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623409353;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+RrRblTQxTiQW11uEZwz6k6Rn04ho0Rc+4Nvx3QLrzo=;
 b=YOFA/w/5O72zRCZi6RzFFbA3EWX4oOchLsagub6WY5zV3sNlo+Rj3PeYBnWMvgA+2mbsQI
 moTIOSzDYR9UJdpcKa/3s772OqQ+LPqEh+R5c+qRE1lTvsapsVDVsQOZ5wV6DpiqAiag3B
 5PrxIaB8OCHBobd3XKz4hn+nqQBvlLA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-AYmMGzIJM1urc5Q34E4AEQ-1; Fri, 11 Jun 2021 07:02:31 -0400
X-MC-Unique: AYmMGzIJM1urc5Q34E4AEQ-1
Received: by mail-wr1-f69.google.com with SMTP id
 k25-20020a5d52590000b0290114dee5b660so2457869wrc.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 04:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+RrRblTQxTiQW11uEZwz6k6Rn04ho0Rc+4Nvx3QLrzo=;
 b=eIQdNQOlMt7VGor5ORNx+tJ8lxfaiNegRX2Jsd9nP7Oncz3QD8yhBssafUtA+z7yWx
 8F46uDVzy2h82/GIG4Y4KgcddBpSuIe7EY20g1p3NS6wKGSxlvwXK27q7w6KCtUy5wGV
 CVKsktyQ8DYoF4iEosQs8ziOKUkyEapU83PHdsflHNMkLbqjFHhdmzTmGgQX24JMaZ5k
 5YlSBaNozMhJA18mt1VzmLRZggdeIjqSsTj/5lh4zoJGw3RYGczuSDQ/zkrs94Jui6BM
 +S8oFck2Rlwe1RMnDolzYlEbBYJZyvTJKRF2Da9nGvrU11ICQNsX3tzF0GDSGpGr7MKf
 PTpQ==
X-Gm-Message-State: AOAM530WtOOe1BMkghuiNCX7gxtSl0RhiiUxn/GBth4dl6ewLHNCatVA
 8R8nnIybMN3ghTB+NFmcjvGizMuj29b4vJbubh7JkxI69jfc9ogoAM0M5HML/AFfHV9r3hK4Ym4
 rvV5bGegggv7kMd5LluAJtIcU
X-Received: by 2002:adf:fd90:: with SMTP id d16mr3381377wrr.35.1623409350603; 
 Fri, 11 Jun 2021 04:02:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSsd36dFENgYkdGQ54PSpUsoW2KwSiq8W+9CJYc+K0FgC3tbwdQbKFEEq0OpZ/4SfqgN/ULg==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr3381331wrr.35.1623409350364; 
 Fri, 11 Jun 2021 04:02:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m6sm7999909wrw.9.2021.06.11.04.02.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 04:02:29 -0700 (PDT)
Subject: Re: [PATCH v7 0/4] KVM statistics data fd-based binary interface
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <4b44c5a7-21c0-73c0-bb03-21806c83b4ae@de.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <db9722a0-8cfb-1bb4-a158-18efc29a1630@redhat.com>
Date: Fri, 11 Jun 2021 13:02:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4b44c5a7-21c0-73c0-bb03-21806c83b4ae@de.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

T24gMTEvMDYvMjEgMDg6NTcsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToKPiAKPiBPbiAw
My4wNi4yMSAyMzoxNCwgSmluZyBaaGFuZyB3cm90ZToKPj4gVGhpcyBwYXRjaHNldCBwcm92aWRl
cyBhIGZpbGUgZGVzY3JpcHRvciBmb3IgZXZlcnkgVk0gYW5kIFZDUFUgdG8gcmVhZAo+PiBLVk0g
c3RhdGlzdGljcyBkYXRhIGluIGJpbmFyeSBmb3JtYXQuCj4+IEl0IGlzIG1lYW50IHRvIHByb3Zp
ZGUgYSBsaWdodHdlaWdodCwgZmxleGlibGUsIHNjYWxhYmxlIGFuZCBlZmZpY2llbnQKPj4gbG9j
ay1mcmVlIHNvbHV0aW9uIGZvciB1c2VyIHNwYWNlIHRlbGVtZXRyeSBhcHBsaWNhdGlvbnMgdG8g
cHVsbCB0aGUKPj4gc3RhdGlzdGljcyBkYXRhIHBlcmlvZGljYWxseSBmb3IgbGFyZ2Ugc2NhbGUg
c3lzdGVtcy4gVGhlIHB1bGxpbmcKPj4gZnJlcXVlbmN5IGNvdWxkIGJlIGFzIGhpZ2ggYXMgYSBm
ZXcgdGltZXMgcGVyIHNlY29uZC4KPj4gSW4gdGhpcyBwYXRjaHNldCwgZXZlcnkgc3RhdGlzdGlj
cyBkYXRhIGFyZSB0cmVhdGVkIHRvIGhhdmUgc29tZQo+PiBhdHRyaWJ1dGVzIGFzIGJlbG93Ogo+
PiDCoMKgICogYXJjaGl0ZWN0dXJlIGRlcGVuZGVudCBvciBnZW5lcmljCj4+IMKgwqAgKiBWTSBz
dGF0aXN0aWNzIGRhdGEgb3IgVkNQVSBzdGF0aXN0aWNzIGRhdGEKPiAKPiBBcmUgdGhlIGRlYnVn
ZnMgdGhpbmdzIGdvb2QgZW5vdWdoLCBvciBkbyB3ZSB3YW50IHRvIGFsc28gYWRkIHRoZSBzYW1l
Cj4gaW9jdGwgZm9yIHRoZSAvZGV2L2t2bSB0byBnZXQgdGhlIGdsb2JhbCBjb3VudGVycyBhcyB3
ZWxsLCBlLmcuIGZvcgo+IHRvb2xzIGxpa2Uga3ZtX3N0YXQ/CgpJIHRoaW5rIHdlIHNob3VsZCwg
eWVzLiAgV2Ugc2hvdWxkIGFsc28gYWRkIHRoZSBzdW1tYXJpemVkIFZDUFUgCnN0YXRpc3RpY3Mg
dG8gdGhlIFZNLWxldmVsIGZpbGUgZGVzY3JpcHRvci4gIEhvd2V2ZXIsIGl0IGNhbiBiZSBkb25l
IGluIApzdGVwcy4KClBhb2xvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
